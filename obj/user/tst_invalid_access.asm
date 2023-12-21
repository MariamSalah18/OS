
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 eb 01 00 00       	call   800221 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	cprintf("PART I: Test the Pointer Validation inside fault_handler():\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 1c 80 00       	push   $0x801c20
  800046:	e8 d8 03 00 00       	call   800423 <cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================\n");
  80004e:	83 ec 0c             	sub    $0xc,%esp
  800051:	68 60 1c 80 00       	push   $0x801c60
  800056:	e8 c8 03 00 00       	call   800423 <cprintf>
  80005b:	83 c4 10             	add    $0x10,%esp
		rsttst();
  80005e:	e8 11 16 00 00       	call   801674 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800063:	a1 20 30 80 00       	mov    0x803020,%eax
  800068:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	a1 20 30 80 00       	mov    0x803020,%eax
  800080:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800086:	52                   	push   %edx
  800087:	51                   	push   %ecx
  800088:	50                   	push   %eax
  800089:	68 9d 1c 80 00       	push   $0x801c9d
  80008e:	e8 95 14 00 00       	call   801528 <sys_create_env>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	ff 75 f4             	pushl  -0xc(%ebp)
  80009f:	e8 a2 14 00 00       	call   801546 <sys_run_env>
  8000a4:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8000bd:	89 c1                	mov    %eax,%ecx
  8000bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c4:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8000ca:	52                   	push   %edx
  8000cb:	51                   	push   %ecx
  8000cc:	50                   	push   %eax
  8000cd:	68 a8 1c 80 00       	push   $0x801ca8
  8000d2:	e8 51 14 00 00       	call   801528 <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e3:	e8 5e 14 00 00       	call   801546 <sys_run_env>
  8000e8:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800101:	89 c1                	mov    %eax,%ecx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  80010e:	52                   	push   %edx
  80010f:	51                   	push   %ecx
  800110:	50                   	push   %eax
  800111:	68 b3 1c 80 00       	push   $0x801cb3
  800116:	e8 0d 14 00 00       	call   801528 <sys_create_env>
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	ff 75 ec             	pushl  -0x14(%ebp)
  800127:	e8 1a 14 00 00       	call   801546 <sys_run_env>
  80012c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 10 27 00 00       	push   $0x2710
  800137:	e8 b1 17 00 00       	call   8018ed <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80013f:	e8 aa 15 00 00       	call   8016ee <gettst>
  800144:	85 c0                	test   %eax,%eax
  800146:	74 12                	je     80015a <_main+0x122>
		cprintf("\nPART I... Failed.\n");
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	68 be 1c 80 00       	push   $0x801cbe
  800150:	e8 ce 02 00 00       	call   800423 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb 10                	jmp    80016a <_main+0x132>
	else
		cprintf("\nPART I... completed successfully\n\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 d4 1c 80 00       	push   $0x801cd4
  800162:	e8 bc 02 00 00       	call   800423 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp


	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap:\n");
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 f8 1c 80 00       	push   $0x801cf8
  800172:	e8 ac 02 00 00       	call   800423 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================================================\n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 58 1d 80 00       	push   $0x801d58
  800182:	e8 9c 02 00 00       	call   800423 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp

	rsttst();
  80018a:	e8 e5 14 00 00       	call   801674 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001a5:	89 c1                	mov    %eax,%ecx
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8001b2:	52                   	push   %edx
  8001b3:	51                   	push   %ecx
  8001b4:	50                   	push   %eax
  8001b5:	68 b5 1d 80 00       	push   $0x801db5
  8001ba:	e8 69 13 00 00       	call   801528 <sys_create_env>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID4);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001cb:	e8 76 13 00 00       	call   801546 <sys_run_env>
  8001d0:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 10 27 00 00       	push   $0x2710
  8001db:	e8 0d 17 00 00       	call   8018ed <env_sleep>
  8001e0:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001e3:	e8 06 15 00 00       	call   8016ee <gettst>
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	74 12                	je     8001fe <_main+0x1c6>
		cprintf("\nPART II... Failed.\n");
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	68 c0 1d 80 00       	push   $0x801dc0
  8001f4:	e8 2a 02 00 00       	call   800423 <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb 10                	jmp    80020e <_main+0x1d6>
	else
		cprintf("\nPART II... completed successfully\n\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 d8 1d 80 00       	push   $0x801dd8
  800206:	e8 18 02 00 00       	call   800423 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations... test invalid access completed successfully\n");
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 00 1e 80 00       	push   $0x801e00
  800216:	e8 08 02 00 00       	call   800423 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
}
  80021e:	90                   	nop
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800227:	e8 6a 13 00 00       	call   801596 <sys_getenvindex>
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80022f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	01 c0                	add    %eax,%eax
  800236:	01 d0                	add    %edx,%eax
  800238:	c1 e0 06             	shl    $0x6,%eax
  80023b:	29 d0                	sub    %edx,%eax
  80023d:	c1 e0 03             	shl    $0x3,%eax
  800240:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800245:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8a 40 68             	mov    0x68(%eax),%al
  800252:	84 c0                	test   %al,%al
  800254:	74 0d                	je     800263 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	83 c0 68             	add    $0x68,%eax
  80025e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800263:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800267:	7e 0a                	jle    800273 <libmain+0x52>
		binaryname = argv[0];
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	8b 00                	mov    (%eax),%eax
  80026e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	ff 75 0c             	pushl  0xc(%ebp)
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 b7 fd ff ff       	call   800038 <_main>
  800281:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800284:	e8 1a 11 00 00       	call   8013a3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	68 58 1e 80 00       	push   $0x801e58
  800291:	e8 8d 01 00 00       	call   800423 <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800299:	a1 20 30 80 00       	mov    0x803020,%eax
  80029e:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8002a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a9:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	52                   	push   %edx
  8002b3:	50                   	push   %eax
  8002b4:	68 80 1e 80 00       	push   $0x801e80
  8002b9:	e8 65 01 00 00       	call   800423 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c6:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  8002e2:	51                   	push   %ecx
  8002e3:	52                   	push   %edx
  8002e4:	50                   	push   %eax
  8002e5:	68 a8 1e 80 00       	push   $0x801ea8
  8002ea:	e8 34 01 00 00       	call   800423 <cprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f7:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	50                   	push   %eax
  800301:	68 00 1f 80 00       	push   $0x801f00
  800306:	e8 18 01 00 00       	call   800423 <cprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	68 58 1e 80 00       	push   $0x801e58
  800316:	e8 08 01 00 00       	call   800423 <cprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80031e:	e8 9a 10 00 00       	call   8013bd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800323:	e8 19 00 00 00       	call   800341 <exit>
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	6a 00                	push   $0x0
  800336:	e8 27 12 00 00       	call   801562 <sys_destroy_env>
  80033b:	83 c4 10             	add    $0x10,%esp
}
  80033e:	90                   	nop
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <exit>:

void
exit(void)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800347:	e8 7c 12 00 00       	call   8015c8 <sys_exit_env>
}
  80034c:	90                   	nop
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	8d 48 01             	lea    0x1(%eax),%ecx
  80035d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800360:	89 0a                	mov    %ecx,(%edx)
  800362:	8b 55 08             	mov    0x8(%ebp),%edx
  800365:	88 d1                	mov    %dl,%cl
  800367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80036e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800371:	8b 00                	mov    (%eax),%eax
  800373:	3d ff 00 00 00       	cmp    $0xff,%eax
  800378:	75 2c                	jne    8003a6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80037a:	a0 24 30 80 00       	mov    0x803024,%al
  80037f:	0f b6 c0             	movzbl %al,%eax
  800382:	8b 55 0c             	mov    0xc(%ebp),%edx
  800385:	8b 12                	mov    (%edx),%edx
  800387:	89 d1                	mov    %edx,%ecx
  800389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038c:	83 c2 08             	add    $0x8,%edx
  80038f:	83 ec 04             	sub    $0x4,%esp
  800392:	50                   	push   %eax
  800393:	51                   	push   %ecx
  800394:	52                   	push   %edx
  800395:	e8 b0 0e 00 00       	call   80124a <sys_cputs>
  80039a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	8b 40 04             	mov    0x4(%eax),%eax
  8003ac:	8d 50 01             	lea    0x1(%eax),%edx
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003b5:	90                   	nop
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    

008003b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c8:	00 00 00 
	b.cnt = 0;
  8003cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003d5:	ff 75 0c             	pushl  0xc(%ebp)
  8003d8:	ff 75 08             	pushl  0x8(%ebp)
  8003db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e1:	50                   	push   %eax
  8003e2:	68 4f 03 80 00       	push   $0x80034f
  8003e7:	e8 11 02 00 00       	call   8005fd <vprintfmt>
  8003ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003ef:	a0 24 30 80 00       	mov    0x803024,%al
  8003f4:	0f b6 c0             	movzbl %al,%eax
  8003f7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	50                   	push   %eax
  800401:	52                   	push   %edx
  800402:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800408:	83 c0 08             	add    $0x8,%eax
  80040b:	50                   	push   %eax
  80040c:	e8 39 0e 00 00       	call   80124a <sys_cputs>
  800411:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800414:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80041b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <cprintf>:

int cprintf(const char *fmt, ...) {
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800429:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800430:	8d 45 0c             	lea    0xc(%ebp),%eax
  800433:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 f4             	pushl  -0xc(%ebp)
  80043f:	50                   	push   %eax
  800440:	e8 73 ff ff ff       	call   8003b8 <vcprintf>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800456:	e8 48 0f 00 00       	call   8013a3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80045b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80045e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	ff 75 f4             	pushl  -0xc(%ebp)
  80046a:	50                   	push   %eax
  80046b:	e8 48 ff ff ff       	call   8003b8 <vcprintf>
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800476:	e8 42 0f 00 00       	call   8013bd <sys_enable_interrupt>
	return cnt;
  80047b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	53                   	push   %ebx
  800484:	83 ec 14             	sub    $0x14,%esp
  800487:	8b 45 10             	mov    0x10(%ebp),%eax
  80048a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800493:	8b 45 18             	mov    0x18(%ebp),%eax
  800496:	ba 00 00 00 00       	mov    $0x0,%edx
  80049b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80049e:	77 55                	ja     8004f5 <printnum+0x75>
  8004a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004a3:	72 05                	jb     8004aa <printnum+0x2a>
  8004a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004a8:	77 4b                	ja     8004f5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b8:	52                   	push   %edx
  8004b9:	50                   	push   %eax
  8004ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8004bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8004c0:	e8 df 14 00 00       	call   8019a4 <__udivdi3>
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 20             	pushl  0x20(%ebp)
  8004ce:	53                   	push   %ebx
  8004cf:	ff 75 18             	pushl  0x18(%ebp)
  8004d2:	52                   	push   %edx
  8004d3:	50                   	push   %eax
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 a1 ff ff ff       	call   800480 <printnum>
  8004df:	83 c4 20             	add    $0x20,%esp
  8004e2:	eb 1a                	jmp    8004fe <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ea:	ff 75 20             	pushl  0x20(%ebp)
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	ff d0                	call   *%eax
  8004f2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f5:	ff 4d 1c             	decl   0x1c(%ebp)
  8004f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004fc:	7f e6                	jg     8004e4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004fe:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800501:	bb 00 00 00 00       	mov    $0x0,%ebx
  800506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80050c:	53                   	push   %ebx
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	50                   	push   %eax
  800510:	e8 9f 15 00 00       	call   801ab4 <__umoddi3>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	05 34 21 80 00       	add    $0x802134,%eax
  80051d:	8a 00                	mov    (%eax),%al
  80051f:	0f be c0             	movsbl %al,%eax
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	50                   	push   %eax
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	ff d0                	call   *%eax
  80052e:	83 c4 10             	add    $0x10,%esp
}
  800531:	90                   	nop
  800532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800535:	c9                   	leave  
  800536:	c3                   	ret    

00800537 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80053a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053e:	7e 1c                	jle    80055c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	8d 50 08             	lea    0x8(%eax),%edx
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	89 10                	mov    %edx,(%eax)
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	83 e8 08             	sub    $0x8,%eax
  800555:	8b 50 04             	mov    0x4(%eax),%edx
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	eb 40                	jmp    80059c <getuint+0x65>
	else if (lflag)
  80055c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800560:	74 1e                	je     800580 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	8d 50 04             	lea    0x4(%eax),%edx
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 10                	mov    %edx,(%eax)
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	83 e8 04             	sub    $0x4,%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	eb 1c                	jmp    80059c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	8d 50 04             	lea    0x4(%eax),%edx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	89 10                	mov    %edx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	83 e8 04             	sub    $0x4,%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80059c:	5d                   	pop    %ebp
  80059d:	c3                   	ret    

0080059e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a5:	7e 1c                	jle    8005c3 <getint+0x25>
		return va_arg(*ap, long long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 08             	lea    0x8(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 08             	sub    $0x8,%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	eb 38                	jmp    8005fb <getint+0x5d>
	else if (lflag)
  8005c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c7:	74 1a                	je     8005e3 <getint+0x45>
		return va_arg(*ap, long);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	89 10                	mov    %edx,(%eax)
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	99                   	cltd   
  8005e1:	eb 18                	jmp    8005fb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 10                	mov    %edx,(%eax)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	83 e8 04             	sub    $0x4,%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	99                   	cltd   
}
  8005fb:	5d                   	pop    %ebp
  8005fc:	c3                   	ret    

008005fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	56                   	push   %esi
  800601:	53                   	push   %ebx
  800602:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800605:	eb 17                	jmp    80061e <vprintfmt+0x21>
			if (ch == '\0')
  800607:	85 db                	test   %ebx,%ebx
  800609:	0f 84 af 03 00 00    	je     8009be <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	53                   	push   %ebx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	ff d0                	call   *%eax
  80061b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061e:	8b 45 10             	mov    0x10(%ebp),%eax
  800621:	8d 50 01             	lea    0x1(%eax),%edx
  800624:	89 55 10             	mov    %edx,0x10(%ebp)
  800627:	8a 00                	mov    (%eax),%al
  800629:	0f b6 d8             	movzbl %al,%ebx
  80062c:	83 fb 25             	cmp    $0x25,%ebx
  80062f:	75 d6                	jne    800607 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800631:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800635:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80063c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800643:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80064a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800651:	8b 45 10             	mov    0x10(%ebp),%eax
  800654:	8d 50 01             	lea    0x1(%eax),%edx
  800657:	89 55 10             	mov    %edx,0x10(%ebp)
  80065a:	8a 00                	mov    (%eax),%al
  80065c:	0f b6 d8             	movzbl %al,%ebx
  80065f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800662:	83 f8 55             	cmp    $0x55,%eax
  800665:	0f 87 2b 03 00 00    	ja     800996 <vprintfmt+0x399>
  80066b:	8b 04 85 58 21 80 00 	mov    0x802158(,%eax,4),%eax
  800672:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800674:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800678:	eb d7                	jmp    800651 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80067a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80067e:	eb d1                	jmp    800651 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800680:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800687:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068a:	89 d0                	mov    %edx,%eax
  80068c:	c1 e0 02             	shl    $0x2,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d8                	add    %ebx,%eax
  800695:	83 e8 30             	sub    $0x30,%eax
  800698:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80069b:	8b 45 10             	mov    0x10(%ebp),%eax
  80069e:	8a 00                	mov    (%eax),%al
  8006a0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006a3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006a6:	7e 3e                	jle    8006e6 <vprintfmt+0xe9>
  8006a8:	83 fb 39             	cmp    $0x39,%ebx
  8006ab:	7f 39                	jg     8006e6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ad:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006b0:	eb d5                	jmp    800687 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	83 c0 04             	add    $0x4,%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	83 e8 04             	sub    $0x4,%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006c6:	eb 1f                	jmp    8006e7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	79 83                	jns    800651 <vprintfmt+0x54>
				width = 0;
  8006ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006d5:	e9 77 ff ff ff       	jmp    800651 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006e1:	e9 6b ff ff ff       	jmp    800651 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006e6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006eb:	0f 89 60 ff ff ff    	jns    800651 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006fe:	e9 4e ff ff ff       	jmp    800651 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800703:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800706:	e9 46 ff ff ff       	jmp    800651 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	83 c0 04             	add    $0x4,%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	83 e8 04             	sub    $0x4,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	50                   	push   %eax
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
			break;
  80072b:	e9 89 02 00 00       	jmp    8009b9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	83 c0 04             	add    $0x4,%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800741:	85 db                	test   %ebx,%ebx
  800743:	79 02                	jns    800747 <vprintfmt+0x14a>
				err = -err;
  800745:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800747:	83 fb 64             	cmp    $0x64,%ebx
  80074a:	7f 0b                	jg     800757 <vprintfmt+0x15a>
  80074c:	8b 34 9d a0 1f 80 00 	mov    0x801fa0(,%ebx,4),%esi
  800753:	85 f6                	test   %esi,%esi
  800755:	75 19                	jne    800770 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800757:	53                   	push   %ebx
  800758:	68 45 21 80 00       	push   $0x802145
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	e8 5e 02 00 00       	call   8009c6 <printfmt>
  800768:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80076b:	e9 49 02 00 00       	jmp    8009b9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800770:	56                   	push   %esi
  800771:	68 4e 21 80 00       	push   $0x80214e
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	ff 75 08             	pushl  0x8(%ebp)
  80077c:	e8 45 02 00 00       	call   8009c6 <printfmt>
  800781:	83 c4 10             	add    $0x10,%esp
			break;
  800784:	e9 30 02 00 00       	jmp    8009b9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	83 c0 04             	add    $0x4,%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 30                	mov    (%eax),%esi
  80079a:	85 f6                	test   %esi,%esi
  80079c:	75 05                	jne    8007a3 <vprintfmt+0x1a6>
				p = "(null)";
  80079e:	be 51 21 80 00       	mov    $0x802151,%esi
			if (width > 0 && padc != '-')
  8007a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a7:	7e 6d                	jle    800816 <vprintfmt+0x219>
  8007a9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ad:	74 67                	je     800816 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	56                   	push   %esi
  8007b7:	e8 0c 03 00 00       	call   800ac8 <strnlen>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007c2:	eb 16                	jmp    8007da <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007c4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	50                   	push   %eax
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	ff d0                	call   *%eax
  8007d4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7f e4                	jg     8007c4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e0:	eb 34                	jmp    800816 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007e6:	74 1c                	je     800804 <vprintfmt+0x207>
  8007e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8007eb:	7e 05                	jle    8007f2 <vprintfmt+0x1f5>
  8007ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8007f0:	7e 12                	jle    800804 <vprintfmt+0x207>
					putch('?', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	6a 3f                	push   $0x3f
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	ff d0                	call   *%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	eb 0f                	jmp    800813 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	53                   	push   %ebx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	ff d0                	call   *%eax
  800810:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800813:	ff 4d e4             	decl   -0x1c(%ebp)
  800816:	89 f0                	mov    %esi,%eax
  800818:	8d 70 01             	lea    0x1(%eax),%esi
  80081b:	8a 00                	mov    (%eax),%al
  80081d:	0f be d8             	movsbl %al,%ebx
  800820:	85 db                	test   %ebx,%ebx
  800822:	74 24                	je     800848 <vprintfmt+0x24b>
  800824:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800828:	78 b8                	js     8007e2 <vprintfmt+0x1e5>
  80082a:	ff 4d e0             	decl   -0x20(%ebp)
  80082d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800831:	79 af                	jns    8007e2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800833:	eb 13                	jmp    800848 <vprintfmt+0x24b>
				putch(' ', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 20                	push   $0x20
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800845:	ff 4d e4             	decl   -0x1c(%ebp)
  800848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084c:	7f e7                	jg     800835 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80084e:	e9 66 01 00 00       	jmp    8009b9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 e8             	pushl  -0x18(%ebp)
  800859:	8d 45 14             	lea    0x14(%ebp),%eax
  80085c:	50                   	push   %eax
  80085d:	e8 3c fd ff ff       	call   80059e <getint>
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80086b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800871:	85 d2                	test   %edx,%edx
  800873:	79 23                	jns    800898 <vprintfmt+0x29b>
				putch('-', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 2d                	push   $0x2d
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088b:	f7 d8                	neg    %eax
  80088d:	83 d2 00             	adc    $0x0,%edx
  800890:	f7 da                	neg    %edx
  800892:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800895:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800898:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80089f:	e9 bc 00 00 00       	jmp    800960 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ad:	50                   	push   %eax
  8008ae:	e8 84 fc ff ff       	call   800537 <getuint>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008bc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c3:	e9 98 00 00 00       	jmp    800960 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	6a 58                	push   $0x58
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	6a 58                	push   $0x58
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	6a 58                	push   $0x58
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
			break;
  8008f8:	e9 bc 00 00 00       	jmp    8009b9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	6a 30                	push   $0x30
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	ff d0                	call   *%eax
  80090a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	6a 78                	push   $0x78
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 c0 04             	add    $0x4,%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80092e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800931:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800938:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80093f:	eb 1f                	jmp    800960 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 e8             	pushl  -0x18(%ebp)
  800947:	8d 45 14             	lea    0x14(%ebp),%eax
  80094a:	50                   	push   %eax
  80094b:	e8 e7 fb ff ff       	call   800537 <getuint>
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800956:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800959:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800960:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800967:	83 ec 04             	sub    $0x4,%esp
  80096a:	52                   	push   %edx
  80096b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80096e:	50                   	push   %eax
  80096f:	ff 75 f4             	pushl  -0xc(%ebp)
  800972:	ff 75 f0             	pushl  -0x10(%ebp)
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 00 fb ff ff       	call   800480 <printnum>
  800980:	83 c4 20             	add    $0x20,%esp
			break;
  800983:	eb 34                	jmp    8009b9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
			break;
  800994:	eb 23                	jmp    8009b9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 25                	push   $0x25
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a6:	ff 4d 10             	decl   0x10(%ebp)
  8009a9:	eb 03                	jmp    8009ae <vprintfmt+0x3b1>
  8009ab:	ff 4d 10             	decl   0x10(%ebp)
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	48                   	dec    %eax
  8009b2:	8a 00                	mov    (%eax),%al
  8009b4:	3c 25                	cmp    $0x25,%al
  8009b6:	75 f3                	jne    8009ab <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009b8:	90                   	nop
		}
	}
  8009b9:	e9 47 fc ff ff       	jmp    800605 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009be:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 16 fc ff ff       	call   8005fd <vprintfmt>
  8009e7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009ea:	90                   	nop
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	8b 40 08             	mov    0x8(%eax),%eax
  8009f6:	8d 50 01             	lea    0x1(%eax),%edx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8b 40 04             	mov    0x4(%eax),%eax
  800a0a:	39 c2                	cmp    %eax,%edx
  800a0c:	73 12                	jae    800a20 <sprintputch+0x33>
		*b->buf++ = ch;
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	8d 48 01             	lea    0x1(%eax),%ecx
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	89 0a                	mov    %ecx,(%edx)
  800a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1e:	88 10                	mov    %dl,(%eax)
}
  800a20:	90                   	nop
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	01 d0                	add    %edx,%eax
  800a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a48:	74 06                	je     800a50 <vsnprintf+0x2d>
  800a4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4e:	7f 07                	jg     800a57 <vsnprintf+0x34>
		return -E_INVAL;
  800a50:	b8 03 00 00 00       	mov    $0x3,%eax
  800a55:	eb 20                	jmp    800a77 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a57:	ff 75 14             	pushl  0x14(%ebp)
  800a5a:	ff 75 10             	pushl  0x10(%ebp)
  800a5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a60:	50                   	push   %eax
  800a61:	68 ed 09 80 00       	push   $0x8009ed
  800a66:	e8 92 fb ff ff       	call   8005fd <vprintfmt>
  800a6b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a88:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	e8 89 ff ff ff       	call   800a23 <vsnprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab2:	eb 06                	jmp    800aba <strlen+0x15>
		n++;
  800ab4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab7:	ff 45 08             	incl   0x8(%ebp)
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	84 c0                	test   %al,%al
  800ac1:	75 f1                	jne    800ab4 <strlen+0xf>
		n++;
	return n;
  800ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad5:	eb 09                	jmp    800ae0 <strnlen+0x18>
		n++;
  800ad7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ada:	ff 45 08             	incl   0x8(%ebp)
  800add:	ff 4d 0c             	decl   0xc(%ebp)
  800ae0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae4:	74 09                	je     800aef <strnlen+0x27>
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	84 c0                	test   %al,%al
  800aed:	75 e8                	jne    800ad7 <strnlen+0xf>
		n++;
	return n;
  800aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b00:	90                   	nop
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8d 50 01             	lea    0x1(%eax),%edx
  800b07:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b13:	8a 12                	mov    (%edx),%dl
  800b15:	88 10                	mov    %dl,(%eax)
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 e4                	jne    800b01 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b35:	eb 1f                	jmp    800b56 <strncpy+0x34>
		*dst++ = *src;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b43:	8a 12                	mov    (%edx),%dl
  800b45:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	84 c0                	test   %al,%al
  800b4e:	74 03                	je     800b53 <strncpy+0x31>
			src++;
  800b50:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b53:	ff 45 fc             	incl   -0x4(%ebp)
  800b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b59:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b5c:	72 d9                	jb     800b37 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b73:	74 30                	je     800ba5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b75:	eb 16                	jmp    800b8d <strlcpy+0x2a>
			*dst++ = *src++;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8d 50 01             	lea    0x1(%eax),%edx
  800b7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b86:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b89:	8a 12                	mov    (%edx),%dl
  800b8b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b8d:	ff 4d 10             	decl   0x10(%ebp)
  800b90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b94:	74 09                	je     800b9f <strlcpy+0x3c>
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	84 c0                	test   %al,%al
  800b9d:	75 d8                	jne    800b77 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	29 c2                	sub    %eax,%edx
  800bad:	89 d0                	mov    %edx,%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb4:	eb 06                	jmp    800bbc <strcmp+0xb>
		p++, q++;
  800bb6:	ff 45 08             	incl   0x8(%ebp)
  800bb9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 0e                	je     800bd3 <strcmp+0x22>
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 10                	mov    (%eax),%dl
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	38 c2                	cmp    %al,%dl
  800bd1:	74 e3                	je     800bb6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d0             	movzbl %al,%edx
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 c0             	movzbl %al,%eax
  800be3:	29 c2                	sub    %eax,%edx
  800be5:	89 d0                	mov    %edx,%eax
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bec:	eb 09                	jmp    800bf7 <strncmp+0xe>
		n--, p++, q++;
  800bee:	ff 4d 10             	decl   0x10(%ebp)
  800bf1:	ff 45 08             	incl   0x8(%ebp)
  800bf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfb:	74 17                	je     800c14 <strncmp+0x2b>
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	74 0e                	je     800c14 <strncmp+0x2b>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 10                	mov    (%eax),%dl
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	38 c2                	cmp    %al,%dl
  800c12:	74 da                	je     800bee <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c18:	75 07                	jne    800c21 <strncmp+0x38>
		return 0;
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	eb 14                	jmp    800c35 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d0             	movzbl %al,%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	0f b6 c0             	movzbl %al,%eax
  800c31:	29 c2                	sub    %eax,%edx
  800c33:	89 d0                	mov    %edx,%eax
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 04             	sub    $0x4,%esp
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c43:	eb 12                	jmp    800c57 <strchr+0x20>
		if (*s == c)
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c4d:	75 05                	jne    800c54 <strchr+0x1d>
			return (char *) s;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	eb 11                	jmp    800c65 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e5                	jne    800c45 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 04             	sub    $0x4,%esp
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c73:	eb 0d                	jmp    800c82 <strfind+0x1b>
		if (*s == c)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7d:	74 0e                	je     800c8d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7f:	ff 45 08             	incl   0x8(%ebp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 ea                	jne    800c75 <strfind+0xe>
  800c8b:	eb 01                	jmp    800c8e <strfind+0x27>
		if (*s == c)
			break;
  800c8d:	90                   	nop
	return (char *) s;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ca5:	eb 0e                	jmp    800cb5 <memset+0x22>
		*p++ = c;
  800ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cb5:	ff 4d f8             	decl   -0x8(%ebp)
  800cb8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cbc:	79 e9                	jns    800ca7 <memset+0x14>
		*p++ = c;

	return v;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cd5:	eb 16                	jmp    800ced <memcpy+0x2a>
		*d++ = *s++;
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf3:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	75 dd                	jne    800cd7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d17:	73 50                	jae    800d69 <memmove+0x6a>
  800d19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	01 d0                	add    %edx,%eax
  800d21:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d24:	76 43                	jbe    800d69 <memmove+0x6a>
		s += n;
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d32:	eb 10                	jmp    800d44 <memmove+0x45>
			*--d = *--s;
  800d34:	ff 4d f8             	decl   -0x8(%ebp)
  800d37:	ff 4d fc             	decl   -0x4(%ebp)
  800d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3d:	8a 10                	mov    (%eax),%dl
  800d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d42:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d44:	8b 45 10             	mov    0x10(%ebp),%eax
  800d47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	75 e3                	jne    800d34 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d51:	eb 23                	jmp    800d76 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d56:	8d 50 01             	lea    0x1(%eax),%edx
  800d59:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d62:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d65:	8a 12                	mov    (%edx),%dl
  800d67:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	75 dd                	jne    800d53 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d8d:	eb 2a                	jmp    800db9 <memcmp+0x3e>
		if (*s1 != *s2)
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	8a 10                	mov    (%eax),%dl
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	38 c2                	cmp    %al,%dl
  800d9b:	74 16                	je     800db3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	0f b6 d0             	movzbl %al,%edx
  800da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	0f b6 c0             	movzbl %al,%eax
  800dad:	29 c2                	sub    %eax,%edx
  800daf:	89 d0                	mov    %edx,%eax
  800db1:	eb 18                	jmp    800dcb <memcmp+0x50>
		s1++, s2++;
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	75 c9                	jne    800d8f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	01 d0                	add    %edx,%eax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dde:	eb 15                	jmp    800df5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d0             	movzbl %al,%edx
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	0f b6 c0             	movzbl %al,%eax
  800dee:	39 c2                	cmp    %eax,%edx
  800df0:	74 0d                	je     800dff <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dfb:	72 e3                	jb     800de0 <memfind+0x13>
  800dfd:	eb 01                	jmp    800e00 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dff:	90                   	nop
	return (void *) s;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e19:	eb 03                	jmp    800e1e <strtol+0x19>
		s++;
  800e1b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	3c 20                	cmp    $0x20,%al
  800e25:	74 f4                	je     800e1b <strtol+0x16>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3c 09                	cmp    $0x9,%al
  800e2e:	74 eb                	je     800e1b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3c 2b                	cmp    $0x2b,%al
  800e37:	75 05                	jne    800e3e <strtol+0x39>
		s++;
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	eb 13                	jmp    800e51 <strtol+0x4c>
	else if (*s == '-')
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	3c 2d                	cmp    $0x2d,%al
  800e45:	75 0a                	jne    800e51 <strtol+0x4c>
		s++, neg = 1;
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e55:	74 06                	je     800e5d <strtol+0x58>
  800e57:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e5b:	75 20                	jne    800e7d <strtol+0x78>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	3c 30                	cmp    $0x30,%al
  800e64:	75 17                	jne    800e7d <strtol+0x78>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	40                   	inc    %eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 78                	cmp    $0x78,%al
  800e6e:	75 0d                	jne    800e7d <strtol+0x78>
		s += 2, base = 16;
  800e70:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e74:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e7b:	eb 28                	jmp    800ea5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e81:	75 15                	jne    800e98 <strtol+0x93>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	3c 30                	cmp    $0x30,%al
  800e8a:	75 0c                	jne    800e98 <strtol+0x93>
		s++, base = 8;
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e96:	eb 0d                	jmp    800ea5 <strtol+0xa0>
	else if (base == 0)
  800e98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9c:	75 07                	jne    800ea5 <strtol+0xa0>
		base = 10;
  800e9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3c 2f                	cmp    $0x2f,%al
  800eac:	7e 19                	jle    800ec7 <strtol+0xc2>
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	3c 39                	cmp    $0x39,%al
  800eb5:	7f 10                	jg     800ec7 <strtol+0xc2>
			dig = *s - '0';
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f be c0             	movsbl %al,%eax
  800ebf:	83 e8 30             	sub    $0x30,%eax
  800ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec5:	eb 42                	jmp    800f09 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 60                	cmp    $0x60,%al
  800ece:	7e 19                	jle    800ee9 <strtol+0xe4>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	3c 7a                	cmp    $0x7a,%al
  800ed7:	7f 10                	jg     800ee9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f be c0             	movsbl %al,%eax
  800ee1:	83 e8 57             	sub    $0x57,%eax
  800ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ee7:	eb 20                	jmp    800f09 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 40                	cmp    $0x40,%al
  800ef0:	7e 39                	jle    800f2b <strtol+0x126>
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 5a                	cmp    $0x5a,%al
  800ef9:	7f 30                	jg     800f2b <strtol+0x126>
			dig = *s - 'A' + 10;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f be c0             	movsbl %al,%eax
  800f03:	83 e8 37             	sub    $0x37,%eax
  800f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0f:	7d 19                	jge    800f2a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f11:	ff 45 08             	incl   0x8(%ebp)
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f25:	e9 7b ff ff ff       	jmp    800ea5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f2a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2f:	74 08                	je     800f39 <strtol+0x134>
		*endptr = (char *) s;
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f3d:	74 07                	je     800f46 <strtol+0x141>
  800f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f42:	f7 d8                	neg    %eax
  800f44:	eb 03                	jmp    800f49 <strtol+0x144>
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <ltostr>:

void
ltostr(long value, char *str)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f63:	79 13                	jns    800f78 <ltostr+0x2d>
	{
		neg = 1;
  800f65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f72:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f75:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f80:	99                   	cltd   
  800f81:	f7 f9                	idiv   %ecx
  800f83:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f99:	83 c2 30             	add    $0x30,%edx
  800f9c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fa6:	f7 e9                	imul   %ecx
  800fa8:	c1 fa 02             	sar    $0x2,%edx
  800fab:	89 c8                	mov    %ecx,%eax
  800fad:	c1 f8 1f             	sar    $0x1f,%eax
  800fb0:	29 c2                	sub    %eax,%edx
  800fb2:	89 d0                	mov    %edx,%eax
  800fb4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fba:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fbf:	f7 e9                	imul   %ecx
  800fc1:	c1 fa 02             	sar    $0x2,%edx
  800fc4:	89 c8                	mov    %ecx,%eax
  800fc6:	c1 f8 1f             	sar    $0x1f,%eax
  800fc9:	29 c2                	sub    %eax,%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	c1 e0 02             	shl    $0x2,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	01 c0                	add    %eax,%eax
  800fd4:	29 c1                	sub    %eax,%ecx
  800fd6:	89 ca                	mov    %ecx,%edx
  800fd8:	85 d2                	test   %edx,%edx
  800fda:	75 9c                	jne    800f78 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	48                   	dec    %eax
  800fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fee:	74 3d                	je     80102d <ltostr+0xe2>
		start = 1 ;
  800ff0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ff7:	eb 34                	jmp    80102d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	01 c2                	add    %eax,%edx
  80100e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	01 c8                	add    %ecx,%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80101a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	01 c2                	add    %eax,%edx
  801022:	8a 45 eb             	mov    -0x15(%ebp),%al
  801025:	88 02                	mov    %al,(%edx)
		start++ ;
  801027:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80102a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801033:	7c c4                	jl     800ff9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801035:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	01 d0                	add    %edx,%eax
  80103d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801040:	90                   	nop
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 54 fa ff ff       	call   800aa5 <strlen>
  801051:	83 c4 04             	add    $0x4,%esp
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	e8 46 fa ff ff       	call   800aa5 <strlen>
  80105f:	83 c4 04             	add    $0x4,%esp
  801062:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801065:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801073:	eb 17                	jmp    80108c <strcconcat+0x49>
		final[s] = str1[s] ;
  801075:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 c2                	add    %eax,%edx
  80107d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	01 c8                	add    %ecx,%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801089:	ff 45 fc             	incl   -0x4(%ebp)
  80108c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801092:	7c e1                	jl     801075 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801094:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010a2:	eb 1f                	jmp    8010c3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a7:	8d 50 01             	lea    0x1(%eax),%edx
  8010aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010c0:	ff 45 f8             	incl   -0x8(%ebp)
  8010c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c9:	7c d9                	jl     8010a4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	c6 00 00             	movb   $0x0,(%eax)
}
  8010d6:	90                   	nop
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010fc:	eb 0c                	jmp    80110a <strsplit+0x31>
			*string++ = 0;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 08             	mov    %edx,0x8(%ebp)
  801107:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	84 c0                	test   %al,%al
  801111:	74 18                	je     80112b <strsplit+0x52>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	0f be c0             	movsbl %al,%eax
  80111b:	50                   	push   %eax
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	e8 13 fb ff ff       	call   800c37 <strchr>
  801124:	83 c4 08             	add    $0x8,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	75 d3                	jne    8010fe <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	84 c0                	test   %al,%al
  801132:	74 5a                	je     80118e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801134:	8b 45 14             	mov    0x14(%ebp),%eax
  801137:	8b 00                	mov    (%eax),%eax
  801139:	83 f8 0f             	cmp    $0xf,%eax
  80113c:	75 07                	jne    801145 <strsplit+0x6c>
		{
			return 0;
  80113e:	b8 00 00 00 00       	mov    $0x0,%eax
  801143:	eb 66                	jmp    8011ab <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801145:	8b 45 14             	mov    0x14(%ebp),%eax
  801148:	8b 00                	mov    (%eax),%eax
  80114a:	8d 48 01             	lea    0x1(%eax),%ecx
  80114d:	8b 55 14             	mov    0x14(%ebp),%edx
  801150:	89 0a                	mov    %ecx,(%edx)
  801152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 c2                	add    %eax,%edx
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801163:	eb 03                	jmp    801168 <strsplit+0x8f>
			string++;
  801165:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	84 c0                	test   %al,%al
  80116f:	74 8b                	je     8010fc <strsplit+0x23>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f be c0             	movsbl %al,%eax
  801179:	50                   	push   %eax
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	e8 b5 fa ff ff       	call   800c37 <strchr>
  801182:	83 c4 08             	add    $0x8,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	74 dc                	je     801165 <strsplit+0x8c>
			string++;
	}
  801189:	e9 6e ff ff ff       	jmp    8010fc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80118e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80118f:	8b 45 14             	mov    0x14(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 4c                	jmp    801208 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 40                	cmp    $0x40,%al
  8011c8:	7e 27                	jle    8011f1 <str2lower+0x44>
  8011ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 5a                	cmp    $0x5a,%al
  8011d6:	7f 19                	jg     8011f1 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8011d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	01 d0                	add    %edx,%eax
  8011e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e6:	01 ca                	add    %ecx,%edx
  8011e8:	8a 12                	mov    (%edx),%dl
  8011ea:	83 c2 20             	add    $0x20,%edx
  8011ed:	88 10                	mov    %dl,(%eax)
  8011ef:	eb 14                	jmp    801205 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  8011f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	01 c2                	add    %eax,%edx
  8011f9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 c8                	add    %ecx,%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801205:	ff 45 fc             	incl   -0x4(%ebp)
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 95 f8 ff ff       	call   800aa5 <strlen>
  801210:	83 c4 04             	add    $0x4,%esp
  801213:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801216:	7f a4                	jg     8011bc <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801231:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801234:	8b 7d 18             	mov    0x18(%ebp),%edi
  801237:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80123a:	cd 30                	int    $0x30
  80123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801256:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	52                   	push   %edx
  801262:	ff 75 0c             	pushl  0xc(%ebp)
  801265:	50                   	push   %eax
  801266:	6a 00                	push   $0x0
  801268:	e8 b2 ff ff ff       	call   80121f <syscall>
  80126d:	83 c4 18             	add    $0x18,%esp
}
  801270:	90                   	nop
  801271:	c9                   	leave  
  801272:	c3                   	ret    

00801273 <sys_cgetc>:

int
sys_cgetc(void)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 01                	push   $0x1
  801282:	e8 98 ff ff ff       	call   80121f <syscall>
  801287:	83 c4 18             	add    $0x18,%esp
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80128f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	52                   	push   %edx
  80129c:	50                   	push   %eax
  80129d:	6a 05                	push   $0x5
  80129f:	e8 7b ff ff ff       	call   80121f <syscall>
  8012a4:	83 c4 18             	add    $0x18,%esp
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	51                   	push   %ecx
  8012c0:	52                   	push   %edx
  8012c1:	50                   	push   %eax
  8012c2:	6a 06                	push   $0x6
  8012c4:	e8 56 ff ff ff       	call   80121f <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	52                   	push   %edx
  8012e3:	50                   	push   %eax
  8012e4:	6a 07                	push   $0x7
  8012e6:	e8 34 ff ff ff       	call   80121f <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	ff 75 08             	pushl  0x8(%ebp)
  8012ff:	6a 08                	push   $0x8
  801301:	e8 19 ff ff ff       	call   80121f <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 09                	push   $0x9
  80131a:	e8 00 ff ff ff       	call   80121f <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 0a                	push   $0xa
  801333:	e8 e7 fe ff ff       	call   80121f <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 0b                	push   $0xb
  80134c:	e8 ce fe ff ff       	call   80121f <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 0c                	push   $0xc
  801365:	e8 b5 fe ff ff       	call   80121f <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	ff 75 08             	pushl  0x8(%ebp)
  80137d:	6a 0d                	push   $0xd
  80137f:	e8 9b fe ff ff       	call   80121f <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 0e                	push   $0xe
  801398:	e8 82 fe ff ff       	call   80121f <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	90                   	nop
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 11                	push   $0x11
  8013b2:	e8 68 fe ff ff       	call   80121f <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 12                	push   $0x12
  8013cc:	e8 4e fe ff ff       	call   80121f <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	90                   	nop
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	50                   	push   %eax
  8013f0:	6a 13                	push   $0x13
  8013f2:	e8 28 fe ff ff       	call   80121f <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 14                	push   $0x14
  80140c:	e8 0e fe ff ff       	call   80121f <syscall>
  801411:	83 c4 18             	add    $0x18,%esp
}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	50                   	push   %eax
  801427:	6a 15                	push   $0x15
  801429:	e8 f1 fd ff ff       	call   80121f <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801436:	8b 55 0c             	mov    0xc(%ebp),%edx
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	52                   	push   %edx
  801443:	50                   	push   %eax
  801444:	6a 18                	push   $0x18
  801446:	e8 d4 fd ff ff       	call   80121f <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801453:	8b 55 0c             	mov    0xc(%ebp),%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	52                   	push   %edx
  801460:	50                   	push   %eax
  801461:	6a 16                	push   $0x16
  801463:	e8 b7 fd ff ff       	call   80121f <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	90                   	nop
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	50                   	push   %eax
  80147f:	6a 17                	push   $0x17
  801481:	e8 99 fd ff ff       	call   80121f <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	90                   	nop
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801498:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	51                   	push   %ecx
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	6a 19                	push   $0x19
  8014ac:	e8 6e fd ff ff       	call   80121f <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	52                   	push   %edx
  8014c6:	50                   	push   %eax
  8014c7:	6a 1a                	push   $0x1a
  8014c9:	e8 51 fd ff ff       	call   80121f <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	51                   	push   %ecx
  8014e4:	52                   	push   %edx
  8014e5:	50                   	push   %eax
  8014e6:	6a 1b                	push   $0x1b
  8014e8:	e8 32 fd ff ff       	call   80121f <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	52                   	push   %edx
  801502:	50                   	push   %eax
  801503:	6a 1c                	push   $0x1c
  801505:	e8 15 fd ff ff       	call   80121f <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 1d                	push   $0x1d
  80151e:	e8 fc fc ff ff       	call   80121f <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	6a 00                	push   $0x0
  801530:	ff 75 14             	pushl  0x14(%ebp)
  801533:	ff 75 10             	pushl  0x10(%ebp)
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	50                   	push   %eax
  80153a:	6a 1e                	push   $0x1e
  80153c:	e8 de fc ff ff       	call   80121f <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	50                   	push   %eax
  801555:	6a 1f                	push   $0x1f
  801557:	e8 c3 fc ff ff       	call   80121f <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
}
  80155f:	90                   	nop
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	50                   	push   %eax
  801571:	6a 20                	push   $0x20
  801573:	e8 a7 fc ff ff       	call   80121f <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 02                	push   $0x2
  80158c:	e8 8e fc ff ff       	call   80121f <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 03                	push   $0x3
  8015a5:	e8 75 fc ff ff       	call   80121f <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 04                	push   $0x4
  8015be:	e8 5c fc ff ff       	call   80121f <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_exit_env>:


void sys_exit_env(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 21                	push   $0x21
  8015d7:	e8 43 fc ff ff       	call   80121f <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015eb:	8d 50 04             	lea    0x4(%eax),%edx
  8015ee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	52                   	push   %edx
  8015f8:	50                   	push   %eax
  8015f9:	6a 22                	push   $0x22
  8015fb:	e8 1f fc ff ff       	call   80121f <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
	return result;
  801603:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801606:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160c:	89 01                	mov    %eax,(%ecx)
  80160e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	c9                   	leave  
  801615:	c2 04 00             	ret    $0x4

00801618 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	ff 75 10             	pushl  0x10(%ebp)
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 08             	pushl  0x8(%ebp)
  801628:	6a 10                	push   $0x10
  80162a:	e8 f0 fb ff ff       	call   80121f <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
	return ;
  801632:	90                   	nop
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_rcr2>:
uint32 sys_rcr2()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 23                	push   $0x23
  801644:	e8 d6 fb ff ff       	call   80121f <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80165a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	50                   	push   %eax
  801667:	6a 24                	push   $0x24
  801669:	e8 b1 fb ff ff       	call   80121f <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
	return ;
  801671:	90                   	nop
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <rsttst>:
void rsttst()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 26                	push   $0x26
  801683:	e8 97 fb ff ff       	call   80121f <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
	return ;
  80168b:	90                   	nop
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80169a:	8b 55 18             	mov    0x18(%ebp),%edx
  80169d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	ff 75 10             	pushl  0x10(%ebp)
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	ff 75 08             	pushl  0x8(%ebp)
  8016ac:	6a 25                	push   $0x25
  8016ae:	e8 6c fb ff ff       	call   80121f <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b6:	90                   	nop
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <chktst>:
void chktst(uint32 n)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	ff 75 08             	pushl  0x8(%ebp)
  8016c7:	6a 27                	push   $0x27
  8016c9:	e8 51 fb ff ff       	call   80121f <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d1:	90                   	nop
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <inctst>:

void inctst()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 28                	push   $0x28
  8016e3:	e8 37 fb ff ff       	call   80121f <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016eb:	90                   	nop
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <gettst>:
uint32 gettst()
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 29                	push   $0x29
  8016fd:	e8 1d fb ff ff       	call   80121f <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 2a                	push   $0x2a
  801719:	e8 01 fb ff ff       	call   80121f <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801724:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801728:	75 07                	jne    801731 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80172a:	b8 01 00 00 00       	mov    $0x1,%eax
  80172f:	eb 05                	jmp    801736 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 2a                	push   $0x2a
  80174a:	e8 d0 fa ff ff       	call   80121f <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
  801752:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801755:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801759:	75 07                	jne    801762 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80175b:	b8 01 00 00 00       	mov    $0x1,%eax
  801760:	eb 05                	jmp    801767 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 2a                	push   $0x2a
  80177b:	e8 9f fa ff ff       	call   80121f <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
  801783:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801786:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80178a:	75 07                	jne    801793 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80178c:	b8 01 00 00 00       	mov    $0x1,%eax
  801791:	eb 05                	jmp    801798 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 2a                	push   $0x2a
  8017ac:	e8 6e fa ff ff       	call   80121f <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017b7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017bb:	75 07                	jne    8017c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c2:	eb 05                	jmp    8017c9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	6a 2b                	push   $0x2b
  8017db:	e8 3f fa ff ff       	call   80121f <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e3:	90                   	nop
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	53                   	push   %ebx
  8017f9:	51                   	push   %ecx
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	6a 2c                	push   $0x2c
  8017fe:	e8 1c fa ff ff       	call   80121f <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	52                   	push   %edx
  80181b:	50                   	push   %eax
  80181c:	6a 2d                	push   $0x2d
  80181e:	e8 fc f9 ff ff       	call   80121f <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80182b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	51                   	push   %ecx
  801837:	ff 75 10             	pushl  0x10(%ebp)
  80183a:	52                   	push   %edx
  80183b:	50                   	push   %eax
  80183c:	6a 2e                	push   $0x2e
  80183e:	e8 dc f9 ff ff       	call   80121f <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 0f                	push   $0xf
  80185a:	e8 c0 f9 ff ff       	call   80121f <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return ;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	50                   	push   %eax
  801874:	6a 2f                	push   $0x2f
  801876:	e8 a4 f9 ff ff       	call   80121f <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp

}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	6a 30                	push   $0x30
  801891:	e8 89 f9 ff ff       	call   80121f <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
	return;
  801899:	90                   	nop
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	6a 31                	push   $0x31
  8018ad:	e8 6d f9 ff ff       	call   80121f <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
	return;
  8018b5:	90                   	nop
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 32                	push   $0x32
  8018c7:	e8 53 f9 ff ff       	call   80121f <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 33                	push   $0x33
  8018e2:	e8 38 f9 ff ff       	call   80121f <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f6:	89 d0                	mov    %edx,%eax
  8018f8:	c1 e0 02             	shl    $0x2,%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801904:	01 d0                	add    %edx,%eax
  801906:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80190d:	01 d0                	add    %edx,%eax
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	01 d0                	add    %edx,%eax
  801918:	c1 e0 04             	shl    $0x4,%eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80191e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801925:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	50                   	push   %eax
  80192c:	e8 b1 fc ff ff       	call   8015e2 <sys_get_virtual_time>
  801931:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801934:	eb 41                	jmp    801977 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801936:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801939:	83 ec 0c             	sub    $0xc,%esp
  80193c:	50                   	push   %eax
  80193d:	e8 a0 fc ff ff       	call   8015e2 <sys_get_virtual_time>
  801942:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194b:	29 c2                	sub    %eax,%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801958:	89 d1                	mov    %edx,%ecx
  80195a:	29 c1                	sub    %eax,%ecx
  80195c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80195f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801962:	39 c2                	cmp    %eax,%edx
  801964:	0f 97 c0             	seta   %al
  801967:	0f b6 c0             	movzbl %al,%eax
  80196a:	29 c1                	sub    %eax,%ecx
  80196c:	89 c8                	mov    %ecx,%eax
  80196e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801971:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801974:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80197d:	72 b7                	jb     801936 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80198f:	eb 03                	jmp    801994 <busy_wait+0x12>
  801991:	ff 45 fc             	incl   -0x4(%ebp)
  801994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801997:	3b 45 08             	cmp    0x8(%ebp),%eax
  80199a:	72 f5                	jb     801991 <busy_wait+0xf>
	return i;
  80199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    
  8019a1:	66 90                	xchg   %ax,%ax
  8019a3:	90                   	nop

008019a4 <__udivdi3>:
  8019a4:	55                   	push   %ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 1c             	sub    $0x1c,%esp
  8019ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bb:	89 ca                	mov    %ecx,%edx
  8019bd:	89 f8                	mov    %edi,%eax
  8019bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019c3:	85 f6                	test   %esi,%esi
  8019c5:	75 2d                	jne    8019f4 <__udivdi3+0x50>
  8019c7:	39 cf                	cmp    %ecx,%edi
  8019c9:	77 65                	ja     801a30 <__udivdi3+0x8c>
  8019cb:	89 fd                	mov    %edi,%ebp
  8019cd:	85 ff                	test   %edi,%edi
  8019cf:	75 0b                	jne    8019dc <__udivdi3+0x38>
  8019d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d6:	31 d2                	xor    %edx,%edx
  8019d8:	f7 f7                	div    %edi
  8019da:	89 c5                	mov    %eax,%ebp
  8019dc:	31 d2                	xor    %edx,%edx
  8019de:	89 c8                	mov    %ecx,%eax
  8019e0:	f7 f5                	div    %ebp
  8019e2:	89 c1                	mov    %eax,%ecx
  8019e4:	89 d8                	mov    %ebx,%eax
  8019e6:	f7 f5                	div    %ebp
  8019e8:	89 cf                	mov    %ecx,%edi
  8019ea:	89 fa                	mov    %edi,%edx
  8019ec:	83 c4 1c             	add    $0x1c,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    
  8019f4:	39 ce                	cmp    %ecx,%esi
  8019f6:	77 28                	ja     801a20 <__udivdi3+0x7c>
  8019f8:	0f bd fe             	bsr    %esi,%edi
  8019fb:	83 f7 1f             	xor    $0x1f,%edi
  8019fe:	75 40                	jne    801a40 <__udivdi3+0x9c>
  801a00:	39 ce                	cmp    %ecx,%esi
  801a02:	72 0a                	jb     801a0e <__udivdi3+0x6a>
  801a04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a08:	0f 87 9e 00 00 00    	ja     801aac <__udivdi3+0x108>
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	89 fa                	mov    %edi,%edx
  801a15:	83 c4 1c             	add    $0x1c,%esp
  801a18:	5b                   	pop    %ebx
  801a19:	5e                   	pop    %esi
  801a1a:	5f                   	pop    %edi
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    
  801a1d:	8d 76 00             	lea    0x0(%esi),%esi
  801a20:	31 ff                	xor    %edi,%edi
  801a22:	31 c0                	xor    %eax,%eax
  801a24:	89 fa                	mov    %edi,%edx
  801a26:	83 c4 1c             	add    $0x1c,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5e                   	pop    %esi
  801a2b:	5f                   	pop    %edi
  801a2c:	5d                   	pop    %ebp
  801a2d:	c3                   	ret    
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	f7 f7                	div    %edi
  801a34:	31 ff                	xor    %edi,%edi
  801a36:	89 fa                	mov    %edi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a45:	89 eb                	mov    %ebp,%ebx
  801a47:	29 fb                	sub    %edi,%ebx
  801a49:	89 f9                	mov    %edi,%ecx
  801a4b:	d3 e6                	shl    %cl,%esi
  801a4d:	89 c5                	mov    %eax,%ebp
  801a4f:	88 d9                	mov    %bl,%cl
  801a51:	d3 ed                	shr    %cl,%ebp
  801a53:	89 e9                	mov    %ebp,%ecx
  801a55:	09 f1                	or     %esi,%ecx
  801a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a5b:	89 f9                	mov    %edi,%ecx
  801a5d:	d3 e0                	shl    %cl,%eax
  801a5f:	89 c5                	mov    %eax,%ebp
  801a61:	89 d6                	mov    %edx,%esi
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 ee                	shr    %cl,%esi
  801a67:	89 f9                	mov    %edi,%ecx
  801a69:	d3 e2                	shl    %cl,%edx
  801a6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a6f:	88 d9                	mov    %bl,%cl
  801a71:	d3 e8                	shr    %cl,%eax
  801a73:	09 c2                	or     %eax,%edx
  801a75:	89 d0                	mov    %edx,%eax
  801a77:	89 f2                	mov    %esi,%edx
  801a79:	f7 74 24 0c          	divl   0xc(%esp)
  801a7d:	89 d6                	mov    %edx,%esi
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	f7 e5                	mul    %ebp
  801a83:	39 d6                	cmp    %edx,%esi
  801a85:	72 19                	jb     801aa0 <__udivdi3+0xfc>
  801a87:	74 0b                	je     801a94 <__udivdi3+0xf0>
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	31 ff                	xor    %edi,%edi
  801a8d:	e9 58 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a98:	89 f9                	mov    %edi,%ecx
  801a9a:	d3 e2                	shl    %cl,%edx
  801a9c:	39 c2                	cmp    %eax,%edx
  801a9e:	73 e9                	jae    801a89 <__udivdi3+0xe5>
  801aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aa3:	31 ff                	xor    %edi,%edi
  801aa5:	e9 40 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	31 c0                	xor    %eax,%eax
  801aae:	e9 37 ff ff ff       	jmp    8019ea <__udivdi3+0x46>
  801ab3:	90                   	nop

00801ab4 <__umoddi3>:
  801ab4:	55                   	push   %ebp
  801ab5:	57                   	push   %edi
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	83 ec 1c             	sub    $0x1c,%esp
  801abb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801acb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ad3:	89 f3                	mov    %esi,%ebx
  801ad5:	89 fa                	mov    %edi,%edx
  801ad7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801adb:	89 34 24             	mov    %esi,(%esp)
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	75 1a                	jne    801afc <__umoddi3+0x48>
  801ae2:	39 f7                	cmp    %esi,%edi
  801ae4:	0f 86 a2 00 00 00    	jbe    801b8c <__umoddi3+0xd8>
  801aea:	89 c8                	mov    %ecx,%eax
  801aec:	89 f2                	mov    %esi,%edx
  801aee:	f7 f7                	div    %edi
  801af0:	89 d0                	mov    %edx,%eax
  801af2:	31 d2                	xor    %edx,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	39 f0                	cmp    %esi,%eax
  801afe:	0f 87 ac 00 00 00    	ja     801bb0 <__umoddi3+0xfc>
  801b04:	0f bd e8             	bsr    %eax,%ebp
  801b07:	83 f5 1f             	xor    $0x1f,%ebp
  801b0a:	0f 84 ac 00 00 00    	je     801bbc <__umoddi3+0x108>
  801b10:	bf 20 00 00 00       	mov    $0x20,%edi
  801b15:	29 ef                	sub    %ebp,%edi
  801b17:	89 fe                	mov    %edi,%esi
  801b19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b1d:	89 e9                	mov    %ebp,%ecx
  801b1f:	d3 e0                	shl    %cl,%eax
  801b21:	89 d7                	mov    %edx,%edi
  801b23:	89 f1                	mov    %esi,%ecx
  801b25:	d3 ef                	shr    %cl,%edi
  801b27:	09 c7                	or     %eax,%edi
  801b29:	89 e9                	mov    %ebp,%ecx
  801b2b:	d3 e2                	shl    %cl,%edx
  801b2d:	89 14 24             	mov    %edx,(%esp)
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	d3 e0                	shl    %cl,%eax
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b3a:	d3 e0                	shl    %cl,%eax
  801b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b44:	89 f1                	mov    %esi,%ecx
  801b46:	d3 e8                	shr    %cl,%eax
  801b48:	09 d0                	or     %edx,%eax
  801b4a:	d3 eb                	shr    %cl,%ebx
  801b4c:	89 da                	mov    %ebx,%edx
  801b4e:	f7 f7                	div    %edi
  801b50:	89 d3                	mov    %edx,%ebx
  801b52:	f7 24 24             	mull   (%esp)
  801b55:	89 c6                	mov    %eax,%esi
  801b57:	89 d1                	mov    %edx,%ecx
  801b59:	39 d3                	cmp    %edx,%ebx
  801b5b:	0f 82 87 00 00 00    	jb     801be8 <__umoddi3+0x134>
  801b61:	0f 84 91 00 00 00    	je     801bf8 <__umoddi3+0x144>
  801b67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b6b:	29 f2                	sub    %esi,%edx
  801b6d:	19 cb                	sbb    %ecx,%ebx
  801b6f:	89 d8                	mov    %ebx,%eax
  801b71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b75:	d3 e0                	shl    %cl,%eax
  801b77:	89 e9                	mov    %ebp,%ecx
  801b79:	d3 ea                	shr    %cl,%edx
  801b7b:	09 d0                	or     %edx,%eax
  801b7d:	89 e9                	mov    %ebp,%ecx
  801b7f:	d3 eb                	shr    %cl,%ebx
  801b81:	89 da                	mov    %ebx,%edx
  801b83:	83 c4 1c             	add    $0x1c,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5e                   	pop    %esi
  801b88:	5f                   	pop    %edi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    
  801b8b:	90                   	nop
  801b8c:	89 fd                	mov    %edi,%ebp
  801b8e:	85 ff                	test   %edi,%edi
  801b90:	75 0b                	jne    801b9d <__umoddi3+0xe9>
  801b92:	b8 01 00 00 00       	mov    $0x1,%eax
  801b97:	31 d2                	xor    %edx,%edx
  801b99:	f7 f7                	div    %edi
  801b9b:	89 c5                	mov    %eax,%ebp
  801b9d:	89 f0                	mov    %esi,%eax
  801b9f:	31 d2                	xor    %edx,%edx
  801ba1:	f7 f5                	div    %ebp
  801ba3:	89 c8                	mov    %ecx,%eax
  801ba5:	f7 f5                	div    %ebp
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	e9 44 ff ff ff       	jmp    801af2 <__umoddi3+0x3e>
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	89 c8                	mov    %ecx,%eax
  801bb2:	89 f2                	mov    %esi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	3b 04 24             	cmp    (%esp),%eax
  801bbf:	72 06                	jb     801bc7 <__umoddi3+0x113>
  801bc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bc5:	77 0f                	ja     801bd6 <__umoddi3+0x122>
  801bc7:	89 f2                	mov    %esi,%edx
  801bc9:	29 f9                	sub    %edi,%ecx
  801bcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bcf:	89 14 24             	mov    %edx,(%esp)
  801bd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bda:	8b 14 24             	mov    (%esp),%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	2b 04 24             	sub    (%esp),%eax
  801beb:	19 fa                	sbb    %edi,%edx
  801bed:	89 d1                	mov    %edx,%ecx
  801bef:	89 c6                	mov    %eax,%esi
  801bf1:	e9 71 ff ff ff       	jmp    801b67 <__umoddi3+0xb3>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bfc:	72 ea                	jb     801be8 <__umoddi3+0x134>
  801bfe:	89 d9                	mov    %ebx,%ecx
  801c00:	e9 62 ff ff ff       	jmp    801b67 <__umoddi3+0xb3>
