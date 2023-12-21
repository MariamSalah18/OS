
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 a0 19 80 00       	push   $0x8019a0
  800046:	e8 4b 02 00 00       	call   800296 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 95 19 80 00       	mov    0x801995,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 c8 19 80 00       	push   $0x8019c8
  80005c:	e8 35 02 00 00       	call   800296 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 6a 13 00 00       	call   8013dc <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	01 c0                	add    %eax,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c1 e0 06             	shl    $0x6,%eax
  800081:	29 d0                	sub    %edx,%eax
  800083:	c1 e0 03             	shl    $0x3,%eax
  800086:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008b:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800090:	a1 20 20 80 00       	mov    0x802020,%eax
  800095:	8a 40 68             	mov    0x68(%eax),%al
  800098:	84 c0                	test   %al,%al
  80009a:	74 0d                	je     8000a9 <libmain+0x42>
		binaryname = myEnv->prog_name;
  80009c:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a1:	83 c0 68             	add    $0x68,%eax
  8000a4:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ad:	7e 0a                	jle    8000b9 <libmain+0x52>
		binaryname = argv[0];
  8000af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b2:	8b 00                	mov    (%eax),%eax
  8000b4:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 0c             	pushl  0xc(%ebp)
  8000bf:	ff 75 08             	pushl  0x8(%ebp)
  8000c2:	e8 71 ff ff ff       	call   800038 <_main>
  8000c7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000ca:	e8 1a 11 00 00       	call   8011e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	68 f4 19 80 00       	push   $0x8019f4
  8000d7:	e8 8d 01 00 00       	call   800269 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000df:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e4:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000ea:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ef:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	52                   	push   %edx
  8000f9:	50                   	push   %eax
  8000fa:	68 1c 1a 80 00       	push   $0x801a1c
  8000ff:	e8 65 01 00 00       	call   800269 <cprintf>
  800104:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800107:	a1 20 20 80 00       	mov    0x802020,%eax
  80010c:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800112:	a1 20 20 80 00       	mov    0x802020,%eax
  800117:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80011d:	a1 20 20 80 00       	mov    0x802020,%eax
  800122:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800128:	51                   	push   %ecx
  800129:	52                   	push   %edx
  80012a:	50                   	push   %eax
  80012b:	68 44 1a 80 00       	push   $0x801a44
  800130:	e8 34 01 00 00       	call   800269 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800138:	a1 20 20 80 00       	mov    0x802020,%eax
  80013d:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	50                   	push   %eax
  800147:	68 9c 1a 80 00       	push   $0x801a9c
  80014c:	e8 18 01 00 00       	call   800269 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 f4 19 80 00       	push   $0x8019f4
  80015c:	e8 08 01 00 00       	call   800269 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800164:	e8 9a 10 00 00       	call   801203 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800169:	e8 19 00 00 00       	call   800187 <exit>
}
  80016e:	90                   	nop
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	6a 00                	push   $0x0
  80017c:	e8 27 12 00 00       	call   8013a8 <sys_destroy_env>
  800181:	83 c4 10             	add    $0x10,%esp
}
  800184:	90                   	nop
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <exit>:

void
exit(void)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018d:	e8 7c 12 00 00       	call   80140e <sys_exit_env>
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80019b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019e:	8b 00                	mov    (%eax),%eax
  8001a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a6:	89 0a                	mov    %ecx,(%edx)
  8001a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ab:	88 d1                	mov    %dl,%cl
  8001ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b7:	8b 00                	mov    (%eax),%eax
  8001b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001be:	75 2c                	jne    8001ec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c0:	a0 24 20 80 00       	mov    0x802024,%al
  8001c5:	0f b6 c0             	movzbl %al,%eax
  8001c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cb:	8b 12                	mov    (%edx),%edx
  8001cd:	89 d1                	mov    %edx,%ecx
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	83 c2 08             	add    $0x8,%edx
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	50                   	push   %eax
  8001d9:	51                   	push   %ecx
  8001da:	52                   	push   %edx
  8001db:	e8 b0 0e 00 00       	call   801090 <sys_cputs>
  8001e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	8b 40 04             	mov    0x4(%eax),%eax
  8001f2:	8d 50 01             	lea    0x1(%eax),%edx
  8001f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001fb:	90                   	nop
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800207:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020e:	00 00 00 
	b.cnt = 0;
  800211:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800218:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	68 95 01 80 00       	push   $0x800195
  80022d:	e8 11 02 00 00       	call   800443 <vprintfmt>
  800232:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800235:	a0 24 20 80 00       	mov    0x802024,%al
  80023a:	0f b6 c0             	movzbl %al,%eax
  80023d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	50                   	push   %eax
  800247:	52                   	push   %edx
  800248:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024e:	83 c0 08             	add    $0x8,%eax
  800251:	50                   	push   %eax
  800252:	e8 39 0e 00 00       	call   801090 <sys_cputs>
  800257:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80025a:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800261:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <cprintf>:

int cprintf(const char *fmt, ...) {
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80026f:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800276:	8d 45 0c             	lea    0xc(%ebp),%eax
  800279:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80027c:	8b 45 08             	mov    0x8(%ebp),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	ff 75 f4             	pushl  -0xc(%ebp)
  800285:	50                   	push   %eax
  800286:	e8 73 ff ff ff       	call   8001fe <vcprintf>
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800291:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800294:	c9                   	leave  
  800295:	c3                   	ret    

00800296 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80029c:	e8 48 0f 00 00       	call   8011e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	e8 48 ff ff ff       	call   8001fe <vcprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002bc:	e8 42 0f 00 00       	call   801203 <sys_enable_interrupt>
	return cnt;
  8002c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	53                   	push   %ebx
  8002ca:	83 ec 14             	sub    $0x14,%esp
  8002cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8002dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e4:	77 55                	ja     80033b <printnum+0x75>
  8002e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e9:	72 05                	jb     8002f0 <printnum+0x2a>
  8002eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ee:	77 4b                	ja     80033b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	ff 75 f4             	pushl  -0xc(%ebp)
  800303:	ff 75 f0             	pushl  -0x10(%ebp)
  800306:	e8 29 14 00 00       	call   801734 <__udivdi3>
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	ff 75 20             	pushl  0x20(%ebp)
  800314:	53                   	push   %ebx
  800315:	ff 75 18             	pushl  0x18(%ebp)
  800318:	52                   	push   %edx
  800319:	50                   	push   %eax
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	ff 75 08             	pushl  0x8(%ebp)
  800320:	e8 a1 ff ff ff       	call   8002c6 <printnum>
  800325:	83 c4 20             	add    $0x20,%esp
  800328:	eb 1a                	jmp    800344 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 20             	pushl  0x20(%ebp)
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	ff d0                	call   *%eax
  800338:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033b:	ff 4d 1c             	decl   0x1c(%ebp)
  80033e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800342:	7f e6                	jg     80032a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800344:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800347:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800352:	53                   	push   %ebx
  800353:	51                   	push   %ecx
  800354:	52                   	push   %edx
  800355:	50                   	push   %eax
  800356:	e8 e9 14 00 00       	call   801844 <__umoddi3>
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  800363:	8a 00                	mov    (%eax),%al
  800365:	0f be c0             	movsbl %al,%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	50                   	push   %eax
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	ff d0                	call   *%eax
  800374:	83 c4 10             	add    $0x10,%esp
}
  800377:	90                   	nop
  800378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800380:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800384:	7e 1c                	jle    8003a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 08             	lea    0x8(%eax),%edx
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
  800393:	8b 45 08             	mov    0x8(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	83 e8 08             	sub    $0x8,%eax
  80039b:	8b 50 04             	mov    0x4(%eax),%edx
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	eb 40                	jmp    8003e2 <getuint+0x65>
	else if (lflag)
  8003a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a6:	74 1e                	je     8003c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	8d 50 04             	lea    0x4(%eax),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 10                	mov    %edx,(%eax)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	83 e8 04             	sub    $0x4,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c4:	eb 1c                	jmp    8003e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	8d 50 04             	lea    0x4(%eax),%edx
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	89 10                	mov    %edx,(%eax)
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	83 e8 04             	sub    $0x4,%eax
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003eb:	7e 1c                	jle    800409 <getint+0x25>
		return va_arg(*ap, long long);
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	8d 50 08             	lea    0x8(%eax),%edx
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	89 10                	mov    %edx,(%eax)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	83 e8 08             	sub    $0x8,%eax
  800402:	8b 50 04             	mov    0x4(%eax),%edx
  800405:	8b 00                	mov    (%eax),%eax
  800407:	eb 38                	jmp    800441 <getint+0x5d>
	else if (lflag)
  800409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040d:	74 1a                	je     800429 <getint+0x45>
		return va_arg(*ap, long);
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 50 04             	lea    0x4(%eax),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	89 10                	mov    %edx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	83 e8 04             	sub    $0x4,%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	99                   	cltd   
  800427:	eb 18                	jmp    800441 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	8d 50 04             	lea    0x4(%eax),%edx
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 10                	mov    %edx,(%eax)
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	83 e8 04             	sub    $0x4,%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	99                   	cltd   
}
  800441:	5d                   	pop    %ebp
  800442:	c3                   	ret    

00800443 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	56                   	push   %esi
  800447:	53                   	push   %ebx
  800448:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044b:	eb 17                	jmp    800464 <vprintfmt+0x21>
			if (ch == '\0')
  80044d:	85 db                	test   %ebx,%ebx
  80044f:	0f 84 af 03 00 00    	je     800804 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	53                   	push   %ebx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	ff d0                	call   *%eax
  800461:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800464:	8b 45 10             	mov    0x10(%ebp),%eax
  800467:	8d 50 01             	lea    0x1(%eax),%edx
  80046a:	89 55 10             	mov    %edx,0x10(%ebp)
  80046d:	8a 00                	mov    (%eax),%al
  80046f:	0f b6 d8             	movzbl %al,%ebx
  800472:	83 fb 25             	cmp    $0x25,%ebx
  800475:	75 d6                	jne    80044d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800477:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80047b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800482:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800489:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800490:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800497:	8b 45 10             	mov    0x10(%ebp),%eax
  80049a:	8d 50 01             	lea    0x1(%eax),%edx
  80049d:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a0:	8a 00                	mov    (%eax),%al
  8004a2:	0f b6 d8             	movzbl %al,%ebx
  8004a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a8:	83 f8 55             	cmp    $0x55,%eax
  8004ab:	0f 87 2b 03 00 00    	ja     8007dc <vprintfmt+0x399>
  8004b1:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  8004b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004be:	eb d7                	jmp    800497 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c4:	eb d1                	jmp    800497 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d0:	89 d0                	mov    %edx,%eax
  8004d2:	c1 e0 02             	shl    $0x2,%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	01 c0                	add    %eax,%eax
  8004d9:	01 d8                	add    %ebx,%eax
  8004db:	83 e8 30             	sub    $0x30,%eax
  8004de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	8a 00                	mov    (%eax),%al
  8004e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8004ec:	7e 3e                	jle    80052c <vprintfmt+0xe9>
  8004ee:	83 fb 39             	cmp    $0x39,%ebx
  8004f1:	7f 39                	jg     80052c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f6:	eb d5                	jmp    8004cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	83 e8 04             	sub    $0x4,%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80050c:	eb 1f                	jmp    80052d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80050e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800512:	79 83                	jns    800497 <vprintfmt+0x54>
				width = 0;
  800514:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80051b:	e9 77 ff ff ff       	jmp    800497 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800520:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800527:	e9 6b ff ff ff       	jmp    800497 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80052c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80052d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800531:	0f 89 60 ff ff ff    	jns    800497 <vprintfmt+0x54>
				width = precision, precision = -1;
  800537:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800544:	e9 4e ff ff ff       	jmp    800497 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800549:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80054c:	e9 46 ff ff ff       	jmp    800497 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 c0 04             	add    $0x4,%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 e8 04             	sub    $0x4,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	50                   	push   %eax
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	ff d0                	call   *%eax
  80056e:	83 c4 10             	add    $0x10,%esp
			break;
  800571:	e9 89 02 00 00       	jmp    8007ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	83 c0 04             	add    $0x4,%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	83 e8 04             	sub    $0x4,%eax
  800585:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800587:	85 db                	test   %ebx,%ebx
  800589:	79 02                	jns    80058d <vprintfmt+0x14a>
				err = -err;
  80058b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80058d:	83 fb 64             	cmp    $0x64,%ebx
  800590:	7f 0b                	jg     80059d <vprintfmt+0x15a>
  800592:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  800599:	85 f6                	test   %esi,%esi
  80059b:	75 19                	jne    8005b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80059d:	53                   	push   %ebx
  80059e:	68 e5 1c 80 00       	push   $0x801ce5
  8005a3:	ff 75 0c             	pushl  0xc(%ebp)
  8005a6:	ff 75 08             	pushl  0x8(%ebp)
  8005a9:	e8 5e 02 00 00       	call   80080c <printfmt>
  8005ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005b1:	e9 49 02 00 00       	jmp    8007ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b6:	56                   	push   %esi
  8005b7:	68 ee 1c 80 00       	push   $0x801cee
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	ff 75 08             	pushl  0x8(%ebp)
  8005c2:	e8 45 02 00 00       	call   80080c <printfmt>
  8005c7:	83 c4 10             	add    $0x10,%esp
			break;
  8005ca:	e9 30 02 00 00       	jmp    8007ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	83 c0 04             	add    $0x4,%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 30                	mov    (%eax),%esi
  8005e0:	85 f6                	test   %esi,%esi
  8005e2:	75 05                	jne    8005e9 <vprintfmt+0x1a6>
				p = "(null)";
  8005e4:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  8005e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ed:	7e 6d                	jle    80065c <vprintfmt+0x219>
  8005ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f3:	74 67                	je     80065c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	50                   	push   %eax
  8005fc:	56                   	push   %esi
  8005fd:	e8 0c 03 00 00       	call   80090e <strnlen>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800608:	eb 16                	jmp    800620 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80060a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061d:	ff 4d e4             	decl   -0x1c(%ebp)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	7f e4                	jg     80060a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800626:	eb 34                	jmp    80065c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800628:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062c:	74 1c                	je     80064a <vprintfmt+0x207>
  80062e:	83 fb 1f             	cmp    $0x1f,%ebx
  800631:	7e 05                	jle    800638 <vprintfmt+0x1f5>
  800633:	83 fb 7e             	cmp    $0x7e,%ebx
  800636:	7e 12                	jle    80064a <vprintfmt+0x207>
					putch('?', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	6a 3f                	push   $0x3f
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	ff d0                	call   *%eax
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb 0f                	jmp    800659 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	53                   	push   %ebx
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800659:	ff 4d e4             	decl   -0x1c(%ebp)
  80065c:	89 f0                	mov    %esi,%eax
  80065e:	8d 70 01             	lea    0x1(%eax),%esi
  800661:	8a 00                	mov    (%eax),%al
  800663:	0f be d8             	movsbl %al,%ebx
  800666:	85 db                	test   %ebx,%ebx
  800668:	74 24                	je     80068e <vprintfmt+0x24b>
  80066a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066e:	78 b8                	js     800628 <vprintfmt+0x1e5>
  800670:	ff 4d e0             	decl   -0x20(%ebp)
  800673:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800677:	79 af                	jns    800628 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800679:	eb 13                	jmp    80068e <vprintfmt+0x24b>
				putch(' ', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	6a 20                	push   $0x20
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	ff d0                	call   *%eax
  800688:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068b:	ff 4d e4             	decl   -0x1c(%ebp)
  80068e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800692:	7f e7                	jg     80067b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800694:	e9 66 01 00 00       	jmp    8007ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 e8             	pushl  -0x18(%ebp)
  80069f:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a2:	50                   	push   %eax
  8006a3:	e8 3c fd ff ff       	call   8003e4 <getint>
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b7:	85 d2                	test   %edx,%edx
  8006b9:	79 23                	jns    8006de <vprintfmt+0x29b>
				putch('-', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	6a 2d                	push   $0x2d
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d1:	f7 d8                	neg    %eax
  8006d3:	83 d2 00             	adc    $0x0,%edx
  8006d6:	f7 da                	neg    %edx
  8006d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e5:	e9 bc 00 00 00       	jmp    8007a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	e8 84 fc ff ff       	call   80037d <getuint>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800702:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800709:	e9 98 00 00 00       	jmp    8007a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	6a 58                	push   $0x58
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	6a 58                	push   $0x58
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	6a 58                	push   $0x58
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
			break;
  80073e:	e9 bc 00 00 00       	jmp    8007ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	6a 30                	push   $0x30
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	ff d0                	call   *%eax
  800750:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	6a 78                	push   $0x78
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	83 c0 04             	add    $0x4,%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80077e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800785:	eb 1f                	jmp    8007a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 e8             	pushl  -0x18(%ebp)
  80078d:	8d 45 14             	lea    0x14(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	e8 e7 fb ff ff       	call   80037d <getuint>
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80079f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	52                   	push   %edx
  8007b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b4:	50                   	push   %eax
  8007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	e8 00 fb ff ff       	call   8002c6 <printnum>
  8007c6:	83 c4 20             	add    $0x20,%esp
			break;
  8007c9:	eb 34                	jmp    8007ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	53                   	push   %ebx
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
			break;
  8007da:	eb 23                	jmp    8007ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 25                	push   $0x25
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ec:	ff 4d 10             	decl   0x10(%ebp)
  8007ef:	eb 03                	jmp    8007f4 <vprintfmt+0x3b1>
  8007f1:	ff 4d 10             	decl   0x10(%ebp)
  8007f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f7:	48                   	dec    %eax
  8007f8:	8a 00                	mov    (%eax),%al
  8007fa:	3c 25                	cmp    $0x25,%al
  8007fc:	75 f3                	jne    8007f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007fe:	90                   	nop
		}
	}
  8007ff:	e9 47 fc ff ff       	jmp    80044b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800804:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800805:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800808:	5b                   	pop    %ebx
  800809:	5e                   	pop    %esi
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800812:	8d 45 10             	lea    0x10(%ebp),%eax
  800815:	83 c0 04             	add    $0x4,%eax
  800818:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80081b:	8b 45 10             	mov    0x10(%ebp),%eax
  80081e:	ff 75 f4             	pushl  -0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 16 fc ff ff       	call   800443 <vprintfmt>
  80082d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800830:	90                   	nop
  800831:	c9                   	leave  
  800832:	c3                   	ret    

00800833 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800836:	8b 45 0c             	mov    0xc(%ebp),%eax
  800839:	8b 40 08             	mov    0x8(%eax),%eax
  80083c:	8d 50 01             	lea    0x1(%eax),%edx
  80083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800842:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	8b 10                	mov    (%eax),%edx
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	8b 40 04             	mov    0x4(%eax),%eax
  800850:	39 c2                	cmp    %eax,%edx
  800852:	73 12                	jae    800866 <sprintputch+0x33>
		*b->buf++ = ch;
  800854:	8b 45 0c             	mov    0xc(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	8d 48 01             	lea    0x1(%eax),%ecx
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085f:	89 0a                	mov    %ecx,(%edx)
  800861:	8b 55 08             	mov    0x8(%ebp),%edx
  800864:	88 10                	mov    %dl,(%eax)
}
  800866:	90                   	nop
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800875:	8b 45 0c             	mov    0xc(%ebp),%eax
  800878:	8d 50 ff             	lea    -0x1(%eax),%edx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80088e:	74 06                	je     800896 <vsnprintf+0x2d>
  800890:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800894:	7f 07                	jg     80089d <vsnprintf+0x34>
		return -E_INVAL;
  800896:	b8 03 00 00 00       	mov    $0x3,%eax
  80089b:	eb 20                	jmp    8008bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	ff 75 14             	pushl  0x14(%ebp)
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	68 33 08 80 00       	push   $0x800833
  8008ac:	e8 92 fb ff ff       	call   800443 <vprintfmt>
  8008b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    

008008bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c8:	83 c0 04             	add    $0x4,%eax
  8008cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 89 ff ff ff       	call   800869 <vsnprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
  8008e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    

008008eb <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008f8:	eb 06                	jmp    800900 <strlen+0x15>
		n++;
  8008fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fd:	ff 45 08             	incl   0x8(%ebp)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8a 00                	mov    (%eax),%al
  800905:	84 c0                	test   %al,%al
  800907:	75 f1                	jne    8008fa <strlen+0xf>
		n++;
	return n;
  800909:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800914:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091b:	eb 09                	jmp    800926 <strnlen+0x18>
		n++;
  80091d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800920:	ff 45 08             	incl   0x8(%ebp)
  800923:	ff 4d 0c             	decl   0xc(%ebp)
  800926:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092a:	74 09                	je     800935 <strnlen+0x27>
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8a 00                	mov    (%eax),%al
  800931:	84 c0                	test   %al,%al
  800933:	75 e8                	jne    80091d <strnlen+0xf>
		n++;
	return n;
  800935:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800946:	90                   	nop
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8d 50 01             	lea    0x1(%eax),%edx
  80094d:	89 55 08             	mov    %edx,0x8(%ebp)
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	8d 4a 01             	lea    0x1(%edx),%ecx
  800956:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800959:	8a 12                	mov    (%edx),%dl
  80095b:	88 10                	mov    %dl,(%eax)
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	84 c0                	test   %al,%al
  800961:	75 e4                	jne    800947 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800963:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097b:	eb 1f                	jmp    80099c <strncpy+0x34>
		*dst++ = *src;
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8d 50 01             	lea    0x1(%eax),%edx
  800983:	89 55 08             	mov    %edx,0x8(%ebp)
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	8a 12                	mov    (%edx),%dl
  80098b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8a 00                	mov    (%eax),%al
  800992:	84 c0                	test   %al,%al
  800994:	74 03                	je     800999 <strncpy+0x31>
			src++;
  800996:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800999:	ff 45 fc             	incl   -0x4(%ebp)
  80099c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80099f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009a2:	72 d9                	jb     80097d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009b9:	74 30                	je     8009eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009bb:	eb 16                	jmp    8009d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8d 50 01             	lea    0x1(%eax),%edx
  8009c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009cf:	8a 12                	mov    (%edx),%dl
  8009d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d3:	ff 4d 10             	decl   0x10(%ebp)
  8009d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009da:	74 09                	je     8009e5 <strlcpy+0x3c>
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	84 c0                	test   %al,%al
  8009e3:	75 d8                	jne    8009bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f1:	29 c2                	sub    %eax,%edx
  8009f3:	89 d0                	mov    %edx,%eax
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009fa:	eb 06                	jmp    800a02 <strcmp+0xb>
		p++, q++;
  8009fc:	ff 45 08             	incl   0x8(%ebp)
  8009ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	84 c0                	test   %al,%al
  800a09:	74 0e                	je     800a19 <strcmp+0x22>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 10                	mov    (%eax),%dl
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	38 c2                	cmp    %al,%dl
  800a17:	74 e3                	je     8009fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	0f b6 d0             	movzbl %al,%edx
  800a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a24:	8a 00                	mov    (%eax),%al
  800a26:	0f b6 c0             	movzbl %al,%eax
  800a29:	29 c2                	sub    %eax,%edx
  800a2b:	89 d0                	mov    %edx,%eax
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a32:	eb 09                	jmp    800a3d <strncmp+0xe>
		n--, p++, q++;
  800a34:	ff 4d 10             	decl   0x10(%ebp)
  800a37:	ff 45 08             	incl   0x8(%ebp)
  800a3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a41:	74 17                	je     800a5a <strncmp+0x2b>
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	84 c0                	test   %al,%al
  800a4a:	74 0e                	je     800a5a <strncmp+0x2b>
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8a 10                	mov    (%eax),%dl
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	38 c2                	cmp    %al,%dl
  800a58:	74 da                	je     800a34 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5e:	75 07                	jne    800a67 <strncmp+0x38>
		return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	eb 14                	jmp    800a7b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	0f b6 d0             	movzbl %al,%edx
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	0f b6 c0             	movzbl %al,%eax
  800a77:	29 c2                	sub    %eax,%edx
  800a79:	89 d0                	mov    %edx,%eax
}
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 04             	sub    $0x4,%esp
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a89:	eb 12                	jmp    800a9d <strchr+0x20>
		if (*s == c)
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8a 00                	mov    (%eax),%al
  800a90:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a93:	75 05                	jne    800a9a <strchr+0x1d>
			return (char *) s;
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	eb 11                	jmp    800aab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9a:	ff 45 08             	incl   0x8(%ebp)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	84 c0                	test   %al,%al
  800aa4:	75 e5                	jne    800a8b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 04             	sub    $0x4,%esp
  800ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ab9:	eb 0d                	jmp    800ac8 <strfind+0x1b>
		if (*s == c)
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac3:	74 0e                	je     800ad3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac5:	ff 45 08             	incl   0x8(%ebp)
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	84 c0                	test   %al,%al
  800acf:	75 ea                	jne    800abb <strfind+0xe>
  800ad1:	eb 01                	jmp    800ad4 <strfind+0x27>
		if (*s == c)
			break;
  800ad3:	90                   	nop
	return (char *) s;
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800aeb:	eb 0e                	jmp    800afb <memset+0x22>
		*p++ = c;
  800aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af0:	8d 50 01             	lea    0x1(%eax),%edx
  800af3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800afb:	ff 4d f8             	decl   -0x8(%ebp)
  800afe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b02:	79 e9                	jns    800aed <memset+0x14>
		*p++ = c;

	return v;
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b1b:	eb 16                	jmp    800b33 <memcpy+0x2a>
		*d++ = *s++;
  800b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b20:	8d 50 01             	lea    0x1(%eax),%edx
  800b23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b2c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b2f:	8a 12                	mov    (%edx),%dl
  800b31:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b33:	8b 45 10             	mov    0x10(%ebp),%eax
  800b36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b39:	89 55 10             	mov    %edx,0x10(%ebp)
  800b3c:	85 c0                	test   %eax,%eax
  800b3e:	75 dd                	jne    800b1d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b5d:	73 50                	jae    800baf <memmove+0x6a>
  800b5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6a:	76 43                	jbe    800baf <memmove+0x6a>
		s += n;
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b78:	eb 10                	jmp    800b8a <memmove+0x45>
			*--d = *--s;
  800b7a:	ff 4d f8             	decl   -0x8(%ebp)
  800b7d:	ff 4d fc             	decl   -0x4(%ebp)
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b83:	8a 10                	mov    (%eax),%dl
  800b85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b88:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b90:	89 55 10             	mov    %edx,0x10(%ebp)
  800b93:	85 c0                	test   %eax,%eax
  800b95:	75 e3                	jne    800b7a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b97:	eb 23                	jmp    800bbc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ba2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bab:	8a 12                	mov    (%edx),%dl
  800bad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800baf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb8:	85 c0                	test   %eax,%eax
  800bba:	75 dd                	jne    800b99 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bd3:	eb 2a                	jmp    800bff <memcmp+0x3e>
		if (*s1 != *s2)
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd8:	8a 10                	mov    (%eax),%dl
  800bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	38 c2                	cmp    %al,%dl
  800be1:	74 16                	je     800bf9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	0f b6 d0             	movzbl %al,%edx
  800beb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	0f b6 c0             	movzbl %al,%eax
  800bf3:	29 c2                	sub    %eax,%edx
  800bf5:	89 d0                	mov    %edx,%eax
  800bf7:	eb 18                	jmp    800c11 <memcmp+0x50>
		s1++, s2++;
  800bf9:	ff 45 fc             	incl   -0x4(%ebp)
  800bfc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bff:	8b 45 10             	mov    0x10(%ebp),%eax
  800c02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c05:	89 55 10             	mov    %edx,0x10(%ebp)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	75 c9                	jne    800bd5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c24:	eb 15                	jmp    800c3b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	0f b6 d0             	movzbl %al,%edx
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	0f b6 c0             	movzbl %al,%eax
  800c34:	39 c2                	cmp    %eax,%edx
  800c36:	74 0d                	je     800c45 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c38:	ff 45 08             	incl   0x8(%ebp)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c41:	72 e3                	jb     800c26 <memfind+0x13>
  800c43:	eb 01                	jmp    800c46 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c45:	90                   	nop
	return (void *) s;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5f:	eb 03                	jmp    800c64 <strtol+0x19>
		s++;
  800c61:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	3c 20                	cmp    $0x20,%al
  800c6b:	74 f4                	je     800c61 <strtol+0x16>
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	3c 09                	cmp    $0x9,%al
  800c74:	74 eb                	je     800c61 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	3c 2b                	cmp    $0x2b,%al
  800c7d:	75 05                	jne    800c84 <strtol+0x39>
		s++;
  800c7f:	ff 45 08             	incl   0x8(%ebp)
  800c82:	eb 13                	jmp    800c97 <strtol+0x4c>
	else if (*s == '-')
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	3c 2d                	cmp    $0x2d,%al
  800c8b:	75 0a                	jne    800c97 <strtol+0x4c>
		s++, neg = 1;
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9b:	74 06                	je     800ca3 <strtol+0x58>
  800c9d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ca1:	75 20                	jne    800cc3 <strtol+0x78>
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	3c 30                	cmp    $0x30,%al
  800caa:	75 17                	jne    800cc3 <strtol+0x78>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	40                   	inc    %eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	3c 78                	cmp    $0x78,%al
  800cb4:	75 0d                	jne    800cc3 <strtol+0x78>
		s += 2, base = 16;
  800cb6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cc1:	eb 28                	jmp    800ceb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc7:	75 15                	jne    800cde <strtol+0x93>
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 30                	cmp    $0x30,%al
  800cd0:	75 0c                	jne    800cde <strtol+0x93>
		s++, base = 8;
  800cd2:	ff 45 08             	incl   0x8(%ebp)
  800cd5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cdc:	eb 0d                	jmp    800ceb <strtol+0xa0>
	else if (base == 0)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	75 07                	jne    800ceb <strtol+0xa0>
		base = 10;
  800ce4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	3c 2f                	cmp    $0x2f,%al
  800cf2:	7e 19                	jle    800d0d <strtol+0xc2>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	3c 39                	cmp    $0x39,%al
  800cfb:	7f 10                	jg     800d0d <strtol+0xc2>
			dig = *s - '0';
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f be c0             	movsbl %al,%eax
  800d05:	83 e8 30             	sub    $0x30,%eax
  800d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d0b:	eb 42                	jmp    800d4f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 60                	cmp    $0x60,%al
  800d14:	7e 19                	jle    800d2f <strtol+0xe4>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 7a                	cmp    $0x7a,%al
  800d1d:	7f 10                	jg     800d2f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f be c0             	movsbl %al,%eax
  800d27:	83 e8 57             	sub    $0x57,%eax
  800d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d2d:	eb 20                	jmp    800d4f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	3c 40                	cmp    $0x40,%al
  800d36:	7e 39                	jle    800d71 <strtol+0x126>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 5a                	cmp    $0x5a,%al
  800d3f:	7f 30                	jg     800d71 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f be c0             	movsbl %al,%eax
  800d49:	83 e8 37             	sub    $0x37,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d52:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d55:	7d 19                	jge    800d70 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d61:	89 c2                	mov    %eax,%edx
  800d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d66:	01 d0                	add    %edx,%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d6b:	e9 7b ff ff ff       	jmp    800ceb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d70:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d75:	74 08                	je     800d7f <strtol+0x134>
		*endptr = (char *) s;
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d83:	74 07                	je     800d8c <strtol+0x141>
  800d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d88:	f7 d8                	neg    %eax
  800d8a:	eb 03                	jmp    800d8f <strtol+0x144>
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <ltostr>:

void
ltostr(long value, char *str)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d9e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800da5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da9:	79 13                	jns    800dbe <ltostr+0x2d>
	{
		neg = 1;
  800dab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800db8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dbb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dc6:	99                   	cltd   
  800dc7:	f7 f9                	idiv   %ecx
  800dc9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcf:	8d 50 01             	lea    0x1(%eax),%edx
  800dd2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd5:	89 c2                	mov    %eax,%edx
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	01 d0                	add    %edx,%eax
  800ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ddf:	83 c2 30             	add    $0x30,%edx
  800de2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dec:	f7 e9                	imul   %ecx
  800dee:	c1 fa 02             	sar    $0x2,%edx
  800df1:	89 c8                	mov    %ecx,%eax
  800df3:	c1 f8 1f             	sar    $0x1f,%eax
  800df6:	29 c2                	sub    %eax,%edx
  800df8:	89 d0                	mov    %edx,%eax
  800dfa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800dfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e00:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e05:	f7 e9                	imul   %ecx
  800e07:	c1 fa 02             	sar    $0x2,%edx
  800e0a:	89 c8                	mov    %ecx,%eax
  800e0c:	c1 f8 1f             	sar    $0x1f,%eax
  800e0f:	29 c2                	sub    %eax,%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	c1 e0 02             	shl    $0x2,%eax
  800e16:	01 d0                	add    %edx,%eax
  800e18:	01 c0                	add    %eax,%eax
  800e1a:	29 c1                	sub    %eax,%ecx
  800e1c:	89 ca                	mov    %ecx,%edx
  800e1e:	85 d2                	test   %edx,%edx
  800e20:	75 9c                	jne    800dbe <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2c:	48                   	dec    %eax
  800e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e30:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e34:	74 3d                	je     800e73 <ltostr+0xe2>
		start = 1 ;
  800e36:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e3d:	eb 34                	jmp    800e73 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	01 c2                	add    %eax,%edx
  800e54:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	01 c8                	add    %ecx,%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	01 c2                	add    %eax,%edx
  800e68:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e6b:	88 02                	mov    %al,(%edx)
		start++ ;
  800e6d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e70:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e79:	7c c4                	jl     800e3f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e7b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e86:	90                   	nop
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e8f:	ff 75 08             	pushl  0x8(%ebp)
  800e92:	e8 54 fa ff ff       	call   8008eb <strlen>
  800e97:	83 c4 04             	add    $0x4,%esp
  800e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	e8 46 fa ff ff       	call   8008eb <strlen>
  800ea5:	83 c4 04             	add    $0x4,%esp
  800ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	01 c2                	add    %eax,%edx
  800ec3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	01 c8                	add    %ecx,%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ecf:	ff 45 fc             	incl   -0x4(%ebp)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ed8:	7c e1                	jl     800ebb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800eda:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ee1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ee8:	eb 1f                	jmp    800f09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef3:	89 c2                	mov    %eax,%edx
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	01 c2                	add    %eax,%edx
  800efa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	01 c8                	add    %ecx,%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f06:	ff 45 f8             	incl   -0x8(%ebp)
  800f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f0f:	7c d9                	jl     800eea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	01 d0                	add    %edx,%eax
  800f19:	c6 00 00             	movb   $0x0,(%eax)
}
  800f1c:	90                   	nop
  800f1d:	c9                   	leave  
  800f1e:	c3                   	ret    

00800f1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f22:	8b 45 14             	mov    0x14(%ebp),%eax
  800f25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2e:	8b 00                	mov    (%eax),%eax
  800f30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	01 d0                	add    %edx,%eax
  800f3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f42:	eb 0c                	jmp    800f50 <strsplit+0x31>
			*string++ = 0;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	74 18                	je     800f71 <strsplit+0x52>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f be c0             	movsbl %al,%eax
  800f61:	50                   	push   %eax
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	e8 13 fb ff ff       	call   800a7d <strchr>
  800f6a:	83 c4 08             	add    $0x8,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 d3                	jne    800f44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	74 5a                	je     800fd4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7d:	8b 00                	mov    (%eax),%eax
  800f7f:	83 f8 0f             	cmp    $0xf,%eax
  800f82:	75 07                	jne    800f8b <strsplit+0x6c>
		{
			return 0;
  800f84:	b8 00 00 00 00       	mov    $0x0,%eax
  800f89:	eb 66                	jmp    800ff1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	8b 00                	mov    (%eax),%eax
  800f90:	8d 48 01             	lea    0x1(%eax),%ecx
  800f93:	8b 55 14             	mov    0x14(%ebp),%edx
  800f96:	89 0a                	mov    %ecx,(%edx)
  800f98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	01 c2                	add    %eax,%edx
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa9:	eb 03                	jmp    800fae <strsplit+0x8f>
			string++;
  800fab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	84 c0                	test   %al,%al
  800fb5:	74 8b                	je     800f42 <strsplit+0x23>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f be c0             	movsbl %al,%eax
  800fbf:	50                   	push   %eax
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	e8 b5 fa ff ff       	call   800a7d <strchr>
  800fc8:	83 c4 08             	add    $0x8,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	74 dc                	je     800fab <strsplit+0x8c>
			string++;
	}
  800fcf:	e9 6e ff ff ff       	jmp    800f42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fd4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd8:	8b 00                	mov    (%eax),%eax
  800fda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  800ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801000:	eb 4c                	jmp    80104e <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801002:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 40                	cmp    $0x40,%al
  80100e:	7e 27                	jle    801037 <str2lower+0x44>
  801010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 5a                	cmp    $0x5a,%al
  80101c:	7f 19                	jg     801037 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80101e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	01 d0                	add    %edx,%eax
  801026:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102c:	01 ca                	add    %ecx,%edx
  80102e:	8a 12                	mov    (%edx),%dl
  801030:	83 c2 20             	add    $0x20,%edx
  801033:	88 10                	mov    %dl,(%eax)
  801035:	eb 14                	jmp    80104b <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801037:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	01 c2                	add    %eax,%edx
  80103f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 c8                	add    %ecx,%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80104b:	ff 45 fc             	incl   -0x4(%ebp)
  80104e:	ff 75 0c             	pushl  0xc(%ebp)
  801051:	e8 95 f8 ff ff       	call   8008eb <strlen>
  801056:	83 c4 04             	add    $0x4,%esp
  801059:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105c:	7f a4                	jg     801002 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801077:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80107d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801080:	cd 30                	int    $0x30
  801082:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80109c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	52                   	push   %edx
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	50                   	push   %eax
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 b2 ff ff ff       	call   801065 <syscall>
  8010b3:	83 c4 18             	add    $0x18,%esp
}
  8010b6:	90                   	nop
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010bc:	6a 00                	push   $0x0
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 01                	push   $0x1
  8010c8:	e8 98 ff ff ff       	call   801065 <syscall>
  8010cd:	83 c4 18             	add    $0x18,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	52                   	push   %edx
  8010e2:	50                   	push   %eax
  8010e3:	6a 05                	push   $0x5
  8010e5:	e8 7b ff ff ff       	call   801065 <syscall>
  8010ea:	83 c4 18             	add    $0x18,%esp
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	51                   	push   %ecx
  801106:	52                   	push   %edx
  801107:	50                   	push   %eax
  801108:	6a 06                	push   $0x6
  80110a:	e8 56 ff ff ff       	call   801065 <syscall>
  80110f:	83 c4 18             	add    $0x18,%esp
}
  801112:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80111c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	52                   	push   %edx
  801129:	50                   	push   %eax
  80112a:	6a 07                	push   $0x7
  80112c:	e8 34 ff ff ff       	call   801065 <syscall>
  801131:	83 c4 18             	add    $0x18,%esp
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	6a 08                	push   $0x8
  801147:	e8 19 ff ff ff       	call   801065 <syscall>
  80114c:	83 c4 18             	add    $0x18,%esp
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 09                	push   $0x9
  801160:	e8 00 ff ff ff       	call   801065 <syscall>
  801165:	83 c4 18             	add    $0x18,%esp
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80116d:	6a 00                	push   $0x0
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 0a                	push   $0xa
  801179:	e8 e7 fe ff ff       	call   801065 <syscall>
  80117e:	83 c4 18             	add    $0x18,%esp
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 0b                	push   $0xb
  801192:	e8 ce fe ff ff       	call   801065 <syscall>
  801197:	83 c4 18             	add    $0x18,%esp
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 0c                	push   $0xc
  8011ab:	e8 b5 fe ff ff       	call   801065 <syscall>
  8011b0:	83 c4 18             	add    $0x18,%esp
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	6a 0d                	push   $0xd
  8011c5:	e8 9b fe ff ff       	call   801065 <syscall>
  8011ca:	83 c4 18             	add    $0x18,%esp
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 0e                	push   $0xe
  8011de:	e8 82 fe ff ff       	call   801065 <syscall>
  8011e3:	83 c4 18             	add    $0x18,%esp
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 11                	push   $0x11
  8011f8:	e8 68 fe ff ff       	call   801065 <syscall>
  8011fd:	83 c4 18             	add    $0x18,%esp
}
  801200:	90                   	nop
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 00                	push   $0x0
  801210:	6a 12                	push   $0x12
  801212:	e8 4e fe ff ff       	call   801065 <syscall>
  801217:	83 c4 18             	add    $0x18,%esp
}
  80121a:	90                   	nop
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sys_cputc>:


void
sys_cputc(const char c)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 04             	sub    $0x4,%esp
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801229:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	50                   	push   %eax
  801236:	6a 13                	push   $0x13
  801238:	e8 28 fe ff ff       	call   801065 <syscall>
  80123d:	83 c4 18             	add    $0x18,%esp
}
  801240:	90                   	nop
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 14                	push   $0x14
  801252:	e8 0e fe ff ff       	call   801065 <syscall>
  801257:	83 c4 18             	add    $0x18,%esp
}
  80125a:	90                   	nop
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	ff 75 0c             	pushl  0xc(%ebp)
  80126c:	50                   	push   %eax
  80126d:	6a 15                	push   $0x15
  80126f:	e8 f1 fd ff ff       	call   801065 <syscall>
  801274:	83 c4 18             	add    $0x18,%esp
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	52                   	push   %edx
  801289:	50                   	push   %eax
  80128a:	6a 18                	push   $0x18
  80128c:	e8 d4 fd ff ff       	call   801065 <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	52                   	push   %edx
  8012a6:	50                   	push   %eax
  8012a7:	6a 16                	push   $0x16
  8012a9:	e8 b7 fd ff ff       	call   801065 <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
}
  8012b1:	90                   	nop
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 17                	push   $0x17
  8012c7:	e8 99 fd ff ff       	call   801065 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	90                   	nop
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	6a 00                	push   $0x0
  8012ea:	51                   	push   %ecx
  8012eb:	52                   	push   %edx
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	6a 19                	push   $0x19
  8012f2:	e8 6e fd ff ff       	call   801065 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	52                   	push   %edx
  80130c:	50                   	push   %eax
  80130d:	6a 1a                	push   $0x1a
  80130f:	e8 51 fd ff ff       	call   801065 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80131c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80131f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	51                   	push   %ecx
  80132a:	52                   	push   %edx
  80132b:	50                   	push   %eax
  80132c:	6a 1b                	push   $0x1b
  80132e:	e8 32 fd ff ff       	call   801065 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80133b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	52                   	push   %edx
  801348:	50                   	push   %eax
  801349:	6a 1c                	push   $0x1c
  80134b:	e8 15 fd ff ff       	call   801065 <syscall>
  801350:	83 c4 18             	add    $0x18,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 1d                	push   $0x1d
  801364:	e8 fc fc ff ff       	call   801065 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	6a 00                	push   $0x0
  801376:	ff 75 14             	pushl  0x14(%ebp)
  801379:	ff 75 10             	pushl  0x10(%ebp)
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	50                   	push   %eax
  801380:	6a 1e                	push   $0x1e
  801382:	e8 de fc ff ff       	call   801065 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	50                   	push   %eax
  80139b:	6a 1f                	push   $0x1f
  80139d:	e8 c3 fc ff ff       	call   801065 <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	90                   	nop
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	50                   	push   %eax
  8013b7:	6a 20                	push   $0x20
  8013b9:	e8 a7 fc ff ff       	call   801065 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 02                	push   $0x2
  8013d2:	e8 8e fc ff ff       	call   801065 <syscall>
  8013d7:	83 c4 18             	add    $0x18,%esp
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 03                	push   $0x3
  8013eb:	e8 75 fc ff ff       	call   801065 <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 04                	push   $0x4
  801404:	e8 5c fc ff ff       	call   801065 <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_exit_env>:


void sys_exit_env(void)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 21                	push   $0x21
  80141d:	e8 43 fc ff ff       	call   801065 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	90                   	nop
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80142e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801431:	8d 50 04             	lea    0x4(%eax),%edx
  801434:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	52                   	push   %edx
  80143e:	50                   	push   %eax
  80143f:	6a 22                	push   $0x22
  801441:	e8 1f fc ff ff       	call   801065 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
	return result;
  801449:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801452:	89 01                	mov    %eax,(%ecx)
  801454:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c9                   	leave  
  80145b:	c2 04 00             	ret    $0x4

0080145e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	ff 75 10             	pushl  0x10(%ebp)
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	ff 75 08             	pushl  0x8(%ebp)
  80146e:	6a 10                	push   $0x10
  801470:	e8 f0 fb ff ff       	call   801065 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
	return ;
  801478:	90                   	nop
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_rcr2>:
uint32 sys_rcr2()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 23                	push   $0x23
  80148a:	e8 d6 fb ff ff       	call   801065 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	50                   	push   %eax
  8014ad:	6a 24                	push   $0x24
  8014af:	e8 b1 fb ff ff       	call   801065 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b7:	90                   	nop
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <rsttst>:
void rsttst()
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 26                	push   $0x26
  8014c9:	e8 97 fb ff ff       	call   801065 <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d1:	90                   	nop
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8014e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014e7:	52                   	push   %edx
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 10             	pushl  0x10(%ebp)
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	ff 75 08             	pushl  0x8(%ebp)
  8014f2:	6a 25                	push   $0x25
  8014f4:	e8 6c fb ff ff       	call   801065 <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fc:	90                   	nop
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <chktst>:
void chktst(uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	ff 75 08             	pushl  0x8(%ebp)
  80150d:	6a 27                	push   $0x27
  80150f:	e8 51 fb ff ff       	call   801065 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
	return ;
  801517:	90                   	nop
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <inctst>:

void inctst()
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 28                	push   $0x28
  801529:	e8 37 fb ff ff       	call   801065 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
	return ;
  801531:	90                   	nop
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <gettst>:
uint32 gettst()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 29                	push   $0x29
  801543:	e8 1d fb ff ff       	call   801065 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 2a                	push   $0x2a
  80155f:	e8 01 fb ff ff       	call   801065 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
  801567:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80156a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80156e:	75 07                	jne    801577 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801570:	b8 01 00 00 00       	mov    $0x1,%eax
  801575:	eb 05                	jmp    80157c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 2a                	push   $0x2a
  801590:	e8 d0 fa ff ff       	call   801065 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80159b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80159f:	75 07                	jne    8015a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a6:	eb 05                	jmp    8015ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 2a                	push   $0x2a
  8015c1:	e8 9f fa ff ff       	call   801065 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
  8015c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015d0:	75 07                	jne    8015d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d7:	eb 05                	jmp    8015de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 2a                	push   $0x2a
  8015f2:	e8 6e fa ff ff       	call   801065 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
  8015fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801601:	75 07                	jne    80160a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801603:	b8 01 00 00 00       	mov    $0x1,%eax
  801608:	eb 05                	jmp    80160f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	ff 75 08             	pushl  0x8(%ebp)
  80161f:	6a 2b                	push   $0x2b
  801621:	e8 3f fa ff ff       	call   801065 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return ;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801630:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801633:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	53                   	push   %ebx
  80163f:	51                   	push   %ecx
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	6a 2c                	push   $0x2c
  801644:	e8 1c fa ff ff       	call   801065 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	52                   	push   %edx
  801661:	50                   	push   %eax
  801662:	6a 2d                	push   $0x2d
  801664:	e8 fc f9 ff ff       	call   801065 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801671:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	6a 00                	push   $0x0
  80167c:	51                   	push   %ecx
  80167d:	ff 75 10             	pushl  0x10(%ebp)
  801680:	52                   	push   %edx
  801681:	50                   	push   %eax
  801682:	6a 2e                	push   $0x2e
  801684:	e8 dc f9 ff ff       	call   801065 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	ff 75 10             	pushl  0x10(%ebp)
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	ff 75 08             	pushl  0x8(%ebp)
  80169e:	6a 0f                	push   $0xf
  8016a0:	e8 c0 f9 ff ff       	call   801065 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a8:	90                   	nop
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	50                   	push   %eax
  8016ba:	6a 2f                	push   $0x2f
  8016bc:	e8 a4 f9 ff ff       	call   801065 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp

}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	6a 30                	push   $0x30
  8016d7:	e8 89 f9 ff ff       	call   801065 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
	return;
  8016df:	90                   	nop
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	6a 31                	push   $0x31
  8016f3:	e8 6d f9 ff ff       	call   801065 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
	return;
  8016fb:	90                   	nop
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 32                	push   $0x32
  80170d:	e8 53 f9 ff ff       	call   801065 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	50                   	push   %eax
  801726:	6a 33                	push   $0x33
  801728:	e8 38 f9 ff ff       	call   801065 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	90                   	nop
  801731:	c9                   	leave  
  801732:	c3                   	ret    
  801733:	90                   	nop

00801734 <__udivdi3>:
  801734:	55                   	push   %ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 1c             	sub    $0x1c,%esp
  80173b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80173f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801743:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801747:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80174b:	89 ca                	mov    %ecx,%edx
  80174d:	89 f8                	mov    %edi,%eax
  80174f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801753:	85 f6                	test   %esi,%esi
  801755:	75 2d                	jne    801784 <__udivdi3+0x50>
  801757:	39 cf                	cmp    %ecx,%edi
  801759:	77 65                	ja     8017c0 <__udivdi3+0x8c>
  80175b:	89 fd                	mov    %edi,%ebp
  80175d:	85 ff                	test   %edi,%edi
  80175f:	75 0b                	jne    80176c <__udivdi3+0x38>
  801761:	b8 01 00 00 00       	mov    $0x1,%eax
  801766:	31 d2                	xor    %edx,%edx
  801768:	f7 f7                	div    %edi
  80176a:	89 c5                	mov    %eax,%ebp
  80176c:	31 d2                	xor    %edx,%edx
  80176e:	89 c8                	mov    %ecx,%eax
  801770:	f7 f5                	div    %ebp
  801772:	89 c1                	mov    %eax,%ecx
  801774:	89 d8                	mov    %ebx,%eax
  801776:	f7 f5                	div    %ebp
  801778:	89 cf                	mov    %ecx,%edi
  80177a:	89 fa                	mov    %edi,%edx
  80177c:	83 c4 1c             	add    $0x1c,%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5f                   	pop    %edi
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    
  801784:	39 ce                	cmp    %ecx,%esi
  801786:	77 28                	ja     8017b0 <__udivdi3+0x7c>
  801788:	0f bd fe             	bsr    %esi,%edi
  80178b:	83 f7 1f             	xor    $0x1f,%edi
  80178e:	75 40                	jne    8017d0 <__udivdi3+0x9c>
  801790:	39 ce                	cmp    %ecx,%esi
  801792:	72 0a                	jb     80179e <__udivdi3+0x6a>
  801794:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801798:	0f 87 9e 00 00 00    	ja     80183c <__udivdi3+0x108>
  80179e:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a3:	89 fa                	mov    %edi,%edx
  8017a5:	83 c4 1c             	add    $0x1c,%esp
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5f                   	pop    %edi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    
  8017ad:	8d 76 00             	lea    0x0(%esi),%esi
  8017b0:	31 ff                	xor    %edi,%edi
  8017b2:	31 c0                	xor    %eax,%eax
  8017b4:	89 fa                	mov    %edi,%edx
  8017b6:	83 c4 1c             	add    $0x1c,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5f                   	pop    %edi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    
  8017be:	66 90                	xchg   %ax,%ax
  8017c0:	89 d8                	mov    %ebx,%eax
  8017c2:	f7 f7                	div    %edi
  8017c4:	31 ff                	xor    %edi,%edi
  8017c6:	89 fa                	mov    %edi,%edx
  8017c8:	83 c4 1c             	add    $0x1c,%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5f                   	pop    %edi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    
  8017d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017d5:	89 eb                	mov    %ebp,%ebx
  8017d7:	29 fb                	sub    %edi,%ebx
  8017d9:	89 f9                	mov    %edi,%ecx
  8017db:	d3 e6                	shl    %cl,%esi
  8017dd:	89 c5                	mov    %eax,%ebp
  8017df:	88 d9                	mov    %bl,%cl
  8017e1:	d3 ed                	shr    %cl,%ebp
  8017e3:	89 e9                	mov    %ebp,%ecx
  8017e5:	09 f1                	or     %esi,%ecx
  8017e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017eb:	89 f9                	mov    %edi,%ecx
  8017ed:	d3 e0                	shl    %cl,%eax
  8017ef:	89 c5                	mov    %eax,%ebp
  8017f1:	89 d6                	mov    %edx,%esi
  8017f3:	88 d9                	mov    %bl,%cl
  8017f5:	d3 ee                	shr    %cl,%esi
  8017f7:	89 f9                	mov    %edi,%ecx
  8017f9:	d3 e2                	shl    %cl,%edx
  8017fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017ff:	88 d9                	mov    %bl,%cl
  801801:	d3 e8                	shr    %cl,%eax
  801803:	09 c2                	or     %eax,%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	89 f2                	mov    %esi,%edx
  801809:	f7 74 24 0c          	divl   0xc(%esp)
  80180d:	89 d6                	mov    %edx,%esi
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	f7 e5                	mul    %ebp
  801813:	39 d6                	cmp    %edx,%esi
  801815:	72 19                	jb     801830 <__udivdi3+0xfc>
  801817:	74 0b                	je     801824 <__udivdi3+0xf0>
  801819:	89 d8                	mov    %ebx,%eax
  80181b:	31 ff                	xor    %edi,%edi
  80181d:	e9 58 ff ff ff       	jmp    80177a <__udivdi3+0x46>
  801822:	66 90                	xchg   %ax,%ax
  801824:	8b 54 24 08          	mov    0x8(%esp),%edx
  801828:	89 f9                	mov    %edi,%ecx
  80182a:	d3 e2                	shl    %cl,%edx
  80182c:	39 c2                	cmp    %eax,%edx
  80182e:	73 e9                	jae    801819 <__udivdi3+0xe5>
  801830:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801833:	31 ff                	xor    %edi,%edi
  801835:	e9 40 ff ff ff       	jmp    80177a <__udivdi3+0x46>
  80183a:	66 90                	xchg   %ax,%ax
  80183c:	31 c0                	xor    %eax,%eax
  80183e:	e9 37 ff ff ff       	jmp    80177a <__udivdi3+0x46>
  801843:	90                   	nop

00801844 <__umoddi3>:
  801844:	55                   	push   %ebp
  801845:	57                   	push   %edi
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	83 ec 1c             	sub    $0x1c,%esp
  80184b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80184f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801853:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801857:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80185b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80185f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801863:	89 f3                	mov    %esi,%ebx
  801865:	89 fa                	mov    %edi,%edx
  801867:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80186b:	89 34 24             	mov    %esi,(%esp)
  80186e:	85 c0                	test   %eax,%eax
  801870:	75 1a                	jne    80188c <__umoddi3+0x48>
  801872:	39 f7                	cmp    %esi,%edi
  801874:	0f 86 a2 00 00 00    	jbe    80191c <__umoddi3+0xd8>
  80187a:	89 c8                	mov    %ecx,%eax
  80187c:	89 f2                	mov    %esi,%edx
  80187e:	f7 f7                	div    %edi
  801880:	89 d0                	mov    %edx,%eax
  801882:	31 d2                	xor    %edx,%edx
  801884:	83 c4 1c             	add    $0x1c,%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
  80188c:	39 f0                	cmp    %esi,%eax
  80188e:	0f 87 ac 00 00 00    	ja     801940 <__umoddi3+0xfc>
  801894:	0f bd e8             	bsr    %eax,%ebp
  801897:	83 f5 1f             	xor    $0x1f,%ebp
  80189a:	0f 84 ac 00 00 00    	je     80194c <__umoddi3+0x108>
  8018a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8018a5:	29 ef                	sub    %ebp,%edi
  8018a7:	89 fe                	mov    %edi,%esi
  8018a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018ad:	89 e9                	mov    %ebp,%ecx
  8018af:	d3 e0                	shl    %cl,%eax
  8018b1:	89 d7                	mov    %edx,%edi
  8018b3:	89 f1                	mov    %esi,%ecx
  8018b5:	d3 ef                	shr    %cl,%edi
  8018b7:	09 c7                	or     %eax,%edi
  8018b9:	89 e9                	mov    %ebp,%ecx
  8018bb:	d3 e2                	shl    %cl,%edx
  8018bd:	89 14 24             	mov    %edx,(%esp)
  8018c0:	89 d8                	mov    %ebx,%eax
  8018c2:	d3 e0                	shl    %cl,%eax
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ca:	d3 e0                	shl    %cl,%eax
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018d4:	89 f1                	mov    %esi,%ecx
  8018d6:	d3 e8                	shr    %cl,%eax
  8018d8:	09 d0                	or     %edx,%eax
  8018da:	d3 eb                	shr    %cl,%ebx
  8018dc:	89 da                	mov    %ebx,%edx
  8018de:	f7 f7                	div    %edi
  8018e0:	89 d3                	mov    %edx,%ebx
  8018e2:	f7 24 24             	mull   (%esp)
  8018e5:	89 c6                	mov    %eax,%esi
  8018e7:	89 d1                	mov    %edx,%ecx
  8018e9:	39 d3                	cmp    %edx,%ebx
  8018eb:	0f 82 87 00 00 00    	jb     801978 <__umoddi3+0x134>
  8018f1:	0f 84 91 00 00 00    	je     801988 <__umoddi3+0x144>
  8018f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018fb:	29 f2                	sub    %esi,%edx
  8018fd:	19 cb                	sbb    %ecx,%ebx
  8018ff:	89 d8                	mov    %ebx,%eax
  801901:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801905:	d3 e0                	shl    %cl,%eax
  801907:	89 e9                	mov    %ebp,%ecx
  801909:	d3 ea                	shr    %cl,%edx
  80190b:	09 d0                	or     %edx,%eax
  80190d:	89 e9                	mov    %ebp,%ecx
  80190f:	d3 eb                	shr    %cl,%ebx
  801911:	89 da                	mov    %ebx,%edx
  801913:	83 c4 1c             	add    $0x1c,%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5f                   	pop    %edi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
  80191b:	90                   	nop
  80191c:	89 fd                	mov    %edi,%ebp
  80191e:	85 ff                	test   %edi,%edi
  801920:	75 0b                	jne    80192d <__umoddi3+0xe9>
  801922:	b8 01 00 00 00       	mov    $0x1,%eax
  801927:	31 d2                	xor    %edx,%edx
  801929:	f7 f7                	div    %edi
  80192b:	89 c5                	mov    %eax,%ebp
  80192d:	89 f0                	mov    %esi,%eax
  80192f:	31 d2                	xor    %edx,%edx
  801931:	f7 f5                	div    %ebp
  801933:	89 c8                	mov    %ecx,%eax
  801935:	f7 f5                	div    %ebp
  801937:	89 d0                	mov    %edx,%eax
  801939:	e9 44 ff ff ff       	jmp    801882 <__umoddi3+0x3e>
  80193e:	66 90                	xchg   %ax,%ax
  801940:	89 c8                	mov    %ecx,%eax
  801942:	89 f2                	mov    %esi,%edx
  801944:	83 c4 1c             	add    $0x1c,%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    
  80194c:	3b 04 24             	cmp    (%esp),%eax
  80194f:	72 06                	jb     801957 <__umoddi3+0x113>
  801951:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801955:	77 0f                	ja     801966 <__umoddi3+0x122>
  801957:	89 f2                	mov    %esi,%edx
  801959:	29 f9                	sub    %edi,%ecx
  80195b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80195f:	89 14 24             	mov    %edx,(%esp)
  801962:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801966:	8b 44 24 04          	mov    0x4(%esp),%eax
  80196a:	8b 14 24             	mov    (%esp),%edx
  80196d:	83 c4 1c             	add    $0x1c,%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    
  801975:	8d 76 00             	lea    0x0(%esi),%esi
  801978:	2b 04 24             	sub    (%esp),%eax
  80197b:	19 fa                	sbb    %edi,%edx
  80197d:	89 d1                	mov    %edx,%ecx
  80197f:	89 c6                	mov    %eax,%esi
  801981:	e9 71 ff ff ff       	jmp    8018f7 <__umoddi3+0xb3>
  801986:	66 90                	xchg   %ax,%ax
  801988:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80198c:	72 ea                	jb     801978 <__umoddi3+0x134>
  80198e:	89 d9                	mov    %ebx,%ecx
  801990:	e9 62 ff ff ff       	jmp    8018f7 <__umoddi3+0xb3>
