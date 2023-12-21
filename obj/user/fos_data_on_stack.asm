
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 a0 19 80 00       	push   $0x8019a0
  800049:	e8 35 02 00 00       	call   800283 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 6a 13 00 00       	call   8013c9 <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	01 c0                	add    %eax,%eax
  800069:	01 d0                	add    %edx,%eax
  80006b:	c1 e0 06             	shl    $0x6,%eax
  80006e:	29 d0                	sub    %edx,%eax
  800070:	c1 e0 03             	shl    $0x3,%eax
  800073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800078:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80007d:	a1 20 20 80 00       	mov    0x802020,%eax
  800082:	8a 40 68             	mov    0x68(%eax),%al
  800085:	84 c0                	test   %al,%al
  800087:	74 0d                	je     800096 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800089:	a1 20 20 80 00       	mov    0x802020,%eax
  80008e:	83 c0 68             	add    $0x68,%eax
  800091:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800096:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80009a:	7e 0a                	jle    8000a6 <libmain+0x52>
		binaryname = argv[0];
  80009c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009f:	8b 00                	mov    (%eax),%eax
  8000a1:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000a6:	83 ec 08             	sub    $0x8,%esp
  8000a9:	ff 75 0c             	pushl  0xc(%ebp)
  8000ac:	ff 75 08             	pushl  0x8(%ebp)
  8000af:	e8 84 ff ff ff       	call   800038 <_main>
  8000b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000b7:	e8 1a 11 00 00       	call   8011d6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 dc 19 80 00       	push   $0x8019dc
  8000c4:	e8 8d 01 00 00       	call   800256 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000cc:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d1:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000d7:	a1 20 20 80 00       	mov    0x802020,%eax
  8000dc:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	52                   	push   %edx
  8000e6:	50                   	push   %eax
  8000e7:	68 04 1a 80 00       	push   $0x801a04
  8000ec:	e8 65 01 00 00       	call   800256 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000f4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f9:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8000ff:	a1 20 20 80 00       	mov    0x802020,%eax
  800104:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80010a:	a1 20 20 80 00       	mov    0x802020,%eax
  80010f:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800115:	51                   	push   %ecx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	68 2c 1a 80 00       	push   $0x801a2c
  80011d:	e8 34 01 00 00       	call   800256 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800125:	a1 20 20 80 00       	mov    0x802020,%eax
  80012a:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	50                   	push   %eax
  800134:	68 84 1a 80 00       	push   $0x801a84
  800139:	e8 18 01 00 00       	call   800256 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 dc 19 80 00       	push   $0x8019dc
  800149:	e8 08 01 00 00       	call   800256 <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800151:	e8 9a 10 00 00       	call   8011f0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800156:	e8 19 00 00 00       	call   800174 <exit>
}
  80015b:	90                   	nop
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	6a 00                	push   $0x0
  800169:	e8 27 12 00 00       	call   801395 <sys_destroy_env>
  80016e:	83 c4 10             	add    $0x10,%esp
}
  800171:	90                   	nop
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <exit>:

void
exit(void)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80017a:	e8 7c 12 00 00       	call   8013fb <sys_exit_env>
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	8d 48 01             	lea    0x1(%eax),%ecx
  800190:	8b 55 0c             	mov    0xc(%ebp),%edx
  800193:	89 0a                	mov    %ecx,(%edx)
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	88 d1                	mov    %dl,%cl
  80019a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	8b 00                	mov    (%eax),%eax
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	75 2c                	jne    8001d9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001ad:	a0 24 20 80 00       	mov    0x802024,%al
  8001b2:	0f b6 c0             	movzbl %al,%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	8b 12                	mov    (%edx),%edx
  8001ba:	89 d1                	mov    %edx,%ecx
  8001bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bf:	83 c2 08             	add    $0x8,%edx
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	50                   	push   %eax
  8001c6:	51                   	push   %ecx
  8001c7:	52                   	push   %edx
  8001c8:	e8 b0 0e 00 00       	call   80107d <sys_cputs>
  8001cd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dc:	8b 40 04             	mov    0x4(%eax),%eax
  8001df:	8d 50 01             	lea    0x1(%eax),%edx
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fb:	00 00 00 
	b.cnt = 0;
  8001fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800205:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800208:	ff 75 0c             	pushl  0xc(%ebp)
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800214:	50                   	push   %eax
  800215:	68 82 01 80 00       	push   $0x800182
  80021a:	e8 11 02 00 00       	call   800430 <vprintfmt>
  80021f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800222:	a0 24 20 80 00       	mov    0x802024,%al
  800227:	0f b6 c0             	movzbl %al,%eax
  80022a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	50                   	push   %eax
  800234:	52                   	push   %edx
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	83 c0 08             	add    $0x8,%eax
  80023e:	50                   	push   %eax
  80023f:	e8 39 0e 00 00       	call   80107d <sys_cputs>
  800244:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800247:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80024e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800254:	c9                   	leave  
  800255:	c3                   	ret    

00800256 <cprintf>:

int cprintf(const char *fmt, ...) {
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80025c:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800263:	8d 45 0c             	lea    0xc(%ebp),%eax
  800266:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	83 ec 08             	sub    $0x8,%esp
  80026f:	ff 75 f4             	pushl  -0xc(%ebp)
  800272:	50                   	push   %eax
  800273:	e8 73 ff ff ff       	call   8001eb <vcprintf>
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800289:	e8 48 0f 00 00       	call   8011d6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800291:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	ff 75 f4             	pushl  -0xc(%ebp)
  80029d:	50                   	push   %eax
  80029e:	e8 48 ff ff ff       	call   8001eb <vcprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002a9:	e8 42 0f 00 00       	call   8011f0 <sys_enable_interrupt>
	return cnt;
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 14             	sub    $0x14,%esp
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d1:	77 55                	ja     800328 <printnum+0x75>
  8002d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d6:	72 05                	jb     8002dd <printnum+0x2a>
  8002d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002db:	77 4b                	ja     800328 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002dd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002eb:	52                   	push   %edx
  8002ec:	50                   	push   %eax
  8002ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f3:	e8 28 14 00 00       	call   801720 <__udivdi3>
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	ff 75 20             	pushl  0x20(%ebp)
  800301:	53                   	push   %ebx
  800302:	ff 75 18             	pushl  0x18(%ebp)
  800305:	52                   	push   %edx
  800306:	50                   	push   %eax
  800307:	ff 75 0c             	pushl  0xc(%ebp)
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	e8 a1 ff ff ff       	call   8002b3 <printnum>
  800312:	83 c4 20             	add    $0x20,%esp
  800315:	eb 1a                	jmp    800331 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	ff 75 20             	pushl  0x20(%ebp)
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	ff d0                	call   *%eax
  800325:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800328:	ff 4d 1c             	decl   0x1c(%ebp)
  80032b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80032f:	7f e6                	jg     800317 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800331:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800334:	bb 00 00 00 00       	mov    $0x0,%ebx
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033f:	53                   	push   %ebx
  800340:	51                   	push   %ecx
  800341:	52                   	push   %edx
  800342:	50                   	push   %eax
  800343:	e8 e8 14 00 00       	call   801830 <__umoddi3>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	05 b4 1c 80 00       	add    $0x801cb4,%eax
  800350:	8a 00                	mov    (%eax),%al
  800352:	0f be c0             	movsbl %al,%eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	50                   	push   %eax
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	ff d0                	call   *%eax
  800361:	83 c4 10             	add    $0x10,%esp
}
  800364:	90                   	nop
  800365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80036d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800371:	7e 1c                	jle    80038f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	8d 50 08             	lea    0x8(%eax),%edx
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	89 10                	mov    %edx,(%eax)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	83 e8 08             	sub    $0x8,%eax
  800388:	8b 50 04             	mov    0x4(%eax),%edx
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	eb 40                	jmp    8003cf <getuint+0x65>
	else if (lflag)
  80038f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800393:	74 1e                	je     8003b3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	8d 50 04             	lea    0x4(%eax),%edx
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	89 10                	mov    %edx,(%eax)
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	83 e8 04             	sub    $0x4,%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b1:	eb 1c                	jmp    8003cf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	8d 50 04             	lea    0x4(%eax),%edx
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	83 e8 04             	sub    $0x4,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d8:	7e 1c                	jle    8003f6 <getint+0x25>
		return va_arg(*ap, long long);
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	8d 50 08             	lea    0x8(%eax),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	89 10                	mov    %edx,(%eax)
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	83 e8 08             	sub    $0x8,%eax
  8003ef:	8b 50 04             	mov    0x4(%eax),%edx
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	eb 38                	jmp    80042e <getint+0x5d>
	else if (lflag)
  8003f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003fa:	74 1a                	je     800416 <getint+0x45>
		return va_arg(*ap, long);
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	8d 50 04             	lea    0x4(%eax),%edx
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	89 10                	mov    %edx,(%eax)
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	83 e8 04             	sub    $0x4,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	99                   	cltd   
  800414:	eb 18                	jmp    80042e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	8d 50 04             	lea    0x4(%eax),%edx
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	89 10                	mov    %edx,(%eax)
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	83 e8 04             	sub    $0x4,%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	99                   	cltd   
}
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	56                   	push   %esi
  800434:	53                   	push   %ebx
  800435:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800438:	eb 17                	jmp    800451 <vprintfmt+0x21>
			if (ch == '\0')
  80043a:	85 db                	test   %ebx,%ebx
  80043c:	0f 84 af 03 00 00    	je     8007f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	53                   	push   %ebx
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	ff d0                	call   *%eax
  80044e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800451:	8b 45 10             	mov    0x10(%ebp),%eax
  800454:	8d 50 01             	lea    0x1(%eax),%edx
  800457:	89 55 10             	mov    %edx,0x10(%ebp)
  80045a:	8a 00                	mov    (%eax),%al
  80045c:	0f b6 d8             	movzbl %al,%ebx
  80045f:	83 fb 25             	cmp    $0x25,%ebx
  800462:	75 d6                	jne    80043a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800464:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800468:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80046f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800476:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80047d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 45 10             	mov    0x10(%ebp),%eax
  800487:	8d 50 01             	lea    0x1(%eax),%edx
  80048a:	89 55 10             	mov    %edx,0x10(%ebp)
  80048d:	8a 00                	mov    (%eax),%al
  80048f:	0f b6 d8             	movzbl %al,%ebx
  800492:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800495:	83 f8 55             	cmp    $0x55,%eax
  800498:	0f 87 2b 03 00 00    	ja     8007c9 <vprintfmt+0x399>
  80049e:	8b 04 85 d8 1c 80 00 	mov    0x801cd8(,%eax,4),%eax
  8004a5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004ab:	eb d7                	jmp    800484 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004ad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004b1:	eb d1                	jmp    800484 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004bd:	89 d0                	mov    %edx,%eax
  8004bf:	c1 e0 02             	shl    $0x2,%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	01 d8                	add    %ebx,%eax
  8004c8:	83 e8 30             	sub    $0x30,%eax
  8004cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d1:	8a 00                	mov    (%eax),%al
  8004d3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004d6:	83 fb 2f             	cmp    $0x2f,%ebx
  8004d9:	7e 3e                	jle    800519 <vprintfmt+0xe9>
  8004db:	83 fb 39             	cmp    $0x39,%ebx
  8004de:	7f 39                	jg     800519 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e3:	eb d5                	jmp    8004ba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	83 c0 04             	add    $0x4,%eax
  8004eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	83 e8 04             	sub    $0x4,%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004f9:	eb 1f                	jmp    80051a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ff:	79 83                	jns    800484 <vprintfmt+0x54>
				width = 0;
  800501:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800508:	e9 77 ff ff ff       	jmp    800484 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80050d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800514:	e9 6b ff ff ff       	jmp    800484 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800519:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051e:	0f 89 60 ff ff ff    	jns    800484 <vprintfmt+0x54>
				width = precision, precision = -1;
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80052a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800531:	e9 4e ff ff ff       	jmp    800484 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800536:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800539:	e9 46 ff ff ff       	jmp    800484 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	83 c0 04             	add    $0x4,%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 e8 04             	sub    $0x4,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 0c             	pushl  0xc(%ebp)
  800555:	50                   	push   %eax
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	ff d0                	call   *%eax
  80055b:	83 c4 10             	add    $0x10,%esp
			break;
  80055e:	e9 89 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	83 c0 04             	add    $0x4,%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 e8 04             	sub    $0x4,%eax
  800572:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800574:	85 db                	test   %ebx,%ebx
  800576:	79 02                	jns    80057a <vprintfmt+0x14a>
				err = -err;
  800578:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80057a:	83 fb 64             	cmp    $0x64,%ebx
  80057d:	7f 0b                	jg     80058a <vprintfmt+0x15a>
  80057f:	8b 34 9d 20 1b 80 00 	mov    0x801b20(,%ebx,4),%esi
  800586:	85 f6                	test   %esi,%esi
  800588:	75 19                	jne    8005a3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80058a:	53                   	push   %ebx
  80058b:	68 c5 1c 80 00       	push   $0x801cc5
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 5e 02 00 00       	call   8007f9 <printfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80059e:	e9 49 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a3:	56                   	push   %esi
  8005a4:	68 ce 1c 80 00       	push   $0x801cce
  8005a9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ac:	ff 75 08             	pushl  0x8(%ebp)
  8005af:	e8 45 02 00 00       	call   8007f9 <printfmt>
  8005b4:	83 c4 10             	add    $0x10,%esp
			break;
  8005b7:	e9 30 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	83 c0 04             	add    $0x4,%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 e8 04             	sub    $0x4,%eax
  8005cb:	8b 30                	mov    (%eax),%esi
  8005cd:	85 f6                	test   %esi,%esi
  8005cf:	75 05                	jne    8005d6 <vprintfmt+0x1a6>
				p = "(null)";
  8005d1:	be d1 1c 80 00       	mov    $0x801cd1,%esi
			if (width > 0 && padc != '-')
  8005d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005da:	7e 6d                	jle    800649 <vprintfmt+0x219>
  8005dc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e0:	74 67                	je     800649 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	50                   	push   %eax
  8005e9:	56                   	push   %esi
  8005ea:	e8 0c 03 00 00       	call   8008fb <strnlen>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005f7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	ff 75 0c             	pushl  0xc(%ebp)
  800601:	50                   	push   %eax
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	ff d0                	call   *%eax
  800607:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	ff 4d e4             	decl   -0x1c(%ebp)
  80060d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800611:	7f e4                	jg     8005f7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800613:	eb 34                	jmp    800649 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800615:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800619:	74 1c                	je     800637 <vprintfmt+0x207>
  80061b:	83 fb 1f             	cmp    $0x1f,%ebx
  80061e:	7e 05                	jle    800625 <vprintfmt+0x1f5>
  800620:	83 fb 7e             	cmp    $0x7e,%ebx
  800623:	7e 12                	jle    800637 <vprintfmt+0x207>
					putch('?', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	6a 3f                	push   $0x3f
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	ff d0                	call   *%eax
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb 0f                	jmp    800646 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	53                   	push   %ebx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800646:	ff 4d e4             	decl   -0x1c(%ebp)
  800649:	89 f0                	mov    %esi,%eax
  80064b:	8d 70 01             	lea    0x1(%eax),%esi
  80064e:	8a 00                	mov    (%eax),%al
  800650:	0f be d8             	movsbl %al,%ebx
  800653:	85 db                	test   %ebx,%ebx
  800655:	74 24                	je     80067b <vprintfmt+0x24b>
  800657:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065b:	78 b8                	js     800615 <vprintfmt+0x1e5>
  80065d:	ff 4d e0             	decl   -0x20(%ebp)
  800660:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800664:	79 af                	jns    800615 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800666:	eb 13                	jmp    80067b <vprintfmt+0x24b>
				putch(' ', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	6a 20                	push   $0x20
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800678:	ff 4d e4             	decl   -0x1c(%ebp)
  80067b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067f:	7f e7                	jg     800668 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800681:	e9 66 01 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	ff 75 e8             	pushl  -0x18(%ebp)
  80068c:	8d 45 14             	lea    0x14(%ebp),%eax
  80068f:	50                   	push   %eax
  800690:	e8 3c fd ff ff       	call   8003d1 <getint>
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80069e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a4:	85 d2                	test   %edx,%edx
  8006a6:	79 23                	jns    8006cb <vprintfmt+0x29b>
				putch('-', putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	6a 2d                	push   $0x2d
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006be:	f7 d8                	neg    %eax
  8006c0:	83 d2 00             	adc    $0x0,%edx
  8006c3:	f7 da                	neg    %edx
  8006c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006d2:	e9 bc 00 00 00       	jmp    800793 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 e8             	pushl  -0x18(%ebp)
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	e8 84 fc ff ff       	call   80036a <getuint>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f6:	e9 98 00 00 00       	jmp    800793 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	6a 58                	push   $0x58
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	ff d0                	call   *%eax
  800708:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	6a 58                	push   $0x58
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	6a 58                	push   $0x58
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
			break;
  80072b:	e9 bc 00 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	6a 30                	push   $0x30
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	6a 78                	push   $0x78
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	83 c0 04             	add    $0x4,%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 e8 04             	sub    $0x4,%eax
  80075f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80076b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800772:	eb 1f                	jmp    800793 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 e8             	pushl  -0x18(%ebp)
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	e8 e7 fb ff ff       	call   80036a <getuint>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800789:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80078c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800793:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079a:	83 ec 04             	sub    $0x4,%esp
  80079d:	52                   	push   %edx
  80079e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 00 fb ff ff       	call   8002b3 <printnum>
  8007b3:	83 c4 20             	add    $0x20,%esp
			break;
  8007b6:	eb 34                	jmp    8007ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	53                   	push   %ebx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			break;
  8007c7:	eb 23                	jmp    8007ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	6a 25                	push   $0x25
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	ff d0                	call   *%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d9:	ff 4d 10             	decl   0x10(%ebp)
  8007dc:	eb 03                	jmp    8007e1 <vprintfmt+0x3b1>
  8007de:	ff 4d 10             	decl   0x10(%ebp)
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	48                   	dec    %eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	3c 25                	cmp    $0x25,%al
  8007e9:	75 f3                	jne    8007de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007eb:	90                   	nop
		}
	}
  8007ec:	e9 47 fc ff ff       	jmp    800438 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007ff:	8d 45 10             	lea    0x10(%ebp),%eax
  800802:	83 c0 04             	add    $0x4,%eax
  800805:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	ff 75 08             	pushl  0x8(%ebp)
  800815:	e8 16 fc ff ff       	call   800430 <vprintfmt>
  80081a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80081d:	90                   	nop
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800823:	8b 45 0c             	mov    0xc(%ebp),%eax
  800826:	8b 40 08             	mov    0x8(%eax),%eax
  800829:	8d 50 01             	lea    0x1(%eax),%edx
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800832:	8b 45 0c             	mov    0xc(%ebp),%eax
  800835:	8b 10                	mov    (%eax),%edx
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	8b 40 04             	mov    0x4(%eax),%eax
  80083d:	39 c2                	cmp    %eax,%edx
  80083f:	73 12                	jae    800853 <sprintputch+0x33>
		*b->buf++ = ch;
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	8d 48 01             	lea    0x1(%eax),%ecx
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 0a                	mov    %ecx,(%edx)
  80084e:	8b 55 08             	mov    0x8(%ebp),%edx
  800851:	88 10                	mov    %dl,(%eax)
}
  800853:	90                   	nop
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800862:	8b 45 0c             	mov    0xc(%ebp),%eax
  800865:	8d 50 ff             	lea    -0x1(%eax),%edx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800877:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80087b:	74 06                	je     800883 <vsnprintf+0x2d>
  80087d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800881:	7f 07                	jg     80088a <vsnprintf+0x34>
		return -E_INVAL;
  800883:	b8 03 00 00 00       	mov    $0x3,%eax
  800888:	eb 20                	jmp    8008aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088a:	ff 75 14             	pushl  0x14(%ebp)
  80088d:	ff 75 10             	pushl  0x10(%ebp)
  800890:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	68 20 08 80 00       	push   $0x800820
  800899:	e8 92 fb ff ff       	call   800430 <vprintfmt>
  80089e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008be:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c1:	50                   	push   %eax
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 08             	pushl  0x8(%ebp)
  8008c8:	e8 89 ff ff ff       	call   800856 <vsnprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008e5:	eb 06                	jmp    8008ed <strlen+0x15>
		n++;
  8008e7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ea:	ff 45 08             	incl   0x8(%ebp)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8a 00                	mov    (%eax),%al
  8008f2:	84 c0                	test   %al,%al
  8008f4:	75 f1                	jne    8008e7 <strlen+0xf>
		n++;
	return n;
  8008f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    

008008fb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800908:	eb 09                	jmp    800913 <strnlen+0x18>
		n++;
  80090a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090d:	ff 45 08             	incl   0x8(%ebp)
  800910:	ff 4d 0c             	decl   0xc(%ebp)
  800913:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800917:	74 09                	je     800922 <strnlen+0x27>
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8a 00                	mov    (%eax),%al
  80091e:	84 c0                	test   %al,%al
  800920:	75 e8                	jne    80090a <strnlen+0xf>
		n++;
	return n;
  800922:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800933:	90                   	nop
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8d 50 01             	lea    0x1(%eax),%edx
  80093a:	89 55 08             	mov    %edx,0x8(%ebp)
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	8d 4a 01             	lea    0x1(%edx),%ecx
  800943:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800946:	8a 12                	mov    (%edx),%dl
  800948:	88 10                	mov    %dl,(%eax)
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	84 c0                	test   %al,%al
  80094e:	75 e4                	jne    800934 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800950:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800968:	eb 1f                	jmp    800989 <strncpy+0x34>
		*dst++ = *src;
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 08             	mov    %edx,0x8(%ebp)
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	8a 12                	mov    (%edx),%dl
  800978:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80097a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	84 c0                	test   %al,%al
  800981:	74 03                	je     800986 <strncpy+0x31>
			src++;
  800983:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800986:	ff 45 fc             	incl   -0x4(%ebp)
  800989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80098c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80098f:	72 d9                	jb     80096a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800991:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    

00800996 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009a6:	74 30                	je     8009d8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009a8:	eb 16                	jmp    8009c0 <strlcpy+0x2a>
			*dst++ = *src++;
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009bc:	8a 12                	mov    (%edx),%dl
  8009be:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c0:	ff 4d 10             	decl   0x10(%ebp)
  8009c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c7:	74 09                	je     8009d2 <strlcpy+0x3c>
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 d8                	jne    8009aa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009de:	29 c2                	sub    %eax,%edx
  8009e0:	89 d0                	mov    %edx,%eax
}
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009e7:	eb 06                	jmp    8009ef <strcmp+0xb>
		p++, q++;
  8009e9:	ff 45 08             	incl   0x8(%ebp)
  8009ec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8a 00                	mov    (%eax),%al
  8009f4:	84 c0                	test   %al,%al
  8009f6:	74 0e                	je     800a06 <strcmp+0x22>
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8a 10                	mov    (%eax),%dl
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	38 c2                	cmp    %al,%dl
  800a04:	74 e3                	je     8009e9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	0f b6 d0             	movzbl %al,%edx
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	8a 00                	mov    (%eax),%al
  800a13:	0f b6 c0             	movzbl %al,%eax
  800a16:	29 c2                	sub    %eax,%edx
  800a18:	89 d0                	mov    %edx,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a1f:	eb 09                	jmp    800a2a <strncmp+0xe>
		n--, p++, q++;
  800a21:	ff 4d 10             	decl   0x10(%ebp)
  800a24:	ff 45 08             	incl   0x8(%ebp)
  800a27:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2e:	74 17                	je     800a47 <strncmp+0x2b>
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8a 00                	mov    (%eax),%al
  800a35:	84 c0                	test   %al,%al
  800a37:	74 0e                	je     800a47 <strncmp+0x2b>
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8a 10                	mov    (%eax),%dl
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	38 c2                	cmp    %al,%dl
  800a45:	74 da                	je     800a21 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4b:	75 07                	jne    800a54 <strncmp+0x38>
		return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a52:	eb 14                	jmp    800a68 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	0f b6 d0             	movzbl %al,%edx
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	0f b6 c0             	movzbl %al,%eax
  800a64:	29 c2                	sub    %eax,%edx
  800a66:	89 d0                	mov    %edx,%eax
}
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a76:	eb 12                	jmp    800a8a <strchr+0x20>
		if (*s == c)
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a80:	75 05                	jne    800a87 <strchr+0x1d>
			return (char *) s;
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	eb 11                	jmp    800a98 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a87:	ff 45 08             	incl   0x8(%ebp)
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	84 c0                	test   %al,%al
  800a91:	75 e5                	jne    800a78 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 04             	sub    $0x4,%esp
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aa6:	eb 0d                	jmp    800ab5 <strfind+0x1b>
		if (*s == c)
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab0:	74 0e                	je     800ac0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ab2:	ff 45 08             	incl   0x8(%ebp)
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	84 c0                	test   %al,%al
  800abc:	75 ea                	jne    800aa8 <strfind+0xe>
  800abe:	eb 01                	jmp    800ac1 <strfind+0x27>
		if (*s == c)
			break;
  800ac0:	90                   	nop
	return (char *) s;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ad8:	eb 0e                	jmp    800ae8 <memset+0x22>
		*p++ = c;
  800ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800add:	8d 50 01             	lea    0x1(%eax),%edx
  800ae0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ae8:	ff 4d f8             	decl   -0x8(%ebp)
  800aeb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800aef:	79 e9                	jns    800ada <memset+0x14>
		*p++ = c;

	return v;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b08:	eb 16                	jmp    800b20 <memcpy+0x2a>
		*d++ = *s++;
  800b0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b0d:	8d 50 01             	lea    0x1(%eax),%edx
  800b10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b1c:	8a 12                	mov    (%edx),%dl
  800b1e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b20:	8b 45 10             	mov    0x10(%ebp),%eax
  800b23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b26:	89 55 10             	mov    %edx,0x10(%ebp)
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	75 dd                	jne    800b0a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b4a:	73 50                	jae    800b9c <memmove+0x6a>
  800b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	01 d0                	add    %edx,%eax
  800b54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b57:	76 43                	jbe    800b9c <memmove+0x6a>
		s += n;
  800b59:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b62:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b65:	eb 10                	jmp    800b77 <memmove+0x45>
			*--d = *--s;
  800b67:	ff 4d f8             	decl   -0x8(%ebp)
  800b6a:	ff 4d fc             	decl   -0x4(%ebp)
  800b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b70:	8a 10                	mov    (%eax),%dl
  800b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b75:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b77:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800b80:	85 c0                	test   %eax,%eax
  800b82:	75 e3                	jne    800b67 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b84:	eb 23                	jmp    800ba9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b89:	8d 50 01             	lea    0x1(%eax),%edx
  800b8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b95:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b98:	8a 12                	mov    (%edx),%dl
  800b9a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	75 dd                	jne    800b86 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bc0:	eb 2a                	jmp    800bec <memcmp+0x3e>
		if (*s1 != *s2)
  800bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc5:	8a 10                	mov    (%eax),%dl
  800bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	38 c2                	cmp    %al,%dl
  800bce:	74 16                	je     800be6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	0f b6 d0             	movzbl %al,%edx
  800bd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	0f b6 c0             	movzbl %al,%eax
  800be0:	29 c2                	sub    %eax,%edx
  800be2:	89 d0                	mov    %edx,%eax
  800be4:	eb 18                	jmp    800bfe <memcmp+0x50>
		s1++, s2++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
  800be9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
  800bef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf2:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	75 c9                	jne    800bc2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0c:	01 d0                	add    %edx,%eax
  800c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c11:	eb 15                	jmp    800c28 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 d0             	movzbl %al,%edx
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	0f b6 c0             	movzbl %al,%eax
  800c21:	39 c2                	cmp    %eax,%edx
  800c23:	74 0d                	je     800c32 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c25:	ff 45 08             	incl   0x8(%ebp)
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c2e:	72 e3                	jb     800c13 <memfind+0x13>
  800c30:	eb 01                	jmp    800c33 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c32:	90                   	nop
	return (void *) s;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4c:	eb 03                	jmp    800c51 <strtol+0x19>
		s++;
  800c4e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	3c 20                	cmp    $0x20,%al
  800c58:	74 f4                	je     800c4e <strtol+0x16>
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	3c 09                	cmp    $0x9,%al
  800c61:	74 eb                	je     800c4e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	3c 2b                	cmp    $0x2b,%al
  800c6a:	75 05                	jne    800c71 <strtol+0x39>
		s++;
  800c6c:	ff 45 08             	incl   0x8(%ebp)
  800c6f:	eb 13                	jmp    800c84 <strtol+0x4c>
	else if (*s == '-')
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3c 2d                	cmp    $0x2d,%al
  800c78:	75 0a                	jne    800c84 <strtol+0x4c>
		s++, neg = 1;
  800c7a:	ff 45 08             	incl   0x8(%ebp)
  800c7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c88:	74 06                	je     800c90 <strtol+0x58>
  800c8a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c8e:	75 20                	jne    800cb0 <strtol+0x78>
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	3c 30                	cmp    $0x30,%al
  800c97:	75 17                	jne    800cb0 <strtol+0x78>
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	40                   	inc    %eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	3c 78                	cmp    $0x78,%al
  800ca1:	75 0d                	jne    800cb0 <strtol+0x78>
		s += 2, base = 16;
  800ca3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ca7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cae:	eb 28                	jmp    800cd8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	75 15                	jne    800ccb <strtol+0x93>
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	3c 30                	cmp    $0x30,%al
  800cbd:	75 0c                	jne    800ccb <strtol+0x93>
		s++, base = 8;
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cc9:	eb 0d                	jmp    800cd8 <strtol+0xa0>
	else if (base == 0)
  800ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccf:	75 07                	jne    800cd8 <strtol+0xa0>
		base = 10;
  800cd1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	3c 2f                	cmp    $0x2f,%al
  800cdf:	7e 19                	jle    800cfa <strtol+0xc2>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	3c 39                	cmp    $0x39,%al
  800ce8:	7f 10                	jg     800cfa <strtol+0xc2>
			dig = *s - '0';
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	0f be c0             	movsbl %al,%eax
  800cf2:	83 e8 30             	sub    $0x30,%eax
  800cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cf8:	eb 42                	jmp    800d3c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	3c 60                	cmp    $0x60,%al
  800d01:	7e 19                	jle    800d1c <strtol+0xe4>
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 7a                	cmp    $0x7a,%al
  800d0a:	7f 10                	jg     800d1c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f be c0             	movsbl %al,%eax
  800d14:	83 e8 57             	sub    $0x57,%eax
  800d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d1a:	eb 20                	jmp    800d3c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	3c 40                	cmp    $0x40,%al
  800d23:	7e 39                	jle    800d5e <strtol+0x126>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 5a                	cmp    $0x5a,%al
  800d2c:	7f 30                	jg     800d5e <strtol+0x126>
			dig = *s - 'A' + 10;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f be c0             	movsbl %al,%eax
  800d36:	83 e8 37             	sub    $0x37,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d42:	7d 19                	jge    800d5d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4e:	89 c2                	mov    %eax,%edx
  800d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d53:	01 d0                	add    %edx,%eax
  800d55:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d58:	e9 7b ff ff ff       	jmp    800cd8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d5d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d62:	74 08                	je     800d6c <strtol+0x134>
		*endptr = (char *) s;
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d70:	74 07                	je     800d79 <strtol+0x141>
  800d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d75:	f7 d8                	neg    %eax
  800d77:	eb 03                	jmp    800d7c <strtol+0x144>
  800d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <ltostr>:

void
ltostr(long value, char *str)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d96:	79 13                	jns    800dab <ltostr+0x2d>
	{
		neg = 1;
  800d98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800da5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800da8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800db3:	99                   	cltd   
  800db4:	f7 f9                	idiv   %ecx
  800db6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc2:	89 c2                	mov    %eax,%edx
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	01 d0                	add    %edx,%eax
  800dc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dcc:	83 c2 30             	add    $0x30,%edx
  800dcf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dd9:	f7 e9                	imul   %ecx
  800ddb:	c1 fa 02             	sar    $0x2,%edx
  800dde:	89 c8                	mov    %ecx,%eax
  800de0:	c1 f8 1f             	sar    $0x1f,%eax
  800de3:	29 c2                	sub    %eax,%edx
  800de5:	89 d0                	mov    %edx,%eax
  800de7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df2:	f7 e9                	imul   %ecx
  800df4:	c1 fa 02             	sar    $0x2,%edx
  800df7:	89 c8                	mov    %ecx,%eax
  800df9:	c1 f8 1f             	sar    $0x1f,%eax
  800dfc:	29 c2                	sub    %eax,%edx
  800dfe:	89 d0                	mov    %edx,%eax
  800e00:	c1 e0 02             	shl    $0x2,%eax
  800e03:	01 d0                	add    %edx,%eax
  800e05:	01 c0                	add    %eax,%eax
  800e07:	29 c1                	sub    %eax,%ecx
  800e09:	89 ca                	mov    %ecx,%edx
  800e0b:	85 d2                	test   %edx,%edx
  800e0d:	75 9c                	jne    800dab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e19:	48                   	dec    %eax
  800e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e21:	74 3d                	je     800e60 <ltostr+0xe2>
		start = 1 ;
  800e23:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e2a:	eb 34                	jmp    800e60 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	01 c2                	add    %eax,%edx
  800e41:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	01 c8                	add    %ecx,%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	01 c2                	add    %eax,%edx
  800e55:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e58:	88 02                	mov    %al,(%edx)
		start++ ;
  800e5a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e5d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e66:	7c c4                	jl     800e2c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e68:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	01 d0                	add    %edx,%eax
  800e70:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e73:	90                   	nop
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e7c:	ff 75 08             	pushl  0x8(%ebp)
  800e7f:	e8 54 fa ff ff       	call   8008d8 <strlen>
  800e84:	83 c4 04             	add    $0x4,%esp
  800e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	e8 46 fa ff ff       	call   8008d8 <strlen>
  800e92:	83 c4 04             	add    $0x4,%esp
  800e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea6:	eb 17                	jmp    800ebf <strcconcat+0x49>
		final[s] = str1[s] ;
  800ea8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
  800eae:	01 c2                	add    %eax,%edx
  800eb0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	01 c8                	add    %ecx,%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ebc:	ff 45 fc             	incl   -0x4(%ebp)
  800ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ec5:	7c e1                	jl     800ea8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ec7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ece:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ed5:	eb 1f                	jmp    800ef6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	8d 50 01             	lea    0x1(%eax),%edx
  800edd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee0:	89 c2                	mov    %eax,%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 c2                	add    %eax,%edx
  800ee7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 c8                	add    %ecx,%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ef3:	ff 45 f8             	incl   -0x8(%ebp)
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800efc:	7c d9                	jl     800ed7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800efe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f01:	8b 45 10             	mov    0x10(%ebp),%eax
  800f04:	01 d0                	add    %edx,%eax
  800f06:	c6 00 00             	movb   $0x0,(%eax)
}
  800f09:	90                   	nop
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f18:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1b:	8b 00                	mov    (%eax),%eax
  800f1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f2f:	eb 0c                	jmp    800f3d <strsplit+0x31>
			*string++ = 0;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8d 50 01             	lea    0x1(%eax),%edx
  800f37:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	84 c0                	test   %al,%al
  800f44:	74 18                	je     800f5e <strsplit+0x52>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be c0             	movsbl %al,%eax
  800f4e:	50                   	push   %eax
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	e8 13 fb ff ff       	call   800a6a <strchr>
  800f57:	83 c4 08             	add    $0x8,%esp
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	75 d3                	jne    800f31 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	74 5a                	je     800fc1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f67:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6a:	8b 00                	mov    (%eax),%eax
  800f6c:	83 f8 0f             	cmp    $0xf,%eax
  800f6f:	75 07                	jne    800f78 <strsplit+0x6c>
		{
			return 0;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
  800f76:	eb 66                	jmp    800fde <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	8d 48 01             	lea    0x1(%eax),%ecx
  800f80:	8b 55 14             	mov    0x14(%ebp),%edx
  800f83:	89 0a                	mov    %ecx,(%edx)
  800f85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 c2                	add    %eax,%edx
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f96:	eb 03                	jmp    800f9b <strsplit+0x8f>
			string++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	74 8b                	je     800f2f <strsplit+0x23>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f be c0             	movsbl %al,%eax
  800fac:	50                   	push   %eax
  800fad:	ff 75 0c             	pushl  0xc(%ebp)
  800fb0:	e8 b5 fa ff ff       	call   800a6a <strchr>
  800fb5:	83 c4 08             	add    $0x8,%esp
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	74 dc                	je     800f98 <strsplit+0x8c>
			string++;
	}
  800fbc:	e9 6e ff ff ff       	jmp    800f2f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fc1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc5:	8b 00                	mov    (%eax),%eax
  800fc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	01 d0                	add    %edx,%eax
  800fd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fd9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  800fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fed:	eb 4c                	jmp    80103b <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  800fef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	01 d0                	add    %edx,%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 40                	cmp    $0x40,%al
  800ffb:	7e 27                	jle    801024 <str2lower+0x44>
  800ffd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 19                	jg     801024 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801016:	8b 55 0c             	mov    0xc(%ebp),%edx
  801019:	01 ca                	add    %ecx,%edx
  80101b:	8a 12                	mov    (%edx),%dl
  80101d:	83 c2 20             	add    $0x20,%edx
  801020:	88 10                	mov    %dl,(%eax)
  801022:	eb 14                	jmp    801038 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	01 c2                	add    %eax,%edx
  80102c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	01 c8                	add    %ecx,%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 75 0c             	pushl  0xc(%ebp)
  80103e:	e8 95 f8 ff ff       	call   8008d8 <strlen>
  801043:	83 c4 04             	add    $0x4,%esp
  801046:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801049:	7f a4                	jg     800fef <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
  801058:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801061:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801064:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801067:	8b 7d 18             	mov    0x18(%ebp),%edi
  80106a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80106d:	cd 30                	int    $0x30
  80106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801072:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801075:	83 c4 10             	add    $0x10,%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801089:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	6a 00                	push   $0x0
  801092:	6a 00                	push   $0x0
  801094:	52                   	push   %edx
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	50                   	push   %eax
  801099:	6a 00                	push   $0x0
  80109b:	e8 b2 ff ff ff       	call   801052 <syscall>
  8010a0:	83 c4 18             	add    $0x18,%esp
}
  8010a3:	90                   	nop
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010a9:	6a 00                	push   $0x0
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	6a 00                	push   $0x0
  8010b3:	6a 01                	push   $0x1
  8010b5:	e8 98 ff ff ff       	call   801052 <syscall>
  8010ba:	83 c4 18             	add    $0x18,%esp
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	6a 00                	push   $0x0
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	52                   	push   %edx
  8010cf:	50                   	push   %eax
  8010d0:	6a 05                	push   $0x5
  8010d2:	e8 7b ff ff ff       	call   801052 <syscall>
  8010d7:	83 c4 18             	add    $0x18,%esp
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	51                   	push   %ecx
  8010f3:	52                   	push   %edx
  8010f4:	50                   	push   %eax
  8010f5:	6a 06                	push   $0x6
  8010f7:	e8 56 ff ff ff       	call   801052 <syscall>
  8010fc:	83 c4 18             	add    $0x18,%esp
}
  8010ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	52                   	push   %edx
  801116:	50                   	push   %eax
  801117:	6a 07                	push   $0x7
  801119:	e8 34 ff ff ff       	call   801052 <syscall>
  80111e:	83 c4 18             	add    $0x18,%esp
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	ff 75 0c             	pushl  0xc(%ebp)
  80112f:	ff 75 08             	pushl  0x8(%ebp)
  801132:	6a 08                	push   $0x8
  801134:	e8 19 ff ff ff       	call   801052 <syscall>
  801139:	83 c4 18             	add    $0x18,%esp
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 09                	push   $0x9
  80114d:	e8 00 ff ff ff       	call   801052 <syscall>
  801152:	83 c4 18             	add    $0x18,%esp
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 0a                	push   $0xa
  801166:	e8 e7 fe ff ff       	call   801052 <syscall>
  80116b:	83 c4 18             	add    $0x18,%esp
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 0b                	push   $0xb
  80117f:	e8 ce fe ff ff       	call   801052 <syscall>
  801184:	83 c4 18             	add    $0x18,%esp
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 0c                	push   $0xc
  801198:	e8 b5 fe ff ff       	call   801052 <syscall>
  80119d:	83 c4 18             	add    $0x18,%esp
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	ff 75 08             	pushl  0x8(%ebp)
  8011b0:	6a 0d                	push   $0xd
  8011b2:	e8 9b fe ff ff       	call   801052 <syscall>
  8011b7:	83 c4 18             	add    $0x18,%esp
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 0e                	push   $0xe
  8011cb:	e8 82 fe ff ff       	call   801052 <syscall>
  8011d0:	83 c4 18             	add    $0x18,%esp
}
  8011d3:	90                   	nop
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 11                	push   $0x11
  8011e5:	e8 68 fe ff ff       	call   801052 <syscall>
  8011ea:	83 c4 18             	add    $0x18,%esp
}
  8011ed:	90                   	nop
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 12                	push   $0x12
  8011ff:	e8 4e fe ff ff       	call   801052 <syscall>
  801204:	83 c4 18             	add    $0x18,%esp
}
  801207:	90                   	nop
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_cputc>:


void
sys_cputc(const char c)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801216:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	50                   	push   %eax
  801223:	6a 13                	push   $0x13
  801225:	e8 28 fe ff ff       	call   801052 <syscall>
  80122a:	83 c4 18             	add    $0x18,%esp
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 14                	push   $0x14
  80123f:	e8 0e fe ff ff       	call   801052 <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	90                   	nop
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	50                   	push   %eax
  80125a:	6a 15                	push   $0x15
  80125c:	e8 f1 fd ff ff       	call   801052 <syscall>
  801261:	83 c4 18             	add    $0x18,%esp
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	52                   	push   %edx
  801276:	50                   	push   %eax
  801277:	6a 18                	push   $0x18
  801279:	e8 d4 fd ff ff       	call   801052 <syscall>
  80127e:	83 c4 18             	add    $0x18,%esp
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	52                   	push   %edx
  801293:	50                   	push   %eax
  801294:	6a 16                	push   $0x16
  801296:	e8 b7 fd ff ff       	call   801052 <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	90                   	nop
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	52                   	push   %edx
  8012b1:	50                   	push   %eax
  8012b2:	6a 17                	push   $0x17
  8012b4:	e8 99 fd ff ff       	call   801052 <syscall>
  8012b9:	83 c4 18             	add    $0x18,%esp
}
  8012bc:	90                   	nop
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012ce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	51                   	push   %ecx
  8012d8:	52                   	push   %edx
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	50                   	push   %eax
  8012dd:	6a 19                	push   $0x19
  8012df:	e8 6e fd ff ff       	call   801052 <syscall>
  8012e4:	83 c4 18             	add    $0x18,%esp
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	52                   	push   %edx
  8012f9:	50                   	push   %eax
  8012fa:	6a 1a                	push   $0x1a
  8012fc:	e8 51 fd ff ff       	call   801052 <syscall>
  801301:	83 c4 18             	add    $0x18,%esp
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801309:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	51                   	push   %ecx
  801317:	52                   	push   %edx
  801318:	50                   	push   %eax
  801319:	6a 1b                	push   $0x1b
  80131b:	e8 32 fd ff ff       	call   801052 <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	52                   	push   %edx
  801335:	50                   	push   %eax
  801336:	6a 1c                	push   $0x1c
  801338:	e8 15 fd ff ff       	call   801052 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 1d                	push   $0x1d
  801351:	e8 fc fc ff ff       	call   801052 <syscall>
  801356:	83 c4 18             	add    $0x18,%esp
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	6a 00                	push   $0x0
  801363:	ff 75 14             	pushl  0x14(%ebp)
  801366:	ff 75 10             	pushl  0x10(%ebp)
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	50                   	push   %eax
  80136d:	6a 1e                	push   $0x1e
  80136f:	e8 de fc ff ff       	call   801052 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	50                   	push   %eax
  801388:	6a 1f                	push   $0x1f
  80138a:	e8 c3 fc ff ff       	call   801052 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	50                   	push   %eax
  8013a4:	6a 20                	push   $0x20
  8013a6:	e8 a7 fc ff ff       	call   801052 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 02                	push   $0x2
  8013bf:	e8 8e fc ff ff       	call   801052 <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 03                	push   $0x3
  8013d8:	e8 75 fc ff ff       	call   801052 <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 04                	push   $0x4
  8013f1:	e8 5c fc ff ff       	call   801052 <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_exit_env>:


void sys_exit_env(void)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 21                	push   $0x21
  80140a:	e8 43 fc ff ff       	call   801052 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	90                   	nop
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80141b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80141e:	8d 50 04             	lea    0x4(%eax),%edx
  801421:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	52                   	push   %edx
  80142b:	50                   	push   %eax
  80142c:	6a 22                	push   $0x22
  80142e:	e8 1f fc ff ff       	call   801052 <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
	return result;
  801436:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	89 01                	mov    %eax,(%ecx)
  801441:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	c9                   	leave  
  801448:	c2 04 00             	ret    $0x4

0080144b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	ff 75 10             	pushl  0x10(%ebp)
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	6a 10                	push   $0x10
  80145d:	e8 f0 fb ff ff       	call   801052 <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
	return ;
  801465:	90                   	nop
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_rcr2>:
uint32 sys_rcr2()
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 23                	push   $0x23
  801477:	e8 d6 fb ff ff       	call   801052 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80148d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	50                   	push   %eax
  80149a:	6a 24                	push   $0x24
  80149c:	e8 b1 fb ff ff       	call   801052 <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a4:	90                   	nop
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <rsttst>:
void rsttst()
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 26                	push   $0x26
  8014b6:	e8 97 fb ff ff       	call   801052 <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8014be:	90                   	nop
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8014d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d4:	52                   	push   %edx
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 10             	pushl  0x10(%ebp)
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	6a 25                	push   $0x25
  8014e1:	e8 6c fb ff ff       	call   801052 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e9:	90                   	nop
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <chktst>:
void chktst(uint32 n)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	6a 27                	push   $0x27
  8014fc:	e8 51 fb ff ff       	call   801052 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
	return ;
  801504:	90                   	nop
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <inctst>:

void inctst()
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 28                	push   $0x28
  801516:	e8 37 fb ff ff       	call   801052 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
	return ;
  80151e:	90                   	nop
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <gettst>:
uint32 gettst()
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 29                	push   $0x29
  801530:	e8 1d fb ff ff       	call   801052 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 2a                	push   $0x2a
  80154c:	e8 01 fb ff ff       	call   801052 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801557:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80155b:	75 07                	jne    801564 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80155d:	b8 01 00 00 00       	mov    $0x1,%eax
  801562:	eb 05                	jmp    801569 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 2a                	push   $0x2a
  80157d:	e8 d0 fa ff ff       	call   801052 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
  801585:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801588:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80158c:	75 07                	jne    801595 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80158e:	b8 01 00 00 00       	mov    $0x1,%eax
  801593:	eb 05                	jmp    80159a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 2a                	push   $0x2a
  8015ae:	e8 9f fa ff ff       	call   801052 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
  8015b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015bd:	75 07                	jne    8015c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c4:	eb 05                	jmp    8015cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 2a                	push   $0x2a
  8015df:	e8 6e fa ff ff       	call   801052 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015ee:	75 07                	jne    8015f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f5:	eb 05                	jmp    8015fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	ff 75 08             	pushl  0x8(%ebp)
  80160c:	6a 2b                	push   $0x2b
  80160e:	e8 3f fa ff ff       	call   801052 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
	return ;
  801616:	90                   	nop
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80161d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	53                   	push   %ebx
  80162c:	51                   	push   %ecx
  80162d:	52                   	push   %edx
  80162e:	50                   	push   %eax
  80162f:	6a 2c                	push   $0x2c
  801631:	e8 1c fa ff ff       	call   801052 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801641:	8b 55 0c             	mov    0xc(%ebp),%edx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	52                   	push   %edx
  80164e:	50                   	push   %eax
  80164f:	6a 2d                	push   $0x2d
  801651:	e8 fc f9 ff ff       	call   801052 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80165e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	6a 00                	push   $0x0
  801669:	51                   	push   %ecx
  80166a:	ff 75 10             	pushl  0x10(%ebp)
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	6a 2e                	push   $0x2e
  801671:	e8 dc f9 ff ff       	call   801052 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	ff 75 10             	pushl  0x10(%ebp)
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	6a 0f                	push   $0xf
  80168d:	e8 c0 f9 ff ff       	call   801052 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
	return ;
  801695:	90                   	nop
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	50                   	push   %eax
  8016a7:	6a 2f                	push   $0x2f
  8016a9:	e8 a4 f9 ff ff       	call   801052 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp

}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	6a 30                	push   $0x30
  8016c4:	e8 89 f9 ff ff       	call   801052 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
	return;
  8016cc:	90                   	nop
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	6a 31                	push   $0x31
  8016e0:	e8 6d f9 ff ff       	call   801052 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
	return;
  8016e8:	90                   	nop
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 32                	push   $0x32
  8016fa:	e8 53 f9 ff ff       	call   801052 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	50                   	push   %eax
  801713:	6a 33                	push   $0x33
  801715:	e8 38 f9 ff ff       	call   801052 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <__udivdi3>:
  801720:	55                   	push   %ebp
  801721:	57                   	push   %edi
  801722:	56                   	push   %esi
  801723:	53                   	push   %ebx
  801724:	83 ec 1c             	sub    $0x1c,%esp
  801727:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80172b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80172f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801733:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801737:	89 ca                	mov    %ecx,%edx
  801739:	89 f8                	mov    %edi,%eax
  80173b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80173f:	85 f6                	test   %esi,%esi
  801741:	75 2d                	jne    801770 <__udivdi3+0x50>
  801743:	39 cf                	cmp    %ecx,%edi
  801745:	77 65                	ja     8017ac <__udivdi3+0x8c>
  801747:	89 fd                	mov    %edi,%ebp
  801749:	85 ff                	test   %edi,%edi
  80174b:	75 0b                	jne    801758 <__udivdi3+0x38>
  80174d:	b8 01 00 00 00       	mov    $0x1,%eax
  801752:	31 d2                	xor    %edx,%edx
  801754:	f7 f7                	div    %edi
  801756:	89 c5                	mov    %eax,%ebp
  801758:	31 d2                	xor    %edx,%edx
  80175a:	89 c8                	mov    %ecx,%eax
  80175c:	f7 f5                	div    %ebp
  80175e:	89 c1                	mov    %eax,%ecx
  801760:	89 d8                	mov    %ebx,%eax
  801762:	f7 f5                	div    %ebp
  801764:	89 cf                	mov    %ecx,%edi
  801766:	89 fa                	mov    %edi,%edx
  801768:	83 c4 1c             	add    $0x1c,%esp
  80176b:	5b                   	pop    %ebx
  80176c:	5e                   	pop    %esi
  80176d:	5f                   	pop    %edi
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    
  801770:	39 ce                	cmp    %ecx,%esi
  801772:	77 28                	ja     80179c <__udivdi3+0x7c>
  801774:	0f bd fe             	bsr    %esi,%edi
  801777:	83 f7 1f             	xor    $0x1f,%edi
  80177a:	75 40                	jne    8017bc <__udivdi3+0x9c>
  80177c:	39 ce                	cmp    %ecx,%esi
  80177e:	72 0a                	jb     80178a <__udivdi3+0x6a>
  801780:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801784:	0f 87 9e 00 00 00    	ja     801828 <__udivdi3+0x108>
  80178a:	b8 01 00 00 00       	mov    $0x1,%eax
  80178f:	89 fa                	mov    %edi,%edx
  801791:	83 c4 1c             	add    $0x1c,%esp
  801794:	5b                   	pop    %ebx
  801795:	5e                   	pop    %esi
  801796:	5f                   	pop    %edi
  801797:	5d                   	pop    %ebp
  801798:	c3                   	ret    
  801799:	8d 76 00             	lea    0x0(%esi),%esi
  80179c:	31 ff                	xor    %edi,%edi
  80179e:	31 c0                	xor    %eax,%eax
  8017a0:	89 fa                	mov    %edi,%edx
  8017a2:	83 c4 1c             	add    $0x1c,%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5f                   	pop    %edi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    
  8017aa:	66 90                	xchg   %ax,%ax
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	f7 f7                	div    %edi
  8017b0:	31 ff                	xor    %edi,%edi
  8017b2:	89 fa                	mov    %edi,%edx
  8017b4:	83 c4 1c             	add    $0x1c,%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5f                   	pop    %edi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    
  8017bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017c1:	89 eb                	mov    %ebp,%ebx
  8017c3:	29 fb                	sub    %edi,%ebx
  8017c5:	89 f9                	mov    %edi,%ecx
  8017c7:	d3 e6                	shl    %cl,%esi
  8017c9:	89 c5                	mov    %eax,%ebp
  8017cb:	88 d9                	mov    %bl,%cl
  8017cd:	d3 ed                	shr    %cl,%ebp
  8017cf:	89 e9                	mov    %ebp,%ecx
  8017d1:	09 f1                	or     %esi,%ecx
  8017d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017d7:	89 f9                	mov    %edi,%ecx
  8017d9:	d3 e0                	shl    %cl,%eax
  8017db:	89 c5                	mov    %eax,%ebp
  8017dd:	89 d6                	mov    %edx,%esi
  8017df:	88 d9                	mov    %bl,%cl
  8017e1:	d3 ee                	shr    %cl,%esi
  8017e3:	89 f9                	mov    %edi,%ecx
  8017e5:	d3 e2                	shl    %cl,%edx
  8017e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017eb:	88 d9                	mov    %bl,%cl
  8017ed:	d3 e8                	shr    %cl,%eax
  8017ef:	09 c2                	or     %eax,%edx
  8017f1:	89 d0                	mov    %edx,%eax
  8017f3:	89 f2                	mov    %esi,%edx
  8017f5:	f7 74 24 0c          	divl   0xc(%esp)
  8017f9:	89 d6                	mov    %edx,%esi
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	f7 e5                	mul    %ebp
  8017ff:	39 d6                	cmp    %edx,%esi
  801801:	72 19                	jb     80181c <__udivdi3+0xfc>
  801803:	74 0b                	je     801810 <__udivdi3+0xf0>
  801805:	89 d8                	mov    %ebx,%eax
  801807:	31 ff                	xor    %edi,%edi
  801809:	e9 58 ff ff ff       	jmp    801766 <__udivdi3+0x46>
  80180e:	66 90                	xchg   %ax,%ax
  801810:	8b 54 24 08          	mov    0x8(%esp),%edx
  801814:	89 f9                	mov    %edi,%ecx
  801816:	d3 e2                	shl    %cl,%edx
  801818:	39 c2                	cmp    %eax,%edx
  80181a:	73 e9                	jae    801805 <__udivdi3+0xe5>
  80181c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80181f:	31 ff                	xor    %edi,%edi
  801821:	e9 40 ff ff ff       	jmp    801766 <__udivdi3+0x46>
  801826:	66 90                	xchg   %ax,%ax
  801828:	31 c0                	xor    %eax,%eax
  80182a:	e9 37 ff ff ff       	jmp    801766 <__udivdi3+0x46>
  80182f:	90                   	nop

00801830 <__umoddi3>:
  801830:	55                   	push   %ebp
  801831:	57                   	push   %edi
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 1c             	sub    $0x1c,%esp
  801837:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80183b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80183f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801843:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801847:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80184b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80184f:	89 f3                	mov    %esi,%ebx
  801851:	89 fa                	mov    %edi,%edx
  801853:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801857:	89 34 24             	mov    %esi,(%esp)
  80185a:	85 c0                	test   %eax,%eax
  80185c:	75 1a                	jne    801878 <__umoddi3+0x48>
  80185e:	39 f7                	cmp    %esi,%edi
  801860:	0f 86 a2 00 00 00    	jbe    801908 <__umoddi3+0xd8>
  801866:	89 c8                	mov    %ecx,%eax
  801868:	89 f2                	mov    %esi,%edx
  80186a:	f7 f7                	div    %edi
  80186c:	89 d0                	mov    %edx,%eax
  80186e:	31 d2                	xor    %edx,%edx
  801870:	83 c4 1c             	add    $0x1c,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
  801878:	39 f0                	cmp    %esi,%eax
  80187a:	0f 87 ac 00 00 00    	ja     80192c <__umoddi3+0xfc>
  801880:	0f bd e8             	bsr    %eax,%ebp
  801883:	83 f5 1f             	xor    $0x1f,%ebp
  801886:	0f 84 ac 00 00 00    	je     801938 <__umoddi3+0x108>
  80188c:	bf 20 00 00 00       	mov    $0x20,%edi
  801891:	29 ef                	sub    %ebp,%edi
  801893:	89 fe                	mov    %edi,%esi
  801895:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801899:	89 e9                	mov    %ebp,%ecx
  80189b:	d3 e0                	shl    %cl,%eax
  80189d:	89 d7                	mov    %edx,%edi
  80189f:	89 f1                	mov    %esi,%ecx
  8018a1:	d3 ef                	shr    %cl,%edi
  8018a3:	09 c7                	or     %eax,%edi
  8018a5:	89 e9                	mov    %ebp,%ecx
  8018a7:	d3 e2                	shl    %cl,%edx
  8018a9:	89 14 24             	mov    %edx,(%esp)
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	d3 e0                	shl    %cl,%eax
  8018b0:	89 c2                	mov    %eax,%edx
  8018b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b6:	d3 e0                	shl    %cl,%eax
  8018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018c0:	89 f1                	mov    %esi,%ecx
  8018c2:	d3 e8                	shr    %cl,%eax
  8018c4:	09 d0                	or     %edx,%eax
  8018c6:	d3 eb                	shr    %cl,%ebx
  8018c8:	89 da                	mov    %ebx,%edx
  8018ca:	f7 f7                	div    %edi
  8018cc:	89 d3                	mov    %edx,%ebx
  8018ce:	f7 24 24             	mull   (%esp)
  8018d1:	89 c6                	mov    %eax,%esi
  8018d3:	89 d1                	mov    %edx,%ecx
  8018d5:	39 d3                	cmp    %edx,%ebx
  8018d7:	0f 82 87 00 00 00    	jb     801964 <__umoddi3+0x134>
  8018dd:	0f 84 91 00 00 00    	je     801974 <__umoddi3+0x144>
  8018e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018e7:	29 f2                	sub    %esi,%edx
  8018e9:	19 cb                	sbb    %ecx,%ebx
  8018eb:	89 d8                	mov    %ebx,%eax
  8018ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018f1:	d3 e0                	shl    %cl,%eax
  8018f3:	89 e9                	mov    %ebp,%ecx
  8018f5:	d3 ea                	shr    %cl,%edx
  8018f7:	09 d0                	or     %edx,%eax
  8018f9:	89 e9                	mov    %ebp,%ecx
  8018fb:	d3 eb                	shr    %cl,%ebx
  8018fd:	89 da                	mov    %ebx,%edx
  8018ff:	83 c4 1c             	add    $0x1c,%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5f                   	pop    %edi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    
  801907:	90                   	nop
  801908:	89 fd                	mov    %edi,%ebp
  80190a:	85 ff                	test   %edi,%edi
  80190c:	75 0b                	jne    801919 <__umoddi3+0xe9>
  80190e:	b8 01 00 00 00       	mov    $0x1,%eax
  801913:	31 d2                	xor    %edx,%edx
  801915:	f7 f7                	div    %edi
  801917:	89 c5                	mov    %eax,%ebp
  801919:	89 f0                	mov    %esi,%eax
  80191b:	31 d2                	xor    %edx,%edx
  80191d:	f7 f5                	div    %ebp
  80191f:	89 c8                	mov    %ecx,%eax
  801921:	f7 f5                	div    %ebp
  801923:	89 d0                	mov    %edx,%eax
  801925:	e9 44 ff ff ff       	jmp    80186e <__umoddi3+0x3e>
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	89 c8                	mov    %ecx,%eax
  80192e:	89 f2                	mov    %esi,%edx
  801930:	83 c4 1c             	add    $0x1c,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5f                   	pop    %edi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    
  801938:	3b 04 24             	cmp    (%esp),%eax
  80193b:	72 06                	jb     801943 <__umoddi3+0x113>
  80193d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801941:	77 0f                	ja     801952 <__umoddi3+0x122>
  801943:	89 f2                	mov    %esi,%edx
  801945:	29 f9                	sub    %edi,%ecx
  801947:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80194b:	89 14 24             	mov    %edx,(%esp)
  80194e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801952:	8b 44 24 04          	mov    0x4(%esp),%eax
  801956:	8b 14 24             	mov    (%esp),%edx
  801959:	83 c4 1c             	add    $0x1c,%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5f                   	pop    %edi
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    
  801961:	8d 76 00             	lea    0x0(%esi),%esi
  801964:	2b 04 24             	sub    (%esp),%eax
  801967:	19 fa                	sbb    %edi,%edx
  801969:	89 d1                	mov    %edx,%ecx
  80196b:	89 c6                	mov    %eax,%esi
  80196d:	e9 71 ff ff ff       	jmp    8018e3 <__umoddi3+0xb3>
  801972:	66 90                	xchg   %ax,%ax
  801974:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801978:	72 ea                	jb     801964 <__umoddi3+0x134>
  80197a:	89 d9                	mov    %ebx,%ecx
  80197c:	e9 62 ff ff ff       	jmp    8018e3 <__umoddi3+0xb3>
