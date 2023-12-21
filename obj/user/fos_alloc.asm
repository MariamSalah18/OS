
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
  80005c:	68 40 31 80 00       	push   $0x803140
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
  8000b9:	68 53 31 80 00       	push   $0x803153
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
  80010f:	68 53 31 80 00       	push   $0x803153
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
  8001a3:	68 78 31 80 00       	push   $0x803178
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
  8001cb:	68 a0 31 80 00       	push   $0x8031a0
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
  8001fc:	68 c8 31 80 00       	push   $0x8031c8
  800201:	e8 34 01 00 00       	call   80033a <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800209:	a1 20 40 80 00       	mov    0x804020,%eax
  80020e:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 20 32 80 00       	push   $0x803220
  80021d:	e8 18 01 00 00       	call   80033a <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 78 31 80 00       	push   $0x803178
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
  8003d7:	e8 f8 2a 00 00       	call   802ed4 <__udivdi3>
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
  800427:	e8 b8 2b 00 00       	call   802fe4 <__umoddi3>
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	05 54 34 80 00       	add    $0x803454,%eax
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
  800582:	8b 04 85 78 34 80 00 	mov    0x803478(,%eax,4),%eax
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
  800663:	8b 34 9d c0 32 80 00 	mov    0x8032c0(,%ebx,4),%esi
  80066a:	85 f6                	test   %esi,%esi
  80066c:	75 19                	jne    800687 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80066e:	53                   	push   %ebx
  80066f:	68 65 34 80 00       	push   $0x803465
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
  800688:	68 6e 34 80 00       	push   $0x80346e
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
  8006b5:	be 71 34 80 00       	mov    $0x803471,%esi
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
  8011fb:	e8 60 0b 00 00       	call   801d60 <alloc_block_FF>
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
  8012f4:	e8 34 10 00 00       	call   80232d <free_block>
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
  8013ca:	68 d0 35 80 00       	push   $0x8035d0
  8013cf:	68 ad 00 00 00       	push   $0xad
  8013d4:	68 f6 35 80 00       	push   $0x8035f6
  8013d9:	e8 0a 19 00 00       	call   802ce8 <_panic>
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
  8013ee:	68 04 36 80 00       	push   $0x803604
  8013f3:	68 ba 00 00 00       	push   $0xba
  8013f8:	68 f6 35 80 00       	push   $0x8035f6
  8013fd:	e8 e6 18 00 00       	call   802ce8 <_panic>

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
  801410:	68 28 36 80 00       	push   $0x803628
  801415:	68 d8 00 00 00       	push   $0xd8
  80141a:	68 f6 35 80 00       	push   $0x8035f6
  80141f:	e8 c4 18 00 00       	call   802ce8 <_panic>

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
  80142d:	68 50 36 80 00       	push   $0x803650
  801432:	68 ea 00 00 00       	push   $0xea
  801437:	68 f6 35 80 00       	push   $0x8035f6
  80143c:	e8 a7 18 00 00       	call   802ce8 <_panic>

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
  80144a:	68 74 36 80 00       	push   $0x803674
  80144f:	68 f2 00 00 00       	push   $0xf2
  801454:	68 f6 35 80 00       	push   $0x8035f6
  801459:	e8 8a 18 00 00       	call   802ce8 <_panic>

0080145e <shrink>:

}
void shrink(uint32 newSize) {
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	68 74 36 80 00       	push   $0x803674
  80146c:	68 f6 00 00 00       	push   $0xf6
  801471:	68 f6 35 80 00       	push   $0x8035f6
  801476:	e8 6d 18 00 00       	call   802ce8 <_panic>

0080147b <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	68 74 36 80 00       	push   $0x803674
  801489:	68 fa 00 00 00       	push   $0xfa
  80148e:	68 f6 35 80 00       	push   $0x8035f6
  801493:	e8 50 18 00 00       	call   802ce8 <_panic>

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

00801b4a <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	50                   	push   %eax
  801b59:	6a 33                	push   $0x33
  801b5b:	e8 38 f9 ff ff       	call   801498 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	83 e8 10             	sub    $0x10,%eax
  801b72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b78:	8b 00                	mov    (%eax),%eax
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	83 e8 10             	sub    $0x10,%eax
  801b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8e:	8a 40 04             	mov    0x4(%eax),%al
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba3:	83 f8 02             	cmp    $0x2,%eax
  801ba6:	74 2b                	je     801bd3 <alloc_block+0x40>
  801ba8:	83 f8 02             	cmp    $0x2,%eax
  801bab:	7f 07                	jg     801bb4 <alloc_block+0x21>
  801bad:	83 f8 01             	cmp    $0x1,%eax
  801bb0:	74 0e                	je     801bc0 <alloc_block+0x2d>
  801bb2:	eb 58                	jmp    801c0c <alloc_block+0x79>
  801bb4:	83 f8 03             	cmp    $0x3,%eax
  801bb7:	74 2d                	je     801be6 <alloc_block+0x53>
  801bb9:	83 f8 04             	cmp    $0x4,%eax
  801bbc:	74 3b                	je     801bf9 <alloc_block+0x66>
  801bbe:	eb 4c                	jmp    801c0c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	e8 95 01 00 00       	call   801d60 <alloc_block_FF>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bd1:	eb 4a                	jmp    801c1d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	e8 32 07 00 00       	call   802310 <alloc_block_NF>
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801be4:	eb 37                	jmp    801c1d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801be6:	83 ec 0c             	sub    $0xc,%esp
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	e8 a3 04 00 00       	call   802094 <alloc_block_BF>
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bf7:	eb 24                	jmp    801c1d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	e8 ef 06 00 00       	call   8022f3 <alloc_block_WF>
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c0a:	eb 11                	jmp    801c1d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c0c:	83 ec 0c             	sub    $0xc,%esp
  801c0f:	68 84 36 80 00       	push   $0x803684
  801c14:	e8 21 e7 ff ff       	call   80033a <cprintf>
  801c19:	83 c4 10             	add    $0x10,%esp
		break;
  801c1c:	90                   	nop
	}
	return va;
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	68 a4 36 80 00       	push   $0x8036a4
  801c30:	e8 05 e7 ff ff       	call   80033a <cprintf>
  801c35:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	68 cf 36 80 00       	push   $0x8036cf
  801c40:	e8 f5 e6 ff ff       	call   80033a <cprintf>
  801c45:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4e:	eb 26                	jmp    801c76 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c53:	8a 40 04             	mov    0x4(%eax),%al
  801c56:	0f b6 d0             	movzbl %al,%edx
  801c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5c:	8b 00                	mov    (%eax),%eax
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	52                   	push   %edx
  801c62:	50                   	push   %eax
  801c63:	68 e7 36 80 00       	push   $0x8036e7
  801c68:	e8 cd e6 ff ff       	call   80033a <cprintf>
  801c6d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c7a:	74 08                	je     801c84 <print_blocks_list+0x62>
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	8b 40 08             	mov    0x8(%eax),%eax
  801c82:	eb 05                	jmp    801c89 <print_blocks_list+0x67>
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
  801c89:	89 45 10             	mov    %eax,0x10(%ebp)
  801c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	75 bd                	jne    801c50 <print_blocks_list+0x2e>
  801c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c97:	75 b7                	jne    801c50 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	68 a4 36 80 00       	push   $0x8036a4
  801ca1:	e8 94 e6 ff ff       	call   80033a <cprintf>
  801ca6:	83 c4 10             	add    $0x10,%esp

}
  801ca9:	90                   	nop
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  801cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb6:	0f 84 a1 00 00 00    	je     801d5d <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  801cbc:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  801cc3:	00 00 00 
	LIST_INIT(&list);
  801cc6:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  801ccd:	00 00 00 
  801cd0:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  801cd7:	00 00 00 
  801cda:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  801ce1:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  801cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ced:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  801cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfd:	75 14                	jne    801d13 <initialize_dynamic_allocator+0x67>
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	68 00 37 80 00       	push   $0x803700
  801d07:	6a 64                	push   $0x64
  801d09:	68 23 37 80 00       	push   $0x803723
  801d0e:	e8 d5 0f 00 00       	call   802ce8 <_panic>
  801d13:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1c:	89 50 0c             	mov    %edx,0xc(%eax)
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	8b 40 0c             	mov    0xc(%eax),%eax
  801d25:	85 c0                	test   %eax,%eax
  801d27:	74 0d                	je     801d36 <initialize_dynamic_allocator+0x8a>
  801d29:	a1 44 41 90 00       	mov    0x904144,%eax
  801d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d31:	89 50 08             	mov    %edx,0x8(%eax)
  801d34:	eb 08                	jmp    801d3e <initialize_dynamic_allocator+0x92>
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	a3 40 41 90 00       	mov    %eax,0x904140
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	a3 44 41 90 00       	mov    %eax,0x904144
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d50:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801d55:	40                   	inc    %eax
  801d56:	a3 4c 41 90 00       	mov    %eax,0x90414c
  801d5b:	eb 01                	jmp    801d5e <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  801d5d:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  801d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d6a:	75 0a                	jne    801d76 <alloc_block_FF+0x16>
	{
		return NULL;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	e9 1c 03 00 00       	jmp    802092 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  801d76:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	75 40                	jne    801dbf <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	83 c0 10             	add    $0x10,%eax
  801d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  801d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	50                   	push   %eax
  801d8f:	e8 bb f3 ff ff       	call   80114f <sbrk>
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	6a 00                	push   $0x0
  801d9f:	e8 ab f3 ff ff       	call   80114f <sbrk>
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  801daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dad:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801db0:	83 ec 08             	sub    $0x8,%esp
  801db3:	50                   	push   %eax
  801db4:	ff 75 ec             	pushl  -0x14(%ebp)
  801db7:	e8 f0 fe ff ff       	call   801cac <initialize_dynamic_allocator>
  801dbc:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  801dbf:	a1 40 41 90 00       	mov    0x904140,%eax
  801dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc7:	e9 1e 01 00 00       	jmp    801eea <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8d 50 10             	lea    0x10(%eax),%edx
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	39 c2                	cmp    %eax,%edx
  801dd9:	75 1c                	jne    801df7 <alloc_block_FF+0x97>
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8a 40 04             	mov    0x4(%eax),%al
  801de1:	3c 01                	cmp    $0x1,%al
  801de3:	75 12                	jne    801df7 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	83 c0 10             	add    $0x10,%eax
  801df2:	e9 9b 02 00 00       	jmp    802092 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	8d 50 10             	lea    0x10(%eax),%edx
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	8b 00                	mov    (%eax),%eax
  801e02:	39 c2                	cmp    %eax,%edx
  801e04:	0f 83 d8 00 00 00    	jae    801ee2 <alloc_block_FF+0x182>
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8a 40 04             	mov    0x4(%eax),%al
  801e10:	3c 01                	cmp    $0x1,%al
  801e12:	0f 85 ca 00 00 00    	jne    801ee2 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	2b 45 08             	sub    0x8(%ebp),%eax
  801e20:	83 e8 10             	sub    $0x10,%eax
  801e23:	83 f8 0f             	cmp    $0xf,%eax
  801e26:	0f 86 a4 00 00 00    	jbe    801ed0 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  801e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	01 d0                	add    %edx,%eax
  801e34:	83 c0 10             	add    $0x10,%eax
  801e37:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	8b 00                	mov    (%eax),%eax
  801e3f:	2b 45 08             	sub    0x8(%ebp),%eax
  801e42:	8d 50 f0             	lea    -0x10(%eax),%edx
  801e45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e48:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  801e4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4d:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  801e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e55:	74 06                	je     801e5d <alloc_block_FF+0xfd>
  801e57:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801e5b:	75 17                	jne    801e74 <alloc_block_FF+0x114>
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	68 3c 37 80 00       	push   $0x80373c
  801e65:	68 8f 00 00 00       	push   $0x8f
  801e6a:	68 23 37 80 00       	push   $0x803723
  801e6f:	e8 74 0e 00 00       	call   802ce8 <_panic>
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	8b 50 08             	mov    0x8(%eax),%edx
  801e7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e7d:	89 50 08             	mov    %edx,0x8(%eax)
  801e80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e83:	8b 40 08             	mov    0x8(%eax),%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	74 0c                	je     801e96 <alloc_block_FF+0x136>
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 08             	mov    0x8(%eax),%eax
  801e90:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e93:	89 50 0c             	mov    %edx,0xc(%eax)
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e9c:	89 50 08             	mov    %edx,0x8(%eax)
  801e9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea5:	89 50 0c             	mov    %edx,0xc(%eax)
  801ea8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eab:	8b 40 08             	mov    0x8(%eax),%eax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	75 08                	jne    801eba <alloc_block_FF+0x15a>
  801eb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eb5:	a3 44 41 90 00       	mov    %eax,0x904144
  801eba:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801ebf:	40                   	inc    %eax
  801ec0:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	8d 50 10             	lea    0x10(%eax),%edx
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	83 c0 10             	add    $0x10,%eax
  801edd:	e9 b0 01 00 00       	jmp    802092 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  801ee2:	a1 48 41 90 00       	mov    0x904148,%eax
  801ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eee:	74 08                	je     801ef8 <alloc_block_FF+0x198>
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 40 08             	mov    0x8(%eax),%eax
  801ef6:	eb 05                	jmp    801efd <alloc_block_FF+0x19d>
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	a3 48 41 90 00       	mov    %eax,0x904148
  801f02:	a1 48 41 90 00       	mov    0x904148,%eax
  801f07:	85 c0                	test   %eax,%eax
  801f09:	0f 85 bd fe ff ff    	jne    801dcc <alloc_block_FF+0x6c>
  801f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f13:	0f 85 b3 fe ff ff    	jne    801dcc <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	83 c0 10             	add    $0x10,%eax
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	50                   	push   %eax
  801f23:	e8 27 f2 ff ff       	call   80114f <sbrk>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	6a 00                	push   $0x0
  801f33:	e8 17 f2 ff ff       	call   80114f <sbrk>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  801f3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f44:	29 c2                	sub    %eax,%edx
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  801f4b:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801f4f:	0f 84 38 01 00 00    	je     80208d <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  801f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f58:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  801f5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f5f:	75 17                	jne    801f78 <alloc_block_FF+0x218>
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	68 00 37 80 00       	push   $0x803700
  801f69:	68 9f 00 00 00       	push   $0x9f
  801f6e:	68 23 37 80 00       	push   $0x803723
  801f73:	e8 70 0d 00 00       	call   802ce8 <_panic>
  801f78:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801f7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f81:	89 50 0c             	mov    %edx,0xc(%eax)
  801f84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f87:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	74 0d                	je     801f9b <alloc_block_FF+0x23b>
  801f8e:	a1 44 41 90 00       	mov    0x904144,%eax
  801f93:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f96:	89 50 08             	mov    %edx,0x8(%eax)
  801f99:	eb 08                	jmp    801fa3 <alloc_block_FF+0x243>
  801f9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f9e:	a3 40 41 90 00       	mov    %eax,0x904140
  801fa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fa6:	a3 44 41 90 00       	mov    %eax,0x904144
  801fab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fb5:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801fba:	40                   	inc    %eax
  801fbb:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	8d 50 10             	lea    0x10(%eax),%edx
  801fc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fc9:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  801fcb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fce:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  801fd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fd5:	2b 45 08             	sub    0x8(%ebp),%eax
  801fd8:	83 f8 10             	cmp    $0x10,%eax
  801fdb:	0f 84 a4 00 00 00    	je     802085 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  801fe1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe4:	2b 45 08             	sub    0x8(%ebp),%eax
  801fe7:	83 e8 10             	sub    $0x10,%eax
  801fea:	83 f8 0f             	cmp    $0xf,%eax
  801fed:	0f 86 8a 00 00 00    	jbe    80207d <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  801ff3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	01 d0                	add    %edx,%eax
  801ffb:	83 c0 10             	add    $0x10,%eax
  801ffe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802001:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802005:	75 17                	jne    80201e <alloc_block_FF+0x2be>
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	68 00 37 80 00       	push   $0x803700
  80200f:	68 a7 00 00 00       	push   $0xa7
  802014:	68 23 37 80 00       	push   $0x803723
  802019:	e8 ca 0c 00 00       	call   802ce8 <_panic>
  80201e:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802024:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802027:	89 50 0c             	mov    %edx,0xc(%eax)
  80202a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202d:	8b 40 0c             	mov    0xc(%eax),%eax
  802030:	85 c0                	test   %eax,%eax
  802032:	74 0d                	je     802041 <alloc_block_FF+0x2e1>
  802034:	a1 44 41 90 00       	mov    0x904144,%eax
  802039:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80203c:	89 50 08             	mov    %edx,0x8(%eax)
  80203f:	eb 08                	jmp    802049 <alloc_block_FF+0x2e9>
  802041:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802044:	a3 40 41 90 00       	mov    %eax,0x904140
  802049:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80204c:	a3 44 41 90 00       	mov    %eax,0x904144
  802051:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80205b:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802060:	40                   	inc    %eax
  802061:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802066:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802069:	2b 45 08             	sub    0x8(%ebp),%eax
  80206c:	8d 50 f0             	lea    -0x10(%eax),%edx
  80206f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802072:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802077:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80207b:	eb 08                	jmp    802085 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  80207d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802080:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802083:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802085:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802088:	83 c0 10             	add    $0x10,%eax
  80208b:	eb 05                	jmp    802092 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  80209a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  8020a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a5:	75 0a                	jne    8020b1 <alloc_block_BF+0x1d>
	{
		return NULL;
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	e9 40 02 00 00       	jmp    8022f1 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8020b1:	a1 40 41 90 00       	mov    0x904140,%eax
  8020b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b9:	eb 66                	jmp    802121 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	8a 40 04             	mov    0x4(%eax),%al
  8020c1:	3c 01                	cmp    $0x1,%al
  8020c3:	75 21                	jne    8020e6 <alloc_block_BF+0x52>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8d 50 10             	lea    0x10(%eax),%edx
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 00                	mov    (%eax),%eax
  8020d0:	39 c2                	cmp    %eax,%edx
  8020d2:	75 12                	jne    8020e6 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	83 c0 10             	add    $0x10,%eax
  8020e1:	e9 0b 02 00 00       	jmp    8022f1 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8a 40 04             	mov    0x4(%eax),%al
  8020ec:	3c 01                	cmp    $0x1,%al
  8020ee:	75 29                	jne    802119 <alloc_block_BF+0x85>
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	8d 50 10             	lea    0x10(%eax),%edx
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	39 c2                	cmp    %eax,%edx
  8020fd:	77 1a                	ja     802119 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8020ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802103:	74 0e                	je     802113 <alloc_block_BF+0x7f>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 10                	mov    (%eax),%edx
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	39 c2                	cmp    %eax,%edx
  802111:	73 06                	jae    802119 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802119:	a1 48 41 90 00       	mov    0x904148,%eax
  80211e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802125:	74 08                	je     80212f <alloc_block_BF+0x9b>
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	eb 05                	jmp    802134 <alloc_block_BF+0xa0>
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	a3 48 41 90 00       	mov    %eax,0x904148
  802139:	a1 48 41 90 00       	mov    0x904148,%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	0f 85 75 ff ff ff    	jne    8020bb <alloc_block_BF+0x27>
  802146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214a:	0f 85 6b ff ff ff    	jne    8020bb <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802154:	0f 84 f8 00 00 00    	je     802252 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8d 50 10             	lea    0x10(%eax),%edx
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	8b 00                	mov    (%eax),%eax
  802165:	39 c2                	cmp    %eax,%edx
  802167:	0f 87 e5 00 00 00    	ja     802252 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80216d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	2b 45 08             	sub    0x8(%ebp),%eax
  802175:	83 e8 10             	sub    $0x10,%eax
  802178:	83 f8 0f             	cmp    $0xf,%eax
  80217b:	0f 86 bf 00 00 00    	jbe    802240 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802181:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	01 d0                	add    %edx,%eax
  802189:	83 c0 10             	add    $0x10,%eax
  80218c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  80218f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	2b 45 08             	sub    0x8(%ebp),%eax
  8021a0:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a6:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8021a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ab:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8021af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b3:	74 06                	je     8021bb <alloc_block_BF+0x127>
  8021b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021b9:	75 17                	jne    8021d2 <alloc_block_BF+0x13e>
  8021bb:	83 ec 04             	sub    $0x4,%esp
  8021be:	68 3c 37 80 00       	push   $0x80373c
  8021c3:	68 e3 00 00 00       	push   $0xe3
  8021c8:	68 23 37 80 00       	push   $0x803723
  8021cd:	e8 16 0b 00 00       	call   802ce8 <_panic>
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d5:	8b 50 08             	mov    0x8(%eax),%edx
  8021d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021db:	89 50 08             	mov    %edx,0x8(%eax)
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	8b 40 08             	mov    0x8(%eax),%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 0c                	je     8021f4 <alloc_block_BF+0x160>
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f1:	89 50 0c             	mov    %edx,0xc(%eax)
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fa:	89 50 08             	mov    %edx,0x8(%eax)
  8021fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802203:	89 50 0c             	mov    %edx,0xc(%eax)
  802206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802209:	8b 40 08             	mov    0x8(%eax),%eax
  80220c:	85 c0                	test   %eax,%eax
  80220e:	75 08                	jne    802218 <alloc_block_BF+0x184>
  802210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802213:	a3 44 41 90 00       	mov    %eax,0x904144
  802218:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80221d:	40                   	inc    %eax
  80221e:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8d 50 10             	lea    0x10(%eax),%edx
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	83 c0 10             	add    $0x10,%eax
  80223b:	e9 b1 00 00 00       	jmp    8022f1 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224a:	83 c0 10             	add    $0x10,%eax
  80224d:	e9 9f 00 00 00       	jmp    8022f1 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	83 c0 10             	add    $0x10,%eax
  802258:	83 ec 0c             	sub    $0xc,%esp
  80225b:	50                   	push   %eax
  80225c:	e8 ee ee ff ff       	call   80114f <sbrk>
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802267:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80226b:	74 7f                	je     8022ec <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  80226d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802271:	75 17                	jne    80228a <alloc_block_BF+0x1f6>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 00 37 80 00       	push   $0x803700
  80227b:	68 f6 00 00 00       	push   $0xf6
  802280:	68 23 37 80 00       	push   $0x803723
  802285:	e8 5e 0a 00 00       	call   802ce8 <_panic>
  80228a:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802293:	89 50 0c             	mov    %edx,0xc(%eax)
  802296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802299:	8b 40 0c             	mov    0xc(%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 0d                	je     8022ad <alloc_block_BF+0x219>
  8022a0:	a1 44 41 90 00       	mov    0x904144,%eax
  8022a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a8:	89 50 08             	mov    %edx,0x8(%eax)
  8022ab:	eb 08                	jmp    8022b5 <alloc_block_BF+0x221>
  8022ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b0:	a3 40 41 90 00       	mov    %eax,0x904140
  8022b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b8:	a3 44 41 90 00       	mov    %eax,0x904144
  8022bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022c7:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8022cc:	40                   	inc    %eax
  8022cd:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8d 50 10             	lea    0x10(%eax),%edx
  8022d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022db:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8022dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8022e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e7:	83 c0 10             	add    $0x10,%eax
  8022ea:	eb 05                	jmp    8022f1 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	68 70 37 80 00       	push   $0x803770
  802301:	68 07 01 00 00       	push   $0x107
  802306:	68 23 37 80 00       	push   $0x803723
  80230b:	e8 d8 09 00 00       	call   802ce8 <_panic>

00802310 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	68 98 37 80 00       	push   $0x803798
  80231e:	68 0f 01 00 00       	push   $0x10f
  802323:	68 23 37 80 00       	push   $0x803723
  802328:	e8 bb 09 00 00       	call   802ce8 <_panic>

0080232d <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802337:	0f 84 ee 05 00 00    	je     80292b <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	83 e8 10             	sub    $0x10,%eax
  802343:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802346:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80234a:	a1 40 41 90 00       	mov    0x904140,%eax
  80234f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802352:	eb 16                	jmp    80236a <free_block+0x3d>
	{
		if (block_pointer == it)
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80235a:	75 06                	jne    802362 <free_block+0x35>
		{
			flagx = 1;
  80235c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802360:	eb 2f                	jmp    802391 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802362:	a1 48 41 90 00       	mov    0x904148,%eax
  802367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80236a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236e:	74 08                	je     802378 <free_block+0x4b>
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 40 08             	mov    0x8(%eax),%eax
  802376:	eb 05                	jmp    80237d <free_block+0x50>
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	a3 48 41 90 00       	mov    %eax,0x904148
  802382:	a1 48 41 90 00       	mov    0x904148,%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	75 c9                	jne    802354 <free_block+0x27>
  80238b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80238f:	75 c3                	jne    802354 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802391:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802395:	0f 84 93 05 00 00    	je     80292e <free_block+0x601>
		return;
	if (va == NULL)
  80239b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239f:	0f 84 8c 05 00 00    	je     802931 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8023a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8023ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b1:	8b 40 08             	mov    0x8(%eax),%eax
  8023b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8023b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023bb:	75 12                	jne    8023cf <free_block+0xa2>
  8023bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023c1:	75 0c                	jne    8023cf <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8023c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8023ca:	e9 63 05 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8023cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023d3:	0f 85 ca 00 00 00    	jne    8024a3 <free_block+0x176>
  8023d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023dc:	8a 40 04             	mov    0x4(%eax),%al
  8023df:	3c 01                	cmp    $0x1,%al
  8023e1:	0f 85 bc 00 00 00    	jne    8024a3 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8023e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ea:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	8b 10                	mov    (%eax),%edx
  8023f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	01 c2                	add    %eax,%edx
  8023fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fd:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8023ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80240f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802413:	75 17                	jne    80242c <free_block+0xff>
  802415:	83 ec 04             	sub    $0x4,%esp
  802418:	68 be 37 80 00       	push   $0x8037be
  80241d:	68 3c 01 00 00       	push   $0x13c
  802422:	68 23 37 80 00       	push   $0x803723
  802427:	e8 bc 08 00 00       	call   802ce8 <_panic>
  80242c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242f:	8b 40 08             	mov    0x8(%eax),%eax
  802432:	85 c0                	test   %eax,%eax
  802434:	74 11                	je     802447 <free_block+0x11a>
  802436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802439:	8b 40 08             	mov    0x8(%eax),%eax
  80243c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80243f:	8b 52 0c             	mov    0xc(%edx),%edx
  802442:	89 50 0c             	mov    %edx,0xc(%eax)
  802445:	eb 0b                	jmp    802452 <free_block+0x125>
  802447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	a3 44 41 90 00       	mov    %eax,0x904144
  802452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 11                	je     80246d <free_block+0x140>
  80245c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245f:	8b 40 0c             	mov    0xc(%eax),%eax
  802462:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802465:	8b 52 08             	mov    0x8(%edx),%edx
  802468:	89 50 08             	mov    %edx,0x8(%eax)
  80246b:	eb 0b                	jmp    802478 <free_block+0x14b>
  80246d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802470:	8b 40 08             	mov    0x8(%eax),%eax
  802473:	a3 40 41 90 00       	mov    %eax,0x904140
  802478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802485:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80248c:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802491:	48                   	dec    %eax
  802492:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802497:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80249e:	e9 8f 04 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8024a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024a7:	75 16                	jne    8024bf <free_block+0x192>
  8024a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ac:	8a 40 04             	mov    0x4(%eax),%al
  8024af:	84 c0                	test   %al,%al
  8024b1:	75 0c                	jne    8024bf <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8024b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8024ba:	e9 73 04 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8024bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024c3:	0f 85 c3 00 00 00    	jne    80258c <free_block+0x25f>
  8024c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024cc:	8a 40 04             	mov    0x4(%eax),%al
  8024cf:	3c 01                	cmp    $0x1,%al
  8024d1:	0f 85 b5 00 00 00    	jne    80258c <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8024d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024da:	8b 10                	mov    (%eax),%edx
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	01 c2                	add    %eax,%edx
  8024e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e6:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8024e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8024f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8024f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024fc:	75 17                	jne    802515 <free_block+0x1e8>
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 be 37 80 00       	push   $0x8037be
  802506:	68 49 01 00 00       	push   $0x149
  80250b:	68 23 37 80 00       	push   $0x803723
  802510:	e8 d3 07 00 00       	call   802ce8 <_panic>
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	85 c0                	test   %eax,%eax
  80251d:	74 11                	je     802530 <free_block+0x203>
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	8b 40 08             	mov    0x8(%eax),%eax
  802525:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802528:	8b 52 0c             	mov    0xc(%edx),%edx
  80252b:	89 50 0c             	mov    %edx,0xc(%eax)
  80252e:	eb 0b                	jmp    80253b <free_block+0x20e>
  802530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	a3 44 41 90 00       	mov    %eax,0x904144
  80253b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253e:	8b 40 0c             	mov    0xc(%eax),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	74 11                	je     802556 <free_block+0x229>
  802545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254e:	8b 52 08             	mov    0x8(%edx),%edx
  802551:	89 50 08             	mov    %edx,0x8(%eax)
  802554:	eb 0b                	jmp    802561 <free_block+0x234>
  802556:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802559:	8b 40 08             	mov    0x8(%eax),%eax
  80255c:	a3 40 41 90 00       	mov    %eax,0x904140
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802575:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80257a:	48                   	dec    %eax
  80257b:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802580:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802587:	e9 a6 03 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  80258c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802590:	75 16                	jne    8025a8 <free_block+0x27b>
  802592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802595:	8a 40 04             	mov    0x4(%eax),%al
  802598:	84 c0                	test   %al,%al
  80259a:	75 0c                	jne    8025a8 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8025a3:	e9 8a 03 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8025a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025ac:	0f 84 81 01 00 00    	je     802733 <free_block+0x406>
  8025b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025b6:	0f 84 77 01 00 00    	je     802733 <free_block+0x406>
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	8a 40 04             	mov    0x4(%eax),%al
  8025c2:	3c 01                	cmp    $0x1,%al
  8025c4:	0f 85 69 01 00 00    	jne    802733 <free_block+0x406>
  8025ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025cd:	8a 40 04             	mov    0x4(%eax),%al
  8025d0:	3c 01                	cmp    $0x1,%al
  8025d2:	0f 85 5b 01 00 00    	jne    802733 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8025d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025db:	8b 10                	mov    (%eax),%edx
  8025dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e0:	8b 08                	mov    (%eax),%ecx
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	01 c8                	add    %ecx,%eax
  8025e9:	01 c2                	add    %eax,%edx
  8025eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ee:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8025f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8025f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802610:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802614:	75 17                	jne    80262d <free_block+0x300>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 be 37 80 00       	push   $0x8037be
  80261e:	68 59 01 00 00       	push   $0x159
  802623:	68 23 37 80 00       	push   $0x803723
  802628:	e8 bb 06 00 00       	call   802ce8 <_panic>
  80262d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802630:	8b 40 08             	mov    0x8(%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 11                	je     802648 <free_block+0x31b>
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	8b 40 08             	mov    0x8(%eax),%eax
  80263d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802640:	8b 52 0c             	mov    0xc(%edx),%edx
  802643:	89 50 0c             	mov    %edx,0xc(%eax)
  802646:	eb 0b                	jmp    802653 <free_block+0x326>
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	8b 40 0c             	mov    0xc(%eax),%eax
  80264e:	a3 44 41 90 00       	mov    %eax,0x904144
  802653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802656:	8b 40 0c             	mov    0xc(%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 11                	je     80266e <free_block+0x341>
  80265d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802666:	8b 52 08             	mov    0x8(%edx),%edx
  802669:	89 50 08             	mov    %edx,0x8(%eax)
  80266c:	eb 0b                	jmp    802679 <free_block+0x34c>
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	8b 40 08             	mov    0x8(%eax),%eax
  802674:	a3 40 41 90 00       	mov    %eax,0x904140
  802679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80268d:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802692:	48                   	dec    %eax
  802693:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802698:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80269c:	75 17                	jne    8026b5 <free_block+0x388>
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 be 37 80 00       	push   $0x8037be
  8026a6:	68 5a 01 00 00       	push   $0x15a
  8026ab:	68 23 37 80 00       	push   $0x803723
  8026b0:	e8 33 06 00 00       	call   802ce8 <_panic>
  8026b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b8:	8b 40 08             	mov    0x8(%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 11                	je     8026d0 <free_block+0x3a3>
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	8b 40 08             	mov    0x8(%eax),%eax
  8026c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8026cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8026ce:	eb 0b                	jmp    8026db <free_block+0x3ae>
  8026d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d6:	a3 44 41 90 00       	mov    %eax,0x904144
  8026db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026de:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 11                	je     8026f6 <free_block+0x3c9>
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ee:	8b 52 08             	mov    0x8(%edx),%edx
  8026f1:	89 50 08             	mov    %edx,0x8(%eax)
  8026f4:	eb 0b                	jmp    802701 <free_block+0x3d4>
  8026f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f9:	8b 40 08             	mov    0x8(%eax),%eax
  8026fc:	a3 40 41 90 00       	mov    %eax,0x904140
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80270b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802715:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80271a:	48                   	dec    %eax
  80271b:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802720:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802727:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80272e:	e9 ff 01 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802737:	0f 84 db 00 00 00    	je     802818 <free_block+0x4eb>
  80273d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802741:	0f 84 d1 00 00 00    	je     802818 <free_block+0x4eb>
  802747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274a:	8a 40 04             	mov    0x4(%eax),%al
  80274d:	84 c0                	test   %al,%al
  80274f:	0f 85 c3 00 00 00    	jne    802818 <free_block+0x4eb>
  802755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802758:	8a 40 04             	mov    0x4(%eax),%al
  80275b:	3c 01                	cmp    $0x1,%al
  80275d:	0f 85 b5 00 00 00    	jne    802818 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802766:	8b 10                	mov    (%eax),%edx
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	01 c2                	add    %eax,%edx
  80276f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802772:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80277d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802780:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802784:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802788:	75 17                	jne    8027a1 <free_block+0x474>
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	68 be 37 80 00       	push   $0x8037be
  802792:	68 64 01 00 00       	push   $0x164
  802797:	68 23 37 80 00       	push   $0x803723
  80279c:	e8 47 05 00 00       	call   802ce8 <_panic>
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	8b 40 08             	mov    0x8(%eax),%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	74 11                	je     8027bc <free_block+0x48f>
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8027b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8027ba:	eb 0b                	jmp    8027c7 <free_block+0x49a>
  8027bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c2:	a3 44 41 90 00       	mov    %eax,0x904144
  8027c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	74 11                	je     8027e2 <free_block+0x4b5>
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027da:	8b 52 08             	mov    0x8(%edx),%edx
  8027dd:	89 50 08             	mov    %edx,0x8(%eax)
  8027e0:	eb 0b                	jmp    8027ed <free_block+0x4c0>
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	8b 40 08             	mov    0x8(%eax),%eax
  8027e8:	a3 40 41 90 00       	mov    %eax,0x904140
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802801:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802806:	48                   	dec    %eax
  802807:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  80280c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802813:	e9 1a 01 00 00       	jmp    802932 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802818:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80281c:	0f 84 df 00 00 00    	je     802901 <free_block+0x5d4>
  802822:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802826:	0f 84 d5 00 00 00    	je     802901 <free_block+0x5d4>
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	8a 40 04             	mov    0x4(%eax),%al
  802832:	3c 01                	cmp    $0x1,%al
  802834:	0f 85 c7 00 00 00    	jne    802901 <free_block+0x5d4>
  80283a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283d:	8a 40 04             	mov    0x4(%eax),%al
  802840:	84 c0                	test   %al,%al
  802842:	0f 85 b9 00 00 00    	jne    802901 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	8b 10                	mov    (%eax),%edx
  802854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	01 c2                	add    %eax,%edx
  80285b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285e:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802870:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802874:	75 17                	jne    80288d <free_block+0x560>
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	68 be 37 80 00       	push   $0x8037be
  80287e:	68 6e 01 00 00       	push   $0x16e
  802883:	68 23 37 80 00       	push   $0x803723
  802888:	e8 5b 04 00 00       	call   802ce8 <_panic>
  80288d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802890:	8b 40 08             	mov    0x8(%eax),%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	74 11                	je     8028a8 <free_block+0x57b>
  802897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289a:	8b 40 08             	mov    0x8(%eax),%eax
  80289d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8028a3:	89 50 0c             	mov    %edx,0xc(%eax)
  8028a6:	eb 0b                	jmp    8028b3 <free_block+0x586>
  8028a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	a3 44 41 90 00       	mov    %eax,0x904144
  8028b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 11                	je     8028ce <free_block+0x5a1>
  8028bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c6:	8b 52 08             	mov    0x8(%edx),%edx
  8028c9:	89 50 08             	mov    %edx,0x8(%eax)
  8028cc:	eb 0b                	jmp    8028d9 <free_block+0x5ac>
  8028ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d1:	8b 40 08             	mov    0x8(%eax),%eax
  8028d4:	a3 40 41 90 00       	mov    %eax,0x904140
  8028d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028ed:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028f2:	48                   	dec    %eax
  8028f3:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  8028f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8028ff:	eb 31                	jmp    802932 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802905:	74 2b                	je     802932 <free_block+0x605>
  802907:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80290b:	74 25                	je     802932 <free_block+0x605>
  80290d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802910:	8a 40 04             	mov    0x4(%eax),%al
  802913:	84 c0                	test   %al,%al
  802915:	75 1b                	jne    802932 <free_block+0x605>
  802917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291a:	8a 40 04             	mov    0x4(%eax),%al
  80291d:	84 c0                	test   %al,%al
  80291f:	75 11                	jne    802932 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802928:	90                   	nop
  802929:	eb 07                	jmp    802932 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  80292b:	90                   	nop
  80292c:	eb 04                	jmp    802932 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  80292e:	90                   	nop
  80292f:	eb 01                	jmp    802932 <free_block+0x605>
	if (va == NULL)
		return;
  802931:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	57                   	push   %edi
  802938:	56                   	push   %esi
  802939:	53                   	push   %ebx
  80293a:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  80293d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802941:	75 19                	jne    80295c <realloc_block_FF+0x28>
  802943:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802947:	74 13                	je     80295c <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	ff 75 0c             	pushl  0xc(%ebp)
  80294f:	e8 0c f4 ff ff       	call   801d60 <alloc_block_FF>
  802954:	83 c4 10             	add    $0x10,%esp
  802957:	e9 84 03 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  80295c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802960:	75 3b                	jne    80299d <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802966:	75 17                	jne    80297f <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  802968:	83 ec 0c             	sub    $0xc,%esp
  80296b:	6a 00                	push   $0x0
  80296d:	e8 ee f3 ff ff       	call   801d60 <alloc_block_FF>
  802972:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802975:	b8 00 00 00 00       	mov    $0x0,%eax
  80297a:	e9 61 03 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  80297f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802983:	74 18                	je     80299d <realloc_block_FF+0x69>
		{
			free_block(va);
  802985:	83 ec 0c             	sub    $0xc,%esp
  802988:	ff 75 08             	pushl  0x8(%ebp)
  80298b:	e8 9d f9 ff ff       	call   80232d <free_block>
  802990:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	e9 43 03 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  80299d:	a1 40 41 90 00       	mov    0x904140,%eax
  8029a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029a5:	e9 02 03 00 00       	jmp    802cac <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	83 e8 10             	sub    $0x10,%eax
  8029b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029b3:	0f 85 eb 02 00 00    	jne    802ca4 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8029b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c1:	83 c2 10             	add    $0x10,%edx
  8029c4:	39 d0                	cmp    %edx,%eax
  8029c6:	75 08                	jne    8029d0 <realloc_block_FF+0x9c>
			{
				return va;
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	e9 10 03 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  8029d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029d8:	0f 83 e0 01 00 00    	jae    802bbe <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8029de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  8029e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ea:	8a 40 04             	mov    0x4(%eax),%al
  8029ed:	3c 01                	cmp    $0x1,%al
  8029ef:	0f 85 06 01 00 00    	jne    802afb <realloc_block_FF+0x1c7>
  8029f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f8:	8b 10                	mov    (%eax),%edx
  8029fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a02:	29 c1                	sub    %eax,%ecx
  802a04:	89 c8                	mov    %ecx,%eax
  802a06:	39 c2                	cmp    %eax,%edx
  802a08:	0f 86 ed 00 00 00    	jbe    802afb <realloc_block_FF+0x1c7>
  802a0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a12:	0f 84 e3 00 00 00    	je     802afb <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  802a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1b:	8b 10                	mov    (%eax),%edx
  802a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	2b 45 0c             	sub    0xc(%ebp),%eax
  802a25:	01 d0                	add    %edx,%eax
  802a27:	83 f8 0f             	cmp    $0xf,%eax
  802a2a:	0f 86 b5 00 00 00    	jbe    802ae5 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  802a30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a36:	01 d0                	add    %edx,%eax
  802a38:	83 c0 10             	add    $0x10,%eax
  802a3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  802a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  802a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a4a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a52:	74 06                	je     802a5a <realloc_block_FF+0x126>
  802a54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a58:	75 17                	jne    802a71 <realloc_block_FF+0x13d>
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 3c 37 80 00       	push   $0x80373c
  802a62:	68 ad 01 00 00       	push   $0x1ad
  802a67:	68 23 37 80 00       	push   $0x803723
  802a6c:	e8 77 02 00 00       	call   802ce8 <_panic>
  802a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a74:	8b 50 08             	mov    0x8(%eax),%edx
  802a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a7a:	89 50 08             	mov    %edx,0x8(%eax)
  802a7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a80:	8b 40 08             	mov    0x8(%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0c                	je     802a93 <realloc_block_FF+0x15f>
  802a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a8a:	8b 40 08             	mov    0x8(%eax),%eax
  802a8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a90:	89 50 0c             	mov    %edx,0xc(%eax)
  802a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a99:	89 50 08             	mov    %edx,0x8(%eax)
  802a9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa2:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	75 08                	jne    802ab7 <realloc_block_FF+0x183>
  802aaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab2:	a3 44 41 90 00       	mov    %eax,0x904144
  802ab7:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 4c 41 90 00       	mov    %eax,0x90414c
						next->size = 0;
  802ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  802acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ace:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  802ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad5:	8d 50 10             	lea    0x10(%eax),%edx
  802ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802adb:	89 10                	mov    %edx,(%eax)
						return va;
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	e9 fb 01 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  802ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae8:	8d 50 10             	lea    0x10(%eax),%edx
  802aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aee:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  802af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af3:	83 c0 10             	add    $0x10,%eax
  802af6:	e9 e5 01 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afe:	8a 40 04             	mov    0x4(%eax),%al
  802b01:	3c 01                	cmp    $0x1,%al
  802b03:	75 59                	jne    802b5e <realloc_block_FF+0x22a>
  802b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b08:	8b 10                	mov    (%eax),%edx
  802b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b12:	29 c1                	sub    %eax,%ecx
  802b14:	89 c8                	mov    %ecx,%eax
  802b16:	39 c2                	cmp    %eax,%edx
  802b18:	75 44                	jne    802b5e <realloc_block_FF+0x22a>
  802b1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b1e:	74 3e                	je     802b5e <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b2f:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802b32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b38:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b47:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4e:	8d 50 10             	lea    0x10(%eax),%edx
  802b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b54:	89 10                	mov    %edx,(%eax)
					return va;
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	e9 82 01 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b61:	8a 40 04             	mov    0x4(%eax),%al
  802b64:	84 c0                	test   %al,%al
  802b66:	74 0a                	je     802b72 <realloc_block_FF+0x23e>
  802b68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b6c:	0f 85 32 01 00 00    	jne    802ca4 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802b72:	83 ec 0c             	sub    $0xc,%esp
  802b75:	ff 75 0c             	pushl  0xc(%ebp)
  802b78:	e8 e3 f1 ff ff       	call   801d60 <alloc_block_FF>
  802b7d:	83 c4 10             	add    $0x10,%esp
  802b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  802b83:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b87:	74 2b                	je     802bb4 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  802b89:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	89 c3                	mov    %eax,%ebx
  802b91:	b8 04 00 00 00       	mov    $0x4,%eax
  802b96:	89 d7                	mov    %edx,%edi
  802b98:	89 de                	mov    %ebx,%esi
  802b9a:	89 c1                	mov    %eax,%ecx
  802b9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  802b9e:	83 ec 0c             	sub    $0xc,%esp
  802ba1:	ff 75 08             	pushl  0x8(%ebp)
  802ba4:	e8 84 f7 ff ff       	call   80232d <free_block>
  802ba9:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802bac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802baf:	e9 2c 01 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  802bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802bb9:	e9 22 01 00 00       	jmp    802ce0 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bc6:	0f 86 d8 00 00 00    	jbe    802ca4 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	2b 45 0c             	sub    0xc(%ebp),%eax
  802bd4:	83 f8 0f             	cmp    $0xf,%eax
  802bd7:	0f 86 b4 00 00 00    	jbe    802c91 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802bdd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be3:	01 d0                	add    %edx,%eax
  802be5:	83 c0 10             	add    $0x10,%eax
  802be8:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	2b 45 0c             	sub    0xc(%ebp),%eax
  802bf3:	8d 50 f0             	lea    -0x10(%eax),%edx
  802bf6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bf9:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802bfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bff:	74 06                	je     802c07 <realloc_block_FF+0x2d3>
  802c01:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802c05:	75 17                	jne    802c1e <realloc_block_FF+0x2ea>
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	68 3c 37 80 00       	push   $0x80373c
  802c0f:	68 dd 01 00 00       	push   $0x1dd
  802c14:	68 23 37 80 00       	push   $0x803723
  802c19:	e8 ca 00 00 00       	call   802ce8 <_panic>
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	8b 50 08             	mov    0x8(%eax),%edx
  802c24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c27:	89 50 08             	mov    %edx,0x8(%eax)
  802c2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c2d:	8b 40 08             	mov    0x8(%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 0c                	je     802c40 <realloc_block_FF+0x30c>
  802c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c37:	8b 40 08             	mov    0x8(%eax),%eax
  802c3a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c3d:	89 50 0c             	mov    %edx,0xc(%eax)
  802c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c43:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c46:	89 50 08             	mov    %edx,0x8(%eax)
  802c49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4f:	89 50 0c             	mov    %edx,0xc(%eax)
  802c52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	75 08                	jne    802c64 <realloc_block_FF+0x330>
  802c5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c5f:	a3 44 41 90 00       	mov    %eax,0x904144
  802c64:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c69:	40                   	inc    %eax
  802c6a:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  802c6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c72:	83 c0 10             	add    $0x10,%eax
  802c75:	83 ec 0c             	sub    $0xc,%esp
  802c78:	50                   	push   %eax
  802c79:	e8 af f6 ff ff       	call   80232d <free_block>
  802c7e:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  802c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c84:	8d 50 10             	lea    0x10(%eax),%edx
  802c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8a:	89 10                	mov    %edx,(%eax)
					return va;
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	eb 4f                	jmp    802ce0 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  802c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c94:	8d 50 10             	lea    0x10(%eax),%edx
  802c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9a:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  802c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9f:	83 c0 10             	add    $0x10,%eax
  802ca2:	eb 3c                	jmp    802ce0 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  802ca4:	a1 48 41 90 00       	mov    0x904148,%eax
  802ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802cac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cb0:	74 08                	je     802cba <realloc_block_FF+0x386>
  802cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb5:	8b 40 08             	mov    0x8(%eax),%eax
  802cb8:	eb 05                	jmp    802cbf <realloc_block_FF+0x38b>
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbf:	a3 48 41 90 00       	mov    %eax,0x904148
  802cc4:	a1 48 41 90 00       	mov    0x904148,%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	0f 85 d9 fc ff ff    	jne    8029aa <realloc_block_FF+0x76>
  802cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cd5:	0f 85 cf fc ff ff    	jne    8029aa <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  802cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ce3:	5b                   	pop    %ebx
  802ce4:	5e                   	pop    %esi
  802ce5:	5f                   	pop    %edi
  802ce6:	5d                   	pop    %ebp
  802ce7:	c3                   	ret    

00802ce8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802cee:	8d 45 10             	lea    0x10(%ebp),%eax
  802cf1:	83 c0 04             	add    $0x4,%eax
  802cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802cf7:	a1 50 41 90 00       	mov    0x904150,%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 16                	je     802d16 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802d00:	a1 50 41 90 00       	mov    0x904150,%eax
  802d05:	83 ec 08             	sub    $0x8,%esp
  802d08:	50                   	push   %eax
  802d09:	68 dc 37 80 00       	push   $0x8037dc
  802d0e:	e8 27 d6 ff ff       	call   80033a <cprintf>
  802d13:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802d16:	a1 00 40 80 00       	mov    0x804000,%eax
  802d1b:	ff 75 0c             	pushl  0xc(%ebp)
  802d1e:	ff 75 08             	pushl  0x8(%ebp)
  802d21:	50                   	push   %eax
  802d22:	68 e1 37 80 00       	push   $0x8037e1
  802d27:	e8 0e d6 ff ff       	call   80033a <cprintf>
  802d2c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d32:	83 ec 08             	sub    $0x8,%esp
  802d35:	ff 75 f4             	pushl  -0xc(%ebp)
  802d38:	50                   	push   %eax
  802d39:	e8 91 d5 ff ff       	call   8002cf <vcprintf>
  802d3e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802d41:	83 ec 08             	sub    $0x8,%esp
  802d44:	6a 00                	push   $0x0
  802d46:	68 fd 37 80 00       	push   $0x8037fd
  802d4b:	e8 7f d5 ff ff       	call   8002cf <vcprintf>
  802d50:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802d53:	e8 00 d5 ff ff       	call   800258 <exit>

	// should not return here
	while (1) ;
  802d58:	eb fe                	jmp    802d58 <_panic+0x70>

00802d5a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
  802d5d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802d60:	a1 20 40 80 00       	mov    0x804020,%eax
  802d65:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	74 14                	je     802d86 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	68 00 38 80 00       	push   $0x803800
  802d7a:	6a 26                	push   $0x26
  802d7c:	68 4c 38 80 00       	push   $0x80384c
  802d81:	e8 62 ff ff ff       	call   802ce8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802d8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802d94:	e9 c5 00 00 00       	jmp    802e5e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	01 d0                	add    %edx,%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	75 08                	jne    802db6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802dae:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802db1:	e9 a5 00 00 00       	jmp    802e5b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802db6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802dbd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802dc4:	eb 69                	jmp    802e2f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802dc6:	a1 20 40 80 00       	mov    0x804020,%eax
  802dcb:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802dd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd4:	89 d0                	mov    %edx,%eax
  802dd6:	01 c0                	add    %eax,%eax
  802dd8:	01 d0                	add    %edx,%eax
  802dda:	c1 e0 03             	shl    $0x3,%eax
  802ddd:	01 c8                	add    %ecx,%eax
  802ddf:	8a 40 04             	mov    0x4(%eax),%al
  802de2:	84 c0                	test   %al,%al
  802de4:	75 46                	jne    802e2c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802de6:	a1 20 40 80 00       	mov    0x804020,%eax
  802deb:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802df1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df4:	89 d0                	mov    %edx,%eax
  802df6:	01 c0                	add    %eax,%eax
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	c1 e0 03             	shl    $0x3,%eax
  802dfd:	01 c8                	add    %ecx,%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e0c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	01 c8                	add    %ecx,%eax
  802e1d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e1f:	39 c2                	cmp    %eax,%edx
  802e21:	75 09                	jne    802e2c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802e23:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802e2a:	eb 15                	jmp    802e41 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e2c:	ff 45 e8             	incl   -0x18(%ebp)
  802e2f:	a1 20 40 80 00       	mov    0x804020,%eax
  802e34:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	77 85                	ja     802dc6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802e41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e45:	75 14                	jne    802e5b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	68 58 38 80 00       	push   $0x803858
  802e4f:	6a 3a                	push   $0x3a
  802e51:	68 4c 38 80 00       	push   $0x80384c
  802e56:	e8 8d fe ff ff       	call   802ce8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802e5b:	ff 45 f0             	incl   -0x10(%ebp)
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e64:	0f 8c 2f ff ff ff    	jl     802d99 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802e6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e78:	eb 26                	jmp    802ea0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802e7a:	a1 20 40 80 00       	mov    0x804020,%eax
  802e7f:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802e85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e88:	89 d0                	mov    %edx,%eax
  802e8a:	01 c0                	add    %eax,%eax
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	c1 e0 03             	shl    $0x3,%eax
  802e91:	01 c8                	add    %ecx,%eax
  802e93:	8a 40 04             	mov    0x4(%eax),%al
  802e96:	3c 01                	cmp    $0x1,%al
  802e98:	75 03                	jne    802e9d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802e9a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e9d:	ff 45 e0             	incl   -0x20(%ebp)
  802ea0:	a1 20 40 80 00       	mov    0x804020,%eax
  802ea5:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eae:	39 c2                	cmp    %eax,%edx
  802eb0:	77 c8                	ja     802e7a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802eb8:	74 14                	je     802ece <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 ac 38 80 00       	push   $0x8038ac
  802ec2:	6a 44                	push   $0x44
  802ec4:	68 4c 38 80 00       	push   $0x80384c
  802ec9:	e8 1a fe ff ff       	call   802ce8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802ece:	90                   	nop
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    
  802ed1:	66 90                	xchg   %ax,%ax
  802ed3:	90                   	nop

00802ed4 <__udivdi3>:
  802ed4:	55                   	push   %ebp
  802ed5:	57                   	push   %edi
  802ed6:	56                   	push   %esi
  802ed7:	53                   	push   %ebx
  802ed8:	83 ec 1c             	sub    $0x1c,%esp
  802edb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802edf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ee7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802eeb:	89 ca                	mov    %ecx,%edx
  802eed:	89 f8                	mov    %edi,%eax
  802eef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ef3:	85 f6                	test   %esi,%esi
  802ef5:	75 2d                	jne    802f24 <__udivdi3+0x50>
  802ef7:	39 cf                	cmp    %ecx,%edi
  802ef9:	77 65                	ja     802f60 <__udivdi3+0x8c>
  802efb:	89 fd                	mov    %edi,%ebp
  802efd:	85 ff                	test   %edi,%edi
  802eff:	75 0b                	jne    802f0c <__udivdi3+0x38>
  802f01:	b8 01 00 00 00       	mov    $0x1,%eax
  802f06:	31 d2                	xor    %edx,%edx
  802f08:	f7 f7                	div    %edi
  802f0a:	89 c5                	mov    %eax,%ebp
  802f0c:	31 d2                	xor    %edx,%edx
  802f0e:	89 c8                	mov    %ecx,%eax
  802f10:	f7 f5                	div    %ebp
  802f12:	89 c1                	mov    %eax,%ecx
  802f14:	89 d8                	mov    %ebx,%eax
  802f16:	f7 f5                	div    %ebp
  802f18:	89 cf                	mov    %ecx,%edi
  802f1a:	89 fa                	mov    %edi,%edx
  802f1c:	83 c4 1c             	add    $0x1c,%esp
  802f1f:	5b                   	pop    %ebx
  802f20:	5e                   	pop    %esi
  802f21:	5f                   	pop    %edi
  802f22:	5d                   	pop    %ebp
  802f23:	c3                   	ret    
  802f24:	39 ce                	cmp    %ecx,%esi
  802f26:	77 28                	ja     802f50 <__udivdi3+0x7c>
  802f28:	0f bd fe             	bsr    %esi,%edi
  802f2b:	83 f7 1f             	xor    $0x1f,%edi
  802f2e:	75 40                	jne    802f70 <__udivdi3+0x9c>
  802f30:	39 ce                	cmp    %ecx,%esi
  802f32:	72 0a                	jb     802f3e <__udivdi3+0x6a>
  802f34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f38:	0f 87 9e 00 00 00    	ja     802fdc <__udivdi3+0x108>
  802f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f43:	89 fa                	mov    %edi,%edx
  802f45:	83 c4 1c             	add    $0x1c,%esp
  802f48:	5b                   	pop    %ebx
  802f49:	5e                   	pop    %esi
  802f4a:	5f                   	pop    %edi
  802f4b:	5d                   	pop    %ebp
  802f4c:	c3                   	ret    
  802f4d:	8d 76 00             	lea    0x0(%esi),%esi
  802f50:	31 ff                	xor    %edi,%edi
  802f52:	31 c0                	xor    %eax,%eax
  802f54:	89 fa                	mov    %edi,%edx
  802f56:	83 c4 1c             	add    $0x1c,%esp
  802f59:	5b                   	pop    %ebx
  802f5a:	5e                   	pop    %esi
  802f5b:	5f                   	pop    %edi
  802f5c:	5d                   	pop    %ebp
  802f5d:	c3                   	ret    
  802f5e:	66 90                	xchg   %ax,%ax
  802f60:	89 d8                	mov    %ebx,%eax
  802f62:	f7 f7                	div    %edi
  802f64:	31 ff                	xor    %edi,%edi
  802f66:	89 fa                	mov    %edi,%edx
  802f68:	83 c4 1c             	add    $0x1c,%esp
  802f6b:	5b                   	pop    %ebx
  802f6c:	5e                   	pop    %esi
  802f6d:	5f                   	pop    %edi
  802f6e:	5d                   	pop    %ebp
  802f6f:	c3                   	ret    
  802f70:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f75:	89 eb                	mov    %ebp,%ebx
  802f77:	29 fb                	sub    %edi,%ebx
  802f79:	89 f9                	mov    %edi,%ecx
  802f7b:	d3 e6                	shl    %cl,%esi
  802f7d:	89 c5                	mov    %eax,%ebp
  802f7f:	88 d9                	mov    %bl,%cl
  802f81:	d3 ed                	shr    %cl,%ebp
  802f83:	89 e9                	mov    %ebp,%ecx
  802f85:	09 f1                	or     %esi,%ecx
  802f87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f8b:	89 f9                	mov    %edi,%ecx
  802f8d:	d3 e0                	shl    %cl,%eax
  802f8f:	89 c5                	mov    %eax,%ebp
  802f91:	89 d6                	mov    %edx,%esi
  802f93:	88 d9                	mov    %bl,%cl
  802f95:	d3 ee                	shr    %cl,%esi
  802f97:	89 f9                	mov    %edi,%ecx
  802f99:	d3 e2                	shl    %cl,%edx
  802f9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f9f:	88 d9                	mov    %bl,%cl
  802fa1:	d3 e8                	shr    %cl,%eax
  802fa3:	09 c2                	or     %eax,%edx
  802fa5:	89 d0                	mov    %edx,%eax
  802fa7:	89 f2                	mov    %esi,%edx
  802fa9:	f7 74 24 0c          	divl   0xc(%esp)
  802fad:	89 d6                	mov    %edx,%esi
  802faf:	89 c3                	mov    %eax,%ebx
  802fb1:	f7 e5                	mul    %ebp
  802fb3:	39 d6                	cmp    %edx,%esi
  802fb5:	72 19                	jb     802fd0 <__udivdi3+0xfc>
  802fb7:	74 0b                	je     802fc4 <__udivdi3+0xf0>
  802fb9:	89 d8                	mov    %ebx,%eax
  802fbb:	31 ff                	xor    %edi,%edi
  802fbd:	e9 58 ff ff ff       	jmp    802f1a <__udivdi3+0x46>
  802fc2:	66 90                	xchg   %ax,%ax
  802fc4:	8b 54 24 08          	mov    0x8(%esp),%edx
  802fc8:	89 f9                	mov    %edi,%ecx
  802fca:	d3 e2                	shl    %cl,%edx
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	73 e9                	jae    802fb9 <__udivdi3+0xe5>
  802fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fd3:	31 ff                	xor    %edi,%edi
  802fd5:	e9 40 ff ff ff       	jmp    802f1a <__udivdi3+0x46>
  802fda:	66 90                	xchg   %ax,%ax
  802fdc:	31 c0                	xor    %eax,%eax
  802fde:	e9 37 ff ff ff       	jmp    802f1a <__udivdi3+0x46>
  802fe3:	90                   	nop

00802fe4 <__umoddi3>:
  802fe4:	55                   	push   %ebp
  802fe5:	57                   	push   %edi
  802fe6:	56                   	push   %esi
  802fe7:	53                   	push   %ebx
  802fe8:	83 ec 1c             	sub    $0x1c,%esp
  802feb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802fef:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ff7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ffb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803003:	89 f3                	mov    %esi,%ebx
  803005:	89 fa                	mov    %edi,%edx
  803007:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80300b:	89 34 24             	mov    %esi,(%esp)
  80300e:	85 c0                	test   %eax,%eax
  803010:	75 1a                	jne    80302c <__umoddi3+0x48>
  803012:	39 f7                	cmp    %esi,%edi
  803014:	0f 86 a2 00 00 00    	jbe    8030bc <__umoddi3+0xd8>
  80301a:	89 c8                	mov    %ecx,%eax
  80301c:	89 f2                	mov    %esi,%edx
  80301e:	f7 f7                	div    %edi
  803020:	89 d0                	mov    %edx,%eax
  803022:	31 d2                	xor    %edx,%edx
  803024:	83 c4 1c             	add    $0x1c,%esp
  803027:	5b                   	pop    %ebx
  803028:	5e                   	pop    %esi
  803029:	5f                   	pop    %edi
  80302a:	5d                   	pop    %ebp
  80302b:	c3                   	ret    
  80302c:	39 f0                	cmp    %esi,%eax
  80302e:	0f 87 ac 00 00 00    	ja     8030e0 <__umoddi3+0xfc>
  803034:	0f bd e8             	bsr    %eax,%ebp
  803037:	83 f5 1f             	xor    $0x1f,%ebp
  80303a:	0f 84 ac 00 00 00    	je     8030ec <__umoddi3+0x108>
  803040:	bf 20 00 00 00       	mov    $0x20,%edi
  803045:	29 ef                	sub    %ebp,%edi
  803047:	89 fe                	mov    %edi,%esi
  803049:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80304d:	89 e9                	mov    %ebp,%ecx
  80304f:	d3 e0                	shl    %cl,%eax
  803051:	89 d7                	mov    %edx,%edi
  803053:	89 f1                	mov    %esi,%ecx
  803055:	d3 ef                	shr    %cl,%edi
  803057:	09 c7                	or     %eax,%edi
  803059:	89 e9                	mov    %ebp,%ecx
  80305b:	d3 e2                	shl    %cl,%edx
  80305d:	89 14 24             	mov    %edx,(%esp)
  803060:	89 d8                	mov    %ebx,%eax
  803062:	d3 e0                	shl    %cl,%eax
  803064:	89 c2                	mov    %eax,%edx
  803066:	8b 44 24 08          	mov    0x8(%esp),%eax
  80306a:	d3 e0                	shl    %cl,%eax
  80306c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803070:	8b 44 24 08          	mov    0x8(%esp),%eax
  803074:	89 f1                	mov    %esi,%ecx
  803076:	d3 e8                	shr    %cl,%eax
  803078:	09 d0                	or     %edx,%eax
  80307a:	d3 eb                	shr    %cl,%ebx
  80307c:	89 da                	mov    %ebx,%edx
  80307e:	f7 f7                	div    %edi
  803080:	89 d3                	mov    %edx,%ebx
  803082:	f7 24 24             	mull   (%esp)
  803085:	89 c6                	mov    %eax,%esi
  803087:	89 d1                	mov    %edx,%ecx
  803089:	39 d3                	cmp    %edx,%ebx
  80308b:	0f 82 87 00 00 00    	jb     803118 <__umoddi3+0x134>
  803091:	0f 84 91 00 00 00    	je     803128 <__umoddi3+0x144>
  803097:	8b 54 24 04          	mov    0x4(%esp),%edx
  80309b:	29 f2                	sub    %esi,%edx
  80309d:	19 cb                	sbb    %ecx,%ebx
  80309f:	89 d8                	mov    %ebx,%eax
  8030a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030a5:	d3 e0                	shl    %cl,%eax
  8030a7:	89 e9                	mov    %ebp,%ecx
  8030a9:	d3 ea                	shr    %cl,%edx
  8030ab:	09 d0                	or     %edx,%eax
  8030ad:	89 e9                	mov    %ebp,%ecx
  8030af:	d3 eb                	shr    %cl,%ebx
  8030b1:	89 da                	mov    %ebx,%edx
  8030b3:	83 c4 1c             	add    $0x1c,%esp
  8030b6:	5b                   	pop    %ebx
  8030b7:	5e                   	pop    %esi
  8030b8:	5f                   	pop    %edi
  8030b9:	5d                   	pop    %ebp
  8030ba:	c3                   	ret    
  8030bb:	90                   	nop
  8030bc:	89 fd                	mov    %edi,%ebp
  8030be:	85 ff                	test   %edi,%edi
  8030c0:	75 0b                	jne    8030cd <__umoddi3+0xe9>
  8030c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c7:	31 d2                	xor    %edx,%edx
  8030c9:	f7 f7                	div    %edi
  8030cb:	89 c5                	mov    %eax,%ebp
  8030cd:	89 f0                	mov    %esi,%eax
  8030cf:	31 d2                	xor    %edx,%edx
  8030d1:	f7 f5                	div    %ebp
  8030d3:	89 c8                	mov    %ecx,%eax
  8030d5:	f7 f5                	div    %ebp
  8030d7:	89 d0                	mov    %edx,%eax
  8030d9:	e9 44 ff ff ff       	jmp    803022 <__umoddi3+0x3e>
  8030de:	66 90                	xchg   %ax,%ax
  8030e0:	89 c8                	mov    %ecx,%eax
  8030e2:	89 f2                	mov    %esi,%edx
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    
  8030ec:	3b 04 24             	cmp    (%esp),%eax
  8030ef:	72 06                	jb     8030f7 <__umoddi3+0x113>
  8030f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8030f5:	77 0f                	ja     803106 <__umoddi3+0x122>
  8030f7:	89 f2                	mov    %esi,%edx
  8030f9:	29 f9                	sub    %edi,%ecx
  8030fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8030ff:	89 14 24             	mov    %edx,(%esp)
  803102:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803106:	8b 44 24 04          	mov    0x4(%esp),%eax
  80310a:	8b 14 24             	mov    (%esp),%edx
  80310d:	83 c4 1c             	add    $0x1c,%esp
  803110:	5b                   	pop    %ebx
  803111:	5e                   	pop    %esi
  803112:	5f                   	pop    %edi
  803113:	5d                   	pop    %ebp
  803114:	c3                   	ret    
  803115:	8d 76 00             	lea    0x0(%esi),%esi
  803118:	2b 04 24             	sub    (%esp),%eax
  80311b:	19 fa                	sbb    %edi,%edx
  80311d:	89 d1                	mov    %edx,%ecx
  80311f:	89 c6                	mov    %eax,%esi
  803121:	e9 71 ff ff ff       	jmp    803097 <__umoddi3+0xb3>
  803126:	66 90                	xchg   %ax,%ax
  803128:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80312c:	72 ea                	jb     803118 <__umoddi3+0x134>
  80312e:	89 d9                	mov    %ebx,%ecx
  803130:	e9 62 ff ff ff       	jmp    803097 <__umoddi3+0xb3>
