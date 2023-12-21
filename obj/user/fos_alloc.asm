
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 15 11 00 00       	call   801165 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 20 31 80 00       	push   $0x803120
  800061:	e8 01 03 00 00       	call   800367 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 33 31 80 00       	push   $0x803133
  8000be:	e8 a4 02 00 00       	call   800367 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 e5 11 00 00       	call   8012c1 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 7b 10 00 00       	call   801165 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 33 31 80 00       	push   $0x803133
  800114:	e8 4e 02 00 00       	call   800367 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 8f 11 00 00       	call   8012c1 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 cc 16 00 00       	call   80180f <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	01 c0                	add    %eax,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c1 e0 06             	shl    $0x6,%eax
  800152:	29 d0                	sub    %edx,%eax
  800154:	c1 e0 03             	shl    $0x3,%eax
  800157:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800161:	a1 20 40 80 00       	mov    0x804020,%eax
  800166:	8a 40 68             	mov    0x68(%eax),%al
  800169:	84 c0                	test   %al,%al
  80016b:	74 0d                	je     80017a <libmain+0x42>
		binaryname = myEnv->prog_name;
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	83 c0 68             	add    $0x68,%eax
  800175:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017e:	7e 0a                	jle    80018a <libmain+0x52>
		binaryname = argv[0];
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 00                	mov    (%eax),%eax
  800185:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 0c             	pushl  0xc(%ebp)
  800190:	ff 75 08             	pushl  0x8(%ebp)
  800193:	e8 a0 fe ff ff       	call   800038 <_main>
  800198:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80019b:	e8 7c 14 00 00       	call   80161c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 58 31 80 00       	push   $0x803158
  8001a8:	e8 8d 01 00 00       	call   80033a <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	52                   	push   %edx
  8001ca:	50                   	push   %eax
  8001cb:	68 80 31 80 00       	push   $0x803180
  8001d0:	e8 65 01 00 00       	call   80033a <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  8001f9:	51                   	push   %ecx
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	68 a8 31 80 00       	push   $0x8031a8
  800201:	e8 34 01 00 00       	call   80033a <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800209:	a1 20 40 80 00       	mov    0x804020,%eax
  80020e:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 00 32 80 00       	push   $0x803200
  80021d:	e8 18 01 00 00       	call   80033a <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 58 31 80 00       	push   $0x803158
  80022d:	e8 08 01 00 00       	call   80033a <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800235:	e8 fc 13 00 00       	call   801636 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80023a:	e8 19 00 00 00       	call   800258 <exit>
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	6a 00                	push   $0x0
  80024d:	e8 89 15 00 00       	call   8017db <sys_destroy_env>
  800252:	83 c4 10             	add    $0x10,%esp
}
  800255:	90                   	nop
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <exit>:

void
exit(void)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80025e:	e8 de 15 00 00       	call   801841 <sys_exit_env>
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	8d 48 01             	lea    0x1(%eax),%ecx
  800274:	8b 55 0c             	mov    0xc(%ebp),%edx
  800277:	89 0a                	mov    %ecx,(%edx)
  800279:	8b 55 08             	mov    0x8(%ebp),%edx
  80027c:	88 d1                	mov    %dl,%cl
  80027e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800281:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	8b 00                	mov    (%eax),%eax
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	75 2c                	jne    8002bd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800291:	a0 24 40 80 00       	mov    0x804024,%al
  800296:	0f b6 c0             	movzbl %al,%eax
  800299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029c:	8b 12                	mov    (%edx),%edx
  80029e:	89 d1                	mov    %edx,%ecx
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	83 c2 08             	add    $0x8,%edx
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	50                   	push   %eax
  8002aa:	51                   	push   %ecx
  8002ab:	52                   	push   %edx
  8002ac:	e8 12 12 00 00       	call   8014c3 <sys_cputs>
  8002b1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	8b 40 04             	mov    0x4(%eax),%eax
  8002c3:	8d 50 01             	lea    0x1(%eax),%edx
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002df:	00 00 00 
	b.cnt = 0;
  8002e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ec:	ff 75 0c             	pushl  0xc(%ebp)
  8002ef:	ff 75 08             	pushl  0x8(%ebp)
  8002f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	68 66 02 80 00       	push   $0x800266
  8002fe:	e8 11 02 00 00       	call   800514 <vprintfmt>
  800303:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800306:	a0 24 40 80 00       	mov    0x804024,%al
  80030b:	0f b6 c0             	movzbl %al,%eax
  80030e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	50                   	push   %eax
  800318:	52                   	push   %edx
  800319:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031f:	83 c0 08             	add    $0x8,%eax
  800322:	50                   	push   %eax
  800323:	e8 9b 11 00 00       	call   8014c3 <sys_cputs>
  800328:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80032b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800332:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    

0080033a <cprintf>:

int cprintf(const char *fmt, ...) {
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800340:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800347:	8d 45 0c             	lea    0xc(%ebp),%eax
  80034a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	ff 75 f4             	pushl  -0xc(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 73 ff ff ff       	call   8002cf <vcprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800362:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80036d:	e8 aa 12 00 00       	call   80161c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800372:	8d 45 0c             	lea    0xc(%ebp),%eax
  800375:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	ff 75 f4             	pushl  -0xc(%ebp)
  800381:	50                   	push   %eax
  800382:	e8 48 ff ff ff       	call   8002cf <vcprintf>
  800387:	83 c4 10             	add    $0x10,%esp
  80038a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80038d:	e8 a4 12 00 00       	call   801636 <sys_enable_interrupt>
	return cnt;
  800392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	53                   	push   %ebx
  80039b:	83 ec 14             	sub    $0x14,%esp
  80039e:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003aa:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b5:	77 55                	ja     80040c <printnum+0x75>
  8003b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ba:	72 05                	jb     8003c1 <printnum+0x2a>
  8003bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003bf:	77 4b                	ja     80040c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cf:	52                   	push   %edx
  8003d0:	50                   	push   %eax
  8003d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d7:	e8 dc 2a 00 00       	call   802eb8 <__udivdi3>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	83 ec 04             	sub    $0x4,%esp
  8003e2:	ff 75 20             	pushl  0x20(%ebp)
  8003e5:	53                   	push   %ebx
  8003e6:	ff 75 18             	pushl  0x18(%ebp)
  8003e9:	52                   	push   %edx
  8003ea:	50                   	push   %eax
  8003eb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ee:	ff 75 08             	pushl  0x8(%ebp)
  8003f1:	e8 a1 ff ff ff       	call   800397 <printnum>
  8003f6:	83 c4 20             	add    $0x20,%esp
  8003f9:	eb 1a                	jmp    800415 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 0c             	pushl  0xc(%ebp)
  800401:	ff 75 20             	pushl  0x20(%ebp)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	ff d0                	call   *%eax
  800409:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040c:	ff 4d 1c             	decl   0x1c(%ebp)
  80040f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800413:	7f e6                	jg     8003fb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800415:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800418:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	53                   	push   %ebx
  800424:	51                   	push   %ecx
  800425:	52                   	push   %edx
  800426:	50                   	push   %eax
  800427:	e8 9c 2b 00 00       	call   802fc8 <__umoddi3>
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	05 34 34 80 00       	add    $0x803434,%eax
  800434:	8a 00                	mov    (%eax),%al
  800436:	0f be c0             	movsbl %al,%eax
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 0c             	pushl  0xc(%ebp)
  80043f:	50                   	push   %eax
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	ff d0                	call   *%eax
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800451:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800455:	7e 1c                	jle    800473 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 08             	lea    0x8(%eax),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	83 e8 08             	sub    $0x8,%eax
  80046c:	8b 50 04             	mov    0x4(%eax),%edx
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	eb 40                	jmp    8004b3 <getuint+0x65>
	else if (lflag)
  800473:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800477:	74 1e                	je     800497 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	8d 50 04             	lea    0x4(%eax),%edx
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	89 10                	mov    %edx,(%eax)
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	83 e8 04             	sub    $0x4,%eax
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	ba 00 00 00 00       	mov    $0x0,%edx
  800495:	eb 1c                	jmp    8004b3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	8d 50 04             	lea    0x4(%eax),%edx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	89 10                	mov    %edx,(%eax)
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	83 e8 04             	sub    $0x4,%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004bc:	7e 1c                	jle    8004da <getint+0x25>
		return va_arg(*ap, long long);
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 08             	lea    0x8(%eax),%edx
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	83 e8 08             	sub    $0x8,%eax
  8004d3:	8b 50 04             	mov    0x4(%eax),%edx
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	eb 38                	jmp    800512 <getint+0x5d>
	else if (lflag)
  8004da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004de:	74 1a                	je     8004fa <getint+0x45>
		return va_arg(*ap, long);
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 04             	lea    0x4(%eax),%edx
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	83 e8 04             	sub    $0x4,%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	99                   	cltd   
  8004f8:	eb 18                	jmp    800512 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	8d 50 04             	lea    0x4(%eax),%edx
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 10                	mov    %edx,(%eax)
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	83 e8 04             	sub    $0x4,%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	99                   	cltd   
}
  800512:	5d                   	pop    %ebp
  800513:	c3                   	ret    

00800514 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	56                   	push   %esi
  800518:	53                   	push   %ebx
  800519:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051c:	eb 17                	jmp    800535 <vprintfmt+0x21>
			if (ch == '\0')
  80051e:	85 db                	test   %ebx,%ebx
  800520:	0f 84 af 03 00 00    	je     8008d5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	53                   	push   %ebx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	ff d0                	call   *%eax
  800532:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800535:	8b 45 10             	mov    0x10(%ebp),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	89 55 10             	mov    %edx,0x10(%ebp)
  80053e:	8a 00                	mov    (%eax),%al
  800540:	0f b6 d8             	movzbl %al,%ebx
  800543:	83 fb 25             	cmp    $0x25,%ebx
  800546:	75 d6                	jne    80051e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800548:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80054c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800553:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800561:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800568:	8b 45 10             	mov    0x10(%ebp),%eax
  80056b:	8d 50 01             	lea    0x1(%eax),%edx
  80056e:	89 55 10             	mov    %edx,0x10(%ebp)
  800571:	8a 00                	mov    (%eax),%al
  800573:	0f b6 d8             	movzbl %al,%ebx
  800576:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800579:	83 f8 55             	cmp    $0x55,%eax
  80057c:	0f 87 2b 03 00 00    	ja     8008ad <vprintfmt+0x399>
  800582:	8b 04 85 58 34 80 00 	mov    0x803458(,%eax,4),%eax
  800589:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80058f:	eb d7                	jmp    800568 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800591:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800595:	eb d1                	jmp    800568 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800597:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80059e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	c1 e0 02             	shl    $0x2,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	01 c0                	add    %eax,%eax
  8005aa:	01 d8                	add    %ebx,%eax
  8005ac:	83 e8 30             	sub    $0x30,%eax
  8005af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	8a 00                	mov    (%eax),%al
  8005b7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005ba:	83 fb 2f             	cmp    $0x2f,%ebx
  8005bd:	7e 3e                	jle    8005fd <vprintfmt+0xe9>
  8005bf:	83 fb 39             	cmp    $0x39,%ebx
  8005c2:	7f 39                	jg     8005fd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005c7:	eb d5                	jmp    80059e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	83 c0 04             	add    $0x4,%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 e8 04             	sub    $0x4,%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005dd:	eb 1f                	jmp    8005fe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e3:	79 83                	jns    800568 <vprintfmt+0x54>
				width = 0;
  8005e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ec:	e9 77 ff ff ff       	jmp    800568 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f8:	e9 6b ff ff ff       	jmp    800568 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005fd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800602:	0f 89 60 ff ff ff    	jns    800568 <vprintfmt+0x54>
				width = precision, precision = -1;
  800608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80060e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800615:	e9 4e ff ff ff       	jmp    800568 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80061d:	e9 46 ff ff ff       	jmp    800568 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 c0 04             	add    $0x4,%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 e8 04             	sub    $0x4,%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	50                   	push   %eax
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	ff d0                	call   *%eax
  80063f:	83 c4 10             	add    $0x10,%esp
			break;
  800642:	e9 89 02 00 00       	jmp    8008d0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	83 c0 04             	add    $0x4,%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 e8 04             	sub    $0x4,%eax
  800656:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800658:	85 db                	test   %ebx,%ebx
  80065a:	79 02                	jns    80065e <vprintfmt+0x14a>
				err = -err;
  80065c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80065e:	83 fb 64             	cmp    $0x64,%ebx
  800661:	7f 0b                	jg     80066e <vprintfmt+0x15a>
  800663:	8b 34 9d a0 32 80 00 	mov    0x8032a0(,%ebx,4),%esi
  80066a:	85 f6                	test   %esi,%esi
  80066c:	75 19                	jne    800687 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80066e:	53                   	push   %ebx
  80066f:	68 45 34 80 00       	push   $0x803445
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 08             	pushl  0x8(%ebp)
  80067a:	e8 5e 02 00 00       	call   8008dd <printfmt>
  80067f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800682:	e9 49 02 00 00       	jmp    8008d0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800687:	56                   	push   %esi
  800688:	68 4e 34 80 00       	push   $0x80344e
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 08             	pushl  0x8(%ebp)
  800693:	e8 45 02 00 00       	call   8008dd <printfmt>
  800698:	83 c4 10             	add    $0x10,%esp
			break;
  80069b:	e9 30 02 00 00       	jmp    8008d0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	83 c0 04             	add    $0x4,%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 e8 04             	sub    $0x4,%eax
  8006af:	8b 30                	mov    (%eax),%esi
  8006b1:	85 f6                	test   %esi,%esi
  8006b3:	75 05                	jne    8006ba <vprintfmt+0x1a6>
				p = "(null)";
  8006b5:	be 51 34 80 00       	mov    $0x803451,%esi
			if (width > 0 && padc != '-')
  8006ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006be:	7e 6d                	jle    80072d <vprintfmt+0x219>
  8006c0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c4:	74 67                	je     80072d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	50                   	push   %eax
  8006cd:	56                   	push   %esi
  8006ce:	e8 0c 03 00 00       	call   8009df <strnlen>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006d9:	eb 16                	jmp    8006f1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	50                   	push   %eax
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	ff d0                	call   *%eax
  8006eb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f5:	7f e4                	jg     8006db <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f7:	eb 34                	jmp    80072d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006fd:	74 1c                	je     80071b <vprintfmt+0x207>
  8006ff:	83 fb 1f             	cmp    $0x1f,%ebx
  800702:	7e 05                	jle    800709 <vprintfmt+0x1f5>
  800704:	83 fb 7e             	cmp    $0x7e,%ebx
  800707:	7e 12                	jle    80071b <vprintfmt+0x207>
					putch('?', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	6a 3f                	push   $0x3f
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	eb 0f                	jmp    80072a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	53                   	push   %ebx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072a:	ff 4d e4             	decl   -0x1c(%ebp)
  80072d:	89 f0                	mov    %esi,%eax
  80072f:	8d 70 01             	lea    0x1(%eax),%esi
  800732:	8a 00                	mov    (%eax),%al
  800734:	0f be d8             	movsbl %al,%ebx
  800737:	85 db                	test   %ebx,%ebx
  800739:	74 24                	je     80075f <vprintfmt+0x24b>
  80073b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80073f:	78 b8                	js     8006f9 <vprintfmt+0x1e5>
  800741:	ff 4d e0             	decl   -0x20(%ebp)
  800744:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800748:	79 af                	jns    8006f9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074a:	eb 13                	jmp    80075f <vprintfmt+0x24b>
				putch(' ', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	6a 20                	push   $0x20
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075c:	ff 4d e4             	decl   -0x1c(%ebp)
  80075f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800763:	7f e7                	jg     80074c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800765:	e9 66 01 00 00       	jmp    8008d0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 e8             	pushl  -0x18(%ebp)
  800770:	8d 45 14             	lea    0x14(%ebp),%eax
  800773:	50                   	push   %eax
  800774:	e8 3c fd ff ff       	call   8004b5 <getint>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800788:	85 d2                	test   %edx,%edx
  80078a:	79 23                	jns    8007af <vprintfmt+0x29b>
				putch('-', putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	6a 2d                	push   $0x2d
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	ff d0                	call   *%eax
  800799:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80079c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a2:	f7 d8                	neg    %eax
  8007a4:	83 d2 00             	adc    $0x0,%edx
  8007a7:	f7 da                	neg    %edx
  8007a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b6:	e9 bc 00 00 00       	jmp    800877 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c4:	50                   	push   %eax
  8007c5:	e8 84 fc ff ff       	call   80044e <getuint>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007da:	e9 98 00 00 00       	jmp    800877 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	6a 58                	push   $0x58
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	ff d0                	call   *%eax
  8007ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	6a 58                	push   $0x58
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	6a 58                	push   $0x58
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
			break;
  80080f:	e9 bc 00 00 00       	jmp    8008d0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	6a 30                	push   $0x30
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 78                	push   $0x78
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 c0 04             	add    $0x4,%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 e8 04             	sub    $0x4,%eax
  800843:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80084f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800856:	eb 1f                	jmp    800877 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 e8             	pushl  -0x18(%ebp)
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	e8 e7 fb ff ff       	call   80044e <getuint>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800870:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800877:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087e:	83 ec 04             	sub    $0x4,%esp
  800881:	52                   	push   %edx
  800882:	ff 75 e4             	pushl  -0x1c(%ebp)
  800885:	50                   	push   %eax
  800886:	ff 75 f4             	pushl  -0xc(%ebp)
  800889:	ff 75 f0             	pushl  -0x10(%ebp)
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	ff 75 08             	pushl  0x8(%ebp)
  800892:	e8 00 fb ff ff       	call   800397 <printnum>
  800897:	83 c4 20             	add    $0x20,%esp
			break;
  80089a:	eb 34                	jmp    8008d0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
			break;
  8008ab:	eb 23                	jmp    8008d0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	6a 25                	push   $0x25
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bd:	ff 4d 10             	decl   0x10(%ebp)
  8008c0:	eb 03                	jmp    8008c5 <vprintfmt+0x3b1>
  8008c2:	ff 4d 10             	decl   0x10(%ebp)
  8008c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c8:	48                   	dec    %eax
  8008c9:	8a 00                	mov    (%eax),%al
  8008cb:	3c 25                	cmp    $0x25,%al
  8008cd:	75 f3                	jne    8008c2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008cf:	90                   	nop
		}
	}
  8008d0:	e9 47 fc ff ff       	jmp    80051c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008d5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f2:	50                   	push   %eax
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 16 fc ff ff       	call   800514 <vprintfmt>
  8008fe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800901:	90                   	nop
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	8b 40 08             	mov    0x8(%eax),%eax
  80090d:	8d 50 01             	lea    0x1(%eax),%edx
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
  800919:	8b 10                	mov    (%eax),%edx
  80091b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091e:	8b 40 04             	mov    0x4(%eax),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	73 12                	jae    800937 <sprintputch+0x33>
		*b->buf++ = ch;
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	8d 48 01             	lea    0x1(%eax),%ecx
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800930:	89 0a                	mov    %ecx,(%edx)
  800932:	8b 55 08             	mov    0x8(%ebp),%edx
  800935:	88 10                	mov    %dl,(%eax)
}
  800937:	90                   	nop
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8d 50 ff             	lea    -0x1(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	01 d0                	add    %edx,%eax
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80095f:	74 06                	je     800967 <vsnprintf+0x2d>
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	7f 07                	jg     80096e <vsnprintf+0x34>
		return -E_INVAL;
  800967:	b8 03 00 00 00       	mov    $0x3,%eax
  80096c:	eb 20                	jmp    80098e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096e:	ff 75 14             	pushl  0x14(%ebp)
  800971:	ff 75 10             	pushl  0x10(%ebp)
  800974:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800977:	50                   	push   %eax
  800978:	68 04 09 80 00       	push   $0x800904
  80097d:	e8 92 fb ff ff       	call   800514 <vprintfmt>
  800982:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800988:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800996:	8d 45 10             	lea    0x10(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 0c             	pushl  0xc(%ebp)
  8009a9:	ff 75 08             	pushl  0x8(%ebp)
  8009ac:	e8 89 ff ff ff       	call   80093a <vsnprintf>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c9:	eb 06                	jmp    8009d1 <strlen+0x15>
		n++;
  8009cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ce:	ff 45 08             	incl   0x8(%ebp)
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	84 c0                	test   %al,%al
  8009d8:	75 f1                	jne    8009cb <strlen+0xf>
		n++;
	return n;
  8009da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ec:	eb 09                	jmp    8009f7 <strnlen+0x18>
		n++;
  8009ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f1:	ff 45 08             	incl   0x8(%ebp)
  8009f4:	ff 4d 0c             	decl   0xc(%ebp)
  8009f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009fb:	74 09                	je     800a06 <strnlen+0x27>
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	75 e8                	jne    8009ee <strnlen+0xf>
		n++;
	return n;
  800a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a17:	90                   	nop
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8d 50 01             	lea    0x1(%eax),%edx
  800a1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2a:	8a 12                	mov    (%edx),%dl
  800a2c:	88 10                	mov    %dl,(%eax)
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	84 c0                	test   %al,%al
  800a32:	75 e4                	jne    800a18 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4c:	eb 1f                	jmp    800a6d <strncpy+0x34>
		*dst++ = *src;
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8d 50 01             	lea    0x1(%eax),%edx
  800a54:	89 55 08             	mov    %edx,0x8(%ebp)
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8a 12                	mov    (%edx),%dl
  800a5c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	84 c0                	test   %al,%al
  800a65:	74 03                	je     800a6a <strncpy+0x31>
			src++;
  800a67:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6a:	ff 45 fc             	incl   -0x4(%ebp)
  800a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a70:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a73:	72 d9                	jb     800a4e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8a:	74 30                	je     800abc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a8c:	eb 16                	jmp    800aa4 <strlcpy+0x2a>
			*dst++ = *src++;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8d 50 01             	lea    0x1(%eax),%edx
  800a94:	89 55 08             	mov    %edx,0x8(%ebp)
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa0:	8a 12                	mov    (%edx),%dl
  800aa2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa4:	ff 4d 10             	decl   0x10(%ebp)
  800aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aab:	74 09                	je     800ab6 <strlcpy+0x3c>
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	84 c0                	test   %al,%al
  800ab4:	75 d8                	jne    800a8e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abc:	8b 55 08             	mov    0x8(%ebp),%edx
  800abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac2:	29 c2                	sub    %eax,%edx
  800ac4:	89 d0                	mov    %edx,%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800acb:	eb 06                	jmp    800ad3 <strcmp+0xb>
		p++, q++;
  800acd:	ff 45 08             	incl   0x8(%ebp)
  800ad0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	84 c0                	test   %al,%al
  800ada:	74 0e                	je     800aea <strcmp+0x22>
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8a 10                	mov    (%eax),%dl
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	38 c2                	cmp    %al,%dl
  800ae8:	74 e3                	je     800acd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	0f b6 d0             	movzbl %al,%edx
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	0f b6 c0             	movzbl %al,%eax
  800afa:	29 c2                	sub    %eax,%edx
  800afc:	89 d0                	mov    %edx,%eax
}
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b03:	eb 09                	jmp    800b0e <strncmp+0xe>
		n--, p++, q++;
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	ff 45 08             	incl   0x8(%ebp)
  800b0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b12:	74 17                	je     800b2b <strncmp+0x2b>
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strncmp+0x2b>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 da                	je     800b05 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2f:	75 07                	jne    800b38 <strncmp+0x38>
		return 0;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	eb 14                	jmp    800b4c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	0f b6 d0             	movzbl %al,%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	0f b6 c0             	movzbl %al,%eax
  800b48:	29 c2                	sub    %eax,%edx
  800b4a:	89 d0                	mov    %edx,%eax
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 04             	sub    $0x4,%esp
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b5a:	eb 12                	jmp    800b6e <strchr+0x20>
		if (*s == c)
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b64:	75 05                	jne    800b6b <strchr+0x1d>
			return (char *) s;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	eb 11                	jmp    800b7c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6b:	ff 45 08             	incl   0x8(%ebp)
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e5                	jne    800b5c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b8a:	eb 0d                	jmp    800b99 <strfind+0x1b>
		if (*s == c)
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8a 00                	mov    (%eax),%al
  800b91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b94:	74 0e                	je     800ba4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b96:	ff 45 08             	incl   0x8(%ebp)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	84 c0                	test   %al,%al
  800ba0:	75 ea                	jne    800b8c <strfind+0xe>
  800ba2:	eb 01                	jmp    800ba5 <strfind+0x27>
		if (*s == c)
			break;
  800ba4:	90                   	nop
	return (char *) s;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bbc:	eb 0e                	jmp    800bcc <memset+0x22>
		*p++ = c;
  800bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc1:	8d 50 01             	lea    0x1(%eax),%edx
  800bc4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bcc:	ff 4d f8             	decl   -0x8(%ebp)
  800bcf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bd3:	79 e9                	jns    800bbe <memset+0x14>
		*p++ = c;

	return v;
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bec:	eb 16                	jmp    800c04 <memcpy+0x2a>
		*d++ = *s++;
  800bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c00:	8a 12                	mov    (%edx),%dl
  800c02:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c04:	8b 45 10             	mov    0x10(%ebp),%eax
  800c07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	75 dd                	jne    800bee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c2e:	73 50                	jae    800c80 <memmove+0x6a>
  800c30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3b:	76 43                	jbe    800c80 <memmove+0x6a>
		s += n;
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c49:	eb 10                	jmp    800c5b <memmove+0x45>
			*--d = *--s;
  800c4b:	ff 4d f8             	decl   -0x8(%ebp)
  800c4e:	ff 4d fc             	decl   -0x4(%ebp)
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c54:	8a 10                	mov    (%eax),%dl
  800c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c59:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c61:	89 55 10             	mov    %edx,0x10(%ebp)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	75 e3                	jne    800c4b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c68:	eb 23                	jmp    800c8d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c6d:	8d 50 01             	lea    0x1(%eax),%edx
  800c70:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c79:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c7c:	8a 12                	mov    (%edx),%dl
  800c7e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c86:	89 55 10             	mov    %edx,0x10(%ebp)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	75 dd                	jne    800c6a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ca4:	eb 2a                	jmp    800cd0 <memcmp+0x3e>
		if (*s1 != *s2)
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca9:	8a 10                	mov    (%eax),%dl
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	38 c2                	cmp    %al,%dl
  800cb2:	74 16                	je     800cca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f b6 d0             	movzbl %al,%edx
  800cbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 c0             	movzbl %al,%eax
  800cc4:	29 c2                	sub    %eax,%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	eb 18                	jmp    800ce2 <memcmp+0x50>
		s1++, s2++;
  800cca:	ff 45 fc             	incl   -0x4(%ebp)
  800ccd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd6:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	75 c9                	jne    800ca6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	01 d0                	add    %edx,%eax
  800cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cf5:	eb 15                	jmp    800d0c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 d0             	movzbl %al,%edx
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	39 c2                	cmp    %eax,%edx
  800d07:	74 0d                	je     800d16 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d09:	ff 45 08             	incl   0x8(%ebp)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d12:	72 e3                	jb     800cf7 <memfind+0x13>
  800d14:	eb 01                	jmp    800d17 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d16:	90                   	nop
	return (void *) s;
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d29:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d30:	eb 03                	jmp    800d35 <strtol+0x19>
		s++;
  800d32:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	3c 20                	cmp    $0x20,%al
  800d3c:	74 f4                	je     800d32 <strtol+0x16>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 09                	cmp    $0x9,%al
  800d45:	74 eb                	je     800d32 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 2b                	cmp    $0x2b,%al
  800d4e:	75 05                	jne    800d55 <strtol+0x39>
		s++;
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	eb 13                	jmp    800d68 <strtol+0x4c>
	else if (*s == '-')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2d                	cmp    $0x2d,%al
  800d5c:	75 0a                	jne    800d68 <strtol+0x4c>
		s++, neg = 1;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6c:	74 06                	je     800d74 <strtol+0x58>
  800d6e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d72:	75 20                	jne    800d94 <strtol+0x78>
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	3c 30                	cmp    $0x30,%al
  800d7b:	75 17                	jne    800d94 <strtol+0x78>
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	40                   	inc    %eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3c 78                	cmp    $0x78,%al
  800d85:	75 0d                	jne    800d94 <strtol+0x78>
		s += 2, base = 16;
  800d87:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d8b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d92:	eb 28                	jmp    800dbc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d98:	75 15                	jne    800daf <strtol+0x93>
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 30                	cmp    $0x30,%al
  800da1:	75 0c                	jne    800daf <strtol+0x93>
		s++, base = 8;
  800da3:	ff 45 08             	incl   0x8(%ebp)
  800da6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dad:	eb 0d                	jmp    800dbc <strtol+0xa0>
	else if (base == 0)
  800daf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db3:	75 07                	jne    800dbc <strtol+0xa0>
		base = 10;
  800db5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3c 2f                	cmp    $0x2f,%al
  800dc3:	7e 19                	jle    800dde <strtol+0xc2>
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	3c 39                	cmp    $0x39,%al
  800dcc:	7f 10                	jg     800dde <strtol+0xc2>
			dig = *s - '0';
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f be c0             	movsbl %al,%eax
  800dd6:	83 e8 30             	sub    $0x30,%eax
  800dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ddc:	eb 42                	jmp    800e20 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	3c 60                	cmp    $0x60,%al
  800de5:	7e 19                	jle    800e00 <strtol+0xe4>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	3c 7a                	cmp    $0x7a,%al
  800dee:	7f 10                	jg     800e00 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f be c0             	movsbl %al,%eax
  800df8:	83 e8 57             	sub    $0x57,%eax
  800dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dfe:	eb 20                	jmp    800e20 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	3c 40                	cmp    $0x40,%al
  800e07:	7e 39                	jle    800e42 <strtol+0x126>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 5a                	cmp    $0x5a,%al
  800e10:	7f 30                	jg     800e42 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f be c0             	movsbl %al,%eax
  800e1a:	83 e8 37             	sub    $0x37,%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e23:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e26:	7d 19                	jge    800e41 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e28:	ff 45 08             	incl   0x8(%ebp)
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e37:	01 d0                	add    %edx,%eax
  800e39:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e3c:	e9 7b ff ff ff       	jmp    800dbc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e41:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e46:	74 08                	je     800e50 <strtol+0x134>
		*endptr = (char *) s;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e54:	74 07                	je     800e5d <strtol+0x141>
  800e56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e59:	f7 d8                	neg    %eax
  800e5b:	eb 03                	jmp    800e60 <strtol+0x144>
  800e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <ltostr>:

void
ltostr(long value, char *str)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e6f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7a:	79 13                	jns    800e8f <ltostr+0x2d>
	{
		neg = 1;
  800e7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e89:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e8c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e97:	99                   	cltd   
  800e98:	f7 f9                	idiv   %ecx
  800e9a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	89 c2                	mov    %eax,%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	01 d0                	add    %edx,%eax
  800ead:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eb0:	83 c2 30             	add    $0x30,%edx
  800eb3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ebd:	f7 e9                	imul   %ecx
  800ebf:	c1 fa 02             	sar    $0x2,%edx
  800ec2:	89 c8                	mov    %ecx,%eax
  800ec4:	c1 f8 1f             	sar    $0x1f,%eax
  800ec7:	29 c2                	sub    %eax,%edx
  800ec9:	89 d0                	mov    %edx,%eax
  800ecb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ece:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed6:	f7 e9                	imul   %ecx
  800ed8:	c1 fa 02             	sar    $0x2,%edx
  800edb:	89 c8                	mov    %ecx,%eax
  800edd:	c1 f8 1f             	sar    $0x1f,%eax
  800ee0:	29 c2                	sub    %eax,%edx
  800ee2:	89 d0                	mov    %edx,%eax
  800ee4:	c1 e0 02             	shl    $0x2,%eax
  800ee7:	01 d0                	add    %edx,%eax
  800ee9:	01 c0                	add    %eax,%eax
  800eeb:	29 c1                	sub    %eax,%ecx
  800eed:	89 ca                	mov    %ecx,%edx
  800eef:	85 d2                	test   %edx,%edx
  800ef1:	75 9c                	jne    800e8f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ef3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efd:	48                   	dec    %eax
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f05:	74 3d                	je     800f44 <ltostr+0xe2>
		start = 1 ;
  800f07:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f0e:	eb 34                	jmp    800f44 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	01 d0                	add    %edx,%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	01 c2                	add    %eax,%edx
  800f25:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	01 c8                	add    %ecx,%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	01 c2                	add    %eax,%edx
  800f39:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f3c:	88 02                	mov    %al,(%edx)
		start++ ;
  800f3e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f41:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f4a:	7c c4                	jl     800f10 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f4c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	01 d0                	add    %edx,%eax
  800f54:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f60:	ff 75 08             	pushl  0x8(%ebp)
  800f63:	e8 54 fa ff ff       	call   8009bc <strlen>
  800f68:	83 c4 04             	add    $0x4,%esp
  800f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f6e:	ff 75 0c             	pushl  0xc(%ebp)
  800f71:	e8 46 fa ff ff       	call   8009bc <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f8a:	eb 17                	jmp    800fa3 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 c2                	add    %eax,%edx
  800f94:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	01 c8                	add    %ecx,%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fa0:	ff 45 fc             	incl   -0x4(%ebp)
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fa9:	7c e1                	jl     800f8c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fb9:	eb 1f                	jmp    800fda <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	8d 50 01             	lea    0x1(%eax),%edx
  800fc1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc4:	89 c2                	mov    %eax,%edx
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	01 c2                	add    %eax,%edx
  800fcb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	01 c8                	add    %ecx,%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe0:	7c d9                	jl     800fbb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fe2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	c6 00 00             	movb   $0x0,(%eax)
}
  800fed:	90                   	nop
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ff3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ffc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fff:	8b 00                	mov    (%eax),%eax
  801001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 d0                	add    %edx,%eax
  80100d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801013:	eb 0c                	jmp    801021 <strsplit+0x31>
			*string++ = 0;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	89 55 08             	mov    %edx,0x8(%ebp)
  80101e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	84 c0                	test   %al,%al
  801028:	74 18                	je     801042 <strsplit+0x52>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f be c0             	movsbl %al,%eax
  801032:	50                   	push   %eax
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	e8 13 fb ff ff       	call   800b4e <strchr>
  80103b:	83 c4 08             	add    $0x8,%esp
  80103e:	85 c0                	test   %eax,%eax
  801040:	75 d3                	jne    801015 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	84 c0                	test   %al,%al
  801049:	74 5a                	je     8010a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	83 f8 0f             	cmp    $0xf,%eax
  801053:	75 07                	jne    80105c <strsplit+0x6c>
		{
			return 0;
  801055:	b8 00 00 00 00       	mov    $0x0,%eax
  80105a:	eb 66                	jmp    8010c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80105c:	8b 45 14             	mov    0x14(%ebp),%eax
  80105f:	8b 00                	mov    (%eax),%eax
  801061:	8d 48 01             	lea    0x1(%eax),%ecx
  801064:	8b 55 14             	mov    0x14(%ebp),%edx
  801067:	89 0a                	mov    %ecx,(%edx)
  801069:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	01 c2                	add    %eax,%edx
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107a:	eb 03                	jmp    80107f <strsplit+0x8f>
			string++;
  80107c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	84 c0                	test   %al,%al
  801086:	74 8b                	je     801013 <strsplit+0x23>
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	0f be c0             	movsbl %al,%eax
  801090:	50                   	push   %eax
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	e8 b5 fa ff ff       	call   800b4e <strchr>
  801099:	83 c4 08             	add    $0x8,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	74 dc                	je     80107c <strsplit+0x8c>
			string++;
	}
  8010a0:	e9 6e ff ff ff       	jmp    801013 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d1:	eb 4c                	jmp    80111f <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 40                	cmp    $0x40,%al
  8010df:	7e 27                	jle    801108 <str2lower+0x44>
  8010e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	01 d0                	add    %edx,%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	3c 5a                	cmp    $0x5a,%al
  8010ed:	7f 19                	jg     801108 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8010ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	01 d0                	add    %edx,%eax
  8010f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fd:	01 ca                	add    %ecx,%edx
  8010ff:	8a 12                	mov    (%edx),%dl
  801101:	83 c2 20             	add    $0x20,%edx
  801104:	88 10                	mov    %dl,(%eax)
  801106:	eb 14                	jmp    80111c <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80111c:	ff 45 fc             	incl   -0x4(%ebp)
  80111f:	ff 75 0c             	pushl  0xc(%ebp)
  801122:	e8 95 f8 ff ff       	call   8009bc <strlen>
  801127:	83 c4 04             	add    $0x4,%esp
  80112a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112d:	7f a4                	jg     8010d3 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801139:	a1 04 40 80 00       	mov    0x804004,%eax
  80113e:	85 c0                	test   %eax,%eax
  801140:	74 0a                	je     80114c <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801142:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801149:	00 00 00 
	}
}
  80114c:	90                   	nop
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 7e 09 00 00       	call   801ade <sys_sbrk>
  801160:	83 c4 10             	add    $0x10,%esp
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80116b:	e8 c6 ff ff ff       	call   801136 <InitializeUHeap>
	if (size == 0)
  801170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801174:	75 0a                	jne    801180 <malloc+0x1b>
		return NULL;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	e9 3f 01 00 00       	jmp    8012bf <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801180:	e8 ac 09 00 00       	call   801b31 <sys_get_hard_limit>
  801185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801188:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  80118f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801192:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
  80119a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  80119d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011aa:	01 d0                	add    %edx,%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8011b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b8:	f7 75 d8             	divl   -0x28(%ebp)
  8011bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011be:	29 d0                	sub    %edx,%eax
  8011c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8011c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011c6:	c1 e8 0c             	shr    $0xc,%eax
  8011c9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8011cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d0:	75 0a                	jne    8011dc <malloc+0x77>
		return NULL;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d7:	e9 e3 00 00 00       	jmp    8012bf <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8011dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011df:	05 00 00 00 80       	add    $0x80000000,%eax
  8011e4:	c1 e8 0c             	shr    $0xc,%eax
  8011e7:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8011ec:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8011f3:	77 19                	ja     80120e <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	ff 75 08             	pushl  0x8(%ebp)
  8011fb:	e8 44 0b 00 00       	call   801d44 <alloc_block_FF>
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801206:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801209:	e9 b1 00 00 00       	jmp    8012bf <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80120e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801211:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801214:	eb 4d                	jmp    801263 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801219:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  801220:	84 c0                	test   %al,%al
  801222:	75 27                	jne    80124b <malloc+0xe6>
			{
				counter++;
  801224:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801227:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80122b:	75 14                	jne    801241 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80122d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801230:	05 00 00 08 00       	add    $0x80000,%eax
  801235:	c1 e0 0c             	shl    $0xc,%eax
  801238:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  80123b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80123e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801244:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801247:	75 17                	jne    801260 <malloc+0xfb>
				{
					break;
  801249:	eb 21                	jmp    80126c <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  80124b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80124e:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  801255:	3c 01                	cmp    $0x1,%al
  801257:	75 07                	jne    801260 <malloc+0xfb>
			{
				counter = 0;
  801259:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801260:	ff 45 e8             	incl   -0x18(%ebp)
  801263:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  80126a:	76 aa                	jbe    801216 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80126c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80126f:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801272:	75 46                	jne    8012ba <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	ff 75 d0             	pushl  -0x30(%ebp)
  80127a:	ff 75 f4             	pushl  -0xc(%ebp)
  80127d:	e8 93 08 00 00       	call   801b15 <sys_allocate_user_mem>
  801282:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801288:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80128b:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801298:	eb 0e                	jmp    8012a8 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  80129a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129d:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  8012a4:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8012a5:	ff 45 e4             	incl   -0x1c(%ebp)
  8012a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8012ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012b3:	77 e5                	ja     80129a <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b8:	eb 05                	jmp    8012bf <malloc+0x15a>
		}
	}

	return NULL;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8012c7:	e8 65 08 00 00       	call   801b31 <sys_get_hard_limit>
  8012cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8012d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d9:	0f 84 c1 00 00 00    	je     8013a0 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8012df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	79 1b                	jns    801301 <free+0x40>
  8012e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ec:	73 13                	jae    801301 <free+0x40>
    {
        free_block(virtual_address);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	e8 18 10 00 00       	call   802311 <free_block>
  8012f9:	83 c4 10             	add    $0x10,%esp
    	return;
  8012fc:	e9 a6 00 00 00       	jmp    8013a7 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801304:	05 00 10 00 00       	add    $0x1000,%eax
  801309:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80130c:	0f 87 91 00 00 00    	ja     8013a3 <free+0xe2>
  801312:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801319:	0f 87 84 00 00 00    	ja     8013a3 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80131f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801322:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801328:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801333:	05 00 00 00 80       	add    $0x80000000,%eax
  801338:	c1 e8 0c             	shr    $0xc,%eax
  80133b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80133e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801341:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801348:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  80134b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80134f:	74 55                	je     8013a6 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801354:	c1 e8 0c             	shr    $0xc,%eax
  801357:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  80135a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135d:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  801364:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136e:	eb 0e                	jmp    80137e <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801373:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  80137a:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  80137b:	ff 45 f4             	incl   -0xc(%ebp)
  80137e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801384:	01 c2                	add    %eax,%edx
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	39 c2                	cmp    %eax,%edx
  80138b:	77 e3                	ja     801370 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 e0             	pushl  -0x20(%ebp)
  801393:	ff 75 ec             	pushl  -0x14(%ebp)
  801396:	e8 5e 07 00 00       	call   801af9 <sys_free_user_mem>
  80139b:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  80139e:	eb 07                	jmp    8013a7 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8013a0:	90                   	nop
  8013a1:	eb 04                	jmp    8013a7 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8013a3:	90                   	nop
  8013a4:	eb 01                	jmp    8013a7 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8013a6:	90                   	nop
    else
     {
    	return;
      }

}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	83 ec 18             	sub    $0x18,%esp
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013b5:	e8 7c fd ff ff       	call   801136 <InitializeUHeap>
	if (size == 0)
  8013ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013be:	75 07                	jne    8013c7 <smalloc+0x1e>
		return NULL;
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c5:	eb 17                	jmp    8013de <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 b0 35 80 00       	push   $0x8035b0
  8013cf:	68 ad 00 00 00       	push   $0xad
  8013d4:	68 d6 35 80 00       	push   $0x8035d6
  8013d9:	e8 ee 18 00 00       	call   802ccc <_panic>
	return NULL;
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013e6:	e8 4b fd ff ff       	call   801136 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	68 e4 35 80 00       	push   $0x8035e4
  8013f3:	68 ba 00 00 00       	push   $0xba
  8013f8:	68 d6 35 80 00       	push   $0x8035d6
  8013fd:	e8 ca 18 00 00       	call   802ccc <_panic>

00801402 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801408:	e8 29 fd ff ff       	call   801136 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	68 08 36 80 00       	push   $0x803608
  801415:	68 d8 00 00 00       	push   $0xd8
  80141a:	68 d6 35 80 00       	push   $0x8035d6
  80141f:	e8 a8 18 00 00       	call   802ccc <_panic>

00801424 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	68 30 36 80 00       	push   $0x803630
  801432:	68 ea 00 00 00       	push   $0xea
  801437:	68 d6 35 80 00       	push   $0x8035d6
  80143c:	e8 8b 18 00 00       	call   802ccc <_panic>

00801441 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	68 54 36 80 00       	push   $0x803654
  80144f:	68 f2 00 00 00       	push   $0xf2
  801454:	68 d6 35 80 00       	push   $0x8035d6
  801459:	e8 6e 18 00 00       	call   802ccc <_panic>

0080145e <shrink>:

}
void shrink(uint32 newSize) {
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	68 54 36 80 00       	push   $0x803654
  80146c:	68 f6 00 00 00       	push   $0xf6
  801471:	68 d6 35 80 00       	push   $0x8035d6
  801476:	e8 51 18 00 00       	call   802ccc <_panic>

0080147b <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	68 54 36 80 00       	push   $0x803654
  801489:	68 fa 00 00 00       	push   $0xfa
  80148e:	68 d6 35 80 00       	push   $0x8035d6
  801493:	e8 34 18 00 00       	call   802ccc <_panic>

00801498 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	57                   	push   %edi
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ad:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b3:	cd 30                	int    $0x30
  8014b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	52                   	push   %edx
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	50                   	push   %eax
  8014df:	6a 00                	push   $0x0
  8014e1:	e8 b2 ff ff ff       	call   801498 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 01                	push   $0x1
  8014fb:	e8 98 ff ff ff       	call   801498 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 05                	push   $0x5
  801518:	e8 7b ff ff ff       	call   801498 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801527:	8b 75 18             	mov    0x18(%ebp),%esi
  80152a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	51                   	push   %ecx
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 06                	push   $0x6
  80153d:	e8 56 ff ff ff       	call   801498 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	6a 07                	push   $0x7
  80155f:	e8 34 ff ff ff       	call   801498 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	ff 75 08             	pushl  0x8(%ebp)
  801578:	6a 08                	push   $0x8
  80157a:	e8 19 ff ff ff       	call   801498 <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 09                	push   $0x9
  801593:	e8 00 ff ff ff       	call   801498 <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 0a                	push   $0xa
  8015ac:	e8 e7 fe ff ff       	call   801498 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 0b                	push   $0xb
  8015c5:	e8 ce fe ff ff       	call   801498 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 0c                	push   $0xc
  8015de:	e8 b5 fe ff ff       	call   801498 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 0d                	push   $0xd
  8015f8:	e8 9b fe ff ff       	call   801498 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 0e                	push   $0xe
  801611:	e8 82 fe ff ff       	call   801498 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 11                	push   $0x11
  80162b:	e8 68 fe ff ff       	call   801498 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 12                	push   $0x12
  801645:	e8 4e fe ff ff       	call   801498 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_cputc>:


void
sys_cputc(const char c)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80165c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	50                   	push   %eax
  801669:	6a 13                	push   $0x13
  80166b:	e8 28 fe ff ff       	call   801498 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	90                   	nop
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 14                	push   $0x14
  801685:	e8 0e fe ff ff       	call   801498 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	50                   	push   %eax
  8016a0:	6a 15                	push   $0x15
  8016a2:	e8 f1 fd ff ff       	call   801498 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 18                	push   $0x18
  8016bf:	e8 d4 fd ff ff       	call   801498 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	6a 16                	push   $0x16
  8016dc:	e8 b7 fd ff ff       	call   801498 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	90                   	nop
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	6a 17                	push   $0x17
  8016fa:	e8 99 fd ff ff       	call   801498 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801711:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801714:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	51                   	push   %ecx
  80171e:	52                   	push   %edx
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	50                   	push   %eax
  801723:	6a 19                	push   $0x19
  801725:	e8 6e fd ff ff       	call   801498 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801732:	8b 55 0c             	mov    0xc(%ebp),%edx
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	52                   	push   %edx
  80173f:	50                   	push   %eax
  801740:	6a 1a                	push   $0x1a
  801742:	e8 51 fd ff ff       	call   801498 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80174f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	51                   	push   %ecx
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	6a 1b                	push   $0x1b
  801761:	e8 32 fd ff ff       	call   801498 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	52                   	push   %edx
  80177b:	50                   	push   %eax
  80177c:	6a 1c                	push   $0x1c
  80177e:	e8 15 fd ff ff       	call   801498 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 1d                	push   $0x1d
  801797:	e8 fc fc ff ff       	call   801498 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	ff 75 14             	pushl  0x14(%ebp)
  8017ac:	ff 75 10             	pushl  0x10(%ebp)
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	50                   	push   %eax
  8017b3:	6a 1e                	push   $0x1e
  8017b5:	e8 de fc ff ff       	call   801498 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	50                   	push   %eax
  8017ce:	6a 1f                	push   $0x1f
  8017d0:	e8 c3 fc ff ff       	call   801498 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	90                   	nop
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	50                   	push   %eax
  8017ea:	6a 20                	push   $0x20
  8017ec:	e8 a7 fc ff ff       	call   801498 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 02                	push   $0x2
  801805:	e8 8e fc ff ff       	call   801498 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 03                	push   $0x3
  80181e:	e8 75 fc ff ff       	call   801498 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 04                	push   $0x4
  801837:	e8 5c fc ff ff       	call   801498 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_exit_env>:


void sys_exit_env(void)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 21                	push   $0x21
  801850:	e8 43 fc ff ff       	call   801498 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	90                   	nop
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801861:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801864:	8d 50 04             	lea    0x4(%eax),%edx
  801867:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 22                	push   $0x22
  801874:	e8 1f fc ff ff       	call   801498 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
	return result;
  80187c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801882:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801885:	89 01                	mov    %eax,(%ecx)
  801887:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	c9                   	leave  
  80188e:	c2 04 00             	ret    $0x4

00801891 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 10                	push   $0x10
  8018a3:	e8 f0 fb ff ff       	call   801498 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 23                	push   $0x23
  8018bd:	e8 d6 fb ff ff       	call   801498 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 24                	push   $0x24
  8018e2:	e8 b1 fb ff ff       	call   801498 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <rsttst>:
void rsttst()
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 26                	push   $0x26
  8018fc:	e8 97 fb ff ff       	call   801498 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
	return ;
  801904:	90                   	nop
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801913:	8b 55 18             	mov    0x18(%ebp),%edx
  801916:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	ff 75 10             	pushl  0x10(%ebp)
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	6a 25                	push   $0x25
  801927:	e8 6c fb ff ff       	call   801498 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
	return ;
  80192f:	90                   	nop
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <chktst>:
void chktst(uint32 n)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 27                	push   $0x27
  801942:	e8 51 fb ff ff       	call   801498 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
	return ;
  80194a:	90                   	nop
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <inctst>:

void inctst()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 28                	push   $0x28
  80195c:	e8 37 fb ff ff       	call   801498 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <gettst>:
uint32 gettst()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 29                	push   $0x29
  801976:	e8 1d fb ff ff       	call   801498 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 2a                	push   $0x2a
  801992:	e8 01 fb ff ff       	call   801498 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
  80199a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80199d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019a1:	75 07                	jne    8019aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a8:	eb 05                	jmp    8019af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 2a                	push   $0x2a
  8019c3:	e8 d0 fa ff ff       	call   801498 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
  8019cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019d2:	75 07                	jne    8019db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d9:	eb 05                	jmp    8019e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 2a                	push   $0x2a
  8019f4:	e8 9f fa ff ff       	call   801498 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
  8019fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a03:	75 07                	jne    801a0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a05:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0a:	eb 05                	jmp    801a11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 2a                	push   $0x2a
  801a25:	e8 6e fa ff ff       	call   801498 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
  801a2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a30:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a34:	75 07                	jne    801a3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a36:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3b:	eb 05                	jmp    801a42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 2b                	push   $0x2b
  801a54:	e8 3f fa ff ff       	call   801498 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5c:	90                   	nop
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	53                   	push   %ebx
  801a72:	51                   	push   %ecx
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 2c                	push   $0x2c
  801a77:	e8 1c fa ff ff       	call   801498 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	6a 2d                	push   $0x2d
  801a97:	e8 fc f9 ff ff       	call   801498 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	51                   	push   %ecx
  801ab0:	ff 75 10             	pushl  0x10(%ebp)
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	6a 2e                	push   $0x2e
  801ab7:	e8 dc f9 ff ff       	call   801498 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	ff 75 10             	pushl  0x10(%ebp)
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 0f                	push   $0xf
  801ad3:	e8 c0 f9 ff ff       	call   801498 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	50                   	push   %eax
  801aed:	6a 2f                	push   $0x2f
  801aef:	e8 a4 f9 ff ff       	call   801498 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp

}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	6a 30                	push   $0x30
  801b0a:	e8 89 f9 ff ff       	call   801498 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
	return;
  801b12:	90                   	nop
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	ff 75 08             	pushl  0x8(%ebp)
  801b24:	6a 31                	push   $0x31
  801b26:	e8 6d f9 ff ff       	call   801498 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
	return;
  801b2e:	90                   	nop
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 32                	push   $0x32
  801b40:	e8 53 f9 ff ff       	call   801498 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	83 e8 10             	sub    $0x10,%eax
  801b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5c:	8b 00                	mov    (%eax),%eax
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	83 e8 10             	sub    $0x10,%eax
  801b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b72:	8a 40 04             	mov    0x4(%eax),%al
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	83 f8 02             	cmp    $0x2,%eax
  801b8a:	74 2b                	je     801bb7 <alloc_block+0x40>
  801b8c:	83 f8 02             	cmp    $0x2,%eax
  801b8f:	7f 07                	jg     801b98 <alloc_block+0x21>
  801b91:	83 f8 01             	cmp    $0x1,%eax
  801b94:	74 0e                	je     801ba4 <alloc_block+0x2d>
  801b96:	eb 58                	jmp    801bf0 <alloc_block+0x79>
  801b98:	83 f8 03             	cmp    $0x3,%eax
  801b9b:	74 2d                	je     801bca <alloc_block+0x53>
  801b9d:	83 f8 04             	cmp    $0x4,%eax
  801ba0:	74 3b                	je     801bdd <alloc_block+0x66>
  801ba2:	eb 4c                	jmp    801bf0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	e8 95 01 00 00       	call   801d44 <alloc_block_FF>
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bb5:	eb 4a                	jmp    801c01 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801bb7:	83 ec 0c             	sub    $0xc,%esp
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 32 07 00 00       	call   8022f4 <alloc_block_NF>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bc8:	eb 37                	jmp    801c01 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 a3 04 00 00       	call   802078 <alloc_block_BF>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bdb:	eb 24                	jmp    801c01 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	e8 ef 06 00 00       	call   8022d7 <alloc_block_WF>
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bee:	eb 11                	jmp    801c01 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801bf0:	83 ec 0c             	sub    $0xc,%esp
  801bf3:	68 64 36 80 00       	push   $0x803664
  801bf8:	e8 3d e7 ff ff       	call   80033a <cprintf>
  801bfd:	83 c4 10             	add    $0x10,%esp
		break;
  801c00:	90                   	nop
	}
	return va;
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801c0c:	83 ec 0c             	sub    $0xc,%esp
  801c0f:	68 84 36 80 00       	push   $0x803684
  801c14:	e8 21 e7 ff ff       	call   80033a <cprintf>
  801c19:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	68 af 36 80 00       	push   $0x8036af
  801c24:	e8 11 e7 ff ff       	call   80033a <cprintf>
  801c29:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c32:	eb 26                	jmp    801c5a <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c37:	8a 40 04             	mov    0x4(%eax),%al
  801c3a:	0f b6 d0             	movzbl %al,%edx
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	52                   	push   %edx
  801c46:	50                   	push   %eax
  801c47:	68 c7 36 80 00       	push   $0x8036c7
  801c4c:	e8 e9 e6 ff ff       	call   80033a <cprintf>
  801c51:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801c54:	8b 45 10             	mov    0x10(%ebp),%eax
  801c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c5e:	74 08                	je     801c68 <print_blocks_list+0x62>
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	8b 40 08             	mov    0x8(%eax),%eax
  801c66:	eb 05                	jmp    801c6d <print_blocks_list+0x67>
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	89 45 10             	mov    %eax,0x10(%ebp)
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	85 c0                	test   %eax,%eax
  801c75:	75 bd                	jne    801c34 <print_blocks_list+0x2e>
  801c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c7b:	75 b7                	jne    801c34 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	68 84 36 80 00       	push   $0x803684
  801c85:	e8 b0 e6 ff ff       	call   80033a <cprintf>
  801c8a:	83 c4 10             	add    $0x10,%esp

}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  801c96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c9a:	0f 84 a1 00 00 00    	je     801d41 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  801ca0:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  801ca7:	00 00 00 
	LIST_INIT(&list);
  801caa:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  801cb1:	00 00 00 
  801cb4:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  801cbb:	00 00 00 
  801cbe:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  801cc5:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  801cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd1:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  801cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce1:	75 14                	jne    801cf7 <initialize_dynamic_allocator+0x67>
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 e0 36 80 00       	push   $0x8036e0
  801ceb:	6a 64                	push   $0x64
  801ced:	68 03 37 80 00       	push   $0x803703
  801cf2:	e8 d5 0f 00 00       	call   802ccc <_panic>
  801cf7:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d00:	89 50 0c             	mov    %edx,0xc(%eax)
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	8b 40 0c             	mov    0xc(%eax),%eax
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	74 0d                	je     801d1a <initialize_dynamic_allocator+0x8a>
  801d0d:	a1 44 41 90 00       	mov    0x904144,%eax
  801d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d15:	89 50 08             	mov    %edx,0x8(%eax)
  801d18:	eb 08                	jmp    801d22 <initialize_dynamic_allocator+0x92>
  801d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1d:	a3 40 41 90 00       	mov    %eax,0x904140
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	a3 44 41 90 00       	mov    %eax,0x904144
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d34:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801d39:	40                   	inc    %eax
  801d3a:	a3 4c 41 90 00       	mov    %eax,0x90414c
  801d3f:	eb 01                	jmp    801d42 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  801d41:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  801d4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d4e:	75 0a                	jne    801d5a <alloc_block_FF+0x16>
	{
		return NULL;
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	e9 1c 03 00 00       	jmp    802076 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  801d5a:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	75 40                	jne    801da3 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	83 c0 10             	add    $0x10,%eax
  801d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	50                   	push   %eax
  801d73:	e8 d7 f3 ff ff       	call   80114f <sbrk>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  801d7e:	83 ec 0c             	sub    $0xc,%esp
  801d81:	6a 00                	push   $0x0
  801d83:	e8 c7 f3 ff ff       	call   80114f <sbrk>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  801d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d91:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	50                   	push   %eax
  801d98:	ff 75 ec             	pushl  -0x14(%ebp)
  801d9b:	e8 f0 fe ff ff       	call   801c90 <initialize_dynamic_allocator>
  801da0:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  801da3:	a1 40 41 90 00       	mov    0x904140,%eax
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dab:	e9 1e 01 00 00       	jmp    801ece <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8d 50 10             	lea    0x10(%eax),%edx
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	8b 00                	mov    (%eax),%eax
  801dbb:	39 c2                	cmp    %eax,%edx
  801dbd:	75 1c                	jne    801ddb <alloc_block_FF+0x97>
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	8a 40 04             	mov    0x4(%eax),%al
  801dc5:	3c 01                	cmp    $0x1,%al
  801dc7:	75 12                	jne    801ddb <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	83 c0 10             	add    $0x10,%eax
  801dd6:	e9 9b 02 00 00       	jmp    802076 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	8d 50 10             	lea    0x10(%eax),%edx
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 00                	mov    (%eax),%eax
  801de6:	39 c2                	cmp    %eax,%edx
  801de8:	0f 83 d8 00 00 00    	jae    801ec6 <alloc_block_FF+0x182>
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8a 40 04             	mov    0x4(%eax),%al
  801df4:	3c 01                	cmp    $0x1,%al
  801df6:	0f 85 ca 00 00 00    	jne    801ec6 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	8b 00                	mov    (%eax),%eax
  801e01:	2b 45 08             	sub    0x8(%ebp),%eax
  801e04:	83 e8 10             	sub    $0x10,%eax
  801e07:	83 f8 0f             	cmp    $0xf,%eax
  801e0a:	0f 86 a4 00 00 00    	jbe    801eb4 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  801e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	83 c0 10             	add    $0x10,%eax
  801e1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	2b 45 08             	sub    0x8(%ebp),%eax
  801e26:	8d 50 f0             	lea    -0x10(%eax),%edx
  801e29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e2c:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  801e2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e31:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  801e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e39:	74 06                	je     801e41 <alloc_block_FF+0xfd>
  801e3b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801e3f:	75 17                	jne    801e58 <alloc_block_FF+0x114>
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	68 1c 37 80 00       	push   $0x80371c
  801e49:	68 8f 00 00 00       	push   $0x8f
  801e4e:	68 03 37 80 00       	push   $0x803703
  801e53:	e8 74 0e 00 00       	call   802ccc <_panic>
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	8b 50 08             	mov    0x8(%eax),%edx
  801e5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e61:	89 50 08             	mov    %edx,0x8(%eax)
  801e64:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e67:	8b 40 08             	mov    0x8(%eax),%eax
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	74 0c                	je     801e7a <alloc_block_FF+0x136>
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	8b 40 08             	mov    0x8(%eax),%eax
  801e74:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e77:	89 50 0c             	mov    %edx,0xc(%eax)
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e80:	89 50 08             	mov    %edx,0x8(%eax)
  801e83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e89:	89 50 0c             	mov    %edx,0xc(%eax)
  801e8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e8f:	8b 40 08             	mov    0x8(%eax),%eax
  801e92:	85 c0                	test   %eax,%eax
  801e94:	75 08                	jne    801e9e <alloc_block_FF+0x15a>
  801e96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e99:	a3 44 41 90 00       	mov    %eax,0x904144
  801e9e:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801ea3:	40                   	inc    %eax
  801ea4:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8d 50 10             	lea    0x10(%eax),%edx
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	83 c0 10             	add    $0x10,%eax
  801ec1:	e9 b0 01 00 00       	jmp    802076 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  801ec6:	a1 48 41 90 00       	mov    0x904148,%eax
  801ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed2:	74 08                	je     801edc <alloc_block_FF+0x198>
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 40 08             	mov    0x8(%eax),%eax
  801eda:	eb 05                	jmp    801ee1 <alloc_block_FF+0x19d>
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	a3 48 41 90 00       	mov    %eax,0x904148
  801ee6:	a1 48 41 90 00       	mov    0x904148,%eax
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	0f 85 bd fe ff ff    	jne    801db0 <alloc_block_FF+0x6c>
  801ef3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef7:	0f 85 b3 fe ff ff    	jne    801db0 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	83 c0 10             	add    $0x10,%eax
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	50                   	push   %eax
  801f07:	e8 43 f2 ff ff       	call   80114f <sbrk>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	6a 00                	push   $0x0
  801f17:	e8 33 f2 ff ff       	call   80114f <sbrk>
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  801f22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f28:	29 c2                	sub    %eax,%edx
  801f2a:	89 d0                	mov    %edx,%eax
  801f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  801f2f:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801f33:	0f 84 38 01 00 00    	je     802071 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  801f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  801f3f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f43:	75 17                	jne    801f5c <alloc_block_FF+0x218>
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	68 e0 36 80 00       	push   $0x8036e0
  801f4d:	68 9f 00 00 00       	push   $0x9f
  801f52:	68 03 37 80 00       	push   $0x803703
  801f57:	e8 70 0d 00 00       	call   802ccc <_panic>
  801f5c:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801f62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f65:	89 50 0c             	mov    %edx,0xc(%eax)
  801f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	74 0d                	je     801f7f <alloc_block_FF+0x23b>
  801f72:	a1 44 41 90 00       	mov    0x904144,%eax
  801f77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f7a:	89 50 08             	mov    %edx,0x8(%eax)
  801f7d:	eb 08                	jmp    801f87 <alloc_block_FF+0x243>
  801f7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f82:	a3 40 41 90 00       	mov    %eax,0x904140
  801f87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f8a:	a3 44 41 90 00       	mov    %eax,0x904144
  801f8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f99:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801f9e:	40                   	inc    %eax
  801f9f:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	8d 50 10             	lea    0x10(%eax),%edx
  801faa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fad:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  801faf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fb2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  801fb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fb9:	2b 45 08             	sub    0x8(%ebp),%eax
  801fbc:	83 f8 10             	cmp    $0x10,%eax
  801fbf:	0f 84 a4 00 00 00    	je     802069 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  801fc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fc8:	2b 45 08             	sub    0x8(%ebp),%eax
  801fcb:	83 e8 10             	sub    $0x10,%eax
  801fce:	83 f8 0f             	cmp    $0xf,%eax
  801fd1:	0f 86 8a 00 00 00    	jbe    802061 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  801fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	01 d0                	add    %edx,%eax
  801fdf:	83 c0 10             	add    $0x10,%eax
  801fe2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  801fe5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801fe9:	75 17                	jne    802002 <alloc_block_FF+0x2be>
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 e0 36 80 00       	push   $0x8036e0
  801ff3:	68 a7 00 00 00       	push   $0xa7
  801ff8:	68 03 37 80 00       	push   $0x803703
  801ffd:	e8 ca 0c 00 00       	call   802ccc <_panic>
  802002:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802008:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80200b:	89 50 0c             	mov    %edx,0xc(%eax)
  80200e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802011:	8b 40 0c             	mov    0xc(%eax),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	74 0d                	je     802025 <alloc_block_FF+0x2e1>
  802018:	a1 44 41 90 00       	mov    0x904144,%eax
  80201d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802020:	89 50 08             	mov    %edx,0x8(%eax)
  802023:	eb 08                	jmp    80202d <alloc_block_FF+0x2e9>
  802025:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802028:	a3 40 41 90 00       	mov    %eax,0x904140
  80202d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802030:	a3 44 41 90 00       	mov    %eax,0x904144
  802035:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802038:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80203f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802044:	40                   	inc    %eax
  802045:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  80204a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80204d:	2b 45 08             	sub    0x8(%ebp),%eax
  802050:	8d 50 f0             	lea    -0x10(%eax),%edx
  802053:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802056:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80205b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80205f:	eb 08                	jmp    802069 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802061:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802064:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802067:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802069:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80206c:	83 c0 10             	add    $0x10,%eax
  80206f:	eb 05                	jmp    802076 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  80207e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802089:	75 0a                	jne    802095 <alloc_block_BF+0x1d>
	{
		return NULL;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	e9 40 02 00 00       	jmp    8022d5 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802095:	a1 40 41 90 00       	mov    0x904140,%eax
  80209a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209d:	eb 66                	jmp    802105 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8a 40 04             	mov    0x4(%eax),%al
  8020a5:	3c 01                	cmp    $0x1,%al
  8020a7:	75 21                	jne    8020ca <alloc_block_BF+0x52>
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8d 50 10             	lea    0x10(%eax),%edx
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 00                	mov    (%eax),%eax
  8020b4:	39 c2                	cmp    %eax,%edx
  8020b6:	75 12                	jne    8020ca <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	83 c0 10             	add    $0x10,%eax
  8020c5:	e9 0b 02 00 00       	jmp    8022d5 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8a 40 04             	mov    0x4(%eax),%al
  8020d0:	3c 01                	cmp    $0x1,%al
  8020d2:	75 29                	jne    8020fd <alloc_block_BF+0x85>
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8d 50 10             	lea    0x10(%eax),%edx
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	39 c2                	cmp    %eax,%edx
  8020e1:	77 1a                	ja     8020fd <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8020e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e7:	74 0e                	je     8020f7 <alloc_block_BF+0x7f>
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 10                	mov    (%eax),%edx
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	39 c2                	cmp    %eax,%edx
  8020f5:	73 06                	jae    8020fd <alloc_block_BF+0x85>
			{
				BF = iterator;
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  8020fd:	a1 48 41 90 00       	mov    0x904148,%eax
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802109:	74 08                	je     802113 <alloc_block_BF+0x9b>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 40 08             	mov    0x8(%eax),%eax
  802111:	eb 05                	jmp    802118 <alloc_block_BF+0xa0>
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	a3 48 41 90 00       	mov    %eax,0x904148
  80211d:	a1 48 41 90 00       	mov    0x904148,%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	0f 85 75 ff ff ff    	jne    80209f <alloc_block_BF+0x27>
  80212a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212e:	0f 85 6b ff ff ff    	jne    80209f <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802138:	0f 84 f8 00 00 00    	je     802236 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8d 50 10             	lea    0x10(%eax),%edx
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	39 c2                	cmp    %eax,%edx
  80214b:	0f 87 e5 00 00 00    	ja     802236 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	2b 45 08             	sub    0x8(%ebp),%eax
  802159:	83 e8 10             	sub    $0x10,%eax
  80215c:	83 f8 0f             	cmp    $0xf,%eax
  80215f:	0f 86 bf 00 00 00    	jbe    802224 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802165:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	01 d0                	add    %edx,%eax
  80216d:	83 c0 10             	add    $0x10,%eax
  802170:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	2b 45 08             	sub    0x8(%ebp),%eax
  802184:	8d 50 f0             	lea    -0x10(%eax),%edx
  802187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218a:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802197:	74 06                	je     80219f <alloc_block_BF+0x127>
  802199:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219d:	75 17                	jne    8021b6 <alloc_block_BF+0x13e>
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 1c 37 80 00       	push   $0x80371c
  8021a7:	68 e3 00 00 00       	push   $0xe3
  8021ac:	68 03 37 80 00       	push   $0x803703
  8021b1:	e8 16 0b 00 00       	call   802ccc <_panic>
  8021b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b9:	8b 50 08             	mov    0x8(%eax),%edx
  8021bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bf:	89 50 08             	mov    %edx,0x8(%eax)
  8021c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c5:	8b 40 08             	mov    0x8(%eax),%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	74 0c                	je     8021d8 <alloc_block_BF+0x160>
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 40 08             	mov    0x8(%eax),%eax
  8021d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021d5:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021de:	89 50 08             	mov    %edx,0x8(%eax)
  8021e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e7:	89 50 0c             	mov    %edx,0xc(%eax)
  8021ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ed:	8b 40 08             	mov    0x8(%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	75 08                	jne    8021fc <alloc_block_BF+0x184>
  8021f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f7:	a3 44 41 90 00       	mov    %eax,0x904144
  8021fc:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802201:	40                   	inc    %eax
  802202:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	8d 50 10             	lea    0x10(%eax),%edx
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802210:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221c:	83 c0 10             	add    $0x10,%eax
  80221f:	e9 b1 00 00 00       	jmp    8022d5 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	83 c0 10             	add    $0x10,%eax
  802231:	e9 9f 00 00 00       	jmp    8022d5 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	83 c0 10             	add    $0x10,%eax
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	50                   	push   %eax
  802240:	e8 0a ef ff ff       	call   80114f <sbrk>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  80224b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80224f:	74 7f                	je     8022d0 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802251:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802255:	75 17                	jne    80226e <alloc_block_BF+0x1f6>
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	68 e0 36 80 00       	push   $0x8036e0
  80225f:	68 f6 00 00 00       	push   $0xf6
  802264:	68 03 37 80 00       	push   $0x803703
  802269:	e8 5e 0a 00 00       	call   802ccc <_panic>
  80226e:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802277:	89 50 0c             	mov    %edx,0xc(%eax)
  80227a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227d:	8b 40 0c             	mov    0xc(%eax),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	74 0d                	je     802291 <alloc_block_BF+0x219>
  802284:	a1 44 41 90 00       	mov    0x904144,%eax
  802289:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80228c:	89 50 08             	mov    %edx,0x8(%eax)
  80228f:	eb 08                	jmp    802299 <alloc_block_BF+0x221>
  802291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802294:	a3 40 41 90 00       	mov    %eax,0x904140
  802299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229c:	a3 44 41 90 00       	mov    %eax,0x904144
  8022a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022ab:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8022b0:	40                   	inc    %eax
  8022b1:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8d 50 10             	lea    0x10(%eax),%edx
  8022bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022bf:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8022c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8022c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022cb:	83 c0 10             	add    $0x10,%eax
  8022ce:	eb 05                	jmp    8022d5 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	68 50 37 80 00       	push   $0x803750
  8022e5:	68 07 01 00 00       	push   $0x107
  8022ea:	68 03 37 80 00       	push   $0x803703
  8022ef:	e8 d8 09 00 00       	call   802ccc <_panic>

008022f4 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	68 78 37 80 00       	push   $0x803778
  802302:	68 0f 01 00 00       	push   $0x10f
  802307:	68 03 37 80 00       	push   $0x803703
  80230c:	e8 bb 09 00 00       	call   802ccc <_panic>

00802311 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802317:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231b:	0f 84 ee 05 00 00    	je     80290f <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	83 e8 10             	sub    $0x10,%eax
  802327:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  80232a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80232e:	a1 40 41 90 00       	mov    0x904140,%eax
  802333:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802336:	eb 16                	jmp    80234e <free_block+0x3d>
	{
		if (block_pointer == it)
  802338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80233e:	75 06                	jne    802346 <free_block+0x35>
		{
			flagx = 1;
  802340:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802344:	eb 2f                	jmp    802375 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802346:	a1 48 41 90 00       	mov    0x904148,%eax
  80234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80234e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802352:	74 08                	je     80235c <free_block+0x4b>
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	eb 05                	jmp    802361 <free_block+0x50>
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	a3 48 41 90 00       	mov    %eax,0x904148
  802366:	a1 48 41 90 00       	mov    0x904148,%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	75 c9                	jne    802338 <free_block+0x27>
  80236f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802373:	75 c3                	jne    802338 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802375:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802379:	0f 84 93 05 00 00    	je     802912 <free_block+0x601>
		return;
	if (va == NULL)
  80237f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802383:	0f 84 8c 05 00 00    	je     802915 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238c:	8b 40 0c             	mov    0xc(%eax),%eax
  80238f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	8b 40 08             	mov    0x8(%eax),%eax
  802398:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  80239b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80239f:	75 12                	jne    8023b3 <free_block+0xa2>
  8023a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023a5:	75 0c                	jne    8023b3 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8023a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023aa:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8023ae:	e9 63 05 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8023b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023b7:	0f 85 ca 00 00 00    	jne    802487 <free_block+0x176>
  8023bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c0:	8a 40 04             	mov    0x4(%eax),%al
  8023c3:	3c 01                	cmp    $0x1,%al
  8023c5:	0f 85 bc 00 00 00    	jne    802487 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8023cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ce:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8023d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d5:	8b 10                	mov    (%eax),%edx
  8023d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	01 c2                	add    %eax,%edx
  8023de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e1:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8023e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8023ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ef:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8023f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023f7:	75 17                	jne    802410 <free_block+0xff>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 9e 37 80 00       	push   $0x80379e
  802401:	68 3c 01 00 00       	push   $0x13c
  802406:	68 03 37 80 00       	push   $0x803703
  80240b:	e8 bc 08 00 00       	call   802ccc <_panic>
  802410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802413:	8b 40 08             	mov    0x8(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 11                	je     80242b <free_block+0x11a>
  80241a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241d:	8b 40 08             	mov    0x8(%eax),%eax
  802420:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802423:	8b 52 0c             	mov    0xc(%edx),%edx
  802426:	89 50 0c             	mov    %edx,0xc(%eax)
  802429:	eb 0b                	jmp    802436 <free_block+0x125>
  80242b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242e:	8b 40 0c             	mov    0xc(%eax),%eax
  802431:	a3 44 41 90 00       	mov    %eax,0x904144
  802436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802439:	8b 40 0c             	mov    0xc(%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 11                	je     802451 <free_block+0x140>
  802440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802449:	8b 52 08             	mov    0x8(%edx),%edx
  80244c:	89 50 08             	mov    %edx,0x8(%eax)
  80244f:	eb 0b                	jmp    80245c <free_block+0x14b>
  802451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802454:	8b 40 08             	mov    0x8(%eax),%eax
  802457:	a3 40 41 90 00       	mov    %eax,0x904140
  80245c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802469:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802470:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802475:	48                   	dec    %eax
  802476:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  80247b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802482:	e9 8f 04 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802487:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80248b:	75 16                	jne    8024a3 <free_block+0x192>
  80248d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802490:	8a 40 04             	mov    0x4(%eax),%al
  802493:	84 c0                	test   %al,%al
  802495:	75 0c                	jne    8024a3 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80249e:	e9 73 04 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8024a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024a7:	0f 85 c3 00 00 00    	jne    802570 <free_block+0x25f>
  8024ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b0:	8a 40 04             	mov    0x4(%eax),%al
  8024b3:	3c 01                	cmp    $0x1,%al
  8024b5:	0f 85 b5 00 00 00    	jne    802570 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8024bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024be:	8b 10                	mov    (%eax),%edx
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	01 c2                	add    %eax,%edx
  8024c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ca:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8024cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8024dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e0:	75 17                	jne    8024f9 <free_block+0x1e8>
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 9e 37 80 00       	push   $0x80379e
  8024ea:	68 49 01 00 00       	push   $0x149
  8024ef:	68 03 37 80 00       	push   $0x803703
  8024f4:	e8 d3 07 00 00       	call   802ccc <_panic>
  8024f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fc:	8b 40 08             	mov    0x8(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 11                	je     802514 <free_block+0x203>
  802503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802506:	8b 40 08             	mov    0x8(%eax),%eax
  802509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80250c:	8b 52 0c             	mov    0xc(%edx),%edx
  80250f:	89 50 0c             	mov    %edx,0xc(%eax)
  802512:	eb 0b                	jmp    80251f <free_block+0x20e>
  802514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802517:	8b 40 0c             	mov    0xc(%eax),%eax
  80251a:	a3 44 41 90 00       	mov    %eax,0x904144
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	8b 40 0c             	mov    0xc(%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 11                	je     80253a <free_block+0x229>
  802529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252c:	8b 40 0c             	mov    0xc(%eax),%eax
  80252f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802532:	8b 52 08             	mov    0x8(%edx),%edx
  802535:	89 50 08             	mov    %edx,0x8(%eax)
  802538:	eb 0b                	jmp    802545 <free_block+0x234>
  80253a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253d:	8b 40 08             	mov    0x8(%eax),%eax
  802540:	a3 40 41 90 00       	mov    %eax,0x904140
  802545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802548:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802559:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80255e:	48                   	dec    %eax
  80255f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80256b:	e9 a6 03 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802570:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802574:	75 16                	jne    80258c <free_block+0x27b>
  802576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802579:	8a 40 04             	mov    0x4(%eax),%al
  80257c:	84 c0                	test   %al,%al
  80257e:	75 0c                	jne    80258c <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802583:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802587:	e9 8a 03 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  80258c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802590:	0f 84 81 01 00 00    	je     802717 <free_block+0x406>
  802596:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259a:	0f 84 77 01 00 00    	je     802717 <free_block+0x406>
  8025a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a3:	8a 40 04             	mov    0x4(%eax),%al
  8025a6:	3c 01                	cmp    $0x1,%al
  8025a8:	0f 85 69 01 00 00    	jne    802717 <free_block+0x406>
  8025ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b1:	8a 40 04             	mov    0x4(%eax),%al
  8025b4:	3c 01                	cmp    $0x1,%al
  8025b6:	0f 85 5b 01 00 00    	jne    802717 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8025bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025bf:	8b 10                	mov    (%eax),%edx
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	8b 08                	mov    (%eax),%ecx
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	01 c8                	add    %ecx,%eax
  8025cd:	01 c2                	add    %eax,%edx
  8025cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d2:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8025d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8025dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8025f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f8:	75 17                	jne    802611 <free_block+0x300>
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 9e 37 80 00       	push   $0x80379e
  802602:	68 59 01 00 00       	push   $0x159
  802607:	68 03 37 80 00       	push   $0x803703
  80260c:	e8 bb 06 00 00       	call   802ccc <_panic>
  802611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802614:	8b 40 08             	mov    0x8(%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 11                	je     80262c <free_block+0x31b>
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 40 08             	mov    0x8(%eax),%eax
  802621:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802624:	8b 52 0c             	mov    0xc(%edx),%edx
  802627:	89 50 0c             	mov    %edx,0xc(%eax)
  80262a:	eb 0b                	jmp    802637 <free_block+0x326>
  80262c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	a3 44 41 90 00       	mov    %eax,0x904144
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	8b 40 0c             	mov    0xc(%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 11                	je     802652 <free_block+0x341>
  802641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264a:	8b 52 08             	mov    0x8(%edx),%edx
  80264d:	89 50 08             	mov    %edx,0x8(%eax)
  802650:	eb 0b                	jmp    80265d <free_block+0x34c>
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	8b 40 08             	mov    0x8(%eax),%eax
  802658:	a3 40 41 90 00       	mov    %eax,0x904140
  80265d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802660:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802671:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802676:	48                   	dec    %eax
  802677:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  80267c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802680:	75 17                	jne    802699 <free_block+0x388>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 9e 37 80 00       	push   $0x80379e
  80268a:	68 5a 01 00 00       	push   $0x15a
  80268f:	68 03 37 80 00       	push   $0x803703
  802694:	e8 33 06 00 00       	call   802ccc <_panic>
  802699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269c:	8b 40 08             	mov    0x8(%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 11                	je     8026b4 <free_block+0x3a3>
  8026a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8026af:	89 50 0c             	mov    %edx,0xc(%eax)
  8026b2:	eb 0b                	jmp    8026bf <free_block+0x3ae>
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ba:	a3 44 41 90 00       	mov    %eax,0x904144
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 11                	je     8026da <free_block+0x3c9>
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d2:	8b 52 08             	mov    0x8(%edx),%edx
  8026d5:	89 50 08             	mov    %edx,0x8(%eax)
  8026d8:	eb 0b                	jmp    8026e5 <free_block+0x3d4>
  8026da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dd:	8b 40 08             	mov    0x8(%eax),%eax
  8026e0:	a3 40 41 90 00       	mov    %eax,0x904140
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026f9:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802704:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  80270b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802712:	e9 ff 01 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80271b:	0f 84 db 00 00 00    	je     8027fc <free_block+0x4eb>
  802721:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802725:	0f 84 d1 00 00 00    	je     8027fc <free_block+0x4eb>
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	8a 40 04             	mov    0x4(%eax),%al
  802731:	84 c0                	test   %al,%al
  802733:	0f 85 c3 00 00 00    	jne    8027fc <free_block+0x4eb>
  802739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273c:	8a 40 04             	mov    0x4(%eax),%al
  80273f:	3c 01                	cmp    $0x1,%al
  802741:	0f 85 b5 00 00 00    	jne    8027fc <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274a:	8b 10                	mov    (%eax),%edx
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	01 c2                	add    %eax,%edx
  802753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802756:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802764:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802768:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80276c:	75 17                	jne    802785 <free_block+0x474>
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	68 9e 37 80 00       	push   $0x80379e
  802776:	68 64 01 00 00       	push   $0x164
  80277b:	68 03 37 80 00       	push   $0x803703
  802780:	e8 47 05 00 00       	call   802ccc <_panic>
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 40 08             	mov    0x8(%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	74 11                	je     8027a0 <free_block+0x48f>
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	8b 40 08             	mov    0x8(%eax),%eax
  802795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802798:	8b 52 0c             	mov    0xc(%edx),%edx
  80279b:	89 50 0c             	mov    %edx,0xc(%eax)
  80279e:	eb 0b                	jmp    8027ab <free_block+0x49a>
  8027a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a6:	a3 44 41 90 00       	mov    %eax,0x904144
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 11                	je     8027c6 <free_block+0x4b5>
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027be:	8b 52 08             	mov    0x8(%edx),%edx
  8027c1:	89 50 08             	mov    %edx,0x8(%eax)
  8027c4:	eb 0b                	jmp    8027d1 <free_block+0x4c0>
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	a3 40 41 90 00       	mov    %eax,0x904140
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027e5:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  8027f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8027f7:	e9 1a 01 00 00       	jmp    802916 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  8027fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802800:	0f 84 df 00 00 00    	je     8028e5 <free_block+0x5d4>
  802806:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80280a:	0f 84 d5 00 00 00    	je     8028e5 <free_block+0x5d4>
  802810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802813:	8a 40 04             	mov    0x4(%eax),%al
  802816:	3c 01                	cmp    $0x1,%al
  802818:	0f 85 c7 00 00 00    	jne    8028e5 <free_block+0x5d4>
  80281e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802821:	8a 40 04             	mov    0x4(%eax),%al
  802824:	84 c0                	test   %al,%al
  802826:	0f 85 b9 00 00 00    	jne    8028e5 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  80282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	8b 10                	mov    (%eax),%edx
  802838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	01 c2                	add    %eax,%edx
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80284d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802850:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802854:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802858:	75 17                	jne    802871 <free_block+0x560>
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 9e 37 80 00       	push   $0x80379e
  802862:	68 6e 01 00 00       	push   $0x16e
  802867:	68 03 37 80 00       	push   $0x803703
  80286c:	e8 5b 04 00 00       	call   802ccc <_panic>
  802871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802874:	8b 40 08             	mov    0x8(%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 11                	je     80288c <free_block+0x57b>
  80287b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287e:	8b 40 08             	mov    0x8(%eax),%eax
  802881:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802884:	8b 52 0c             	mov    0xc(%edx),%edx
  802887:	89 50 0c             	mov    %edx,0xc(%eax)
  80288a:	eb 0b                	jmp    802897 <free_block+0x586>
  80288c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	a3 44 41 90 00       	mov    %eax,0x904144
  802897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 11                	je     8028b2 <free_block+0x5a1>
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028aa:	8b 52 08             	mov    0x8(%edx),%edx
  8028ad:	89 50 08             	mov    %edx,0x8(%eax)
  8028b0:	eb 0b                	jmp    8028bd <free_block+0x5ac>
  8028b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b5:	8b 40 08             	mov    0x8(%eax),%eax
  8028b8:	a3 40 41 90 00       	mov    %eax,0x904140
  8028bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028d1:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028d6:	48                   	dec    %eax
  8028d7:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  8028dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8028e3:	eb 31                	jmp    802916 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  8028e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028e9:	74 2b                	je     802916 <free_block+0x605>
  8028eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ef:	74 25                	je     802916 <free_block+0x605>
  8028f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f4:	8a 40 04             	mov    0x4(%eax),%al
  8028f7:	84 c0                	test   %al,%al
  8028f9:	75 1b                	jne    802916 <free_block+0x605>
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	8a 40 04             	mov    0x4(%eax),%al
  802901:	84 c0                	test   %al,%al
  802903:	75 11                	jne    802916 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802908:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80290c:	90                   	nop
  80290d:	eb 07                	jmp    802916 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  80290f:	90                   	nop
  802910:	eb 04                	jmp    802916 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802912:	90                   	nop
  802913:	eb 01                	jmp    802916 <free_block+0x605>
	if (va == NULL)
		return;
  802915:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802916:	c9                   	leave  
  802917:	c3                   	ret    

00802918 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	57                   	push   %edi
  80291c:	56                   	push   %esi
  80291d:	53                   	push   %ebx
  80291e:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802921:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802925:	75 19                	jne    802940 <realloc_block_FF+0x28>
  802927:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80292b:	74 13                	je     802940 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  80292d:	83 ec 0c             	sub    $0xc,%esp
  802930:	ff 75 0c             	pushl  0xc(%ebp)
  802933:	e8 0c f4 ff ff       	call   801d44 <alloc_block_FF>
  802938:	83 c4 10             	add    $0x10,%esp
  80293b:	e9 84 03 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  802940:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802944:	75 3b                	jne    802981 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802946:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294a:	75 17                	jne    802963 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  80294c:	83 ec 0c             	sub    $0xc,%esp
  80294f:	6a 00                	push   $0x0
  802951:	e8 ee f3 ff ff       	call   801d44 <alloc_block_FF>
  802956:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	e9 61 03 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  802963:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802967:	74 18                	je     802981 <realloc_block_FF+0x69>
		{
			free_block(va);
  802969:	83 ec 0c             	sub    $0xc,%esp
  80296c:	ff 75 08             	pushl  0x8(%ebp)
  80296f:	e8 9d f9 ff ff       	call   802311 <free_block>
  802974:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	e9 43 03 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  802981:	a1 40 41 90 00       	mov    0x904140,%eax
  802986:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802989:	e9 02 03 00 00       	jmp    802c90 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	83 e8 10             	sub    $0x10,%eax
  802994:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802997:	0f 85 eb 02 00 00    	jne    802c88 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  80299d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a5:	83 c2 10             	add    $0x10,%edx
  8029a8:	39 d0                	cmp    %edx,%eax
  8029aa:	75 08                	jne    8029b4 <realloc_block_FF+0x9c>
			{
				return va;
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	e9 10 03 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  8029b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029bc:	0f 83 e0 01 00 00    	jae    802ba2 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8029c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c5:	8b 40 08             	mov    0x8(%eax),%eax
  8029c8:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  8029cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ce:	8a 40 04             	mov    0x4(%eax),%al
  8029d1:	3c 01                	cmp    $0x1,%al
  8029d3:	0f 85 06 01 00 00    	jne    802adf <realloc_block_FF+0x1c7>
  8029d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029dc:	8b 10                	mov    (%eax),%edx
  8029de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e1:	8b 00                	mov    (%eax),%eax
  8029e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029e6:	29 c1                	sub    %eax,%ecx
  8029e8:	89 c8                	mov    %ecx,%eax
  8029ea:	39 c2                	cmp    %eax,%edx
  8029ec:	0f 86 ed 00 00 00    	jbe    802adf <realloc_block_FF+0x1c7>
  8029f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029f6:	0f 84 e3 00 00 00    	je     802adf <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  8029fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ff:	8b 10                	mov    (%eax),%edx
  802a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	2b 45 0c             	sub    0xc(%ebp),%eax
  802a09:	01 d0                	add    %edx,%eax
  802a0b:	83 f8 0f             	cmp    $0xf,%eax
  802a0e:	0f 86 b5 00 00 00    	jbe    802ac9 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  802a14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a1a:	01 d0                	add    %edx,%eax
  802a1c:	83 c0 10             	add    $0x10,%eax
  802a1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  802a22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  802a2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a2e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802a32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a36:	74 06                	je     802a3e <realloc_block_FF+0x126>
  802a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a3c:	75 17                	jne    802a55 <realloc_block_FF+0x13d>
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	68 1c 37 80 00       	push   $0x80371c
  802a46:	68 ad 01 00 00       	push   $0x1ad
  802a4b:	68 03 37 80 00       	push   $0x803703
  802a50:	e8 77 02 00 00       	call   802ccc <_panic>
  802a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a58:	8b 50 08             	mov    0x8(%eax),%edx
  802a5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a5e:	89 50 08             	mov    %edx,0x8(%eax)
  802a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a64:	8b 40 08             	mov    0x8(%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0c                	je     802a77 <realloc_block_FF+0x15f>
  802a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6e:	8b 40 08             	mov    0x8(%eax),%eax
  802a71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a74:	89 50 0c             	mov    %edx,0xc(%eax)
  802a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a7d:	89 50 08             	mov    %edx,0x8(%eax)
  802a80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a86:	89 50 0c             	mov    %edx,0xc(%eax)
  802a89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	75 08                	jne    802a9b <realloc_block_FF+0x183>
  802a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a96:	a3 44 41 90 00       	mov    %eax,0x904144
  802a9b:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802aa0:	40                   	inc    %eax
  802aa1:	a3 4c 41 90 00       	mov    %eax,0x90414c
						next->size = 0;
  802aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  802aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  802ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab9:	8d 50 10             	lea    0x10(%eax),%edx
  802abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abf:	89 10                	mov    %edx,(%eax)
						return va;
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	e9 fb 01 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  802ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802acc:	8d 50 10             	lea    0x10(%eax),%edx
  802acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad2:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  802ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad7:	83 c0 10             	add    $0x10,%eax
  802ada:	e9 e5 01 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae2:	8a 40 04             	mov    0x4(%eax),%al
  802ae5:	3c 01                	cmp    $0x1,%al
  802ae7:	75 59                	jne    802b42 <realloc_block_FF+0x22a>
  802ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aec:	8b 10                	mov    (%eax),%edx
  802aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802af6:	29 c1                	sub    %eax,%ecx
  802af8:	89 c8                	mov    %ecx,%eax
  802afa:	39 c2                	cmp    %eax,%edx
  802afc:	75 44                	jne    802b42 <realloc_block_FF+0x22a>
  802afe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b02:	74 3e                	je     802b42 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b07:	8b 40 08             	mov    0x8(%eax),%eax
  802b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b13:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b1c:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b32:	8d 50 10             	lea    0x10(%eax),%edx
  802b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b38:	89 10                	mov    %edx,(%eax)
					return va;
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	e9 82 01 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b45:	8a 40 04             	mov    0x4(%eax),%al
  802b48:	84 c0                	test   %al,%al
  802b4a:	74 0a                	je     802b56 <realloc_block_FF+0x23e>
  802b4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b50:	0f 85 32 01 00 00    	jne    802c88 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802b56:	83 ec 0c             	sub    $0xc,%esp
  802b59:	ff 75 0c             	pushl  0xc(%ebp)
  802b5c:	e8 e3 f1 ff ff       	call   801d44 <alloc_block_FF>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  802b67:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b6b:	74 2b                	je     802b98 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  802b6d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	89 c3                	mov    %eax,%ebx
  802b75:	b8 04 00 00 00       	mov    $0x4,%eax
  802b7a:	89 d7                	mov    %edx,%edi
  802b7c:	89 de                	mov    %ebx,%esi
  802b7e:	89 c1                	mov    %eax,%ecx
  802b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  802b82:	83 ec 0c             	sub    $0xc,%esp
  802b85:	ff 75 08             	pushl  0x8(%ebp)
  802b88:	e8 84 f7 ff ff       	call   802311 <free_block>
  802b8d:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b93:	e9 2c 01 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  802b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802b9d:	e9 22 01 00 00       	jmp    802cc4 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802baa:	0f 86 d8 00 00 00    	jbe    802c88 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	2b 45 0c             	sub    0xc(%ebp),%eax
  802bb8:	83 f8 0f             	cmp    $0xf,%eax
  802bbb:	0f 86 b4 00 00 00    	jbe    802c75 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802bc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	83 c0 10             	add    $0x10,%eax
  802bcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	2b 45 0c             	sub    0xc(%ebp),%eax
  802bd7:	8d 50 f0             	lea    -0x10(%eax),%edx
  802bda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bdd:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802be3:	74 06                	je     802beb <realloc_block_FF+0x2d3>
  802be5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802be9:	75 17                	jne    802c02 <realloc_block_FF+0x2ea>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 1c 37 80 00       	push   $0x80371c
  802bf3:	68 dd 01 00 00       	push   $0x1dd
  802bf8:	68 03 37 80 00       	push   $0x803703
  802bfd:	e8 ca 00 00 00       	call   802ccc <_panic>
  802c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c05:	8b 50 08             	mov    0x8(%eax),%edx
  802c08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c0b:	89 50 08             	mov    %edx,0x8(%eax)
  802c0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 0c                	je     802c24 <realloc_block_FF+0x30c>
  802c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1b:	8b 40 08             	mov    0x8(%eax),%eax
  802c1e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c21:	89 50 0c             	mov    %edx,0xc(%eax)
  802c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c27:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c2a:	89 50 08             	mov    %edx,0x8(%eax)
  802c2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c33:	89 50 0c             	mov    %edx,0xc(%eax)
  802c36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	75 08                	jne    802c48 <realloc_block_FF+0x330>
  802c40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c43:	a3 44 41 90 00       	mov    %eax,0x904144
  802c48:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c4d:	40                   	inc    %eax
  802c4e:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  802c53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c56:	83 c0 10             	add    $0x10,%eax
  802c59:	83 ec 0c             	sub    $0xc,%esp
  802c5c:	50                   	push   %eax
  802c5d:	e8 af f6 ff ff       	call   802311 <free_block>
  802c62:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  802c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c68:	8d 50 10             	lea    0x10(%eax),%edx
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	89 10                	mov    %edx,(%eax)
					return va;
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	eb 4f                	jmp    802cc4 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  802c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c78:	8d 50 10             	lea    0x10(%eax),%edx
  802c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7e:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  802c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c83:	83 c0 10             	add    $0x10,%eax
  802c86:	eb 3c                	jmp    802cc4 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  802c88:	a1 48 41 90 00       	mov    0x904148,%eax
  802c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c94:	74 08                	je     802c9e <realloc_block_FF+0x386>
  802c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c99:	8b 40 08             	mov    0x8(%eax),%eax
  802c9c:	eb 05                	jmp    802ca3 <realloc_block_FF+0x38b>
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	a3 48 41 90 00       	mov    %eax,0x904148
  802ca8:	a1 48 41 90 00       	mov    0x904148,%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	0f 85 d9 fc ff ff    	jne    80298e <realloc_block_FF+0x76>
  802cb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cb9:	0f 85 cf fc ff ff    	jne    80298e <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cc7:	5b                   	pop    %ebx
  802cc8:	5e                   	pop    %esi
  802cc9:	5f                   	pop    %edi
  802cca:	5d                   	pop    %ebp
  802ccb:	c3                   	ret    

00802ccc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802ccc:	55                   	push   %ebp
  802ccd:	89 e5                	mov    %esp,%ebp
  802ccf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802cd2:	8d 45 10             	lea    0x10(%ebp),%eax
  802cd5:	83 c0 04             	add    $0x4,%eax
  802cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802cdb:	a1 50 41 90 00       	mov    0x904150,%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 16                	je     802cfa <_panic+0x2e>
		cprintf("%s: ", argv0);
  802ce4:	a1 50 41 90 00       	mov    0x904150,%eax
  802ce9:	83 ec 08             	sub    $0x8,%esp
  802cec:	50                   	push   %eax
  802ced:	68 bc 37 80 00       	push   $0x8037bc
  802cf2:	e8 43 d6 ff ff       	call   80033a <cprintf>
  802cf7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802cfa:	a1 00 40 80 00       	mov    0x804000,%eax
  802cff:	ff 75 0c             	pushl  0xc(%ebp)
  802d02:	ff 75 08             	pushl  0x8(%ebp)
  802d05:	50                   	push   %eax
  802d06:	68 c1 37 80 00       	push   $0x8037c1
  802d0b:	e8 2a d6 ff ff       	call   80033a <cprintf>
  802d10:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802d13:	8b 45 10             	mov    0x10(%ebp),%eax
  802d16:	83 ec 08             	sub    $0x8,%esp
  802d19:	ff 75 f4             	pushl  -0xc(%ebp)
  802d1c:	50                   	push   %eax
  802d1d:	e8 ad d5 ff ff       	call   8002cf <vcprintf>
  802d22:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802d25:	83 ec 08             	sub    $0x8,%esp
  802d28:	6a 00                	push   $0x0
  802d2a:	68 dd 37 80 00       	push   $0x8037dd
  802d2f:	e8 9b d5 ff ff       	call   8002cf <vcprintf>
  802d34:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802d37:	e8 1c d5 ff ff       	call   800258 <exit>

	// should not return here
	while (1) ;
  802d3c:	eb fe                	jmp    802d3c <_panic+0x70>

00802d3e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802d44:	a1 20 40 80 00       	mov    0x804020,%eax
  802d49:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d52:	39 c2                	cmp    %eax,%edx
  802d54:	74 14                	je     802d6a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	68 e0 37 80 00       	push   $0x8037e0
  802d5e:	6a 26                	push   $0x26
  802d60:	68 2c 38 80 00       	push   $0x80382c
  802d65:	e8 62 ff ff ff       	call   802ccc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802d71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802d78:	e9 c5 00 00 00       	jmp    802e42 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	01 d0                	add    %edx,%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	75 08                	jne    802d9a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802d92:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802d95:	e9 a5 00 00 00       	jmp    802e3f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802d9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802da1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802da8:	eb 69                	jmp    802e13 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802daa:	a1 20 40 80 00       	mov    0x804020,%eax
  802daf:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802db5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db8:	89 d0                	mov    %edx,%eax
  802dba:	01 c0                	add    %eax,%eax
  802dbc:	01 d0                	add    %edx,%eax
  802dbe:	c1 e0 03             	shl    $0x3,%eax
  802dc1:	01 c8                	add    %ecx,%eax
  802dc3:	8a 40 04             	mov    0x4(%eax),%al
  802dc6:	84 c0                	test   %al,%al
  802dc8:	75 46                	jne    802e10 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802dca:	a1 20 40 80 00       	mov    0x804020,%eax
  802dcf:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802dd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd8:	89 d0                	mov    %edx,%eax
  802dda:	01 c0                	add    %eax,%eax
  802ddc:	01 d0                	add    %edx,%eax
  802dde:	c1 e0 03             	shl    $0x3,%eax
  802de1:	01 c8                	add    %ecx,%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802de8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802deb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802df0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	01 c8                	add    %ecx,%eax
  802e01:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e03:	39 c2                	cmp    %eax,%edx
  802e05:	75 09                	jne    802e10 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802e07:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802e0e:	eb 15                	jmp    802e25 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e10:	ff 45 e8             	incl   -0x18(%ebp)
  802e13:	a1 20 40 80 00       	mov    0x804020,%eax
  802e18:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e21:	39 c2                	cmp    %eax,%edx
  802e23:	77 85                	ja     802daa <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802e25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e29:	75 14                	jne    802e3f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 38 38 80 00       	push   $0x803838
  802e33:	6a 3a                	push   $0x3a
  802e35:	68 2c 38 80 00       	push   $0x80382c
  802e3a:	e8 8d fe ff ff       	call   802ccc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802e3f:	ff 45 f0             	incl   -0x10(%ebp)
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e48:	0f 8c 2f ff ff ff    	jl     802d7d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802e4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e5c:	eb 26                	jmp    802e84 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802e5e:	a1 20 40 80 00       	mov    0x804020,%eax
  802e63:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802e69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e6c:	89 d0                	mov    %edx,%eax
  802e6e:	01 c0                	add    %eax,%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	c1 e0 03             	shl    $0x3,%eax
  802e75:	01 c8                	add    %ecx,%eax
  802e77:	8a 40 04             	mov    0x4(%eax),%al
  802e7a:	3c 01                	cmp    $0x1,%al
  802e7c:	75 03                	jne    802e81 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802e7e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e81:	ff 45 e0             	incl   -0x20(%ebp)
  802e84:	a1 20 40 80 00       	mov    0x804020,%eax
  802e89:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e92:	39 c2                	cmp    %eax,%edx
  802e94:	77 c8                	ja     802e5e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e9c:	74 14                	je     802eb2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	68 8c 38 80 00       	push   $0x80388c
  802ea6:	6a 44                	push   $0x44
  802ea8:	68 2c 38 80 00       	push   $0x80382c
  802ead:	e8 1a fe ff ff       	call   802ccc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802eb2:	90                   	nop
  802eb3:	c9                   	leave  
  802eb4:	c3                   	ret    
  802eb5:	66 90                	xchg   %ax,%ax
  802eb7:	90                   	nop

00802eb8 <__udivdi3>:
  802eb8:	55                   	push   %ebp
  802eb9:	57                   	push   %edi
  802eba:	56                   	push   %esi
  802ebb:	53                   	push   %ebx
  802ebc:	83 ec 1c             	sub    $0x1c,%esp
  802ebf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802ec3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802ec7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ecf:	89 ca                	mov    %ecx,%edx
  802ed1:	89 f8                	mov    %edi,%eax
  802ed3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ed7:	85 f6                	test   %esi,%esi
  802ed9:	75 2d                	jne    802f08 <__udivdi3+0x50>
  802edb:	39 cf                	cmp    %ecx,%edi
  802edd:	77 65                	ja     802f44 <__udivdi3+0x8c>
  802edf:	89 fd                	mov    %edi,%ebp
  802ee1:	85 ff                	test   %edi,%edi
  802ee3:	75 0b                	jne    802ef0 <__udivdi3+0x38>
  802ee5:	b8 01 00 00 00       	mov    $0x1,%eax
  802eea:	31 d2                	xor    %edx,%edx
  802eec:	f7 f7                	div    %edi
  802eee:	89 c5                	mov    %eax,%ebp
  802ef0:	31 d2                	xor    %edx,%edx
  802ef2:	89 c8                	mov    %ecx,%eax
  802ef4:	f7 f5                	div    %ebp
  802ef6:	89 c1                	mov    %eax,%ecx
  802ef8:	89 d8                	mov    %ebx,%eax
  802efa:	f7 f5                	div    %ebp
  802efc:	89 cf                	mov    %ecx,%edi
  802efe:	89 fa                	mov    %edi,%edx
  802f00:	83 c4 1c             	add    $0x1c,%esp
  802f03:	5b                   	pop    %ebx
  802f04:	5e                   	pop    %esi
  802f05:	5f                   	pop    %edi
  802f06:	5d                   	pop    %ebp
  802f07:	c3                   	ret    
  802f08:	39 ce                	cmp    %ecx,%esi
  802f0a:	77 28                	ja     802f34 <__udivdi3+0x7c>
  802f0c:	0f bd fe             	bsr    %esi,%edi
  802f0f:	83 f7 1f             	xor    $0x1f,%edi
  802f12:	75 40                	jne    802f54 <__udivdi3+0x9c>
  802f14:	39 ce                	cmp    %ecx,%esi
  802f16:	72 0a                	jb     802f22 <__udivdi3+0x6a>
  802f18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f1c:	0f 87 9e 00 00 00    	ja     802fc0 <__udivdi3+0x108>
  802f22:	b8 01 00 00 00       	mov    $0x1,%eax
  802f27:	89 fa                	mov    %edi,%edx
  802f29:	83 c4 1c             	add    $0x1c,%esp
  802f2c:	5b                   	pop    %ebx
  802f2d:	5e                   	pop    %esi
  802f2e:	5f                   	pop    %edi
  802f2f:	5d                   	pop    %ebp
  802f30:	c3                   	ret    
  802f31:	8d 76 00             	lea    0x0(%esi),%esi
  802f34:	31 ff                	xor    %edi,%edi
  802f36:	31 c0                	xor    %eax,%eax
  802f38:	89 fa                	mov    %edi,%edx
  802f3a:	83 c4 1c             	add    $0x1c,%esp
  802f3d:	5b                   	pop    %ebx
  802f3e:	5e                   	pop    %esi
  802f3f:	5f                   	pop    %edi
  802f40:	5d                   	pop    %ebp
  802f41:	c3                   	ret    
  802f42:	66 90                	xchg   %ax,%ax
  802f44:	89 d8                	mov    %ebx,%eax
  802f46:	f7 f7                	div    %edi
  802f48:	31 ff                	xor    %edi,%edi
  802f4a:	89 fa                	mov    %edi,%edx
  802f4c:	83 c4 1c             	add    $0x1c,%esp
  802f4f:	5b                   	pop    %ebx
  802f50:	5e                   	pop    %esi
  802f51:	5f                   	pop    %edi
  802f52:	5d                   	pop    %ebp
  802f53:	c3                   	ret    
  802f54:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f59:	89 eb                	mov    %ebp,%ebx
  802f5b:	29 fb                	sub    %edi,%ebx
  802f5d:	89 f9                	mov    %edi,%ecx
  802f5f:	d3 e6                	shl    %cl,%esi
  802f61:	89 c5                	mov    %eax,%ebp
  802f63:	88 d9                	mov    %bl,%cl
  802f65:	d3 ed                	shr    %cl,%ebp
  802f67:	89 e9                	mov    %ebp,%ecx
  802f69:	09 f1                	or     %esi,%ecx
  802f6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f6f:	89 f9                	mov    %edi,%ecx
  802f71:	d3 e0                	shl    %cl,%eax
  802f73:	89 c5                	mov    %eax,%ebp
  802f75:	89 d6                	mov    %edx,%esi
  802f77:	88 d9                	mov    %bl,%cl
  802f79:	d3 ee                	shr    %cl,%esi
  802f7b:	89 f9                	mov    %edi,%ecx
  802f7d:	d3 e2                	shl    %cl,%edx
  802f7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f83:	88 d9                	mov    %bl,%cl
  802f85:	d3 e8                	shr    %cl,%eax
  802f87:	09 c2                	or     %eax,%edx
  802f89:	89 d0                	mov    %edx,%eax
  802f8b:	89 f2                	mov    %esi,%edx
  802f8d:	f7 74 24 0c          	divl   0xc(%esp)
  802f91:	89 d6                	mov    %edx,%esi
  802f93:	89 c3                	mov    %eax,%ebx
  802f95:	f7 e5                	mul    %ebp
  802f97:	39 d6                	cmp    %edx,%esi
  802f99:	72 19                	jb     802fb4 <__udivdi3+0xfc>
  802f9b:	74 0b                	je     802fa8 <__udivdi3+0xf0>
  802f9d:	89 d8                	mov    %ebx,%eax
  802f9f:	31 ff                	xor    %edi,%edi
  802fa1:	e9 58 ff ff ff       	jmp    802efe <__udivdi3+0x46>
  802fa6:	66 90                	xchg   %ax,%ax
  802fa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802fac:	89 f9                	mov    %edi,%ecx
  802fae:	d3 e2                	shl    %cl,%edx
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	73 e9                	jae    802f9d <__udivdi3+0xe5>
  802fb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fb7:	31 ff                	xor    %edi,%edi
  802fb9:	e9 40 ff ff ff       	jmp    802efe <__udivdi3+0x46>
  802fbe:	66 90                	xchg   %ax,%ax
  802fc0:	31 c0                	xor    %eax,%eax
  802fc2:	e9 37 ff ff ff       	jmp    802efe <__udivdi3+0x46>
  802fc7:	90                   	nop

00802fc8 <__umoddi3>:
  802fc8:	55                   	push   %ebp
  802fc9:	57                   	push   %edi
  802fca:	56                   	push   %esi
  802fcb:	53                   	push   %ebx
  802fcc:	83 ec 1c             	sub    $0x1c,%esp
  802fcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802fd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802fd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802fdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fe3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802fe7:	89 f3                	mov    %esi,%ebx
  802fe9:	89 fa                	mov    %edi,%edx
  802feb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fef:	89 34 24             	mov    %esi,(%esp)
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	75 1a                	jne    803010 <__umoddi3+0x48>
  802ff6:	39 f7                	cmp    %esi,%edi
  802ff8:	0f 86 a2 00 00 00    	jbe    8030a0 <__umoddi3+0xd8>
  802ffe:	89 c8                	mov    %ecx,%eax
  803000:	89 f2                	mov    %esi,%edx
  803002:	f7 f7                	div    %edi
  803004:	89 d0                	mov    %edx,%eax
  803006:	31 d2                	xor    %edx,%edx
  803008:	83 c4 1c             	add    $0x1c,%esp
  80300b:	5b                   	pop    %ebx
  80300c:	5e                   	pop    %esi
  80300d:	5f                   	pop    %edi
  80300e:	5d                   	pop    %ebp
  80300f:	c3                   	ret    
  803010:	39 f0                	cmp    %esi,%eax
  803012:	0f 87 ac 00 00 00    	ja     8030c4 <__umoddi3+0xfc>
  803018:	0f bd e8             	bsr    %eax,%ebp
  80301b:	83 f5 1f             	xor    $0x1f,%ebp
  80301e:	0f 84 ac 00 00 00    	je     8030d0 <__umoddi3+0x108>
  803024:	bf 20 00 00 00       	mov    $0x20,%edi
  803029:	29 ef                	sub    %ebp,%edi
  80302b:	89 fe                	mov    %edi,%esi
  80302d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803031:	89 e9                	mov    %ebp,%ecx
  803033:	d3 e0                	shl    %cl,%eax
  803035:	89 d7                	mov    %edx,%edi
  803037:	89 f1                	mov    %esi,%ecx
  803039:	d3 ef                	shr    %cl,%edi
  80303b:	09 c7                	or     %eax,%edi
  80303d:	89 e9                	mov    %ebp,%ecx
  80303f:	d3 e2                	shl    %cl,%edx
  803041:	89 14 24             	mov    %edx,(%esp)
  803044:	89 d8                	mov    %ebx,%eax
  803046:	d3 e0                	shl    %cl,%eax
  803048:	89 c2                	mov    %eax,%edx
  80304a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80304e:	d3 e0                	shl    %cl,%eax
  803050:	89 44 24 04          	mov    %eax,0x4(%esp)
  803054:	8b 44 24 08          	mov    0x8(%esp),%eax
  803058:	89 f1                	mov    %esi,%ecx
  80305a:	d3 e8                	shr    %cl,%eax
  80305c:	09 d0                	or     %edx,%eax
  80305e:	d3 eb                	shr    %cl,%ebx
  803060:	89 da                	mov    %ebx,%edx
  803062:	f7 f7                	div    %edi
  803064:	89 d3                	mov    %edx,%ebx
  803066:	f7 24 24             	mull   (%esp)
  803069:	89 c6                	mov    %eax,%esi
  80306b:	89 d1                	mov    %edx,%ecx
  80306d:	39 d3                	cmp    %edx,%ebx
  80306f:	0f 82 87 00 00 00    	jb     8030fc <__umoddi3+0x134>
  803075:	0f 84 91 00 00 00    	je     80310c <__umoddi3+0x144>
  80307b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80307f:	29 f2                	sub    %esi,%edx
  803081:	19 cb                	sbb    %ecx,%ebx
  803083:	89 d8                	mov    %ebx,%eax
  803085:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803089:	d3 e0                	shl    %cl,%eax
  80308b:	89 e9                	mov    %ebp,%ecx
  80308d:	d3 ea                	shr    %cl,%edx
  80308f:	09 d0                	or     %edx,%eax
  803091:	89 e9                	mov    %ebp,%ecx
  803093:	d3 eb                	shr    %cl,%ebx
  803095:	89 da                	mov    %ebx,%edx
  803097:	83 c4 1c             	add    $0x1c,%esp
  80309a:	5b                   	pop    %ebx
  80309b:	5e                   	pop    %esi
  80309c:	5f                   	pop    %edi
  80309d:	5d                   	pop    %ebp
  80309e:	c3                   	ret    
  80309f:	90                   	nop
  8030a0:	89 fd                	mov    %edi,%ebp
  8030a2:	85 ff                	test   %edi,%edi
  8030a4:	75 0b                	jne    8030b1 <__umoddi3+0xe9>
  8030a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ab:	31 d2                	xor    %edx,%edx
  8030ad:	f7 f7                	div    %edi
  8030af:	89 c5                	mov    %eax,%ebp
  8030b1:	89 f0                	mov    %esi,%eax
  8030b3:	31 d2                	xor    %edx,%edx
  8030b5:	f7 f5                	div    %ebp
  8030b7:	89 c8                	mov    %ecx,%eax
  8030b9:	f7 f5                	div    %ebp
  8030bb:	89 d0                	mov    %edx,%eax
  8030bd:	e9 44 ff ff ff       	jmp    803006 <__umoddi3+0x3e>
  8030c2:	66 90                	xchg   %ax,%ax
  8030c4:	89 c8                	mov    %ecx,%eax
  8030c6:	89 f2                	mov    %esi,%edx
  8030c8:	83 c4 1c             	add    $0x1c,%esp
  8030cb:	5b                   	pop    %ebx
  8030cc:	5e                   	pop    %esi
  8030cd:	5f                   	pop    %edi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
  8030d0:	3b 04 24             	cmp    (%esp),%eax
  8030d3:	72 06                	jb     8030db <__umoddi3+0x113>
  8030d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8030d9:	77 0f                	ja     8030ea <__umoddi3+0x122>
  8030db:	89 f2                	mov    %esi,%edx
  8030dd:	29 f9                	sub    %edi,%ecx
  8030df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8030e3:	89 14 24             	mov    %edx,(%esp)
  8030e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8030ee:	8b 14 24             	mov    (%esp),%edx
  8030f1:	83 c4 1c             	add    $0x1c,%esp
  8030f4:	5b                   	pop    %ebx
  8030f5:	5e                   	pop    %esi
  8030f6:	5f                   	pop    %edi
  8030f7:	5d                   	pop    %ebp
  8030f8:	c3                   	ret    
  8030f9:	8d 76 00             	lea    0x0(%esi),%esi
  8030fc:	2b 04 24             	sub    (%esp),%eax
  8030ff:	19 fa                	sbb    %edi,%edx
  803101:	89 d1                	mov    %edx,%ecx
  803103:	89 c6                	mov    %eax,%esi
  803105:	e9 71 ff ff ff       	jmp    80307b <__umoddi3+0xb3>
  80310a:	66 90                	xchg   %ax,%ax
  80310c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803110:	72 ea                	jb     8030fc <__umoddi3+0x134>
  803112:	89 d9                	mov    %ebx,%ecx
  803114:	e9 62 ff ff ff       	jmp    80307b <__umoddi3+0xb3>
