
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 60 00 00 00       	call   800096 <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp

	int i1=0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 e0 19 80 00       	push   $0x8019e0
  800058:	e8 1d 0c 00 00       	call   800c7a <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 e2 19 80 00       	push   $0x8019e2
  80006f:	e8 06 0c 00 00       	call   800c7a <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 e4 19 80 00       	push   $0x8019e4
  80008b:	e8 35 02 00 00       	call   8002c5 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");
	return;
  800093:	90                   	nop
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80009c:	e8 6a 13 00 00       	call   80140b <sys_getenvindex>
  8000a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a7:	89 d0                	mov    %edx,%eax
  8000a9:	01 c0                	add    %eax,%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	c1 e0 06             	shl    $0x6,%eax
  8000b0:	29 d0                	sub    %edx,%eax
  8000b2:	c1 e0 03             	shl    $0x3,%eax
  8000b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ba:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000bf:	a1 20 20 80 00       	mov    0x802020,%eax
  8000c4:	8a 40 68             	mov    0x68(%eax),%al
  8000c7:	84 c0                	test   %al,%al
  8000c9:	74 0d                	je     8000d8 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8000cb:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d0:	83 c0 68             	add    $0x68,%eax
  8000d3:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000dc:	7e 0a                	jle    8000e8 <libmain+0x52>
		binaryname = argv[0];
  8000de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e1:	8b 00                	mov    (%eax),%eax
  8000e3:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	ff 75 0c             	pushl  0xc(%ebp)
  8000ee:	ff 75 08             	pushl  0x8(%ebp)
  8000f1:	e8 42 ff ff ff       	call   800038 <_main>
  8000f6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000f9:	e8 1a 11 00 00       	call   801218 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	68 18 1a 80 00       	push   $0x801a18
  800106:	e8 8d 01 00 00       	call   800298 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80010e:	a1 20 20 80 00       	mov    0x802020,%eax
  800113:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800119:	a1 20 20 80 00       	mov    0x802020,%eax
  80011e:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	52                   	push   %edx
  800128:	50                   	push   %eax
  800129:	68 40 1a 80 00       	push   $0x801a40
  80012e:	e8 65 01 00 00       	call   800298 <cprintf>
  800133:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800136:	a1 20 20 80 00       	mov    0x802020,%eax
  80013b:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800141:	a1 20 20 80 00       	mov    0x802020,%eax
  800146:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80014c:	a1 20 20 80 00       	mov    0x802020,%eax
  800151:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800157:	51                   	push   %ecx
  800158:	52                   	push   %edx
  800159:	50                   	push   %eax
  80015a:	68 68 1a 80 00       	push   $0x801a68
  80015f:	e8 34 01 00 00       	call   800298 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800167:	a1 20 20 80 00       	mov    0x802020,%eax
  80016c:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	68 c0 1a 80 00       	push   $0x801ac0
  80017b:	e8 18 01 00 00       	call   800298 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	68 18 1a 80 00       	push   $0x801a18
  80018b:	e8 08 01 00 00       	call   800298 <cprintf>
  800190:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800193:	e8 9a 10 00 00       	call   801232 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800198:	e8 19 00 00 00       	call   8001b6 <exit>
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	6a 00                	push   $0x0
  8001ab:	e8 27 12 00 00       	call   8013d7 <sys_destroy_env>
  8001b0:	83 c4 10             	add    $0x10,%esp
}
  8001b3:	90                   	nop
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <exit>:

void
exit(void)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001bc:	e8 7c 12 00 00       	call   80143d <sys_exit_env>
}
  8001c1:	90                   	nop
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cd:	8b 00                	mov    (%eax),%eax
  8001cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 0a                	mov    %ecx,(%edx)
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	88 d1                	mov    %dl,%cl
  8001dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001df:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	8b 00                	mov    (%eax),%eax
  8001e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ed:	75 2c                	jne    80021b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001ef:	a0 24 20 80 00       	mov    0x802024,%al
  8001f4:	0f b6 c0             	movzbl %al,%eax
  8001f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fa:	8b 12                	mov    (%edx),%edx
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800201:	83 c2 08             	add    $0x8,%edx
  800204:	83 ec 04             	sub    $0x4,%esp
  800207:	50                   	push   %eax
  800208:	51                   	push   %ecx
  800209:	52                   	push   %edx
  80020a:	e8 b0 0e 00 00       	call   8010bf <sys_cputs>
  80020f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800212:	8b 45 0c             	mov    0xc(%ebp),%eax
  800215:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021e:	8b 40 04             	mov    0x4(%eax),%eax
  800221:	8d 50 01             	lea    0x1(%eax),%edx
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	89 50 04             	mov    %edx,0x4(%eax)
}
  80022a:	90                   	nop
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800236:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023d:	00 00 00 
	b.cnt = 0;
  800240:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800247:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800256:	50                   	push   %eax
  800257:	68 c4 01 80 00       	push   $0x8001c4
  80025c:	e8 11 02 00 00       	call   800472 <vprintfmt>
  800261:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800264:	a0 24 20 80 00       	mov    0x802024,%al
  800269:	0f b6 c0             	movzbl %al,%eax
  80026c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	50                   	push   %eax
  800276:	52                   	push   %edx
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	83 c0 08             	add    $0x8,%eax
  800280:	50                   	push   %eax
  800281:	e8 39 0e 00 00       	call   8010bf <sys_cputs>
  800286:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800289:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800290:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <cprintf>:

int cprintf(const char *fmt, ...) {
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80029e:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b4:	50                   	push   %eax
  8002b5:	e8 73 ff ff ff       	call   80022d <vcprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002cb:	e8 48 0f 00 00       	call   801218 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002df:	50                   	push   %eax
  8002e0:	e8 48 ff ff ff       	call   80022d <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002eb:	e8 42 0f 00 00       	call   801232 <sys_enable_interrupt>
	return cnt;
  8002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 14             	sub    $0x14,%esp
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800302:	8b 45 14             	mov    0x14(%ebp),%eax
  800305:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800308:	8b 45 18             	mov    0x18(%ebp),%eax
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800313:	77 55                	ja     80036a <printnum+0x75>
  800315:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800318:	72 05                	jb     80031f <printnum+0x2a>
  80031a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031d:	77 4b                	ja     80036a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800322:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	52                   	push   %edx
  80032e:	50                   	push   %eax
  80032f:	ff 75 f4             	pushl  -0xc(%ebp)
  800332:	ff 75 f0             	pushl  -0x10(%ebp)
  800335:	e8 2a 14 00 00       	call   801764 <__udivdi3>
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	ff 75 20             	pushl  0x20(%ebp)
  800343:	53                   	push   %ebx
  800344:	ff 75 18             	pushl  0x18(%ebp)
  800347:	52                   	push   %edx
  800348:	50                   	push   %eax
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 a1 ff ff ff       	call   8002f5 <printnum>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800359:	83 ec 08             	sub    $0x8,%esp
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 20             	pushl  0x20(%ebp)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	ff d0                	call   *%eax
  800367:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80036a:	ff 4d 1c             	decl   0x1c(%ebp)
  80036d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800371:	7f e6                	jg     800359 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800373:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800376:	bb 00 00 00 00       	mov    $0x0,%ebx
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800381:	53                   	push   %ebx
  800382:	51                   	push   %ecx
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	e8 ea 14 00 00       	call   801874 <__umoddi3>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	05 f4 1c 80 00       	add    $0x801cf4,%eax
  800392:	8a 00                	mov    (%eax),%al
  800394:	0f be c0             	movsbl %al,%eax
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	ff 75 0c             	pushl  0xc(%ebp)
  80039d:	50                   	push   %eax
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	ff d0                	call   *%eax
  8003a3:	83 c4 10             	add    $0x10,%esp
}
  8003a6:	90                   	nop
  8003a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003b3:	7e 1c                	jle    8003d1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	8d 50 08             	lea    0x8(%eax),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	89 10                	mov    %edx,(%eax)
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	83 e8 08             	sub    $0x8,%eax
  8003ca:	8b 50 04             	mov    0x4(%eax),%edx
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	eb 40                	jmp    800411 <getuint+0x65>
	else if (lflag)
  8003d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003d5:	74 1e                	je     8003f5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 04             	lea    0x4(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 04             	sub    $0x4,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	eb 1c                	jmp    800411 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	8d 50 04             	lea    0x4(%eax),%edx
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	89 10                	mov    %edx,(%eax)
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	83 e8 04             	sub    $0x4,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800411:	5d                   	pop    %ebp
  800412:	c3                   	ret    

00800413 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800416:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041a:	7e 1c                	jle    800438 <getint+0x25>
		return va_arg(*ap, long long);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 08             	lea    0x8(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 08             	sub    $0x8,%eax
  800431:	8b 50 04             	mov    0x4(%eax),%edx
  800434:	8b 00                	mov    (%eax),%eax
  800436:	eb 38                	jmp    800470 <getint+0x5d>
	else if (lflag)
  800438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043c:	74 1a                	je     800458 <getint+0x45>
		return va_arg(*ap, long);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	8d 50 04             	lea    0x4(%eax),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	89 10                	mov    %edx,(%eax)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	83 e8 04             	sub    $0x4,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	99                   	cltd   
  800456:	eb 18                	jmp    800470 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	8d 50 04             	lea    0x4(%eax),%edx
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	89 10                	mov    %edx,(%eax)
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	83 e8 04             	sub    $0x4,%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	99                   	cltd   
}
  800470:	5d                   	pop    %ebp
  800471:	c3                   	ret    

00800472 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	56                   	push   %esi
  800476:	53                   	push   %ebx
  800477:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047a:	eb 17                	jmp    800493 <vprintfmt+0x21>
			if (ch == '\0')
  80047c:	85 db                	test   %ebx,%ebx
  80047e:	0f 84 af 03 00 00    	je     800833 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 0c             	pushl  0xc(%ebp)
  80048a:	53                   	push   %ebx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	ff d0                	call   *%eax
  800490:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800493:	8b 45 10             	mov    0x10(%ebp),%eax
  800496:	8d 50 01             	lea    0x1(%eax),%edx
  800499:	89 55 10             	mov    %edx,0x10(%ebp)
  80049c:	8a 00                	mov    (%eax),%al
  80049e:	0f b6 d8             	movzbl %al,%ebx
  8004a1:	83 fb 25             	cmp    $0x25,%ebx
  8004a4:	75 d6                	jne    80047c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004a6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c9:	8d 50 01             	lea    0x1(%eax),%edx
  8004cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004cf:	8a 00                	mov    (%eax),%al
  8004d1:	0f b6 d8             	movzbl %al,%ebx
  8004d4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004d7:	83 f8 55             	cmp    $0x55,%eax
  8004da:	0f 87 2b 03 00 00    	ja     80080b <vprintfmt+0x399>
  8004e0:	8b 04 85 18 1d 80 00 	mov    0x801d18(,%eax,4),%eax
  8004e7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004e9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004ed:	eb d7                	jmp    8004c6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004ef:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004f3:	eb d1                	jmp    8004c6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ff:	89 d0                	mov    %edx,%eax
  800501:	c1 e0 02             	shl    $0x2,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d8                	add    %ebx,%eax
  80050a:	83 e8 30             	sub    $0x30,%eax
  80050d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800510:	8b 45 10             	mov    0x10(%ebp),%eax
  800513:	8a 00                	mov    (%eax),%al
  800515:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800518:	83 fb 2f             	cmp    $0x2f,%ebx
  80051b:	7e 3e                	jle    80055b <vprintfmt+0xe9>
  80051d:	83 fb 39             	cmp    $0x39,%ebx
  800520:	7f 39                	jg     80055b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800522:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800525:	eb d5                	jmp    8004fc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	83 c0 04             	add    $0x4,%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80053b:	eb 1f                	jmp    80055c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80053d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800541:	79 83                	jns    8004c6 <vprintfmt+0x54>
				width = 0;
  800543:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80054a:	e9 77 ff ff ff       	jmp    8004c6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80054f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800556:	e9 6b ff ff ff       	jmp    8004c6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80055b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80055c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800560:	0f 89 60 ff ff ff    	jns    8004c6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800573:	e9 4e ff ff ff       	jmp    8004c6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800578:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80057b:	e9 46 ff ff ff       	jmp    8004c6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	83 c0 04             	add    $0x4,%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	83 e8 04             	sub    $0x4,%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	ff 75 0c             	pushl  0xc(%ebp)
  800597:	50                   	push   %eax
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	ff d0                	call   *%eax
  80059d:	83 c4 10             	add    $0x10,%esp
			break;
  8005a0:	e9 89 02 00 00       	jmp    80082e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	83 c0 04             	add    $0x4,%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	83 e8 04             	sub    $0x4,%eax
  8005b4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	79 02                	jns    8005bc <vprintfmt+0x14a>
				err = -err;
  8005ba:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005bc:	83 fb 64             	cmp    $0x64,%ebx
  8005bf:	7f 0b                	jg     8005cc <vprintfmt+0x15a>
  8005c1:	8b 34 9d 60 1b 80 00 	mov    0x801b60(,%ebx,4),%esi
  8005c8:	85 f6                	test   %esi,%esi
  8005ca:	75 19                	jne    8005e5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005cc:	53                   	push   %ebx
  8005cd:	68 05 1d 80 00       	push   $0x801d05
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 5e 02 00 00       	call   80083b <printfmt>
  8005dd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005e0:	e9 49 02 00 00       	jmp    80082e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005e5:	56                   	push   %esi
  8005e6:	68 0e 1d 80 00       	push   $0x801d0e
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 45 02 00 00       	call   80083b <printfmt>
  8005f6:	83 c4 10             	add    $0x10,%esp
			break;
  8005f9:	e9 30 02 00 00       	jmp    80082e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	83 c0 04             	add    $0x4,%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	83 e8 04             	sub    $0x4,%eax
  80060d:	8b 30                	mov    (%eax),%esi
  80060f:	85 f6                	test   %esi,%esi
  800611:	75 05                	jne    800618 <vprintfmt+0x1a6>
				p = "(null)";
  800613:	be 11 1d 80 00       	mov    $0x801d11,%esi
			if (width > 0 && padc != '-')
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	7e 6d                	jle    80068b <vprintfmt+0x219>
  80061e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800622:	74 67                	je     80068b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	50                   	push   %eax
  80062b:	56                   	push   %esi
  80062c:	e8 0c 03 00 00       	call   80093d <strnlen>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800637:	eb 16                	jmp    80064f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800639:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80064c:	ff 4d e4             	decl   -0x1c(%ebp)
  80064f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800653:	7f e4                	jg     800639 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800655:	eb 34                	jmp    80068b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800657:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80065b:	74 1c                	je     800679 <vprintfmt+0x207>
  80065d:	83 fb 1f             	cmp    $0x1f,%ebx
  800660:	7e 05                	jle    800667 <vprintfmt+0x1f5>
  800662:	83 fb 7e             	cmp    $0x7e,%ebx
  800665:	7e 12                	jle    800679 <vprintfmt+0x207>
					putch('?', putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	6a 3f                	push   $0x3f
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	eb 0f                	jmp    800688 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	53                   	push   %ebx
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	ff d0                	call   *%eax
  800685:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800688:	ff 4d e4             	decl   -0x1c(%ebp)
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	8d 70 01             	lea    0x1(%eax),%esi
  800690:	8a 00                	mov    (%eax),%al
  800692:	0f be d8             	movsbl %al,%ebx
  800695:	85 db                	test   %ebx,%ebx
  800697:	74 24                	je     8006bd <vprintfmt+0x24b>
  800699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069d:	78 b8                	js     800657 <vprintfmt+0x1e5>
  80069f:	ff 4d e0             	decl   -0x20(%ebp)
  8006a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a6:	79 af                	jns    800657 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a8:	eb 13                	jmp    8006bd <vprintfmt+0x24b>
				putch(' ', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	6a 20                	push   $0x20
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	ff d0                	call   *%eax
  8006b7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c1:	7f e7                	jg     8006aa <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006c3:	e9 66 01 00 00       	jmp    80082e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d1:	50                   	push   %eax
  8006d2:	e8 3c fd ff ff       	call   800413 <getint>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e6:	85 d2                	test   %edx,%edx
  8006e8:	79 23                	jns    80070d <vprintfmt+0x29b>
				putch('-', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	6a 2d                	push   $0x2d
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	ff d0                	call   *%eax
  8006f7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800700:	f7 d8                	neg    %eax
  800702:	83 d2 00             	adc    $0x0,%edx
  800705:	f7 da                	neg    %edx
  800707:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80070d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800714:	e9 bc 00 00 00       	jmp    8007d5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 e8             	pushl  -0x18(%ebp)
  80071f:	8d 45 14             	lea    0x14(%ebp),%eax
  800722:	50                   	push   %eax
  800723:	e8 84 fc ff ff       	call   8003ac <getuint>
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800731:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800738:	e9 98 00 00 00       	jmp    8007d5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 58                	push   $0x58
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	6a 58                	push   $0x58
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	ff d0                	call   *%eax
  80075a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	6a 58                	push   $0x58
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
			break;
  80076d:	e9 bc 00 00 00       	jmp    80082e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 30                	push   $0x30
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	6a 78                	push   $0x78
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	83 c0 04             	add    $0x4,%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	83 e8 04             	sub    $0x4,%eax
  8007a1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007b4:	eb 1f                	jmp    8007d5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	e8 e7 fb ff ff       	call   8003ac <getuint>
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007dc:	83 ec 04             	sub    $0x4,%esp
  8007df:	52                   	push   %edx
  8007e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	ff 75 08             	pushl  0x8(%ebp)
  8007f0:	e8 00 fb ff ff       	call   8002f5 <printnum>
  8007f5:	83 c4 20             	add    $0x20,%esp
			break;
  8007f8:	eb 34                	jmp    80082e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	53                   	push   %ebx
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	ff d0                	call   *%eax
  800806:	83 c4 10             	add    $0x10,%esp
			break;
  800809:	eb 23                	jmp    80082e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	6a 25                	push   $0x25
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081b:	ff 4d 10             	decl   0x10(%ebp)
  80081e:	eb 03                	jmp    800823 <vprintfmt+0x3b1>
  800820:	ff 4d 10             	decl   0x10(%ebp)
  800823:	8b 45 10             	mov    0x10(%ebp),%eax
  800826:	48                   	dec    %eax
  800827:	8a 00                	mov    (%eax),%al
  800829:	3c 25                	cmp    $0x25,%al
  80082b:	75 f3                	jne    800820 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80082d:	90                   	nop
		}
	}
  80082e:	e9 47 fc ff ff       	jmp    80047a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800833:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800834:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800837:	5b                   	pop    %ebx
  800838:	5e                   	pop    %esi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800841:	8d 45 10             	lea    0x10(%ebp),%eax
  800844:	83 c0 04             	add    $0x4,%eax
  800847:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	ff 75 f4             	pushl  -0xc(%ebp)
  800850:	50                   	push   %eax
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	ff 75 08             	pushl  0x8(%ebp)
  800857:	e8 16 fc ff ff       	call   800472 <vprintfmt>
  80085c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80085f:	90                   	nop
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800865:	8b 45 0c             	mov    0xc(%ebp),%eax
  800868:	8b 40 08             	mov    0x8(%eax),%eax
  80086b:	8d 50 01             	lea    0x1(%eax),%edx
  80086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800871:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800874:	8b 45 0c             	mov    0xc(%ebp),%eax
  800877:	8b 10                	mov    (%eax),%edx
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087c:	8b 40 04             	mov    0x4(%eax),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	73 12                	jae    800895 <sprintputch+0x33>
		*b->buf++ = ch;
  800883:	8b 45 0c             	mov    0xc(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	8d 48 01             	lea    0x1(%eax),%ecx
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088e:	89 0a                	mov    %ecx,(%edx)
  800890:	8b 55 08             	mov    0x8(%ebp),%edx
  800893:	88 10                	mov    %dl,(%eax)
}
  800895:	90                   	nop
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	01 d0                	add    %edx,%eax
  8008af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008bd:	74 06                	je     8008c5 <vsnprintf+0x2d>
  8008bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c3:	7f 07                	jg     8008cc <vsnprintf+0x34>
		return -E_INVAL;
  8008c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ca:	eb 20                	jmp    8008ec <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cc:	ff 75 14             	pushl  0x14(%ebp)
  8008cf:	ff 75 10             	pushl  0x10(%ebp)
  8008d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d5:	50                   	push   %eax
  8008d6:	68 62 08 80 00       	push   $0x800862
  8008db:	e8 92 fb ff ff       	call   800472 <vprintfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800900:	ff 75 f4             	pushl  -0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	ff 75 08             	pushl  0x8(%ebp)
  80090a:	e8 89 ff ff ff       	call   800898 <vsnprintf>
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800915:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800918:	c9                   	leave  
  800919:	c3                   	ret    

0080091a <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800927:	eb 06                	jmp    80092f <strlen+0x15>
		n++;
  800929:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80092c:	ff 45 08             	incl   0x8(%ebp)
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8a 00                	mov    (%eax),%al
  800934:	84 c0                	test   %al,%al
  800936:	75 f1                	jne    800929 <strlen+0xf>
		n++;
	return n;
  800938:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    

0080093d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094a:	eb 09                	jmp    800955 <strnlen+0x18>
		n++;
  80094c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094f:	ff 45 08             	incl   0x8(%ebp)
  800952:	ff 4d 0c             	decl   0xc(%ebp)
  800955:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800959:	74 09                	je     800964 <strnlen+0x27>
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8a 00                	mov    (%eax),%al
  800960:	84 c0                	test   %al,%al
  800962:	75 e8                	jne    80094c <strnlen+0xf>
		n++;
	return n;
  800964:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800975:	90                   	nop
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8d 50 01             	lea    0x1(%eax),%edx
  80097c:	89 55 08             	mov    %edx,0x8(%ebp)
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	8d 4a 01             	lea    0x1(%edx),%ecx
  800985:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800988:	8a 12                	mov    (%edx),%dl
  80098a:	88 10                	mov    %dl,(%eax)
  80098c:	8a 00                	mov    (%eax),%al
  80098e:	84 c0                	test   %al,%al
  800990:	75 e4                	jne    800976 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800992:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009aa:	eb 1f                	jmp    8009cb <strncpy+0x34>
		*dst++ = *src;
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8d 50 01             	lea    0x1(%eax),%edx
  8009b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	8a 12                	mov    (%edx),%dl
  8009ba:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8a 00                	mov    (%eax),%al
  8009c1:	84 c0                	test   %al,%al
  8009c3:	74 03                	je     8009c8 <strncpy+0x31>
			src++;
  8009c5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c8:	ff 45 fc             	incl   -0x4(%ebp)
  8009cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009d1:	72 d9                	jb     8009ac <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e8:	74 30                	je     800a1a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ea:	eb 16                	jmp    800a02 <strlcpy+0x2a>
			*dst++ = *src++;
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8d 50 01             	lea    0x1(%eax),%edx
  8009f2:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009fb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009fe:	8a 12                	mov    (%edx),%dl
  800a00:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a02:	ff 4d 10             	decl   0x10(%ebp)
  800a05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a09:	74 09                	je     800a14 <strlcpy+0x3c>
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 d8                	jne    8009ec <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a20:	29 c2                	sub    %eax,%edx
  800a22:	89 d0                	mov    %edx,%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a29:	eb 06                	jmp    800a31 <strcmp+0xb>
		p++, q++;
  800a2b:	ff 45 08             	incl   0x8(%ebp)
  800a2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	84 c0                	test   %al,%al
  800a38:	74 0e                	je     800a48 <strcmp+0x22>
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8a 10                	mov    (%eax),%dl
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	38 c2                	cmp    %al,%dl
  800a46:	74 e3                	je     800a2b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	0f b6 d0             	movzbl %al,%edx
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	8a 00                	mov    (%eax),%al
  800a55:	0f b6 c0             	movzbl %al,%eax
  800a58:	29 c2                	sub    %eax,%edx
  800a5a:	89 d0                	mov    %edx,%eax
}
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a61:	eb 09                	jmp    800a6c <strncmp+0xe>
		n--, p++, q++;
  800a63:	ff 4d 10             	decl   0x10(%ebp)
  800a66:	ff 45 08             	incl   0x8(%ebp)
  800a69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a70:	74 17                	je     800a89 <strncmp+0x2b>
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	84 c0                	test   %al,%al
  800a79:	74 0e                	je     800a89 <strncmp+0x2b>
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8a 10                	mov    (%eax),%dl
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	8a 00                	mov    (%eax),%al
  800a85:	38 c2                	cmp    %al,%dl
  800a87:	74 da                	je     800a63 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8d:	75 07                	jne    800a96 <strncmp+0x38>
		return 0;
  800a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a94:	eb 14                	jmp    800aaa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8a 00                	mov    (%eax),%al
  800a9b:	0f b6 d0             	movzbl %al,%edx
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	0f b6 c0             	movzbl %al,%eax
  800aa6:	29 c2                	sub    %eax,%edx
  800aa8:	89 d0                	mov    %edx,%eax
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ab8:	eb 12                	jmp    800acc <strchr+0x20>
		if (*s == c)
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac2:	75 05                	jne    800ac9 <strchr+0x1d>
			return (char *) s;
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	eb 11                	jmp    800ada <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ac9:	ff 45 08             	incl   0x8(%ebp)
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	84 c0                	test   %al,%al
  800ad3:	75 e5                	jne    800aba <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 04             	sub    $0x4,%esp
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae8:	eb 0d                	jmp    800af7 <strfind+0x1b>
		if (*s == c)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af2:	74 0e                	je     800b02 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800af4:	ff 45 08             	incl   0x8(%ebp)
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 ea                	jne    800aea <strfind+0xe>
  800b00:	eb 01                	jmp    800b03 <strfind+0x27>
		if (*s == c)
			break;
  800b02:	90                   	nop
	return (char *) s;
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b1a:	eb 0e                	jmp    800b2a <memset+0x22>
		*p++ = c;
  800b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b28:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b2a:	ff 4d f8             	decl   -0x8(%ebp)
  800b2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b31:	79 e9                	jns    800b1c <memset+0x14>
		*p++ = c;

	return v;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b4a:	eb 16                	jmp    800b62 <memcpy+0x2a>
		*d++ = *s++;
  800b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b5e:	8a 12                	mov    (%edx),%dl
  800b60:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	85 c0                	test   %eax,%eax
  800b6d:	75 dd                	jne    800b4c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8c:	73 50                	jae    800bde <memmove+0x6a>
  800b8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b91:	8b 45 10             	mov    0x10(%ebp),%eax
  800b94:	01 d0                	add    %edx,%eax
  800b96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b99:	76 43                	jbe    800bde <memmove+0x6a>
		s += n;
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ba7:	eb 10                	jmp    800bb9 <memmove+0x45>
			*--d = *--s;
  800ba9:	ff 4d f8             	decl   -0x8(%ebp)
  800bac:	ff 4d fc             	decl   -0x4(%ebp)
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb2:	8a 10                	mov    (%eax),%dl
  800bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	75 e3                	jne    800ba9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc6:	eb 23                	jmp    800beb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bcb:	8d 50 01             	lea    0x1(%eax),%edx
  800bce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bd1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bda:	8a 12                	mov    (%edx),%dl
  800bdc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bde:	8b 45 10             	mov    0x10(%ebp),%eax
  800be1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be4:	89 55 10             	mov    %edx,0x10(%ebp)
  800be7:	85 c0                	test   %eax,%eax
  800be9:	75 dd                	jne    800bc8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c02:	eb 2a                	jmp    800c2e <memcmp+0x3e>
		if (*s1 != *s2)
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c07:	8a 10                	mov    (%eax),%dl
  800c09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	38 c2                	cmp    %al,%dl
  800c10:	74 16                	je     800c28 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 d0             	movzbl %al,%edx
  800c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1d:	8a 00                	mov    (%eax),%al
  800c1f:	0f b6 c0             	movzbl %al,%eax
  800c22:	29 c2                	sub    %eax,%edx
  800c24:	89 d0                	mov    %edx,%eax
  800c26:	eb 18                	jmp    800c40 <memcmp+0x50>
		s1++, s2++;
  800c28:	ff 45 fc             	incl   -0x4(%ebp)
  800c2b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	89 55 10             	mov    %edx,0x10(%ebp)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	75 c9                	jne    800c04 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 d0                	add    %edx,%eax
  800c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c53:	eb 15                	jmp    800c6a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	0f b6 d0             	movzbl %al,%edx
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	0f b6 c0             	movzbl %al,%eax
  800c63:	39 c2                	cmp    %eax,%edx
  800c65:	74 0d                	je     800c74 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c67:	ff 45 08             	incl   0x8(%ebp)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c70:	72 e3                	jb     800c55 <memfind+0x13>
  800c72:	eb 01                	jmp    800c75 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c74:	90                   	nop
	return (void *) s;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8e:	eb 03                	jmp    800c93 <strtol+0x19>
		s++;
  800c90:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	3c 20                	cmp    $0x20,%al
  800c9a:	74 f4                	je     800c90 <strtol+0x16>
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	3c 09                	cmp    $0x9,%al
  800ca3:	74 eb                	je     800c90 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	3c 2b                	cmp    $0x2b,%al
  800cac:	75 05                	jne    800cb3 <strtol+0x39>
		s++;
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	eb 13                	jmp    800cc6 <strtol+0x4c>
	else if (*s == '-')
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	3c 2d                	cmp    $0x2d,%al
  800cba:	75 0a                	jne    800cc6 <strtol+0x4c>
		s++, neg = 1;
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 06                	je     800cd2 <strtol+0x58>
  800ccc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cd0:	75 20                	jne    800cf2 <strtol+0x78>
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 30                	cmp    $0x30,%al
  800cd9:	75 17                	jne    800cf2 <strtol+0x78>
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	40                   	inc    %eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	3c 78                	cmp    $0x78,%al
  800ce3:	75 0d                	jne    800cf2 <strtol+0x78>
		s += 2, base = 16;
  800ce5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ce9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cf0:	eb 28                	jmp    800d1a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	75 15                	jne    800d0d <strtol+0x93>
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	3c 30                	cmp    $0x30,%al
  800cff:	75 0c                	jne    800d0d <strtol+0x93>
		s++, base = 8;
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d0b:	eb 0d                	jmp    800d1a <strtol+0xa0>
	else if (base == 0)
  800d0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d11:	75 07                	jne    800d1a <strtol+0xa0>
		base = 10;
  800d13:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	3c 2f                	cmp    $0x2f,%al
  800d21:	7e 19                	jle    800d3c <strtol+0xc2>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	3c 39                	cmp    $0x39,%al
  800d2a:	7f 10                	jg     800d3c <strtol+0xc2>
			dig = *s - '0';
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f be c0             	movsbl %al,%eax
  800d34:	83 e8 30             	sub    $0x30,%eax
  800d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3a:	eb 42                	jmp    800d7e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 60                	cmp    $0x60,%al
  800d43:	7e 19                	jle    800d5e <strtol+0xe4>
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 7a                	cmp    $0x7a,%al
  800d4c:	7f 10                	jg     800d5e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	0f be c0             	movsbl %al,%eax
  800d56:	83 e8 57             	sub    $0x57,%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d5c:	eb 20                	jmp    800d7e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 40                	cmp    $0x40,%al
  800d65:	7e 39                	jle    800da0 <strtol+0x126>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3c 5a                	cmp    $0x5a,%al
  800d6e:	7f 30                	jg     800da0 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be c0             	movsbl %al,%eax
  800d78:	83 e8 37             	sub    $0x37,%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d84:	7d 19                	jge    800d9f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d95:	01 d0                	add    %edx,%eax
  800d97:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d9a:	e9 7b ff ff ff       	jmp    800d1a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d9f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800da0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da4:	74 08                	je     800dae <strtol+0x134>
		*endptr = (char *) s;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800db2:	74 07                	je     800dbb <strtol+0x141>
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	f7 d8                	neg    %eax
  800db9:	eb 03                	jmp    800dbe <strtol+0x144>
  800dbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <ltostr>:

void
ltostr(long value, char *str)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dcd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd8:	79 13                	jns    800ded <ltostr+0x2d>
	{
		neg = 1;
  800dda:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800de7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800df5:	99                   	cltd   
  800df6:	f7 f9                	idiv   %ecx
  800df8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfe:	8d 50 01             	lea    0x1(%eax),%edx
  800e01:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e0e:	83 c2 30             	add    $0x30,%edx
  800e11:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e16:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e1b:	f7 e9                	imul   %ecx
  800e1d:	c1 fa 02             	sar    $0x2,%edx
  800e20:	89 c8                	mov    %ecx,%eax
  800e22:	c1 f8 1f             	sar    $0x1f,%eax
  800e25:	29 c2                	sub    %eax,%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e2f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e34:	f7 e9                	imul   %ecx
  800e36:	c1 fa 02             	sar    $0x2,%edx
  800e39:	89 c8                	mov    %ecx,%eax
  800e3b:	c1 f8 1f             	sar    $0x1f,%eax
  800e3e:	29 c2                	sub    %eax,%edx
  800e40:	89 d0                	mov    %edx,%eax
  800e42:	c1 e0 02             	shl    $0x2,%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	01 c0                	add    %eax,%eax
  800e49:	29 c1                	sub    %eax,%ecx
  800e4b:	89 ca                	mov    %ecx,%edx
  800e4d:	85 d2                	test   %edx,%edx
  800e4f:	75 9c                	jne    800ded <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5b:	48                   	dec    %eax
  800e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e63:	74 3d                	je     800ea2 <ltostr+0xe2>
		start = 1 ;
  800e65:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e6c:	eb 34                	jmp    800ea2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	01 c2                	add    %eax,%edx
  800e83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	01 c8                	add    %ecx,%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	01 c2                	add    %eax,%edx
  800e97:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e9a:	88 02                	mov    %al,(%edx)
		start++ ;
  800e9c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e9f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ea8:	7c c4                	jl     800e6e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eaa:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	01 d0                	add    %edx,%eax
  800eb2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eb5:	90                   	nop
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ebe:	ff 75 08             	pushl  0x8(%ebp)
  800ec1:	e8 54 fa ff ff       	call   80091a <strlen>
  800ec6:	83 c4 04             	add    $0x4,%esp
  800ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	e8 46 fa ff ff       	call   80091a <strlen>
  800ed4:	83 c4 04             	add    $0x4,%esp
  800ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ee1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee8:	eb 17                	jmp    800f01 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 c2                	add    %eax,%edx
  800ef2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	01 c8                	add    %ecx,%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800efe:	ff 45 fc             	incl   -0x4(%ebp)
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f04:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f07:	7c e1                	jl     800eea <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f17:	eb 1f                	jmp    800f38 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f22:	89 c2                	mov    %eax,%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 c2                	add    %eax,%edx
  800f29:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f35:	ff 45 f8             	incl   -0x8(%ebp)
  800f38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f3e:	7c d9                	jl     800f19 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	01 d0                	add    %edx,%eax
  800f48:	c6 00 00             	movb   $0x0,(%eax)
}
  800f4b:	90                   	nop
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f51:	8b 45 14             	mov    0x14(%ebp),%eax
  800f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5d:	8b 00                	mov    (%eax),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 10             	mov    0x10(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f71:	eb 0c                	jmp    800f7f <strsplit+0x31>
			*string++ = 0;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8d 50 01             	lea    0x1(%eax),%edx
  800f79:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	84 c0                	test   %al,%al
  800f86:	74 18                	je     800fa0 <strsplit+0x52>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f be c0             	movsbl %al,%eax
  800f90:	50                   	push   %eax
  800f91:	ff 75 0c             	pushl  0xc(%ebp)
  800f94:	e8 13 fb ff ff       	call   800aac <strchr>
  800f99:	83 c4 08             	add    $0x8,%esp
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	75 d3                	jne    800f73 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	84 c0                	test   %al,%al
  800fa7:	74 5a                	je     801003 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fac:	8b 00                	mov    (%eax),%eax
  800fae:	83 f8 0f             	cmp    $0xf,%eax
  800fb1:	75 07                	jne    800fba <strsplit+0x6c>
		{
			return 0;
  800fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb8:	eb 66                	jmp    801020 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fba:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbd:	8b 00                	mov    (%eax),%eax
  800fbf:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc2:	8b 55 14             	mov    0x14(%ebp),%edx
  800fc5:	89 0a                	mov    %ecx,(%edx)
  800fc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	01 c2                	add    %eax,%edx
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fd8:	eb 03                	jmp    800fdd <strsplit+0x8f>
			string++;
  800fda:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	84 c0                	test   %al,%al
  800fe4:	74 8b                	je     800f71 <strsplit+0x23>
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f be c0             	movsbl %al,%eax
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	e8 b5 fa ff ff       	call   800aac <strchr>
  800ff7:	83 c4 08             	add    $0x8,%esp
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	74 dc                	je     800fda <strsplit+0x8c>
			string++;
	}
  800ffe:	e9 6e ff ff ff       	jmp    800f71 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801003:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80101b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80102f:	eb 4c                	jmp    80107d <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801031:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 40                	cmp    $0x40,%al
  80103d:	7e 27                	jle    801066 <str2lower+0x44>
  80103f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 d0                	add    %edx,%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 5a                	cmp    $0x5a,%al
  80104b:	7f 19                	jg     801066 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80104d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105b:	01 ca                	add    %ecx,%edx
  80105d:	8a 12                	mov    (%edx),%dl
  80105f:	83 c2 20             	add    $0x20,%edx
  801062:	88 10                	mov    %dl,(%eax)
  801064:	eb 14                	jmp    80107a <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801066:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	01 c2                	add    %eax,%edx
  80106e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	01 c8                	add    %ecx,%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80107a:	ff 45 fc             	incl   -0x4(%ebp)
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	e8 95 f8 ff ff       	call   80091a <strlen>
  801085:	83 c4 04             	add    $0x4,%esp
  801088:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108b:	7f a4                	jg     801031 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010a9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010ac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010af:	cd 30                	int    $0x30
  8010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 04             	sub    $0x4,%esp
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	52                   	push   %edx
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	50                   	push   %eax
  8010db:	6a 00                	push   $0x0
  8010dd:	e8 b2 ff ff ff       	call   801094 <syscall>
  8010e2:	83 c4 18             	add    $0x18,%esp
}
  8010e5:	90                   	nop
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 00                	push   $0x0
  8010f1:	6a 00                	push   $0x0
  8010f3:	6a 00                	push   $0x0
  8010f5:	6a 01                	push   $0x1
  8010f7:	e8 98 ff ff ff       	call   801094 <syscall>
  8010fc:	83 c4 18             	add    $0x18,%esp
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	52                   	push   %edx
  801111:	50                   	push   %eax
  801112:	6a 05                	push   $0x5
  801114:	e8 7b ff ff ff       	call   801094 <syscall>
  801119:	83 c4 18             	add    $0x18,%esp
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	56                   	push   %esi
  801122:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801123:	8b 75 18             	mov    0x18(%ebp),%esi
  801126:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801129:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80112c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
  801134:	51                   	push   %ecx
  801135:	52                   	push   %edx
  801136:	50                   	push   %eax
  801137:	6a 06                	push   $0x6
  801139:	e8 56 ff ff ff       	call   801094 <syscall>
  80113e:	83 c4 18             	add    $0x18,%esp
}
  801141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80114b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	52                   	push   %edx
  801158:	50                   	push   %eax
  801159:	6a 07                	push   $0x7
  80115b:	e8 34 ff ff ff       	call   801094 <syscall>
  801160:	83 c4 18             	add    $0x18,%esp
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	6a 08                	push   $0x8
  801176:	e8 19 ff ff ff       	call   801094 <syscall>
  80117b:	83 c4 18             	add    $0x18,%esp
}
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 09                	push   $0x9
  80118f:	e8 00 ff ff ff       	call   801094 <syscall>
  801194:	83 c4 18             	add    $0x18,%esp
}
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 0a                	push   $0xa
  8011a8:	e8 e7 fe ff ff       	call   801094 <syscall>
  8011ad:	83 c4 18             	add    $0x18,%esp
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 0b                	push   $0xb
  8011c1:	e8 ce fe ff ff       	call   801094 <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 0c                	push   $0xc
  8011da:	e8 b5 fe ff ff       	call   801094 <syscall>
  8011df:	83 c4 18             	add    $0x18,%esp
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	6a 0d                	push   $0xd
  8011f4:	e8 9b fe ff ff       	call   801094 <syscall>
  8011f9:	83 c4 18             	add    $0x18,%esp
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 0e                	push   $0xe
  80120d:	e8 82 fe ff ff       	call   801094 <syscall>
  801212:	83 c4 18             	add    $0x18,%esp
}
  801215:	90                   	nop
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 11                	push   $0x11
  801227:	e8 68 fe ff ff       	call   801094 <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 12                	push   $0x12
  801241:	e8 4e fe ff ff       	call   801094 <syscall>
  801246:	83 c4 18             	add    $0x18,%esp
}
  801249:	90                   	nop
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <sys_cputc>:


void
sys_cputc(const char c)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801258:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	50                   	push   %eax
  801265:	6a 13                	push   $0x13
  801267:	e8 28 fe ff ff       	call   801094 <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	90                   	nop
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 14                	push   $0x14
  801281:	e8 0e fe ff ff       	call   801094 <syscall>
  801286:	83 c4 18             	add    $0x18,%esp
}
  801289:	90                   	nop
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	6a 15                	push   $0x15
  80129e:	e8 f1 fd ff ff       	call   801094 <syscall>
  8012a3:	83 c4 18             	add    $0x18,%esp
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	52                   	push   %edx
  8012b8:	50                   	push   %eax
  8012b9:	6a 18                	push   $0x18
  8012bb:	e8 d4 fd ff ff       	call   801094 <syscall>
  8012c0:	83 c4 18             	add    $0x18,%esp
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	52                   	push   %edx
  8012d5:	50                   	push   %eax
  8012d6:	6a 16                	push   $0x16
  8012d8:	e8 b7 fd ff ff       	call   801094 <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	90                   	nop
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	52                   	push   %edx
  8012f3:	50                   	push   %eax
  8012f4:	6a 17                	push   $0x17
  8012f6:	e8 99 fd ff ff       	call   801094 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80130d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801310:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	51                   	push   %ecx
  80131a:	52                   	push   %edx
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	50                   	push   %eax
  80131f:	6a 19                	push   $0x19
  801321:	e8 6e fd ff ff       	call   801094 <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80132e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	52                   	push   %edx
  80133b:	50                   	push   %eax
  80133c:	6a 1a                	push   $0x1a
  80133e:	e8 51 fd ff ff       	call   801094 <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80134b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	51                   	push   %ecx
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 1b                	push   $0x1b
  80135d:	e8 32 fd ff ff       	call   801094 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	6a 1c                	push   $0x1c
  80137a:	e8 15 fd ff ff       	call   801094 <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 1d                	push   $0x1d
  801393:	e8 fc fc ff ff       	call   801094 <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	6a 00                	push   $0x0
  8013a5:	ff 75 14             	pushl  0x14(%ebp)
  8013a8:	ff 75 10             	pushl  0x10(%ebp)
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	50                   	push   %eax
  8013af:	6a 1e                	push   $0x1e
  8013b1:	e8 de fc ff ff       	call   801094 <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	50                   	push   %eax
  8013ca:	6a 1f                	push   $0x1f
  8013cc:	e8 c3 fc ff ff       	call   801094 <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	90                   	nop
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	50                   	push   %eax
  8013e6:	6a 20                	push   $0x20
  8013e8:	e8 a7 fc ff ff       	call   801094 <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 02                	push   $0x2
  801401:	e8 8e fc ff ff       	call   801094 <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 03                	push   $0x3
  80141a:	e8 75 fc ff ff       	call   801094 <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 04                	push   $0x4
  801433:	e8 5c fc ff ff       	call   801094 <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_exit_env>:


void sys_exit_env(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 21                	push   $0x21
  80144c:	e8 43 fc ff ff       	call   801094 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80145d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801460:	8d 50 04             	lea    0x4(%eax),%edx
  801463:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	52                   	push   %edx
  80146d:	50                   	push   %eax
  80146e:	6a 22                	push   $0x22
  801470:	e8 1f fc ff ff       	call   801094 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
	return result;
  801478:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	89 01                	mov    %eax,(%ecx)
  801483:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	c9                   	leave  
  80148a:	c2 04 00             	ret    $0x4

0080148d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	ff 75 10             	pushl  0x10(%ebp)
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	6a 10                	push   $0x10
  80149f:	e8 f0 fb ff ff       	call   801094 <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a7:	90                   	nop
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_rcr2>:
uint32 sys_rcr2()
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 23                	push   $0x23
  8014b9:	e8 d6 fb ff ff       	call   801094 <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014cf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	50                   	push   %eax
  8014dc:	6a 24                	push   $0x24
  8014de:	e8 b1 fb ff ff       	call   801094 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e6:	90                   	nop
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <rsttst>:
void rsttst()
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 26                	push   $0x26
  8014f8:	e8 97 fb ff ff       	call   801094 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801500:	90                   	nop
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80150f:	8b 55 18             	mov    0x18(%ebp),%edx
  801512:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	ff 75 10             	pushl  0x10(%ebp)
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	6a 25                	push   $0x25
  801523:	e8 6c fb ff ff       	call   801094 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
	return ;
  80152b:	90                   	nop
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <chktst>:
void chktst(uint32 n)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	6a 27                	push   $0x27
  80153e:	e8 51 fb ff ff       	call   801094 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
	return ;
  801546:	90                   	nop
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <inctst>:

void inctst()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 28                	push   $0x28
  801558:	e8 37 fb ff ff       	call   801094 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
	return ;
  801560:	90                   	nop
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <gettst>:
uint32 gettst()
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 29                	push   $0x29
  801572:	e8 1d fb ff ff       	call   801094 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 2a                	push   $0x2a
  80158e:	e8 01 fb ff ff       	call   801094 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
  801596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801599:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80159d:	75 07                	jne    8015a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80159f:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a4:	eb 05                	jmp    8015ab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 2a                	push   $0x2a
  8015bf:	e8 d0 fa ff ff       	call   801094 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
  8015c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015ca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015ce:	75 07                	jne    8015d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d5:	eb 05                	jmp    8015dc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 2a                	push   $0x2a
  8015f0:	e8 9f fa ff ff       	call   801094 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
  8015f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015fb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015ff:	75 07                	jne    801608 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801601:	b8 01 00 00 00       	mov    $0x1,%eax
  801606:	eb 05                	jmp    80160d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 2a                	push   $0x2a
  801621:	e8 6e fa ff ff       	call   801094 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
  801629:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80162c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801630:	75 07                	jne    801639 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801632:	b8 01 00 00 00       	mov    $0x1,%eax
  801637:	eb 05                	jmp    80163e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	6a 2b                	push   $0x2b
  801650:	e8 3f fa ff ff       	call   801094 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
	return ;
  801658:	90                   	nop
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80165f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801662:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	53                   	push   %ebx
  80166e:	51                   	push   %ecx
  80166f:	52                   	push   %edx
  801670:	50                   	push   %eax
  801671:	6a 2c                	push   $0x2c
  801673:	e8 1c fa ff ff       	call   801094 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	52                   	push   %edx
  801690:	50                   	push   %eax
  801691:	6a 2d                	push   $0x2d
  801693:	e8 fc f9 ff ff       	call   801094 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	51                   	push   %ecx
  8016ac:	ff 75 10             	pushl  0x10(%ebp)
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 2e                	push   $0x2e
  8016b3:	e8 dc f9 ff ff       	call   801094 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	ff 75 10             	pushl  0x10(%ebp)
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	ff 75 08             	pushl  0x8(%ebp)
  8016cd:	6a 0f                	push   $0xf
  8016cf:	e8 c0 f9 ff ff       	call   801094 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d7:	90                   	nop
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	50                   	push   %eax
  8016e9:	6a 2f                	push   $0x2f
  8016eb:	e8 a4 f9 ff ff       	call   801094 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp

}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	6a 30                	push   $0x30
  801706:	e8 89 f9 ff ff       	call   801094 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	6a 31                	push   $0x31
  801722:	e8 6d f9 ff ff       	call   801094 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
	return;
  80172a:	90                   	nop
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 32                	push   $0x32
  80173c:	e8 53 f9 ff ff       	call   801094 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	50                   	push   %eax
  801755:	6a 33                	push   $0x33
  801757:	e8 38 f9 ff ff       	call   801094 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    
  801762:	66 90                	xchg   %ax,%ax

00801764 <__udivdi3>:
  801764:	55                   	push   %ebp
  801765:	57                   	push   %edi
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 1c             	sub    $0x1c,%esp
  80176b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80176f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177b:	89 ca                	mov    %ecx,%edx
  80177d:	89 f8                	mov    %edi,%eax
  80177f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801783:	85 f6                	test   %esi,%esi
  801785:	75 2d                	jne    8017b4 <__udivdi3+0x50>
  801787:	39 cf                	cmp    %ecx,%edi
  801789:	77 65                	ja     8017f0 <__udivdi3+0x8c>
  80178b:	89 fd                	mov    %edi,%ebp
  80178d:	85 ff                	test   %edi,%edi
  80178f:	75 0b                	jne    80179c <__udivdi3+0x38>
  801791:	b8 01 00 00 00       	mov    $0x1,%eax
  801796:	31 d2                	xor    %edx,%edx
  801798:	f7 f7                	div    %edi
  80179a:	89 c5                	mov    %eax,%ebp
  80179c:	31 d2                	xor    %edx,%edx
  80179e:	89 c8                	mov    %ecx,%eax
  8017a0:	f7 f5                	div    %ebp
  8017a2:	89 c1                	mov    %eax,%ecx
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	f7 f5                	div    %ebp
  8017a8:	89 cf                	mov    %ecx,%edi
  8017aa:	89 fa                	mov    %edi,%edx
  8017ac:	83 c4 1c             	add    $0x1c,%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
  8017b4:	39 ce                	cmp    %ecx,%esi
  8017b6:	77 28                	ja     8017e0 <__udivdi3+0x7c>
  8017b8:	0f bd fe             	bsr    %esi,%edi
  8017bb:	83 f7 1f             	xor    $0x1f,%edi
  8017be:	75 40                	jne    801800 <__udivdi3+0x9c>
  8017c0:	39 ce                	cmp    %ecx,%esi
  8017c2:	72 0a                	jb     8017ce <__udivdi3+0x6a>
  8017c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017c8:	0f 87 9e 00 00 00    	ja     80186c <__udivdi3+0x108>
  8017ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d3:	89 fa                	mov    %edi,%edx
  8017d5:	83 c4 1c             	add    $0x1c,%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    
  8017dd:	8d 76 00             	lea    0x0(%esi),%esi
  8017e0:	31 ff                	xor    %edi,%edi
  8017e2:	31 c0                	xor    %eax,%eax
  8017e4:	89 fa                	mov    %edi,%edx
  8017e6:	83 c4 1c             	add    $0x1c,%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
  8017ee:	66 90                	xchg   %ax,%ax
  8017f0:	89 d8                	mov    %ebx,%eax
  8017f2:	f7 f7                	div    %edi
  8017f4:	31 ff                	xor    %edi,%edi
  8017f6:	89 fa                	mov    %edi,%edx
  8017f8:	83 c4 1c             	add    $0x1c,%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5f                   	pop    %edi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    
  801800:	bd 20 00 00 00       	mov    $0x20,%ebp
  801805:	89 eb                	mov    %ebp,%ebx
  801807:	29 fb                	sub    %edi,%ebx
  801809:	89 f9                	mov    %edi,%ecx
  80180b:	d3 e6                	shl    %cl,%esi
  80180d:	89 c5                	mov    %eax,%ebp
  80180f:	88 d9                	mov    %bl,%cl
  801811:	d3 ed                	shr    %cl,%ebp
  801813:	89 e9                	mov    %ebp,%ecx
  801815:	09 f1                	or     %esi,%ecx
  801817:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80181b:	89 f9                	mov    %edi,%ecx
  80181d:	d3 e0                	shl    %cl,%eax
  80181f:	89 c5                	mov    %eax,%ebp
  801821:	89 d6                	mov    %edx,%esi
  801823:	88 d9                	mov    %bl,%cl
  801825:	d3 ee                	shr    %cl,%esi
  801827:	89 f9                	mov    %edi,%ecx
  801829:	d3 e2                	shl    %cl,%edx
  80182b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80182f:	88 d9                	mov    %bl,%cl
  801831:	d3 e8                	shr    %cl,%eax
  801833:	09 c2                	or     %eax,%edx
  801835:	89 d0                	mov    %edx,%eax
  801837:	89 f2                	mov    %esi,%edx
  801839:	f7 74 24 0c          	divl   0xc(%esp)
  80183d:	89 d6                	mov    %edx,%esi
  80183f:	89 c3                	mov    %eax,%ebx
  801841:	f7 e5                	mul    %ebp
  801843:	39 d6                	cmp    %edx,%esi
  801845:	72 19                	jb     801860 <__udivdi3+0xfc>
  801847:	74 0b                	je     801854 <__udivdi3+0xf0>
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	31 ff                	xor    %edi,%edi
  80184d:	e9 58 ff ff ff       	jmp    8017aa <__udivdi3+0x46>
  801852:	66 90                	xchg   %ax,%ax
  801854:	8b 54 24 08          	mov    0x8(%esp),%edx
  801858:	89 f9                	mov    %edi,%ecx
  80185a:	d3 e2                	shl    %cl,%edx
  80185c:	39 c2                	cmp    %eax,%edx
  80185e:	73 e9                	jae    801849 <__udivdi3+0xe5>
  801860:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801863:	31 ff                	xor    %edi,%edi
  801865:	e9 40 ff ff ff       	jmp    8017aa <__udivdi3+0x46>
  80186a:	66 90                	xchg   %ax,%ax
  80186c:	31 c0                	xor    %eax,%eax
  80186e:	e9 37 ff ff ff       	jmp    8017aa <__udivdi3+0x46>
  801873:	90                   	nop

00801874 <__umoddi3>:
  801874:	55                   	push   %ebp
  801875:	57                   	push   %edi
  801876:	56                   	push   %esi
  801877:	53                   	push   %ebx
  801878:	83 ec 1c             	sub    $0x1c,%esp
  80187b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80187f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801883:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801887:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80188b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801893:	89 f3                	mov    %esi,%ebx
  801895:	89 fa                	mov    %edi,%edx
  801897:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80189b:	89 34 24             	mov    %esi,(%esp)
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	75 1a                	jne    8018bc <__umoddi3+0x48>
  8018a2:	39 f7                	cmp    %esi,%edi
  8018a4:	0f 86 a2 00 00 00    	jbe    80194c <__umoddi3+0xd8>
  8018aa:	89 c8                	mov    %ecx,%eax
  8018ac:	89 f2                	mov    %esi,%edx
  8018ae:	f7 f7                	div    %edi
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	31 d2                	xor    %edx,%edx
  8018b4:	83 c4 1c             	add    $0x1c,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    
  8018bc:	39 f0                	cmp    %esi,%eax
  8018be:	0f 87 ac 00 00 00    	ja     801970 <__umoddi3+0xfc>
  8018c4:	0f bd e8             	bsr    %eax,%ebp
  8018c7:	83 f5 1f             	xor    $0x1f,%ebp
  8018ca:	0f 84 ac 00 00 00    	je     80197c <__umoddi3+0x108>
  8018d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8018d5:	29 ef                	sub    %ebp,%edi
  8018d7:	89 fe                	mov    %edi,%esi
  8018d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018dd:	89 e9                	mov    %ebp,%ecx
  8018df:	d3 e0                	shl    %cl,%eax
  8018e1:	89 d7                	mov    %edx,%edi
  8018e3:	89 f1                	mov    %esi,%ecx
  8018e5:	d3 ef                	shr    %cl,%edi
  8018e7:	09 c7                	or     %eax,%edi
  8018e9:	89 e9                	mov    %ebp,%ecx
  8018eb:	d3 e2                	shl    %cl,%edx
  8018ed:	89 14 24             	mov    %edx,(%esp)
  8018f0:	89 d8                	mov    %ebx,%eax
  8018f2:	d3 e0                	shl    %cl,%eax
  8018f4:	89 c2                	mov    %eax,%edx
  8018f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018fa:	d3 e0                	shl    %cl,%eax
  8018fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801900:	8b 44 24 08          	mov    0x8(%esp),%eax
  801904:	89 f1                	mov    %esi,%ecx
  801906:	d3 e8                	shr    %cl,%eax
  801908:	09 d0                	or     %edx,%eax
  80190a:	d3 eb                	shr    %cl,%ebx
  80190c:	89 da                	mov    %ebx,%edx
  80190e:	f7 f7                	div    %edi
  801910:	89 d3                	mov    %edx,%ebx
  801912:	f7 24 24             	mull   (%esp)
  801915:	89 c6                	mov    %eax,%esi
  801917:	89 d1                	mov    %edx,%ecx
  801919:	39 d3                	cmp    %edx,%ebx
  80191b:	0f 82 87 00 00 00    	jb     8019a8 <__umoddi3+0x134>
  801921:	0f 84 91 00 00 00    	je     8019b8 <__umoddi3+0x144>
  801927:	8b 54 24 04          	mov    0x4(%esp),%edx
  80192b:	29 f2                	sub    %esi,%edx
  80192d:	19 cb                	sbb    %ecx,%ebx
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801935:	d3 e0                	shl    %cl,%eax
  801937:	89 e9                	mov    %ebp,%ecx
  801939:	d3 ea                	shr    %cl,%edx
  80193b:	09 d0                	or     %edx,%eax
  80193d:	89 e9                	mov    %ebp,%ecx
  80193f:	d3 eb                	shr    %cl,%ebx
  801941:	89 da                	mov    %ebx,%edx
  801943:	83 c4 1c             	add    $0x1c,%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5f                   	pop    %edi
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    
  80194b:	90                   	nop
  80194c:	89 fd                	mov    %edi,%ebp
  80194e:	85 ff                	test   %edi,%edi
  801950:	75 0b                	jne    80195d <__umoddi3+0xe9>
  801952:	b8 01 00 00 00       	mov    $0x1,%eax
  801957:	31 d2                	xor    %edx,%edx
  801959:	f7 f7                	div    %edi
  80195b:	89 c5                	mov    %eax,%ebp
  80195d:	89 f0                	mov    %esi,%eax
  80195f:	31 d2                	xor    %edx,%edx
  801961:	f7 f5                	div    %ebp
  801963:	89 c8                	mov    %ecx,%eax
  801965:	f7 f5                	div    %ebp
  801967:	89 d0                	mov    %edx,%eax
  801969:	e9 44 ff ff ff       	jmp    8018b2 <__umoddi3+0x3e>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	89 c8                	mov    %ecx,%eax
  801972:	89 f2                	mov    %esi,%edx
  801974:	83 c4 1c             	add    $0x1c,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
  80197c:	3b 04 24             	cmp    (%esp),%eax
  80197f:	72 06                	jb     801987 <__umoddi3+0x113>
  801981:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801985:	77 0f                	ja     801996 <__umoddi3+0x122>
  801987:	89 f2                	mov    %esi,%edx
  801989:	29 f9                	sub    %edi,%ecx
  80198b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80198f:	89 14 24             	mov    %edx,(%esp)
  801992:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801996:	8b 44 24 04          	mov    0x4(%esp),%eax
  80199a:	8b 14 24             	mov    (%esp),%edx
  80199d:	83 c4 1c             	add    $0x1c,%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5f                   	pop    %edi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
  8019a5:	8d 76 00             	lea    0x0(%esi),%esi
  8019a8:	2b 04 24             	sub    (%esp),%eax
  8019ab:	19 fa                	sbb    %edi,%edx
  8019ad:	89 d1                	mov    %edx,%ecx
  8019af:	89 c6                	mov    %eax,%esi
  8019b1:	e9 71 ff ff ff       	jmp    801927 <__umoddi3+0xb3>
  8019b6:	66 90                	xchg   %ax,%ax
  8019b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019bc:	72 ea                	jb     8019a8 <__umoddi3+0x134>
  8019be:	89 d9                	mov    %ebx,%ecx
  8019c0:	e9 62 ff ff ff       	jmp    801927 <__umoddi3+0xb3>
