
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 80 19 80 00       	push   $0x801980
  800046:	e8 35 02 00 00       	call   800280 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 68 13 00 00       	call   8013c4 <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	01 c0                	add    %eax,%eax
  800066:	01 d0                	add    %edx,%eax
  800068:	c1 e0 06             	shl    $0x6,%eax
  80006b:	29 d0                	sub    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800075:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80007a:	a1 20 20 80 00       	mov    0x802020,%eax
  80007f:	8a 40 68             	mov    0x68(%eax),%al
  800082:	84 c0                	test   %al,%al
  800084:	74 0d                	je     800093 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800086:	a1 20 20 80 00       	mov    0x802020,%eax
  80008b:	83 c0 68             	add    $0x68,%eax
  80008e:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800097:	7e 0a                	jle    8000a3 <libmain+0x52>
		binaryname = argv[0];
  800099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009c:	8b 00                	mov    (%eax),%eax
  80009e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000a3:	83 ec 08             	sub    $0x8,%esp
  8000a6:	ff 75 0c             	pushl  0xc(%ebp)
  8000a9:	ff 75 08             	pushl  0x8(%ebp)
  8000ac:	e8 87 ff ff ff       	call   800038 <_main>
  8000b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000b4:	e8 18 11 00 00       	call   8011d1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	68 c4 19 80 00       	push   $0x8019c4
  8000c1:	e8 8d 01 00 00       	call   800253 <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000c9:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ce:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000d4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d9:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	52                   	push   %edx
  8000e3:	50                   	push   %eax
  8000e4:	68 ec 19 80 00       	push   $0x8019ec
  8000e9:	e8 65 01 00 00       	call   800253 <cprintf>
  8000ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000f1:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f6:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8000fc:	a1 20 20 80 00       	mov    0x802020,%eax
  800101:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800107:	a1 20 20 80 00       	mov    0x802020,%eax
  80010c:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800112:	51                   	push   %ecx
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 14 1a 80 00       	push   $0x801a14
  80011a:	e8 34 01 00 00       	call   800253 <cprintf>
  80011f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800122:	a1 20 20 80 00       	mov    0x802020,%eax
  800127:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	50                   	push   %eax
  800131:	68 6c 1a 80 00       	push   $0x801a6c
  800136:	e8 18 01 00 00       	call   800253 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	68 c4 19 80 00       	push   $0x8019c4
  800146:	e8 08 01 00 00       	call   800253 <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80014e:	e8 98 10 00 00       	call   8011eb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800153:	e8 19 00 00 00       	call   800171 <exit>
}
  800158:	90                   	nop
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	6a 00                	push   $0x0
  800166:	e8 25 12 00 00       	call   801390 <sys_destroy_env>
  80016b:	83 c4 10             	add    $0x10,%esp
}
  80016e:	90                   	nop
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <exit>:

void
exit(void)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800177:	e8 7a 12 00 00       	call   8013f6 <sys_exit_env>
}
  80017c:	90                   	nop
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800185:	8b 45 0c             	mov    0xc(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	8d 48 01             	lea    0x1(%eax),%ecx
  80018d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800190:	89 0a                	mov    %ecx,(%edx)
  800192:	8b 55 08             	mov    0x8(%ebp),%edx
  800195:	88 d1                	mov    %dl,%cl
  800197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80019e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a1:	8b 00                	mov    (%eax),%eax
  8001a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a8:	75 2c                	jne    8001d6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001aa:	a0 24 20 80 00       	mov    0x802024,%al
  8001af:	0f b6 c0             	movzbl %al,%eax
  8001b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b5:	8b 12                	mov    (%edx),%edx
  8001b7:	89 d1                	mov    %edx,%ecx
  8001b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bc:	83 c2 08             	add    $0x8,%edx
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	50                   	push   %eax
  8001c3:	51                   	push   %ecx
  8001c4:	52                   	push   %edx
  8001c5:	e8 ae 0e 00 00       	call   801078 <sys_cputs>
  8001ca:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	8b 40 04             	mov    0x4(%eax),%eax
  8001dc:	8d 50 01             	lea    0x1(%eax),%edx
  8001df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001e5:	90                   	nop
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f8:	00 00 00 
	b.cnt = 0;
  8001fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800202:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	68 7f 01 80 00       	push   $0x80017f
  800217:	e8 11 02 00 00       	call   80042d <vprintfmt>
  80021c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80021f:	a0 24 20 80 00       	mov    0x802024,%al
  800224:	0f b6 c0             	movzbl %al,%eax
  800227:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	50                   	push   %eax
  800231:	52                   	push   %edx
  800232:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800238:	83 c0 08             	add    $0x8,%eax
  80023b:	50                   	push   %eax
  80023c:	e8 37 0e 00 00       	call   801078 <sys_cputs>
  800241:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800244:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80024b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <cprintf>:

int cprintf(const char *fmt, ...) {
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800259:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800260:	8d 45 0c             	lea    0xc(%ebp),%eax
  800263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	ff 75 f4             	pushl  -0xc(%ebp)
  80026f:	50                   	push   %eax
  800270:	e8 73 ff ff ff       	call   8001e8 <vcprintf>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80027b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800286:	e8 46 0f 00 00       	call   8011d1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800291:	8b 45 08             	mov    0x8(%ebp),%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	ff 75 f4             	pushl  -0xc(%ebp)
  80029a:	50                   	push   %eax
  80029b:	e8 48 ff ff ff       	call   8001e8 <vcprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002a6:	e8 40 0f 00 00       	call   8011eb <sys_enable_interrupt>
	return cnt;
  8002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 14             	sub    $0x14,%esp
  8002b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ce:	77 55                	ja     800325 <printnum+0x75>
  8002d0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d3:	72 05                	jb     8002da <printnum+0x2a>
  8002d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002d8:	77 4b                	ja     800325 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002dd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	52                   	push   %edx
  8002e9:	50                   	push   %eax
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f0:	e8 27 14 00 00       	call   80171c <__udivdi3>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	ff 75 20             	pushl  0x20(%ebp)
  8002fe:	53                   	push   %ebx
  8002ff:	ff 75 18             	pushl  0x18(%ebp)
  800302:	52                   	push   %edx
  800303:	50                   	push   %eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 a1 ff ff ff       	call   8002b0 <printnum>
  80030f:	83 c4 20             	add    $0x20,%esp
  800312:	eb 1a                	jmp    80032e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	ff 75 0c             	pushl  0xc(%ebp)
  80031a:	ff 75 20             	pushl  0x20(%ebp)
  80031d:	8b 45 08             	mov    0x8(%ebp),%eax
  800320:	ff d0                	call   *%eax
  800322:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800325:	ff 4d 1c             	decl   0x1c(%ebp)
  800328:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80032c:	7f e6                	jg     800314 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800331:	bb 00 00 00 00       	mov    $0x0,%ebx
  800336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033c:	53                   	push   %ebx
  80033d:	51                   	push   %ecx
  80033e:	52                   	push   %edx
  80033f:	50                   	push   %eax
  800340:	e8 e7 14 00 00       	call   80182c <__umoddi3>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	05 94 1c 80 00       	add    $0x801c94,%eax
  80034d:	8a 00                	mov    (%eax),%al
  80034f:	0f be c0             	movsbl %al,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	50                   	push   %eax
  800359:	8b 45 08             	mov    0x8(%ebp),%eax
  80035c:	ff d0                	call   *%eax
  80035e:	83 c4 10             	add    $0x10,%esp
}
  800361:	90                   	nop
  800362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80036a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80036e:	7e 1c                	jle    80038c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	8d 50 08             	lea    0x8(%eax),%edx
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	89 10                	mov    %edx,(%eax)
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	83 e8 08             	sub    $0x8,%eax
  800385:	8b 50 04             	mov    0x4(%eax),%edx
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	eb 40                	jmp    8003cc <getuint+0x65>
	else if (lflag)
  80038c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800390:	74 1e                	je     8003b0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 50 04             	lea    0x4(%eax),%edx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	89 10                	mov    %edx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	83 e8 04             	sub    $0x4,%eax
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ae:	eb 1c                	jmp    8003cc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	8d 50 04             	lea    0x4(%eax),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	89 10                	mov    %edx,(%eax)
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	83 e8 04             	sub    $0x4,%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003cc:	5d                   	pop    %ebp
  8003cd:	c3                   	ret    

008003ce <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d5:	7e 1c                	jle    8003f3 <getint+0x25>
		return va_arg(*ap, long long);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 08             	lea    0x8(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 08             	sub    $0x8,%eax
  8003ec:	8b 50 04             	mov    0x4(%eax),%edx
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	eb 38                	jmp    80042b <getint+0x5d>
	else if (lflag)
  8003f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f7:	74 1a                	je     800413 <getint+0x45>
		return va_arg(*ap, long);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 04             	sub    $0x4,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	99                   	cltd   
  800411:	eb 18                	jmp    80042b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	8d 50 04             	lea    0x4(%eax),%edx
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	83 e8 04             	sub    $0x4,%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	99                   	cltd   
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	56                   	push   %esi
  800431:	53                   	push   %ebx
  800432:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800435:	eb 17                	jmp    80044e <vprintfmt+0x21>
			if (ch == '\0')
  800437:	85 db                	test   %ebx,%ebx
  800439:	0f 84 af 03 00 00    	je     8007ee <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	53                   	push   %ebx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044e:	8b 45 10             	mov    0x10(%ebp),%eax
  800451:	8d 50 01             	lea    0x1(%eax),%edx
  800454:	89 55 10             	mov    %edx,0x10(%ebp)
  800457:	8a 00                	mov    (%eax),%al
  800459:	0f b6 d8             	movzbl %al,%ebx
  80045c:	83 fb 25             	cmp    $0x25,%ebx
  80045f:	75 d6                	jne    800437 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800461:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800465:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80046c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800473:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80047a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 45 10             	mov    0x10(%ebp),%eax
  800484:	8d 50 01             	lea    0x1(%eax),%edx
  800487:	89 55 10             	mov    %edx,0x10(%ebp)
  80048a:	8a 00                	mov    (%eax),%al
  80048c:	0f b6 d8             	movzbl %al,%ebx
  80048f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800492:	83 f8 55             	cmp    $0x55,%eax
  800495:	0f 87 2b 03 00 00    	ja     8007c6 <vprintfmt+0x399>
  80049b:	8b 04 85 b8 1c 80 00 	mov    0x801cb8(,%eax,4),%eax
  8004a2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004a8:	eb d7                	jmp    800481 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004aa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004ae:	eb d1                	jmp    800481 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ba:	89 d0                	mov    %edx,%eax
  8004bc:	c1 e0 02             	shl    $0x2,%eax
  8004bf:	01 d0                	add    %edx,%eax
  8004c1:	01 c0                	add    %eax,%eax
  8004c3:	01 d8                	add    %ebx,%eax
  8004c5:	83 e8 30             	sub    $0x30,%eax
  8004c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	8a 00                	mov    (%eax),%al
  8004d0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004d3:	83 fb 2f             	cmp    $0x2f,%ebx
  8004d6:	7e 3e                	jle    800516 <vprintfmt+0xe9>
  8004d8:	83 fb 39             	cmp    $0x39,%ebx
  8004db:	7f 39                	jg     800516 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004dd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e0:	eb d5                	jmp    8004b7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	83 c0 04             	add    $0x4,%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	83 e8 04             	sub    $0x4,%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004f6:	eb 1f                	jmp    800517 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004fc:	79 83                	jns    800481 <vprintfmt+0x54>
				width = 0;
  8004fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800505:	e9 77 ff ff ff       	jmp    800481 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80050a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800511:	e9 6b ff ff ff       	jmp    800481 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800516:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800517:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051b:	0f 89 60 ff ff ff    	jns    800481 <vprintfmt+0x54>
				width = precision, precision = -1;
  800521:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800524:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800527:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80052e:	e9 4e ff ff ff       	jmp    800481 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800533:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800536:	e9 46 ff ff ff       	jmp    800481 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	83 c0 04             	add    $0x4,%eax
  800541:	89 45 14             	mov    %eax,0x14(%ebp)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	83 e8 04             	sub    $0x4,%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	ff d0                	call   *%eax
  800558:	83 c4 10             	add    $0x10,%esp
			break;
  80055b:	e9 89 02 00 00       	jmp    8007e9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	83 c0 04             	add    $0x4,%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	83 e8 04             	sub    $0x4,%eax
  80056f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800571:	85 db                	test   %ebx,%ebx
  800573:	79 02                	jns    800577 <vprintfmt+0x14a>
				err = -err;
  800575:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800577:	83 fb 64             	cmp    $0x64,%ebx
  80057a:	7f 0b                	jg     800587 <vprintfmt+0x15a>
  80057c:	8b 34 9d 00 1b 80 00 	mov    0x801b00(,%ebx,4),%esi
  800583:	85 f6                	test   %esi,%esi
  800585:	75 19                	jne    8005a0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800587:	53                   	push   %ebx
  800588:	68 a5 1c 80 00       	push   $0x801ca5
  80058d:	ff 75 0c             	pushl  0xc(%ebp)
  800590:	ff 75 08             	pushl  0x8(%ebp)
  800593:	e8 5e 02 00 00       	call   8007f6 <printfmt>
  800598:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80059b:	e9 49 02 00 00       	jmp    8007e9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a0:	56                   	push   %esi
  8005a1:	68 ae 1c 80 00       	push   $0x801cae
  8005a6:	ff 75 0c             	pushl  0xc(%ebp)
  8005a9:	ff 75 08             	pushl  0x8(%ebp)
  8005ac:	e8 45 02 00 00       	call   8007f6 <printfmt>
  8005b1:	83 c4 10             	add    $0x10,%esp
			break;
  8005b4:	e9 30 02 00 00       	jmp    8007e9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	83 c0 04             	add    $0x4,%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	83 e8 04             	sub    $0x4,%eax
  8005c8:	8b 30                	mov    (%eax),%esi
  8005ca:	85 f6                	test   %esi,%esi
  8005cc:	75 05                	jne    8005d3 <vprintfmt+0x1a6>
				p = "(null)";
  8005ce:	be b1 1c 80 00       	mov    $0x801cb1,%esi
			if (width > 0 && padc != '-')
  8005d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d7:	7e 6d                	jle    800646 <vprintfmt+0x219>
  8005d9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005dd:	74 67                	je     800646 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	56                   	push   %esi
  8005e7:	e8 0c 03 00 00       	call   8008f8 <strnlen>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005f2:	eb 16                	jmp    80060a <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005f4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	50                   	push   %eax
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	ff d0                	call   *%eax
  800604:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800607:	ff 4d e4             	decl   -0x1c(%ebp)
  80060a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060e:	7f e4                	jg     8005f4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800610:	eb 34                	jmp    800646 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800612:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800616:	74 1c                	je     800634 <vprintfmt+0x207>
  800618:	83 fb 1f             	cmp    $0x1f,%ebx
  80061b:	7e 05                	jle    800622 <vprintfmt+0x1f5>
  80061d:	83 fb 7e             	cmp    $0x7e,%ebx
  800620:	7e 12                	jle    800634 <vprintfmt+0x207>
					putch('?', putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	6a 3f                	push   $0x3f
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	ff d0                	call   *%eax
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	eb 0f                	jmp    800643 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	53                   	push   %ebx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800643:	ff 4d e4             	decl   -0x1c(%ebp)
  800646:	89 f0                	mov    %esi,%eax
  800648:	8d 70 01             	lea    0x1(%eax),%esi
  80064b:	8a 00                	mov    (%eax),%al
  80064d:	0f be d8             	movsbl %al,%ebx
  800650:	85 db                	test   %ebx,%ebx
  800652:	74 24                	je     800678 <vprintfmt+0x24b>
  800654:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800658:	78 b8                	js     800612 <vprintfmt+0x1e5>
  80065a:	ff 4d e0             	decl   -0x20(%ebp)
  80065d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800661:	79 af                	jns    800612 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800663:	eb 13                	jmp    800678 <vprintfmt+0x24b>
				putch(' ', putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	6a 20                	push   $0x20
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	ff d0                	call   *%eax
  800672:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800675:	ff 4d e4             	decl   -0x1c(%ebp)
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	7f e7                	jg     800665 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80067e:	e9 66 01 00 00       	jmp    8007e9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 e8             	pushl  -0x18(%ebp)
  800689:	8d 45 14             	lea    0x14(%ebp),%eax
  80068c:	50                   	push   %eax
  80068d:	e8 3c fd ff ff       	call   8003ce <getint>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800698:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80069b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a1:	85 d2                	test   %edx,%edx
  8006a3:	79 23                	jns    8006c8 <vprintfmt+0x29b>
				putch('-', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	6a 2d                	push   $0x2d
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	ff d0                	call   *%eax
  8006b2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bb:	f7 d8                	neg    %eax
  8006bd:	83 d2 00             	adc    $0x0,%edx
  8006c0:	f7 da                	neg    %edx
  8006c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006cf:	e9 bc 00 00 00       	jmp    800790 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8006da:	8d 45 14             	lea    0x14(%ebp),%eax
  8006dd:	50                   	push   %eax
  8006de:	e8 84 fc ff ff       	call   800367 <getuint>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f3:	e9 98 00 00 00       	jmp    800790 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	6a 58                	push   $0x58
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	6a 58                	push   $0x58
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	ff d0                	call   *%eax
  800715:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	6a 58                	push   $0x58
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	ff d0                	call   *%eax
  800725:	83 c4 10             	add    $0x10,%esp
			break;
  800728:	e9 bc 00 00 00       	jmp    8007e9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	6a 30                	push   $0x30
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	ff d0                	call   *%eax
  80073a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 78                	push   $0x78
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 c0 04             	add    $0x4,%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 e8 04             	sub    $0x4,%eax
  80075c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80075e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800761:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800768:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80076f:	eb 1f                	jmp    800790 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 e8             	pushl  -0x18(%ebp)
  800777:	8d 45 14             	lea    0x14(%ebp),%eax
  80077a:	50                   	push   %eax
  80077b:	e8 e7 fb ff ff       	call   800367 <getuint>
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800786:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800789:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800790:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800797:	83 ec 04             	sub    $0x4,%esp
  80079a:	52                   	push   %edx
  80079b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80079e:	50                   	push   %eax
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	e8 00 fb ff ff       	call   8002b0 <printnum>
  8007b0:	83 c4 20             	add    $0x20,%esp
			break;
  8007b3:	eb 34                	jmp    8007e9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
			break;
  8007c4:	eb 23                	jmp    8007e9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	6a 25                	push   $0x25
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d6:	ff 4d 10             	decl   0x10(%ebp)
  8007d9:	eb 03                	jmp    8007de <vprintfmt+0x3b1>
  8007db:	ff 4d 10             	decl   0x10(%ebp)
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	48                   	dec    %eax
  8007e2:	8a 00                	mov    (%eax),%al
  8007e4:	3c 25                	cmp    $0x25,%al
  8007e6:	75 f3                	jne    8007db <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007e8:	90                   	nop
		}
	}
  8007e9:	e9 47 fc ff ff       	jmp    800435 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007ee:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007f2:	5b                   	pop    %ebx
  8007f3:	5e                   	pop    %esi
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007fc:	8d 45 10             	lea    0x10(%ebp),%eax
  8007ff:	83 c0 04             	add    $0x4,%eax
  800802:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	ff 75 f4             	pushl  -0xc(%ebp)
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 16 fc ff ff       	call   80042d <vprintfmt>
  800817:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80081a:	90                   	nop
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    

0080081d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800820:	8b 45 0c             	mov    0xc(%ebp),%eax
  800823:	8b 40 08             	mov    0x8(%eax),%eax
  800826:	8d 50 01             	lea    0x1(%eax),%edx
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80082f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800832:	8b 10                	mov    (%eax),%edx
  800834:	8b 45 0c             	mov    0xc(%ebp),%eax
  800837:	8b 40 04             	mov    0x4(%eax),%eax
  80083a:	39 c2                	cmp    %eax,%edx
  80083c:	73 12                	jae    800850 <sprintputch+0x33>
		*b->buf++ = ch;
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	8d 48 01             	lea    0x1(%eax),%ecx
  800846:	8b 55 0c             	mov    0xc(%ebp),%edx
  800849:	89 0a                	mov    %ecx,(%edx)
  80084b:	8b 55 08             	mov    0x8(%ebp),%edx
  80084e:	88 10                	mov    %dl,(%eax)
}
  800850:	90                   	nop
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80085f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800862:	8d 50 ff             	lea    -0x1(%eax),%edx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800874:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800878:	74 06                	je     800880 <vsnprintf+0x2d>
  80087a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087e:	7f 07                	jg     800887 <vsnprintf+0x34>
		return -E_INVAL;
  800880:	b8 03 00 00 00       	mov    $0x3,%eax
  800885:	eb 20                	jmp    8008a7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800887:	ff 75 14             	pushl  0x14(%ebp)
  80088a:	ff 75 10             	pushl  0x10(%ebp)
  80088d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800890:	50                   	push   %eax
  800891:	68 1d 08 80 00       	push   $0x80081d
  800896:	e8 92 fb ff ff       	call   80042d <vprintfmt>
  80089b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80089e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008af:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b2:	83 c0 04             	add    $0x4,%eax
  8008b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 89 ff ff ff       	call   800853 <vsnprintf>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008e2:	eb 06                	jmp    8008ea <strlen+0x15>
		n++;
  8008e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e7:	ff 45 08             	incl   0x8(%ebp)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8a 00                	mov    (%eax),%al
  8008ef:	84 c0                	test   %al,%al
  8008f1:	75 f1                	jne    8008e4 <strlen+0xf>
		n++;
	return n;
  8008f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800905:	eb 09                	jmp    800910 <strnlen+0x18>
		n++;
  800907:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090a:	ff 45 08             	incl   0x8(%ebp)
  80090d:	ff 4d 0c             	decl   0xc(%ebp)
  800910:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800914:	74 09                	je     80091f <strnlen+0x27>
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8a 00                	mov    (%eax),%al
  80091b:	84 c0                	test   %al,%al
  80091d:	75 e8                	jne    800907 <strnlen+0xf>
		n++;
	return n;
  80091f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800930:	90                   	nop
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8d 50 01             	lea    0x1(%eax),%edx
  800937:	89 55 08             	mov    %edx,0x8(%ebp)
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800940:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800943:	8a 12                	mov    (%edx),%dl
  800945:	88 10                	mov    %dl,(%eax)
  800947:	8a 00                	mov    (%eax),%al
  800949:	84 c0                	test   %al,%al
  80094b:	75 e4                	jne    800931 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80094d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80095e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800965:	eb 1f                	jmp    800986 <strncpy+0x34>
		*dst++ = *src;
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8d 50 01             	lea    0x1(%eax),%edx
  80096d:	89 55 08             	mov    %edx,0x8(%ebp)
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	8a 12                	mov    (%edx),%dl
  800975:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	84 c0                	test   %al,%al
  80097e:	74 03                	je     800983 <strncpy+0x31>
			src++;
  800980:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800983:	ff 45 fc             	incl   -0x4(%ebp)
  800986:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800989:	3b 45 10             	cmp    0x10(%ebp),%eax
  80098c:	72 d9                	jb     800967 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80098e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80099f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009a3:	74 30                	je     8009d5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009a5:	eb 16                	jmp    8009bd <strlcpy+0x2a>
			*dst++ = *src++;
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	8d 50 01             	lea    0x1(%eax),%edx
  8009ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009b9:	8a 12                	mov    (%edx),%dl
  8009bb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009bd:	ff 4d 10             	decl   0x10(%ebp)
  8009c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c4:	74 09                	je     8009cf <strlcpy+0x3c>
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	84 c0                	test   %al,%al
  8009cd:	75 d8                	jne    8009a7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009db:	29 c2                	sub    %eax,%edx
  8009dd:	89 d0                	mov    %edx,%eax
}
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009e4:	eb 06                	jmp    8009ec <strcmp+0xb>
		p++, q++;
  8009e6:	ff 45 08             	incl   0x8(%ebp)
  8009e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	84 c0                	test   %al,%al
  8009f3:	74 0e                	je     800a03 <strcmp+0x22>
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8a 10                	mov    (%eax),%dl
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	38 c2                	cmp    %al,%dl
  800a01:	74 e3                	je     8009e6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	0f b6 d0             	movzbl %al,%edx
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	0f b6 c0             	movzbl %al,%eax
  800a13:	29 c2                	sub    %eax,%edx
  800a15:	89 d0                	mov    %edx,%eax
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a1c:	eb 09                	jmp    800a27 <strncmp+0xe>
		n--, p++, q++;
  800a1e:	ff 4d 10             	decl   0x10(%ebp)
  800a21:	ff 45 08             	incl   0x8(%ebp)
  800a24:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2b:	74 17                	je     800a44 <strncmp+0x2b>
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8a 00                	mov    (%eax),%al
  800a32:	84 c0                	test   %al,%al
  800a34:	74 0e                	je     800a44 <strncmp+0x2b>
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8a 10                	mov    (%eax),%dl
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	38 c2                	cmp    %al,%dl
  800a42:	74 da                	je     800a1e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a48:	75 07                	jne    800a51 <strncmp+0x38>
		return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4f:	eb 14                	jmp    800a65 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	0f b6 d0             	movzbl %al,%edx
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	29 c2                	sub    %eax,%edx
  800a63:	89 d0                	mov    %edx,%eax
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a73:	eb 12                	jmp    800a87 <strchr+0x20>
		if (*s == c)
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a7d:	75 05                	jne    800a84 <strchr+0x1d>
			return (char *) s;
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	eb 11                	jmp    800a95 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a84:	ff 45 08             	incl   0x8(%ebp)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	84 c0                	test   %al,%al
  800a8e:	75 e5                	jne    800a75 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 04             	sub    $0x4,%esp
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aa3:	eb 0d                	jmp    800ab2 <strfind+0x1b>
		if (*s == c)
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aad:	74 0e                	je     800abd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aaf:	ff 45 08             	incl   0x8(%ebp)
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8a 00                	mov    (%eax),%al
  800ab7:	84 c0                	test   %al,%al
  800ab9:	75 ea                	jne    800aa5 <strfind+0xe>
  800abb:	eb 01                	jmp    800abe <strfind+0x27>
		if (*s == c)
			break;
  800abd:	90                   	nop
	return (char *) s;
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ad5:	eb 0e                	jmp    800ae5 <memset+0x22>
		*p++ = c;
  800ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ae5:	ff 4d f8             	decl   -0x8(%ebp)
  800ae8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800aec:	79 e9                	jns    800ad7 <memset+0x14>
		*p++ = c;

	return v;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b05:	eb 16                	jmp    800b1d <memcpy+0x2a>
		*d++ = *s++;
  800b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b0a:	8d 50 01             	lea    0x1(%eax),%edx
  800b0d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b13:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b16:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b19:	8a 12                	mov    (%edx),%dl
  800b1b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b23:	89 55 10             	mov    %edx,0x10(%ebp)
  800b26:	85 c0                	test   %eax,%eax
  800b28:	75 dd                	jne    800b07 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b44:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b47:	73 50                	jae    800b99 <memmove+0x6a>
  800b49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4f:	01 d0                	add    %edx,%eax
  800b51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b54:	76 43                	jbe    800b99 <memmove+0x6a>
		s += n;
  800b56:	8b 45 10             	mov    0x10(%ebp),%eax
  800b59:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b62:	eb 10                	jmp    800b74 <memmove+0x45>
			*--d = *--s;
  800b64:	ff 4d f8             	decl   -0x8(%ebp)
  800b67:	ff 4d fc             	decl   -0x4(%ebp)
  800b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b6d:	8a 10                	mov    (%eax),%dl
  800b6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b72:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	75 e3                	jne    800b64 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b81:	eb 23                	jmp    800ba6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b86:	8d 50 01             	lea    0x1(%eax),%edx
  800b89:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b92:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b95:	8a 12                	mov    (%edx),%dl
  800b97:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9f:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba2:	85 c0                	test   %eax,%eax
  800ba4:	75 dd                	jne    800b83 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bbd:	eb 2a                	jmp    800be9 <memcmp+0x3e>
		if (*s1 != *s2)
  800bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc2:	8a 10                	mov    (%eax),%dl
  800bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	38 c2                	cmp    %al,%dl
  800bcb:	74 16                	je     800be3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	0f b6 d0             	movzbl %al,%edx
  800bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	0f b6 c0             	movzbl %al,%eax
  800bdd:	29 c2                	sub    %eax,%edx
  800bdf:	89 d0                	mov    %edx,%eax
  800be1:	eb 18                	jmp    800bfb <memcmp+0x50>
		s1++, s2++;
  800be3:	ff 45 fc             	incl   -0x4(%ebp)
  800be6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bef:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf2:	85 c0                	test   %eax,%eax
  800bf4:	75 c9                	jne    800bbf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c03:	8b 55 08             	mov    0x8(%ebp),%edx
  800c06:	8b 45 10             	mov    0x10(%ebp),%eax
  800c09:	01 d0                	add    %edx,%eax
  800c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c0e:	eb 15                	jmp    800c25 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	0f b6 d0             	movzbl %al,%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	0f b6 c0             	movzbl %al,%eax
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	74 0d                	je     800c2f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c22:	ff 45 08             	incl   0x8(%ebp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c2b:	72 e3                	jb     800c10 <memfind+0x13>
  800c2d:	eb 01                	jmp    800c30 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c2f:	90                   	nop
	return (void *) s;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c42:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c49:	eb 03                	jmp    800c4e <strtol+0x19>
		s++;
  800c4b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	3c 20                	cmp    $0x20,%al
  800c55:	74 f4                	je     800c4b <strtol+0x16>
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	3c 09                	cmp    $0x9,%al
  800c5e:	74 eb                	je     800c4b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	3c 2b                	cmp    $0x2b,%al
  800c67:	75 05                	jne    800c6e <strtol+0x39>
		s++;
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	eb 13                	jmp    800c81 <strtol+0x4c>
	else if (*s == '-')
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	3c 2d                	cmp    $0x2d,%al
  800c75:	75 0a                	jne    800c81 <strtol+0x4c>
		s++, neg = 1;
  800c77:	ff 45 08             	incl   0x8(%ebp)
  800c7a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c85:	74 06                	je     800c8d <strtol+0x58>
  800c87:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c8b:	75 20                	jne    800cad <strtol+0x78>
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3c 30                	cmp    $0x30,%al
  800c94:	75 17                	jne    800cad <strtol+0x78>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	40                   	inc    %eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3c 78                	cmp    $0x78,%al
  800c9e:	75 0d                	jne    800cad <strtol+0x78>
		s += 2, base = 16;
  800ca0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ca4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cab:	eb 28                	jmp    800cd5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb1:	75 15                	jne    800cc8 <strtol+0x93>
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	3c 30                	cmp    $0x30,%al
  800cba:	75 0c                	jne    800cc8 <strtol+0x93>
		s++, base = 8;
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cc6:	eb 0d                	jmp    800cd5 <strtol+0xa0>
	else if (base == 0)
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	75 07                	jne    800cd5 <strtol+0xa0>
		base = 10;
  800cce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 2f                	cmp    $0x2f,%al
  800cdc:	7e 19                	jle    800cf7 <strtol+0xc2>
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	3c 39                	cmp    $0x39,%al
  800ce5:	7f 10                	jg     800cf7 <strtol+0xc2>
			dig = *s - '0';
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	0f be c0             	movsbl %al,%eax
  800cef:	83 e8 30             	sub    $0x30,%eax
  800cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cf5:	eb 42                	jmp    800d39 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	3c 60                	cmp    $0x60,%al
  800cfe:	7e 19                	jle    800d19 <strtol+0xe4>
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	3c 7a                	cmp    $0x7a,%al
  800d07:	7f 10                	jg     800d19 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	0f be c0             	movsbl %al,%eax
  800d11:	83 e8 57             	sub    $0x57,%eax
  800d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d17:	eb 20                	jmp    800d39 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	3c 40                	cmp    $0x40,%al
  800d20:	7e 39                	jle    800d5b <strtol+0x126>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 5a                	cmp    $0x5a,%al
  800d29:	7f 30                	jg     800d5b <strtol+0x126>
			dig = *s - 'A' + 10;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f be c0             	movsbl %al,%eax
  800d33:	83 e8 37             	sub    $0x37,%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d3f:	7d 19                	jge    800d5a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d41:	ff 45 08             	incl   0x8(%ebp)
  800d44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d47:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4b:	89 c2                	mov    %eax,%edx
  800d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d50:	01 d0                	add    %edx,%eax
  800d52:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d55:	e9 7b ff ff ff       	jmp    800cd5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d5a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5f:	74 08                	je     800d69 <strtol+0x134>
		*endptr = (char *) s;
  800d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d6d:	74 07                	je     800d76 <strtol+0x141>
  800d6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d72:	f7 d8                	neg    %eax
  800d74:	eb 03                	jmp    800d79 <strtol+0x144>
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <ltostr>:

void
ltostr(long value, char *str)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d93:	79 13                	jns    800da8 <ltostr+0x2d>
	{
		neg = 1;
  800d95:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800da2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800da5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800db0:	99                   	cltd   
  800db1:	f7 f9                	idiv   %ecx
  800db3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbf:	89 c2                	mov    %eax,%edx
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	01 d0                	add    %edx,%eax
  800dc6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dc9:	83 c2 30             	add    $0x30,%edx
  800dcc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dd6:	f7 e9                	imul   %ecx
  800dd8:	c1 fa 02             	sar    $0x2,%edx
  800ddb:	89 c8                	mov    %ecx,%eax
  800ddd:	c1 f8 1f             	sar    $0x1f,%eax
  800de0:	29 c2                	sub    %eax,%edx
  800de2:	89 d0                	mov    %edx,%eax
  800de4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800de7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dea:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800def:	f7 e9                	imul   %ecx
  800df1:	c1 fa 02             	sar    $0x2,%edx
  800df4:	89 c8                	mov    %ecx,%eax
  800df6:	c1 f8 1f             	sar    $0x1f,%eax
  800df9:	29 c2                	sub    %eax,%edx
  800dfb:	89 d0                	mov    %edx,%eax
  800dfd:	c1 e0 02             	shl    $0x2,%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	01 c0                	add    %eax,%eax
  800e04:	29 c1                	sub    %eax,%ecx
  800e06:	89 ca                	mov    %ecx,%edx
  800e08:	85 d2                	test   %edx,%edx
  800e0a:	75 9c                	jne    800da8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e16:	48                   	dec    %eax
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e1e:	74 3d                	je     800e5d <ltostr+0xe2>
		start = 1 ;
  800e20:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e27:	eb 34                	jmp    800e5d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	01 c2                	add    %eax,%edx
  800e3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	01 c8                	add    %ecx,%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	01 c2                	add    %eax,%edx
  800e52:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e55:	88 02                	mov    %al,(%edx)
		start++ ;
  800e57:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e5a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e63:	7c c4                	jl     800e29 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e65:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	01 d0                	add    %edx,%eax
  800e6d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e70:	90                   	nop
  800e71:	c9                   	leave  
  800e72:	c3                   	ret    

00800e73 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e79:	ff 75 08             	pushl  0x8(%ebp)
  800e7c:	e8 54 fa ff ff       	call   8008d5 <strlen>
  800e81:	83 c4 04             	add    $0x4,%esp
  800e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	e8 46 fa ff ff       	call   8008d5 <strlen>
  800e8f:	83 c4 04             	add    $0x4,%esp
  800e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea3:	eb 17                	jmp    800ebc <strcconcat+0x49>
		final[s] = str1[s] ;
  800ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	01 c2                	add    %eax,%edx
  800ead:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	01 c8                	add    %ecx,%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800eb9:	ff 45 fc             	incl   -0x4(%ebp)
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ec2:	7c e1                	jl     800ea5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ec4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ecb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ed2:	eb 1f                	jmp    800ef3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed7:	8d 50 01             	lea    0x1(%eax),%edx
  800eda:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 c2                	add    %eax,%edx
  800ee4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	01 c8                	add    %ecx,%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ef0:	ff 45 f8             	incl   -0x8(%ebp)
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ef9:	7c d9                	jl     800ed4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800efb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	01 d0                	add    %edx,%eax
  800f03:	c6 00 00             	movb   $0x0,(%eax)
}
  800f06:	90                   	nop
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	8b 00                	mov    (%eax),%eax
  800f1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f2c:	eb 0c                	jmp    800f3a <strsplit+0x31>
			*string++ = 0;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8d 50 01             	lea    0x1(%eax),%edx
  800f34:	89 55 08             	mov    %edx,0x8(%ebp)
  800f37:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	84 c0                	test   %al,%al
  800f41:	74 18                	je     800f5b <strsplit+0x52>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f be c0             	movsbl %al,%eax
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	e8 13 fb ff ff       	call   800a67 <strchr>
  800f54:	83 c4 08             	add    $0x8,%esp
  800f57:	85 c0                	test   %eax,%eax
  800f59:	75 d3                	jne    800f2e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	84 c0                	test   %al,%al
  800f62:	74 5a                	je     800fbe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f64:	8b 45 14             	mov    0x14(%ebp),%eax
  800f67:	8b 00                	mov    (%eax),%eax
  800f69:	83 f8 0f             	cmp    $0xf,%eax
  800f6c:	75 07                	jne    800f75 <strsplit+0x6c>
		{
			return 0;
  800f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f73:	eb 66                	jmp    800fdb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	8b 00                	mov    (%eax),%eax
  800f7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800f7d:	8b 55 14             	mov    0x14(%ebp),%edx
  800f80:	89 0a                	mov    %ecx,(%edx)
  800f82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	01 c2                	add    %eax,%edx
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f93:	eb 03                	jmp    800f98 <strsplit+0x8f>
			string++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	84 c0                	test   %al,%al
  800f9f:	74 8b                	je     800f2c <strsplit+0x23>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f be c0             	movsbl %al,%eax
  800fa9:	50                   	push   %eax
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	e8 b5 fa ff ff       	call   800a67 <strchr>
  800fb2:	83 c4 08             	add    $0x8,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	74 dc                	je     800f95 <strsplit+0x8c>
			string++;
	}
  800fb9:	e9 6e ff ff ff       	jmp    800f2c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fbe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc2:	8b 00                	mov    (%eax),%eax
  800fc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	01 d0                	add    %edx,%eax
  800fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fd6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  800fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fea:	eb 4c                	jmp    801038 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  800fec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 27                	jle    801021 <str2lower+0x44>
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801000:	01 d0                	add    %edx,%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3c 5a                	cmp    $0x5a,%al
  801006:	7f 19                	jg     801021 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801008:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	01 d0                	add    %edx,%eax
  801010:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	01 ca                	add    %ecx,%edx
  801018:	8a 12                	mov    (%edx),%dl
  80101a:	83 c2 20             	add    $0x20,%edx
  80101d:	88 10                	mov    %dl,(%eax)
  80101f:	eb 14                	jmp    801035 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801021:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	01 c2                	add    %eax,%edx
  801029:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	01 c8                	add    %ecx,%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801035:	ff 45 fc             	incl   -0x4(%ebp)
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	e8 95 f8 ff ff       	call   8008d5 <strlen>
  801040:	83 c4 04             	add    $0x4,%esp
  801043:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801046:	7f a4                	jg     800fec <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80105f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801062:	8b 7d 18             	mov    0x18(%ebp),%edi
  801065:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801068:	cd 30                	int    $0x30
  80106a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80106d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 04             	sub    $0x4,%esp
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801084:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	6a 00                	push   $0x0
  80108d:	6a 00                	push   $0x0
  80108f:	52                   	push   %edx
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	50                   	push   %eax
  801094:	6a 00                	push   $0x0
  801096:	e8 b2 ff ff ff       	call   80104d <syscall>
  80109b:	83 c4 18             	add    $0x18,%esp
}
  80109e:	90                   	nop
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010a4:	6a 00                	push   $0x0
  8010a6:	6a 00                	push   $0x0
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	6a 00                	push   $0x0
  8010ae:	6a 01                	push   $0x1
  8010b0:	e8 98 ff ff ff       	call   80104d <syscall>
  8010b5:	83 c4 18             	add    $0x18,%esp
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	6a 00                	push   $0x0
  8010c9:	52                   	push   %edx
  8010ca:	50                   	push   %eax
  8010cb:	6a 05                	push   $0x5
  8010cd:	e8 7b ff ff ff       	call   80104d <syscall>
  8010d2:	83 c4 18             	add    $0x18,%esp
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8010df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	51                   	push   %ecx
  8010ee:	52                   	push   %edx
  8010ef:	50                   	push   %eax
  8010f0:	6a 06                	push   $0x6
  8010f2:	e8 56 ff ff ff       	call   80104d <syscall>
  8010f7:	83 c4 18             	add    $0x18,%esp
}
  8010fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	52                   	push   %edx
  801111:	50                   	push   %eax
  801112:	6a 07                	push   $0x7
  801114:	e8 34 ff ff ff       	call   80104d <syscall>
  801119:	83 c4 18             	add    $0x18,%esp
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801121:	6a 00                	push   $0x0
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	ff 75 08             	pushl  0x8(%ebp)
  80112d:	6a 08                	push   $0x8
  80112f:	e8 19 ff ff ff       	call   80104d <syscall>
  801134:	83 c4 18             	add    $0x18,%esp
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 00                	push   $0x0
  801146:	6a 09                	push   $0x9
  801148:	e8 00 ff ff ff       	call   80104d <syscall>
  80114d:	83 c4 18             	add    $0x18,%esp
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 0a                	push   $0xa
  801161:	e8 e7 fe ff ff       	call   80104d <syscall>
  801166:	83 c4 18             	add    $0x18,%esp
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 0b                	push   $0xb
  80117a:	e8 ce fe ff ff       	call   80104d <syscall>
  80117f:	83 c4 18             	add    $0x18,%esp
}
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 0c                	push   $0xc
  801193:	e8 b5 fe ff ff       	call   80104d <syscall>
  801198:	83 c4 18             	add    $0x18,%esp
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	6a 0d                	push   $0xd
  8011ad:	e8 9b fe ff ff       	call   80104d <syscall>
  8011b2:	83 c4 18             	add    $0x18,%esp
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 0e                	push   $0xe
  8011c6:	e8 82 fe ff ff       	call   80104d <syscall>
  8011cb:	83 c4 18             	add    $0x18,%esp
}
  8011ce:	90                   	nop
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 11                	push   $0x11
  8011e0:	e8 68 fe ff ff       	call   80104d <syscall>
  8011e5:	83 c4 18             	add    $0x18,%esp
}
  8011e8:	90                   	nop
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 12                	push   $0x12
  8011fa:	e8 4e fe ff ff       	call   80104d <syscall>
  8011ff:	83 c4 18             	add    $0x18,%esp
}
  801202:	90                   	nop
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <sys_cputc>:


void
sys_cputc(const char c)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801211:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	50                   	push   %eax
  80121e:	6a 13                	push   $0x13
  801220:	e8 28 fe ff ff       	call   80104d <syscall>
  801225:	83 c4 18             	add    $0x18,%esp
}
  801228:	90                   	nop
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 14                	push   $0x14
  80123a:	e8 0e fe ff ff       	call   80104d <syscall>
  80123f:	83 c4 18             	add    $0x18,%esp
}
  801242:	90                   	nop
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	50                   	push   %eax
  801255:	6a 15                	push   $0x15
  801257:	e8 f1 fd ff ff       	call   80104d <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801264:	8b 55 0c             	mov    0xc(%ebp),%edx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	52                   	push   %edx
  801271:	50                   	push   %eax
  801272:	6a 18                	push   $0x18
  801274:	e8 d4 fd ff ff       	call   80104d <syscall>
  801279:	83 c4 18             	add    $0x18,%esp
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801281:	8b 55 0c             	mov    0xc(%ebp),%edx
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	52                   	push   %edx
  80128e:	50                   	push   %eax
  80128f:	6a 16                	push   $0x16
  801291:	e8 b7 fd ff ff       	call   80104d <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80129f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	52                   	push   %edx
  8012ac:	50                   	push   %eax
  8012ad:	6a 17                	push   $0x17
  8012af:	e8 99 fd ff ff       	call   80104d <syscall>
  8012b4:	83 c4 18             	add    $0x18,%esp
}
  8012b7:	90                   	nop
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	6a 00                	push   $0x0
  8012d2:	51                   	push   %ecx
  8012d3:	52                   	push   %edx
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	50                   	push   %eax
  8012d8:	6a 19                	push   $0x19
  8012da:	e8 6e fd ff ff       	call   80104d <syscall>
  8012df:	83 c4 18             	add    $0x18,%esp
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	52                   	push   %edx
  8012f4:	50                   	push   %eax
  8012f5:	6a 1a                	push   $0x1a
  8012f7:	e8 51 fd ff ff       	call   80104d <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801304:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	51                   	push   %ecx
  801312:	52                   	push   %edx
  801313:	50                   	push   %eax
  801314:	6a 1b                	push   $0x1b
  801316:	e8 32 fd ff ff       	call   80104d <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	52                   	push   %edx
  801330:	50                   	push   %eax
  801331:	6a 1c                	push   $0x1c
  801333:	e8 15 fd ff ff       	call   80104d <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 1d                	push   $0x1d
  80134c:	e8 fc fc ff ff       	call   80104d <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	6a 00                	push   $0x0
  80135e:	ff 75 14             	pushl  0x14(%ebp)
  801361:	ff 75 10             	pushl  0x10(%ebp)
  801364:	ff 75 0c             	pushl  0xc(%ebp)
  801367:	50                   	push   %eax
  801368:	6a 1e                	push   $0x1e
  80136a:	e8 de fc ff ff       	call   80104d <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
}
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	50                   	push   %eax
  801383:	6a 1f                	push   $0x1f
  801385:	e8 c3 fc ff ff       	call   80104d <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	90                   	nop
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	50                   	push   %eax
  80139f:	6a 20                	push   $0x20
  8013a1:	e8 a7 fc ff ff       	call   80104d <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 02                	push   $0x2
  8013ba:	e8 8e fc ff ff       	call   80104d <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 03                	push   $0x3
  8013d3:	e8 75 fc ff ff       	call   80104d <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 04                	push   $0x4
  8013ec:	e8 5c fc ff ff       	call   80104d <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 21                	push   $0x21
  801405:	e8 43 fc ff ff       	call   80104d <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	90                   	nop
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801416:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801419:	8d 50 04             	lea    0x4(%eax),%edx
  80141c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	52                   	push   %edx
  801426:	50                   	push   %eax
  801427:	6a 22                	push   $0x22
  801429:	e8 1f fc ff ff       	call   80104d <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
	return result;
  801431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143a:	89 01                	mov    %eax,(%ecx)
  80143c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	c9                   	leave  
  801443:	c2 04 00             	ret    $0x4

00801446 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	ff 75 10             	pushl  0x10(%ebp)
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	ff 75 08             	pushl  0x8(%ebp)
  801456:	6a 10                	push   $0x10
  801458:	e8 f0 fb ff ff       	call   80104d <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
	return ;
  801460:	90                   	nop
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_rcr2>:
uint32 sys_rcr2()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 23                	push   $0x23
  801472:	e8 d6 fb ff ff       	call   80104d <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801488:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	50                   	push   %eax
  801495:	6a 24                	push   $0x24
  801497:	e8 b1 fb ff ff       	call   80104d <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
	return ;
  80149f:	90                   	nop
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <rsttst>:
void rsttst()
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 26                	push   $0x26
  8014b1:	e8 97 fb ff ff       	call   80104d <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b9:	90                   	nop
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8014cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014cf:	52                   	push   %edx
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 10             	pushl  0x10(%ebp)
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	ff 75 08             	pushl  0x8(%ebp)
  8014da:	6a 25                	push   $0x25
  8014dc:	e8 6c fb ff ff       	call   80104d <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e4:	90                   	nop
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <chktst>:
void chktst(uint32 n)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	6a 27                	push   $0x27
  8014f7:	e8 51 fb ff ff       	call   80104d <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ff:	90                   	nop
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <inctst>:

void inctst()
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 28                	push   $0x28
  801511:	e8 37 fb ff ff       	call   80104d <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
	return ;
  801519:	90                   	nop
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <gettst>:
uint32 gettst()
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 29                	push   $0x29
  80152b:	e8 1d fb ff ff       	call   80104d <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 2a                	push   $0x2a
  801547:	e8 01 fb ff ff       	call   80104d <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
  80154f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801552:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801556:	75 07                	jne    80155f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801558:	b8 01 00 00 00       	mov    $0x1,%eax
  80155d:	eb 05                	jmp    801564 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 2a                	push   $0x2a
  801578:	e8 d0 fa ff ff       	call   80104d <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
  801580:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801583:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801587:	75 07                	jne    801590 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801589:	b8 01 00 00 00       	mov    $0x1,%eax
  80158e:	eb 05                	jmp    801595 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 2a                	push   $0x2a
  8015a9:	e8 9f fa ff ff       	call   80104d <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
  8015b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015b8:	75 07                	jne    8015c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8015bf:	eb 05                	jmp    8015c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 2a                	push   $0x2a
  8015da:	e8 6e fa ff ff       	call   80104d <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015e9:	75 07                	jne    8015f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f0:	eb 05                	jmp    8015f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	6a 2b                	push   $0x2b
  801609:	e8 3f fa ff ff       	call   80104d <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return ;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801618:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80161b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	53                   	push   %ebx
  801627:	51                   	push   %ecx
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	6a 2c                	push   $0x2c
  80162c:	e8 1c fa ff ff       	call   80104d <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	52                   	push   %edx
  801649:	50                   	push   %eax
  80164a:	6a 2d                	push   $0x2d
  80164c:	e8 fc f9 ff ff       	call   80104d <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801659:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	51                   	push   %ecx
  801665:	ff 75 10             	pushl  0x10(%ebp)
  801668:	52                   	push   %edx
  801669:	50                   	push   %eax
  80166a:	6a 2e                	push   $0x2e
  80166c:	e8 dc f9 ff ff       	call   80104d <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	ff 75 10             	pushl  0x10(%ebp)
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	ff 75 08             	pushl  0x8(%ebp)
  801686:	6a 0f                	push   $0xf
  801688:	e8 c0 f9 ff ff       	call   80104d <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
	return ;
  801690:	90                   	nop
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	50                   	push   %eax
  8016a2:	6a 2f                	push   $0x2f
  8016a4:	e8 a4 f9 ff ff       	call   80104d <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp

}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	6a 30                	push   $0x30
  8016bf:	e8 89 f9 ff ff       	call   80104d <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
	return;
  8016c7:	90                   	nop
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 31                	push   $0x31
  8016db:	e8 6d f9 ff ff       	call   80104d <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 32                	push   $0x32
  8016f5:	e8 53 f9 ff ff       	call   80104d <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	50                   	push   %eax
  80170e:	6a 33                	push   $0x33
  801710:	e8 38 f9 ff ff       	call   80104d <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	90                   	nop
  801719:	c9                   	leave  
  80171a:	c3                   	ret    
  80171b:	90                   	nop

0080171c <__udivdi3>:
  80171c:	55                   	push   %ebp
  80171d:	57                   	push   %edi
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	83 ec 1c             	sub    $0x1c,%esp
  801723:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801727:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80172b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80172f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801733:	89 ca                	mov    %ecx,%edx
  801735:	89 f8                	mov    %edi,%eax
  801737:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80173b:	85 f6                	test   %esi,%esi
  80173d:	75 2d                	jne    80176c <__udivdi3+0x50>
  80173f:	39 cf                	cmp    %ecx,%edi
  801741:	77 65                	ja     8017a8 <__udivdi3+0x8c>
  801743:	89 fd                	mov    %edi,%ebp
  801745:	85 ff                	test   %edi,%edi
  801747:	75 0b                	jne    801754 <__udivdi3+0x38>
  801749:	b8 01 00 00 00       	mov    $0x1,%eax
  80174e:	31 d2                	xor    %edx,%edx
  801750:	f7 f7                	div    %edi
  801752:	89 c5                	mov    %eax,%ebp
  801754:	31 d2                	xor    %edx,%edx
  801756:	89 c8                	mov    %ecx,%eax
  801758:	f7 f5                	div    %ebp
  80175a:	89 c1                	mov    %eax,%ecx
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	f7 f5                	div    %ebp
  801760:	89 cf                	mov    %ecx,%edi
  801762:	89 fa                	mov    %edi,%edx
  801764:	83 c4 1c             	add    $0x1c,%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    
  80176c:	39 ce                	cmp    %ecx,%esi
  80176e:	77 28                	ja     801798 <__udivdi3+0x7c>
  801770:	0f bd fe             	bsr    %esi,%edi
  801773:	83 f7 1f             	xor    $0x1f,%edi
  801776:	75 40                	jne    8017b8 <__udivdi3+0x9c>
  801778:	39 ce                	cmp    %ecx,%esi
  80177a:	72 0a                	jb     801786 <__udivdi3+0x6a>
  80177c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801780:	0f 87 9e 00 00 00    	ja     801824 <__udivdi3+0x108>
  801786:	b8 01 00 00 00       	mov    $0x1,%eax
  80178b:	89 fa                	mov    %edi,%edx
  80178d:	83 c4 1c             	add    $0x1c,%esp
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5f                   	pop    %edi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    
  801795:	8d 76 00             	lea    0x0(%esi),%esi
  801798:	31 ff                	xor    %edi,%edi
  80179a:	31 c0                	xor    %eax,%eax
  80179c:	89 fa                	mov    %edi,%edx
  80179e:	83 c4 1c             	add    $0x1c,%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    
  8017a6:	66 90                	xchg   %ax,%ax
  8017a8:	89 d8                	mov    %ebx,%eax
  8017aa:	f7 f7                	div    %edi
  8017ac:	31 ff                	xor    %edi,%edi
  8017ae:	89 fa                	mov    %edi,%edx
  8017b0:	83 c4 1c             	add    $0x1c,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
  8017b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017bd:	89 eb                	mov    %ebp,%ebx
  8017bf:	29 fb                	sub    %edi,%ebx
  8017c1:	89 f9                	mov    %edi,%ecx
  8017c3:	d3 e6                	shl    %cl,%esi
  8017c5:	89 c5                	mov    %eax,%ebp
  8017c7:	88 d9                	mov    %bl,%cl
  8017c9:	d3 ed                	shr    %cl,%ebp
  8017cb:	89 e9                	mov    %ebp,%ecx
  8017cd:	09 f1                	or     %esi,%ecx
  8017cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017d3:	89 f9                	mov    %edi,%ecx
  8017d5:	d3 e0                	shl    %cl,%eax
  8017d7:	89 c5                	mov    %eax,%ebp
  8017d9:	89 d6                	mov    %edx,%esi
  8017db:	88 d9                	mov    %bl,%cl
  8017dd:	d3 ee                	shr    %cl,%esi
  8017df:	89 f9                	mov    %edi,%ecx
  8017e1:	d3 e2                	shl    %cl,%edx
  8017e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017e7:	88 d9                	mov    %bl,%cl
  8017e9:	d3 e8                	shr    %cl,%eax
  8017eb:	09 c2                	or     %eax,%edx
  8017ed:	89 d0                	mov    %edx,%eax
  8017ef:	89 f2                	mov    %esi,%edx
  8017f1:	f7 74 24 0c          	divl   0xc(%esp)
  8017f5:	89 d6                	mov    %edx,%esi
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	f7 e5                	mul    %ebp
  8017fb:	39 d6                	cmp    %edx,%esi
  8017fd:	72 19                	jb     801818 <__udivdi3+0xfc>
  8017ff:	74 0b                	je     80180c <__udivdi3+0xf0>
  801801:	89 d8                	mov    %ebx,%eax
  801803:	31 ff                	xor    %edi,%edi
  801805:	e9 58 ff ff ff       	jmp    801762 <__udivdi3+0x46>
  80180a:	66 90                	xchg   %ax,%ax
  80180c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801810:	89 f9                	mov    %edi,%ecx
  801812:	d3 e2                	shl    %cl,%edx
  801814:	39 c2                	cmp    %eax,%edx
  801816:	73 e9                	jae    801801 <__udivdi3+0xe5>
  801818:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80181b:	31 ff                	xor    %edi,%edi
  80181d:	e9 40 ff ff ff       	jmp    801762 <__udivdi3+0x46>
  801822:	66 90                	xchg   %ax,%ax
  801824:	31 c0                	xor    %eax,%eax
  801826:	e9 37 ff ff ff       	jmp    801762 <__udivdi3+0x46>
  80182b:	90                   	nop

0080182c <__umoddi3>:
  80182c:	55                   	push   %ebp
  80182d:	57                   	push   %edi
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 1c             	sub    $0x1c,%esp
  801833:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801837:	8b 74 24 34          	mov    0x34(%esp),%esi
  80183b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80183f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801843:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801847:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80184b:	89 f3                	mov    %esi,%ebx
  80184d:	89 fa                	mov    %edi,%edx
  80184f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801853:	89 34 24             	mov    %esi,(%esp)
  801856:	85 c0                	test   %eax,%eax
  801858:	75 1a                	jne    801874 <__umoddi3+0x48>
  80185a:	39 f7                	cmp    %esi,%edi
  80185c:	0f 86 a2 00 00 00    	jbe    801904 <__umoddi3+0xd8>
  801862:	89 c8                	mov    %ecx,%eax
  801864:	89 f2                	mov    %esi,%edx
  801866:	f7 f7                	div    %edi
  801868:	89 d0                	mov    %edx,%eax
  80186a:	31 d2                	xor    %edx,%edx
  80186c:	83 c4 1c             	add    $0x1c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
  801874:	39 f0                	cmp    %esi,%eax
  801876:	0f 87 ac 00 00 00    	ja     801928 <__umoddi3+0xfc>
  80187c:	0f bd e8             	bsr    %eax,%ebp
  80187f:	83 f5 1f             	xor    $0x1f,%ebp
  801882:	0f 84 ac 00 00 00    	je     801934 <__umoddi3+0x108>
  801888:	bf 20 00 00 00       	mov    $0x20,%edi
  80188d:	29 ef                	sub    %ebp,%edi
  80188f:	89 fe                	mov    %edi,%esi
  801891:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801895:	89 e9                	mov    %ebp,%ecx
  801897:	d3 e0                	shl    %cl,%eax
  801899:	89 d7                	mov    %edx,%edi
  80189b:	89 f1                	mov    %esi,%ecx
  80189d:	d3 ef                	shr    %cl,%edi
  80189f:	09 c7                	or     %eax,%edi
  8018a1:	89 e9                	mov    %ebp,%ecx
  8018a3:	d3 e2                	shl    %cl,%edx
  8018a5:	89 14 24             	mov    %edx,(%esp)
  8018a8:	89 d8                	mov    %ebx,%eax
  8018aa:	d3 e0                	shl    %cl,%eax
  8018ac:	89 c2                	mov    %eax,%edx
  8018ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b2:	d3 e0                	shl    %cl,%eax
  8018b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018bc:	89 f1                	mov    %esi,%ecx
  8018be:	d3 e8                	shr    %cl,%eax
  8018c0:	09 d0                	or     %edx,%eax
  8018c2:	d3 eb                	shr    %cl,%ebx
  8018c4:	89 da                	mov    %ebx,%edx
  8018c6:	f7 f7                	div    %edi
  8018c8:	89 d3                	mov    %edx,%ebx
  8018ca:	f7 24 24             	mull   (%esp)
  8018cd:	89 c6                	mov    %eax,%esi
  8018cf:	89 d1                	mov    %edx,%ecx
  8018d1:	39 d3                	cmp    %edx,%ebx
  8018d3:	0f 82 87 00 00 00    	jb     801960 <__umoddi3+0x134>
  8018d9:	0f 84 91 00 00 00    	je     801970 <__umoddi3+0x144>
  8018df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018e3:	29 f2                	sub    %esi,%edx
  8018e5:	19 cb                	sbb    %ecx,%ebx
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018ed:	d3 e0                	shl    %cl,%eax
  8018ef:	89 e9                	mov    %ebp,%ecx
  8018f1:	d3 ea                	shr    %cl,%edx
  8018f3:	09 d0                	or     %edx,%eax
  8018f5:	89 e9                	mov    %ebp,%ecx
  8018f7:	d3 eb                	shr    %cl,%ebx
  8018f9:	89 da                	mov    %ebx,%edx
  8018fb:	83 c4 1c             	add    $0x1c,%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5f                   	pop    %edi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    
  801903:	90                   	nop
  801904:	89 fd                	mov    %edi,%ebp
  801906:	85 ff                	test   %edi,%edi
  801908:	75 0b                	jne    801915 <__umoddi3+0xe9>
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	31 d2                	xor    %edx,%edx
  801911:	f7 f7                	div    %edi
  801913:	89 c5                	mov    %eax,%ebp
  801915:	89 f0                	mov    %esi,%eax
  801917:	31 d2                	xor    %edx,%edx
  801919:	f7 f5                	div    %ebp
  80191b:	89 c8                	mov    %ecx,%eax
  80191d:	f7 f5                	div    %ebp
  80191f:	89 d0                	mov    %edx,%eax
  801921:	e9 44 ff ff ff       	jmp    80186a <__umoddi3+0x3e>
  801926:	66 90                	xchg   %ax,%ax
  801928:	89 c8                	mov    %ecx,%eax
  80192a:	89 f2                	mov    %esi,%edx
  80192c:	83 c4 1c             	add    $0x1c,%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    
  801934:	3b 04 24             	cmp    (%esp),%eax
  801937:	72 06                	jb     80193f <__umoddi3+0x113>
  801939:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80193d:	77 0f                	ja     80194e <__umoddi3+0x122>
  80193f:	89 f2                	mov    %esi,%edx
  801941:	29 f9                	sub    %edi,%ecx
  801943:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801947:	89 14 24             	mov    %edx,(%esp)
  80194a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801952:	8b 14 24             	mov    (%esp),%edx
  801955:	83 c4 1c             	add    $0x1c,%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5f                   	pop    %edi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    
  80195d:	8d 76 00             	lea    0x0(%esi),%esi
  801960:	2b 04 24             	sub    (%esp),%eax
  801963:	19 fa                	sbb    %edi,%edx
  801965:	89 d1                	mov    %edx,%ecx
  801967:	89 c6                	mov    %eax,%esi
  801969:	e9 71 ff ff ff       	jmp    8018df <__umoddi3+0xb3>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801974:	72 ea                	jb     801960 <__umoddi3+0x134>
  801976:	89 d9                	mov    %ebx,%ecx
  801978:	e9 62 ff ff ff       	jmp    8018df <__umoddi3+0xb3>
