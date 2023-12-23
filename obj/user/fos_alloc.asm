
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
  80004b:	e8 13 11 00 00       	call   801163 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 31 80 00       	push   $0x8031a0
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
  8000b9:	68 b3 31 80 00       	push   $0x8031b3
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
  8000d7:	e8 e3 11 00 00       	call   8012bf <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 79 10 00 00       	call   801163 <malloc>
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
  80010f:	68 b3 31 80 00       	push   $0x8031b3
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
  80012d:	e8 8d 11 00 00       	call   8012bf <free>
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
  80013e:	e8 ca 16 00 00       	call   80180d <sys_getenvindex>
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
  80019b:	e8 7a 14 00 00       	call   80161a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 d8 31 80 00       	push   $0x8031d8
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
  8001cb:	68 00 32 80 00       	push   $0x803200
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
  8001fc:	68 28 32 80 00       	push   $0x803228
  800201:	e8 34 01 00 00       	call   80033a <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800209:	a1 20 40 80 00       	mov    0x804020,%eax
  80020e:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 80 32 80 00       	push   $0x803280
  80021d:	e8 18 01 00 00       	call   80033a <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 d8 31 80 00       	push   $0x8031d8
  80022d:	e8 08 01 00 00       	call   80033a <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800235:	e8 fa 13 00 00       	call   801634 <sys_enable_interrupt>

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
  80024d:	e8 87 15 00 00       	call   8017d9 <sys_destroy_env>
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
  80025e:	e8 dc 15 00 00       	call   80183f <sys_exit_env>
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
  8002ac:	e8 10 12 00 00       	call   8014c1 <sys_cputs>
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
  800323:	e8 99 11 00 00       	call   8014c1 <sys_cputs>
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
  80036d:	e8 a8 12 00 00       	call   80161a <sys_disable_interrupt>
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
  80038d:	e8 a2 12 00 00       	call   801634 <sys_enable_interrupt>
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
  8003d7:	e8 50 2b 00 00       	call   802f2c <__udivdi3>
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
  800427:	e8 10 2c 00 00       	call   80303c <__umoddi3>
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	05 b4 34 80 00       	add    $0x8034b4,%eax
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
  800582:	8b 04 85 d8 34 80 00 	mov    0x8034d8(,%eax,4),%eax
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
  800663:	8b 34 9d 20 33 80 00 	mov    0x803320(,%ebx,4),%esi
  80066a:	85 f6                	test   %esi,%esi
  80066c:	75 19                	jne    800687 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80066e:	53                   	push   %ebx
  80066f:	68 c5 34 80 00       	push   $0x8034c5
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
  800688:	68 ce 34 80 00       	push   $0x8034ce
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
  8006b5:	be d1 34 80 00       	mov    $0x8034d1,%esi
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
	return dst;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801137:	a1 04 40 80 00       	mov    0x804004,%eax
  80113c:	85 c0                	test   %eax,%eax
  80113e:	74 0a                	je     80114a <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801140:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801147:	00 00 00 
	}
}
  80114a:	90                   	nop
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	ff 75 08             	pushl  0x8(%ebp)
  801159:	e8 7e 09 00 00       	call   801adc <sys_sbrk>
  80115e:	83 c4 10             	add    $0x10,%esp
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801169:	e8 c6 ff ff ff       	call   801134 <InitializeUHeap>
	if (size == 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	75 0a                	jne    80117e <malloc+0x1b>
		return NULL;
  801174:	b8 00 00 00 00       	mov    $0x0,%eax
  801179:	e9 3f 01 00 00       	jmp    8012bd <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80117e:	e8 ac 09 00 00       	call   801b2f <sys_get_hard_limit>
  801183:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801186:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  80118d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801190:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801195:	c1 e8 0c             	shr    $0xc,%eax
  801198:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  80119b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	48                   	dec    %eax
  8011ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8011ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b6:	f7 75 d8             	divl   -0x28(%ebp)
  8011b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bc:	29 d0                	sub    %edx,%eax
  8011be:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8011c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011c4:	c1 e8 0c             	shr    $0xc,%eax
  8011c7:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8011ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ce:	75 0a                	jne    8011da <malloc+0x77>
		return NULL;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d5:	e9 e3 00 00 00       	jmp    8012bd <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8011da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011dd:	05 00 00 00 80       	add    $0x80000000,%eax
  8011e2:	c1 e8 0c             	shr    $0xc,%eax
  8011e5:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8011ea:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8011f1:	77 19                	ja     80120c <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	ff 75 08             	pushl  0x8(%ebp)
  8011f9:	e8 60 0b 00 00       	call   801d5e <alloc_block_FF>
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801207:	e9 b1 00 00 00       	jmp    8012bd <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80120c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80120f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801212:	eb 4d                	jmp    801261 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801217:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  80121e:	84 c0                	test   %al,%al
  801220:	75 27                	jne    801249 <malloc+0xe6>
			{
				counter++;
  801222:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801225:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801229:	75 14                	jne    80123f <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80122b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80122e:	05 00 00 08 00       	add    $0x80000,%eax
  801233:	c1 e0 0c             	shl    $0xc,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  80123f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801242:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801245:	75 17                	jne    80125e <malloc+0xfb>
				{
					break;
  801247:	eb 21                	jmp    80126a <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80124c:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  801253:	3c 01                	cmp    $0x1,%al
  801255:	75 07                	jne    80125e <malloc+0xfb>
			{
				counter = 0;
  801257:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80125e:	ff 45 e8             	incl   -0x18(%ebp)
  801261:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801268:	76 aa                	jbe    801214 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80126a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80126d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801270:	75 46                	jne    8012b8 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	ff 75 d0             	pushl  -0x30(%ebp)
  801278:	ff 75 f4             	pushl  -0xc(%ebp)
  80127b:	e8 93 08 00 00       	call   801b13 <sys_allocate_user_mem>
  801280:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801286:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801289:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801296:	eb 0e                	jmp    8012a6 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129b:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  8012a2:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8012a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8012a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8012a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ac:	01 d0                	add    %edx,%eax
  8012ae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012b1:	77 e5                	ja     801298 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	eb 05                	jmp    8012bd <malloc+0x15a>
		}
	}

	return NULL;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8012c5:	e8 65 08 00 00       	call   801b2f <sys_get_hard_limit>
  8012ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8012d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d7:	0f 84 c1 00 00 00    	je     80139e <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8012dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	79 1b                	jns    8012ff <free+0x40>
  8012e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	73 13                	jae    8012ff <free+0x40>
    {
        free_block(virtual_address);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	ff 75 08             	pushl  0x8(%ebp)
  8012f2:	e8 34 10 00 00       	call   80232b <free_block>
  8012f7:	83 c4 10             	add    $0x10,%esp
    	return;
  8012fa:	e9 a6 00 00 00       	jmp    8013a5 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	05 00 10 00 00       	add    $0x1000,%eax
  801307:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80130a:	0f 87 91 00 00 00    	ja     8013a1 <free+0xe2>
  801310:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801317:	0f 87 84 00 00 00    	ja     8013a1 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80131d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801320:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80132e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801331:	05 00 00 00 80       	add    $0x80000000,%eax
  801336:	c1 e8 0c             	shr    $0xc,%eax
  801339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80133c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133f:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801346:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801349:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80134d:	74 55                	je     8013a4 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  80134f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801352:	c1 e8 0c             	shr    $0xc,%eax
  801355:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135b:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  801362:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136c:	eb 0e                	jmp    80137c <free+0xbd>
	{
		userArr[i].is_allocated=0;
  80136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801371:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  801378:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801379:	ff 45 f4             	incl   -0xc(%ebp)
  80137c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80137f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801382:	01 c2                	add    %eax,%edx
  801384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801387:	39 c2                	cmp    %eax,%edx
  801389:	77 e3                	ja     80136e <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	ff 75 e0             	pushl  -0x20(%ebp)
  801391:	ff 75 ec             	pushl  -0x14(%ebp)
  801394:	e8 5e 07 00 00       	call   801af7 <sys_free_user_mem>
  801399:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  80139c:	eb 07                	jmp    8013a5 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  80139e:	90                   	nop
  80139f:	eb 04                	jmp    8013a5 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8013a1:	90                   	nop
  8013a2:	eb 01                	jmp    8013a5 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8013a4:	90                   	nop
    else
     {
    	return;
      }

}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 18             	sub    $0x18,%esp
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013b3:	e8 7c fd ff ff       	call   801134 <InitializeUHeap>
	if (size == 0)
  8013b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013bc:	75 07                	jne    8013c5 <smalloc+0x1e>
		return NULL;
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	eb 17                	jmp    8013dc <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	68 30 36 80 00       	push   $0x803630
  8013cd:	68 ad 00 00 00       	push   $0xad
  8013d2:	68 56 36 80 00       	push   $0x803656
  8013d7:	e8 67 19 00 00       	call   802d43 <_panic>
	return NULL;
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013e4:	e8 4b fd ff ff       	call   801134 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	68 64 36 80 00       	push   $0x803664
  8013f1:	68 ba 00 00 00       	push   $0xba
  8013f6:	68 56 36 80 00       	push   $0x803656
  8013fb:	e8 43 19 00 00       	call   802d43 <_panic>

00801400 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801406:	e8 29 fd ff ff       	call   801134 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	68 88 36 80 00       	push   $0x803688
  801413:	68 d8 00 00 00       	push   $0xd8
  801418:	68 56 36 80 00       	push   $0x803656
  80141d:	e8 21 19 00 00       	call   802d43 <_panic>

00801422 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	68 b0 36 80 00       	push   $0x8036b0
  801430:	68 ea 00 00 00       	push   $0xea
  801435:	68 56 36 80 00       	push   $0x803656
  80143a:	e8 04 19 00 00       	call   802d43 <_panic>

0080143f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 d4 36 80 00       	push   $0x8036d4
  80144d:	68 f2 00 00 00       	push   $0xf2
  801452:	68 56 36 80 00       	push   $0x803656
  801457:	e8 e7 18 00 00       	call   802d43 <_panic>

0080145c <shrink>:

}
void shrink(uint32 newSize) {
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 d4 36 80 00       	push   $0x8036d4
  80146a:	68 f6 00 00 00       	push   $0xf6
  80146f:	68 56 36 80 00       	push   $0x803656
  801474:	e8 ca 18 00 00       	call   802d43 <_panic>

00801479 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 d4 36 80 00       	push   $0x8036d4
  801487:	68 fa 00 00 00       	push   $0xfa
  80148c:	68 56 36 80 00       	push   $0x803656
  801491:	e8 ad 18 00 00       	call   802d43 <_panic>

00801496 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	57                   	push   %edi
  80149a:	56                   	push   %esi
  80149b:	53                   	push   %ebx
  80149c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b1:	cd 30                	int    $0x30
  8014b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    

008014c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	52                   	push   %edx
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	50                   	push   %eax
  8014dd:	6a 00                	push   $0x0
  8014df:	e8 b2 ff ff ff       	call   801496 <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	90                   	nop
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 01                	push   $0x1
  8014f9:	e8 98 ff ff ff       	call   801496 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801506:	8b 55 0c             	mov    0xc(%ebp),%edx
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	52                   	push   %edx
  801513:	50                   	push   %eax
  801514:	6a 05                	push   $0x5
  801516:	e8 7b ff ff ff       	call   801496 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801525:	8b 75 18             	mov    0x18(%ebp),%esi
  801528:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
  801536:	51                   	push   %ecx
  801537:	52                   	push   %edx
  801538:	50                   	push   %eax
  801539:	6a 06                	push   $0x6
  80153b:	e8 56 ff ff ff       	call   801496 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    

0080154a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	6a 07                	push   $0x7
  80155d:	e8 34 ff ff ff       	call   801496 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	6a 08                	push   $0x8
  801578:	e8 19 ff ff ff       	call   801496 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 09                	push   $0x9
  801591:	e8 00 ff ff ff       	call   801496 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 0a                	push   $0xa
  8015aa:	e8 e7 fe ff ff       	call   801496 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 0b                	push   $0xb
  8015c3:	e8 ce fe ff ff       	call   801496 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 0c                	push   $0xc
  8015dc:	e8 b5 fe ff ff       	call   801496 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	6a 0d                	push   $0xd
  8015f6:	e8 9b fe ff ff       	call   801496 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 0e                	push   $0xe
  80160f:	e8 82 fe ff ff       	call   801496 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 11                	push   $0x11
  801629:	e8 68 fe ff ff       	call   801496 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	90                   	nop
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 12                	push   $0x12
  801643:	e8 4e fe ff ff       	call   801496 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_cputc>:


void
sys_cputc(const char c)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80165a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	50                   	push   %eax
  801667:	6a 13                	push   $0x13
  801669:	e8 28 fe ff ff       	call   801496 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	90                   	nop
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 14                	push   $0x14
  801683:	e8 0e fe ff ff       	call   801496 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	90                   	nop
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	50                   	push   %eax
  80169e:	6a 15                	push   $0x15
  8016a0:	e8 f1 fd ff ff       	call   801496 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	6a 18                	push   $0x18
  8016bd:	e8 d4 fd ff ff       	call   801496 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 16                	push   $0x16
  8016da:	e8 b7 fd ff ff       	call   801496 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	90                   	nop
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	52                   	push   %edx
  8016f5:	50                   	push   %eax
  8016f6:	6a 17                	push   $0x17
  8016f8:	e8 99 fd ff ff       	call   801496 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80170f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801712:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	51                   	push   %ecx
  80171c:	52                   	push   %edx
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	50                   	push   %eax
  801721:	6a 19                	push   $0x19
  801723:	e8 6e fd ff ff       	call   801496 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	52                   	push   %edx
  80173d:	50                   	push   %eax
  80173e:	6a 1a                	push   $0x1a
  801740:	e8 51 fd ff ff       	call   801496 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80174d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	51                   	push   %ecx
  80175b:	52                   	push   %edx
  80175c:	50                   	push   %eax
  80175d:	6a 1b                	push   $0x1b
  80175f:	e8 32 fd ff ff       	call   801496 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 1c                	push   $0x1c
  80177c:	e8 15 fd ff ff       	call   801496 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 1d                	push   $0x1d
  801795:	e8 fc fc ff ff       	call   801496 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 14             	pushl  0x14(%ebp)
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	50                   	push   %eax
  8017b1:	6a 1e                	push   $0x1e
  8017b3:	e8 de fc ff ff       	call   801496 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	50                   	push   %eax
  8017cc:	6a 1f                	push   $0x1f
  8017ce:	e8 c3 fc ff ff       	call   801496 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	90                   	nop
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	50                   	push   %eax
  8017e8:	6a 20                	push   $0x20
  8017ea:	e8 a7 fc ff ff       	call   801496 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 02                	push   $0x2
  801803:	e8 8e fc ff ff       	call   801496 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 03                	push   $0x3
  80181c:	e8 75 fc ff ff       	call   801496 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 04                	push   $0x4
  801835:	e8 5c fc ff ff       	call   801496 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_exit_env>:


void sys_exit_env(void)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 21                	push   $0x21
  80184e:	e8 43 fc ff ff       	call   801496 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80185f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801862:	8d 50 04             	lea    0x4(%eax),%edx
  801865:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	52                   	push   %edx
  80186f:	50                   	push   %eax
  801870:	6a 22                	push   $0x22
  801872:	e8 1f fc ff ff       	call   801496 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return result;
  80187a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801880:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801883:	89 01                	mov    %eax,(%ecx)
  801885:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	c9                   	leave  
  80188c:	c2 04 00             	ret    $0x4

0080188f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 10                	push   $0x10
  8018a1:	e8 f0 fb ff ff       	call   801496 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_rcr2>:
uint32 sys_rcr2()
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 23                	push   $0x23
  8018bb:	e8 d6 fb ff ff       	call   801496 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018d1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	50                   	push   %eax
  8018de:	6a 24                	push   $0x24
  8018e0:	e8 b1 fb ff ff       	call   801496 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e8:	90                   	nop
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <rsttst>:
void rsttst()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 26                	push   $0x26
  8018fa:	e8 97 fb ff ff       	call   801496 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	8b 45 14             	mov    0x14(%ebp),%eax
  80190e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801911:	8b 55 18             	mov    0x18(%ebp),%edx
  801914:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801918:	52                   	push   %edx
  801919:	50                   	push   %eax
  80191a:	ff 75 10             	pushl  0x10(%ebp)
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 25                	push   $0x25
  801925:	e8 6c fb ff ff       	call   801496 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <chktst>:
void chktst(uint32 n)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	6a 27                	push   $0x27
  801940:	e8 51 fb ff ff       	call   801496 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <inctst>:

void inctst()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 28                	push   $0x28
  80195a:	e8 37 fb ff ff       	call   801496 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
	return ;
  801962:	90                   	nop
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <gettst>:
uint32 gettst()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 29                	push   $0x29
  801974:	e8 1d fb ff ff       	call   801496 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 2a                	push   $0x2a
  801990:	e8 01 fb ff ff       	call   801496 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
  801998:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80199b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80199f:	75 07                	jne    8019a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	eb 05                	jmp    8019ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 2a                	push   $0x2a
  8019c1:	e8 d0 fa ff ff       	call   801496 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
  8019c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019cc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019d0:	75 07                	jne    8019d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d7:	eb 05                	jmp    8019de <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 2a                	push   $0x2a
  8019f2:	e8 9f fa ff ff       	call   801496 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
  8019fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019fd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a01:	75 07                	jne    801a0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a03:	b8 01 00 00 00       	mov    $0x1,%eax
  801a08:	eb 05                	jmp    801a0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 2a                	push   $0x2a
  801a23:	e8 6e fa ff ff       	call   801496 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
  801a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a2e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a32:	75 07                	jne    801a3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a34:	b8 01 00 00 00       	mov    $0x1,%eax
  801a39:	eb 05                	jmp    801a40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 2b                	push   $0x2b
  801a52:	e8 3f fa ff ff       	call   801496 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	53                   	push   %ebx
  801a70:	51                   	push   %ecx
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 2c                	push   $0x2c
  801a75:	e8 1c fa ff ff       	call   801496 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	6a 2d                	push   $0x2d
  801a95:	e8 fc f9 ff ff       	call   801496 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	51                   	push   %ecx
  801aae:	ff 75 10             	pushl  0x10(%ebp)
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 2e                	push   $0x2e
  801ab5:	e8 dc f9 ff ff       	call   801496 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 10             	pushl  0x10(%ebp)
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 0f                	push   $0xf
  801ad1:	e8 c0 f9 ff ff       	call   801496 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad9:	90                   	nop
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	50                   	push   %eax
  801aeb:	6a 2f                	push   $0x2f
  801aed:	e8 a4 f9 ff ff       	call   801496 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp

}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	6a 30                	push   $0x30
  801b08:	e8 89 f9 ff ff       	call   801496 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 31                	push   $0x31
  801b24:	e8 6d f9 ff ff       	call   801496 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
	return;
  801b2c:	90                   	nop
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 32                	push   $0x32
  801b3e:	e8 53 f9 ff ff       	call   801496 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	50                   	push   %eax
  801b57:	6a 33                	push   $0x33
  801b59:	e8 38 f9 ff ff       	call   801496 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	83 e8 10             	sub    $0x10,%eax
  801b70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b76:	8b 00                	mov    (%eax),%eax
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	83 e8 10             	sub    $0x10,%eax
  801b86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8c:	8a 40 04             	mov    0x4(%eax),%al
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801b97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba1:	83 f8 02             	cmp    $0x2,%eax
  801ba4:	74 2b                	je     801bd1 <alloc_block+0x40>
  801ba6:	83 f8 02             	cmp    $0x2,%eax
  801ba9:	7f 07                	jg     801bb2 <alloc_block+0x21>
  801bab:	83 f8 01             	cmp    $0x1,%eax
  801bae:	74 0e                	je     801bbe <alloc_block+0x2d>
  801bb0:	eb 58                	jmp    801c0a <alloc_block+0x79>
  801bb2:	83 f8 03             	cmp    $0x3,%eax
  801bb5:	74 2d                	je     801be4 <alloc_block+0x53>
  801bb7:	83 f8 04             	cmp    $0x4,%eax
  801bba:	74 3b                	je     801bf7 <alloc_block+0x66>
  801bbc:	eb 4c                	jmp    801c0a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	e8 95 01 00 00       	call   801d5e <alloc_block_FF>
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bcf:	eb 4a                	jmp    801c1b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 32 07 00 00       	call   80230e <alloc_block_NF>
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801be2:	eb 37                	jmp    801c1b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	e8 a3 04 00 00       	call   802092 <alloc_block_BF>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bf5:	eb 24                	jmp    801c1b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	e8 ef 06 00 00       	call   8022f1 <alloc_block_WF>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c08:	eb 11                	jmp    801c1b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	68 e4 36 80 00       	push   $0x8036e4
  801c12:	e8 23 e7 ff ff       	call   80033a <cprintf>
  801c17:	83 c4 10             	add    $0x10,%esp
		break;
  801c1a:	90                   	nop
	}
	return va;
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	68 04 37 80 00       	push   $0x803704
  801c2e:	e8 07 e7 ff ff       	call   80033a <cprintf>
  801c33:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	68 2f 37 80 00       	push   $0x80372f
  801c3e:	e8 f7 e6 ff ff       	call   80033a <cprintf>
  801c43:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4c:	eb 26                	jmp    801c74 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	8a 40 04             	mov    0x4(%eax),%al
  801c54:	0f b6 d0             	movzbl %al,%edx
  801c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5a:	8b 00                	mov    (%eax),%eax
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	68 47 37 80 00       	push   $0x803747
  801c66:	e8 cf e6 ff ff       	call   80033a <cprintf>
  801c6b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c78:	74 08                	je     801c82 <print_blocks_list+0x62>
  801c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7d:	8b 40 08             	mov    0x8(%eax),%eax
  801c80:	eb 05                	jmp    801c87 <print_blocks_list+0x67>
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	89 45 10             	mov    %eax,0x10(%ebp)
  801c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	75 bd                	jne    801c4e <print_blocks_list+0x2e>
  801c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c95:	75 b7                	jne    801c4e <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	68 04 37 80 00       	push   $0x803704
  801c9f:	e8 96 e6 ff ff       	call   80033a <cprintf>
  801ca4:	83 c4 10             	add    $0x10,%esp

}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  801cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb4:	0f 84 a1 00 00 00    	je     801d5b <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  801cba:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  801cc1:	00 00 00 
	LIST_INIT(&list);
  801cc4:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  801ccb:	00 00 00 
  801cce:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  801cd5:	00 00 00 
  801cd8:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  801cdf:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  801cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfb:	75 14                	jne    801d11 <initialize_dynamic_allocator+0x67>
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 60 37 80 00       	push   $0x803760
  801d05:	6a 64                	push   $0x64
  801d07:	68 83 37 80 00       	push   $0x803783
  801d0c:	e8 32 10 00 00       	call   802d43 <_panic>
  801d11:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	89 50 0c             	mov    %edx,0xc(%eax)
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	8b 40 0c             	mov    0xc(%eax),%eax
  801d23:	85 c0                	test   %eax,%eax
  801d25:	74 0d                	je     801d34 <initialize_dynamic_allocator+0x8a>
  801d27:	a1 44 41 90 00       	mov    0x904144,%eax
  801d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2f:	89 50 08             	mov    %edx,0x8(%eax)
  801d32:	eb 08                	jmp    801d3c <initialize_dynamic_allocator+0x92>
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	a3 40 41 90 00       	mov    %eax,0x904140
  801d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3f:	a3 44 41 90 00       	mov    %eax,0x904144
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d4e:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801d53:	40                   	inc    %eax
  801d54:	a3 4c 41 90 00       	mov    %eax,0x90414c
  801d59:	eb 01                	jmp    801d5c <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  801d5b:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  801d64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d68:	75 0a                	jne    801d74 <alloc_block_FF+0x16>
	{
		return NULL;
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6f:	e9 1c 03 00 00       	jmp    802090 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  801d74:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	75 40                	jne    801dbd <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	83 c0 10             	add    $0x10,%eax
  801d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	50                   	push   %eax
  801d8d:	e8 bb f3 ff ff       	call   80114d <sbrk>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 ab f3 ff ff       	call   80114d <sbrk>
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  801da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dab:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801dae:	83 ec 08             	sub    $0x8,%esp
  801db1:	50                   	push   %eax
  801db2:	ff 75 ec             	pushl  -0x14(%ebp)
  801db5:	e8 f0 fe ff ff       	call   801caa <initialize_dynamic_allocator>
  801dba:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  801dbd:	a1 40 41 90 00       	mov    0x904140,%eax
  801dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc5:	e9 1e 01 00 00       	jmp    801ee8 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	8d 50 10             	lea    0x10(%eax),%edx
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	8b 00                	mov    (%eax),%eax
  801dd5:	39 c2                	cmp    %eax,%edx
  801dd7:	75 1c                	jne    801df5 <alloc_block_FF+0x97>
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8a 40 04             	mov    0x4(%eax),%al
  801ddf:	3c 01                	cmp    $0x1,%al
  801de1:	75 12                	jne    801df5 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	83 c0 10             	add    $0x10,%eax
  801df0:	e9 9b 02 00 00       	jmp    802090 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8d 50 10             	lea    0x10(%eax),%edx
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	39 c2                	cmp    %eax,%edx
  801e02:	0f 83 d8 00 00 00    	jae    801ee0 <alloc_block_FF+0x182>
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8a 40 04             	mov    0x4(%eax),%al
  801e0e:	3c 01                	cmp    $0x1,%al
  801e10:	0f 85 ca 00 00 00    	jne    801ee0 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 00                	mov    (%eax),%eax
  801e1b:	2b 45 08             	sub    0x8(%ebp),%eax
  801e1e:	83 e8 10             	sub    $0x10,%eax
  801e21:	83 f8 0f             	cmp    $0xf,%eax
  801e24:	0f 86 a4 00 00 00    	jbe    801ece <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  801e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	01 d0                	add    %edx,%eax
  801e32:	83 c0 10             	add    $0x10,%eax
  801e35:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  801e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	2b 45 08             	sub    0x8(%ebp),%eax
  801e40:	8d 50 f0             	lea    -0x10(%eax),%edx
  801e43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e46:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  801e48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4b:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  801e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e53:	74 06                	je     801e5b <alloc_block_FF+0xfd>
  801e55:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801e59:	75 17                	jne    801e72 <alloc_block_FF+0x114>
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	68 9c 37 80 00       	push   $0x80379c
  801e63:	68 8f 00 00 00       	push   $0x8f
  801e68:	68 83 37 80 00       	push   $0x803783
  801e6d:	e8 d1 0e 00 00       	call   802d43 <_panic>
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 50 08             	mov    0x8(%eax),%edx
  801e78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e7b:	89 50 08             	mov    %edx,0x8(%eax)
  801e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e81:	8b 40 08             	mov    0x8(%eax),%eax
  801e84:	85 c0                	test   %eax,%eax
  801e86:	74 0c                	je     801e94 <alloc_block_FF+0x136>
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 40 08             	mov    0x8(%eax),%eax
  801e8e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e91:	89 50 0c             	mov    %edx,0xc(%eax)
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e9a:	89 50 08             	mov    %edx,0x8(%eax)
  801e9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea3:	89 50 0c             	mov    %edx,0xc(%eax)
  801ea6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	85 c0                	test   %eax,%eax
  801eae:	75 08                	jne    801eb8 <alloc_block_FF+0x15a>
  801eb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eb3:	a3 44 41 90 00       	mov    %eax,0x904144
  801eb8:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801ebd:	40                   	inc    %eax
  801ebe:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	8d 50 10             	lea    0x10(%eax),%edx
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	83 c0 10             	add    $0x10,%eax
  801edb:	e9 b0 01 00 00       	jmp    802090 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  801ee0:	a1 48 41 90 00       	mov    0x904148,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eec:	74 08                	je     801ef6 <alloc_block_FF+0x198>
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 40 08             	mov    0x8(%eax),%eax
  801ef4:	eb 05                	jmp    801efb <alloc_block_FF+0x19d>
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	a3 48 41 90 00       	mov    %eax,0x904148
  801f00:	a1 48 41 90 00       	mov    0x904148,%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	0f 85 bd fe ff ff    	jne    801dca <alloc_block_FF+0x6c>
  801f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f11:	0f 85 b3 fe ff ff    	jne    801dca <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	83 c0 10             	add    $0x10,%eax
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	50                   	push   %eax
  801f21:	e8 27 f2 ff ff       	call   80114d <sbrk>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	6a 00                	push   $0x0
  801f31:	e8 17 f2 ff ff       	call   80114d <sbrk>
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  801f3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f42:	29 c2                	sub    %eax,%edx
  801f44:	89 d0                	mov    %edx,%eax
  801f46:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  801f49:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801f4d:	0f 84 38 01 00 00    	je     80208b <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  801f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f56:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  801f59:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f5d:	75 17                	jne    801f76 <alloc_block_FF+0x218>
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 60 37 80 00       	push   $0x803760
  801f67:	68 9f 00 00 00       	push   $0x9f
  801f6c:	68 83 37 80 00       	push   $0x803783
  801f71:	e8 cd 0d 00 00       	call   802d43 <_panic>
  801f76:	8b 15 44 41 90 00    	mov    0x904144,%edx
  801f7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f7f:	89 50 0c             	mov    %edx,0xc(%eax)
  801f82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f85:	8b 40 0c             	mov    0xc(%eax),%eax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	74 0d                	je     801f99 <alloc_block_FF+0x23b>
  801f8c:	a1 44 41 90 00       	mov    0x904144,%eax
  801f91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f94:	89 50 08             	mov    %edx,0x8(%eax)
  801f97:	eb 08                	jmp    801fa1 <alloc_block_FF+0x243>
  801f99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f9c:	a3 40 41 90 00       	mov    %eax,0x904140
  801fa1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fa4:	a3 44 41 90 00       	mov    %eax,0x904144
  801fa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fb3:	a1 4c 41 90 00       	mov    0x90414c,%eax
  801fb8:	40                   	inc    %eax
  801fb9:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8d 50 10             	lea    0x10(%eax),%edx
  801fc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fc7:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  801fc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fcc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  801fd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fd3:	2b 45 08             	sub    0x8(%ebp),%eax
  801fd6:	83 f8 10             	cmp    $0x10,%eax
  801fd9:	0f 84 a4 00 00 00    	je     802083 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  801fdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe2:	2b 45 08             	sub    0x8(%ebp),%eax
  801fe5:	83 e8 10             	sub    $0x10,%eax
  801fe8:	83 f8 0f             	cmp    $0xf,%eax
  801feb:	0f 86 8a 00 00 00    	jbe    80207b <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  801ff1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	01 d0                	add    %edx,%eax
  801ff9:	83 c0 10             	add    $0x10,%eax
  801ffc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  801fff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802003:	75 17                	jne    80201c <alloc_block_FF+0x2be>
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	68 60 37 80 00       	push   $0x803760
  80200d:	68 a7 00 00 00       	push   $0xa7
  802012:	68 83 37 80 00       	push   $0x803783
  802017:	e8 27 0d 00 00       	call   802d43 <_panic>
  80201c:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802022:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802025:	89 50 0c             	mov    %edx,0xc(%eax)
  802028:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202b:	8b 40 0c             	mov    0xc(%eax),%eax
  80202e:	85 c0                	test   %eax,%eax
  802030:	74 0d                	je     80203f <alloc_block_FF+0x2e1>
  802032:	a1 44 41 90 00       	mov    0x904144,%eax
  802037:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80203a:	89 50 08             	mov    %edx,0x8(%eax)
  80203d:	eb 08                	jmp    802047 <alloc_block_FF+0x2e9>
  80203f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802042:	a3 40 41 90 00       	mov    %eax,0x904140
  802047:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80204a:	a3 44 41 90 00       	mov    %eax,0x904144
  80204f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802059:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80205e:	40                   	inc    %eax
  80205f:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802064:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802067:	2b 45 08             	sub    0x8(%ebp),%eax
  80206a:	8d 50 f0             	lea    -0x10(%eax),%edx
  80206d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802070:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802072:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802075:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802079:	eb 08                	jmp    802083 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  80207b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80207e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802081:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802083:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802086:	83 c0 10             	add    $0x10,%eax
  802089:	eb 05                	jmp    802090 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802098:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  80209f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a3:	75 0a                	jne    8020af <alloc_block_BF+0x1d>
	{
		return NULL;
  8020a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020aa:	e9 40 02 00 00       	jmp    8022ef <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8020af:	a1 40 41 90 00       	mov    0x904140,%eax
  8020b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b7:	eb 66                	jmp    80211f <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	8a 40 04             	mov    0x4(%eax),%al
  8020bf:	3c 01                	cmp    $0x1,%al
  8020c1:	75 21                	jne    8020e4 <alloc_block_BF+0x52>
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8d 50 10             	lea    0x10(%eax),%edx
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	39 c2                	cmp    %eax,%edx
  8020d0:	75 12                	jne    8020e4 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	83 c0 10             	add    $0x10,%eax
  8020df:	e9 0b 02 00 00       	jmp    8022ef <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8a 40 04             	mov    0x4(%eax),%al
  8020ea:	3c 01                	cmp    $0x1,%al
  8020ec:	75 29                	jne    802117 <alloc_block_BF+0x85>
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8d 50 10             	lea    0x10(%eax),%edx
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 00                	mov    (%eax),%eax
  8020f9:	39 c2                	cmp    %eax,%edx
  8020fb:	77 1a                	ja     802117 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8020fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802101:	74 0e                	je     802111 <alloc_block_BF+0x7f>
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 10                	mov    (%eax),%edx
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	8b 00                	mov    (%eax),%eax
  80210d:	39 c2                	cmp    %eax,%edx
  80210f:	73 06                	jae    802117 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802117:	a1 48 41 90 00       	mov    0x904148,%eax
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802123:	74 08                	je     80212d <alloc_block_BF+0x9b>
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	8b 40 08             	mov    0x8(%eax),%eax
  80212b:	eb 05                	jmp    802132 <alloc_block_BF+0xa0>
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
  802132:	a3 48 41 90 00       	mov    %eax,0x904148
  802137:	a1 48 41 90 00       	mov    0x904148,%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 85 75 ff ff ff    	jne    8020b9 <alloc_block_BF+0x27>
  802144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802148:	0f 85 6b ff ff ff    	jne    8020b9 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  80214e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802152:	0f 84 f8 00 00 00    	je     802250 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	8d 50 10             	lea    0x10(%eax),%edx
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	0f 87 e5 00 00 00    	ja     802250 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	2b 45 08             	sub    0x8(%ebp),%eax
  802173:	83 e8 10             	sub    $0x10,%eax
  802176:	83 f8 0f             	cmp    $0xf,%eax
  802179:	0f 86 bf 00 00 00    	jbe    80223e <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  80217f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	01 d0                	add    %edx,%eax
  802187:	83 c0 10             	add    $0x10,%eax
  80218a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  80218d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	8b 00                	mov    (%eax),%eax
  80219b:	2b 45 08             	sub    0x8(%ebp),%eax
  80219e:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a4:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8021a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8021ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b1:	74 06                	je     8021b9 <alloc_block_BF+0x127>
  8021b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021b7:	75 17                	jne    8021d0 <alloc_block_BF+0x13e>
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 9c 37 80 00       	push   $0x80379c
  8021c1:	68 e3 00 00 00       	push   $0xe3
  8021c6:	68 83 37 80 00       	push   $0x803783
  8021cb:	e8 73 0b 00 00       	call   802d43 <_panic>
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d9:	89 50 08             	mov    %edx,0x8(%eax)
  8021dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021df:	8b 40 08             	mov    0x8(%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0c                	je     8021f2 <alloc_block_BF+0x160>
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ef:	89 50 0c             	mov    %edx,0xc(%eax)
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f8:	89 50 08             	mov    %edx,0x8(%eax)
  8021fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802201:	89 50 0c             	mov    %edx,0xc(%eax)
  802204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802207:	8b 40 08             	mov    0x8(%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	75 08                	jne    802216 <alloc_block_BF+0x184>
  80220e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802211:	a3 44 41 90 00       	mov    %eax,0x904144
  802216:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80221b:	40                   	inc    %eax
  80221c:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	8d 50 10             	lea    0x10(%eax),%edx
  802227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222a:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80222c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222f:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	83 c0 10             	add    $0x10,%eax
  802239:	e9 b1 00 00 00       	jmp    8022ef <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	83 c0 10             	add    $0x10,%eax
  80224b:	e9 9f 00 00 00       	jmp    8022ef <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	83 c0 10             	add    $0x10,%eax
  802256:	83 ec 0c             	sub    $0xc,%esp
  802259:	50                   	push   %eax
  80225a:	e8 ee ee ff ff       	call   80114d <sbrk>
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802265:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802269:	74 7f                	je     8022ea <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  80226b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80226f:	75 17                	jne    802288 <alloc_block_BF+0x1f6>
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 60 37 80 00       	push   $0x803760
  802279:	68 f6 00 00 00       	push   $0xf6
  80227e:	68 83 37 80 00       	push   $0x803783
  802283:	e8 bb 0a 00 00       	call   802d43 <_panic>
  802288:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80228e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802291:	89 50 0c             	mov    %edx,0xc(%eax)
  802294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802297:	8b 40 0c             	mov    0xc(%eax),%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	74 0d                	je     8022ab <alloc_block_BF+0x219>
  80229e:	a1 44 41 90 00       	mov    0x904144,%eax
  8022a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a6:	89 50 08             	mov    %edx,0x8(%eax)
  8022a9:	eb 08                	jmp    8022b3 <alloc_block_BF+0x221>
  8022ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ae:	a3 40 41 90 00       	mov    %eax,0x904140
  8022b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b6:	a3 44 41 90 00       	mov    %eax,0x904144
  8022bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022c5:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8022ca:	40                   	inc    %eax
  8022cb:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	8d 50 10             	lea    0x10(%eax),%edx
  8022d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8022db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022de:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8022e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e5:	83 c0 10             	add    $0x10,%eax
  8022e8:	eb 05                	jmp    8022ef <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 d0 37 80 00       	push   $0x8037d0
  8022ff:	68 07 01 00 00       	push   $0x107
  802304:	68 83 37 80 00       	push   $0x803783
  802309:	e8 35 0a 00 00       	call   802d43 <_panic>

0080230e <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	68 f8 37 80 00       	push   $0x8037f8
  80231c:	68 0f 01 00 00       	push   $0x10f
  802321:	68 83 37 80 00       	push   $0x803783
  802326:	e8 18 0a 00 00       	call   802d43 <_panic>

0080232b <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802335:	0f 84 ee 05 00 00    	je     802929 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	83 e8 10             	sub    $0x10,%eax
  802341:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802344:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802348:	a1 40 41 90 00       	mov    0x904140,%eax
  80234d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802350:	eb 16                	jmp    802368 <free_block+0x3d>
	{
		if (block_pointer == it)
  802352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802355:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802358:	75 06                	jne    802360 <free_block+0x35>
		{
			flagx = 1;
  80235a:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  80235e:	eb 2f                	jmp    80238f <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802360:	a1 48 41 90 00       	mov    0x904148,%eax
  802365:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802368:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236c:	74 08                	je     802376 <free_block+0x4b>
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	8b 40 08             	mov    0x8(%eax),%eax
  802374:	eb 05                	jmp    80237b <free_block+0x50>
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	a3 48 41 90 00       	mov    %eax,0x904148
  802380:	a1 48 41 90 00       	mov    0x904148,%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	75 c9                	jne    802352 <free_block+0x27>
  802389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80238d:	75 c3                	jne    802352 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  80238f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802393:	0f 84 93 05 00 00    	je     80292c <free_block+0x601>
		return;
	if (va == NULL)
  802399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239d:	0f 84 8c 05 00 00    	je     80292f <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8023ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023af:	8b 40 08             	mov    0x8(%eax),%eax
  8023b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8023b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023b9:	75 12                	jne    8023cd <free_block+0xa2>
  8023bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023bf:	75 0c                	jne    8023cd <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8023c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8023c8:	e9 63 05 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8023cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023d1:	0f 85 ca 00 00 00    	jne    8024a1 <free_block+0x176>
  8023d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023da:	8a 40 04             	mov    0x4(%eax),%al
  8023dd:	3c 01                	cmp    $0x1,%al
  8023df:	0f 85 bc 00 00 00    	jne    8024a1 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8023ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ef:	8b 10                	mov    (%eax),%edx
  8023f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	01 c2                	add    %eax,%edx
  8023f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fb:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8023fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802409:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80240d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802411:	75 17                	jne    80242a <free_block+0xff>
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	68 1e 38 80 00       	push   $0x80381e
  80241b:	68 3c 01 00 00       	push   $0x13c
  802420:	68 83 37 80 00       	push   $0x803783
  802425:	e8 19 09 00 00       	call   802d43 <_panic>
  80242a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242d:	8b 40 08             	mov    0x8(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 11                	je     802445 <free_block+0x11a>
  802434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802437:	8b 40 08             	mov    0x8(%eax),%eax
  80243a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80243d:	8b 52 0c             	mov    0xc(%edx),%edx
  802440:	89 50 0c             	mov    %edx,0xc(%eax)
  802443:	eb 0b                	jmp    802450 <free_block+0x125>
  802445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	a3 44 41 90 00       	mov    %eax,0x904144
  802450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802453:	8b 40 0c             	mov    0xc(%eax),%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	74 11                	je     80246b <free_block+0x140>
  80245a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245d:	8b 40 0c             	mov    0xc(%eax),%eax
  802460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802463:	8b 52 08             	mov    0x8(%edx),%edx
  802466:	89 50 08             	mov    %edx,0x8(%eax)
  802469:	eb 0b                	jmp    802476 <free_block+0x14b>
  80246b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246e:	8b 40 08             	mov    0x8(%eax),%eax
  802471:	a3 40 41 90 00       	mov    %eax,0x904140
  802476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802479:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802483:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80248a:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802495:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80249c:	e9 8f 04 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8024a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024a5:	75 16                	jne    8024bd <free_block+0x192>
  8024a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024aa:	8a 40 04             	mov    0x4(%eax),%al
  8024ad:	84 c0                	test   %al,%al
  8024af:	75 0c                	jne    8024bd <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8024b8:	e9 73 04 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8024bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024c1:	0f 85 c3 00 00 00    	jne    80258a <free_block+0x25f>
  8024c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ca:	8a 40 04             	mov    0x4(%eax),%al
  8024cd:	3c 01                	cmp    $0x1,%al
  8024cf:	0f 85 b5 00 00 00    	jne    80258a <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8024d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d8:	8b 10                	mov    (%eax),%edx
  8024da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	01 c2                	add    %eax,%edx
  8024e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e4:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8024e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8024ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8024f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024fa:	75 17                	jne    802513 <free_block+0x1e8>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 1e 38 80 00       	push   $0x80381e
  802504:	68 49 01 00 00       	push   $0x149
  802509:	68 83 37 80 00       	push   $0x803783
  80250e:	e8 30 08 00 00       	call   802d43 <_panic>
  802513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802516:	8b 40 08             	mov    0x8(%eax),%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	74 11                	je     80252e <free_block+0x203>
  80251d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802520:	8b 40 08             	mov    0x8(%eax),%eax
  802523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802526:	8b 52 0c             	mov    0xc(%edx),%edx
  802529:	89 50 0c             	mov    %edx,0xc(%eax)
  80252c:	eb 0b                	jmp    802539 <free_block+0x20e>
  80252e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802531:	8b 40 0c             	mov    0xc(%eax),%eax
  802534:	a3 44 41 90 00       	mov    %eax,0x904144
  802539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 11                	je     802554 <free_block+0x229>
  802543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802546:	8b 40 0c             	mov    0xc(%eax),%eax
  802549:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254c:	8b 52 08             	mov    0x8(%edx),%edx
  80254f:	89 50 08             	mov    %edx,0x8(%eax)
  802552:	eb 0b                	jmp    80255f <free_block+0x234>
  802554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802557:	8b 40 08             	mov    0x8(%eax),%eax
  80255a:	a3 40 41 90 00       	mov    %eax,0x904140
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802573:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802578:	48                   	dec    %eax
  802579:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  80257e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802585:	e9 a6 03 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  80258a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80258e:	75 16                	jne    8025a6 <free_block+0x27b>
  802590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802593:	8a 40 04             	mov    0x4(%eax),%al
  802596:	84 c0                	test   %al,%al
  802598:	75 0c                	jne    8025a6 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  80259a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8025a1:	e9 8a 03 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8025a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025aa:	0f 84 81 01 00 00    	je     802731 <free_block+0x406>
  8025b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025b4:	0f 84 77 01 00 00    	je     802731 <free_block+0x406>
  8025ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bd:	8a 40 04             	mov    0x4(%eax),%al
  8025c0:	3c 01                	cmp    $0x1,%al
  8025c2:	0f 85 69 01 00 00    	jne    802731 <free_block+0x406>
  8025c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025cb:	8a 40 04             	mov    0x4(%eax),%al
  8025ce:	3c 01                	cmp    $0x1,%al
  8025d0:	0f 85 5b 01 00 00    	jne    802731 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8025d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d9:	8b 10                	mov    (%eax),%edx
  8025db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025de:	8b 08                	mov    (%eax),%ecx
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	01 c8                	add    %ecx,%eax
  8025e7:	01 c2                	add    %eax,%edx
  8025e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ec:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8025ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8025f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fa:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80260e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802612:	75 17                	jne    80262b <free_block+0x300>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 1e 38 80 00       	push   $0x80381e
  80261c:	68 59 01 00 00       	push   $0x159
  802621:	68 83 37 80 00       	push   $0x803783
  802626:	e8 18 07 00 00       	call   802d43 <_panic>
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	8b 40 08             	mov    0x8(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 11                	je     802646 <free_block+0x31b>
  802635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802638:	8b 40 08             	mov    0x8(%eax),%eax
  80263b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263e:	8b 52 0c             	mov    0xc(%edx),%edx
  802641:	89 50 0c             	mov    %edx,0xc(%eax)
  802644:	eb 0b                	jmp    802651 <free_block+0x326>
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	a3 44 41 90 00       	mov    %eax,0x904144
  802651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 11                	je     80266c <free_block+0x341>
  80265b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265e:	8b 40 0c             	mov    0xc(%eax),%eax
  802661:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802664:	8b 52 08             	mov    0x8(%edx),%edx
  802667:	89 50 08             	mov    %edx,0x8(%eax)
  80266a:	eb 0b                	jmp    802677 <free_block+0x34c>
  80266c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266f:	8b 40 08             	mov    0x8(%eax),%eax
  802672:	a3 40 41 90 00       	mov    %eax,0x904140
  802677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80268b:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802690:	48                   	dec    %eax
  802691:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80269a:	75 17                	jne    8026b3 <free_block+0x388>
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	68 1e 38 80 00       	push   $0x80381e
  8026a4:	68 5a 01 00 00       	push   $0x15a
  8026a9:	68 83 37 80 00       	push   $0x803783
  8026ae:	e8 90 06 00 00       	call   802d43 <_panic>
  8026b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b6:	8b 40 08             	mov    0x8(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 11                	je     8026ce <free_block+0x3a3>
  8026bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8026c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8026cc:	eb 0b                	jmp    8026d9 <free_block+0x3ae>
  8026ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	a3 44 41 90 00       	mov    %eax,0x904144
  8026d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	74 11                	je     8026f4 <free_block+0x3c9>
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ec:	8b 52 08             	mov    0x8(%edx),%edx
  8026ef:	89 50 08             	mov    %edx,0x8(%eax)
  8026f2:	eb 0b                	jmp    8026ff <free_block+0x3d4>
  8026f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f7:	8b 40 08             	mov    0x8(%eax),%eax
  8026fa:	a3 40 41 90 00       	mov    %eax,0x904140
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802713:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802718:	48                   	dec    %eax
  802719:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  80271e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802725:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80272c:	e9 ff 01 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802735:	0f 84 db 00 00 00    	je     802816 <free_block+0x4eb>
  80273b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80273f:	0f 84 d1 00 00 00    	je     802816 <free_block+0x4eb>
  802745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802748:	8a 40 04             	mov    0x4(%eax),%al
  80274b:	84 c0                	test   %al,%al
  80274d:	0f 85 c3 00 00 00    	jne    802816 <free_block+0x4eb>
  802753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802756:	8a 40 04             	mov    0x4(%eax),%al
  802759:	3c 01                	cmp    $0x1,%al
  80275b:	0f 85 b5 00 00 00    	jne    802816 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	8b 10                	mov    (%eax),%edx
  802766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	01 c2                	add    %eax,%edx
  80276d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802770:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802782:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802786:	75 17                	jne    80279f <free_block+0x474>
  802788:	83 ec 04             	sub    $0x4,%esp
  80278b:	68 1e 38 80 00       	push   $0x80381e
  802790:	68 64 01 00 00       	push   $0x164
  802795:	68 83 37 80 00       	push   $0x803783
  80279a:	e8 a4 05 00 00       	call   802d43 <_panic>
  80279f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a2:	8b 40 08             	mov    0x8(%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 11                	je     8027ba <free_block+0x48f>
  8027a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ac:	8b 40 08             	mov    0x8(%eax),%eax
  8027af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8027b5:	89 50 0c             	mov    %edx,0xc(%eax)
  8027b8:	eb 0b                	jmp    8027c5 <free_block+0x49a>
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	a3 44 41 90 00       	mov    %eax,0x904144
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	74 11                	je     8027e0 <free_block+0x4b5>
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d8:	8b 52 08             	mov    0x8(%edx),%edx
  8027db:	89 50 08             	mov    %edx,0x8(%eax)
  8027de:	eb 0b                	jmp    8027eb <free_block+0x4c0>
  8027e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e3:	8b 40 08             	mov    0x8(%eax),%eax
  8027e6:	a3 40 41 90 00       	mov    %eax,0x904140
  8027eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027ff:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802804:	48                   	dec    %eax
  802805:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  80280a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802811:	e9 1a 01 00 00       	jmp    802930 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80281a:	0f 84 df 00 00 00    	je     8028ff <free_block+0x5d4>
  802820:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802824:	0f 84 d5 00 00 00    	je     8028ff <free_block+0x5d4>
  80282a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282d:	8a 40 04             	mov    0x4(%eax),%al
  802830:	3c 01                	cmp    $0x1,%al
  802832:	0f 85 c7 00 00 00    	jne    8028ff <free_block+0x5d4>
  802838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283b:	8a 40 04             	mov    0x4(%eax),%al
  80283e:	84 c0                	test   %al,%al
  802840:	0f 85 b9 00 00 00    	jne    8028ff <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802849:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80284d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802850:	8b 10                	mov    (%eax),%edx
  802852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	01 c2                	add    %eax,%edx
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80285e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80286e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802872:	75 17                	jne    80288b <free_block+0x560>
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	68 1e 38 80 00       	push   $0x80381e
  80287c:	68 6e 01 00 00       	push   $0x16e
  802881:	68 83 37 80 00       	push   $0x803783
  802886:	e8 b8 04 00 00       	call   802d43 <_panic>
  80288b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288e:	8b 40 08             	mov    0x8(%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 11                	je     8028a6 <free_block+0x57b>
  802895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80289e:	8b 52 0c             	mov    0xc(%edx),%edx
  8028a1:	89 50 0c             	mov    %edx,0xc(%eax)
  8028a4:	eb 0b                	jmp    8028b1 <free_block+0x586>
  8028a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	a3 44 41 90 00       	mov    %eax,0x904144
  8028b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 11                	je     8028cc <free_block+0x5a1>
  8028bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028be:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c4:	8b 52 08             	mov    0x8(%edx),%edx
  8028c7:	89 50 08             	mov    %edx,0x8(%eax)
  8028ca:	eb 0b                	jmp    8028d7 <free_block+0x5ac>
  8028cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cf:	8b 40 08             	mov    0x8(%eax),%eax
  8028d2:	a3 40 41 90 00       	mov    %eax,0x904140
  8028d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028eb:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028f0:	48                   	dec    %eax
  8028f1:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  8028f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8028fd:	eb 31                	jmp    802930 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  8028ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802903:	74 2b                	je     802930 <free_block+0x605>
  802905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802909:	74 25                	je     802930 <free_block+0x605>
  80290b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290e:	8a 40 04             	mov    0x4(%eax),%al
  802911:	84 c0                	test   %al,%al
  802913:	75 1b                	jne    802930 <free_block+0x605>
  802915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802918:	8a 40 04             	mov    0x4(%eax),%al
  80291b:	84 c0                	test   %al,%al
  80291d:	75 11                	jne    802930 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802926:	90                   	nop
  802927:	eb 07                	jmp    802930 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802929:	90                   	nop
  80292a:	eb 04                	jmp    802930 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  80292c:	90                   	nop
  80292d:	eb 01                	jmp    802930 <free_block+0x605>
	if (va == NULL)
		return;
  80292f:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802930:	c9                   	leave  
  802931:	c3                   	ret    

00802932 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293c:	75 19                	jne    802957 <realloc_block_FF+0x25>
  80293e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802942:	74 13                	je     802957 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  802944:	83 ec 0c             	sub    $0xc,%esp
  802947:	ff 75 0c             	pushl  0xc(%ebp)
  80294a:	e8 0f f4 ff ff       	call   801d5e <alloc_block_FF>
  80294f:	83 c4 10             	add    $0x10,%esp
  802952:	e9 ea 03 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  802957:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80295b:	75 3b                	jne    802998 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  80295d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802961:	75 17                	jne    80297a <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  802963:	83 ec 0c             	sub    $0xc,%esp
  802966:	6a 00                	push   $0x0
  802968:	e8 f1 f3 ff ff       	call   801d5e <alloc_block_FF>
  80296d:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802970:	b8 00 00 00 00       	mov    $0x0,%eax
  802975:	e9 c7 03 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  80297a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297e:	74 18                	je     802998 <realloc_block_FF+0x66>
		{
			free_block(va);
  802980:	83 ec 0c             	sub    $0xc,%esp
  802983:	ff 75 08             	pushl  0x8(%ebp)
  802986:	e8 a0 f9 ff ff       	call   80232b <free_block>
  80298b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
  802993:	e9 a9 03 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  802998:	a1 40 41 90 00       	mov    0x904140,%eax
  80299d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a0:	e9 68 03 00 00       	jmp    802d0d <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	83 e8 10             	sub    $0x10,%eax
  8029ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029ae:	0f 85 51 03 00 00    	jne    802d05 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029bc:	83 c2 10             	add    $0x10,%edx
  8029bf:	39 d0                	cmp    %edx,%eax
  8029c1:	75 08                	jne    8029cb <realloc_block_FF+0x99>
			{
				return va;
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	e9 76 03 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029d3:	0f 83 45 02 00 00    	jae    802c1e <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8a 40 04             	mov    0x4(%eax),%al
  8029e8:	3c 01                	cmp    $0x1,%al
  8029ea:	0f 85 6b 01 00 00    	jne    802b5b <realloc_block_FF+0x229>
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	0f 84 61 01 00 00    	je     802b5b <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 10                	mov    (%eax),%edx
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a07:	29 c1                	sub    %eax,%ecx
  802a09:	89 c8                	mov    %ecx,%eax
  802a0b:	39 c2                	cmp    %eax,%edx
  802a0d:	0f 86 e3 00 00 00    	jbe    802af6 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	8b 10                	mov    (%eax),%edx
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	2b 45 0c             	sub    0xc(%ebp),%eax
  802a20:	01 d0                	add    %edx,%eax
  802a22:	83 f8 0f             	cmp    $0xf,%eax
  802a25:	0f 86 b5 00 00 00    	jbe    802ae0 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  802a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a31:	01 d0                	add    %edx,%eax
  802a33:	83 c0 10             	add    $0x10,%eax
  802a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  802a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a45:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  802a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4d:	74 06                	je     802a55 <realloc_block_FF+0x123>
  802a4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a53:	75 17                	jne    802a6c <realloc_block_FF+0x13a>
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	68 9c 37 80 00       	push   $0x80379c
  802a5d:	68 ae 01 00 00       	push   $0x1ae
  802a62:	68 83 37 80 00       	push   $0x803783
  802a67:	e8 d7 02 00 00       	call   802d43 <_panic>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 50 08             	mov    0x8(%eax),%edx
  802a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a75:	89 50 08             	mov    %edx,0x8(%eax)
  802a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7b:	8b 40 08             	mov    0x8(%eax),%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	74 0c                	je     802a8e <realloc_block_FF+0x15c>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a8b:	89 50 0c             	mov    %edx,0xc(%eax)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a94:	89 50 08             	mov    %edx,0x8(%eax)
  802a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9d:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa3:	8b 40 08             	mov    0x8(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	75 08                	jne    802ab2 <realloc_block_FF+0x180>
  802aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aad:	a3 44 41 90 00       	mov    %eax,0x904144
  802ab2:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802ab7:	40                   	inc    %eax
  802ab8:	a3 4c 41 90 00       	mov    %eax,0x90414c
							next->size = 0;
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  802ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  802acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad0:	8d 50 10             	lea    0x10(%eax),%edx
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	89 10                	mov    %edx,(%eax)
							return va;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	e9 61 02 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  802ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae3:	8d 50 10             	lea    0x10(%eax),%edx
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	83 c0 10             	add    $0x10,%eax
  802af1:	e9 4b 02 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 10                	mov    (%eax),%edx
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b03:	29 c1                	sub    %eax,%ecx
  802b05:	89 c8                	mov    %ecx,%eax
  802b07:	39 c2                	cmp    %eax,%edx
  802b09:	0f 83 f5 01 00 00    	jae    802d04 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802b0f:	83 ec 0c             	sub    $0xc,%esp
  802b12:	ff 75 0c             	pushl  0xc(%ebp)
  802b15:	e8 44 f2 ff ff       	call   801d5e <alloc_block_FF>
  802b1a:	83 c4 10             	add    $0x10,%esp
  802b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  802b20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b24:	74 2d                	je     802b53 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	50                   	push   %eax
  802b2f:	ff 75 08             	pushl  0x8(%ebp)
  802b32:	ff 75 ec             	pushl  -0x14(%ebp)
  802b35:	e8 a0 e0 ff ff       	call   800bda <memcpy>
  802b3a:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  802b3d:	83 ec 0c             	sub    $0xc,%esp
  802b40:	ff 75 08             	pushl  0x8(%ebp)
  802b43:	e8 e3 f7 ff ff       	call   80232b <free_block>
  802b48:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  802b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4e:	e9 ee 01 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	e9 e6 01 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	8a 40 04             	mov    0x4(%eax),%al
  802b61:	3c 01                	cmp    $0x1,%al
  802b63:	75 59                	jne    802bbe <realloc_block_FF+0x28c>
  802b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b68:	8b 10                	mov    (%eax),%edx
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b72:	29 c1                	sub    %eax,%ecx
  802b74:	89 c8                	mov    %ecx,%eax
  802b76:	39 c2                	cmp    %eax,%edx
  802b78:	75 44                	jne    802bbe <realloc_block_FF+0x28c>
  802b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7e:	74 3e                	je     802bbe <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b8f:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b98:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bae:	8d 50 10             	lea    0x10(%eax),%edx
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	89 10                	mov    %edx,(%eax)
					return va;
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	e9 83 01 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8a 40 04             	mov    0x4(%eax),%al
  802bc4:	84 c0                	test   %al,%al
  802bc6:	74 0a                	je     802bd2 <realloc_block_FF+0x2a0>
  802bc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcc:	0f 85 33 01 00 00    	jne    802d05 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802bd2:	83 ec 0c             	sub    $0xc,%esp
  802bd5:	ff 75 0c             	pushl  0xc(%ebp)
  802bd8:	e8 81 f1 ff ff       	call   801d5e <alloc_block_FF>
  802bdd:	83 c4 10             	add    $0x10,%esp
  802be0:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  802be3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802be7:	74 2d                	je     802c16 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	50                   	push   %eax
  802bf2:	ff 75 08             	pushl  0x8(%ebp)
  802bf5:	ff 75 e0             	pushl  -0x20(%ebp)
  802bf8:	e8 dd df ff ff       	call   800bda <memcpy>
  802bfd:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  802c00:	83 ec 0c             	sub    $0xc,%esp
  802c03:	ff 75 08             	pushl  0x8(%ebp)
  802c06:	e8 20 f7 ff ff       	call   80232b <free_block>
  802c0b:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c11:	e9 2b 01 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	e9 23 01 00 00       	jmp    802d41 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 00                	mov    (%eax),%eax
  802c23:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c26:	0f 86 d9 00 00 00    	jbe    802d05 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	2b 45 0c             	sub    0xc(%ebp),%eax
  802c34:	83 f8 0f             	cmp    $0xf,%eax
  802c37:	0f 86 b4 00 00 00    	jbe    802cf1 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	83 c0 10             	add    $0x10,%eax
  802c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	2b 45 0c             	sub    0xc(%ebp),%eax
  802c53:	8d 50 f0             	lea    -0x10(%eax),%edx
  802c56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c59:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5f:	74 06                	je     802c67 <realloc_block_FF+0x335>
  802c61:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c65:	75 17                	jne    802c7e <realloc_block_FF+0x34c>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 9c 37 80 00       	push   $0x80379c
  802c6f:	68 ed 01 00 00       	push   $0x1ed
  802c74:	68 83 37 80 00       	push   $0x803783
  802c79:	e8 c5 00 00 00       	call   802d43 <_panic>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 50 08             	mov    0x8(%eax),%edx
  802c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c87:	89 50 08             	mov    %edx,0x8(%eax)
  802c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c8d:	8b 40 08             	mov    0x8(%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 0c                	je     802ca0 <realloc_block_FF+0x36e>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9d:	89 50 0c             	mov    %edx,0xc(%eax)
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca6:	89 50 08             	mov    %edx,0x8(%eax)
  802ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caf:	89 50 0c             	mov    %edx,0xc(%eax)
  802cb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb5:	8b 40 08             	mov    0x8(%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	75 08                	jne    802cc4 <realloc_block_FF+0x392>
  802cbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbf:	a3 44 41 90 00       	mov    %eax,0x904144
  802cc4:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802cc9:	40                   	inc    %eax
  802cca:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  802ccf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd2:	83 c0 10             	add    $0x10,%eax
  802cd5:	83 ec 0c             	sub    $0xc,%esp
  802cd8:	50                   	push   %eax
  802cd9:	e8 4d f6 ff ff       	call   80232b <free_block>
  802cde:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  802ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce4:	8d 50 10             	lea    0x10(%eax),%edx
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	89 10                	mov    %edx,(%eax)
					return va;
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	eb 50                	jmp    802d41 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  802cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf4:	8d 50 10             	lea    0x10(%eax),%edx
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	83 c0 10             	add    $0x10,%eax
  802d02:	eb 3d                	jmp    802d41 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  802d04:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  802d05:	a1 48 41 90 00       	mov    0x904148,%eax
  802d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d11:	74 08                	je     802d1b <realloc_block_FF+0x3e9>
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 08             	mov    0x8(%eax),%eax
  802d19:	eb 05                	jmp    802d20 <realloc_block_FF+0x3ee>
  802d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d20:	a3 48 41 90 00       	mov    %eax,0x904148
  802d25:	a1 48 41 90 00       	mov    0x904148,%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	0f 85 73 fc ff ff    	jne    8029a5 <realloc_block_FF+0x73>
  802d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d36:	0f 85 69 fc ff ff    	jne    8029a5 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d41:	c9                   	leave  
  802d42:	c3                   	ret    

00802d43 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802d43:	55                   	push   %ebp
  802d44:	89 e5                	mov    %esp,%ebp
  802d46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802d49:	8d 45 10             	lea    0x10(%ebp),%eax
  802d4c:	83 c0 04             	add    $0x4,%eax
  802d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802d52:	a1 50 41 90 00       	mov    0x904150,%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 16                	je     802d71 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802d5b:	a1 50 41 90 00       	mov    0x904150,%eax
  802d60:	83 ec 08             	sub    $0x8,%esp
  802d63:	50                   	push   %eax
  802d64:	68 3c 38 80 00       	push   $0x80383c
  802d69:	e8 cc d5 ff ff       	call   80033a <cprintf>
  802d6e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802d71:	a1 00 40 80 00       	mov    0x804000,%eax
  802d76:	ff 75 0c             	pushl  0xc(%ebp)
  802d79:	ff 75 08             	pushl  0x8(%ebp)
  802d7c:	50                   	push   %eax
  802d7d:	68 41 38 80 00       	push   $0x803841
  802d82:	e8 b3 d5 ff ff       	call   80033a <cprintf>
  802d87:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d8d:	83 ec 08             	sub    $0x8,%esp
  802d90:	ff 75 f4             	pushl  -0xc(%ebp)
  802d93:	50                   	push   %eax
  802d94:	e8 36 d5 ff ff       	call   8002cf <vcprintf>
  802d99:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802d9c:	83 ec 08             	sub    $0x8,%esp
  802d9f:	6a 00                	push   $0x0
  802da1:	68 5d 38 80 00       	push   $0x80385d
  802da6:	e8 24 d5 ff ff       	call   8002cf <vcprintf>
  802dab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802dae:	e8 a5 d4 ff ff       	call   800258 <exit>

	// should not return here
	while (1) ;
  802db3:	eb fe                	jmp    802db3 <_panic+0x70>

00802db5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
  802db8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802dbb:	a1 20 40 80 00       	mov    0x804020,%eax
  802dc0:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	74 14                	je     802de1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	68 60 38 80 00       	push   $0x803860
  802dd5:	6a 26                	push   $0x26
  802dd7:	68 ac 38 80 00       	push   $0x8038ac
  802ddc:	e8 62 ff ff ff       	call   802d43 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802de1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802de8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802def:	e9 c5 00 00 00       	jmp    802eb9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	01 d0                	add    %edx,%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	75 08                	jne    802e11 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802e09:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e0c:	e9 a5 00 00 00       	jmp    802eb6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802e11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e1f:	eb 69                	jmp    802e8a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e21:	a1 20 40 80 00       	mov    0x804020,%eax
  802e26:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802e2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2f:	89 d0                	mov    %edx,%eax
  802e31:	01 c0                	add    %eax,%eax
  802e33:	01 d0                	add    %edx,%eax
  802e35:	c1 e0 03             	shl    $0x3,%eax
  802e38:	01 c8                	add    %ecx,%eax
  802e3a:	8a 40 04             	mov    0x4(%eax),%al
  802e3d:	84 c0                	test   %al,%al
  802e3f:	75 46                	jne    802e87 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e41:	a1 20 40 80 00       	mov    0x804020,%eax
  802e46:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802e4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4f:	89 d0                	mov    %edx,%eax
  802e51:	01 c0                	add    %eax,%eax
  802e53:	01 d0                	add    %edx,%eax
  802e55:	c1 e0 03             	shl    $0x3,%eax
  802e58:	01 c8                	add    %ecx,%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e67:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	01 c8                	add    %ecx,%eax
  802e78:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	75 09                	jne    802e87 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802e7e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802e85:	eb 15                	jmp    802e9c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e87:	ff 45 e8             	incl   -0x18(%ebp)
  802e8a:	a1 20 40 80 00       	mov    0x804020,%eax
  802e8f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	39 c2                	cmp    %eax,%edx
  802e9a:	77 85                	ja     802e21 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802e9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea0:	75 14                	jne    802eb6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 b8 38 80 00       	push   $0x8038b8
  802eaa:	6a 3a                	push   $0x3a
  802eac:	68 ac 38 80 00       	push   $0x8038ac
  802eb1:	e8 8d fe ff ff       	call   802d43 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802eb6:	ff 45 f0             	incl   -0x10(%ebp)
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ebf:	0f 8c 2f ff ff ff    	jl     802df4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ecc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ed3:	eb 26                	jmp    802efb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802ed5:	a1 20 40 80 00       	mov    0x804020,%eax
  802eda:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  802ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ee3:	89 d0                	mov    %edx,%eax
  802ee5:	01 c0                	add    %eax,%eax
  802ee7:	01 d0                	add    %edx,%eax
  802ee9:	c1 e0 03             	shl    $0x3,%eax
  802eec:	01 c8                	add    %ecx,%eax
  802eee:	8a 40 04             	mov    0x4(%eax),%al
  802ef1:	3c 01                	cmp    $0x1,%al
  802ef3:	75 03                	jne    802ef8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802ef5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ef8:	ff 45 e0             	incl   -0x20(%ebp)
  802efb:	a1 20 40 80 00       	mov    0x804020,%eax
  802f00:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	39 c2                	cmp    %eax,%edx
  802f0b:	77 c8                	ja     802ed5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f13:	74 14                	je     802f29 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 0c 39 80 00       	push   $0x80390c
  802f1d:	6a 44                	push   $0x44
  802f1f:	68 ac 38 80 00       	push   $0x8038ac
  802f24:	e8 1a fe ff ff       	call   802d43 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f29:	90                   	nop
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <__udivdi3>:
  802f2c:	55                   	push   %ebp
  802f2d:	57                   	push   %edi
  802f2e:	56                   	push   %esi
  802f2f:	53                   	push   %ebx
  802f30:	83 ec 1c             	sub    $0x1c,%esp
  802f33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f43:	89 ca                	mov    %ecx,%edx
  802f45:	89 f8                	mov    %edi,%eax
  802f47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f4b:	85 f6                	test   %esi,%esi
  802f4d:	75 2d                	jne    802f7c <__udivdi3+0x50>
  802f4f:	39 cf                	cmp    %ecx,%edi
  802f51:	77 65                	ja     802fb8 <__udivdi3+0x8c>
  802f53:	89 fd                	mov    %edi,%ebp
  802f55:	85 ff                	test   %edi,%edi
  802f57:	75 0b                	jne    802f64 <__udivdi3+0x38>
  802f59:	b8 01 00 00 00       	mov    $0x1,%eax
  802f5e:	31 d2                	xor    %edx,%edx
  802f60:	f7 f7                	div    %edi
  802f62:	89 c5                	mov    %eax,%ebp
  802f64:	31 d2                	xor    %edx,%edx
  802f66:	89 c8                	mov    %ecx,%eax
  802f68:	f7 f5                	div    %ebp
  802f6a:	89 c1                	mov    %eax,%ecx
  802f6c:	89 d8                	mov    %ebx,%eax
  802f6e:	f7 f5                	div    %ebp
  802f70:	89 cf                	mov    %ecx,%edi
  802f72:	89 fa                	mov    %edi,%edx
  802f74:	83 c4 1c             	add    $0x1c,%esp
  802f77:	5b                   	pop    %ebx
  802f78:	5e                   	pop    %esi
  802f79:	5f                   	pop    %edi
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    
  802f7c:	39 ce                	cmp    %ecx,%esi
  802f7e:	77 28                	ja     802fa8 <__udivdi3+0x7c>
  802f80:	0f bd fe             	bsr    %esi,%edi
  802f83:	83 f7 1f             	xor    $0x1f,%edi
  802f86:	75 40                	jne    802fc8 <__udivdi3+0x9c>
  802f88:	39 ce                	cmp    %ecx,%esi
  802f8a:	72 0a                	jb     802f96 <__udivdi3+0x6a>
  802f8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f90:	0f 87 9e 00 00 00    	ja     803034 <__udivdi3+0x108>
  802f96:	b8 01 00 00 00       	mov    $0x1,%eax
  802f9b:	89 fa                	mov    %edi,%edx
  802f9d:	83 c4 1c             	add    $0x1c,%esp
  802fa0:	5b                   	pop    %ebx
  802fa1:	5e                   	pop    %esi
  802fa2:	5f                   	pop    %edi
  802fa3:	5d                   	pop    %ebp
  802fa4:	c3                   	ret    
  802fa5:	8d 76 00             	lea    0x0(%esi),%esi
  802fa8:	31 ff                	xor    %edi,%edi
  802faa:	31 c0                	xor    %eax,%eax
  802fac:	89 fa                	mov    %edi,%edx
  802fae:	83 c4 1c             	add    $0x1c,%esp
  802fb1:	5b                   	pop    %ebx
  802fb2:	5e                   	pop    %esi
  802fb3:	5f                   	pop    %edi
  802fb4:	5d                   	pop    %ebp
  802fb5:	c3                   	ret    
  802fb6:	66 90                	xchg   %ax,%ax
  802fb8:	89 d8                	mov    %ebx,%eax
  802fba:	f7 f7                	div    %edi
  802fbc:	31 ff                	xor    %edi,%edi
  802fbe:	89 fa                	mov    %edi,%edx
  802fc0:	83 c4 1c             	add    $0x1c,%esp
  802fc3:	5b                   	pop    %ebx
  802fc4:	5e                   	pop    %esi
  802fc5:	5f                   	pop    %edi
  802fc6:	5d                   	pop    %ebp
  802fc7:	c3                   	ret    
  802fc8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fcd:	89 eb                	mov    %ebp,%ebx
  802fcf:	29 fb                	sub    %edi,%ebx
  802fd1:	89 f9                	mov    %edi,%ecx
  802fd3:	d3 e6                	shl    %cl,%esi
  802fd5:	89 c5                	mov    %eax,%ebp
  802fd7:	88 d9                	mov    %bl,%cl
  802fd9:	d3 ed                	shr    %cl,%ebp
  802fdb:	89 e9                	mov    %ebp,%ecx
  802fdd:	09 f1                	or     %esi,%ecx
  802fdf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fe3:	89 f9                	mov    %edi,%ecx
  802fe5:	d3 e0                	shl    %cl,%eax
  802fe7:	89 c5                	mov    %eax,%ebp
  802fe9:	89 d6                	mov    %edx,%esi
  802feb:	88 d9                	mov    %bl,%cl
  802fed:	d3 ee                	shr    %cl,%esi
  802fef:	89 f9                	mov    %edi,%ecx
  802ff1:	d3 e2                	shl    %cl,%edx
  802ff3:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ff7:	88 d9                	mov    %bl,%cl
  802ff9:	d3 e8                	shr    %cl,%eax
  802ffb:	09 c2                	or     %eax,%edx
  802ffd:	89 d0                	mov    %edx,%eax
  802fff:	89 f2                	mov    %esi,%edx
  803001:	f7 74 24 0c          	divl   0xc(%esp)
  803005:	89 d6                	mov    %edx,%esi
  803007:	89 c3                	mov    %eax,%ebx
  803009:	f7 e5                	mul    %ebp
  80300b:	39 d6                	cmp    %edx,%esi
  80300d:	72 19                	jb     803028 <__udivdi3+0xfc>
  80300f:	74 0b                	je     80301c <__udivdi3+0xf0>
  803011:	89 d8                	mov    %ebx,%eax
  803013:	31 ff                	xor    %edi,%edi
  803015:	e9 58 ff ff ff       	jmp    802f72 <__udivdi3+0x46>
  80301a:	66 90                	xchg   %ax,%ax
  80301c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803020:	89 f9                	mov    %edi,%ecx
  803022:	d3 e2                	shl    %cl,%edx
  803024:	39 c2                	cmp    %eax,%edx
  803026:	73 e9                	jae    803011 <__udivdi3+0xe5>
  803028:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80302b:	31 ff                	xor    %edi,%edi
  80302d:	e9 40 ff ff ff       	jmp    802f72 <__udivdi3+0x46>
  803032:	66 90                	xchg   %ax,%ax
  803034:	31 c0                	xor    %eax,%eax
  803036:	e9 37 ff ff ff       	jmp    802f72 <__udivdi3+0x46>
  80303b:	90                   	nop

0080303c <__umoddi3>:
  80303c:	55                   	push   %ebp
  80303d:	57                   	push   %edi
  80303e:	56                   	push   %esi
  80303f:	53                   	push   %ebx
  803040:	83 ec 1c             	sub    $0x1c,%esp
  803043:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803047:	8b 74 24 34          	mov    0x34(%esp),%esi
  80304b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80304f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803053:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803057:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80305b:	89 f3                	mov    %esi,%ebx
  80305d:	89 fa                	mov    %edi,%edx
  80305f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803063:	89 34 24             	mov    %esi,(%esp)
  803066:	85 c0                	test   %eax,%eax
  803068:	75 1a                	jne    803084 <__umoddi3+0x48>
  80306a:	39 f7                	cmp    %esi,%edi
  80306c:	0f 86 a2 00 00 00    	jbe    803114 <__umoddi3+0xd8>
  803072:	89 c8                	mov    %ecx,%eax
  803074:	89 f2                	mov    %esi,%edx
  803076:	f7 f7                	div    %edi
  803078:	89 d0                	mov    %edx,%eax
  80307a:	31 d2                	xor    %edx,%edx
  80307c:	83 c4 1c             	add    $0x1c,%esp
  80307f:	5b                   	pop    %ebx
  803080:	5e                   	pop    %esi
  803081:	5f                   	pop    %edi
  803082:	5d                   	pop    %ebp
  803083:	c3                   	ret    
  803084:	39 f0                	cmp    %esi,%eax
  803086:	0f 87 ac 00 00 00    	ja     803138 <__umoddi3+0xfc>
  80308c:	0f bd e8             	bsr    %eax,%ebp
  80308f:	83 f5 1f             	xor    $0x1f,%ebp
  803092:	0f 84 ac 00 00 00    	je     803144 <__umoddi3+0x108>
  803098:	bf 20 00 00 00       	mov    $0x20,%edi
  80309d:	29 ef                	sub    %ebp,%edi
  80309f:	89 fe                	mov    %edi,%esi
  8030a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030a5:	89 e9                	mov    %ebp,%ecx
  8030a7:	d3 e0                	shl    %cl,%eax
  8030a9:	89 d7                	mov    %edx,%edi
  8030ab:	89 f1                	mov    %esi,%ecx
  8030ad:	d3 ef                	shr    %cl,%edi
  8030af:	09 c7                	or     %eax,%edi
  8030b1:	89 e9                	mov    %ebp,%ecx
  8030b3:	d3 e2                	shl    %cl,%edx
  8030b5:	89 14 24             	mov    %edx,(%esp)
  8030b8:	89 d8                	mov    %ebx,%eax
  8030ba:	d3 e0                	shl    %cl,%eax
  8030bc:	89 c2                	mov    %eax,%edx
  8030be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030c2:	d3 e0                	shl    %cl,%eax
  8030c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030cc:	89 f1                	mov    %esi,%ecx
  8030ce:	d3 e8                	shr    %cl,%eax
  8030d0:	09 d0                	or     %edx,%eax
  8030d2:	d3 eb                	shr    %cl,%ebx
  8030d4:	89 da                	mov    %ebx,%edx
  8030d6:	f7 f7                	div    %edi
  8030d8:	89 d3                	mov    %edx,%ebx
  8030da:	f7 24 24             	mull   (%esp)
  8030dd:	89 c6                	mov    %eax,%esi
  8030df:	89 d1                	mov    %edx,%ecx
  8030e1:	39 d3                	cmp    %edx,%ebx
  8030e3:	0f 82 87 00 00 00    	jb     803170 <__umoddi3+0x134>
  8030e9:	0f 84 91 00 00 00    	je     803180 <__umoddi3+0x144>
  8030ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030f3:	29 f2                	sub    %esi,%edx
  8030f5:	19 cb                	sbb    %ecx,%ebx
  8030f7:	89 d8                	mov    %ebx,%eax
  8030f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030fd:	d3 e0                	shl    %cl,%eax
  8030ff:	89 e9                	mov    %ebp,%ecx
  803101:	d3 ea                	shr    %cl,%edx
  803103:	09 d0                	or     %edx,%eax
  803105:	89 e9                	mov    %ebp,%ecx
  803107:	d3 eb                	shr    %cl,%ebx
  803109:	89 da                	mov    %ebx,%edx
  80310b:	83 c4 1c             	add    $0x1c,%esp
  80310e:	5b                   	pop    %ebx
  80310f:	5e                   	pop    %esi
  803110:	5f                   	pop    %edi
  803111:	5d                   	pop    %ebp
  803112:	c3                   	ret    
  803113:	90                   	nop
  803114:	89 fd                	mov    %edi,%ebp
  803116:	85 ff                	test   %edi,%edi
  803118:	75 0b                	jne    803125 <__umoddi3+0xe9>
  80311a:	b8 01 00 00 00       	mov    $0x1,%eax
  80311f:	31 d2                	xor    %edx,%edx
  803121:	f7 f7                	div    %edi
  803123:	89 c5                	mov    %eax,%ebp
  803125:	89 f0                	mov    %esi,%eax
  803127:	31 d2                	xor    %edx,%edx
  803129:	f7 f5                	div    %ebp
  80312b:	89 c8                	mov    %ecx,%eax
  80312d:	f7 f5                	div    %ebp
  80312f:	89 d0                	mov    %edx,%eax
  803131:	e9 44 ff ff ff       	jmp    80307a <__umoddi3+0x3e>
  803136:	66 90                	xchg   %ax,%ax
  803138:	89 c8                	mov    %ecx,%eax
  80313a:	89 f2                	mov    %esi,%edx
  80313c:	83 c4 1c             	add    $0x1c,%esp
  80313f:	5b                   	pop    %ebx
  803140:	5e                   	pop    %esi
  803141:	5f                   	pop    %edi
  803142:	5d                   	pop    %ebp
  803143:	c3                   	ret    
  803144:	3b 04 24             	cmp    (%esp),%eax
  803147:	72 06                	jb     80314f <__umoddi3+0x113>
  803149:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80314d:	77 0f                	ja     80315e <__umoddi3+0x122>
  80314f:	89 f2                	mov    %esi,%edx
  803151:	29 f9                	sub    %edi,%ecx
  803153:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803157:	89 14 24             	mov    %edx,(%esp)
  80315a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80315e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803162:	8b 14 24             	mov    (%esp),%edx
  803165:	83 c4 1c             	add    $0x1c,%esp
  803168:	5b                   	pop    %ebx
  803169:	5e                   	pop    %esi
  80316a:	5f                   	pop    %edi
  80316b:	5d                   	pop    %ebp
  80316c:	c3                   	ret    
  80316d:	8d 76 00             	lea    0x0(%esi),%esi
  803170:	2b 04 24             	sub    (%esp),%eax
  803173:	19 fa                	sbb    %edi,%edx
  803175:	89 d1                	mov    %edx,%ecx
  803177:	89 c6                	mov    %eax,%esi
  803179:	e9 71 ff ff ff       	jmp    8030ef <__umoddi3+0xb3>
  80317e:	66 90                	xchg   %ax,%ax
  803180:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803184:	72 ea                	jb     803170 <__umoddi3+0x134>
  803186:	89 d9                	mov    %ebx,%ecx
  803188:	e9 62 ff ff ff       	jmp    8030ef <__umoddi3+0xb3>
