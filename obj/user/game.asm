
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 e0 19 80 00       	push   $0x8019e0
  80005b:	e8 51 02 00 00       	call   8002b1 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 e3 19 80 00       	push   $0x8019e3
  800092:	e8 1a 02 00 00       	call   8002b1 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000b5:	e8 6a 13 00 00       	call   801424 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	01 c0                	add    %eax,%eax
  8000c4:	01 d0                	add    %edx,%eax
  8000c6:	c1 e0 06             	shl    $0x6,%eax
  8000c9:	29 d0                	sub    %edx,%eax
  8000cb:	c1 e0 03             	shl    $0x3,%eax
  8000ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d3:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000dd:	8a 40 68             	mov    0x68(%eax),%al
  8000e0:	84 c0                	test   %al,%al
  8000e2:	74 0d                	je     8000f1 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8000e4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e9:	83 c0 68             	add    $0x68,%eax
  8000ec:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f5:	7e 0a                	jle    800101 <libmain+0x52>
		binaryname = argv[0];
  8000f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fa:	8b 00                	mov    (%eax),%eax
  8000fc:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	ff 75 0c             	pushl  0xc(%ebp)
  800107:	ff 75 08             	pushl  0x8(%ebp)
  80010a:	e8 29 ff ff ff       	call   800038 <_main>
  80010f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800112:	e8 1a 11 00 00       	call   801231 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	68 00 1a 80 00       	push   $0x801a00
  80011f:	e8 8d 01 00 00       	call   8002b1 <cprintf>
  800124:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800127:	a1 20 20 80 00       	mov    0x802020,%eax
  80012c:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800132:	a1 20 20 80 00       	mov    0x802020,%eax
  800137:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	52                   	push   %edx
  800141:	50                   	push   %eax
  800142:	68 28 1a 80 00       	push   $0x801a28
  800147:	e8 65 01 00 00       	call   8002b1 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80014f:	a1 20 20 80 00       	mov    0x802020,%eax
  800154:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80015a:	a1 20 20 80 00       	mov    0x802020,%eax
  80015f:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800165:	a1 20 20 80 00       	mov    0x802020,%eax
  80016a:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800170:	51                   	push   %ecx
  800171:	52                   	push   %edx
  800172:	50                   	push   %eax
  800173:	68 50 1a 80 00       	push   $0x801a50
  800178:	e8 34 01 00 00       	call   8002b1 <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800180:	a1 20 20 80 00       	mov    0x802020,%eax
  800185:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	50                   	push   %eax
  80018f:	68 a8 1a 80 00       	push   $0x801aa8
  800194:	e8 18 01 00 00       	call   8002b1 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 00 1a 80 00       	push   $0x801a00
  8001a4:	e8 08 01 00 00       	call   8002b1 <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ac:	e8 9a 10 00 00       	call   80124b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001b1:	e8 19 00 00 00       	call   8001cf <exit>
}
  8001b6:	90                   	nop
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	6a 00                	push   $0x0
  8001c4:	e8 27 12 00 00       	call   8013f0 <sys_destroy_env>
  8001c9:	83 c4 10             	add    $0x10,%esp
}
  8001cc:	90                   	nop
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <exit>:

void
exit(void)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001d5:	e8 7c 12 00 00       	call   801456 <sys_exit_env>
}
  8001da:	90                   	nop
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	8b 00                	mov    (%eax),%eax
  8001e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8001eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ee:	89 0a                	mov    %ecx,(%edx)
  8001f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f3:	88 d1                	mov    %dl,%cl
  8001f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	3d ff 00 00 00       	cmp    $0xff,%eax
  800206:	75 2c                	jne    800234 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800208:	a0 24 20 80 00       	mov    0x802024,%al
  80020d:	0f b6 c0             	movzbl %al,%eax
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 12                	mov    (%edx),%edx
  800215:	89 d1                	mov    %edx,%ecx
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	83 c2 08             	add    $0x8,%edx
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	50                   	push   %eax
  800221:	51                   	push   %ecx
  800222:	52                   	push   %edx
  800223:	e8 b0 0e 00 00       	call   8010d8 <sys_cputs>
  800228:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80022b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	8b 40 04             	mov    0x4(%eax),%eax
  80023a:	8d 50 01             	lea    0x1(%eax),%edx
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	89 50 04             	mov    %edx,0x4(%eax)
}
  800243:	90                   	nop
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800256:	00 00 00 
	b.cnt = 0;
  800259:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800260:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800263:	ff 75 0c             	pushl  0xc(%ebp)
  800266:	ff 75 08             	pushl  0x8(%ebp)
  800269:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	68 dd 01 80 00       	push   $0x8001dd
  800275:	e8 11 02 00 00       	call   80048b <vprintfmt>
  80027a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80027d:	a0 24 20 80 00       	mov    0x802024,%al
  800282:	0f b6 c0             	movzbl %al,%eax
  800285:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80028b:	83 ec 04             	sub    $0x4,%esp
  80028e:	50                   	push   %eax
  80028f:	52                   	push   %edx
  800290:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800296:	83 c0 08             	add    $0x8,%eax
  800299:	50                   	push   %eax
  80029a:	e8 39 0e 00 00       	call   8010d8 <sys_cputs>
  80029f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002a2:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002b7:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cd:	50                   	push   %eax
  8002ce:	e8 73 ff ff ff       	call   800246 <vcprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002e4:	e8 48 0f 00 00       	call   801231 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f8:	50                   	push   %eax
  8002f9:	e8 48 ff ff ff       	call   800246 <vcprintf>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800304:	e8 42 0f 00 00       	call   80124b <sys_enable_interrupt>
	return cnt;
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	53                   	push   %ebx
  800312:	83 ec 14             	sub    $0x14,%esp
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80031b:	8b 45 14             	mov    0x14(%ebp),%eax
  80031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800321:	8b 45 18             	mov    0x18(%ebp),%eax
  800324:	ba 00 00 00 00       	mov    $0x0,%edx
  800329:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80032c:	77 55                	ja     800383 <printnum+0x75>
  80032e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800331:	72 05                	jb     800338 <printnum+0x2a>
  800333:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800336:	77 4b                	ja     800383 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800338:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80033b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80033e:	8b 45 18             	mov    0x18(%ebp),%eax
  800341:	ba 00 00 00 00       	mov    $0x0,%edx
  800346:	52                   	push   %edx
  800347:	50                   	push   %eax
  800348:	ff 75 f4             	pushl  -0xc(%ebp)
  80034b:	ff 75 f0             	pushl  -0x10(%ebp)
  80034e:	e8 29 14 00 00       	call   80177c <__udivdi3>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	ff 75 20             	pushl  0x20(%ebp)
  80035c:	53                   	push   %ebx
  80035d:	ff 75 18             	pushl  0x18(%ebp)
  800360:	52                   	push   %edx
  800361:	50                   	push   %eax
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 a1 ff ff ff       	call   80030e <printnum>
  80036d:	83 c4 20             	add    $0x20,%esp
  800370:	eb 1a                	jmp    80038c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	ff 75 0c             	pushl  0xc(%ebp)
  800378:	ff 75 20             	pushl  0x20(%ebp)
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	ff d0                	call   *%eax
  800380:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800383:	ff 4d 1c             	decl   0x1c(%ebp)
  800386:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80038a:	7f e6                	jg     800372 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80038f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80039a:	53                   	push   %ebx
  80039b:	51                   	push   %ecx
  80039c:	52                   	push   %edx
  80039d:	50                   	push   %eax
  80039e:	e8 e9 14 00 00       	call   80188c <__umoddi3>
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  8003ab:	8a 00                	mov    (%eax),%al
  8003ad:	0f be c0             	movsbl %al,%eax
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	ff 75 0c             	pushl  0xc(%ebp)
  8003b6:	50                   	push   %eax
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	ff d0                	call   *%eax
  8003bc:	83 c4 10             	add    $0x10,%esp
}
  8003bf:	90                   	nop
  8003c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003cc:	7e 1c                	jle    8003ea <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	8d 50 08             	lea    0x8(%eax),%edx
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	89 10                	mov    %edx,(%eax)
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	83 e8 08             	sub    $0x8,%eax
  8003e3:	8b 50 04             	mov    0x4(%eax),%edx
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	eb 40                	jmp    80042a <getuint+0x65>
	else if (lflag)
  8003ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ee:	74 1e                	je     80040e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	8d 50 04             	lea    0x4(%eax),%edx
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	89 10                	mov    %edx,(%eax)
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	8b 00                	mov    (%eax),%eax
  800402:	83 e8 04             	sub    $0x4,%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	ba 00 00 00 00       	mov    $0x0,%edx
  80040c:	eb 1c                	jmp    80042a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	8d 50 04             	lea    0x4(%eax),%edx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	89 10                	mov    %edx,(%eax)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	83 e8 04             	sub    $0x4,%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800433:	7e 1c                	jle    800451 <getint+0x25>
		return va_arg(*ap, long long);
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	8d 50 08             	lea    0x8(%eax),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	89 10                	mov    %edx,(%eax)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	83 e8 08             	sub    $0x8,%eax
  80044a:	8b 50 04             	mov    0x4(%eax),%edx
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	eb 38                	jmp    800489 <getint+0x5d>
	else if (lflag)
  800451:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800455:	74 1a                	je     800471 <getint+0x45>
		return va_arg(*ap, long);
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 04             	lea    0x4(%eax),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	83 e8 04             	sub    $0x4,%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	99                   	cltd   
  80046f:	eb 18                	jmp    800489 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	89 10                	mov    %edx,(%eax)
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	83 e8 04             	sub    $0x4,%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	99                   	cltd   
}
  800489:	5d                   	pop    %ebp
  80048a:	c3                   	ret    

0080048b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	56                   	push   %esi
  80048f:	53                   	push   %ebx
  800490:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800493:	eb 17                	jmp    8004ac <vprintfmt+0x21>
			if (ch == '\0')
  800495:	85 db                	test   %ebx,%ebx
  800497:	0f 84 af 03 00 00    	je     80084c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	53                   	push   %ebx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	ff d0                	call   *%eax
  8004a9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	8d 50 01             	lea    0x1(%eax),%edx
  8004b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b5:	8a 00                	mov    (%eax),%al
  8004b7:	0f b6 d8             	movzbl %al,%ebx
  8004ba:	83 fb 25             	cmp    $0x25,%ebx
  8004bd:	75 d6                	jne    800495 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004bf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004c3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004d8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	8d 50 01             	lea    0x1(%eax),%edx
  8004e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e8:	8a 00                	mov    (%eax),%al
  8004ea:	0f b6 d8             	movzbl %al,%ebx
  8004ed:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f0:	83 f8 55             	cmp    $0x55,%eax
  8004f3:	0f 87 2b 03 00 00    	ja     800824 <vprintfmt+0x399>
  8004f9:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  800500:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800502:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800506:	eb d7                	jmp    8004df <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800508:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80050c:	eb d1                	jmp    8004df <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	c1 e0 02             	shl    $0x2,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	01 c0                	add    %eax,%eax
  800521:	01 d8                	add    %ebx,%eax
  800523:	83 e8 30             	sub    $0x30,%eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800529:	8b 45 10             	mov    0x10(%ebp),%eax
  80052c:	8a 00                	mov    (%eax),%al
  80052e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800531:	83 fb 2f             	cmp    $0x2f,%ebx
  800534:	7e 3e                	jle    800574 <vprintfmt+0xe9>
  800536:	83 fb 39             	cmp    $0x39,%ebx
  800539:	7f 39                	jg     800574 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80053e:	eb d5                	jmp    800515 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	83 c0 04             	add    $0x4,%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	83 e8 04             	sub    $0x4,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800554:	eb 1f                	jmp    800575 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800556:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055a:	79 83                	jns    8004df <vprintfmt+0x54>
				width = 0;
  80055c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800563:	e9 77 ff ff ff       	jmp    8004df <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800568:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80056f:	e9 6b ff ff ff       	jmp    8004df <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800574:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800579:	0f 89 60 ff ff ff    	jns    8004df <vprintfmt+0x54>
				width = precision, precision = -1;
  80057f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800582:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800585:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80058c:	e9 4e ff ff ff       	jmp    8004df <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800591:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800594:	e9 46 ff ff ff       	jmp    8004df <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	83 c0 04             	add    $0x4,%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	83 e8 04             	sub    $0x4,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	ff d0                	call   *%eax
  8005b6:	83 c4 10             	add    $0x10,%esp
			break;
  8005b9:	e9 89 02 00 00       	jmp    800847 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 c0 04             	add    $0x4,%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005cf:	85 db                	test   %ebx,%ebx
  8005d1:	79 02                	jns    8005d5 <vprintfmt+0x14a>
				err = -err;
  8005d3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d5:	83 fb 64             	cmp    $0x64,%ebx
  8005d8:	7f 0b                	jg     8005e5 <vprintfmt+0x15a>
  8005da:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005e1:	85 f6                	test   %esi,%esi
  8005e3:	75 19                	jne    8005fe <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005e5:	53                   	push   %ebx
  8005e6:	68 e5 1c 80 00       	push   $0x801ce5
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 5e 02 00 00       	call   800854 <printfmt>
  8005f6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005f9:	e9 49 02 00 00       	jmp    800847 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005fe:	56                   	push   %esi
  8005ff:	68 ee 1c 80 00       	push   $0x801cee
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	e8 45 02 00 00       	call   800854 <printfmt>
  80060f:	83 c4 10             	add    $0x10,%esp
			break;
  800612:	e9 30 02 00 00       	jmp    800847 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 c0 04             	add    $0x4,%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 30                	mov    (%eax),%esi
  800628:	85 f6                	test   %esi,%esi
  80062a:	75 05                	jne    800631 <vprintfmt+0x1a6>
				p = "(null)";
  80062c:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  800631:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800635:	7e 6d                	jle    8006a4 <vprintfmt+0x219>
  800637:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80063b:	74 67                	je     8006a4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	50                   	push   %eax
  800644:	56                   	push   %esi
  800645:	e8 0c 03 00 00       	call   800956 <strnlen>
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800650:	eb 16                	jmp    800668 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800652:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 0c             	pushl  0xc(%ebp)
  80065c:	50                   	push   %eax
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	ff d0                	call   *%eax
  800662:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800665:	ff 4d e4             	decl   -0x1c(%ebp)
  800668:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066c:	7f e4                	jg     800652 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066e:	eb 34                	jmp    8006a4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800670:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800674:	74 1c                	je     800692 <vprintfmt+0x207>
  800676:	83 fb 1f             	cmp    $0x1f,%ebx
  800679:	7e 05                	jle    800680 <vprintfmt+0x1f5>
  80067b:	83 fb 7e             	cmp    $0x7e,%ebx
  80067e:	7e 12                	jle    800692 <vprintfmt+0x207>
					putch('?', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	6a 3f                	push   $0x3f
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	eb 0f                	jmp    8006a1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	53                   	push   %ebx
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	ff d0                	call   *%eax
  80069e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a4:	89 f0                	mov    %esi,%eax
  8006a6:	8d 70 01             	lea    0x1(%eax),%esi
  8006a9:	8a 00                	mov    (%eax),%al
  8006ab:	0f be d8             	movsbl %al,%ebx
  8006ae:	85 db                	test   %ebx,%ebx
  8006b0:	74 24                	je     8006d6 <vprintfmt+0x24b>
  8006b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b6:	78 b8                	js     800670 <vprintfmt+0x1e5>
  8006b8:	ff 4d e0             	decl   -0x20(%ebp)
  8006bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bf:	79 af                	jns    800670 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c1:	eb 13                	jmp    8006d6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	6a 20                	push   $0x20
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	ff d0                	call   *%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d3:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006da:	7f e7                	jg     8006c3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006dc:	e9 66 01 00 00       	jmp    800847 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	e8 3c fd ff ff       	call   80042c <getint>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ff:	85 d2                	test   %edx,%edx
  800701:	79 23                	jns    800726 <vprintfmt+0x29b>
				putch('-', putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	ff 75 0c             	pushl  0xc(%ebp)
  800709:	6a 2d                	push   $0x2d
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800719:	f7 d8                	neg    %eax
  80071b:	83 d2 00             	adc    $0x0,%edx
  80071e:	f7 da                	neg    %edx
  800720:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800723:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800726:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80072d:	e9 bc 00 00 00       	jmp    8007ee <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 e8             	pushl  -0x18(%ebp)
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
  80073b:	50                   	push   %eax
  80073c:	e8 84 fc ff ff       	call   8003c5 <getuint>
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800747:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80074a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800751:	e9 98 00 00 00       	jmp    8007ee <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	6a 58                	push   $0x58
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	6a 58                	push   $0x58
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	6a 58                	push   $0x58
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
			break;
  800786:	e9 bc 00 00 00       	jmp    800847 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	6a 30                	push   $0x30
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	6a 78                	push   $0x78
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	83 c0 04             	add    $0x4,%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 e8 04             	sub    $0x4,%eax
  8007ba:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007c6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007cd:	eb 1f                	jmp    8007ee <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	e8 e7 fb ff ff       	call   8003c5 <getuint>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007e7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ee:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f5:	83 ec 04             	sub    $0x4,%esp
  8007f8:	52                   	push   %edx
  8007f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007fc:	50                   	push   %eax
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	ff 75 f0             	pushl  -0x10(%ebp)
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	e8 00 fb ff ff       	call   80030e <printnum>
  80080e:	83 c4 20             	add    $0x20,%esp
			break;
  800811:	eb 34                	jmp    800847 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	53                   	push   %ebx
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			break;
  800822:	eb 23                	jmp    800847 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 25                	push   $0x25
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800834:	ff 4d 10             	decl   0x10(%ebp)
  800837:	eb 03                	jmp    80083c <vprintfmt+0x3b1>
  800839:	ff 4d 10             	decl   0x10(%ebp)
  80083c:	8b 45 10             	mov    0x10(%ebp),%eax
  80083f:	48                   	dec    %eax
  800840:	8a 00                	mov    (%eax),%al
  800842:	3c 25                	cmp    $0x25,%al
  800844:	75 f3                	jne    800839 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800846:	90                   	nop
		}
	}
  800847:	e9 47 fc ff ff       	jmp    800493 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80084c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80084d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800850:	5b                   	pop    %ebx
  800851:	5e                   	pop    %esi
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085a:	8d 45 10             	lea    0x10(%ebp),%eax
  80085d:	83 c0 04             	add    $0x4,%eax
  800860:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	ff 75 f4             	pushl  -0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 16 fc ff ff       	call   80048b <vprintfmt>
  800875:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800878:	90                   	nop
  800879:	c9                   	leave  
  80087a:	c3                   	ret    

0080087b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	8b 40 08             	mov    0x8(%eax),%eax
  800884:	8d 50 01             	lea    0x1(%eax),%edx
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80088d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800890:	8b 10                	mov    (%eax),%edx
  800892:	8b 45 0c             	mov    0xc(%ebp),%eax
  800895:	8b 40 04             	mov    0x4(%eax),%eax
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	73 12                	jae    8008ae <sprintputch+0x33>
		*b->buf++ = ch;
  80089c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a7:	89 0a                	mov    %ecx,(%edx)
  8008a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ac:	88 10                	mov    %dl,(%eax)
}
  8008ae:	90                   	nop
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	01 d0                	add    %edx,%eax
  8008c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008d6:	74 06                	je     8008de <vsnprintf+0x2d>
  8008d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008dc:	7f 07                	jg     8008e5 <vsnprintf+0x34>
		return -E_INVAL;
  8008de:	b8 03 00 00 00       	mov    $0x3,%eax
  8008e3:	eb 20                	jmp    800905 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e5:	ff 75 14             	pushl  0x14(%ebp)
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ee:	50                   	push   %eax
  8008ef:	68 7b 08 80 00       	push   $0x80087b
  8008f4:	e8 92 fb ff ff       	call   80048b <vprintfmt>
  8008f9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800902:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090d:	8d 45 10             	lea    0x10(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800916:	8b 45 10             	mov    0x10(%ebp),%eax
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 89 ff ff ff       	call   8008b1 <vsnprintf>
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80092e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800939:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800940:	eb 06                	jmp    800948 <strlen+0x15>
		n++;
  800942:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800945:	ff 45 08             	incl   0x8(%ebp)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8a 00                	mov    (%eax),%al
  80094d:	84 c0                	test   %al,%al
  80094f:	75 f1                	jne    800942 <strlen+0xf>
		n++;
	return n;
  800951:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800963:	eb 09                	jmp    80096e <strnlen+0x18>
		n++;
  800965:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800968:	ff 45 08             	incl   0x8(%ebp)
  80096b:	ff 4d 0c             	decl   0xc(%ebp)
  80096e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800972:	74 09                	je     80097d <strnlen+0x27>
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8a 00                	mov    (%eax),%al
  800979:	84 c0                	test   %al,%al
  80097b:	75 e8                	jne    800965 <strnlen+0xf>
		n++;
	return n;
  80097d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80098e:	90                   	nop
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8d 50 01             	lea    0x1(%eax),%edx
  800995:	89 55 08             	mov    %edx,0x8(%ebp)
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80099e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009a1:	8a 12                	mov    (%edx),%dl
  8009a3:	88 10                	mov    %dl,(%eax)
  8009a5:	8a 00                	mov    (%eax),%al
  8009a7:	84 c0                	test   %al,%al
  8009a9:	75 e4                	jne    80098f <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c3:	eb 1f                	jmp    8009e4 <strncpy+0x34>
		*dst++ = *src;
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8d 50 01             	lea    0x1(%eax),%edx
  8009cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d1:	8a 12                	mov    (%edx),%dl
  8009d3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d8:	8a 00                	mov    (%eax),%al
  8009da:	84 c0                	test   %al,%al
  8009dc:	74 03                	je     8009e1 <strncpy+0x31>
			src++;
  8009de:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e1:	ff 45 fc             	incl   -0x4(%ebp)
  8009e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009ea:	72 d9                	jb     8009c5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a01:	74 30                	je     800a33 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a03:	eb 16                	jmp    800a1b <strlcpy+0x2a>
			*dst++ = *src++;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8d 50 01             	lea    0x1(%eax),%edx
  800a0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a17:	8a 12                	mov    (%edx),%dl
  800a19:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a1b:	ff 4d 10             	decl   0x10(%ebp)
  800a1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a22:	74 09                	je     800a2d <strlcpy+0x3c>
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a27:	8a 00                	mov    (%eax),%al
  800a29:	84 c0                	test   %al,%al
  800a2b:	75 d8                	jne    800a05 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a33:	8b 55 08             	mov    0x8(%ebp),%edx
  800a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a39:	29 c2                	sub    %eax,%edx
  800a3b:	89 d0                	mov    %edx,%eax
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a42:	eb 06                	jmp    800a4a <strcmp+0xb>
		p++, q++;
  800a44:	ff 45 08             	incl   0x8(%ebp)
  800a47:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8a 00                	mov    (%eax),%al
  800a4f:	84 c0                	test   %al,%al
  800a51:	74 0e                	je     800a61 <strcmp+0x22>
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8a 10                	mov    (%eax),%dl
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	38 c2                	cmp    %al,%dl
  800a5f:	74 e3                	je     800a44 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	0f b6 d0             	movzbl %al,%edx
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	0f b6 c0             	movzbl %al,%eax
  800a71:	29 c2                	sub    %eax,%edx
  800a73:	89 d0                	mov    %edx,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a7a:	eb 09                	jmp    800a85 <strncmp+0xe>
		n--, p++, q++;
  800a7c:	ff 4d 10             	decl   0x10(%ebp)
  800a7f:	ff 45 08             	incl   0x8(%ebp)
  800a82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a89:	74 17                	je     800aa2 <strncmp+0x2b>
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8a 00                	mov    (%eax),%al
  800a90:	84 c0                	test   %al,%al
  800a92:	74 0e                	je     800aa2 <strncmp+0x2b>
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8a 10                	mov    (%eax),%dl
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	8a 00                	mov    (%eax),%al
  800a9e:	38 c2                	cmp    %al,%dl
  800aa0:	74 da                	je     800a7c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa6:	75 07                	jne    800aaf <strncmp+0x38>
		return 0;
  800aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aad:	eb 14                	jmp    800ac3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8a 00                	mov    (%eax),%al
  800ab4:	0f b6 d0             	movzbl %al,%edx
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	0f b6 c0             	movzbl %al,%eax
  800abf:	29 c2                	sub    %eax,%edx
  800ac1:	89 d0                	mov    %edx,%eax
}
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	83 ec 04             	sub    $0x4,%esp
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad1:	eb 12                	jmp    800ae5 <strchr+0x20>
		if (*s == c)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800adb:	75 05                	jne    800ae2 <strchr+0x1d>
			return (char *) s;
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	eb 11                	jmp    800af3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ae2:	ff 45 08             	incl   0x8(%ebp)
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8a 00                	mov    (%eax),%al
  800aea:	84 c0                	test   %al,%al
  800aec:	75 e5                	jne    800ad3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 04             	sub    $0x4,%esp
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b01:	eb 0d                	jmp    800b10 <strfind+0x1b>
		if (*s == c)
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8a 00                	mov    (%eax),%al
  800b08:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b0b:	74 0e                	je     800b1b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b0d:	ff 45 08             	incl   0x8(%ebp)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	84 c0                	test   %al,%al
  800b17:	75 ea                	jne    800b03 <strfind+0xe>
  800b19:	eb 01                	jmp    800b1c <strfind+0x27>
		if (*s == c)
			break;
  800b1b:	90                   	nop
	return (char *) s;
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b33:	eb 0e                	jmp    800b43 <memset+0x22>
		*p++ = c;
  800b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b38:	8d 50 01             	lea    0x1(%eax),%edx
  800b3b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b43:	ff 4d f8             	decl   -0x8(%ebp)
  800b46:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b4a:	79 e9                	jns    800b35 <memset+0x14>
		*p++ = c;

	return v;
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b63:	eb 16                	jmp    800b7b <memcpy+0x2a>
		*d++ = *s++;
  800b65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b68:	8d 50 01             	lea    0x1(%eax),%edx
  800b6b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b74:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b77:	8a 12                	mov    (%edx),%dl
  800b79:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b81:	89 55 10             	mov    %edx,0x10(%ebp)
  800b84:	85 c0                	test   %eax,%eax
  800b86:	75 dd                	jne    800b65 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ba5:	73 50                	jae    800bf7 <memmove+0x6a>
  800ba7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	01 d0                	add    %edx,%eax
  800baf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb2:	76 43                	jbe    800bf7 <memmove+0x6a>
		s += n;
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc0:	eb 10                	jmp    800bd2 <memmove+0x45>
			*--d = *--s;
  800bc2:	ff 4d f8             	decl   -0x8(%ebp)
  800bc5:	ff 4d fc             	decl   -0x4(%ebp)
  800bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcb:	8a 10                	mov    (%eax),%dl
  800bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	75 e3                	jne    800bc2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdf:	eb 23                	jmp    800c04 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bed:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bf3:	8a 12                	mov    (%edx),%dl
  800bf5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800c00:	85 c0                	test   %eax,%eax
  800c02:	75 dd                	jne    800be1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c1b:	eb 2a                	jmp    800c47 <memcmp+0x3e>
		if (*s1 != *s2)
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c20:	8a 10                	mov    (%eax),%dl
  800c22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	38 c2                	cmp    %al,%dl
  800c29:	74 16                	je     800c41 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f b6 d0             	movzbl %al,%edx
  800c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	0f b6 c0             	movzbl %al,%eax
  800c3b:	29 c2                	sub    %eax,%edx
  800c3d:	89 d0                	mov    %edx,%eax
  800c3f:	eb 18                	jmp    800c59 <memcmp+0x50>
		s1++, s2++;
  800c41:	ff 45 fc             	incl   -0x4(%ebp)
  800c44:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c50:	85 c0                	test   %eax,%eax
  800c52:	75 c9                	jne    800c1d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	01 d0                	add    %edx,%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c6c:	eb 15                	jmp    800c83 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	0f b6 d0             	movzbl %al,%edx
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	0f b6 c0             	movzbl %al,%eax
  800c7c:	39 c2                	cmp    %eax,%edx
  800c7e:	74 0d                	je     800c8d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c89:	72 e3                	jb     800c6e <memfind+0x13>
  800c8b:	eb 01                	jmp    800c8e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c8d:	90                   	nop
	return (void *) s;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca7:	eb 03                	jmp    800cac <strtol+0x19>
		s++;
  800ca9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3c 20                	cmp    $0x20,%al
  800cb3:	74 f4                	je     800ca9 <strtol+0x16>
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 09                	cmp    $0x9,%al
  800cbc:	74 eb                	je     800ca9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3c 2b                	cmp    $0x2b,%al
  800cc5:	75 05                	jne    800ccc <strtol+0x39>
		s++;
  800cc7:	ff 45 08             	incl   0x8(%ebp)
  800cca:	eb 13                	jmp    800cdf <strtol+0x4c>
	else if (*s == '-')
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3c 2d                	cmp    $0x2d,%al
  800cd3:	75 0a                	jne    800cdf <strtol+0x4c>
		s++, neg = 1;
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce3:	74 06                	je     800ceb <strtol+0x58>
  800ce5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ce9:	75 20                	jne    800d0b <strtol+0x78>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	3c 30                	cmp    $0x30,%al
  800cf2:	75 17                	jne    800d0b <strtol+0x78>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	40                   	inc    %eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	3c 78                	cmp    $0x78,%al
  800cfc:	75 0d                	jne    800d0b <strtol+0x78>
		s += 2, base = 16;
  800cfe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d02:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d09:	eb 28                	jmp    800d33 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0f:	75 15                	jne    800d26 <strtol+0x93>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	3c 30                	cmp    $0x30,%al
  800d18:	75 0c                	jne    800d26 <strtol+0x93>
		s++, base = 8;
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d24:	eb 0d                	jmp    800d33 <strtol+0xa0>
	else if (base == 0)
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	75 07                	jne    800d33 <strtol+0xa0>
		base = 10;
  800d2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3c 2f                	cmp    $0x2f,%al
  800d3a:	7e 19                	jle    800d55 <strtol+0xc2>
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 39                	cmp    $0x39,%al
  800d43:	7f 10                	jg     800d55 <strtol+0xc2>
			dig = *s - '0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	0f be c0             	movsbl %al,%eax
  800d4d:	83 e8 30             	sub    $0x30,%eax
  800d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d53:	eb 42                	jmp    800d97 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 60                	cmp    $0x60,%al
  800d5c:	7e 19                	jle    800d77 <strtol+0xe4>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 7a                	cmp    $0x7a,%al
  800d65:	7f 10                	jg     800d77 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f be c0             	movsbl %al,%eax
  800d6f:	83 e8 57             	sub    $0x57,%eax
  800d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d75:	eb 20                	jmp    800d97 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 40                	cmp    $0x40,%al
  800d7e:	7e 39                	jle    800db9 <strtol+0x126>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 5a                	cmp    $0x5a,%al
  800d87:	7f 30                	jg     800db9 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f be c0             	movsbl %al,%eax
  800d91:	83 e8 37             	sub    $0x37,%eax
  800d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9d:	7d 19                	jge    800db8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800da9:	89 c2                	mov    %eax,%edx
  800dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dae:	01 d0                	add    %edx,%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800db3:	e9 7b ff ff ff       	jmp    800d33 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800db8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbd:	74 08                	je     800dc7 <strtol+0x134>
		*endptr = (char *) s;
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dcb:	74 07                	je     800dd4 <strtol+0x141>
  800dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd0:	f7 d8                	neg    %eax
  800dd2:	eb 03                	jmp    800dd7 <strtol+0x144>
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dd7:	c9                   	leave  
  800dd8:	c3                   	ret    

00800dd9 <ltostr>:

void
ltostr(long value, char *str)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ddf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800de6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ded:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df1:	79 13                	jns    800e06 <ltostr+0x2d>
	{
		neg = 1;
  800df3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e00:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e03:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e0e:	99                   	cltd   
  800e0f:	f7 f9                	idiv   %ecx
  800e11:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e17:	8d 50 01             	lea    0x1(%eax),%edx
  800e1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1d:	89 c2                	mov    %eax,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	01 d0                	add    %edx,%eax
  800e24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e27:	83 c2 30             	add    $0x30,%edx
  800e2a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e2f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e34:	f7 e9                	imul   %ecx
  800e36:	c1 fa 02             	sar    $0x2,%edx
  800e39:	89 c8                	mov    %ecx,%eax
  800e3b:	c1 f8 1f             	sar    $0x1f,%eax
  800e3e:	29 c2                	sub    %eax,%edx
  800e40:	89 d0                	mov    %edx,%eax
  800e42:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e48:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e4d:	f7 e9                	imul   %ecx
  800e4f:	c1 fa 02             	sar    $0x2,%edx
  800e52:	89 c8                	mov    %ecx,%eax
  800e54:	c1 f8 1f             	sar    $0x1f,%eax
  800e57:	29 c2                	sub    %eax,%edx
  800e59:	89 d0                	mov    %edx,%eax
  800e5b:	c1 e0 02             	shl    $0x2,%eax
  800e5e:	01 d0                	add    %edx,%eax
  800e60:	01 c0                	add    %eax,%eax
  800e62:	29 c1                	sub    %eax,%ecx
  800e64:	89 ca                	mov    %ecx,%edx
  800e66:	85 d2                	test   %edx,%edx
  800e68:	75 9c                	jne    800e06 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	48                   	dec    %eax
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7c:	74 3d                	je     800ebb <ltostr+0xe2>
		start = 1 ;
  800e7e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e85:	eb 34                	jmp    800ebb <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	01 d0                	add    %edx,%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	01 c2                	add    %eax,%edx
  800e9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	01 c8                	add    %ecx,%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	01 c2                	add    %eax,%edx
  800eb0:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eb3:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eb8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ec1:	7c c4                	jl     800e87 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ec3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	01 d0                	add    %edx,%eax
  800ecb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ece:	90                   	nop
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ed7:	ff 75 08             	pushl  0x8(%ebp)
  800eda:	e8 54 fa ff ff       	call   800933 <strlen>
  800edf:	83 c4 04             	add    $0x4,%esp
  800ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	e8 46 fa ff ff       	call   800933 <strlen>
  800eed:	83 c4 04             	add    $0x4,%esp
  800ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800efa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f01:	eb 17                	jmp    800f1a <strcconcat+0x49>
		final[s] = str1[s] ;
  800f03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f06:	8b 45 10             	mov    0x10(%ebp),%eax
  800f09:	01 c2                	add    %eax,%edx
  800f0b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	01 c8                	add    %ecx,%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
  800f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f20:	7c e1                	jl     800f03 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f29:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f30:	eb 1f                	jmp    800f51 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3b:	89 c2                	mov    %eax,%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 c2                	add    %eax,%edx
  800f42:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	01 c8                	add    %ecx,%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f4e:	ff 45 f8             	incl   -0x8(%ebp)
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f57:	7c d9                	jl     800f32 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	01 d0                	add    %edx,%eax
  800f61:	c6 00 00             	movb   $0x0,(%eax)
}
  800f64:	90                   	nop
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	8b 00                	mov    (%eax),%eax
  800f78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f8a:	eb 0c                	jmp    800f98 <strsplit+0x31>
			*string++ = 0;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8d 50 01             	lea    0x1(%eax),%edx
  800f92:	89 55 08             	mov    %edx,0x8(%ebp)
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	84 c0                	test   %al,%al
  800f9f:	74 18                	je     800fb9 <strsplit+0x52>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f be c0             	movsbl %al,%eax
  800fa9:	50                   	push   %eax
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	e8 13 fb ff ff       	call   800ac5 <strchr>
  800fb2:	83 c4 08             	add    $0x8,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	75 d3                	jne    800f8c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 5a                	je     80101c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc5:	8b 00                	mov    (%eax),%eax
  800fc7:	83 f8 0f             	cmp    $0xf,%eax
  800fca:	75 07                	jne    800fd3 <strsplit+0x6c>
		{
			return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd1:	eb 66                	jmp    801039 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	8d 48 01             	lea    0x1(%eax),%ecx
  800fdb:	8b 55 14             	mov    0x14(%ebp),%edx
  800fde:	89 0a                	mov    %ecx,(%edx)
  800fe0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	01 c2                	add    %eax,%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff1:	eb 03                	jmp    800ff6 <strsplit+0x8f>
			string++;
  800ff3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	84 c0                	test   %al,%al
  800ffd:	74 8b                	je     800f8a <strsplit+0x23>
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	0f be c0             	movsbl %al,%eax
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	e8 b5 fa ff ff       	call   800ac5 <strchr>
  801010:	83 c4 08             	add    $0x8,%esp
  801013:	85 c0                	test   %eax,%eax
  801015:	74 dc                	je     800ff3 <strsplit+0x8c>
			string++;
	}
  801017:	e9 6e ff ff ff       	jmp    800f8a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80101c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80101d:	8b 45 14             	mov    0x14(%ebp),%eax
  801020:	8b 00                	mov    (%eax),%eax
  801022:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801034:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801048:	eb 4c                	jmp    801096 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80104a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	01 d0                	add    %edx,%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 40                	cmp    $0x40,%al
  801056:	7e 27                	jle    80107f <str2lower+0x44>
  801058:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 5a                	cmp    $0x5a,%al
  801064:	7f 19                	jg     80107f <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801066:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	01 d0                	add    %edx,%eax
  80106e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	01 ca                	add    %ecx,%edx
  801076:	8a 12                	mov    (%edx),%dl
  801078:	83 c2 20             	add    $0x20,%edx
  80107b:	88 10                	mov    %dl,(%eax)
  80107d:	eb 14                	jmp    801093 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80107f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 c2                	add    %eax,%edx
  801087:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	01 c8                	add    %ecx,%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801093:	ff 45 fc             	incl   -0x4(%ebp)
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	e8 95 f8 ff ff       	call   800933 <strlen>
  80109e:	83 c4 04             	add    $0x4,%esp
  8010a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a4:	7f a4                	jg     80104a <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010c2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010c5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010c8:	cd 30                	int    $0x30
  8010ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    

008010d8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 04             	sub    $0x4,%esp
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 00                	push   $0x0
  8010ef:	52                   	push   %edx
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	50                   	push   %eax
  8010f4:	6a 00                	push   $0x0
  8010f6:	e8 b2 ff ff ff       	call   8010ad <syscall>
  8010fb:	83 c4 18             	add    $0x18,%esp
}
  8010fe:	90                   	nop
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <sys_cgetc>:

int
sys_cgetc(void)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 01                	push   $0x1
  801110:	e8 98 ff ff ff       	call   8010ad <syscall>
  801115:	83 c4 18             	add    $0x18,%esp
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80111d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	52                   	push   %edx
  80112a:	50                   	push   %eax
  80112b:	6a 05                	push   $0x5
  80112d:	e8 7b ff ff ff       	call   8010ad <syscall>
  801132:	83 c4 18             	add    $0x18,%esp
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80113c:	8b 75 18             	mov    0x18(%ebp),%esi
  80113f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801142:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801145:	8b 55 0c             	mov    0xc(%ebp),%edx
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
  80114d:	51                   	push   %ecx
  80114e:	52                   	push   %edx
  80114f:	50                   	push   %eax
  801150:	6a 06                	push   $0x6
  801152:	e8 56 ff ff ff       	call   8010ad <syscall>
  801157:	83 c4 18             	add    $0x18,%esp
}
  80115a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801164:	8b 55 0c             	mov    0xc(%ebp),%edx
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	52                   	push   %edx
  801171:	50                   	push   %eax
  801172:	6a 07                	push   $0x7
  801174:	e8 34 ff ff ff       	call   8010ad <syscall>
  801179:	83 c4 18             	add    $0x18,%esp
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	ff 75 0c             	pushl  0xc(%ebp)
  80118a:	ff 75 08             	pushl  0x8(%ebp)
  80118d:	6a 08                	push   $0x8
  80118f:	e8 19 ff ff ff       	call   8010ad <syscall>
  801194:	83 c4 18             	add    $0x18,%esp
}
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 09                	push   $0x9
  8011a8:	e8 00 ff ff ff       	call   8010ad <syscall>
  8011ad:	83 c4 18             	add    $0x18,%esp
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 0a                	push   $0xa
  8011c1:	e8 e7 fe ff ff       	call   8010ad <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 0b                	push   $0xb
  8011da:	e8 ce fe ff ff       	call   8010ad <syscall>
  8011df:	83 c4 18             	add    $0x18,%esp
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 0c                	push   $0xc
  8011f3:	e8 b5 fe ff ff       	call   8010ad <syscall>
  8011f8:	83 c4 18             	add    $0x18,%esp
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	ff 75 08             	pushl  0x8(%ebp)
  80120b:	6a 0d                	push   $0xd
  80120d:	e8 9b fe ff ff       	call   8010ad <syscall>
  801212:	83 c4 18             	add    $0x18,%esp
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 0e                	push   $0xe
  801226:	e8 82 fe ff ff       	call   8010ad <syscall>
  80122b:	83 c4 18             	add    $0x18,%esp
}
  80122e:	90                   	nop
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 11                	push   $0x11
  801240:	e8 68 fe ff ff       	call   8010ad <syscall>
  801245:	83 c4 18             	add    $0x18,%esp
}
  801248:	90                   	nop
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 12                	push   $0x12
  80125a:	e8 4e fe ff ff       	call   8010ad <syscall>
  80125f:	83 c4 18             	add    $0x18,%esp
}
  801262:	90                   	nop
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <sys_cputc>:


void
sys_cputc(const char c)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801271:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	50                   	push   %eax
  80127e:	6a 13                	push   $0x13
  801280:	e8 28 fe ff ff       	call   8010ad <syscall>
  801285:	83 c4 18             	add    $0x18,%esp
}
  801288:	90                   	nop
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 14                	push   $0x14
  80129a:	e8 0e fe ff ff       	call   8010ad <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	6a 15                	push   $0x15
  8012b7:	e8 f1 fd ff ff       	call   8010ad <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	52                   	push   %edx
  8012d1:	50                   	push   %eax
  8012d2:	6a 18                	push   $0x18
  8012d4:	e8 d4 fd ff ff       	call   8010ad <syscall>
  8012d9:	83 c4 18             	add    $0x18,%esp
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	52                   	push   %edx
  8012ee:	50                   	push   %eax
  8012ef:	6a 16                	push   $0x16
  8012f1:	e8 b7 fd ff ff       	call   8010ad <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	90                   	nop
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	52                   	push   %edx
  80130c:	50                   	push   %eax
  80130d:	6a 17                	push   $0x17
  80130f:	e8 99 fd ff ff       	call   8010ad <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	90                   	nop
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 04             	sub    $0x4,%esp
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801326:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801329:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	6a 00                	push   $0x0
  801332:	51                   	push   %ecx
  801333:	52                   	push   %edx
  801334:	ff 75 0c             	pushl  0xc(%ebp)
  801337:	50                   	push   %eax
  801338:	6a 19                	push   $0x19
  80133a:	e8 6e fd ff ff       	call   8010ad <syscall>
  80133f:	83 c4 18             	add    $0x18,%esp
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	52                   	push   %edx
  801354:	50                   	push   %eax
  801355:	6a 1a                	push   $0x1a
  801357:	e8 51 fd ff ff       	call   8010ad <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801364:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	51                   	push   %ecx
  801372:	52                   	push   %edx
  801373:	50                   	push   %eax
  801374:	6a 1b                	push   $0x1b
  801376:	e8 32 fd ff ff       	call   8010ad <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	52                   	push   %edx
  801390:	50                   	push   %eax
  801391:	6a 1c                	push   $0x1c
  801393:	e8 15 fd ff ff       	call   8010ad <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 1d                	push   $0x1d
  8013ac:	e8 fc fc ff ff       	call   8010ad <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	6a 00                	push   $0x0
  8013be:	ff 75 14             	pushl  0x14(%ebp)
  8013c1:	ff 75 10             	pushl  0x10(%ebp)
  8013c4:	ff 75 0c             	pushl  0xc(%ebp)
  8013c7:	50                   	push   %eax
  8013c8:	6a 1e                	push   $0x1e
  8013ca:	e8 de fc ff ff       	call   8010ad <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	50                   	push   %eax
  8013e3:	6a 1f                	push   $0x1f
  8013e5:	e8 c3 fc ff ff       	call   8010ad <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
}
  8013ed:	90                   	nop
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	50                   	push   %eax
  8013ff:	6a 20                	push   $0x20
  801401:	e8 a7 fc ff ff       	call   8010ad <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 02                	push   $0x2
  80141a:	e8 8e fc ff ff       	call   8010ad <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 03                	push   $0x3
  801433:	e8 75 fc ff ff       	call   8010ad <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 04                	push   $0x4
  80144c:	e8 5c fc ff ff       	call   8010ad <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_exit_env>:


void sys_exit_env(void)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 21                	push   $0x21
  801465:	e8 43 fc ff ff       	call   8010ad <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801476:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801479:	8d 50 04             	lea    0x4(%eax),%edx
  80147c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	52                   	push   %edx
  801486:	50                   	push   %eax
  801487:	6a 22                	push   $0x22
  801489:	e8 1f fc ff ff       	call   8010ad <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
	return result;
  801491:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149a:	89 01                	mov    %eax,(%ecx)
  80149c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	c9                   	leave  
  8014a3:	c2 04 00             	ret    $0x4

008014a6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	ff 75 10             	pushl  0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	6a 10                	push   $0x10
  8014b8:	e8 f0 fb ff ff       	call   8010ad <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c0:	90                   	nop
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 23                	push   $0x23
  8014d2:	e8 d6 fb ff ff       	call   8010ad <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014e8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	50                   	push   %eax
  8014f5:	6a 24                	push   $0x24
  8014f7:	e8 b1 fb ff ff       	call   8010ad <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ff:	90                   	nop
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <rsttst>:
void rsttst()
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 26                	push   $0x26
  801511:	e8 97 fb ff ff       	call   8010ad <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
	return ;
  801519:	90                   	nop
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	8b 45 14             	mov    0x14(%ebp),%eax
  801525:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801528:	8b 55 18             	mov    0x18(%ebp),%edx
  80152b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80152f:	52                   	push   %edx
  801530:	50                   	push   %eax
  801531:	ff 75 10             	pushl  0x10(%ebp)
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	ff 75 08             	pushl  0x8(%ebp)
  80153a:	6a 25                	push   $0x25
  80153c:	e8 6c fb ff ff       	call   8010ad <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
	return ;
  801544:	90                   	nop
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <chktst>:
void chktst(uint32 n)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	6a 27                	push   $0x27
  801557:	e8 51 fb ff ff       	call   8010ad <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
	return ;
  80155f:	90                   	nop
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <inctst>:

void inctst()
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 28                	push   $0x28
  801571:	e8 37 fb ff ff       	call   8010ad <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
	return ;
  801579:	90                   	nop
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <gettst>:
uint32 gettst()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 29                	push   $0x29
  80158b:	e8 1d fb ff ff       	call   8010ad <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 2a                	push   $0x2a
  8015a7:	e8 01 fb ff ff       	call   8010ad <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
  8015af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015b2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015b6:	75 07                	jne    8015bf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8015bd:	eb 05                	jmp    8015c4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 2a                	push   $0x2a
  8015d8:	e8 d0 fa ff ff       	call   8010ad <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
  8015e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015e3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015e7:	75 07                	jne    8015f0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ee:	eb 05                	jmp    8015f5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 2a                	push   $0x2a
  801609:	e8 9f fa ff ff       	call   8010ad <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
  801611:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801614:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801618:	75 07                	jne    801621 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80161a:	b8 01 00 00 00       	mov    $0x1,%eax
  80161f:	eb 05                	jmp    801626 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801621:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 2a                	push   $0x2a
  80163a:	e8 6e fa ff ff       	call   8010ad <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
  801642:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801645:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801649:	75 07                	jne    801652 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80164b:	b8 01 00 00 00       	mov    $0x1,%eax
  801650:	eb 05                	jmp    801657 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 2b                	push   $0x2b
  801669:	e8 3f fa ff ff       	call   8010ad <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
	return ;
  801671:	90                   	nop
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801678:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	6a 00                	push   $0x0
  801686:	53                   	push   %ebx
  801687:	51                   	push   %ecx
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 2c                	push   $0x2c
  80168c:	e8 1c fa ff ff       	call   8010ad <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 2d                	push   $0x2d
  8016ac:	e8 fc f9 ff ff       	call   8010ad <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	6a 00                	push   $0x0
  8016c4:	51                   	push   %ecx
  8016c5:	ff 75 10             	pushl  0x10(%ebp)
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 2e                	push   $0x2e
  8016cc:	e8 dc f9 ff ff       	call   8010ad <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	6a 0f                	push   $0xf
  8016e8:	e8 c0 f9 ff ff       	call   8010ad <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	50                   	push   %eax
  801702:	6a 2f                	push   $0x2f
  801704:	e8 a4 f9 ff ff       	call   8010ad <syscall>
  801709:	83 c4 18             	add    $0x18,%esp

}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	6a 30                	push   $0x30
  80171f:	e8 89 f9 ff ff       	call   8010ad <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
	return;
  801727:	90                   	nop
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	6a 31                	push   $0x31
  80173b:	e8 6d f9 ff ff       	call   8010ad <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 32                	push   $0x32
  801755:	e8 53 f9 ff ff       	call   8010ad <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	50                   	push   %eax
  80176e:	6a 33                	push   $0x33
  801770:	e8 38 f9 ff ff       	call   8010ad <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    
  80177b:	90                   	nop

0080177c <__udivdi3>:
  80177c:	55                   	push   %ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 1c             	sub    $0x1c,%esp
  801783:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801787:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80178b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80178f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801793:	89 ca                	mov    %ecx,%edx
  801795:	89 f8                	mov    %edi,%eax
  801797:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80179b:	85 f6                	test   %esi,%esi
  80179d:	75 2d                	jne    8017cc <__udivdi3+0x50>
  80179f:	39 cf                	cmp    %ecx,%edi
  8017a1:	77 65                	ja     801808 <__udivdi3+0x8c>
  8017a3:	89 fd                	mov    %edi,%ebp
  8017a5:	85 ff                	test   %edi,%edi
  8017a7:	75 0b                	jne    8017b4 <__udivdi3+0x38>
  8017a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ae:	31 d2                	xor    %edx,%edx
  8017b0:	f7 f7                	div    %edi
  8017b2:	89 c5                	mov    %eax,%ebp
  8017b4:	31 d2                	xor    %edx,%edx
  8017b6:	89 c8                	mov    %ecx,%eax
  8017b8:	f7 f5                	div    %ebp
  8017ba:	89 c1                	mov    %eax,%ecx
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	f7 f5                	div    %ebp
  8017c0:	89 cf                	mov    %ecx,%edi
  8017c2:	89 fa                	mov    %edi,%edx
  8017c4:	83 c4 1c             	add    $0x1c,%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5f                   	pop    %edi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
  8017cc:	39 ce                	cmp    %ecx,%esi
  8017ce:	77 28                	ja     8017f8 <__udivdi3+0x7c>
  8017d0:	0f bd fe             	bsr    %esi,%edi
  8017d3:	83 f7 1f             	xor    $0x1f,%edi
  8017d6:	75 40                	jne    801818 <__udivdi3+0x9c>
  8017d8:	39 ce                	cmp    %ecx,%esi
  8017da:	72 0a                	jb     8017e6 <__udivdi3+0x6a>
  8017dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017e0:	0f 87 9e 00 00 00    	ja     801884 <__udivdi3+0x108>
  8017e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017eb:	89 fa                	mov    %edi,%edx
  8017ed:	83 c4 1c             	add    $0x1c,%esp
  8017f0:	5b                   	pop    %ebx
  8017f1:	5e                   	pop    %esi
  8017f2:	5f                   	pop    %edi
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    
  8017f5:	8d 76 00             	lea    0x0(%esi),%esi
  8017f8:	31 ff                	xor    %edi,%edi
  8017fa:	31 c0                	xor    %eax,%eax
  8017fc:	89 fa                	mov    %edi,%edx
  8017fe:	83 c4 1c             	add    $0x1c,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
  801806:	66 90                	xchg   %ax,%ax
  801808:	89 d8                	mov    %ebx,%eax
  80180a:	f7 f7                	div    %edi
  80180c:	31 ff                	xor    %edi,%edi
  80180e:	89 fa                	mov    %edi,%edx
  801810:	83 c4 1c             	add    $0x1c,%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
  801818:	bd 20 00 00 00       	mov    $0x20,%ebp
  80181d:	89 eb                	mov    %ebp,%ebx
  80181f:	29 fb                	sub    %edi,%ebx
  801821:	89 f9                	mov    %edi,%ecx
  801823:	d3 e6                	shl    %cl,%esi
  801825:	89 c5                	mov    %eax,%ebp
  801827:	88 d9                	mov    %bl,%cl
  801829:	d3 ed                	shr    %cl,%ebp
  80182b:	89 e9                	mov    %ebp,%ecx
  80182d:	09 f1                	or     %esi,%ecx
  80182f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801833:	89 f9                	mov    %edi,%ecx
  801835:	d3 e0                	shl    %cl,%eax
  801837:	89 c5                	mov    %eax,%ebp
  801839:	89 d6                	mov    %edx,%esi
  80183b:	88 d9                	mov    %bl,%cl
  80183d:	d3 ee                	shr    %cl,%esi
  80183f:	89 f9                	mov    %edi,%ecx
  801841:	d3 e2                	shl    %cl,%edx
  801843:	8b 44 24 08          	mov    0x8(%esp),%eax
  801847:	88 d9                	mov    %bl,%cl
  801849:	d3 e8                	shr    %cl,%eax
  80184b:	09 c2                	or     %eax,%edx
  80184d:	89 d0                	mov    %edx,%eax
  80184f:	89 f2                	mov    %esi,%edx
  801851:	f7 74 24 0c          	divl   0xc(%esp)
  801855:	89 d6                	mov    %edx,%esi
  801857:	89 c3                	mov    %eax,%ebx
  801859:	f7 e5                	mul    %ebp
  80185b:	39 d6                	cmp    %edx,%esi
  80185d:	72 19                	jb     801878 <__udivdi3+0xfc>
  80185f:	74 0b                	je     80186c <__udivdi3+0xf0>
  801861:	89 d8                	mov    %ebx,%eax
  801863:	31 ff                	xor    %edi,%edi
  801865:	e9 58 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  80186a:	66 90                	xchg   %ax,%ax
  80186c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801870:	89 f9                	mov    %edi,%ecx
  801872:	d3 e2                	shl    %cl,%edx
  801874:	39 c2                	cmp    %eax,%edx
  801876:	73 e9                	jae    801861 <__udivdi3+0xe5>
  801878:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80187b:	31 ff                	xor    %edi,%edi
  80187d:	e9 40 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  801882:	66 90                	xchg   %ax,%ax
  801884:	31 c0                	xor    %eax,%eax
  801886:	e9 37 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  80188b:	90                   	nop

0080188c <__umoddi3>:
  80188c:	55                   	push   %ebp
  80188d:	57                   	push   %edi
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
  801890:	83 ec 1c             	sub    $0x1c,%esp
  801893:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801897:	8b 74 24 34          	mov    0x34(%esp),%esi
  80189b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80189f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018ab:	89 f3                	mov    %esi,%ebx
  8018ad:	89 fa                	mov    %edi,%edx
  8018af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018b3:	89 34 24             	mov    %esi,(%esp)
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	75 1a                	jne    8018d4 <__umoddi3+0x48>
  8018ba:	39 f7                	cmp    %esi,%edi
  8018bc:	0f 86 a2 00 00 00    	jbe    801964 <__umoddi3+0xd8>
  8018c2:	89 c8                	mov    %ecx,%eax
  8018c4:	89 f2                	mov    %esi,%edx
  8018c6:	f7 f7                	div    %edi
  8018c8:	89 d0                	mov    %edx,%eax
  8018ca:	31 d2                	xor    %edx,%edx
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    
  8018d4:	39 f0                	cmp    %esi,%eax
  8018d6:	0f 87 ac 00 00 00    	ja     801988 <__umoddi3+0xfc>
  8018dc:	0f bd e8             	bsr    %eax,%ebp
  8018df:	83 f5 1f             	xor    $0x1f,%ebp
  8018e2:	0f 84 ac 00 00 00    	je     801994 <__umoddi3+0x108>
  8018e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8018ed:	29 ef                	sub    %ebp,%edi
  8018ef:	89 fe                	mov    %edi,%esi
  8018f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018f5:	89 e9                	mov    %ebp,%ecx
  8018f7:	d3 e0                	shl    %cl,%eax
  8018f9:	89 d7                	mov    %edx,%edi
  8018fb:	89 f1                	mov    %esi,%ecx
  8018fd:	d3 ef                	shr    %cl,%edi
  8018ff:	09 c7                	or     %eax,%edi
  801901:	89 e9                	mov    %ebp,%ecx
  801903:	d3 e2                	shl    %cl,%edx
  801905:	89 14 24             	mov    %edx,(%esp)
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	d3 e0                	shl    %cl,%eax
  80190c:	89 c2                	mov    %eax,%edx
  80190e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801912:	d3 e0                	shl    %cl,%eax
  801914:	89 44 24 04          	mov    %eax,0x4(%esp)
  801918:	8b 44 24 08          	mov    0x8(%esp),%eax
  80191c:	89 f1                	mov    %esi,%ecx
  80191e:	d3 e8                	shr    %cl,%eax
  801920:	09 d0                	or     %edx,%eax
  801922:	d3 eb                	shr    %cl,%ebx
  801924:	89 da                	mov    %ebx,%edx
  801926:	f7 f7                	div    %edi
  801928:	89 d3                	mov    %edx,%ebx
  80192a:	f7 24 24             	mull   (%esp)
  80192d:	89 c6                	mov    %eax,%esi
  80192f:	89 d1                	mov    %edx,%ecx
  801931:	39 d3                	cmp    %edx,%ebx
  801933:	0f 82 87 00 00 00    	jb     8019c0 <__umoddi3+0x134>
  801939:	0f 84 91 00 00 00    	je     8019d0 <__umoddi3+0x144>
  80193f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801943:	29 f2                	sub    %esi,%edx
  801945:	19 cb                	sbb    %ecx,%ebx
  801947:	89 d8                	mov    %ebx,%eax
  801949:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80194d:	d3 e0                	shl    %cl,%eax
  80194f:	89 e9                	mov    %ebp,%ecx
  801951:	d3 ea                	shr    %cl,%edx
  801953:	09 d0                	or     %edx,%eax
  801955:	89 e9                	mov    %ebp,%ecx
  801957:	d3 eb                	shr    %cl,%ebx
  801959:	89 da                	mov    %ebx,%edx
  80195b:	83 c4 1c             	add    $0x1c,%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5f                   	pop    %edi
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    
  801963:	90                   	nop
  801964:	89 fd                	mov    %edi,%ebp
  801966:	85 ff                	test   %edi,%edi
  801968:	75 0b                	jne    801975 <__umoddi3+0xe9>
  80196a:	b8 01 00 00 00       	mov    $0x1,%eax
  80196f:	31 d2                	xor    %edx,%edx
  801971:	f7 f7                	div    %edi
  801973:	89 c5                	mov    %eax,%ebp
  801975:	89 f0                	mov    %esi,%eax
  801977:	31 d2                	xor    %edx,%edx
  801979:	f7 f5                	div    %ebp
  80197b:	89 c8                	mov    %ecx,%eax
  80197d:	f7 f5                	div    %ebp
  80197f:	89 d0                	mov    %edx,%eax
  801981:	e9 44 ff ff ff       	jmp    8018ca <__umoddi3+0x3e>
  801986:	66 90                	xchg   %ax,%ax
  801988:	89 c8                	mov    %ecx,%eax
  80198a:	89 f2                	mov    %esi,%edx
  80198c:	83 c4 1c             	add    $0x1c,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
  801994:	3b 04 24             	cmp    (%esp),%eax
  801997:	72 06                	jb     80199f <__umoddi3+0x113>
  801999:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80199d:	77 0f                	ja     8019ae <__umoddi3+0x122>
  80199f:	89 f2                	mov    %esi,%edx
  8019a1:	29 f9                	sub    %edi,%ecx
  8019a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019a7:	89 14 24             	mov    %edx,(%esp)
  8019aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019b2:	8b 14 24             	mov    (%esp),%edx
  8019b5:	83 c4 1c             	add    $0x1c,%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5f                   	pop    %edi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    
  8019bd:	8d 76 00             	lea    0x0(%esi),%esi
  8019c0:	2b 04 24             	sub    (%esp),%eax
  8019c3:	19 fa                	sbb    %edi,%edx
  8019c5:	89 d1                	mov    %edx,%ecx
  8019c7:	89 c6                	mov    %eax,%esi
  8019c9:	e9 71 ff ff ff       	jmp    80193f <__umoddi3+0xb3>
  8019ce:	66 90                	xchg   %ax,%ax
  8019d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019d4:	72 ea                	jb     8019c0 <__umoddi3+0x134>
  8019d6:	89 d9                	mov    %ebx,%ecx
  8019d8:	e9 62 ff ff ff       	jmp    80193f <__umoddi3+0xb3>
