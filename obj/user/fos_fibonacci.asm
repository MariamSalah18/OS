
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1c 80 00       	push   $0x801cc0
  800057:	e8 07 0a 00 00       	call   800a63 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 59 0e 00 00       	call   800ecb <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 de 1c 80 00       	push   $0x801cde
  800097:	e8 74 02 00 00       	call   800310 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e7:	e8 70 15 00 00       	call   80165c <sys_getenvindex>
  8000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	01 c0                	add    %eax,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	c1 e0 06             	shl    $0x6,%eax
  8000fb:	29 d0                	sub    %edx,%eax
  8000fd:	c1 e0 03             	shl    $0x3,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010a:	a1 20 30 80 00       	mov    0x803020,%eax
  80010f:	8a 40 68             	mov    0x68(%eax),%al
  800112:	84 c0                	test   %al,%al
  800114:	74 0d                	je     800123 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	83 c0 68             	add    $0x68,%eax
  80011e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800123:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800127:	7e 0a                	jle    800133 <libmain+0x52>
		binaryname = argv[0];
  800129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012c:	8b 00                	mov    (%eax),%eax
  80012e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	ff 75 0c             	pushl  0xc(%ebp)
  800139:	ff 75 08             	pushl  0x8(%ebp)
  80013c:	e8 f7 fe ff ff       	call   800038 <_main>
  800141:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800144:	e8 20 13 00 00       	call   801469 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	68 0c 1d 80 00       	push   $0x801d0c
  800151:	e8 8d 01 00 00       	call   8002e3 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800159:	a1 20 30 80 00       	mov    0x803020,%eax
  80015e:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  80016f:	83 ec 04             	sub    $0x4,%esp
  800172:	52                   	push   %edx
  800173:	50                   	push   %eax
  800174:	68 34 1d 80 00       	push   $0x801d34
  800179:	e8 65 01 00 00       	call   8002e3 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800181:	a1 20 30 80 00       	mov    0x803020,%eax
  800186:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800197:	a1 20 30 80 00       	mov    0x803020,%eax
  80019c:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  8001a2:	51                   	push   %ecx
  8001a3:	52                   	push   %edx
  8001a4:	50                   	push   %eax
  8001a5:	68 5c 1d 80 00       	push   $0x801d5c
  8001aa:	e8 34 01 00 00       	call   8002e3 <cprintf>
  8001af:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	50                   	push   %eax
  8001c1:	68 b4 1d 80 00       	push   $0x801db4
  8001c6:	e8 18 01 00 00       	call   8002e3 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 0c 1d 80 00       	push   $0x801d0c
  8001d6:	e8 08 01 00 00       	call   8002e3 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001de:	e8 a0 12 00 00       	call   801483 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001e3:	e8 19 00 00 00       	call   800201 <exit>
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	6a 00                	push   $0x0
  8001f6:	e8 2d 14 00 00       	call   801628 <sys_destroy_env>
  8001fb:	83 c4 10             	add    $0x10,%esp
}
  8001fe:	90                   	nop
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <exit>:

void
exit(void)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800207:	e8 82 14 00 00       	call   80168e <sys_exit_env>
}
  80020c:	90                   	nop
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800215:	8b 45 0c             	mov    0xc(%ebp),%eax
  800218:	8b 00                	mov    (%eax),%eax
  80021a:	8d 48 01             	lea    0x1(%eax),%ecx
  80021d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800220:	89 0a                	mov    %ecx,(%edx)
  800222:	8b 55 08             	mov    0x8(%ebp),%edx
  800225:	88 d1                	mov    %dl,%cl
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800231:	8b 00                	mov    (%eax),%eax
  800233:	3d ff 00 00 00       	cmp    $0xff,%eax
  800238:	75 2c                	jne    800266 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80023a:	a0 24 30 80 00       	mov    0x803024,%al
  80023f:	0f b6 c0             	movzbl %al,%eax
  800242:	8b 55 0c             	mov    0xc(%ebp),%edx
  800245:	8b 12                	mov    (%edx),%edx
  800247:	89 d1                	mov    %edx,%ecx
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	83 c2 08             	add    $0x8,%edx
  80024f:	83 ec 04             	sub    $0x4,%esp
  800252:	50                   	push   %eax
  800253:	51                   	push   %ecx
  800254:	52                   	push   %edx
  800255:	e8 b6 10 00 00       	call   801310 <sys_cputs>
  80025a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
  800269:	8b 40 04             	mov    0x4(%eax),%eax
  80026c:	8d 50 01             	lea    0x1(%eax),%edx
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	89 50 04             	mov    %edx,0x4(%eax)
}
  800275:	90                   	nop
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800281:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800288:	00 00 00 
	b.cnt = 0;
  80028b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800292:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a1:	50                   	push   %eax
  8002a2:	68 0f 02 80 00       	push   $0x80020f
  8002a7:	e8 11 02 00 00       	call   8004bd <vprintfmt>
  8002ac:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002af:	a0 24 30 80 00       	mov    0x803024,%al
  8002b4:	0f b6 c0             	movzbl %al,%eax
  8002b7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	50                   	push   %eax
  8002c1:	52                   	push   %edx
  8002c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c8:	83 c0 08             	add    $0x8,%eax
  8002cb:	50                   	push   %eax
  8002cc:	e8 3f 10 00 00       	call   801310 <sys_cputs>
  8002d1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d4:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e9:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	83 ec 08             	sub    $0x8,%esp
  8002fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ff:	50                   	push   %eax
  800300:	e8 73 ff ff ff       	call   800278 <vcprintf>
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800316:	e8 4e 11 00 00       	call   801469 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80031b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	ff 75 f4             	pushl  -0xc(%ebp)
  80032a:	50                   	push   %eax
  80032b:	e8 48 ff ff ff       	call   800278 <vcprintf>
  800330:	83 c4 10             	add    $0x10,%esp
  800333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800336:	e8 48 11 00 00       	call   801483 <sys_enable_interrupt>
	return cnt;
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	53                   	push   %ebx
  800344:	83 ec 14             	sub    $0x14,%esp
  800347:	8b 45 10             	mov    0x10(%ebp),%eax
  80034a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80034d:	8b 45 14             	mov    0x14(%ebp),%eax
  800350:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800353:	8b 45 18             	mov    0x18(%ebp),%eax
  800356:	ba 00 00 00 00       	mov    $0x0,%edx
  80035b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035e:	77 55                	ja     8003b5 <printnum+0x75>
  800360:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800363:	72 05                	jb     80036a <printnum+0x2a>
  800365:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800368:	77 4b                	ja     8003b5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80036d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800370:	8b 45 18             	mov    0x18(%ebp),%eax
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	52                   	push   %edx
  800379:	50                   	push   %eax
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 f0             	pushl  -0x10(%ebp)
  800380:	e8 cf 16 00 00       	call   801a54 <__udivdi3>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	83 ec 04             	sub    $0x4,%esp
  80038b:	ff 75 20             	pushl  0x20(%ebp)
  80038e:	53                   	push   %ebx
  80038f:	ff 75 18             	pushl  0x18(%ebp)
  800392:	52                   	push   %edx
  800393:	50                   	push   %eax
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	e8 a1 ff ff ff       	call   800340 <printnum>
  80039f:	83 c4 20             	add    $0x20,%esp
  8003a2:	eb 1a                	jmp    8003be <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	ff 75 0c             	pushl  0xc(%ebp)
  8003aa:	ff 75 20             	pushl  0x20(%ebp)
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	ff d0                	call   *%eax
  8003b2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b5:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003bc:	7f e6                	jg     8003a4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003be:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cc:	53                   	push   %ebx
  8003cd:	51                   	push   %ecx
  8003ce:	52                   	push   %edx
  8003cf:	50                   	push   %eax
  8003d0:	e8 8f 17 00 00       	call   801b64 <__umoddi3>
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  8003dd:	8a 00                	mov    (%eax),%al
  8003df:	0f be c0             	movsbl %al,%eax
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	ff 75 0c             	pushl  0xc(%ebp)
  8003e8:	50                   	push   %eax
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	ff d0                	call   *%eax
  8003ee:	83 c4 10             	add    $0x10,%esp
}
  8003f1:	90                   	nop
  8003f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003fe:	7e 1c                	jle    80041c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	8d 50 08             	lea    0x8(%eax),%edx
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	89 10                	mov    %edx,(%eax)
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	83 e8 08             	sub    $0x8,%eax
  800415:	8b 50 04             	mov    0x4(%eax),%edx
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	eb 40                	jmp    80045c <getuint+0x65>
	else if (lflag)
  80041c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800420:	74 1e                	je     800440 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	8d 50 04             	lea    0x4(%eax),%edx
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	89 10                	mov    %edx,(%eax)
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	83 e8 04             	sub    $0x4,%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	ba 00 00 00 00       	mov    $0x0,%edx
  80043e:	eb 1c                	jmp    80045c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	8d 50 04             	lea    0x4(%eax),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 10                	mov    %edx,(%eax)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	83 e8 04             	sub    $0x4,%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    

0080045e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800461:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800465:	7e 1c                	jle    800483 <getint+0x25>
		return va_arg(*ap, long long);
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	8d 50 08             	lea    0x8(%eax),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	89 10                	mov    %edx,(%eax)
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	83 e8 08             	sub    $0x8,%eax
  80047c:	8b 50 04             	mov    0x4(%eax),%edx
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	eb 38                	jmp    8004bb <getint+0x5d>
	else if (lflag)
  800483:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800487:	74 1a                	je     8004a3 <getint+0x45>
		return va_arg(*ap, long);
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	8d 50 04             	lea    0x4(%eax),%edx
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	89 10                	mov    %edx,(%eax)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	83 e8 04             	sub    $0x4,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	99                   	cltd   
  8004a1:	eb 18                	jmp    8004bb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 50 04             	lea    0x4(%eax),%edx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	89 10                	mov    %edx,(%eax)
  8004b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	83 e8 04             	sub    $0x4,%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	99                   	cltd   
}
  8004bb:	5d                   	pop    %ebp
  8004bc:	c3                   	ret    

008004bd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c5:	eb 17                	jmp    8004de <vprintfmt+0x21>
			if (ch == '\0')
  8004c7:	85 db                	test   %ebx,%ebx
  8004c9:	0f 84 af 03 00 00    	je     80087e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	53                   	push   %ebx
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	ff d0                	call   *%eax
  8004db:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004de:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e1:	8d 50 01             	lea    0x1(%eax),%edx
  8004e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e7:	8a 00                	mov    (%eax),%al
  8004e9:	0f b6 d8             	movzbl %al,%ebx
  8004ec:	83 fb 25             	cmp    $0x25,%ebx
  8004ef:	75 d6                	jne    8004c7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004f5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800503:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80050a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	8d 50 01             	lea    0x1(%eax),%edx
  800517:	89 55 10             	mov    %edx,0x10(%ebp)
  80051a:	8a 00                	mov    (%eax),%al
  80051c:	0f b6 d8             	movzbl %al,%ebx
  80051f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800522:	83 f8 55             	cmp    $0x55,%eax
  800525:	0f 87 2b 03 00 00    	ja     800856 <vprintfmt+0x399>
  80052b:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  800532:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800534:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800538:	eb d7                	jmp    800511 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80053e:	eb d1                	jmp    800511 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800540:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800547:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054a:	89 d0                	mov    %edx,%eax
  80054c:	c1 e0 02             	shl    $0x2,%eax
  80054f:	01 d0                	add    %edx,%eax
  800551:	01 c0                	add    %eax,%eax
  800553:	01 d8                	add    %ebx,%eax
  800555:	83 e8 30             	sub    $0x30,%eax
  800558:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80055b:	8b 45 10             	mov    0x10(%ebp),%eax
  80055e:	8a 00                	mov    (%eax),%al
  800560:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800563:	83 fb 2f             	cmp    $0x2f,%ebx
  800566:	7e 3e                	jle    8005a6 <vprintfmt+0xe9>
  800568:	83 fb 39             	cmp    $0x39,%ebx
  80056b:	7f 39                	jg     8005a6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800570:	eb d5                	jmp    800547 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	83 c0 04             	add    $0x4,%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 e8 04             	sub    $0x4,%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800586:	eb 1f                	jmp    8005a7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800588:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058c:	79 83                	jns    800511 <vprintfmt+0x54>
				width = 0;
  80058e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800595:	e9 77 ff ff ff       	jmp    800511 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80059a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a1:	e9 6b ff ff ff       	jmp    800511 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ab:	0f 89 60 ff ff ff    	jns    800511 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005be:	e9 4e ff ff ff       	jmp    800511 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c6:	e9 46 ff ff ff       	jmp    800511 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 c0 04             	add    $0x4,%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	ff 75 0c             	pushl  0xc(%ebp)
  8005e2:	50                   	push   %eax
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	ff d0                	call   *%eax
  8005e8:	83 c4 10             	add    $0x10,%esp
			break;
  8005eb:	e9 89 02 00 00       	jmp    800879 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	83 c0 04             	add    $0x4,%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	83 e8 04             	sub    $0x4,%eax
  8005ff:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800601:	85 db                	test   %ebx,%ebx
  800603:	79 02                	jns    800607 <vprintfmt+0x14a>
				err = -err;
  800605:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800607:	83 fb 64             	cmp    $0x64,%ebx
  80060a:	7f 0b                	jg     800617 <vprintfmt+0x15a>
  80060c:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  800613:	85 f6                	test   %esi,%esi
  800615:	75 19                	jne    800630 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800617:	53                   	push   %ebx
  800618:	68 05 20 80 00       	push   $0x802005
  80061d:	ff 75 0c             	pushl  0xc(%ebp)
  800620:	ff 75 08             	pushl  0x8(%ebp)
  800623:	e8 5e 02 00 00       	call   800886 <printfmt>
  800628:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80062b:	e9 49 02 00 00       	jmp    800879 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800630:	56                   	push   %esi
  800631:	68 0e 20 80 00       	push   $0x80200e
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 45 02 00 00       	call   800886 <printfmt>
  800641:	83 c4 10             	add    $0x10,%esp
			break;
  800644:	e9 30 02 00 00       	jmp    800879 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	83 c0 04             	add    $0x4,%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	83 e8 04             	sub    $0x4,%eax
  800658:	8b 30                	mov    (%eax),%esi
  80065a:	85 f6                	test   %esi,%esi
  80065c:	75 05                	jne    800663 <vprintfmt+0x1a6>
				p = "(null)";
  80065e:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  800663:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800667:	7e 6d                	jle    8006d6 <vprintfmt+0x219>
  800669:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80066d:	74 67                	je     8006d6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80066f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	50                   	push   %eax
  800676:	56                   	push   %esi
  800677:	e8 12 05 00 00       	call   800b8e <strnlen>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800682:	eb 16                	jmp    80069a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800684:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	50                   	push   %eax
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	ff d0                	call   *%eax
  800694:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	ff 4d e4             	decl   -0x1c(%ebp)
  80069a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069e:	7f e4                	jg     800684 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a0:	eb 34                	jmp    8006d6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a6:	74 1c                	je     8006c4 <vprintfmt+0x207>
  8006a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ab:	7e 05                	jle    8006b2 <vprintfmt+0x1f5>
  8006ad:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b0:	7e 12                	jle    8006c4 <vprintfmt+0x207>
					putch('?', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	6a 3f                	push   $0x3f
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb 0f                	jmp    8006d3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	53                   	push   %ebx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	ff d0                	call   *%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d3:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d6:	89 f0                	mov    %esi,%eax
  8006d8:	8d 70 01             	lea    0x1(%eax),%esi
  8006db:	8a 00                	mov    (%eax),%al
  8006dd:	0f be d8             	movsbl %al,%ebx
  8006e0:	85 db                	test   %ebx,%ebx
  8006e2:	74 24                	je     800708 <vprintfmt+0x24b>
  8006e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e8:	78 b8                	js     8006a2 <vprintfmt+0x1e5>
  8006ea:	ff 4d e0             	decl   -0x20(%ebp)
  8006ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f1:	79 af                	jns    8006a2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f3:	eb 13                	jmp    800708 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	6a 20                	push   $0x20
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7f e7                	jg     8006f5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80070e:	e9 66 01 00 00       	jmp    800879 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 e8             	pushl  -0x18(%ebp)
  800719:	8d 45 14             	lea    0x14(%ebp),%eax
  80071c:	50                   	push   %eax
  80071d:	e8 3c fd ff ff       	call   80045e <getint>
  800722:	83 c4 10             	add    $0x10,%esp
  800725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800728:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80072b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800731:	85 d2                	test   %edx,%edx
  800733:	79 23                	jns    800758 <vprintfmt+0x29b>
				putch('-', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	6a 2d                	push   $0x2d
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074b:	f7 d8                	neg    %eax
  80074d:	83 d2 00             	adc    $0x0,%edx
  800750:	f7 da                	neg    %edx
  800752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800755:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800758:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075f:	e9 bc 00 00 00       	jmp    800820 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 e8             	pushl  -0x18(%ebp)
  80076a:	8d 45 14             	lea    0x14(%ebp),%eax
  80076d:	50                   	push   %eax
  80076e:	e8 84 fc ff ff       	call   8003f7 <getuint>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800779:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80077c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800783:	e9 98 00 00 00       	jmp    800820 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	6a 58                	push   $0x58
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	6a 58                	push   $0x58
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	ff d0                	call   *%eax
  8007a5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	6a 58                	push   $0x58
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	ff d0                	call   *%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
			break;
  8007b8:	e9 bc 00 00 00       	jmp    800879 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	6a 30                	push   $0x30
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 78                	push   $0x78
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	83 c0 04             	add    $0x4,%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	83 e8 04             	sub    $0x4,%eax
  8007ec:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ff:	eb 1f                	jmp    800820 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 e8             	pushl  -0x18(%ebp)
  800807:	8d 45 14             	lea    0x14(%ebp),%eax
  80080a:	50                   	push   %eax
  80080b:	e8 e7 fb ff ff       	call   8003f7 <getuint>
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800816:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800819:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800820:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800827:	83 ec 04             	sub    $0x4,%esp
  80082a:	52                   	push   %edx
  80082b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80082e:	50                   	push   %eax
  80082f:	ff 75 f4             	pushl  -0xc(%ebp)
  800832:	ff 75 f0             	pushl  -0x10(%ebp)
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 00 fb ff ff       	call   800340 <printnum>
  800840:	83 c4 20             	add    $0x20,%esp
			break;
  800843:	eb 34                	jmp    800879 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	53                   	push   %ebx
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
			break;
  800854:	eb 23                	jmp    800879 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 25                	push   $0x25
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800866:	ff 4d 10             	decl   0x10(%ebp)
  800869:	eb 03                	jmp    80086e <vprintfmt+0x3b1>
  80086b:	ff 4d 10             	decl   0x10(%ebp)
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
  800871:	48                   	dec    %eax
  800872:	8a 00                	mov    (%eax),%al
  800874:	3c 25                	cmp    $0x25,%al
  800876:	75 f3                	jne    80086b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800878:	90                   	nop
		}
	}
  800879:	e9 47 fc ff ff       	jmp    8004c5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80087e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80087f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800882:	5b                   	pop    %ebx
  800883:	5e                   	pop    %esi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80088c:	8d 45 10             	lea    0x10(%ebp),%eax
  80088f:	83 c0 04             	add    $0x4,%eax
  800892:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800895:	8b 45 10             	mov    0x10(%ebp),%eax
  800898:	ff 75 f4             	pushl  -0xc(%ebp)
  80089b:	50                   	push   %eax
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	ff 75 08             	pushl  0x8(%ebp)
  8008a2:	e8 16 fc ff ff       	call   8004bd <vprintfmt>
  8008a7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008aa:	90                   	nop
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	8b 40 08             	mov    0x8(%eax),%eax
  8008b6:	8d 50 01             	lea    0x1(%eax),%edx
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	8b 10                	mov    (%eax),%edx
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	8b 40 04             	mov    0x4(%eax),%eax
  8008ca:	39 c2                	cmp    %eax,%edx
  8008cc:	73 12                	jae    8008e0 <sprintputch+0x33>
		*b->buf++ = ch;
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d9:	89 0a                	mov    %ecx,(%edx)
  8008db:	8b 55 08             	mov    0x8(%ebp),%edx
  8008de:	88 10                	mov    %dl,(%eax)
}
  8008e0:	90                   	nop
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800904:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800908:	74 06                	je     800910 <vsnprintf+0x2d>
  80090a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090e:	7f 07                	jg     800917 <vsnprintf+0x34>
		return -E_INVAL;
  800910:	b8 03 00 00 00       	mov    $0x3,%eax
  800915:	eb 20                	jmp    800937 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800917:	ff 75 14             	pushl  0x14(%ebp)
  80091a:	ff 75 10             	pushl  0x10(%ebp)
  80091d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800920:	50                   	push   %eax
  800921:	68 ad 08 80 00       	push   $0x8008ad
  800926:	e8 92 fb ff ff       	call   8004bd <vprintfmt>
  80092b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80092e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800931:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800934:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093f:	8d 45 10             	lea    0x10(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	ff 75 f4             	pushl  -0xc(%ebp)
  80094e:	50                   	push   %eax
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 89 ff ff ff       	call   8008e3 <vsnprintf>
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800960:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80096b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096f:	74 13                	je     800984 <readline+0x1f>
		cprintf("%s", prompt);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	68 70 21 80 00       	push   $0x802170
  80097c:	e8 62 f9 ff ff       	call   8002e3 <cprintf>
  800981:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800984:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80098b:	83 ec 0c             	sub    $0xc,%esp
  80098e:	6a 00                	push   $0x0
  800990:	e8 b4 10 00 00       	call   801a49 <iscons>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80099b:	e8 5b 10 00 00       	call   8019fb <getchar>
  8009a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009a7:	79 22                	jns    8009cb <readline+0x66>
			if (c != -E_EOF)
  8009a9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009ad:	0f 84 ad 00 00 00    	je     800a60 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8009b9:	68 73 21 80 00       	push   $0x802173
  8009be:	e8 20 f9 ff ff       	call   8002e3 <cprintf>
  8009c3:	83 c4 10             	add    $0x10,%esp
			return;
  8009c6:	e9 95 00 00 00       	jmp    800a60 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009cb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009cf:	7e 34                	jle    800a05 <readline+0xa0>
  8009d1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009d8:	7f 2b                	jg     800a05 <readline+0xa0>
			if (echoing)
  8009da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009de:	74 0e                	je     8009ee <readline+0x89>
				cputchar(c);
  8009e0:	83 ec 0c             	sub    $0xc,%esp
  8009e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e6:	e8 c8 0f 00 00       	call   8019b3 <cputchar>
  8009eb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f1:	8d 50 01             	lea    0x1(%eax),%edx
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a01:	88 10                	mov    %dl,(%eax)
  800a03:	eb 56                	jmp    800a5b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a05:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a09:	75 1f                	jne    800a2a <readline+0xc5>
  800a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a0f:	7e 19                	jle    800a2a <readline+0xc5>
			if (echoing)
  800a11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a15:	74 0e                	je     800a25 <readline+0xc0>
				cputchar(c);
  800a17:	83 ec 0c             	sub    $0xc,%esp
  800a1a:	ff 75 ec             	pushl  -0x14(%ebp)
  800a1d:	e8 91 0f 00 00       	call   8019b3 <cputchar>
  800a22:	83 c4 10             	add    $0x10,%esp

			i--;
  800a25:	ff 4d f4             	decl   -0xc(%ebp)
  800a28:	eb 31                	jmp    800a5b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a2a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a2e:	74 0a                	je     800a3a <readline+0xd5>
  800a30:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a34:	0f 85 61 ff ff ff    	jne    80099b <readline+0x36>
			if (echoing)
  800a3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a3e:	74 0e                	je     800a4e <readline+0xe9>
				cputchar(c);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff 75 ec             	pushl  -0x14(%ebp)
  800a46:	e8 68 0f 00 00       	call   8019b3 <cputchar>
  800a4b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	01 d0                	add    %edx,%eax
  800a56:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a59:	eb 06                	jmp    800a61 <readline+0xfc>
		}
	}
  800a5b:	e9 3b ff ff ff       	jmp    80099b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a60:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a69:	e8 fb 09 00 00       	call   801469 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a72:	74 13                	je     800a87 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 08             	pushl  0x8(%ebp)
  800a7a:	68 70 21 80 00       	push   $0x802170
  800a7f:	e8 5f f8 ff ff       	call   8002e3 <cprintf>
  800a84:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a8e:	83 ec 0c             	sub    $0xc,%esp
  800a91:	6a 00                	push   $0x0
  800a93:	e8 b1 0f 00 00       	call   801a49 <iscons>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a9e:	e8 58 0f 00 00       	call   8019fb <getchar>
  800aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aaa:	79 23                	jns    800acf <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aac:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab0:	74 13                	je     800ac5 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab8:	68 73 21 80 00       	push   $0x802173
  800abd:	e8 21 f8 ff ff       	call   8002e3 <cprintf>
  800ac2:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ac5:	e8 b9 09 00 00       	call   801483 <sys_enable_interrupt>
			return;
  800aca:	e9 9a 00 00 00       	jmp    800b69 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800acf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad3:	7e 34                	jle    800b09 <atomic_readline+0xa6>
  800ad5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800adc:	7f 2b                	jg     800b09 <atomic_readline+0xa6>
			if (echoing)
  800ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ae2:	74 0e                	je     800af2 <atomic_readline+0x8f>
				cputchar(c);
  800ae4:	83 ec 0c             	sub    $0xc,%esp
  800ae7:	ff 75 ec             	pushl  -0x14(%ebp)
  800aea:	e8 c4 0e 00 00       	call   8019b3 <cputchar>
  800aef:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af5:	8d 50 01             	lea    0x1(%eax),%edx
  800af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	01 d0                	add    %edx,%eax
  800b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b05:	88 10                	mov    %dl,(%eax)
  800b07:	eb 5b                	jmp    800b64 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b09:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b0d:	75 1f                	jne    800b2e <atomic_readline+0xcb>
  800b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b13:	7e 19                	jle    800b2e <atomic_readline+0xcb>
			if (echoing)
  800b15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b19:	74 0e                	je     800b29 <atomic_readline+0xc6>
				cputchar(c);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b21:	e8 8d 0e 00 00       	call   8019b3 <cputchar>
  800b26:	83 c4 10             	add    $0x10,%esp
			i--;
  800b29:	ff 4d f4             	decl   -0xc(%ebp)
  800b2c:	eb 36                	jmp    800b64 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b2e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b32:	74 0a                	je     800b3e <atomic_readline+0xdb>
  800b34:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b38:	0f 85 60 ff ff ff    	jne    800a9e <atomic_readline+0x3b>
			if (echoing)
  800b3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b42:	74 0e                	je     800b52 <atomic_readline+0xef>
				cputchar(c);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4a:	e8 64 0e 00 00       	call   8019b3 <cputchar>
  800b4f:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
  800b5a:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b5d:	e8 21 09 00 00       	call   801483 <sys_enable_interrupt>
			return;
  800b62:	eb 05                	jmp    800b69 <atomic_readline+0x106>
		}
	}
  800b64:	e9 35 ff ff ff       	jmp    800a9e <atomic_readline+0x3b>
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b78:	eb 06                	jmp    800b80 <strlen+0x15>
		n++;
  800b7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7d:	ff 45 08             	incl   0x8(%ebp)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8a 00                	mov    (%eax),%al
  800b85:	84 c0                	test   %al,%al
  800b87:	75 f1                	jne    800b7a <strlen+0xf>
		n++;
	return n;
  800b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9b:	eb 09                	jmp    800ba6 <strnlen+0x18>
		n++;
  800b9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba0:	ff 45 08             	incl   0x8(%ebp)
  800ba3:	ff 4d 0c             	decl   0xc(%ebp)
  800ba6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800baa:	74 09                	je     800bb5 <strnlen+0x27>
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8a 00                	mov    (%eax),%al
  800bb1:	84 c0                	test   %al,%al
  800bb3:	75 e8                	jne    800b9d <strnlen+0xf>
		n++;
	return n;
  800bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bc6:	90                   	nop
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8d 50 01             	lea    0x1(%eax),%edx
  800bcd:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd9:	8a 12                	mov    (%edx),%dl
  800bdb:	88 10                	mov    %dl,(%eax)
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 e4                	jne    800bc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfb:	eb 1f                	jmp    800c1c <strncpy+0x34>
		*dst++ = *src;
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 08             	mov    %edx,0x8(%ebp)
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	8a 12                	mov    (%edx),%dl
  800c0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	84 c0                	test   %al,%al
  800c14:	74 03                	je     800c19 <strncpy+0x31>
			src++;
  800c16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c19:	ff 45 fc             	incl   -0x4(%ebp)
  800c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c22:	72 d9                	jb     800bfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c39:	74 30                	je     800c6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c3b:	eb 16                	jmp    800c53 <strlcpy+0x2a>
			*dst++ = *src++;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8d 50 01             	lea    0x1(%eax),%edx
  800c43:	89 55 08             	mov    %edx,0x8(%ebp)
  800c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c4f:	8a 12                	mov    (%edx),%dl
  800c51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c53:	ff 4d 10             	decl   0x10(%ebp)
  800c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5a:	74 09                	je     800c65 <strlcpy+0x3c>
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	84 c0                	test   %al,%al
  800c63:	75 d8                	jne    800c3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c71:	29 c2                	sub    %eax,%edx
  800c73:	89 d0                	mov    %edx,%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c7a:	eb 06                	jmp    800c82 <strcmp+0xb>
		p++, q++;
  800c7c:	ff 45 08             	incl   0x8(%ebp)
  800c7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	74 0e                	je     800c99 <strcmp+0x22>
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 10                	mov    (%eax),%dl
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	38 c2                	cmp    %al,%dl
  800c97:	74 e3                	je     800c7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	0f b6 d0             	movzbl %al,%edx
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	0f b6 c0             	movzbl %al,%eax
  800ca9:	29 c2                	sub    %eax,%edx
  800cab:	89 d0                	mov    %edx,%eax
}
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cb2:	eb 09                	jmp    800cbd <strncmp+0xe>
		n--, p++, q++;
  800cb4:	ff 4d 10             	decl   0x10(%ebp)
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 17                	je     800cda <strncmp+0x2b>
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	84 c0                	test   %al,%al
  800cca:	74 0e                	je     800cda <strncmp+0x2b>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 10                	mov    (%eax),%dl
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	38 c2                	cmp    %al,%dl
  800cd8:	74 da                	je     800cb4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	75 07                	jne    800ce7 <strncmp+0x38>
		return 0;
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce5:	eb 14                	jmp    800cfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	0f b6 d0             	movzbl %al,%edx
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	0f b6 c0             	movzbl %al,%eax
  800cf7:	29 c2                	sub    %eax,%edx
  800cf9:	89 d0                	mov    %edx,%eax
}
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    

00800cfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	83 ec 04             	sub    $0x4,%esp
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d09:	eb 12                	jmp    800d1d <strchr+0x20>
		if (*s == c)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d13:	75 05                	jne    800d1a <strchr+0x1d>
			return (char *) s;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	eb 11                	jmp    800d2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	75 e5                	jne    800d0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 04             	sub    $0x4,%esp
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d39:	eb 0d                	jmp    800d48 <strfind+0x1b>
		if (*s == c)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d43:	74 0e                	je     800d53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d45:	ff 45 08             	incl   0x8(%ebp)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 ea                	jne    800d3b <strfind+0xe>
  800d51:	eb 01                	jmp    800d54 <strfind+0x27>
		if (*s == c)
			break;
  800d53:	90                   	nop
	return (char *) s;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d65:	8b 45 10             	mov    0x10(%ebp),%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d6b:	eb 0e                	jmp    800d7b <memset+0x22>
		*p++ = c;
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d7b:	ff 4d f8             	decl   -0x8(%ebp)
  800d7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d82:	79 e9                	jns    800d6d <memset+0x14>
		*p++ = c;

	return v;
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d9b:	eb 16                	jmp    800db3 <memcpy+0x2a>
		*d++ = *s++;
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800daf:	8a 12                	mov    (%edx),%dl
  800db1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	75 dd                	jne    800d9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ddd:	73 50                	jae    800e2f <memmove+0x6a>
  800ddf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	01 d0                	add    %edx,%eax
  800de7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dea:	76 43                	jbe    800e2f <memmove+0x6a>
		s += n;
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800df2:	8b 45 10             	mov    0x10(%ebp),%eax
  800df5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800df8:	eb 10                	jmp    800e0a <memmove+0x45>
			*--d = *--s;
  800dfa:	ff 4d f8             	decl   -0x8(%ebp)
  800dfd:	ff 4d fc             	decl   -0x4(%ebp)
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	8a 10                	mov    (%eax),%dl
  800e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	89 55 10             	mov    %edx,0x10(%ebp)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	75 e3                	jne    800dfa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e17:	eb 23                	jmp    800e3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1c:	8d 50 01             	lea    0x1(%eax),%edx
  800e1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2b:	8a 12                	mov    (%edx),%dl
  800e2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e35:	89 55 10             	mov    %edx,0x10(%ebp)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	75 dd                	jne    800e19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e53:	eb 2a                	jmp    800e7f <memcmp+0x3e>
		if (*s1 != *s2)
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	8a 10                	mov    (%eax),%dl
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	38 c2                	cmp    %al,%dl
  800e61:	74 16                	je     800e79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	0f b6 d0             	movzbl %al,%edx
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f b6 c0             	movzbl %al,%eax
  800e73:	29 c2                	sub    %eax,%edx
  800e75:	89 d0                	mov    %edx,%eax
  800e77:	eb 18                	jmp    800e91 <memcmp+0x50>
		s1++, s2++;
  800e79:	ff 45 fc             	incl   -0x4(%ebp)
  800e7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e85:	89 55 10             	mov    %edx,0x10(%ebp)
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	75 c9                	jne    800e55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    

00800e93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9f:	01 d0                	add    %edx,%eax
  800ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ea4:	eb 15                	jmp    800ebb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	0f b6 c0             	movzbl %al,%eax
  800eb4:	39 c2                	cmp    %eax,%edx
  800eb6:	74 0d                	je     800ec5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb8:	ff 45 08             	incl   0x8(%ebp)
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ec1:	72 e3                	jb     800ea6 <memfind+0x13>
  800ec3:	eb 01                	jmp    800ec6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ec5:	90                   	nop
	return (void *) s;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ed1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ed8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800edf:	eb 03                	jmp    800ee4 <strtol+0x19>
		s++;
  800ee1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	3c 20                	cmp    $0x20,%al
  800eeb:	74 f4                	je     800ee1 <strtol+0x16>
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	3c 09                	cmp    $0x9,%al
  800ef4:	74 eb                	je     800ee1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3c 2b                	cmp    $0x2b,%al
  800efd:	75 05                	jne    800f04 <strtol+0x39>
		s++;
  800eff:	ff 45 08             	incl   0x8(%ebp)
  800f02:	eb 13                	jmp    800f17 <strtol+0x4c>
	else if (*s == '-')
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 2d                	cmp    $0x2d,%al
  800f0b:	75 0a                	jne    800f17 <strtol+0x4c>
		s++, neg = 1;
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1b:	74 06                	je     800f23 <strtol+0x58>
  800f1d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f21:	75 20                	jne    800f43 <strtol+0x78>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 30                	cmp    $0x30,%al
  800f2a:	75 17                	jne    800f43 <strtol+0x78>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	40                   	inc    %eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 78                	cmp    $0x78,%al
  800f34:	75 0d                	jne    800f43 <strtol+0x78>
		s += 2, base = 16;
  800f36:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f3a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f41:	eb 28                	jmp    800f6b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 15                	jne    800f5e <strtol+0x93>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 0c                	jne    800f5e <strtol+0x93>
		s++, base = 8;
  800f52:	ff 45 08             	incl   0x8(%ebp)
  800f55:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f5c:	eb 0d                	jmp    800f6b <strtol+0xa0>
	else if (base == 0)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	75 07                	jne    800f6b <strtol+0xa0>
		base = 10;
  800f64:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 2f                	cmp    $0x2f,%al
  800f72:	7e 19                	jle    800f8d <strtol+0xc2>
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 39                	cmp    $0x39,%al
  800f7b:	7f 10                	jg     800f8d <strtol+0xc2>
			dig = *s - '0';
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	0f be c0             	movsbl %al,%eax
  800f85:	83 e8 30             	sub    $0x30,%eax
  800f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f8b:	eb 42                	jmp    800fcf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 60                	cmp    $0x60,%al
  800f94:	7e 19                	jle    800faf <strtol+0xe4>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 7a                	cmp    $0x7a,%al
  800f9d:	7f 10                	jg     800faf <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	0f be c0             	movsbl %al,%eax
  800fa7:	83 e8 57             	sub    $0x57,%eax
  800faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fad:	eb 20                	jmp    800fcf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	3c 40                	cmp    $0x40,%al
  800fb6:	7e 39                	jle    800ff1 <strtol+0x126>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 5a                	cmp    $0x5a,%al
  800fbf:	7f 30                	jg     800ff1 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f be c0             	movsbl %al,%eax
  800fc9:	83 e8 37             	sub    $0x37,%eax
  800fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fd5:	7d 19                	jge    800ff0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fe1:	89 c2                	mov    %eax,%edx
  800fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe6:	01 d0                	add    %edx,%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800feb:	e9 7b ff ff ff       	jmp    800f6b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ff0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ff1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ff5:	74 08                	je     800fff <strtol+0x134>
		*endptr = (char *) s;
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801003:	74 07                	je     80100c <strtol+0x141>
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	f7 d8                	neg    %eax
  80100a:	eb 03                	jmp    80100f <strtol+0x144>
  80100c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <ltostr>:

void
ltostr(long value, char *str)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801017:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80101e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801029:	79 13                	jns    80103e <ltostr+0x2d>
	{
		neg = 1;
  80102b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801038:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801046:	99                   	cltd   
  801047:	f7 f9                	idiv   %ecx
  801049:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80104c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104f:	8d 50 01             	lea    0x1(%eax),%edx
  801052:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801055:	89 c2                	mov    %eax,%edx
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80105f:	83 c2 30             	add    $0x30,%edx
  801062:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801064:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801067:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80106c:	f7 e9                	imul   %ecx
  80106e:	c1 fa 02             	sar    $0x2,%edx
  801071:	89 c8                	mov    %ecx,%eax
  801073:	c1 f8 1f             	sar    $0x1f,%eax
  801076:	29 c2                	sub    %eax,%edx
  801078:	89 d0                	mov    %edx,%eax
  80107a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80107d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801080:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801085:	f7 e9                	imul   %ecx
  801087:	c1 fa 02             	sar    $0x2,%edx
  80108a:	89 c8                	mov    %ecx,%eax
  80108c:	c1 f8 1f             	sar    $0x1f,%eax
  80108f:	29 c2                	sub    %eax,%edx
  801091:	89 d0                	mov    %edx,%eax
  801093:	c1 e0 02             	shl    $0x2,%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	01 c0                	add    %eax,%eax
  80109a:	29 c1                	sub    %eax,%ecx
  80109c:	89 ca                	mov    %ecx,%edx
  80109e:	85 d2                	test   %edx,%edx
  8010a0:	75 9c                	jne    80103e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ac:	48                   	dec    %eax
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b4:	74 3d                	je     8010f3 <ltostr+0xe2>
		start = 1 ;
  8010b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010bd:	eb 34                	jmp    8010f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	01 d0                	add    %edx,%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	01 c2                	add    %eax,%edx
  8010d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	01 c8                	add    %ecx,%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 c2                	add    %eax,%edx
  8010e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8010ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f9:	7c c4                	jl     8010bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801106:	90                   	nop
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	e8 54 fa ff ff       	call   800b6b <strlen>
  801117:	83 c4 04             	add    $0x4,%esp
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	e8 46 fa ff ff       	call   800b6b <strlen>
  801125:	83 c4 04             	add    $0x4,%esp
  801128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80112b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801139:	eb 17                	jmp    801152 <strcconcat+0x49>
		final[s] = str1[s] ;
  80113b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	01 c8                	add    %ecx,%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80114f:	ff 45 fc             	incl   -0x4(%ebp)
  801152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801155:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801158:	7c e1                	jl     80113b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80115a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801168:	eb 1f                	jmp    801189 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8d 50 01             	lea    0x1(%eax),%edx
  801170:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801173:	89 c2                	mov    %eax,%edx
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	01 c2                	add    %eax,%edx
  80117a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	01 c8                	add    %ecx,%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801186:	ff 45 f8             	incl   -0x8(%ebp)
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118f:	7c d9                	jl     80116a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801191:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	c6 00 00             	movb   $0x0,(%eax)
}
  80119c:	90                   	nop
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c2:	eb 0c                	jmp    8011d0 <strsplit+0x31>
			*string++ = 0;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	84 c0                	test   %al,%al
  8011d7:	74 18                	je     8011f1 <strsplit+0x52>
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f be c0             	movsbl %al,%eax
  8011e1:	50                   	push   %eax
  8011e2:	ff 75 0c             	pushl  0xc(%ebp)
  8011e5:	e8 13 fb ff ff       	call   800cfd <strchr>
  8011ea:	83 c4 08             	add    $0x8,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	75 d3                	jne    8011c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	84 c0                	test   %al,%al
  8011f8:	74 5a                	je     801254 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fd:	8b 00                	mov    (%eax),%eax
  8011ff:	83 f8 0f             	cmp    $0xf,%eax
  801202:	75 07                	jne    80120b <strsplit+0x6c>
		{
			return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 66                	jmp    801271 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80120b:	8b 45 14             	mov    0x14(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	8d 48 01             	lea    0x1(%eax),%ecx
  801213:	8b 55 14             	mov    0x14(%ebp),%edx
  801216:	89 0a                	mov    %ecx,(%edx)
  801218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	01 c2                	add    %eax,%edx
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801229:	eb 03                	jmp    80122e <strsplit+0x8f>
			string++;
  80122b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	84 c0                	test   %al,%al
  801235:	74 8b                	je     8011c2 <strsplit+0x23>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	0f be c0             	movsbl %al,%eax
  80123f:	50                   	push   %eax
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	e8 b5 fa ff ff       	call   800cfd <strchr>
  801248:	83 c4 08             	add    $0x8,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	74 dc                	je     80122b <strsplit+0x8c>
			string++;
	}
  80124f:	e9 6e ff ff ff       	jmp    8011c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801254:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80126c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801271:	c9                   	leave  
  801272:	c3                   	ret    

00801273 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801280:	eb 4c                	jmp    8012ce <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 40                	cmp    $0x40,%al
  80128e:	7e 27                	jle    8012b7 <str2lower+0x44>
  801290:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	01 d0                	add    %edx,%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 5a                	cmp    $0x5a,%al
  80129c:	7f 19                	jg     8012b7 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80129e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	01 ca                	add    %ecx,%edx
  8012ae:	8a 12                	mov    (%edx),%dl
  8012b0:	83 c2 20             	add    $0x20,%edx
  8012b3:	88 10                	mov    %dl,(%eax)
  8012b5:	eb 14                	jmp    8012cb <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  8012b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	01 c2                	add    %eax,%edx
  8012bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 c8                	add    %ecx,%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	e8 95 f8 ff ff       	call   800b6b <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012dc:	7f a4                	jg     801282 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012fa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012fd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801300:	cd 30                	int    $0x30
  801302:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801305:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 04             	sub    $0x4,%esp
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80131c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	52                   	push   %edx
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	50                   	push   %eax
  80132c:	6a 00                	push   $0x0
  80132e:	e8 b2 ff ff ff       	call   8012e5 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_cgetc>:

int
sys_cgetc(void)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 01                	push   $0x1
  801348:	e8 98 ff ff ff       	call   8012e5 <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801355:	8b 55 0c             	mov    0xc(%ebp),%edx
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	52                   	push   %edx
  801362:	50                   	push   %eax
  801363:	6a 05                	push   $0x5
  801365:	e8 7b ff ff ff       	call   8012e5 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801374:	8b 75 18             	mov    0x18(%ebp),%esi
  801377:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80137a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	51                   	push   %ecx
  801386:	52                   	push   %edx
  801387:	50                   	push   %eax
  801388:	6a 06                	push   $0x6
  80138a:	e8 56 ff ff ff       	call   8012e5 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801395:	5b                   	pop    %ebx
  801396:	5e                   	pop    %esi
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80139c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	52                   	push   %edx
  8013a9:	50                   	push   %eax
  8013aa:	6a 07                	push   $0x7
  8013ac:	e8 34 ff ff ff       	call   8012e5 <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	6a 08                	push   $0x8
  8013c7:	e8 19 ff ff ff       	call   8012e5 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 09                	push   $0x9
  8013e0:	e8 00 ff ff ff       	call   8012e5 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 0a                	push   $0xa
  8013f9:	e8 e7 fe ff ff       	call   8012e5 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 0b                	push   $0xb
  801412:	e8 ce fe ff ff       	call   8012e5 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 0c                	push   $0xc
  80142b:	e8 b5 fe ff ff       	call   8012e5 <syscall>
  801430:	83 c4 18             	add    $0x18,%esp
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	6a 0d                	push   $0xd
  801445:	e8 9b fe ff ff       	call   8012e5 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 0e                	push   $0xe
  80145e:	e8 82 fe ff ff       	call   8012e5 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	90                   	nop
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 11                	push   $0x11
  801478:	e8 68 fe ff ff       	call   8012e5 <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 12                	push   $0x12
  801492:	e8 4e fe ff ff       	call   8012e5 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_cputc>:


void
sys_cputc(const char c)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	50                   	push   %eax
  8014b6:	6a 13                	push   $0x13
  8014b8:	e8 28 fe ff ff       	call   8012e5 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 14                	push   $0x14
  8014d2:	e8 0e fe ff ff       	call   8012e5 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	50                   	push   %eax
  8014ed:	6a 15                	push   $0x15
  8014ef:	e8 f1 fd ff ff       	call   8012e5 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	52                   	push   %edx
  801509:	50                   	push   %eax
  80150a:	6a 18                	push   $0x18
  80150c:	e8 d4 fd ff ff       	call   8012e5 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 16                	push   $0x16
  801529:	e8 b7 fd ff ff       	call   8012e5 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	52                   	push   %edx
  801544:	50                   	push   %eax
  801545:	6a 17                	push   $0x17
  801547:	e8 99 fd ff ff       	call   8012e5 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80155e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801561:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	6a 00                	push   $0x0
  80156a:	51                   	push   %ecx
  80156b:	52                   	push   %edx
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	50                   	push   %eax
  801570:	6a 19                	push   $0x19
  801572:	e8 6e fd ff ff       	call   8012e5 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	6a 1a                	push   $0x1a
  80158f:	e8 51 fd ff ff       	call   8012e5 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	51                   	push   %ecx
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	6a 1b                	push   $0x1b
  8015ae:	e8 32 fd ff ff       	call   8012e5 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	6a 1c                	push   $0x1c
  8015cb:	e8 15 fd ff ff       	call   8012e5 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 1d                	push   $0x1d
  8015e4:	e8 fc fc ff ff       	call   8012e5 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 14             	pushl  0x14(%ebp)
  8015f9:	ff 75 10             	pushl  0x10(%ebp)
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	6a 1e                	push   $0x1e
  801602:	e8 de fc ff ff       	call   8012e5 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	50                   	push   %eax
  80161b:	6a 1f                	push   $0x1f
  80161d:	e8 c3 fc ff ff       	call   8012e5 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	50                   	push   %eax
  801637:	6a 20                	push   $0x20
  801639:	e8 a7 fc ff ff       	call   8012e5 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 02                	push   $0x2
  801652:	e8 8e fc ff ff       	call   8012e5 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 03                	push   $0x3
  80166b:	e8 75 fc ff ff       	call   8012e5 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 04                	push   $0x4
  801684:	e8 5c fc ff ff       	call   8012e5 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_exit_env>:


void sys_exit_env(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 21                	push   $0x21
  80169d:	e8 43 fc ff ff       	call   8012e5 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	90                   	nop
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b1:	8d 50 04             	lea    0x4(%eax),%edx
  8016b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 22                	push   $0x22
  8016c1:	e8 1f fc ff ff       	call   8012e5 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d2:	89 01                	mov    %eax,(%ecx)
  8016d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	c9                   	leave  
  8016db:	c2 04 00             	ret    $0x4

008016de <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 10             	pushl  0x10(%ebp)
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	6a 10                	push   $0x10
  8016f0:	e8 f0 fb ff ff       	call   8012e5 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f8:	90                   	nop
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_rcr2>:
uint32 sys_rcr2()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 23                	push   $0x23
  80170a:	e8 d6 fb ff ff       	call   8012e5 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801720:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	50                   	push   %eax
  80172d:	6a 24                	push   $0x24
  80172f:	e8 b1 fb ff ff       	call   8012e5 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <rsttst>:
void rsttst()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 26                	push   $0x26
  801749:	e8 97 fb ff ff       	call   8012e5 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return ;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 04             	sub    $0x4,%esp
  80175a:	8b 45 14             	mov    0x14(%ebp),%eax
  80175d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801760:	8b 55 18             	mov    0x18(%ebp),%edx
  801763:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	ff 75 10             	pushl  0x10(%ebp)
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 25                	push   $0x25
  801774:	e8 6c fb ff ff       	call   8012e5 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
	return ;
  80177c:	90                   	nop
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <chktst>:
void chktst(uint32 n)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 27                	push   $0x27
  80178f:	e8 51 fb ff ff       	call   8012e5 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <inctst>:

void inctst()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 28                	push   $0x28
  8017a9:	e8 37 fb ff ff       	call   8012e5 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <gettst>:
uint32 gettst()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 29                	push   $0x29
  8017c3:	e8 1d fb ff ff       	call   8012e5 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 2a                	push   $0x2a
  8017df:	e8 01 fb ff ff       	call   8012e5 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017ea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017ee:	75 07                	jne    8017f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f5:	eb 05                	jmp    8017fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 2a                	push   $0x2a
  801810:	e8 d0 fa ff ff       	call   8012e5 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
  801818:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80181b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80181f:	75 07                	jne    801828 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801821:	b8 01 00 00 00       	mov    $0x1,%eax
  801826:	eb 05                	jmp    80182d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 2a                	push   $0x2a
  801841:	e8 9f fa ff ff       	call   8012e5 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
  801849:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80184c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801850:	75 07                	jne    801859 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801852:	b8 01 00 00 00       	mov    $0x1,%eax
  801857:	eb 05                	jmp    80185e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 2a                	push   $0x2a
  801872:	e8 6e fa ff ff       	call   8012e5 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
  80187a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80187d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801881:	75 07                	jne    80188a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801883:	b8 01 00 00 00       	mov    $0x1,%eax
  801888:	eb 05                	jmp    80188f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 2b                	push   $0x2b
  8018a1:	e8 3f fa ff ff       	call   8012e5 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	53                   	push   %ebx
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 2c                	push   $0x2c
  8018c4:	e8 1c fa ff ff       	call   8012e5 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 2d                	push   $0x2d
  8018e4:	e8 fc f9 ff ff       	call   8012e5 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	51                   	push   %ecx
  8018fd:	ff 75 10             	pushl  0x10(%ebp)
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 2e                	push   $0x2e
  801904:	e8 dc f9 ff ff       	call   8012e5 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 10             	pushl  0x10(%ebp)
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 0f                	push   $0xf
  801920:	e8 c0 f9 ff ff       	call   8012e5 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
	return ;
  801928:	90                   	nop
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	50                   	push   %eax
  80193a:	6a 2f                	push   $0x2f
  80193c:	e8 a4 f9 ff ff       	call   8012e5 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp

}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 30                	push   $0x30
  801957:	e8 89 f9 ff ff       	call   8012e5 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 31                	push   $0x31
  801973:	e8 6d f9 ff ff       	call   8012e5 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
	return;
  80197b:	90                   	nop
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 32                	push   $0x32
  80198d:	e8 53 f9 ff ff       	call   8012e5 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	50                   	push   %eax
  8019a6:	6a 33                	push   $0x33
  8019a8:	e8 38 f9 ff ff       	call   8012e5 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	90                   	nop
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019bf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	50                   	push   %eax
  8019c7:	e8 d1 fa ff ff       	call   80149d <sys_cputc>
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019d8:	e8 8c fa ff ff       	call   801469 <sys_disable_interrupt>
	char c = ch;
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019e3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	50                   	push   %eax
  8019eb:	e8 ad fa ff ff       	call   80149d <sys_cputc>
  8019f0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019f3:	e8 8b fa ff ff       	call   801483 <sys_enable_interrupt>
}
  8019f8:	90                   	nop
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <getchar>:

int
getchar(void)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a08:	eb 08                	jmp    801a12 <getchar+0x17>
	{
		c = sys_cgetc();
  801a0a:	e8 2a f9 ff ff       	call   801339 <sys_cgetc>
  801a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a16:	74 f2                	je     801a0a <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <atomic_getchar>:

int
atomic_getchar(void)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a23:	e8 41 fa ff ff       	call   801469 <sys_disable_interrupt>
	int c=0;
  801a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a2f:	eb 08                	jmp    801a39 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a31:	e8 03 f9 ff ff       	call   801339 <sys_cgetc>
  801a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a3d:	74 f2                	je     801a31 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a3f:	e8 3f fa ff ff       	call   801483 <sys_enable_interrupt>
	return c;
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <iscons>:

int iscons(int fdnum)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a4c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    
  801a53:	90                   	nop

00801a54 <__udivdi3>:
  801a54:	55                   	push   %ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 1c             	sub    $0x1c,%esp
  801a5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6b:	89 ca                	mov    %ecx,%edx
  801a6d:	89 f8                	mov    %edi,%eax
  801a6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a73:	85 f6                	test   %esi,%esi
  801a75:	75 2d                	jne    801aa4 <__udivdi3+0x50>
  801a77:	39 cf                	cmp    %ecx,%edi
  801a79:	77 65                	ja     801ae0 <__udivdi3+0x8c>
  801a7b:	89 fd                	mov    %edi,%ebp
  801a7d:	85 ff                	test   %edi,%edi
  801a7f:	75 0b                	jne    801a8c <__udivdi3+0x38>
  801a81:	b8 01 00 00 00       	mov    $0x1,%eax
  801a86:	31 d2                	xor    %edx,%edx
  801a88:	f7 f7                	div    %edi
  801a8a:	89 c5                	mov    %eax,%ebp
  801a8c:	31 d2                	xor    %edx,%edx
  801a8e:	89 c8                	mov    %ecx,%eax
  801a90:	f7 f5                	div    %ebp
  801a92:	89 c1                	mov    %eax,%ecx
  801a94:	89 d8                	mov    %ebx,%eax
  801a96:	f7 f5                	div    %ebp
  801a98:	89 cf                	mov    %ecx,%edi
  801a9a:	89 fa                	mov    %edi,%edx
  801a9c:	83 c4 1c             	add    $0x1c,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    
  801aa4:	39 ce                	cmp    %ecx,%esi
  801aa6:	77 28                	ja     801ad0 <__udivdi3+0x7c>
  801aa8:	0f bd fe             	bsr    %esi,%edi
  801aab:	83 f7 1f             	xor    $0x1f,%edi
  801aae:	75 40                	jne    801af0 <__udivdi3+0x9c>
  801ab0:	39 ce                	cmp    %ecx,%esi
  801ab2:	72 0a                	jb     801abe <__udivdi3+0x6a>
  801ab4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ab8:	0f 87 9e 00 00 00    	ja     801b5c <__udivdi3+0x108>
  801abe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac3:	89 fa                	mov    %edi,%edx
  801ac5:	83 c4 1c             	add    $0x1c,%esp
  801ac8:	5b                   	pop    %ebx
  801ac9:	5e                   	pop    %esi
  801aca:	5f                   	pop    %edi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    
  801acd:	8d 76 00             	lea    0x0(%esi),%esi
  801ad0:	31 ff                	xor    %edi,%edi
  801ad2:	31 c0                	xor    %eax,%eax
  801ad4:	89 fa                	mov    %edi,%edx
  801ad6:	83 c4 1c             	add    $0x1c,%esp
  801ad9:	5b                   	pop    %ebx
  801ada:	5e                   	pop    %esi
  801adb:	5f                   	pop    %edi
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    
  801ade:	66 90                	xchg   %ax,%ax
  801ae0:	89 d8                	mov    %ebx,%eax
  801ae2:	f7 f7                	div    %edi
  801ae4:	31 ff                	xor    %edi,%edi
  801ae6:	89 fa                	mov    %edi,%edx
  801ae8:	83 c4 1c             	add    $0x1c,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    
  801af0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801af5:	89 eb                	mov    %ebp,%ebx
  801af7:	29 fb                	sub    %edi,%ebx
  801af9:	89 f9                	mov    %edi,%ecx
  801afb:	d3 e6                	shl    %cl,%esi
  801afd:	89 c5                	mov    %eax,%ebp
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 ed                	shr    %cl,%ebp
  801b03:	89 e9                	mov    %ebp,%ecx
  801b05:	09 f1                	or     %esi,%ecx
  801b07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b0b:	89 f9                	mov    %edi,%ecx
  801b0d:	d3 e0                	shl    %cl,%eax
  801b0f:	89 c5                	mov    %eax,%ebp
  801b11:	89 d6                	mov    %edx,%esi
  801b13:	88 d9                	mov    %bl,%cl
  801b15:	d3 ee                	shr    %cl,%esi
  801b17:	89 f9                	mov    %edi,%ecx
  801b19:	d3 e2                	shl    %cl,%edx
  801b1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b1f:	88 d9                	mov    %bl,%cl
  801b21:	d3 e8                	shr    %cl,%eax
  801b23:	09 c2                	or     %eax,%edx
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	89 f2                	mov    %esi,%edx
  801b29:	f7 74 24 0c          	divl   0xc(%esp)
  801b2d:	89 d6                	mov    %edx,%esi
  801b2f:	89 c3                	mov    %eax,%ebx
  801b31:	f7 e5                	mul    %ebp
  801b33:	39 d6                	cmp    %edx,%esi
  801b35:	72 19                	jb     801b50 <__udivdi3+0xfc>
  801b37:	74 0b                	je     801b44 <__udivdi3+0xf0>
  801b39:	89 d8                	mov    %ebx,%eax
  801b3b:	31 ff                	xor    %edi,%edi
  801b3d:	e9 58 ff ff ff       	jmp    801a9a <__udivdi3+0x46>
  801b42:	66 90                	xchg   %ax,%ax
  801b44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b48:	89 f9                	mov    %edi,%ecx
  801b4a:	d3 e2                	shl    %cl,%edx
  801b4c:	39 c2                	cmp    %eax,%edx
  801b4e:	73 e9                	jae    801b39 <__udivdi3+0xe5>
  801b50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b53:	31 ff                	xor    %edi,%edi
  801b55:	e9 40 ff ff ff       	jmp    801a9a <__udivdi3+0x46>
  801b5a:	66 90                	xchg   %ax,%ax
  801b5c:	31 c0                	xor    %eax,%eax
  801b5e:	e9 37 ff ff ff       	jmp    801a9a <__udivdi3+0x46>
  801b63:	90                   	nop

00801b64 <__umoddi3>:
  801b64:	55                   	push   %ebp
  801b65:	57                   	push   %edi
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 1c             	sub    $0x1c,%esp
  801b6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b83:	89 f3                	mov    %esi,%ebx
  801b85:	89 fa                	mov    %edi,%edx
  801b87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b8b:	89 34 24             	mov    %esi,(%esp)
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	75 1a                	jne    801bac <__umoddi3+0x48>
  801b92:	39 f7                	cmp    %esi,%edi
  801b94:	0f 86 a2 00 00 00    	jbe    801c3c <__umoddi3+0xd8>
  801b9a:	89 c8                	mov    %ecx,%eax
  801b9c:	89 f2                	mov    %esi,%edx
  801b9e:	f7 f7                	div    %edi
  801ba0:	89 d0                	mov    %edx,%eax
  801ba2:	31 d2                	xor    %edx,%edx
  801ba4:	83 c4 1c             	add    $0x1c,%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
  801bac:	39 f0                	cmp    %esi,%eax
  801bae:	0f 87 ac 00 00 00    	ja     801c60 <__umoddi3+0xfc>
  801bb4:	0f bd e8             	bsr    %eax,%ebp
  801bb7:	83 f5 1f             	xor    $0x1f,%ebp
  801bba:	0f 84 ac 00 00 00    	je     801c6c <__umoddi3+0x108>
  801bc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801bc5:	29 ef                	sub    %ebp,%edi
  801bc7:	89 fe                	mov    %edi,%esi
  801bc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bcd:	89 e9                	mov    %ebp,%ecx
  801bcf:	d3 e0                	shl    %cl,%eax
  801bd1:	89 d7                	mov    %edx,%edi
  801bd3:	89 f1                	mov    %esi,%ecx
  801bd5:	d3 ef                	shr    %cl,%edi
  801bd7:	09 c7                	or     %eax,%edi
  801bd9:	89 e9                	mov    %ebp,%ecx
  801bdb:	d3 e2                	shl    %cl,%edx
  801bdd:	89 14 24             	mov    %edx,(%esp)
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	d3 e0                	shl    %cl,%eax
  801be4:	89 c2                	mov    %eax,%edx
  801be6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bea:	d3 e0                	shl    %cl,%eax
  801bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bf4:	89 f1                	mov    %esi,%ecx
  801bf6:	d3 e8                	shr    %cl,%eax
  801bf8:	09 d0                	or     %edx,%eax
  801bfa:	d3 eb                	shr    %cl,%ebx
  801bfc:	89 da                	mov    %ebx,%edx
  801bfe:	f7 f7                	div    %edi
  801c00:	89 d3                	mov    %edx,%ebx
  801c02:	f7 24 24             	mull   (%esp)
  801c05:	89 c6                	mov    %eax,%esi
  801c07:	89 d1                	mov    %edx,%ecx
  801c09:	39 d3                	cmp    %edx,%ebx
  801c0b:	0f 82 87 00 00 00    	jb     801c98 <__umoddi3+0x134>
  801c11:	0f 84 91 00 00 00    	je     801ca8 <__umoddi3+0x144>
  801c17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c1b:	29 f2                	sub    %esi,%edx
  801c1d:	19 cb                	sbb    %ecx,%ebx
  801c1f:	89 d8                	mov    %ebx,%eax
  801c21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c25:	d3 e0                	shl    %cl,%eax
  801c27:	89 e9                	mov    %ebp,%ecx
  801c29:	d3 ea                	shr    %cl,%edx
  801c2b:	09 d0                	or     %edx,%eax
  801c2d:	89 e9                	mov    %ebp,%ecx
  801c2f:	d3 eb                	shr    %cl,%ebx
  801c31:	89 da                	mov    %ebx,%edx
  801c33:	83 c4 1c             	add    $0x1c,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5f                   	pop    %edi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    
  801c3b:	90                   	nop
  801c3c:	89 fd                	mov    %edi,%ebp
  801c3e:	85 ff                	test   %edi,%edi
  801c40:	75 0b                	jne    801c4d <__umoddi3+0xe9>
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	31 d2                	xor    %edx,%edx
  801c49:	f7 f7                	div    %edi
  801c4b:	89 c5                	mov    %eax,%ebp
  801c4d:	89 f0                	mov    %esi,%eax
  801c4f:	31 d2                	xor    %edx,%edx
  801c51:	f7 f5                	div    %ebp
  801c53:	89 c8                	mov    %ecx,%eax
  801c55:	f7 f5                	div    %ebp
  801c57:	89 d0                	mov    %edx,%eax
  801c59:	e9 44 ff ff ff       	jmp    801ba2 <__umoddi3+0x3e>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	89 c8                	mov    %ecx,%eax
  801c62:	89 f2                	mov    %esi,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	3b 04 24             	cmp    (%esp),%eax
  801c6f:	72 06                	jb     801c77 <__umoddi3+0x113>
  801c71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c75:	77 0f                	ja     801c86 <__umoddi3+0x122>
  801c77:	89 f2                	mov    %esi,%edx
  801c79:	29 f9                	sub    %edi,%ecx
  801c7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c7f:	89 14 24             	mov    %edx,(%esp)
  801c82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c8a:	8b 14 24             	mov    (%esp),%edx
  801c8d:	83 c4 1c             	add    $0x1c,%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5f                   	pop    %edi
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    
  801c95:	8d 76 00             	lea    0x0(%esi),%esi
  801c98:	2b 04 24             	sub    (%esp),%eax
  801c9b:	19 fa                	sbb    %edi,%edx
  801c9d:	89 d1                	mov    %edx,%ecx
  801c9f:	89 c6                	mov    %eax,%esi
  801ca1:	e9 71 ff ff ff       	jmp    801c17 <__umoddi3+0xb3>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cac:	72 ea                	jb     801c98 <__umoddi3+0x134>
  801cae:	89 d9                	mov    %ebx,%ecx
  801cb0:	e9 62 ff ff ff       	jmp    801c17 <__umoddi3+0xb3>
