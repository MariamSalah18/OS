
obj/user/tst_page_replacement_LRU_Lists_1:     file format elf32-i386


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
  800031:	e8 29 02 00 00       	call   80025f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 54             	sub    $0x54,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	{
		//uint32 actual_active_list[5] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x203000};
		uint32 actual_active_list[5] ;
		{
			actual_active_list[0] = 0x803000;
  80003f:	c7 45 c4 00 30 80 00 	movl   $0x803000,-0x3c(%ebp)
			actual_active_list[1] = 0x801000;
  800046:	c7 45 c8 00 10 80 00 	movl   $0x801000,-0x38(%ebp)
			actual_active_list[2] = 0x800000;
  80004d:	c7 45 cc 00 00 80 00 	movl   $0x800000,-0x34(%ebp)
			actual_active_list[3] = 0xeebfd000;
  800054:	c7 45 d0 00 d0 bf ee 	movl   $0xeebfd000,-0x30(%ebp)
			actual_active_list[4] = 0x203000;
  80005b:	c7 45 d4 00 30 20 00 	movl   $0x203000,-0x2c(%ebp)
		}
		//uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
		uint32 actual_second_list[5] ;
		{
			actual_second_list[0] = 0x202000 ;
  800062:	c7 45 b0 00 20 20 00 	movl   $0x202000,-0x50(%ebp)
			actual_second_list[1] = 0x201000 ;
  800069:	c7 45 b4 00 10 20 00 	movl   $0x201000,-0x4c(%ebp)
			actual_second_list[2] = 0x200000 ;
  800070:	c7 45 b8 00 00 20 00 	movl   $0x200000,-0x48(%ebp)
			actual_second_list[3] = 0x802000 ;
  800077:	c7 45 bc 00 20 80 00 	movl   $0x802000,-0x44(%ebp)
			actual_second_list[4] = 0x205000 ;
  80007e:	c7 45 c0 00 50 20 00 	movl   $0x205000,-0x40(%ebp)
		}
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 5, 5);
  800085:	6a 05                	push   $0x5
  800087:	6a 05                	push   $0x5
  800089:	8d 45 b0             	lea    -0x50(%ebp),%eax
  80008c:	50                   	push   %eax
  80008d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800090:	50                   	push   %eax
  800091:	e8 75 19 00 00       	call   801a0b <sys_check_LRU_lists>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(check == 0)
  80009c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000a0:	75 14                	jne    8000b6 <_main+0x7e>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	68 80 1d 80 00       	push   $0x801d80
  8000aa:	6a 28                	push   $0x28
  8000ac:	68 04 1e 80 00       	push   $0x801e04
  8000b1:	e8 d7 02 00 00       	call   80038d <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8000b6:	e8 75 14 00 00       	call   801530 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000be:	e8 b8 14 00 00       	call   80157b <sys_pf_calculate_allocated_pages>
  8000c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000c6:	a0 3f e0 80 00       	mov    0x80e03f,%al
  8000cb:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000ce:	a0 3f f0 80 00       	mov    0x80f03f,%al
  8000d3:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000dd:	eb 4a                	jmp    800129 <_main+0xf1>
	{
		arr[i] = 'A' ;
  8000df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e2:	05 40 30 80 00       	add    $0x803040,%eax
  8000e7:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr + garbage5;
  8000ea:	a1 00 30 80 00       	mov    0x803000,%eax
  8000ef:	8a 00                	mov    (%eax),%al
  8000f1:	88 c2                	mov    %al,%dl
  8000f3:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *ptr2 + garbage4;
  8000fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800100:	8a 00                	mov    (%eax),%al
  800102:	88 c2                	mov    %al,%dl
  800104:	8a 45 e1             	mov    -0x1f(%ebp),%al
  800107:	01 d0                	add    %edx,%eax
  800109:	88 45 f7             	mov    %al,-0x9(%ebp)
		ptr++ ; ptr2++ ;
  80010c:	a1 00 30 80 00       	mov    0x803000,%eax
  800111:	40                   	inc    %eax
  800112:	a3 00 30 80 00       	mov    %eax,0x803000
  800117:	a1 04 30 80 00       	mov    0x803004,%eax
  80011c:	40                   	inc    %eax
  80011d:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800122:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  800129:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  800130:	7e ad                	jle    8000df <_main+0xa7>
		ptr++ ; ptr2++ ;
	}

	//===================

	cprintf("Checking Allocation in Mem & Page File... \n");
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 2c 1e 80 00       	push   $0x801e2c
  80013a:	e8 0b 05 00 00       	call   80064a <cprintf>
  80013f:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800142:	e8 34 14 00 00       	call   80157b <sys_pf_calculate_allocated_pages>
  800147:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80014a:	74 14                	je     800160 <_main+0x128>
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 58 1e 80 00       	push   $0x801e58
  800154:	6a 45                	push   $0x45
  800156:	68 04 1e 80 00       	push   $0x801e04
  80015b:	e8 2d 02 00 00       	call   80038d <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800160:	e8 cb 13 00 00       	call   801530 <sys_calculate_free_frames>
  800165:	89 c3                	mov    %eax,%ebx
  800167:	e8 dd 13 00 00       	call   801549 <sys_calculate_modified_frames>
  80016c:	01 d8                	add    %ebx,%eax
  80016e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("freePages %d\n",freePages);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	ff 75 e8             	pushl  -0x18(%ebp)
  800177:	68 c2 1e 80 00       	push   $0x801ec2
  80017c:	e8 c9 04 00 00       	call   80064a <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
		cprintf("freePagesAfter %d\n",freePagesAfter);
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	ff 75 dc             	pushl  -0x24(%ebp)
  80018a:	68 d0 1e 80 00       	push   $0x801ed0
  80018f:	e8 b6 04 00 00       	call   80064a <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		if( (freePages - freePagesAfter) != 0 )
  800197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80019a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019d:	74 14                	je     8001b3 <_main+0x17b>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 e4 1e 80 00       	push   $0x801ee4
  8001a7:	6a 4b                	push   $0x4b
  8001a9:	68 04 1e 80 00       	push   $0x801e04
  8001ae:	e8 da 01 00 00       	call   80038d <_panic>
	}

	cprintf("\nChecking CONTENT in Mem ... \n");
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 48 1f 80 00       	push   $0x801f48
  8001bb:	e8 8a 04 00 00       	call   80064a <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8001c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001ca:	eb 29                	jmp    8001f5 <_main+0x1bd>
			if( arr[i] != 'A') panic("Modified page(s) not restored correctly");
  8001cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cf:	05 40 30 80 00       	add    $0x803040,%eax
  8001d4:	8a 00                	mov    (%eax),%al
  8001d6:	3c 41                	cmp    $0x41,%al
  8001d8:	74 14                	je     8001ee <_main+0x1b6>
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	68 68 1f 80 00       	push   $0x801f68
  8001e2:	6a 51                	push   $0x51
  8001e4:	68 04 1e 80 00       	push   $0x801e04
  8001e9:	e8 9f 01 00 00       	call   80038d <_panic>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
	}

	cprintf("\nChecking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8001ee:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8001f5:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8001fc:	7e ce                	jle    8001cc <_main+0x194>
			if( arr[i] != 'A') panic("Modified page(s) not restored correctly");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8001fe:	e8 78 13 00 00       	call   80157b <sys_pf_calculate_allocated_pages>
  800203:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800206:	74 14                	je     80021c <_main+0x1e4>
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	68 58 1e 80 00       	push   $0x801e58
  800210:	6a 52                	push   $0x52
  800212:	68 04 1e 80 00       	push   $0x801e04
  800217:	e8 71 01 00 00       	call   80038d <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  80021c:	e8 0f 13 00 00       	call   801530 <sys_calculate_free_frames>
  800221:	89 c3                	mov    %eax,%ebx
  800223:	e8 21 13 00 00       	call   801549 <sys_calculate_modified_frames>
  800228:	01 d8                	add    %ebx,%eax
  80022a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  80022d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800230:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800233:	74 14                	je     800249 <_main+0x211>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 e4 1e 80 00       	push   $0x801ee4
  80023d:	6a 56                	push   $0x56
  80023f:	68 04 1e 80 00       	push   $0x801e04
  800244:	e8 44 01 00 00       	call   80038d <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] using APRROXIMATED LRU is completed successfully.\n");
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 90 1f 80 00       	push   $0x801f90
  800251:	e8 f4 03 00 00       	call   80064a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	return;
  800259:	90                   	nop
}
  80025a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800265:	e8 51 15 00 00       	call   8017bb <sys_getenvindex>
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800270:	89 d0                	mov    %edx,%eax
  800272:	01 c0                	add    %eax,%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c1 e0 06             	shl    $0x6,%eax
  800279:	29 d0                	sub    %edx,%eax
  80027b:	c1 e0 03             	shl    $0x3,%eax
  80027e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800283:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8a 40 68             	mov    0x68(%eax),%al
  800290:	84 c0                	test   %al,%al
  800292:	74 0d                	je     8002a1 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800294:	a1 20 30 80 00       	mov    0x803020,%eax
  800299:	83 c0 68             	add    $0x68,%eax
  80029c:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a5:	7e 0a                	jle    8002b1 <libmain+0x52>
		binaryname = argv[0];
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	ff 75 0c             	pushl  0xc(%ebp)
  8002b7:	ff 75 08             	pushl  0x8(%ebp)
  8002ba:	e8 79 fd ff ff       	call   800038 <_main>
  8002bf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c2:	e8 01 13 00 00       	call   8015c8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	68 10 20 80 00       	push   $0x802010
  8002cf:	e8 76 03 00 00       	call   80064a <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8002e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e7:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	52                   	push   %edx
  8002f1:	50                   	push   %eax
  8002f2:	68 38 20 80 00       	push   $0x802038
  8002f7:	e8 4e 03 00 00       	call   80064a <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800304:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80030a:	a1 20 30 80 00       	mov    0x803020,%eax
  80030f:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800315:	a1 20 30 80 00       	mov    0x803020,%eax
  80031a:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800320:	51                   	push   %ecx
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	68 60 20 80 00       	push   $0x802060
  800328:	e8 1d 03 00 00       	call   80064a <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800330:	a1 20 30 80 00       	mov    0x803020,%eax
  800335:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	68 b8 20 80 00       	push   $0x8020b8
  800344:	e8 01 03 00 00       	call   80064a <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 10 20 80 00       	push   $0x802010
  800354:	e8 f1 02 00 00       	call   80064a <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035c:	e8 81 12 00 00       	call   8015e2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800361:	e8 19 00 00 00       	call   80037f <exit>
}
  800366:	90                   	nop
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	6a 00                	push   $0x0
  800374:	e8 0e 14 00 00       	call   801787 <sys_destroy_env>
  800379:	83 c4 10             	add    $0x10,%esp
}
  80037c:	90                   	nop
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <exit>:

void
exit(void)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800385:	e8 63 14 00 00       	call   8017ed <sys_exit_env>
}
  80038a:	90                   	nop
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    

0080038d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800393:	8d 45 10             	lea    0x10(%ebp),%eax
  800396:	83 c0 04             	add    $0x4,%eax
  800399:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039c:	a1 18 f1 80 00       	mov    0x80f118,%eax
  8003a1:	85 c0                	test   %eax,%eax
  8003a3:	74 16                	je     8003bb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a5:	a1 18 f1 80 00       	mov    0x80f118,%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 cc 20 80 00       	push   $0x8020cc
  8003b3:	e8 92 02 00 00       	call   80064a <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003bb:	a1 08 30 80 00       	mov    0x803008,%eax
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	68 d1 20 80 00       	push   $0x8020d1
  8003cc:	e8 79 02 00 00       	call   80064a <cprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dd:	50                   	push   %eax
  8003de:	e8 fc 01 00 00       	call   8005df <vcprintf>
  8003e3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	6a 00                	push   $0x0
  8003eb:	68 ed 20 80 00       	push   $0x8020ed
  8003f0:	e8 ea 01 00 00       	call   8005df <vcprintf>
  8003f5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f8:	e8 82 ff ff ff       	call   80037f <exit>

	// should not return here
	while (1) ;
  8003fd:	eb fe                	jmp    8003fd <_panic+0x70>

008003ff <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800405:	a1 20 30 80 00       	mov    0x803020,%eax
  80040a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 f0 20 80 00       	push   $0x8020f0
  80041f:	6a 26                	push   $0x26
  800421:	68 3c 21 80 00       	push   $0x80213c
  800426:	e8 62 ff ff ff       	call   80038d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c5 00 00 00       	jmp    800503 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a5 00 00 00       	jmp    800500 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 30 80 00       	mov    0x803020,%eax
  800470:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 15                	jmp    8004e6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	39 c2                	cmp    %eax,%edx
  8004e4:	77 85                	ja     80046b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004ea:	75 14                	jne    800500 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004ec:	83 ec 04             	sub    $0x4,%esp
  8004ef:	68 48 21 80 00       	push   $0x802148
  8004f4:	6a 3a                	push   $0x3a
  8004f6:	68 3c 21 80 00       	push   $0x80213c
  8004fb:	e8 8d fe ff ff       	call   80038d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800500:	ff 45 f0             	incl   -0x10(%ebp)
  800503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800506:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800509:	0f 8c 2f ff ff ff    	jl     80043e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800516:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051d:	eb 26                	jmp    800545 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051f:	a1 20 30 80 00       	mov    0x803020,%eax
  800524:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80052a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052d:	89 d0                	mov    %edx,%eax
  80052f:	01 c0                	add    %eax,%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	c1 e0 03             	shl    $0x3,%eax
  800536:	01 c8                	add    %ecx,%eax
  800538:	8a 40 04             	mov    0x4(%eax),%al
  80053b:	3c 01                	cmp    $0x1,%al
  80053d:	75 03                	jne    800542 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80053f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800542:	ff 45 e0             	incl   -0x20(%ebp)
  800545:	a1 20 30 80 00       	mov    0x803020,%eax
  80054a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800553:	39 c2                	cmp    %eax,%edx
  800555:	77 c8                	ja     80051f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80055d:	74 14                	je     800573 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 9c 21 80 00       	push   $0x80219c
  800567:	6a 44                	push   $0x44
  800569:	68 3c 21 80 00       	push   $0x80213c
  80056e:	e8 1a fe ff ff       	call   80038d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80057c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	8d 48 01             	lea    0x1(%eax),%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	89 0a                	mov    %ecx,(%edx)
  800589:	8b 55 08             	mov    0x8(%ebp),%edx
  80058c:	88 d1                	mov    %dl,%cl
  80058e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800591:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80059f:	75 2c                	jne    8005cd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a1:	a0 24 30 80 00       	mov    0x803024,%al
  8005a6:	0f b6 c0             	movzbl %al,%eax
  8005a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ac:	8b 12                	mov    (%edx),%edx
  8005ae:	89 d1                	mov    %edx,%ecx
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	83 c2 08             	add    $0x8,%edx
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	50                   	push   %eax
  8005ba:	51                   	push   %ecx
  8005bb:	52                   	push   %edx
  8005bc:	e8 ae 0e 00 00       	call   80146f <sys_cputs>
  8005c1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 40 04             	mov    0x4(%eax),%eax
  8005d3:	8d 50 01             	lea    0x1(%eax),%edx
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005dc:	90                   	nop
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ef:	00 00 00 
	b.cnt = 0;
  8005f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	ff 75 08             	pushl  0x8(%ebp)
  800602:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800608:	50                   	push   %eax
  800609:	68 76 05 80 00       	push   $0x800576
  80060e:	e8 11 02 00 00       	call   800824 <vprintfmt>
  800613:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800616:	a0 24 30 80 00       	mov    0x803024,%al
  80061b:	0f b6 c0             	movzbl %al,%eax
  80061e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800624:	83 ec 04             	sub    $0x4,%esp
  800627:	50                   	push   %eax
  800628:	52                   	push   %edx
  800629:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80062f:	83 c0 08             	add    $0x8,%eax
  800632:	50                   	push   %eax
  800633:	e8 37 0e 00 00       	call   80146f <sys_cputs>
  800638:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80063b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800642:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <cprintf>:

int cprintf(const char *fmt, ...) {
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
  80064d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800650:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800657:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	ff 75 f4             	pushl  -0xc(%ebp)
  800666:	50                   	push   %eax
  800667:	e8 73 ff ff ff       	call   8005df <vcprintf>
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800672:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80067d:	e8 46 0f 00 00       	call   8015c8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800682:	8d 45 0c             	lea    0xc(%ebp),%eax
  800685:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 f4             	pushl  -0xc(%ebp)
  800691:	50                   	push   %eax
  800692:	e8 48 ff ff ff       	call   8005df <vcprintf>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80069d:	e8 40 0f 00 00       	call   8015e2 <sys_enable_interrupt>
	return cnt;
  8006a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	53                   	push   %ebx
  8006ab:	83 ec 14             	sub    $0x14,%esp
  8006ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c5:	77 55                	ja     80071c <printnum+0x75>
  8006c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ca:	72 05                	jb     8006d1 <printnum+0x2a>
  8006cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006cf:	77 4b                	ja     80071c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
  8006df:	52                   	push   %edx
  8006e0:	50                   	push   %eax
  8006e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e7:	e8 28 14 00 00       	call   801b14 <__udivdi3>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	ff 75 20             	pushl  0x20(%ebp)
  8006f5:	53                   	push   %ebx
  8006f6:	ff 75 18             	pushl  0x18(%ebp)
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	e8 a1 ff ff ff       	call   8006a7 <printnum>
  800706:	83 c4 20             	add    $0x20,%esp
  800709:	eb 1a                	jmp    800725 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	ff 75 20             	pushl  0x20(%ebp)
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80071c:	ff 4d 1c             	decl   0x1c(%ebp)
  80071f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800723:	7f e6                	jg     80070b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800725:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800733:	53                   	push   %ebx
  800734:	51                   	push   %ecx
  800735:	52                   	push   %edx
  800736:	50                   	push   %eax
  800737:	e8 e8 14 00 00       	call   801c24 <__umoddi3>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	05 14 24 80 00       	add    $0x802414,%eax
  800744:	8a 00                	mov    (%eax),%al
  800746:	0f be c0             	movsbl %al,%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	50                   	push   %eax
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	ff d0                	call   *%eax
  800755:	83 c4 10             	add    $0x10,%esp
}
  800758:	90                   	nop
  800759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    

0080075e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800761:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800765:	7e 1c                	jle    800783 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	8d 50 08             	lea    0x8(%eax),%edx
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	89 10                	mov    %edx,(%eax)
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	83 e8 08             	sub    $0x8,%eax
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	eb 40                	jmp    8007c3 <getuint+0x65>
	else if (lflag)
  800783:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800787:	74 1e                	je     8007a7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	eb 1c                	jmp    8007c3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8d 50 04             	lea    0x4(%eax),%edx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 10                	mov    %edx,(%eax)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cc:	7e 1c                	jle    8007ea <getint+0x25>
		return va_arg(*ap, long long);
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	8d 50 08             	lea    0x8(%eax),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	89 10                	mov    %edx,(%eax)
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	83 e8 08             	sub    $0x8,%eax
  8007e3:	8b 50 04             	mov    0x4(%eax),%edx
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	eb 38                	jmp    800822 <getint+0x5d>
	else if (lflag)
  8007ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ee:	74 1a                	je     80080a <getint+0x45>
		return va_arg(*ap, long);
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	8d 50 04             	lea    0x4(%eax),%edx
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	89 10                	mov    %edx,(%eax)
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	83 e8 04             	sub    $0x4,%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	99                   	cltd   
  800808:	eb 18                	jmp    800822 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	8d 50 04             	lea    0x4(%eax),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	89 10                	mov    %edx,(%eax)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 e8 04             	sub    $0x4,%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	99                   	cltd   
}
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	56                   	push   %esi
  800828:	53                   	push   %ebx
  800829:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082c:	eb 17                	jmp    800845 <vprintfmt+0x21>
			if (ch == '\0')
  80082e:	85 db                	test   %ebx,%ebx
  800830:	0f 84 af 03 00 00    	je     800be5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	53                   	push   %ebx
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800845:	8b 45 10             	mov    0x10(%ebp),%eax
  800848:	8d 50 01             	lea    0x1(%eax),%edx
  80084b:	89 55 10             	mov    %edx,0x10(%ebp)
  80084e:	8a 00                	mov    (%eax),%al
  800850:	0f b6 d8             	movzbl %al,%ebx
  800853:	83 fb 25             	cmp    $0x25,%ebx
  800856:	75 d6                	jne    80082e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800858:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80085c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800863:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80086a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800871:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800878:	8b 45 10             	mov    0x10(%ebp),%eax
  80087b:	8d 50 01             	lea    0x1(%eax),%edx
  80087e:	89 55 10             	mov    %edx,0x10(%ebp)
  800881:	8a 00                	mov    (%eax),%al
  800883:	0f b6 d8             	movzbl %al,%ebx
  800886:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800889:	83 f8 55             	cmp    $0x55,%eax
  80088c:	0f 87 2b 03 00 00    	ja     800bbd <vprintfmt+0x399>
  800892:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  800899:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80089b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d7                	jmp    800878 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008a5:	eb d1                	jmp    800878 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b1:	89 d0                	mov    %edx,%eax
  8008b3:	c1 e0 02             	shl    $0x2,%eax
  8008b6:	01 d0                	add    %edx,%eax
  8008b8:	01 c0                	add    %eax,%eax
  8008ba:	01 d8                	add    %ebx,%eax
  8008bc:	83 e8 30             	sub    $0x30,%eax
  8008bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c5:	8a 00                	mov    (%eax),%al
  8008c7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ca:	83 fb 2f             	cmp    $0x2f,%ebx
  8008cd:	7e 3e                	jle    80090d <vprintfmt+0xe9>
  8008cf:	83 fb 39             	cmp    $0x39,%ebx
  8008d2:	7f 39                	jg     80090d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d7:	eb d5                	jmp    8008ae <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 c0 04             	add    $0x4,%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	83 e8 04             	sub    $0x4,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008ed:	eb 1f                	jmp    80090e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f3:	79 83                	jns    800878 <vprintfmt+0x54>
				width = 0;
  8008f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008fc:	e9 77 ff ff ff       	jmp    800878 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800901:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800908:	e9 6b ff ff ff       	jmp    800878 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80090d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80090e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800912:	0f 89 60 ff ff ff    	jns    800878 <vprintfmt+0x54>
				width = precision, precision = -1;
  800918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800925:	e9 4e ff ff ff       	jmp    800878 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80092a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80092d:	e9 46 ff ff ff       	jmp    800878 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 c0 04             	add    $0x4,%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	50                   	push   %eax
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
			break;
  800952:	e9 89 02 00 00       	jmp    800be0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800968:	85 db                	test   %ebx,%ebx
  80096a:	79 02                	jns    80096e <vprintfmt+0x14a>
				err = -err;
  80096c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80096e:	83 fb 64             	cmp    $0x64,%ebx
  800971:	7f 0b                	jg     80097e <vprintfmt+0x15a>
  800973:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  80097a:	85 f6                	test   %esi,%esi
  80097c:	75 19                	jne    800997 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80097e:	53                   	push   %ebx
  80097f:	68 25 24 80 00       	push   $0x802425
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 5e 02 00 00       	call   800bed <printfmt>
  80098f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800992:	e9 49 02 00 00       	jmp    800be0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800997:	56                   	push   %esi
  800998:	68 2e 24 80 00       	push   $0x80242e
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	ff 75 08             	pushl  0x8(%ebp)
  8009a3:	e8 45 02 00 00       	call   800bed <printfmt>
  8009a8:	83 c4 10             	add    $0x10,%esp
			break;
  8009ab:	e9 30 02 00 00       	jmp    800be0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 c0 04             	add    $0x4,%eax
  8009b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	83 e8 04             	sub    $0x4,%eax
  8009bf:	8b 30                	mov    (%eax),%esi
  8009c1:	85 f6                	test   %esi,%esi
  8009c3:	75 05                	jne    8009ca <vprintfmt+0x1a6>
				p = "(null)";
  8009c5:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  8009ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ce:	7e 6d                	jle    800a3d <vprintfmt+0x219>
  8009d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009d4:	74 67                	je     800a3d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	50                   	push   %eax
  8009dd:	56                   	push   %esi
  8009de:	e8 0c 03 00 00       	call   800cef <strnlen>
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e9:	eb 16                	jmp    800a01 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009eb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	50                   	push   %eax
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	7f e4                	jg     8009eb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a07:	eb 34                	jmp    800a3d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a09:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a0d:	74 1c                	je     800a2b <vprintfmt+0x207>
  800a0f:	83 fb 1f             	cmp    $0x1f,%ebx
  800a12:	7e 05                	jle    800a19 <vprintfmt+0x1f5>
  800a14:	83 fb 7e             	cmp    $0x7e,%ebx
  800a17:	7e 12                	jle    800a2b <vprintfmt+0x207>
					putch('?', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 3f                	push   $0x3f
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	eb 0f                	jmp    800a3a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3d:	89 f0                	mov    %esi,%eax
  800a3f:	8d 70 01             	lea    0x1(%eax),%esi
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	0f be d8             	movsbl %al,%ebx
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	74 24                	je     800a6f <vprintfmt+0x24b>
  800a4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4f:	78 b8                	js     800a09 <vprintfmt+0x1e5>
  800a51:	ff 4d e0             	decl   -0x20(%ebp)
  800a54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a58:	79 af                	jns    800a09 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5a:	eb 13                	jmp    800a6f <vprintfmt+0x24b>
				putch(' ', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 20                	push   $0x20
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a6c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a73:	7f e7                	jg     800a5c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a75:	e9 66 01 00 00       	jmp    800be0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a80:	8d 45 14             	lea    0x14(%ebp),%eax
  800a83:	50                   	push   %eax
  800a84:	e8 3c fd ff ff       	call   8007c5 <getint>
  800a89:	83 c4 10             	add    $0x10,%esp
  800a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a98:	85 d2                	test   %edx,%edx
  800a9a:	79 23                	jns    800abf <vprintfmt+0x29b>
				putch('-', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 2d                	push   $0x2d
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab2:	f7 d8                	neg    %eax
  800ab4:	83 d2 00             	adc    $0x0,%edx
  800ab7:	f7 da                	neg    %edx
  800ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800abf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac6:	e9 bc 00 00 00       	jmp    800b87 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad4:	50                   	push   %eax
  800ad5:	e8 84 fc ff ff       	call   80075e <getuint>
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ae3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aea:	e9 98 00 00 00       	jmp    800b87 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 58                	push   $0x58
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 58                	push   $0x58
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 58                	push   $0x58
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			break;
  800b1f:	e9 bc 00 00 00       	jmp    800be0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	6a 30                	push   $0x30
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	6a 78                	push   $0x78
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	83 c0 04             	add    $0x4,%eax
  800b4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	83 e8 04             	sub    $0x4,%eax
  800b53:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b66:	eb 1f                	jmp    800b87 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	e8 e7 fb ff ff       	call   80075e <getuint>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b87:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8e:	83 ec 04             	sub    $0x4,%esp
  800b91:	52                   	push   %edx
  800b92:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b95:	50                   	push   %eax
  800b96:	ff 75 f4             	pushl  -0xc(%ebp)
  800b99:	ff 75 f0             	pushl  -0x10(%ebp)
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	ff 75 08             	pushl  0x8(%ebp)
  800ba2:	e8 00 fb ff ff       	call   8006a7 <printnum>
  800ba7:	83 c4 20             	add    $0x20,%esp
			break;
  800baa:	eb 34                	jmp    800be0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	53                   	push   %ebx
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
			break;
  800bbb:	eb 23                	jmp    800be0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	6a 25                	push   $0x25
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bcd:	ff 4d 10             	decl   0x10(%ebp)
  800bd0:	eb 03                	jmp    800bd5 <vprintfmt+0x3b1>
  800bd2:	ff 4d 10             	decl   0x10(%ebp)
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	48                   	dec    %eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	3c 25                	cmp    $0x25,%al
  800bdd:	75 f3                	jne    800bd2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bdf:	90                   	nop
		}
	}
  800be0:	e9 47 fc ff ff       	jmp    80082c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800be5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bf3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf6:	83 c0 04             	add    $0x4,%eax
  800bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bff:	ff 75 f4             	pushl  -0xc(%ebp)
  800c02:	50                   	push   %eax
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	ff 75 08             	pushl  0x8(%ebp)
  800c09:	e8 16 fc ff ff       	call   800824 <vprintfmt>
  800c0e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c11:	90                   	nop
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	8b 40 08             	mov    0x8(%eax),%eax
  800c1d:	8d 50 01             	lea    0x1(%eax),%edx
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 10                	mov    (%eax),%edx
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2e:	8b 40 04             	mov    0x4(%eax),%eax
  800c31:	39 c2                	cmp    %eax,%edx
  800c33:	73 12                	jae    800c47 <sprintputch+0x33>
		*b->buf++ = ch;
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	8d 48 01             	lea    0x1(%eax),%ecx
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	89 0a                	mov    %ecx,(%edx)
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	88 10                	mov    %dl,(%eax)
}
  800c47:	90                   	nop
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c6f:	74 06                	je     800c77 <vsnprintf+0x2d>
  800c71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c75:	7f 07                	jg     800c7e <vsnprintf+0x34>
		return -E_INVAL;
  800c77:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7c:	eb 20                	jmp    800c9e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7e:	ff 75 14             	pushl  0x14(%ebp)
  800c81:	ff 75 10             	pushl  0x10(%ebp)
  800c84:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c87:	50                   	push   %eax
  800c88:	68 14 0c 80 00       	push   $0x800c14
  800c8d:	e8 92 fb ff ff       	call   800824 <vprintfmt>
  800c92:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c98:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca9:	83 c0 04             	add    $0x4,%eax
  800cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800caf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb5:	50                   	push   %eax
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	ff 75 08             	pushl  0x8(%ebp)
  800cbc:	e8 89 ff ff ff       	call   800c4a <vsnprintf>
  800cc1:	83 c4 10             	add    $0x10,%esp
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd9:	eb 06                	jmp    800ce1 <strlen+0x15>
		n++;
  800cdb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 f1                	jne    800cdb <strlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfc:	eb 09                	jmp    800d07 <strnlen+0x18>
		n++;
  800cfe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 4d 0c             	decl   0xc(%ebp)
  800d07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0b:	74 09                	je     800d16 <strnlen+0x27>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	75 e8                	jne    800cfe <strnlen+0xf>
		n++;
	return n;
  800d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d27:	90                   	nop
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8d 50 01             	lea    0x1(%eax),%edx
  800d2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d3a:	8a 12                	mov    (%edx),%dl
  800d3c:	88 10                	mov    %dl,(%eax)
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	75 e4                	jne    800d28 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5c:	eb 1f                	jmp    800d7d <strncpy+0x34>
		*dst++ = *src;
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8d 50 01             	lea    0x1(%eax),%edx
  800d64:	89 55 08             	mov    %edx,0x8(%ebp)
  800d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6a:	8a 12                	mov    (%edx),%dl
  800d6c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	74 03                	je     800d7a <strncpy+0x31>
			src++;
  800d77:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d80:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d83:	72 d9                	jb     800d5e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9a:	74 30                	je     800dcc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d9c:	eb 16                	jmp    800db4 <strlcpy+0x2a>
			*dst++ = *src++;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 08             	mov    %edx,0x8(%ebp)
  800da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db0:	8a 12                	mov    (%edx),%dl
  800db2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	74 09                	je     800dc6 <strlcpy+0x3c>
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	75 d8                	jne    800d9e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	29 c2                	sub    %eax,%edx
  800dd4:	89 d0                	mov    %edx,%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ddb:	eb 06                	jmp    800de3 <strcmp+0xb>
		p++, q++;
  800ddd:	ff 45 08             	incl   0x8(%ebp)
  800de0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	84 c0                	test   %al,%al
  800dea:	74 0e                	je     800dfa <strcmp+0x22>
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 10                	mov    (%eax),%dl
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	38 c2                	cmp    %al,%dl
  800df8:	74 e3                	je     800ddd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	0f b6 d0             	movzbl %al,%edx
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f b6 c0             	movzbl %al,%eax
  800e0a:	29 c2                	sub    %eax,%edx
  800e0c:	89 d0                	mov    %edx,%eax
}
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e13:	eb 09                	jmp    800e1e <strncmp+0xe>
		n--, p++, q++;
  800e15:	ff 4d 10             	decl   0x10(%ebp)
  800e18:	ff 45 08             	incl   0x8(%ebp)
  800e1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	74 17                	je     800e3b <strncmp+0x2b>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 0e                	je     800e3b <strncmp+0x2b>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 10                	mov    (%eax),%dl
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	38 c2                	cmp    %al,%dl
  800e39:	74 da                	je     800e15 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	75 07                	jne    800e48 <strncmp+0x38>
		return 0;
  800e41:	b8 00 00 00 00       	mov    $0x0,%eax
  800e46:	eb 14                	jmp    800e5c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 d0             	movzbl %al,%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
}
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 04             	sub    $0x4,%esp
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6a:	eb 12                	jmp    800e7e <strchr+0x20>
		if (*s == c)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e74:	75 05                	jne    800e7b <strchr+0x1d>
			return (char *) s;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	eb 11                	jmp    800e8c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e7b:	ff 45 08             	incl   0x8(%ebp)
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	75 e5                	jne    800e6c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 04             	sub    $0x4,%esp
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e9a:	eb 0d                	jmp    800ea9 <strfind+0x1b>
		if (*s == c)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ea4:	74 0e                	je     800eb4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 ea                	jne    800e9c <strfind+0xe>
  800eb2:	eb 01                	jmp    800eb5 <strfind+0x27>
		if (*s == c)
			break;
  800eb4:	90                   	nop
	return (char *) s;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ecc:	eb 0e                	jmp    800edc <memset+0x22>
		*p++ = c;
  800ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed1:	8d 50 01             	lea    0x1(%eax),%edx
  800ed4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eda:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800edc:	ff 4d f8             	decl   -0x8(%ebp)
  800edf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ee3:	79 e9                	jns    800ece <memset+0x14>
		*p++ = c;

	return v;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800efc:	eb 16                	jmp    800f14 <memcpy+0x2a>
		*d++ = *s++;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	8d 50 01             	lea    0x1(%eax),%edx
  800f04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f10:	8a 12                	mov    (%edx),%dl
  800f12:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	75 dd                	jne    800efe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f3e:	73 50                	jae    800f90 <memmove+0x6a>
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	01 d0                	add    %edx,%eax
  800f48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f4b:	76 43                	jbe    800f90 <memmove+0x6a>
		s += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f59:	eb 10                	jmp    800f6b <memmove+0x45>
			*--d = *--s;
  800f5b:	ff 4d f8             	decl   -0x8(%ebp)
  800f5e:	ff 4d fc             	decl   -0x4(%ebp)
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f64:	8a 10                	mov    (%eax),%dl
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f71:	89 55 10             	mov    %edx,0x10(%ebp)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	75 e3                	jne    800f5b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f78:	eb 23                	jmp    800f9d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 dd                	jne    800f7a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fb4:	eb 2a                	jmp    800fe0 <memcmp+0x3e>
		if (*s1 != *s2)
  800fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb9:	8a 10                	mov    (%eax),%dl
  800fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	38 c2                	cmp    %al,%dl
  800fc2:	74 16                	je     800fda <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	0f b6 d0             	movzbl %al,%edx
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	0f b6 c0             	movzbl %al,%eax
  800fd4:	29 c2                	sub    %eax,%edx
  800fd6:	89 d0                	mov    %edx,%eax
  800fd8:	eb 18                	jmp    800ff2 <memcmp+0x50>
		s1++, s2++;
  800fda:	ff 45 fc             	incl   -0x4(%ebp)
  800fdd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	75 c9                	jne    800fb6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	01 d0                	add    %edx,%eax
  801002:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801005:	eb 15                	jmp    80101c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	0f b6 d0             	movzbl %al,%edx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	0f b6 c0             	movzbl %al,%eax
  801015:	39 c2                	cmp    %eax,%edx
  801017:	74 0d                	je     801026 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801022:	72 e3                	jb     801007 <memfind+0x13>
  801024:	eb 01                	jmp    801027 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801026:	90                   	nop
	return (void *) s;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801039:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801040:	eb 03                	jmp    801045 <strtol+0x19>
		s++;
  801042:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 20                	cmp    $0x20,%al
  80104c:	74 f4                	je     801042 <strtol+0x16>
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3c 09                	cmp    $0x9,%al
  801055:	74 eb                	je     801042 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	3c 2b                	cmp    $0x2b,%al
  80105e:	75 05                	jne    801065 <strtol+0x39>
		s++;
  801060:	ff 45 08             	incl   0x8(%ebp)
  801063:	eb 13                	jmp    801078 <strtol+0x4c>
	else if (*s == '-')
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 2d                	cmp    $0x2d,%al
  80106c:	75 0a                	jne    801078 <strtol+0x4c>
		s++, neg = 1;
  80106e:	ff 45 08             	incl   0x8(%ebp)
  801071:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	74 06                	je     801084 <strtol+0x58>
  80107e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801082:	75 20                	jne    8010a4 <strtol+0x78>
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 30                	cmp    $0x30,%al
  80108b:	75 17                	jne    8010a4 <strtol+0x78>
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	40                   	inc    %eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	3c 78                	cmp    $0x78,%al
  801095:	75 0d                	jne    8010a4 <strtol+0x78>
		s += 2, base = 16;
  801097:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80109b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a2:	eb 28                	jmp    8010cc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a8:	75 15                	jne    8010bf <strtol+0x93>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 30                	cmp    $0x30,%al
  8010b1:	75 0c                	jne    8010bf <strtol+0x93>
		s++, base = 8;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
  8010b6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010bd:	eb 0d                	jmp    8010cc <strtol+0xa0>
	else if (base == 0)
  8010bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c3:	75 07                	jne    8010cc <strtol+0xa0>
		base = 10;
  8010c5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 2f                	cmp    $0x2f,%al
  8010d3:	7e 19                	jle    8010ee <strtol+0xc2>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 39                	cmp    $0x39,%al
  8010dc:	7f 10                	jg     8010ee <strtol+0xc2>
			dig = *s - '0';
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f be c0             	movsbl %al,%eax
  8010e6:	83 e8 30             	sub    $0x30,%eax
  8010e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ec:	eb 42                	jmp    801130 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 60                	cmp    $0x60,%al
  8010f5:	7e 19                	jle    801110 <strtol+0xe4>
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 7a                	cmp    $0x7a,%al
  8010fe:	7f 10                	jg     801110 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	0f be c0             	movsbl %al,%eax
  801108:	83 e8 57             	sub    $0x57,%eax
  80110b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80110e:	eb 20                	jmp    801130 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 40                	cmp    $0x40,%al
  801117:	7e 39                	jle    801152 <strtol+0x126>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 5a                	cmp    $0x5a,%al
  801120:	7f 30                	jg     801152 <strtol+0x126>
			dig = *s - 'A' + 10;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	0f be c0             	movsbl %al,%eax
  80112a:	83 e8 37             	sub    $0x37,%eax
  80112d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801133:	3b 45 10             	cmp    0x10(%ebp),%eax
  801136:	7d 19                	jge    801151 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801138:	ff 45 08             	incl   0x8(%ebp)
  80113b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801142:	89 c2                	mov    %eax,%edx
  801144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801147:	01 d0                	add    %edx,%eax
  801149:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80114c:	e9 7b ff ff ff       	jmp    8010cc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801151:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801152:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801156:	74 08                	je     801160 <strtol+0x134>
		*endptr = (char *) s;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801160:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801164:	74 07                	je     80116d <strtol+0x141>
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	f7 d8                	neg    %eax
  80116b:	eb 03                	jmp    801170 <strtol+0x144>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <ltostr>:

void
ltostr(long value, char *str)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80117f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118a:	79 13                	jns    80119f <ltostr+0x2d>
	{
		neg = 1;
  80118c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801199:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80119c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a7:	99                   	cltd   
  8011a8:	f7 f9                	idiv   %ecx
  8011aa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b0:	8d 50 01             	lea    0x1(%eax),%edx
  8011b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c0:	83 c2 30             	add    $0x30,%edx
  8011c3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011cd:	f7 e9                	imul   %ecx
  8011cf:	c1 fa 02             	sar    $0x2,%edx
  8011d2:	89 c8                	mov    %ecx,%eax
  8011d4:	c1 f8 1f             	sar    $0x1f,%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
  8011db:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e6:	f7 e9                	imul   %ecx
  8011e8:	c1 fa 02             	sar    $0x2,%edx
  8011eb:	89 c8                	mov    %ecx,%eax
  8011ed:	c1 f8 1f             	sar    $0x1f,%eax
  8011f0:	29 c2                	sub    %eax,%edx
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	c1 e0 02             	shl    $0x2,%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	01 c0                	add    %eax,%eax
  8011fb:	29 c1                	sub    %eax,%ecx
  8011fd:	89 ca                	mov    %ecx,%edx
  8011ff:	85 d2                	test   %edx,%edx
  801201:	75 9c                	jne    80119f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801203:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	48                   	dec    %eax
  80120e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801211:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801215:	74 3d                	je     801254 <ltostr+0xe2>
		start = 1 ;
  801217:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80121e:	eb 34                	jmp    801254 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80122d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 c2                	add    %eax,%edx
  801235:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	01 c8                	add    %ecx,%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	01 c2                	add    %eax,%edx
  801249:	8a 45 eb             	mov    -0x15(%ebp),%al
  80124c:	88 02                	mov    %al,(%edx)
		start++ ;
  80124e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801251:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80125a:	7c c4                	jl     801220 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80125c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801267:	90                   	nop
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801270:	ff 75 08             	pushl  0x8(%ebp)
  801273:	e8 54 fa ff ff       	call   800ccc <strlen>
  801278:	83 c4 04             	add    $0x4,%esp
  80127b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 46 fa ff ff       	call   800ccc <strlen>
  801286:	83 c4 04             	add    $0x4,%esp
  801289:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80128c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129a:	eb 17                	jmp    8012b3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80129c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 c2                	add    %eax,%edx
  8012a4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	01 c8                	add    %ecx,%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b0:	ff 45 fc             	incl   -0x4(%ebp)
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b9:	7c e1                	jl     80129c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c9:	eb 1f                	jmp    8012ea <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ce:	8d 50 01             	lea    0x1(%eax),%edx
  8012d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d4:	89 c2                	mov    %eax,%edx
  8012d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d9:	01 c2                	add    %eax,%edx
  8012db:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	01 c8                	add    %ecx,%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e7:	ff 45 f8             	incl   -0x8(%ebp)
  8012ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f0:	7c d9                	jl     8012cb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	01 d0                	add    %edx,%eax
  8012fa:	c6 00 00             	movb   $0x0,(%eax)
}
  8012fd:	90                   	nop
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801303:	8b 45 14             	mov    0x14(%ebp),%eax
  801306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80130c:	8b 45 14             	mov    0x14(%ebp),%eax
  80130f:	8b 00                	mov    (%eax),%eax
  801311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	01 d0                	add    %edx,%eax
  80131d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801323:	eb 0c                	jmp    801331 <strsplit+0x31>
			*string++ = 0;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8d 50 01             	lea    0x1(%eax),%edx
  80132b:	89 55 08             	mov    %edx,0x8(%ebp)
  80132e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	84 c0                	test   %al,%al
  801338:	74 18                	je     801352 <strsplit+0x52>
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	0f be c0             	movsbl %al,%eax
  801342:	50                   	push   %eax
  801343:	ff 75 0c             	pushl  0xc(%ebp)
  801346:	e8 13 fb ff ff       	call   800e5e <strchr>
  80134b:	83 c4 08             	add    $0x8,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	75 d3                	jne    801325 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	84 c0                	test   %al,%al
  801359:	74 5a                	je     8013b5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80135b:	8b 45 14             	mov    0x14(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	83 f8 0f             	cmp    $0xf,%eax
  801363:	75 07                	jne    80136c <strsplit+0x6c>
		{
			return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	eb 66                	jmp    8013d2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 48 01             	lea    0x1(%eax),%ecx
  801374:	8b 55 14             	mov    0x14(%ebp),%edx
  801377:	89 0a                	mov    %ecx,(%edx)
  801379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	01 c2                	add    %eax,%edx
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138a:	eb 03                	jmp    80138f <strsplit+0x8f>
			string++;
  80138c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 8b                	je     801323 <strsplit+0x23>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 b5 fa ff ff       	call   800e5e <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	74 dc                	je     80138c <strsplit+0x8c>
			string++;
	}
  8013b0:	e9 6e ff ff ff       	jmp    801323 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8013da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e1:	eb 4c                	jmp    80142f <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8013e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	01 d0                	add    %edx,%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	3c 40                	cmp    $0x40,%al
  8013ef:	7e 27                	jle    801418 <str2lower+0x44>
  8013f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	3c 5a                	cmp    $0x5a,%al
  8013fd:	7f 19                	jg     801418 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8013ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140d:	01 ca                	add    %ecx,%edx
  80140f:	8a 12                	mov    (%edx),%dl
  801411:	83 c2 20             	add    $0x20,%edx
  801414:	88 10                	mov    %dl,(%eax)
  801416:	eb 14                	jmp    80142c <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801418:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	01 c2                	add    %eax,%edx
  801420:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 c8                	add    %ecx,%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80142c:	ff 45 fc             	incl   -0x4(%ebp)
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	e8 95 f8 ff ff       	call   800ccc <strlen>
  801437:	83 c4 04             	add    $0x4,%esp
  80143a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80143d:	7f a4                	jg     8013e3 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	57                   	push   %edi
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
  80144a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801456:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801459:	8b 7d 18             	mov    0x18(%ebp),%edi
  80145c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80145f:	cd 30                	int    $0x30
  801461:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	5b                   	pop    %ebx
  80146b:	5e                   	pop    %esi
  80146c:	5f                   	pop    %edi
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 45 10             	mov    0x10(%ebp),%eax
  801478:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80147b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	52                   	push   %edx
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	50                   	push   %eax
  80148b:	6a 00                	push   $0x0
  80148d:	e8 b2 ff ff ff       	call   801444 <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
}
  801495:	90                   	nop
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_cgetc>:

int
sys_cgetc(void)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 01                	push   $0x1
  8014a7:	e8 98 ff ff ff       	call   801444 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	52                   	push   %edx
  8014c1:	50                   	push   %eax
  8014c2:	6a 05                	push   $0x5
  8014c4:	e8 7b ff ff ff       	call   801444 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	56                   	push   %esi
  8014d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8014d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	56                   	push   %esi
  8014e3:	53                   	push   %ebx
  8014e4:	51                   	push   %ecx
  8014e5:	52                   	push   %edx
  8014e6:	50                   	push   %eax
  8014e7:	6a 06                	push   $0x6
  8014e9:	e8 56 ff ff ff       	call   801444 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f4:	5b                   	pop    %ebx
  8014f5:	5e                   	pop    %esi
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	6a 07                	push   $0x7
  80150b:	e8 34 ff ff ff       	call   801444 <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	6a 08                	push   $0x8
  801526:	e8 19 ff ff ff       	call   801444 <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 09                	push   $0x9
  80153f:	e8 00 ff ff ff       	call   801444 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 0a                	push   $0xa
  801558:	e8 e7 fe ff ff       	call   801444 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 0b                	push   $0xb
  801571:	e8 ce fe ff ff       	call   801444 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 0c                	push   $0xc
  80158a:	e8 b5 fe ff ff       	call   801444 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	6a 0d                	push   $0xd
  8015a4:	e8 9b fe ff ff       	call   801444 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 0e                	push   $0xe
  8015bd:	e8 82 fe ff ff       	call   801444 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	90                   	nop
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 11                	push   $0x11
  8015d7:	e8 68 fe ff ff       	call   801444 <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 12                	push   $0x12
  8015f1:	e8 4e fe ff ff       	call   801444 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_cputc>:


void
sys_cputc(const char c)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801608:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	50                   	push   %eax
  801615:	6a 13                	push   $0x13
  801617:	e8 28 fe ff ff       	call   801444 <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 14                	push   $0x14
  801631:	e8 0e fe ff ff       	call   801444 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	90                   	nop
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	50                   	push   %eax
  80164c:	6a 15                	push   $0x15
  80164e:	e8 f1 fd ff ff       	call   801444 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	52                   	push   %edx
  801668:	50                   	push   %eax
  801669:	6a 18                	push   $0x18
  80166b:	e8 d4 fd ff ff       	call   801444 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	52                   	push   %edx
  801685:	50                   	push   %eax
  801686:	6a 16                	push   $0x16
  801688:	e8 b7 fd ff ff       	call   801444 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	6a 17                	push   $0x17
  8016a6:	e8 99 fd ff ff       	call   801444 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	51                   	push   %ecx
  8016ca:	52                   	push   %edx
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	6a 19                	push   $0x19
  8016d1:	e8 6e fd ff ff       	call   801444 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 1a                	push   $0x1a
  8016ee:	e8 51 fd ff ff       	call   801444 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	51                   	push   %ecx
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 1b                	push   $0x1b
  80170d:	e8 32 fd ff ff       	call   801444 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 1c                	push   $0x1c
  80172a:	e8 15 fd ff ff       	call   801444 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 1d                	push   $0x1d
  801743:	e8 fc fc ff ff       	call   801444 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	ff 75 14             	pushl  0x14(%ebp)
  801758:	ff 75 10             	pushl  0x10(%ebp)
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	50                   	push   %eax
  80175f:	6a 1e                	push   $0x1e
  801761:	e8 de fc ff ff       	call   801444 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	50                   	push   %eax
  80177a:	6a 1f                	push   $0x1f
  80177c:	e8 c3 fc ff ff       	call   801444 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	50                   	push   %eax
  801796:	6a 20                	push   $0x20
  801798:	e8 a7 fc ff ff       	call   801444 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 02                	push   $0x2
  8017b1:	e8 8e fc ff ff       	call   801444 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 03                	push   $0x3
  8017ca:	e8 75 fc ff ff       	call   801444 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 04                	push   $0x4
  8017e3:	e8 5c fc ff ff       	call   801444 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_exit_env>:


void sys_exit_env(void)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 21                	push   $0x21
  8017fc:	e8 43 fc ff ff       	call   801444 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80180d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801810:	8d 50 04             	lea    0x4(%eax),%edx
  801813:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	6a 22                	push   $0x22
  801820:	e8 1f fc ff ff       	call   801444 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
	return result;
  801828:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801831:	89 01                	mov    %eax,(%ecx)
  801833:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	c9                   	leave  
  80183a:	c2 04 00             	ret    $0x4

0080183d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 10                	push   $0x10
  80184f:	e8 f0 fb ff ff       	call   801444 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return ;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_rcr2>:
uint32 sys_rcr2()
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 23                	push   $0x23
  801869:	e8 d6 fb ff ff       	call   801444 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80187f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	50                   	push   %eax
  80188c:	6a 24                	push   $0x24
  80188e:	e8 b1 fb ff ff       	call   801444 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
	return ;
  801896:	90                   	nop
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <rsttst>:
void rsttst()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 26                	push   $0x26
  8018a8:	e8 97 fb ff ff       	call   801444 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b0:	90                   	nop
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018bf:	8b 55 18             	mov    0x18(%ebp),%edx
  8018c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	ff 75 10             	pushl  0x10(%ebp)
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 25                	push   $0x25
  8018d3:	e8 6c fb ff ff       	call   801444 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018db:	90                   	nop
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <chktst>:
void chktst(uint32 n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 27                	push   $0x27
  8018ee:	e8 51 fb ff ff       	call   801444 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f6:	90                   	nop
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <inctst>:

void inctst()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 28                	push   $0x28
  801908:	e8 37 fb ff ff       	call   801444 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return ;
  801910:	90                   	nop
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <gettst>:
uint32 gettst()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 29                	push   $0x29
  801922:	e8 1d fb ff ff       	call   801444 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 2a                	push   $0x2a
  80193e:	e8 01 fb ff ff       	call   801444 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
  801946:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801949:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80194d:	75 07                	jne    801956 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80194f:	b8 01 00 00 00       	mov    $0x1,%eax
  801954:	eb 05                	jmp    80195b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 2a                	push   $0x2a
  80196f:	e8 d0 fa ff ff       	call   801444 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
  801977:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80197a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80197e:	75 07                	jne    801987 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801980:	b8 01 00 00 00       	mov    $0x1,%eax
  801985:	eb 05                	jmp    80198c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 2a                	push   $0x2a
  8019a0:	e8 9f fa ff ff       	call   801444 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
  8019a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019ab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019af:	75 07                	jne    8019b8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b6:	eb 05                	jmp    8019bd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 2a                	push   $0x2a
  8019d1:	e8 6e fa ff ff       	call   801444 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
  8019d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019dc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019e0:	75 07                	jne    8019e9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e7:	eb 05                	jmp    8019ee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	6a 2b                	push   $0x2b
  801a00:	e8 3f fa ff ff       	call   801444 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
	return ;
  801a08:	90                   	nop
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	53                   	push   %ebx
  801a1e:	51                   	push   %ecx
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 2c                	push   $0x2c
  801a23:	e8 1c fa ff ff       	call   801444 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 2d                	push   $0x2d
  801a43:	e8 fc f9 ff ff       	call   801444 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	6a 00                	push   $0x0
  801a5b:	51                   	push   %ecx
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	52                   	push   %edx
  801a60:	50                   	push   %eax
  801a61:	6a 2e                	push   $0x2e
  801a63:	e8 dc f9 ff ff       	call   801444 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	ff 75 10             	pushl  0x10(%ebp)
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 0f                	push   $0xf
  801a7f:	e8 c0 f9 ff ff       	call   801444 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	return ;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	50                   	push   %eax
  801a99:	6a 2f                	push   $0x2f
  801a9b:	e8 a4 f9 ff ff       	call   801444 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp

}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 30                	push   $0x30
  801ab6:	e8 89 f9 ff ff       	call   801444 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
	return;
  801abe:	90                   	nop
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	6a 31                	push   $0x31
  801ad2:	e8 6d f9 ff ff       	call   801444 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 32                	push   $0x32
  801aec:	e8 53 f9 ff ff       	call   801444 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	50                   	push   %eax
  801b05:	6a 33                	push   $0x33
  801b07:	e8 38 f9 ff ff       	call   801444 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    
  801b12:	66 90                	xchg   %ax,%ax

00801b14 <__udivdi3>:
  801b14:	55                   	push   %ebp
  801b15:	57                   	push   %edi
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	83 ec 1c             	sub    $0x1c,%esp
  801b1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2b:	89 ca                	mov    %ecx,%edx
  801b2d:	89 f8                	mov    %edi,%eax
  801b2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b33:	85 f6                	test   %esi,%esi
  801b35:	75 2d                	jne    801b64 <__udivdi3+0x50>
  801b37:	39 cf                	cmp    %ecx,%edi
  801b39:	77 65                	ja     801ba0 <__udivdi3+0x8c>
  801b3b:	89 fd                	mov    %edi,%ebp
  801b3d:	85 ff                	test   %edi,%edi
  801b3f:	75 0b                	jne    801b4c <__udivdi3+0x38>
  801b41:	b8 01 00 00 00       	mov    $0x1,%eax
  801b46:	31 d2                	xor    %edx,%edx
  801b48:	f7 f7                	div    %edi
  801b4a:	89 c5                	mov    %eax,%ebp
  801b4c:	31 d2                	xor    %edx,%edx
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	f7 f5                	div    %ebp
  801b52:	89 c1                	mov    %eax,%ecx
  801b54:	89 d8                	mov    %ebx,%eax
  801b56:	f7 f5                	div    %ebp
  801b58:	89 cf                	mov    %ecx,%edi
  801b5a:	89 fa                	mov    %edi,%edx
  801b5c:	83 c4 1c             	add    $0x1c,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
  801b64:	39 ce                	cmp    %ecx,%esi
  801b66:	77 28                	ja     801b90 <__udivdi3+0x7c>
  801b68:	0f bd fe             	bsr    %esi,%edi
  801b6b:	83 f7 1f             	xor    $0x1f,%edi
  801b6e:	75 40                	jne    801bb0 <__udivdi3+0x9c>
  801b70:	39 ce                	cmp    %ecx,%esi
  801b72:	72 0a                	jb     801b7e <__udivdi3+0x6a>
  801b74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b78:	0f 87 9e 00 00 00    	ja     801c1c <__udivdi3+0x108>
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	89 fa                	mov    %edi,%edx
  801b85:	83 c4 1c             	add    $0x1c,%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5e                   	pop    %esi
  801b8a:	5f                   	pop    %edi
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    
  801b8d:	8d 76 00             	lea    0x0(%esi),%esi
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	31 c0                	xor    %eax,%eax
  801b94:	89 fa                	mov    %edi,%edx
  801b96:	83 c4 1c             	add    $0x1c,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f7                	div    %edi
  801ba4:	31 ff                	xor    %edi,%edi
  801ba6:	89 fa                	mov    %edi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bb5:	89 eb                	mov    %ebp,%ebx
  801bb7:	29 fb                	sub    %edi,%ebx
  801bb9:	89 f9                	mov    %edi,%ecx
  801bbb:	d3 e6                	shl    %cl,%esi
  801bbd:	89 c5                	mov    %eax,%ebp
  801bbf:	88 d9                	mov    %bl,%cl
  801bc1:	d3 ed                	shr    %cl,%ebp
  801bc3:	89 e9                	mov    %ebp,%ecx
  801bc5:	09 f1                	or     %esi,%ecx
  801bc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bcb:	89 f9                	mov    %edi,%ecx
  801bcd:	d3 e0                	shl    %cl,%eax
  801bcf:	89 c5                	mov    %eax,%ebp
  801bd1:	89 d6                	mov    %edx,%esi
  801bd3:	88 d9                	mov    %bl,%cl
  801bd5:	d3 ee                	shr    %cl,%esi
  801bd7:	89 f9                	mov    %edi,%ecx
  801bd9:	d3 e2                	shl    %cl,%edx
  801bdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bdf:	88 d9                	mov    %bl,%cl
  801be1:	d3 e8                	shr    %cl,%eax
  801be3:	09 c2                	or     %eax,%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	89 f2                	mov    %esi,%edx
  801be9:	f7 74 24 0c          	divl   0xc(%esp)
  801bed:	89 d6                	mov    %edx,%esi
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	f7 e5                	mul    %ebp
  801bf3:	39 d6                	cmp    %edx,%esi
  801bf5:	72 19                	jb     801c10 <__udivdi3+0xfc>
  801bf7:	74 0b                	je     801c04 <__udivdi3+0xf0>
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	31 ff                	xor    %edi,%edi
  801bfd:	e9 58 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c08:	89 f9                	mov    %edi,%ecx
  801c0a:	d3 e2                	shl    %cl,%edx
  801c0c:	39 c2                	cmp    %eax,%edx
  801c0e:	73 e9                	jae    801bf9 <__udivdi3+0xe5>
  801c10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c13:	31 ff                	xor    %edi,%edi
  801c15:	e9 40 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	31 c0                	xor    %eax,%eax
  801c1e:	e9 37 ff ff ff       	jmp    801b5a <__udivdi3+0x46>
  801c23:	90                   	nop

00801c24 <__umoddi3>:
  801c24:	55                   	push   %ebp
  801c25:	57                   	push   %edi
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	83 ec 1c             	sub    $0x1c,%esp
  801c2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c43:	89 f3                	mov    %esi,%ebx
  801c45:	89 fa                	mov    %edi,%edx
  801c47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4b:	89 34 24             	mov    %esi,(%esp)
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	75 1a                	jne    801c6c <__umoddi3+0x48>
  801c52:	39 f7                	cmp    %esi,%edi
  801c54:	0f 86 a2 00 00 00    	jbe    801cfc <__umoddi3+0xd8>
  801c5a:	89 c8                	mov    %ecx,%eax
  801c5c:	89 f2                	mov    %esi,%edx
  801c5e:	f7 f7                	div    %edi
  801c60:	89 d0                	mov    %edx,%eax
  801c62:	31 d2                	xor    %edx,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	39 f0                	cmp    %esi,%eax
  801c6e:	0f 87 ac 00 00 00    	ja     801d20 <__umoddi3+0xfc>
  801c74:	0f bd e8             	bsr    %eax,%ebp
  801c77:	83 f5 1f             	xor    $0x1f,%ebp
  801c7a:	0f 84 ac 00 00 00    	je     801d2c <__umoddi3+0x108>
  801c80:	bf 20 00 00 00       	mov    $0x20,%edi
  801c85:	29 ef                	sub    %ebp,%edi
  801c87:	89 fe                	mov    %edi,%esi
  801c89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c8d:	89 e9                	mov    %ebp,%ecx
  801c8f:	d3 e0                	shl    %cl,%eax
  801c91:	89 d7                	mov    %edx,%edi
  801c93:	89 f1                	mov    %esi,%ecx
  801c95:	d3 ef                	shr    %cl,%edi
  801c97:	09 c7                	or     %eax,%edi
  801c99:	89 e9                	mov    %ebp,%ecx
  801c9b:	d3 e2                	shl    %cl,%edx
  801c9d:	89 14 24             	mov    %edx,(%esp)
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	d3 e0                	shl    %cl,%eax
  801ca4:	89 c2                	mov    %eax,%edx
  801ca6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801caa:	d3 e0                	shl    %cl,%eax
  801cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb4:	89 f1                	mov    %esi,%ecx
  801cb6:	d3 e8                	shr    %cl,%eax
  801cb8:	09 d0                	or     %edx,%eax
  801cba:	d3 eb                	shr    %cl,%ebx
  801cbc:	89 da                	mov    %ebx,%edx
  801cbe:	f7 f7                	div    %edi
  801cc0:	89 d3                	mov    %edx,%ebx
  801cc2:	f7 24 24             	mull   (%esp)
  801cc5:	89 c6                	mov    %eax,%esi
  801cc7:	89 d1                	mov    %edx,%ecx
  801cc9:	39 d3                	cmp    %edx,%ebx
  801ccb:	0f 82 87 00 00 00    	jb     801d58 <__umoddi3+0x134>
  801cd1:	0f 84 91 00 00 00    	je     801d68 <__umoddi3+0x144>
  801cd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cdb:	29 f2                	sub    %esi,%edx
  801cdd:	19 cb                	sbb    %ecx,%ebx
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ce5:	d3 e0                	shl    %cl,%eax
  801ce7:	89 e9                	mov    %ebp,%ecx
  801ce9:	d3 ea                	shr    %cl,%edx
  801ceb:	09 d0                	or     %edx,%eax
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	d3 eb                	shr    %cl,%ebx
  801cf1:	89 da                	mov    %ebx,%edx
  801cf3:	83 c4 1c             	add    $0x1c,%esp
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5f                   	pop    %edi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
  801cfb:	90                   	nop
  801cfc:	89 fd                	mov    %edi,%ebp
  801cfe:	85 ff                	test   %edi,%edi
  801d00:	75 0b                	jne    801d0d <__umoddi3+0xe9>
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	31 d2                	xor    %edx,%edx
  801d09:	f7 f7                	div    %edi
  801d0b:	89 c5                	mov    %eax,%ebp
  801d0d:	89 f0                	mov    %esi,%eax
  801d0f:	31 d2                	xor    %edx,%edx
  801d11:	f7 f5                	div    %ebp
  801d13:	89 c8                	mov    %ecx,%eax
  801d15:	f7 f5                	div    %ebp
  801d17:	89 d0                	mov    %edx,%eax
  801d19:	e9 44 ff ff ff       	jmp    801c62 <__umoddi3+0x3e>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	89 c8                	mov    %ecx,%eax
  801d22:	89 f2                	mov    %esi,%edx
  801d24:	83 c4 1c             	add    $0x1c,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
  801d2c:	3b 04 24             	cmp    (%esp),%eax
  801d2f:	72 06                	jb     801d37 <__umoddi3+0x113>
  801d31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d35:	77 0f                	ja     801d46 <__umoddi3+0x122>
  801d37:	89 f2                	mov    %esi,%edx
  801d39:	29 f9                	sub    %edi,%ecx
  801d3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d3f:	89 14 24             	mov    %edx,(%esp)
  801d42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d4a:	8b 14 24             	mov    (%esp),%edx
  801d4d:	83 c4 1c             	add    $0x1c,%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    
  801d55:	8d 76 00             	lea    0x0(%esi),%esi
  801d58:	2b 04 24             	sub    (%esp),%eax
  801d5b:	19 fa                	sbb    %edi,%edx
  801d5d:	89 d1                	mov    %edx,%ecx
  801d5f:	89 c6                	mov    %eax,%esi
  801d61:	e9 71 ff ff ff       	jmp    801cd7 <__umoddi3+0xb3>
  801d66:	66 90                	xchg   %ax,%ax
  801d68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d6c:	72 ea                	jb     801d58 <__umoddi3+0x134>
  801d6e:	89 d9                	mov    %ebx,%ecx
  801d70:	e9 62 ff ff ff       	jmp    801cd7 <__umoddi3+0xb3>
