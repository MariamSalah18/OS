
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 9d 02 00 00       	call   8002d3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 40 80 00       	mov    0x804020,%eax
  800048:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80004e:	a1 20 40 80 00       	mov    0x804020,%eax
  800053:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 32 80 00       	push   $0x8032c0
  800065:	6a 14                	push   $0x14
  800067:	68 dc 32 80 00       	push   $0x8032dc
  80006c:	e8 90 03 00 00       	call   800401 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 47 18 00 00       	call   801908 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 8a 18 00 00       	call   801953 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 0c 14 00 00       	call   8014e9 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 f8 32 80 00       	push   $0x8032f8
  8000f9:	6a 33                	push   $0x33
  8000fb:	68 dc 32 80 00       	push   $0x8032dc
  800100:	e8 fc 02 00 00       	call   800401 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 49 18 00 00       	call   801953 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 33 80 00       	push   $0x803328
  800117:	6a 34                	push   $0x34
  800119:	68 dc 32 80 00       	push   $0x8032dc
  80011e:	e8 de 02 00 00       	call   800401 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 e0 17 00 00       	call   801908 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 a4 17 00 00       	call   801908 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 58 33 80 00       	push   $0x803358
  800181:	6a 3e                	push   $0x3e
  800183:	68 dc 32 80 00       	push   $0x8032dc
  800188:	e8 74 02 00 00       	call   800401 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 59 1c 00 00       	call   801e25 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 33 80 00       	push   $0x8033d4
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 dc 32 80 00       	push   $0x8032dc
  8001e7:	e8 15 02 00 00       	call   800401 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 17 17 00 00       	call   801908 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 5a 17 00 00       	call   801953 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 3a 14 00 00       	call   801645 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 40 17 00 00       	call   801953 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 33 80 00       	push   $0x8033f4
  800220:	6a 4f                	push   $0x4f
  800222:	68 dc 32 80 00       	push   $0x8032dc
  800227:	e8 d5 01 00 00       	call   800401 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 d7 16 00 00       	call   801908 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 30 34 80 00       	push   $0x803430
  800247:	6a 50                	push   $0x50
  800249:	68 dc 32 80 00       	push   $0x8032dc
  80024e:	e8 ae 01 00 00       	call   800401 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 93 1b 00 00       	call   801e25 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 34 80 00       	push   $0x80347c
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 dc 32 80 00       	push   $0x8032dc
  8002ad:	e8 4f 01 00 00       	call   800401 <_panic>
		}
	}

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002b5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002b8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ba:	e8 12 1a 00 00       	call   801cd1 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 a0 34 80 00       	push   $0x8034a0
  8002c7:	6a 5b                	push   $0x5b
  8002c9:	68 dc 32 80 00       	push   $0x8032dc
  8002ce:	e8 2e 01 00 00       	call   800401 <_panic>

008002d3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002d9:	e8 b5 18 00 00       	call   801b93 <sys_getenvindex>
  8002de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002e4:	89 d0                	mov    %edx,%eax
  8002e6:	01 c0                	add    %eax,%eax
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	c1 e0 06             	shl    $0x6,%eax
  8002ed:	29 d0                	sub    %edx,%eax
  8002ef:	c1 e0 03             	shl    $0x3,%eax
  8002f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800301:	8a 40 68             	mov    0x68(%eax),%al
  800304:	84 c0                	test   %al,%al
  800306:	74 0d                	je     800315 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	83 c0 68             	add    $0x68,%eax
  800310:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800319:	7e 0a                	jle    800325 <libmain+0x52>
		binaryname = argv[0];
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 05 fd ff ff       	call   800038 <_main>
  800333:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800336:	e8 65 16 00 00       	call   8019a0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 04 35 80 00       	push   $0x803504
  800343:	e8 76 03 00 00       	call   8006be <cprintf>
  800348:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80034b:	a1 20 40 80 00       	mov    0x804020,%eax
  800350:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	52                   	push   %edx
  800365:	50                   	push   %eax
  800366:	68 2c 35 80 00       	push   $0x80352c
  80036b:	e8 4e 03 00 00       	call   8006be <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800373:	a1 20 40 80 00       	mov    0x804020,%eax
  800378:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80037e:	a1 20 40 80 00       	mov    0x804020,%eax
  800383:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800389:	a1 20 40 80 00       	mov    0x804020,%eax
  80038e:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800394:	51                   	push   %ecx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	68 54 35 80 00       	push   $0x803554
  80039c:	e8 1d 03 00 00       	call   8006be <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a9:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	50                   	push   %eax
  8003b3:	68 ac 35 80 00       	push   $0x8035ac
  8003b8:	e8 01 03 00 00       	call   8006be <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	68 04 35 80 00       	push   $0x803504
  8003c8:	e8 f1 02 00 00       	call   8006be <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d0:	e8 e5 15 00 00       	call   8019ba <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d5:	e8 19 00 00 00       	call   8003f3 <exit>
}
  8003da:	90                   	nop
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    

008003dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	6a 00                	push   $0x0
  8003e8:	e8 72 17 00 00       	call   801b5f <sys_destroy_env>
  8003ed:	83 c4 10             	add    $0x10,%esp
}
  8003f0:	90                   	nop
  8003f1:	c9                   	leave  
  8003f2:	c3                   	ret    

008003f3 <exit>:

void
exit(void)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f9:	e8 c7 17 00 00       	call   801bc5 <sys_exit_env>
}
  8003fe:	90                   	nop
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800407:	8d 45 10             	lea    0x10(%ebp),%eax
  80040a:	83 c0 04             	add    $0x4,%eax
  80040d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800410:	a1 18 41 80 00       	mov    0x804118,%eax
  800415:	85 c0                	test   %eax,%eax
  800417:	74 16                	je     80042f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800419:	a1 18 41 80 00       	mov    0x804118,%eax
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	50                   	push   %eax
  800422:	68 c0 35 80 00       	push   $0x8035c0
  800427:	e8 92 02 00 00       	call   8006be <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042f:	a1 00 40 80 00       	mov    0x804000,%eax
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	50                   	push   %eax
  80043b:	68 c5 35 80 00       	push   $0x8035c5
  800440:	e8 79 02 00 00       	call   8006be <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800448:	8b 45 10             	mov    0x10(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 f4             	pushl  -0xc(%ebp)
  800451:	50                   	push   %eax
  800452:	e8 fc 01 00 00       	call   800653 <vcprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	6a 00                	push   $0x0
  80045f:	68 e1 35 80 00       	push   $0x8035e1
  800464:	e8 ea 01 00 00       	call   800653 <vcprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80046c:	e8 82 ff ff ff       	call   8003f3 <exit>

	// should not return here
	while (1) ;
  800471:	eb fe                	jmp    800471 <_panic+0x70>

00800473 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800484:	8b 45 0c             	mov    0xc(%ebp),%eax
  800487:	39 c2                	cmp    %eax,%edx
  800489:	74 14                	je     80049f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80048b:	83 ec 04             	sub    $0x4,%esp
  80048e:	68 e4 35 80 00       	push   $0x8035e4
  800493:	6a 26                	push   $0x26
  800495:	68 30 36 80 00       	push   $0x803630
  80049a:	e8 62 ff ff ff       	call   800401 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80049f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ad:	e9 c5 00 00 00       	jmp    800577 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	01 d0                	add    %edx,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	75 08                	jne    8004cf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004c7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ca:	e9 a5 00 00 00       	jmp    800574 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004dd:	eb 69                	jmp    800548 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004df:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e4:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004ed:	89 d0                	mov    %edx,%eax
  8004ef:	01 c0                	add    %eax,%eax
  8004f1:	01 d0                	add    %edx,%eax
  8004f3:	c1 e0 03             	shl    $0x3,%eax
  8004f6:	01 c8                	add    %ecx,%eax
  8004f8:	8a 40 04             	mov    0x4(%eax),%al
  8004fb:	84 c0                	test   %al,%al
  8004fd:	75 46                	jne    800545 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800504:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80050a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80050d:	89 d0                	mov    %edx,%eax
  80050f:	01 c0                	add    %eax,%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	c1 e0 03             	shl    $0x3,%eax
  800516:	01 c8                	add    %ecx,%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80051d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800520:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800525:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	01 c8                	add    %ecx,%eax
  800536:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800538:	39 c2                	cmp    %eax,%edx
  80053a:	75 09                	jne    800545 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80053c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800543:	eb 15                	jmp    80055a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800545:	ff 45 e8             	incl   -0x18(%ebp)
  800548:	a1 20 40 80 00       	mov    0x804020,%eax
  80054d:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800556:	39 c2                	cmp    %eax,%edx
  800558:	77 85                	ja     8004df <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80055a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80055e:	75 14                	jne    800574 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800560:	83 ec 04             	sub    $0x4,%esp
  800563:	68 3c 36 80 00       	push   $0x80363c
  800568:	6a 3a                	push   $0x3a
  80056a:	68 30 36 80 00       	push   $0x803630
  80056f:	e8 8d fe ff ff       	call   800401 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800574:	ff 45 f0             	incl   -0x10(%ebp)
  800577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80057d:	0f 8c 2f ff ff ff    	jl     8004b2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800583:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800591:	eb 26                	jmp    8005b9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800593:	a1 20 40 80 00       	mov    0x804020,%eax
  800598:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80059e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	c1 e0 03             	shl    $0x3,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8a 40 04             	mov    0x4(%eax),%al
  8005af:	3c 01                	cmp    $0x1,%al
  8005b1:	75 03                	jne    8005b6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005b3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b6:	ff 45 e0             	incl   -0x20(%ebp)
  8005b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8005be:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8005c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c7:	39 c2                	cmp    %eax,%edx
  8005c9:	77 c8                	ja     800593 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005d1:	74 14                	je     8005e7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 90 36 80 00       	push   $0x803690
  8005db:	6a 44                	push   $0x44
  8005dd:	68 30 36 80 00       	push   $0x803630
  8005e2:	e8 1a fe ff ff       	call   800401 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e7:	90                   	nop
  8005e8:	c9                   	leave  
  8005e9:	c3                   	ret    

008005ea <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	89 0a                	mov    %ecx,(%edx)
  8005fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800600:	88 d1                	mov    %dl,%cl
  800602:	8b 55 0c             	mov    0xc(%ebp),%edx
  800605:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800613:	75 2c                	jne    800641 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800615:	a0 24 40 80 00       	mov    0x804024,%al
  80061a:	0f b6 c0             	movzbl %al,%eax
  80061d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800620:	8b 12                	mov    (%edx),%edx
  800622:	89 d1                	mov    %edx,%ecx
  800624:	8b 55 0c             	mov    0xc(%ebp),%edx
  800627:	83 c2 08             	add    $0x8,%edx
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	50                   	push   %eax
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	e8 12 12 00 00       	call   801847 <sys_cputs>
  800635:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8b 40 04             	mov    0x4(%eax),%eax
  800647:	8d 50 01             	lea    0x1(%eax),%edx
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800650:	90                   	nop
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80065c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800663:	00 00 00 
	b.cnt = 0;
  800666:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800670:	ff 75 0c             	pushl  0xc(%ebp)
  800673:	ff 75 08             	pushl  0x8(%ebp)
  800676:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	68 ea 05 80 00       	push   $0x8005ea
  800682:	e8 11 02 00 00       	call   800898 <vprintfmt>
  800687:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80068a:	a0 24 40 80 00       	mov    0x804024,%al
  80068f:	0f b6 c0             	movzbl %al,%eax
  800692:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800698:	83 ec 04             	sub    $0x4,%esp
  80069b:	50                   	push   %eax
  80069c:	52                   	push   %edx
  80069d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a3:	83 c0 08             	add    $0x8,%eax
  8006a6:	50                   	push   %eax
  8006a7:	e8 9b 11 00 00       	call   801847 <sys_cputs>
  8006ac:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006af:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    

008006be <cprintf>:

int cprintf(const char *fmt, ...) {
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c4:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	e8 73 ff ff ff       	call   800653 <vcprintf>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006eb:	55                   	push   %ebp
  8006ec:	89 e5                	mov    %esp,%ebp
  8006ee:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006f1:	e8 aa 12 00 00       	call   8019a0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 f4             	pushl  -0xc(%ebp)
  800705:	50                   	push   %eax
  800706:	e8 48 ff ff ff       	call   800653 <vcprintf>
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800711:	e8 a4 12 00 00       	call   8019ba <sys_enable_interrupt>
	return cnt;
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	53                   	push   %ebx
  80071f:	83 ec 14             	sub    $0x14,%esp
  800722:	8b 45 10             	mov    0x10(%ebp),%eax
  800725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072e:	8b 45 18             	mov    0x18(%ebp),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800739:	77 55                	ja     800790 <printnum+0x75>
  80073b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073e:	72 05                	jb     800745 <printnum+0x2a>
  800740:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800743:	77 4b                	ja     800790 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800745:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800748:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80074b:	8b 45 18             	mov    0x18(%ebp),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
  800753:	52                   	push   %edx
  800754:	50                   	push   %eax
  800755:	ff 75 f4             	pushl  -0xc(%ebp)
  800758:	ff 75 f0             	pushl  -0x10(%ebp)
  80075b:	e8 f0 28 00 00       	call   803050 <__udivdi3>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	83 ec 04             	sub    $0x4,%esp
  800766:	ff 75 20             	pushl  0x20(%ebp)
  800769:	53                   	push   %ebx
  80076a:	ff 75 18             	pushl  0x18(%ebp)
  80076d:	52                   	push   %edx
  80076e:	50                   	push   %eax
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	ff 75 08             	pushl  0x8(%ebp)
  800775:	e8 a1 ff ff ff       	call   80071b <printnum>
  80077a:	83 c4 20             	add    $0x20,%esp
  80077d:	eb 1a                	jmp    800799 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 20             	pushl  0x20(%ebp)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	ff d0                	call   *%eax
  80078d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800790:	ff 4d 1c             	decl   0x1c(%ebp)
  800793:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800797:	7f e6                	jg     80077f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800799:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a7:	53                   	push   %ebx
  8007a8:	51                   	push   %ecx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 b0 29 00 00       	call   803160 <__umoddi3>
  8007b0:	83 c4 10             	add    $0x10,%esp
  8007b3:	05 f4 38 80 00       	add    $0x8038f4,%eax
  8007b8:	8a 00                	mov    (%eax),%al
  8007ba:	0f be c0             	movsbl %al,%eax
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	50                   	push   %eax
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
}
  8007cc:	90                   	nop
  8007cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d9:	7e 1c                	jle    8007f7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 08             	lea    0x8(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 08             	sub    $0x8,%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	eb 40                	jmp    800837 <getuint+0x65>
	else if (lflag)
  8007f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fb:	74 1e                	je     80081b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 10                	mov    %edx,(%eax)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	83 e8 04             	sub    $0x4,%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	eb 1c                	jmp    800837 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	8d 50 04             	lea    0x4(%eax),%edx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	89 10                	mov    %edx,(%eax)
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	83 e8 04             	sub    $0x4,%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800840:	7e 1c                	jle    80085e <getint+0x25>
		return va_arg(*ap, long long);
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	8d 50 08             	lea    0x8(%eax),%edx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	89 10                	mov    %edx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	83 e8 08             	sub    $0x8,%eax
  800857:	8b 50 04             	mov    0x4(%eax),%edx
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	eb 38                	jmp    800896 <getint+0x5d>
	else if (lflag)
  80085e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800862:	74 1a                	je     80087e <getint+0x45>
		return va_arg(*ap, long);
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	8d 50 04             	lea    0x4(%eax),%edx
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	89 10                	mov    %edx,(%eax)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	99                   	cltd   
  80087c:	eb 18                	jmp    800896 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	8d 50 04             	lea    0x4(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 10                	mov    %edx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	99                   	cltd   
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a0:	eb 17                	jmp    8008b9 <vprintfmt+0x21>
			if (ch == '\0')
  8008a2:	85 db                	test   %ebx,%ebx
  8008a4:	0f 84 af 03 00 00    	je     800c59 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bc:	8d 50 01             	lea    0x1(%eax),%edx
  8008bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c2:	8a 00                	mov    (%eax),%al
  8008c4:	0f b6 d8             	movzbl %al,%ebx
  8008c7:	83 fb 25             	cmp    $0x25,%ebx
  8008ca:	75 d6                	jne    8008a2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	8d 50 01             	lea    0x1(%eax),%edx
  8008f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f5:	8a 00                	mov    (%eax),%al
  8008f7:	0f b6 d8             	movzbl %al,%ebx
  8008fa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fd:	83 f8 55             	cmp    $0x55,%eax
  800900:	0f 87 2b 03 00 00    	ja     800c31 <vprintfmt+0x399>
  800906:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  80090d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800913:	eb d7                	jmp    8008ec <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800915:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800919:	eb d1                	jmp    8008ec <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800922:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800925:	89 d0                	mov    %edx,%eax
  800927:	c1 e0 02             	shl    $0x2,%eax
  80092a:	01 d0                	add    %edx,%eax
  80092c:	01 c0                	add    %eax,%eax
  80092e:	01 d8                	add    %ebx,%eax
  800930:	83 e8 30             	sub    $0x30,%eax
  800933:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800936:	8b 45 10             	mov    0x10(%ebp),%eax
  800939:	8a 00                	mov    (%eax),%al
  80093b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093e:	83 fb 2f             	cmp    $0x2f,%ebx
  800941:	7e 3e                	jle    800981 <vprintfmt+0xe9>
  800943:	83 fb 39             	cmp    $0x39,%ebx
  800946:	7f 39                	jg     800981 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800948:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094b:	eb d5                	jmp    800922 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800961:	eb 1f                	jmp    800982 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800963:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800967:	79 83                	jns    8008ec <vprintfmt+0x54>
				width = 0;
  800969:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800970:	e9 77 ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800975:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097c:	e9 6b ff ff ff       	jmp    8008ec <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800981:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800986:	0f 89 60 ff ff ff    	jns    8008ec <vprintfmt+0x54>
				width = precision, precision = -1;
  80098c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800992:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800999:	e9 4e ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009a1:	e9 46 ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	83 c0 04             	add    $0x4,%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	83 e8 04             	sub    $0x4,%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	50                   	push   %eax
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
			break;
  8009c6:	e9 89 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	83 c0 04             	add    $0x4,%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	83 e8 04             	sub    $0x4,%eax
  8009da:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009dc:	85 db                	test   %ebx,%ebx
  8009de:	79 02                	jns    8009e2 <vprintfmt+0x14a>
				err = -err;
  8009e0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e2:	83 fb 64             	cmp    $0x64,%ebx
  8009e5:	7f 0b                	jg     8009f2 <vprintfmt+0x15a>
  8009e7:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8009ee:	85 f6                	test   %esi,%esi
  8009f0:	75 19                	jne    800a0b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f2:	53                   	push   %ebx
  8009f3:	68 05 39 80 00       	push   $0x803905
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 5e 02 00 00       	call   800c61 <printfmt>
  800a03:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a06:	e9 49 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a0b:	56                   	push   %esi
  800a0c:	68 0e 39 80 00       	push   $0x80390e
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	e8 45 02 00 00       	call   800c61 <printfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
			break;
  800a1f:	e9 30 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 30                	mov    (%eax),%esi
  800a35:	85 f6                	test   %esi,%esi
  800a37:	75 05                	jne    800a3e <vprintfmt+0x1a6>
				p = "(null)";
  800a39:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	7e 6d                	jle    800ab1 <vprintfmt+0x219>
  800a44:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a48:	74 67                	je     800ab1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	50                   	push   %eax
  800a51:	56                   	push   %esi
  800a52:	e8 0c 03 00 00       	call   800d63 <strnlen>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5d:	eb 16                	jmp    800a75 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	50                   	push   %eax
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a72:	ff 4d e4             	decl   -0x1c(%ebp)
  800a75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a79:	7f e4                	jg     800a5f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7b:	eb 34                	jmp    800ab1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a81:	74 1c                	je     800a9f <vprintfmt+0x207>
  800a83:	83 fb 1f             	cmp    $0x1f,%ebx
  800a86:	7e 05                	jle    800a8d <vprintfmt+0x1f5>
  800a88:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8b:	7e 12                	jle    800a9f <vprintfmt+0x207>
					putch('?', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	6a 3f                	push   $0x3f
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	eb 0f                	jmp    800aae <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	53                   	push   %ebx
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aae:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab1:	89 f0                	mov    %esi,%eax
  800ab3:	8d 70 01             	lea    0x1(%eax),%esi
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	0f be d8             	movsbl %al,%ebx
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	74 24                	je     800ae3 <vprintfmt+0x24b>
  800abf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac3:	78 b8                	js     800a7d <vprintfmt+0x1e5>
  800ac5:	ff 4d e0             	decl   -0x20(%ebp)
  800ac8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800acc:	79 af                	jns    800a7d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ace:	eb 13                	jmp    800ae3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 20                	push   $0x20
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae7:	7f e7                	jg     800ad0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae9:	e9 66 01 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 e8             	pushl  -0x18(%ebp)
  800af4:	8d 45 14             	lea    0x14(%ebp),%eax
  800af7:	50                   	push   %eax
  800af8:	e8 3c fd ff ff       	call   800839 <getint>
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0c:	85 d2                	test   %edx,%edx
  800b0e:	79 23                	jns    800b33 <vprintfmt+0x29b>
				putch('-', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 2d                	push   $0x2d
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b26:	f7 d8                	neg    %eax
  800b28:	83 d2 00             	adc    $0x0,%edx
  800b2b:	f7 da                	neg    %edx
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3a:	e9 bc 00 00 00       	jmp    800bfb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 e8             	pushl  -0x18(%ebp)
  800b45:	8d 45 14             	lea    0x14(%ebp),%eax
  800b48:	50                   	push   %eax
  800b49:	e8 84 fc ff ff       	call   8007d2 <getuint>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b57:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5e:	e9 98 00 00 00       	jmp    800bfb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 58                	push   $0x58
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	6a 58                	push   $0x58
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	6a 58                	push   $0x58
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	e9 bc 00 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 30                	push   $0x30
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	6a 78                	push   $0x78
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	83 c0 04             	add    $0x4,%eax
  800bbe:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bda:	eb 1f                	jmp    800bfb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 e7 fb ff ff       	call   8007d2 <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bfb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	52                   	push   %edx
  800c06:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 08             	pushl  0x8(%ebp)
  800c16:	e8 00 fb ff ff       	call   80071b <printnum>
  800c1b:	83 c4 20             	add    $0x20,%esp
			break;
  800c1e:	eb 34                	jmp    800c54 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			break;
  800c2f:	eb 23                	jmp    800c54 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 25                	push   $0x25
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c41:	ff 4d 10             	decl   0x10(%ebp)
  800c44:	eb 03                	jmp    800c49 <vprintfmt+0x3b1>
  800c46:	ff 4d 10             	decl   0x10(%ebp)
  800c49:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4c:	48                   	dec    %eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	3c 25                	cmp    $0x25,%al
  800c51:	75 f3                	jne    800c46 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c53:	90                   	nop
		}
	}
  800c54:	e9 47 fc ff ff       	jmp    8008a0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c59:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c67:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	ff 75 f4             	pushl  -0xc(%ebp)
  800c76:	50                   	push   %eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	e8 16 fc ff ff       	call   800898 <vprintfmt>
  800c82:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c85:	90                   	nop
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8b 40 08             	mov    0x8(%eax),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8b 10                	mov    (%eax),%edx
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8b 40 04             	mov    0x4(%eax),%eax
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	73 12                	jae    800cbb <sprintputch+0x33>
		*b->buf++ = ch;
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	89 0a                	mov    %ecx,(%edx)
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	88 10                	mov    %dl,(%eax)
}
  800cbb:	90                   	nop
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
  800cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce3:	74 06                	je     800ceb <vsnprintf+0x2d>
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	7f 07                	jg     800cf2 <vsnprintf+0x34>
		return -E_INVAL;
  800ceb:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf0:	eb 20                	jmp    800d12 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf2:	ff 75 14             	pushl  0x14(%ebp)
  800cf5:	ff 75 10             	pushl  0x10(%ebp)
  800cf8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cfb:	50                   	push   %eax
  800cfc:	68 88 0c 80 00       	push   $0x800c88
  800d01:	e8 92 fb ff ff       	call   800898 <vprintfmt>
  800d06:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d23:	8b 45 10             	mov    0x10(%ebp),%eax
  800d26:	ff 75 f4             	pushl  -0xc(%ebp)
  800d29:	50                   	push   %eax
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	ff 75 08             	pushl  0x8(%ebp)
  800d30:	e8 89 ff ff ff       	call   800cbe <vsnprintf>
  800d35:	83 c4 10             	add    $0x10,%esp
  800d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4d:	eb 06                	jmp    800d55 <strlen+0x15>
		n++;
  800d4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 f1                	jne    800d4f <strlen+0xf>
		n++;
	return n;
  800d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d70:	eb 09                	jmp    800d7b <strnlen+0x18>
		n++;
  800d72:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	ff 4d 0c             	decl   0xc(%ebp)
  800d7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7f:	74 09                	je     800d8a <strnlen+0x27>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 e8                	jne    800d72 <strnlen+0xf>
		n++;
	return n;
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d9b:	90                   	nop
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	89 55 08             	mov    %edx,0x8(%ebp)
  800da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dae:	8a 12                	mov    (%edx),%dl
  800db0:	88 10                	mov    %dl,(%eax)
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e4                	jne    800d9c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd0:	eb 1f                	jmp    800df1 <strncpy+0x34>
		*dst++ = *src;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8d 50 01             	lea    0x1(%eax),%edx
  800dd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dde:	8a 12                	mov    (%edx),%dl
  800de0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	74 03                	je     800dee <strncpy+0x31>
			src++;
  800deb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dee:	ff 45 fc             	incl   -0x4(%ebp)
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df7:	72 d9                	jb     800dd2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	74 30                	je     800e40 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e10:	eb 16                	jmp    800e28 <strlcpy+0x2a>
			*dst++ = *src++;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e24:	8a 12                	mov    (%edx),%dl
  800e26:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e28:	ff 4d 10             	decl   0x10(%ebp)
  800e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2f:	74 09                	je     800e3a <strlcpy+0x3c>
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	84 c0                	test   %al,%al
  800e38:	75 d8                	jne    800e12 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	29 c2                	sub    %eax,%edx
  800e48:	89 d0                	mov    %edx,%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e4f:	eb 06                	jmp    800e57 <strcmp+0xb>
		p++, q++;
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	84 c0                	test   %al,%al
  800e5e:	74 0e                	je     800e6e <strcmp+0x22>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 10                	mov    (%eax),%dl
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	38 c2                	cmp    %al,%dl
  800e6c:	74 e3                	je     800e51 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 d0             	movzbl %al,%edx
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 c0             	movzbl %al,%eax
  800e7e:	29 c2                	sub    %eax,%edx
  800e80:	89 d0                	mov    %edx,%eax
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e87:	eb 09                	jmp    800e92 <strncmp+0xe>
		n--, p++, q++;
  800e89:	ff 4d 10             	decl   0x10(%ebp)
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 17                	je     800eaf <strncmp+0x2b>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	74 0e                	je     800eaf <strncmp+0x2b>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 10                	mov    (%eax),%dl
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	38 c2                	cmp    %al,%dl
  800ead:	74 da                	je     800e89 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	75 07                	jne    800ebc <strncmp+0x38>
		return 0;
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eba:	eb 14                	jmp    800ed0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f b6 d0             	movzbl %al,%edx
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	29 c2                	sub    %eax,%edx
  800ece:	89 d0                	mov    %edx,%eax
}
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 04             	sub    $0x4,%esp
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ede:	eb 12                	jmp    800ef2 <strchr+0x20>
		if (*s == c)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee8:	75 05                	jne    800eef <strchr+0x1d>
			return (char *) s;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	eb 11                	jmp    800f00 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eef:	ff 45 08             	incl   0x8(%ebp)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	84 c0                	test   %al,%al
  800ef9:	75 e5                	jne    800ee0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800efb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f0e:	eb 0d                	jmp    800f1d <strfind+0x1b>
		if (*s == c)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f18:	74 0e                	je     800f28 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	84 c0                	test   %al,%al
  800f24:	75 ea                	jne    800f10 <strfind+0xe>
  800f26:	eb 01                	jmp    800f29 <strfind+0x27>
		if (*s == c)
			break;
  800f28:	90                   	nop
	return (char *) s;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f40:	eb 0e                	jmp    800f50 <memset+0x22>
		*p++ = c;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8d 50 01             	lea    0x1(%eax),%edx
  800f48:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f50:	ff 4d f8             	decl   -0x8(%ebp)
  800f53:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f57:	79 e9                	jns    800f42 <memset+0x14>
		*p++ = c;

	return v;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f70:	eb 16                	jmp    800f88 <memcpy+0x2a>
		*d++ = *s++;
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	8d 50 01             	lea    0x1(%eax),%edx
  800f78:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f81:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f84:	8a 12                	mov    (%edx),%dl
  800f86:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 dd                	jne    800f72 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb2:	73 50                	jae    801004 <memmove+0x6a>
  800fb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	01 d0                	add    %edx,%eax
  800fbc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbf:	76 43                	jbe    801004 <memmove+0x6a>
		s += n;
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcd:	eb 10                	jmp    800fdf <memmove+0x45>
			*--d = *--s;
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	ff 4d fc             	decl   -0x4(%ebp)
  800fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd8:	8a 10                	mov    (%eax),%dl
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 e3                	jne    800fcf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fec:	eb 23                	jmp    801011 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff1:	8d 50 01             	lea    0x1(%eax),%edx
  800ff4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801000:	8a 12                	mov    (%edx),%dl
  801002:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100a:	89 55 10             	mov    %edx,0x10(%ebp)
  80100d:	85 c0                	test   %eax,%eax
  80100f:	75 dd                	jne    800fee <memmove+0x54>
			*d++ = *s++;

	return dst;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801028:	eb 2a                	jmp    801054 <memcmp+0x3e>
		if (*s1 != *s2)
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 10                	mov    (%eax),%dl
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	38 c2                	cmp    %al,%dl
  801036:	74 16                	je     80104e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f b6 d0             	movzbl %al,%edx
  801040:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 c0             	movzbl %al,%eax
  801048:	29 c2                	sub    %eax,%edx
  80104a:	89 d0                	mov    %edx,%eax
  80104c:	eb 18                	jmp    801066 <memcmp+0x50>
		s1++, s2++;
  80104e:	ff 45 fc             	incl   -0x4(%ebp)
  801051:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 c9                	jne    80102a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801079:	eb 15                	jmp    801090 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	0f b6 d0             	movzbl %al,%edx
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	0f b6 c0             	movzbl %al,%eax
  801089:	39 c2                	cmp    %eax,%edx
  80108b:	74 0d                	je     80109a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108d:	ff 45 08             	incl   0x8(%ebp)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801096:	72 e3                	jb     80107b <memfind+0x13>
  801098:	eb 01                	jmp    80109b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109a:	90                   	nop
	return (void *) s;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109e:	c9                   	leave  
  80109f:	c3                   	ret    

008010a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b4:	eb 03                	jmp    8010b9 <strtol+0x19>
		s++;
  8010b6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3c 20                	cmp    $0x20,%al
  8010c0:	74 f4                	je     8010b6 <strtol+0x16>
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 09                	cmp    $0x9,%al
  8010c9:	74 eb                	je     8010b6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2b                	cmp    $0x2b,%al
  8010d2:	75 05                	jne    8010d9 <strtol+0x39>
		s++;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	eb 13                	jmp    8010ec <strtol+0x4c>
	else if (*s == '-')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 2d                	cmp    $0x2d,%al
  8010e0:	75 0a                	jne    8010ec <strtol+0x4c>
		s++, neg = 1;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f0:	74 06                	je     8010f8 <strtol+0x58>
  8010f2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f6:	75 20                	jne    801118 <strtol+0x78>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 30                	cmp    $0x30,%al
  8010ff:	75 17                	jne    801118 <strtol+0x78>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	40                   	inc    %eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3c 78                	cmp    $0x78,%al
  801109:	75 0d                	jne    801118 <strtol+0x78>
		s += 2, base = 16;
  80110b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801116:	eb 28                	jmp    801140 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801118:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111c:	75 15                	jne    801133 <strtol+0x93>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 30                	cmp    $0x30,%al
  801125:	75 0c                	jne    801133 <strtol+0x93>
		s++, base = 8;
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801131:	eb 0d                	jmp    801140 <strtol+0xa0>
	else if (base == 0)
  801133:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801137:	75 07                	jne    801140 <strtol+0xa0>
		base = 10;
  801139:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	3c 2f                	cmp    $0x2f,%al
  801147:	7e 19                	jle    801162 <strtol+0xc2>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 39                	cmp    $0x39,%al
  801150:	7f 10                	jg     801162 <strtol+0xc2>
			dig = *s - '0';
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	0f be c0             	movsbl %al,%eax
  80115a:	83 e8 30             	sub    $0x30,%eax
  80115d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801160:	eb 42                	jmp    8011a4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 60                	cmp    $0x60,%al
  801169:	7e 19                	jle    801184 <strtol+0xe4>
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 7a                	cmp    $0x7a,%al
  801172:	7f 10                	jg     801184 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	0f be c0             	movsbl %al,%eax
  80117c:	83 e8 57             	sub    $0x57,%eax
  80117f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801182:	eb 20                	jmp    8011a4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 40                	cmp    $0x40,%al
  80118b:	7e 39                	jle    8011c6 <strtol+0x126>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 5a                	cmp    $0x5a,%al
  801194:	7f 30                	jg     8011c6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	0f be c0             	movsbl %al,%eax
  80119e:	83 e8 37             	sub    $0x37,%eax
  8011a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011aa:	7d 19                	jge    8011c5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c0:	e9 7b ff ff ff       	jmp    801140 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ca:	74 08                	je     8011d4 <strtol+0x134>
		*endptr = (char *) s;
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d8:	74 07                	je     8011e1 <strtol+0x141>
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dd:	f7 d8                	neg    %eax
  8011df:	eb 03                	jmp    8011e4 <strtol+0x144>
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fe:	79 13                	jns    801213 <ltostr+0x2d>
	{
		neg = 1;
  801200:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801210:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121b:	99                   	cltd   
  80121c:	f7 f9                	idiv   %ecx
  80121e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801221:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801234:	83 c2 30             	add    $0x30,%edx
  801237:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801241:	f7 e9                	imul   %ecx
  801243:	c1 fa 02             	sar    $0x2,%edx
  801246:	89 c8                	mov    %ecx,%eax
  801248:	c1 f8 1f             	sar    $0x1f,%eax
  80124b:	29 c2                	sub    %eax,%edx
  80124d:	89 d0                	mov    %edx,%eax
  80124f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801255:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125a:	f7 e9                	imul   %ecx
  80125c:	c1 fa 02             	sar    $0x2,%edx
  80125f:	89 c8                	mov    %ecx,%eax
  801261:	c1 f8 1f             	sar    $0x1f,%eax
  801264:	29 c2                	sub    %eax,%edx
  801266:	89 d0                	mov    %edx,%eax
  801268:	c1 e0 02             	shl    $0x2,%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	01 c0                	add    %eax,%eax
  80126f:	29 c1                	sub    %eax,%ecx
  801271:	89 ca                	mov    %ecx,%edx
  801273:	85 d2                	test   %edx,%edx
  801275:	75 9c                	jne    801213 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801281:	48                   	dec    %eax
  801282:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 3d                	je     8012c8 <ltostr+0xe2>
		start = 1 ;
  80128b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801292:	eb 34                	jmp    8012c8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	01 c2                	add    %eax,%edx
  8012a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ce:	7c c4                	jl     801294 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012db:	90                   	nop
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 54 fa ff ff       	call   800d40 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	e8 46 fa ff ff       	call   800d40 <strlen>
  8012fa:	83 c4 04             	add    $0x4,%esp
  8012fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130e:	eb 17                	jmp    801327 <strcconcat+0x49>
		final[s] = str1[s] ;
  801310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	01 c2                	add    %eax,%edx
  801318:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	01 c8                	add    %ecx,%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801324:	ff 45 fc             	incl   -0x4(%ebp)
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132d:	7c e1                	jl     801310 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801336:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133d:	eb 1f                	jmp    80135e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801348:	89 c2                	mov    %eax,%edx
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
  80134d:	01 c2                	add    %eax,%edx
  80134f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 c8                	add    %ecx,%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80135b:	ff 45 f8             	incl   -0x8(%ebp)
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801364:	7c d9                	jl     80133f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	c6 00 00             	movb   $0x0,(%eax)
}
  801371:	90                   	nop
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	eb 0c                	jmp    8013a5 <strsplit+0x31>
			*string++ = 0;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 18                	je     8013c6 <strsplit+0x52>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	0f be c0             	movsbl %al,%eax
  8013b6:	50                   	push   %eax
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	e8 13 fb ff ff       	call   800ed2 <strchr>
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	75 d3                	jne    801399 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 5a                	je     801429 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 f8 0f             	cmp    $0xf,%eax
  8013d7:	75 07                	jne    8013e0 <strsplit+0x6c>
		{
			return 0;
  8013d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013de:	eb 66                	jmp    801446 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013eb:	89 0a                	mov    %ecx,(%edx)
  8013ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fe:	eb 03                	jmp    801403 <strsplit+0x8f>
			string++;
  801400:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	74 8b                	je     801397 <strsplit+0x23>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f be c0             	movsbl %al,%eax
  801414:	50                   	push   %eax
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	e8 b5 fa ff ff       	call   800ed2 <strchr>
  80141d:	83 c4 08             	add    $0x8,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	74 dc                	je     801400 <strsplit+0x8c>
			string++;
	}
  801424:	e9 6e ff ff ff       	jmp    801397 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801429:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80142a:	8b 45 14             	mov    0x14(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801441:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80144e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801455:	eb 4c                	jmp    8014a3 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 40                	cmp    $0x40,%al
  801463:	7e 27                	jle    80148c <str2lower+0x44>
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 5a                	cmp    $0x5a,%al
  801471:	7f 19                	jg     80148c <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801481:	01 ca                	add    %ecx,%edx
  801483:	8a 12                	mov    (%edx),%dl
  801485:	83 c2 20             	add    $0x20,%edx
  801488:	88 10                	mov    %dl,(%eax)
  80148a:	eb 14                	jmp    8014a0 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80148c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	01 c2                	add    %eax,%edx
  801494:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	01 c8                	add    %ecx,%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8014a0:	ff 45 fc             	incl   -0x4(%ebp)
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	e8 95 f8 ff ff       	call   800d40 <strlen>
  8014ab:	83 c4 04             	add    $0x4,%esp
  8014ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b1:	7f a4                	jg     801457 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  8014bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	74 0a                	je     8014d0 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014c6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014cd:	00 00 00 
	}
}
  8014d0:	90                   	nop
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 7e 09 00 00       	call   801e62 <sys_sbrk>
  8014e4:	83 c4 10             	add    $0x10,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ef:	e8 c6 ff ff ff       	call   8014ba <InitializeUHeap>
	if (size == 0)
  8014f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f8:	75 0a                	jne    801504 <malloc+0x1b>
		return NULL;
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ff:	e9 3f 01 00 00       	jmp    801643 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801504:	e8 ac 09 00 00       	call   801eb5 <sys_get_hard_limit>
  801509:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  80150c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801516:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
  80151e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801521:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801528:	8b 55 08             	mov    0x8(%ebp),%edx
  80152b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	48                   	dec    %eax
  801531:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	f7 75 d8             	divl   -0x28(%ebp)
  80153f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801542:	29 d0                	sub    %edx,%eax
  801544:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801547:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80154a:	c1 e8 0c             	shr    $0xc,%eax
  80154d:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801554:	75 0a                	jne    801560 <malloc+0x77>
		return NULL;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	e9 e3 00 00 00       	jmp    801643 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801563:	05 00 00 00 80       	add    $0x80000000,%eax
  801568:	c1 e8 0c             	shr    $0xc,%eax
  80156b:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801570:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801577:	77 19                	ja     801592 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801579:	83 ec 0c             	sub    $0xc,%esp
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	e8 44 0b 00 00       	call   8020c8 <alloc_block_FF>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  80158a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80158d:	e9 b1 00 00 00       	jmp    801643 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801592:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801595:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801598:	eb 4d                	jmp    8015e7 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  80159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159d:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015a4:	84 c0                	test   %al,%al
  8015a6:	75 27                	jne    8015cf <malloc+0xe6>
			{
				counter++;
  8015a8:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  8015ab:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8015af:	75 14                	jne    8015c5 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  8015b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b4:	05 00 00 08 00       	add    $0x80000,%eax
  8015b9:	c1 e0 0c             	shl    $0xc,%eax
  8015bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  8015c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c8:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015cb:	75 17                	jne    8015e4 <malloc+0xfb>
				{
					break;
  8015cd:	eb 21                	jmp    8015f0 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  8015cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d2:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015d9:	3c 01                	cmp    $0x1,%al
  8015db:	75 07                	jne    8015e4 <malloc+0xfb>
			{
				counter = 0;
  8015dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  8015e4:	ff 45 e8             	incl   -0x18(%ebp)
  8015e7:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8015ee:	76 aa                	jbe    80159a <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8015f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f3:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015f6:	75 46                	jne    80163e <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8015fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801601:	e8 93 08 00 00       	call   801e99 <sys_allocate_user_mem>
  801606:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80160f:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80161c:	eb 0e                	jmp    80162c <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  80161e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801621:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  801628:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801629:	ff 45 e4             	incl   -0x1c(%ebp)
  80162c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801637:	77 e5                	ja     80161e <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163c:	eb 05                	jmp    801643 <malloc+0x15a>
		}
	}

	return NULL;
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80164b:	e8 65 08 00 00       	call   801eb5 <sys_get_hard_limit>
  801650:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801659:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165d:	0f 84 c1 00 00 00    	je     801724 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801666:	85 c0                	test   %eax,%eax
  801668:	79 1b                	jns    801685 <free+0x40>
  80166a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801670:	73 13                	jae    801685 <free+0x40>
    {
        free_block(virtual_address);
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 18 10 00 00       	call   802695 <free_block>
  80167d:	83 c4 10             	add    $0x10,%esp
    	return;
  801680:	e9 a6 00 00 00       	jmp    80172b <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	05 00 10 00 00       	add    $0x1000,%eax
  80168d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801690:	0f 87 91 00 00 00    	ja     801727 <free+0xe2>
  801696:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80169d:	0f 87 84 00 00 00    	ja     801727 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  8016a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  8016b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b7:	05 00 00 00 80       	add    $0x80000000,%eax
  8016bc:	c1 e8 0c             	shr    $0xc,%eax
  8016bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  8016c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c5:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8016cc:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  8016cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016d3:	74 55                	je     80172a <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  8016d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d8:	c1 e8 0c             	shr    $0xc,%eax
  8016db:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  8016de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e1:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  8016e8:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8016ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f2:	eb 0e                	jmp    801702 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  8016fe:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  8016ff:	ff 45 f4             	incl   -0xc(%ebp)
  801702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801708:	01 c2                	add    %eax,%edx
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	39 c2                	cmp    %eax,%edx
  80170f:	77 e3                	ja     8016f4 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	ff 75 e0             	pushl  -0x20(%ebp)
  801717:	ff 75 ec             	pushl  -0x14(%ebp)
  80171a:	e8 5e 07 00 00       	call   801e7d <sys_free_user_mem>
  80171f:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801722:	eb 07                	jmp    80172b <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801724:	90                   	nop
  801725:	eb 04                	jmp    80172b <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801727:	90                   	nop
  801728:	eb 01                	jmp    80172b <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  80172a:	90                   	nop
    else
     {
    	return;
      }

}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 18             	sub    $0x18,%esp
  801733:	8b 45 10             	mov    0x10(%ebp),%eax
  801736:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801739:	e8 7c fd ff ff       	call   8014ba <InitializeUHeap>
	if (size == 0)
  80173e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801742:	75 07                	jne    80174b <smalloc+0x1e>
		return NULL;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	eb 17                	jmp    801762 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 70 3a 80 00       	push   $0x803a70
  801753:	68 ad 00 00 00       	push   $0xad
  801758:	68 96 3a 80 00       	push   $0x803a96
  80175d:	e8 9f ec ff ff       	call   800401 <_panic>
	return NULL;
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176a:	e8 4b fd ff ff       	call   8014ba <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 a4 3a 80 00       	push   $0x803aa4
  801777:	68 ba 00 00 00       	push   $0xba
  80177c:	68 96 3a 80 00       	push   $0x803a96
  801781:	e8 7b ec ff ff       	call   800401 <_panic>

00801786 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178c:	e8 29 fd ff ff       	call   8014ba <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 c8 3a 80 00       	push   $0x803ac8
  801799:	68 d8 00 00 00       	push   $0xd8
  80179e:	68 96 3a 80 00       	push   $0x803a96
  8017a3:	e8 59 ec ff ff       	call   800401 <_panic>

008017a8 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 f0 3a 80 00       	push   $0x803af0
  8017b6:	68 ea 00 00 00       	push   $0xea
  8017bb:	68 96 3a 80 00       	push   $0x803a96
  8017c0:	e8 3c ec ff ff       	call   800401 <_panic>

008017c5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 14 3b 80 00       	push   $0x803b14
  8017d3:	68 f2 00 00 00       	push   $0xf2
  8017d8:	68 96 3a 80 00       	push   $0x803a96
  8017dd:	e8 1f ec ff ff       	call   800401 <_panic>

008017e2 <shrink>:

}
void shrink(uint32 newSize) {
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 14 3b 80 00       	push   $0x803b14
  8017f0:	68 f6 00 00 00       	push   $0xf6
  8017f5:	68 96 3a 80 00       	push   $0x803a96
  8017fa:	e8 02 ec ff ff       	call   800401 <_panic>

008017ff <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 14 3b 80 00       	push   $0x803b14
  80180d:	68 fa 00 00 00       	push   $0xfa
  801812:	68 96 3a 80 00       	push   $0x803a96
  801817:	e8 e5 eb ff ff       	call   800401 <_panic>

0080181c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801831:	8b 7d 18             	mov    0x18(%ebp),%edi
  801834:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801837:	cd 30                	int    $0x30
  801839:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5f                   	pop    %edi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	8b 45 10             	mov    0x10(%ebp),%eax
  801850:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801853:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	52                   	push   %edx
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	50                   	push   %eax
  801863:	6a 00                	push   $0x0
  801865:	e8 b2 ff ff ff       	call   80181c <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	90                   	nop
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_cgetc>:

int
sys_cgetc(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 01                	push   $0x1
  80187f:	e8 98 ff ff ff       	call   80181c <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 05                	push   $0x5
  80189c:	e8 7b ff ff ff       	call   80181c <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	51                   	push   %ecx
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 06                	push   $0x6
  8018c1:	e8 56 ff ff ff       	call   80181c <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cc:	5b                   	pop    %ebx
  8018cd:	5e                   	pop    %esi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    

008018d0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 07                	push   $0x7
  8018e3:	e8 34 ff ff ff       	call   80181c <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	6a 08                	push   $0x8
  8018fe:	e8 19 ff ff ff       	call   80181c <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 09                	push   $0x9
  801917:	e8 00 ff ff ff       	call   80181c <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 0a                	push   $0xa
  801930:	e8 e7 fe ff ff       	call   80181c <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 0b                	push   $0xb
  801949:	e8 ce fe ff ff       	call   80181c <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 0c                	push   $0xc
  801962:	e8 b5 fe ff ff       	call   80181c <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 0d                	push   $0xd
  80197c:	e8 9b fe ff ff       	call   80181c <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 0e                	push   $0xe
  801995:	e8 82 fe ff ff       	call   80181c <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 11                	push   $0x11
  8019af:	e8 68 fe ff ff       	call   80181c <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 12                	push   $0x12
  8019c9:	e8 4e fe ff ff       	call   80181c <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	50                   	push   %eax
  8019ed:	6a 13                	push   $0x13
  8019ef:	e8 28 fe ff ff       	call   80181c <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 14                	push   $0x14
  801a09:	e8 0e fe ff ff       	call   80181c <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	50                   	push   %eax
  801a24:	6a 15                	push   $0x15
  801a26:	e8 f1 fd ff ff       	call   80181c <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 18                	push   $0x18
  801a43:	e8 d4 fd ff ff       	call   80181c <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 16                	push   $0x16
  801a60:	e8 b7 fd ff ff       	call   80181c <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	90                   	nop
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	6a 17                	push   $0x17
  801a7e:	e8 99 fd ff ff       	call   80181c <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	90                   	nop
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a92:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a95:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a98:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	51                   	push   %ecx
  801aa2:	52                   	push   %edx
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	50                   	push   %eax
  801aa7:	6a 19                	push   $0x19
  801aa9:	e8 6e fd ff ff       	call   80181c <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 1a                	push   $0x1a
  801ac6:	e8 51 fd ff ff       	call   80181c <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ad3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	51                   	push   %ecx
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 1b                	push   $0x1b
  801ae5:	e8 32 fd ff ff       	call   80181c <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 1c                	push   $0x1c
  801b02:	e8 15 fd ff ff       	call   80181c <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 1d                	push   $0x1d
  801b1b:	e8 fc fc ff ff       	call   80181c <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 14             	pushl  0x14(%ebp)
  801b30:	ff 75 10             	pushl  0x10(%ebp)
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	50                   	push   %eax
  801b37:	6a 1e                	push   $0x1e
  801b39:	e8 de fc ff ff       	call   80181c <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	50                   	push   %eax
  801b52:	6a 1f                	push   $0x1f
  801b54:	e8 c3 fc ff ff       	call   80181c <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	50                   	push   %eax
  801b6e:	6a 20                	push   $0x20
  801b70:	e8 a7 fc ff ff       	call   80181c <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 02                	push   $0x2
  801b89:	e8 8e fc ff ff       	call   80181c <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 03                	push   $0x3
  801ba2:	e8 75 fc ff ff       	call   80181c <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 04                	push   $0x4
  801bbb:	e8 5c fc ff ff       	call   80181c <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_exit_env>:


void sys_exit_env(void)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 21                	push   $0x21
  801bd4:	e8 43 fc ff ff       	call   80181c <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	90                   	nop
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801be5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be8:	8d 50 04             	lea    0x4(%eax),%edx
  801beb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	6a 22                	push   $0x22
  801bf8:	e8 1f fc ff ff       	call   80181c <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return result;
  801c00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	89 01                	mov    %eax,(%ecx)
  801c0b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	c9                   	leave  
  801c12:	c2 04 00             	ret    $0x4

00801c15 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 10             	pushl  0x10(%ebp)
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 10                	push   $0x10
  801c27:	e8 f0 fb ff ff       	call   80181c <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 23                	push   $0x23
  801c41:	e8 d6 fb ff ff       	call   80181c <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c57:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	50                   	push   %eax
  801c64:	6a 24                	push   $0x24
  801c66:	e8 b1 fb ff ff       	call   80181c <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6e:	90                   	nop
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <rsttst>:
void rsttst()
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 26                	push   $0x26
  801c80:	e8 97 fb ff ff       	call   80181c <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return ;
  801c88:	90                   	nop
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 04             	sub    $0x4,%esp
  801c91:	8b 45 14             	mov    0x14(%ebp),%eax
  801c94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c97:	8b 55 18             	mov    0x18(%ebp),%edx
  801c9a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	ff 75 10             	pushl  0x10(%ebp)
  801ca3:	ff 75 0c             	pushl  0xc(%ebp)
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	6a 25                	push   $0x25
  801cab:	e8 6c fb ff ff       	call   80181c <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb3:	90                   	nop
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <chktst>:
void chktst(uint32 n)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	ff 75 08             	pushl  0x8(%ebp)
  801cc4:	6a 27                	push   $0x27
  801cc6:	e8 51 fb ff ff       	call   80181c <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <inctst>:

void inctst()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 28                	push   $0x28
  801ce0:	e8 37 fb ff ff       	call   80181c <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce8:	90                   	nop
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <gettst>:
uint32 gettst()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 29                	push   $0x29
  801cfa:	e8 1d fb ff ff       	call   80181c <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 2a                	push   $0x2a
  801d16:	e8 01 fb ff ff       	call   80181c <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
  801d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d21:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d25:	75 07                	jne    801d2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2c:	eb 05                	jmp    801d33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 2a                	push   $0x2a
  801d47:	e8 d0 fa ff ff       	call   80181c <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
  801d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d52:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d56:	75 07                	jne    801d5f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d58:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5d:	eb 05                	jmp    801d64 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 2a                	push   $0x2a
  801d78:	e8 9f fa ff ff       	call   80181c <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
  801d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d83:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d87:	75 07                	jne    801d90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	eb 05                	jmp    801d95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 2a                	push   $0x2a
  801da9:	e8 6e fa ff ff       	call   80181c <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
  801db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db8:	75 07                	jne    801dc1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dba:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbf:	eb 05                	jmp    801dc6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 2b                	push   $0x2b
  801dd8:	e8 3f fa ff ff       	call   80181c <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801de7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	53                   	push   %ebx
  801df6:	51                   	push   %ecx
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	6a 2c                	push   $0x2c
  801dfb:	e8 1c fa ff ff       	call   80181c <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	6a 2d                	push   $0x2d
  801e1b:	e8 fc f9 ff ff       	call   80181c <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	6a 00                	push   $0x0
  801e33:	51                   	push   %ecx
  801e34:	ff 75 10             	pushl  0x10(%ebp)
  801e37:	52                   	push   %edx
  801e38:	50                   	push   %eax
  801e39:	6a 2e                	push   $0x2e
  801e3b:	e8 dc f9 ff ff       	call   80181c <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	ff 75 10             	pushl  0x10(%ebp)
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	6a 0f                	push   $0xf
  801e57:	e8 c0 f9 ff ff       	call   80181c <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 2f                	push   $0x2f
  801e73:	e8 a4 f9 ff ff       	call   80181c <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp

}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	6a 30                	push   $0x30
  801e8e:	e8 89 f9 ff ff       	call   80181c <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
	return;
  801e96:	90                   	nop
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 31                	push   $0x31
  801eaa:	e8 6d f9 ff ff       	call   80181c <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 32                	push   $0x32
  801ec4:	e8 53 f9 ff ff       	call   80181c <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	83 e8 10             	sub    $0x10,%eax
  801eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee0:	8b 00                	mov    (%eax),%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	83 e8 10             	sub    $0x10,%eax
  801ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef6:	8a 40 04             	mov    0x4(%eax),%al
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0b:	83 f8 02             	cmp    $0x2,%eax
  801f0e:	74 2b                	je     801f3b <alloc_block+0x40>
  801f10:	83 f8 02             	cmp    $0x2,%eax
  801f13:	7f 07                	jg     801f1c <alloc_block+0x21>
  801f15:	83 f8 01             	cmp    $0x1,%eax
  801f18:	74 0e                	je     801f28 <alloc_block+0x2d>
  801f1a:	eb 58                	jmp    801f74 <alloc_block+0x79>
  801f1c:	83 f8 03             	cmp    $0x3,%eax
  801f1f:	74 2d                	je     801f4e <alloc_block+0x53>
  801f21:	83 f8 04             	cmp    $0x4,%eax
  801f24:	74 3b                	je     801f61 <alloc_block+0x66>
  801f26:	eb 4c                	jmp    801f74 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	e8 95 01 00 00       	call   8020c8 <alloc_block_FF>
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f39:	eb 4a                	jmp    801f85 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 08             	pushl  0x8(%ebp)
  801f41:	e8 32 07 00 00       	call   802678 <alloc_block_NF>
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f4c:	eb 37                	jmp    801f85 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	e8 a3 04 00 00       	call   8023fc <alloc_block_BF>
  801f59:	83 c4 10             	add    $0x10,%esp
  801f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f5f:	eb 24                	jmp    801f85 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 ef 06 00 00       	call   80265b <alloc_block_WF>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f72:	eb 11                	jmp    801f85 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	68 24 3b 80 00       	push   $0x803b24
  801f7c:	e8 3d e7 ff ff       	call   8006be <cprintf>
  801f81:	83 c4 10             	add    $0x10,%esp
		break;
  801f84:	90                   	nop
	}
	return va;
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	68 44 3b 80 00       	push   $0x803b44
  801f98:	e8 21 e7 ff ff       	call   8006be <cprintf>
  801f9d:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	68 6f 3b 80 00       	push   $0x803b6f
  801fa8:	e8 11 e7 ff ff       	call   8006be <cprintf>
  801fad:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb6:	eb 26                	jmp    801fde <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8a 40 04             	mov    0x4(%eax),%al
  801fbe:	0f b6 d0             	movzbl %al,%edx
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	52                   	push   %edx
  801fca:	50                   	push   %eax
  801fcb:	68 87 3b 80 00       	push   $0x803b87
  801fd0:	e8 e9 e6 ff ff       	call   8006be <cprintf>
  801fd5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe2:	74 08                	je     801fec <print_blocks_list+0x62>
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	eb 05                	jmp    801ff1 <print_blocks_list+0x67>
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff1:	89 45 10             	mov    %eax,0x10(%ebp)
  801ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	75 bd                	jne    801fb8 <print_blocks_list+0x2e>
  801ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fff:	75 b7                	jne    801fb8 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	68 44 3b 80 00       	push   $0x803b44
  802009:	e8 b0 e6 ff ff       	call   8006be <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp

}
  802011:	90                   	nop
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80201a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80201e:	0f 84 a1 00 00 00    	je     8020c5 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802024:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  80202b:	00 00 00 
	LIST_INIT(&list);
  80202e:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  802035:	00 00 00 
  802038:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  80203f:	00 00 00 
  802042:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  802049:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802065:	75 14                	jne    80207b <initialize_dynamic_allocator+0x67>
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	68 a0 3b 80 00       	push   $0x803ba0
  80206f:	6a 64                	push   $0x64
  802071:	68 c3 3b 80 00       	push   $0x803bc3
  802076:	e8 86 e3 ff ff       	call   800401 <_panic>
  80207b:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	89 50 0c             	mov    %edx,0xc(%eax)
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	8b 40 0c             	mov    0xc(%eax),%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	74 0d                	je     80209e <initialize_dynamic_allocator+0x8a>
  802091:	a1 44 41 90 00       	mov    0x904144,%eax
  802096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802099:	89 50 08             	mov    %edx,0x8(%eax)
  80209c:	eb 08                	jmp    8020a6 <initialize_dynamic_allocator+0x92>
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	a3 40 41 90 00       	mov    %eax,0x904140
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	a3 44 41 90 00       	mov    %eax,0x904144
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020b8:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8020bd:	40                   	inc    %eax
  8020be:	a3 4c 41 90 00       	mov    %eax,0x90414c
  8020c3:	eb 01                	jmp    8020c6 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8020c5:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8020ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d2:	75 0a                	jne    8020de <alloc_block_FF+0x16>
	{
		return NULL;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d9:	e9 1c 03 00 00       	jmp    8023fa <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8020de:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	75 40                	jne    802127 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	83 c0 10             	add    $0x10,%eax
  8020ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8020f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	50                   	push   %eax
  8020f7:	e8 d7 f3 ff ff       	call   8014d3 <sbrk>
  8020fc:	83 c4 10             	add    $0x10,%esp
  8020ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	6a 00                	push   $0x0
  802107:	e8 c7 f3 ff ff       	call   8014d3 <sbrk>
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802112:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802115:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802118:	83 ec 08             	sub    $0x8,%esp
  80211b:	50                   	push   %eax
  80211c:	ff 75 ec             	pushl  -0x14(%ebp)
  80211f:	e8 f0 fe ff ff       	call   802014 <initialize_dynamic_allocator>
  802124:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802127:	a1 40 41 90 00       	mov    0x904140,%eax
  80212c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212f:	e9 1e 01 00 00       	jmp    802252 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8d 50 10             	lea    0x10(%eax),%edx
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	39 c2                	cmp    %eax,%edx
  802141:	75 1c                	jne    80215f <alloc_block_FF+0x97>
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8a 40 04             	mov    0x4(%eax),%al
  802149:	3c 01                	cmp    $0x1,%al
  80214b:	75 12                	jne    80215f <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	83 c0 10             	add    $0x10,%eax
  80215a:	e9 9b 02 00 00       	jmp    8023fa <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8d 50 10             	lea    0x10(%eax),%edx
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	39 c2                	cmp    %eax,%edx
  80216c:	0f 83 d8 00 00 00    	jae    80224a <alloc_block_FF+0x182>
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8a 40 04             	mov    0x4(%eax),%al
  802178:	3c 01                	cmp    $0x1,%al
  80217a:	0f 85 ca 00 00 00    	jne    80224a <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	2b 45 08             	sub    0x8(%ebp),%eax
  802188:	83 e8 10             	sub    $0x10,%eax
  80218b:	83 f8 0f             	cmp    $0xf,%eax
  80218e:	0f 86 a4 00 00 00    	jbe    802238 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	01 d0                	add    %edx,%eax
  80219c:	83 c0 10             	add    $0x10,%eax
  80219f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8021aa:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021b0:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8021b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021b5:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8021b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bd:	74 06                	je     8021c5 <alloc_block_FF+0xfd>
  8021bf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021c3:	75 17                	jne    8021dc <alloc_block_FF+0x114>
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	68 dc 3b 80 00       	push   $0x803bdc
  8021cd:	68 8f 00 00 00       	push   $0x8f
  8021d2:	68 c3 3b 80 00       	push   $0x803bc3
  8021d7:	e8 25 e2 ff ff       	call   800401 <_panic>
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 50 08             	mov    0x8(%eax),%edx
  8021e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021e5:	89 50 08             	mov    %edx,0x8(%eax)
  8021e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	74 0c                	je     8021fe <alloc_block_FF+0x136>
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8021fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802204:	89 50 08             	mov    %edx,0x8(%eax)
  802207:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	89 50 0c             	mov    %edx,0xc(%eax)
  802210:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802213:	8b 40 08             	mov    0x8(%eax),%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	75 08                	jne    802222 <alloc_block_FF+0x15a>
  80221a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80221d:	a3 44 41 90 00       	mov    %eax,0x904144
  802222:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802227:	40                   	inc    %eax
  802228:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	8d 50 10             	lea    0x10(%eax),%edx
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	83 c0 10             	add    $0x10,%eax
  802245:	e9 b0 01 00 00       	jmp    8023fa <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  80224a:	a1 48 41 90 00       	mov    0x904148,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802256:	74 08                	je     802260 <alloc_block_FF+0x198>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	eb 05                	jmp    802265 <alloc_block_FF+0x19d>
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
  802265:	a3 48 41 90 00       	mov    %eax,0x904148
  80226a:	a1 48 41 90 00       	mov    0x904148,%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	0f 85 bd fe ff ff    	jne    802134 <alloc_block_FF+0x6c>
  802277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227b:	0f 85 b3 fe ff ff    	jne    802134 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	83 c0 10             	add    $0x10,%eax
  802287:	83 ec 0c             	sub    $0xc,%esp
  80228a:	50                   	push   %eax
  80228b:	e8 43 f2 ff ff       	call   8014d3 <sbrk>
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802296:	83 ec 0c             	sub    $0xc,%esp
  802299:	6a 00                	push   $0x0
  80229b:	e8 33 f2 ff ff       	call   8014d3 <sbrk>
  8022a0:	83 c4 10             	add    $0x10,%esp
  8022a3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8022a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ac:	29 c2                	sub    %eax,%edx
  8022ae:	89 d0                	mov    %edx,%eax
  8022b0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8022b3:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8022b7:	0f 84 38 01 00 00    	je     8023f5 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8022bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8022c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022c7:	75 17                	jne    8022e0 <alloc_block_FF+0x218>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 a0 3b 80 00       	push   $0x803ba0
  8022d1:	68 9f 00 00 00       	push   $0x9f
  8022d6:	68 c3 3b 80 00       	push   $0x803bc3
  8022db:	e8 21 e1 ff ff       	call   800401 <_panic>
  8022e0:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8022e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8022ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	74 0d                	je     802303 <alloc_block_FF+0x23b>
  8022f6:	a1 44 41 90 00       	mov    0x904144,%eax
  8022fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022fe:	89 50 08             	mov    %edx,0x8(%eax)
  802301:	eb 08                	jmp    80230b <alloc_block_FF+0x243>
  802303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802306:	a3 40 41 90 00       	mov    %eax,0x904140
  80230b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80230e:	a3 44 41 90 00       	mov    %eax,0x904144
  802313:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802316:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80231d:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802322:	40                   	inc    %eax
  802323:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8d 50 10             	lea    0x10(%eax),%edx
  80232e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802331:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802333:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802336:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  80233a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80233d:	2b 45 08             	sub    0x8(%ebp),%eax
  802340:	83 f8 10             	cmp    $0x10,%eax
  802343:	0f 84 a4 00 00 00    	je     8023ed <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802349:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80234c:	2b 45 08             	sub    0x8(%ebp),%eax
  80234f:	83 e8 10             	sub    $0x10,%eax
  802352:	83 f8 0f             	cmp    $0xf,%eax
  802355:	0f 86 8a 00 00 00    	jbe    8023e5 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  80235b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	01 d0                	add    %edx,%eax
  802363:	83 c0 10             	add    $0x10,%eax
  802366:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802369:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80236d:	75 17                	jne    802386 <alloc_block_FF+0x2be>
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 a0 3b 80 00       	push   $0x803ba0
  802377:	68 a7 00 00 00       	push   $0xa7
  80237c:	68 c3 3b 80 00       	push   $0x803bc3
  802381:	e8 7b e0 ff ff       	call   800401 <_panic>
  802386:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80238c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80238f:	89 50 0c             	mov    %edx,0xc(%eax)
  802392:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802395:	8b 40 0c             	mov    0xc(%eax),%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 0d                	je     8023a9 <alloc_block_FF+0x2e1>
  80239c:	a1 44 41 90 00       	mov    0x904144,%eax
  8023a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023a4:	89 50 08             	mov    %edx,0x8(%eax)
  8023a7:	eb 08                	jmp    8023b1 <alloc_block_FF+0x2e9>
  8023a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ac:	a3 40 41 90 00       	mov    %eax,0x904140
  8023b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b4:	a3 44 41 90 00       	mov    %eax,0x904144
  8023b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023c3:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8023c8:	40                   	inc    %eax
  8023c9:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8023ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d4:	8d 50 f0             	lea    -0x10(%eax),%edx
  8023d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023da:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8023dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023df:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8023e3:	eb 08                	jmp    8023ed <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  8023e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023eb:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  8023ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f0:	83 c0 10             	add    $0x10,%eax
  8023f3:	eb 05                	jmp    8023fa <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  8023f5:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802402:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802409:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80240d:	75 0a                	jne    802419 <alloc_block_BF+0x1d>
	{
		return NULL;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	e9 40 02 00 00       	jmp    802659 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802419:	a1 40 41 90 00       	mov    0x904140,%eax
  80241e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802421:	eb 66                	jmp    802489 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8a 40 04             	mov    0x4(%eax),%al
  802429:	3c 01                	cmp    $0x1,%al
  80242b:	75 21                	jne    80244e <alloc_block_BF+0x52>
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	8d 50 10             	lea    0x10(%eax),%edx
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	39 c2                	cmp    %eax,%edx
  80243a:	75 12                	jne    80244e <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	83 c0 10             	add    $0x10,%eax
  802449:	e9 0b 02 00 00       	jmp    802659 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8a 40 04             	mov    0x4(%eax),%al
  802454:	3c 01                	cmp    $0x1,%al
  802456:	75 29                	jne    802481 <alloc_block_BF+0x85>
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	8d 50 10             	lea    0x10(%eax),%edx
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	39 c2                	cmp    %eax,%edx
  802465:	77 1a                	ja     802481 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246b:	74 0e                	je     80247b <alloc_block_BF+0x7f>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 10                	mov    (%eax),%edx
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	39 c2                	cmp    %eax,%edx
  802479:	73 06                	jae    802481 <alloc_block_BF+0x85>
			{
				BF = iterator;
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802481:	a1 48 41 90 00       	mov    0x904148,%eax
  802486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248d:	74 08                	je     802497 <alloc_block_BF+0x9b>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 08             	mov    0x8(%eax),%eax
  802495:	eb 05                	jmp    80249c <alloc_block_BF+0xa0>
  802497:	b8 00 00 00 00       	mov    $0x0,%eax
  80249c:	a3 48 41 90 00       	mov    %eax,0x904148
  8024a1:	a1 48 41 90 00       	mov    0x904148,%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	0f 85 75 ff ff ff    	jne    802423 <alloc_block_BF+0x27>
  8024ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b2:	0f 85 6b ff ff ff    	jne    802423 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  8024b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bc:	0f 84 f8 00 00 00    	je     8025ba <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	8d 50 10             	lea    0x10(%eax),%edx
  8024c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	39 c2                	cmp    %eax,%edx
  8024cf:	0f 87 e5 00 00 00    	ja     8025ba <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	2b 45 08             	sub    0x8(%ebp),%eax
  8024dd:	83 e8 10             	sub    $0x10,%eax
  8024e0:	83 f8 0f             	cmp    $0xf,%eax
  8024e3:	0f 86 bf 00 00 00    	jbe    8025a8 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  8024e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	83 c0 10             	add    $0x10,%eax
  8024f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  8024f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	2b 45 08             	sub    0x8(%ebp),%eax
  802508:	8d 50 f0             	lea    -0x10(%eax),%edx
  80250b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250e:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802513:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80251b:	74 06                	je     802523 <alloc_block_BF+0x127>
  80251d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802521:	75 17                	jne    80253a <alloc_block_BF+0x13e>
  802523:	83 ec 04             	sub    $0x4,%esp
  802526:	68 dc 3b 80 00       	push   $0x803bdc
  80252b:	68 e3 00 00 00       	push   $0xe3
  802530:	68 c3 3b 80 00       	push   $0x803bc3
  802535:	e8 c7 de ff ff       	call   800401 <_panic>
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	8b 50 08             	mov    0x8(%eax),%edx
  802540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802543:	89 50 08             	mov    %edx,0x8(%eax)
  802546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802549:	8b 40 08             	mov    0x8(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 0c                	je     80255c <alloc_block_BF+0x160>
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 40 08             	mov    0x8(%eax),%eax
  802556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802559:	89 50 0c             	mov    %edx,0xc(%eax)
  80255c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802562:	89 50 08             	mov    %edx,0x8(%eax)
  802565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802568:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256b:	89 50 0c             	mov    %edx,0xc(%eax)
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	8b 40 08             	mov    0x8(%eax),%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	75 08                	jne    802580 <alloc_block_BF+0x184>
  802578:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257b:	a3 44 41 90 00       	mov    %eax,0x904144
  802580:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802585:	40                   	inc    %eax
  802586:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	8d 50 10             	lea    0x10(%eax),%edx
  802591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802594:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  80259d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a0:	83 c0 10             	add    $0x10,%eax
  8025a3:	e9 b1 00 00 00       	jmp    802659 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	83 c0 10             	add    $0x10,%eax
  8025b5:	e9 9f 00 00 00       	jmp    802659 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	83 c0 10             	add    $0x10,%eax
  8025c0:	83 ec 0c             	sub    $0xc,%esp
  8025c3:	50                   	push   %eax
  8025c4:	e8 0a ef ff ff       	call   8014d3 <sbrk>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8025cf:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025d3:	74 7f                	je     802654 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8025d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025d9:	75 17                	jne    8025f2 <alloc_block_BF+0x1f6>
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 a0 3b 80 00       	push   $0x803ba0
  8025e3:	68 f6 00 00 00       	push   $0xf6
  8025e8:	68 c3 3b 80 00       	push   $0x803bc3
  8025ed:	e8 0f de ff ff       	call   800401 <_panic>
  8025f2:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8025f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8025fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802601:	8b 40 0c             	mov    0xc(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0d                	je     802615 <alloc_block_BF+0x219>
  802608:	a1 44 41 90 00       	mov    0x904144,%eax
  80260d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802610:	89 50 08             	mov    %edx,0x8(%eax)
  802613:	eb 08                	jmp    80261d <alloc_block_BF+0x221>
  802615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802618:	a3 40 41 90 00       	mov    %eax,0x904140
  80261d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802620:	a3 44 41 90 00       	mov    %eax,0x904144
  802625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802628:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80262f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802634:	40                   	inc    %eax
  802635:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8d 50 10             	lea    0x10(%eax),%edx
  802640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802643:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802648:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  80264c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264f:	83 c0 10             	add    $0x10,%eax
  802652:	eb 05                	jmp    802659 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802661:	83 ec 04             	sub    $0x4,%esp
  802664:	68 10 3c 80 00       	push   $0x803c10
  802669:	68 07 01 00 00       	push   $0x107
  80266e:	68 c3 3b 80 00       	push   $0x803bc3
  802673:	e8 89 dd ff ff       	call   800401 <_panic>

00802678 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 38 3c 80 00       	push   $0x803c38
  802686:	68 0f 01 00 00       	push   $0x10f
  80268b:	68 c3 3b 80 00       	push   $0x803bc3
  802690:	e8 6c dd ff ff       	call   800401 <_panic>

00802695 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  80269b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80269f:	0f 84 ee 05 00 00    	je     802c93 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	83 e8 10             	sub    $0x10,%eax
  8026ab:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  8026ae:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026b2:	a1 40 41 90 00       	mov    0x904140,%eax
  8026b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026ba:	eb 16                	jmp    8026d2 <free_block+0x3d>
	{
		if (block_pointer == it)
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026c2:	75 06                	jne    8026ca <free_block+0x35>
		{
			flagx = 1;
  8026c4:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  8026c8:	eb 2f                	jmp    8026f9 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026ca:	a1 48 41 90 00       	mov    0x904148,%eax
  8026cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d6:	74 08                	je     8026e0 <free_block+0x4b>
  8026d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026db:	8b 40 08             	mov    0x8(%eax),%eax
  8026de:	eb 05                	jmp    8026e5 <free_block+0x50>
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	a3 48 41 90 00       	mov    %eax,0x904148
  8026ea:	a1 48 41 90 00       	mov    0x904148,%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	75 c9                	jne    8026bc <free_block+0x27>
  8026f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f7:	75 c3                	jne    8026bc <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  8026f9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8026fd:	0f 84 93 05 00 00    	je     802c96 <free_block+0x601>
		return;
	if (va == NULL)
  802703:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802707:	0f 84 8c 05 00 00    	je     802c99 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  80270d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802719:	8b 40 08             	mov    0x8(%eax),%eax
  80271c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  80271f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802723:	75 12                	jne    802737 <free_block+0xa2>
  802725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802729:	75 0c                	jne    802737 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  80272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802732:	e9 63 05 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802737:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80273b:	0f 85 ca 00 00 00    	jne    80280b <free_block+0x176>
  802741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802744:	8a 40 04             	mov    0x4(%eax),%al
  802747:	3c 01                	cmp    $0x1,%al
  802749:	0f 85 bc 00 00 00    	jne    80280b <free_block+0x176>
	{
		block_pointer->is_free = 1;
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	8b 10                	mov    (%eax),%edx
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	01 c2                	add    %eax,%edx
  802762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802765:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802773:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80277b:	75 17                	jne    802794 <free_block+0xff>
  80277d:	83 ec 04             	sub    $0x4,%esp
  802780:	68 5e 3c 80 00       	push   $0x803c5e
  802785:	68 3c 01 00 00       	push   $0x13c
  80278a:	68 c3 3b 80 00       	push   $0x803bc3
  80278f:	e8 6d dc ff ff       	call   800401 <_panic>
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	8b 40 08             	mov    0x8(%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 11                	je     8027af <free_block+0x11a>
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	8b 40 08             	mov    0x8(%eax),%eax
  8027a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a7:	8b 52 0c             	mov    0xc(%edx),%edx
  8027aa:	89 50 0c             	mov    %edx,0xc(%eax)
  8027ad:	eb 0b                	jmp    8027ba <free_block+0x125>
  8027af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	a3 44 41 90 00       	mov    %eax,0x904144
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	74 11                	je     8027d5 <free_block+0x140>
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027cd:	8b 52 08             	mov    0x8(%edx),%edx
  8027d0:	89 50 08             	mov    %edx,0x8(%eax)
  8027d3:	eb 0b                	jmp    8027e0 <free_block+0x14b>
  8027d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	a3 40 41 90 00       	mov    %eax,0x904140
  8027e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027f4:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8027f9:	48                   	dec    %eax
  8027fa:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  8027ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802806:	e9 8f 04 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  80280b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80280f:	75 16                	jne    802827 <free_block+0x192>
  802811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802814:	8a 40 04             	mov    0x4(%eax),%al
  802817:	84 c0                	test   %al,%al
  802819:	75 0c                	jne    802827 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802822:	e9 73 04 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80282b:	0f 85 c3 00 00 00    	jne    8028f4 <free_block+0x25f>
  802831:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802834:	8a 40 04             	mov    0x4(%eax),%al
  802837:	3c 01                	cmp    $0x1,%al
  802839:	0f 85 b5 00 00 00    	jne    8028f4 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  80283f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802842:	8b 10                	mov    (%eax),%edx
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	01 c2                	add    %eax,%edx
  80284b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284e:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802864:	75 17                	jne    80287d <free_block+0x1e8>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 5e 3c 80 00       	push   $0x803c5e
  80286e:	68 49 01 00 00       	push   $0x149
  802873:	68 c3 3b 80 00       	push   $0x803bc3
  802878:	e8 84 db ff ff       	call   800401 <_panic>
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 11                	je     802898 <free_block+0x203>
  802887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288a:	8b 40 08             	mov    0x8(%eax),%eax
  80288d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802890:	8b 52 0c             	mov    0xc(%edx),%edx
  802893:	89 50 0c             	mov    %edx,0xc(%eax)
  802896:	eb 0b                	jmp    8028a3 <free_block+0x20e>
  802898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289b:	8b 40 0c             	mov    0xc(%eax),%eax
  80289e:	a3 44 41 90 00       	mov    %eax,0x904144
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	74 11                	je     8028be <free_block+0x229>
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b6:	8b 52 08             	mov    0x8(%edx),%edx
  8028b9:	89 50 08             	mov    %edx,0x8(%eax)
  8028bc:	eb 0b                	jmp    8028c9 <free_block+0x234>
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	8b 40 08             	mov    0x8(%eax),%eax
  8028c4:	a3 40 41 90 00       	mov    %eax,0x904140
  8028c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028dd:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  8028e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8028ef:	e9 a6 03 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  8028f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028f8:	75 16                	jne    802910 <free_block+0x27b>
  8028fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fd:	8a 40 04             	mov    0x4(%eax),%al
  802900:	84 c0                	test   %al,%al
  802902:	75 0c                	jne    802910 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802907:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80290b:	e9 8a 03 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802910:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802914:	0f 84 81 01 00 00    	je     802a9b <free_block+0x406>
  80291a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80291e:	0f 84 77 01 00 00    	je     802a9b <free_block+0x406>
  802924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802927:	8a 40 04             	mov    0x4(%eax),%al
  80292a:	3c 01                	cmp    $0x1,%al
  80292c:	0f 85 69 01 00 00    	jne    802a9b <free_block+0x406>
  802932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802935:	8a 40 04             	mov    0x4(%eax),%al
  802938:	3c 01                	cmp    $0x1,%al
  80293a:	0f 85 5b 01 00 00    	jne    802a9b <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	8b 10                	mov    (%eax),%edx
  802945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802948:	8b 08                	mov    (%eax),%ecx
  80294a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	01 c8                	add    %ecx,%eax
  802951:	01 c2                	add    %eax,%edx
  802953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802956:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802964:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802978:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297c:	75 17                	jne    802995 <free_block+0x300>
  80297e:	83 ec 04             	sub    $0x4,%esp
  802981:	68 5e 3c 80 00       	push   $0x803c5e
  802986:	68 59 01 00 00       	push   $0x159
  80298b:	68 c3 3b 80 00       	push   $0x803bc3
  802990:	e8 6c da ff ff       	call   800401 <_panic>
  802995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802998:	8b 40 08             	mov    0x8(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 11                	je     8029b0 <free_block+0x31b>
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 40 08             	mov    0x8(%eax),%eax
  8029a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8029ab:	89 50 0c             	mov    %edx,0xc(%eax)
  8029ae:	eb 0b                	jmp    8029bb <free_block+0x326>
  8029b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b6:	a3 44 41 90 00       	mov    %eax,0x904144
  8029bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029be:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 11                	je     8029d6 <free_block+0x341>
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ce:	8b 52 08             	mov    0x8(%edx),%edx
  8029d1:	89 50 08             	mov    %edx,0x8(%eax)
  8029d4:	eb 0b                	jmp    8029e1 <free_block+0x34c>
  8029d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d9:	8b 40 08             	mov    0x8(%eax),%eax
  8029dc:	a3 40 41 90 00       	mov    %eax,0x904140
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8029f5:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8029fa:	48                   	dec    %eax
  8029fb:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a04:	75 17                	jne    802a1d <free_block+0x388>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 5e 3c 80 00       	push   $0x803c5e
  802a0e:	68 5a 01 00 00       	push   $0x15a
  802a13:	68 c3 3b 80 00       	push   $0x803bc3
  802a18:	e8 e4 d9 ff ff       	call   800401 <_panic>
  802a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a20:	8b 40 08             	mov    0x8(%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 11                	je     802a38 <free_block+0x3a3>
  802a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a30:	8b 52 0c             	mov    0xc(%edx),%edx
  802a33:	89 50 0c             	mov    %edx,0xc(%eax)
  802a36:	eb 0b                	jmp    802a43 <free_block+0x3ae>
  802a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	a3 44 41 90 00       	mov    %eax,0x904144
  802a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 11                	je     802a5e <free_block+0x3c9>
  802a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a50:	8b 40 0c             	mov    0xc(%eax),%eax
  802a53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a56:	8b 52 08             	mov    0x8(%edx),%edx
  802a59:	89 50 08             	mov    %edx,0x8(%eax)
  802a5c:	eb 0b                	jmp    802a69 <free_block+0x3d4>
  802a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a61:	8b 40 08             	mov    0x8(%eax),%eax
  802a64:	a3 40 41 90 00       	mov    %eax,0x904140
  802a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a76:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a7d:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a82:	48                   	dec    %eax
  802a83:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802a8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802a96:	e9 ff 01 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802a9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a9f:	0f 84 db 00 00 00    	je     802b80 <free_block+0x4eb>
  802aa5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa9:	0f 84 d1 00 00 00    	je     802b80 <free_block+0x4eb>
  802aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab2:	8a 40 04             	mov    0x4(%eax),%al
  802ab5:	84 c0                	test   %al,%al
  802ab7:	0f 85 c3 00 00 00    	jne    802b80 <free_block+0x4eb>
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	8a 40 04             	mov    0x4(%eax),%al
  802ac3:	3c 01                	cmp    $0x1,%al
  802ac5:	0f 85 b5 00 00 00    	jne    802b80 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ace:	8b 10                	mov    (%eax),%edx
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	01 c2                	add    %eax,%edx
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af0:	75 17                	jne    802b09 <free_block+0x474>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 5e 3c 80 00       	push   $0x803c5e
  802afa:	68 64 01 00 00       	push   $0x164
  802aff:	68 c3 3b 80 00       	push   $0x803bc3
  802b04:	e8 f8 d8 ff ff       	call   800401 <_panic>
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 11                	je     802b24 <free_block+0x48f>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 40 08             	mov    0x8(%eax),%eax
  802b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1c:	8b 52 0c             	mov    0xc(%edx),%edx
  802b1f:	89 50 0c             	mov    %edx,0xc(%eax)
  802b22:	eb 0b                	jmp    802b2f <free_block+0x49a>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	a3 44 41 90 00       	mov    %eax,0x904144
  802b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b32:	8b 40 0c             	mov    0xc(%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 11                	je     802b4a <free_block+0x4b5>
  802b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b42:	8b 52 08             	mov    0x8(%edx),%edx
  802b45:	89 50 08             	mov    %edx,0x8(%eax)
  802b48:	eb 0b                	jmp    802b55 <free_block+0x4c0>
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 40 08             	mov    0x8(%eax),%eax
  802b50:	a3 40 41 90 00       	mov    %eax,0x904140
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b69:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802b6e:	48                   	dec    %eax
  802b6f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802b74:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802b7b:	e9 1a 01 00 00       	jmp    802c9a <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b84:	0f 84 df 00 00 00    	je     802c69 <free_block+0x5d4>
  802b8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b8e:	0f 84 d5 00 00 00    	je     802c69 <free_block+0x5d4>
  802b94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b97:	8a 40 04             	mov    0x4(%eax),%al
  802b9a:	3c 01                	cmp    $0x1,%al
  802b9c:	0f 85 c7 00 00 00    	jne    802c69 <free_block+0x5d4>
  802ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba5:	8a 40 04             	mov    0x4(%eax),%al
  802ba8:	84 c0                	test   %al,%al
  802baa:	0f 85 b9 00 00 00    	jne    802c69 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bba:	8b 10                	mov    (%eax),%edx
  802bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	01 c2                	add    %eax,%edx
  802bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc6:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802bd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bdc:	75 17                	jne    802bf5 <free_block+0x560>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 5e 3c 80 00       	push   $0x803c5e
  802be6:	68 6e 01 00 00       	push   $0x16e
  802beb:	68 c3 3b 80 00       	push   $0x803bc3
  802bf0:	e8 0c d8 ff ff       	call   800401 <_panic>
  802bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf8:	8b 40 08             	mov    0x8(%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 11                	je     802c10 <free_block+0x57b>
  802bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c08:	8b 52 0c             	mov    0xc(%edx),%edx
  802c0b:	89 50 0c             	mov    %edx,0xc(%eax)
  802c0e:	eb 0b                	jmp    802c1b <free_block+0x586>
  802c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c13:	8b 40 0c             	mov    0xc(%eax),%eax
  802c16:	a3 44 41 90 00       	mov    %eax,0x904144
  802c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 11                	je     802c36 <free_block+0x5a1>
  802c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2e:	8b 52 08             	mov    0x8(%edx),%edx
  802c31:	89 50 08             	mov    %edx,0x8(%eax)
  802c34:	eb 0b                	jmp    802c41 <free_block+0x5ac>
  802c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	a3 40 41 90 00       	mov    %eax,0x904140
  802c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c55:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c5a:	48                   	dec    %eax
  802c5b:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802c60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802c67:	eb 31                	jmp    802c9a <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802c69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c6d:	74 2b                	je     802c9a <free_block+0x605>
  802c6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c73:	74 25                	je     802c9a <free_block+0x605>
  802c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c78:	8a 40 04             	mov    0x4(%eax),%al
  802c7b:	84 c0                	test   %al,%al
  802c7d:	75 1b                	jne    802c9a <free_block+0x605>
  802c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c82:	8a 40 04             	mov    0x4(%eax),%al
  802c85:	84 c0                	test   %al,%al
  802c87:	75 11                	jne    802c9a <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802c90:	90                   	nop
  802c91:	eb 07                	jmp    802c9a <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802c93:	90                   	nop
  802c94:	eb 04                	jmp    802c9a <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802c96:	90                   	nop
  802c97:	eb 01                	jmp    802c9a <free_block+0x605>
	if (va == NULL)
		return;
  802c99:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802c9a:	c9                   	leave  
  802c9b:	c3                   	ret    

00802c9c <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802c9c:	55                   	push   %ebp
  802c9d:	89 e5                	mov    %esp,%ebp
  802c9f:	57                   	push   %edi
  802ca0:	56                   	push   %esi
  802ca1:	53                   	push   %ebx
  802ca2:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802ca5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca9:	75 19                	jne    802cc4 <realloc_block_FF+0x28>
  802cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802caf:	74 13                	je     802cc4 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  802cb1:	83 ec 0c             	sub    $0xc,%esp
  802cb4:	ff 75 0c             	pushl  0xc(%ebp)
  802cb7:	e8 0c f4 ff ff       	call   8020c8 <alloc_block_FF>
  802cbc:	83 c4 10             	add    $0x10,%esp
  802cbf:	e9 84 03 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  802cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc8:	75 3b                	jne    802d05 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cce:	75 17                	jne    802ce7 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  802cd0:	83 ec 0c             	sub    $0xc,%esp
  802cd3:	6a 00                	push   $0x0
  802cd5:	e8 ee f3 ff ff       	call   8020c8 <alloc_block_FF>
  802cda:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce2:	e9 61 03 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  802ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ceb:	74 18                	je     802d05 <realloc_block_FF+0x69>
		{
			free_block(va);
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	ff 75 08             	pushl  0x8(%ebp)
  802cf3:	e8 9d f9 ff ff       	call   802695 <free_block>
  802cf8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802d00:	e9 43 03 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  802d05:	a1 40 41 90 00       	mov    0x904140,%eax
  802d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d0d:	e9 02 03 00 00       	jmp    803014 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	83 e8 10             	sub    $0x10,%eax
  802d18:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d1b:	0f 85 eb 02 00 00    	jne    80300c <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d29:	83 c2 10             	add    $0x10,%edx
  802d2c:	39 d0                	cmp    %edx,%eax
  802d2e:	75 08                	jne    802d38 <realloc_block_FF+0x9c>
			{
				return va;
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	e9 10 03 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d40:	0f 83 e0 01 00 00    	jae    802f26 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  802d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d52:	8a 40 04             	mov    0x4(%eax),%al
  802d55:	3c 01                	cmp    $0x1,%al
  802d57:	0f 85 06 01 00 00    	jne    802e63 <realloc_block_FF+0x1c7>
  802d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d60:	8b 10                	mov    (%eax),%edx
  802d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d6a:	29 c1                	sub    %eax,%ecx
  802d6c:	89 c8                	mov    %ecx,%eax
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	0f 86 ed 00 00 00    	jbe    802e63 <realloc_block_FF+0x1c7>
  802d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d7a:	0f 84 e3 00 00 00    	je     802e63 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  802d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d83:	8b 10                	mov    (%eax),%edx
  802d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	2b 45 0c             	sub    0xc(%ebp),%eax
  802d8d:	01 d0                	add    %edx,%eax
  802d8f:	83 f8 0f             	cmp    $0xf,%eax
  802d92:	0f 86 b5 00 00 00    	jbe    802e4d <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  802d98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9e:	01 d0                	add    %edx,%eax
  802da0:	83 c0 10             	add    $0x10,%eax
  802da3:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  802da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  802daf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802db6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dba:	74 06                	je     802dc2 <realloc_block_FF+0x126>
  802dbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dc0:	75 17                	jne    802dd9 <realloc_block_FF+0x13d>
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	68 dc 3b 80 00       	push   $0x803bdc
  802dca:	68 ad 01 00 00       	push   $0x1ad
  802dcf:	68 c3 3b 80 00       	push   $0x803bc3
  802dd4:	e8 28 d6 ff ff       	call   800401 <_panic>
  802dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de2:	89 50 08             	mov    %edx,0x8(%eax)
  802de5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de8:	8b 40 08             	mov    0x8(%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0c                	je     802dfb <realloc_block_FF+0x15f>
  802def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df2:	8b 40 08             	mov    0x8(%eax),%eax
  802df5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802df8:	89 50 0c             	mov    %edx,0xc(%eax)
  802dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e01:	89 50 08             	mov    %edx,0x8(%eax)
  802e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e0a:	89 50 0c             	mov    %edx,0xc(%eax)
  802e0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	75 08                	jne    802e1f <realloc_block_FF+0x183>
  802e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1a:	a3 44 41 90 00       	mov    %eax,0x904144
  802e1f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802e24:	40                   	inc    %eax
  802e25:	a3 4c 41 90 00       	mov    %eax,0x90414c
						next->size = 0;
  802e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  802e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e36:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	8d 50 10             	lea    0x10(%eax),%edx
  802e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e43:	89 10                	mov    %edx,(%eax)
						return va;
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	e9 fb 01 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  802e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e50:	8d 50 10             	lea    0x10(%eax),%edx
  802e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e56:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	83 c0 10             	add    $0x10,%eax
  802e5e:	e9 e5 01 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e66:	8a 40 04             	mov    0x4(%eax),%al
  802e69:	3c 01                	cmp    $0x1,%al
  802e6b:	75 59                	jne    802ec6 <realloc_block_FF+0x22a>
  802e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e70:	8b 10                	mov    (%eax),%edx
  802e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e7a:	29 c1                	sub    %eax,%ecx
  802e7c:	89 c8                	mov    %ecx,%eax
  802e7e:	39 c2                	cmp    %eax,%edx
  802e80:	75 44                	jne    802ec6 <realloc_block_FF+0x22a>
  802e82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e86:	74 3e                	je     802ec6 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e94:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e97:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802e9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea0:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eaf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb6:	8d 50 10             	lea    0x10(%eax),%edx
  802eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebc:	89 10                	mov    %edx,(%eax)
					return va;
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	e9 82 01 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec9:	8a 40 04             	mov    0x4(%eax),%al
  802ecc:	84 c0                	test   %al,%al
  802ece:	74 0a                	je     802eda <realloc_block_FF+0x23e>
  802ed0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ed4:	0f 85 32 01 00 00    	jne    80300c <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802eda:	83 ec 0c             	sub    $0xc,%esp
  802edd:	ff 75 0c             	pushl  0xc(%ebp)
  802ee0:	e8 e3 f1 ff ff       	call   8020c8 <alloc_block_FF>
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  802eeb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802eef:	74 2b                	je     802f1c <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  802ef1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	89 c3                	mov    %eax,%ebx
  802ef9:	b8 04 00 00 00       	mov    $0x4,%eax
  802efe:	89 d7                	mov    %edx,%edi
  802f00:	89 de                	mov    %ebx,%esi
  802f02:	89 c1                	mov    %eax,%ecx
  802f04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	ff 75 08             	pushl  0x8(%ebp)
  802f0c:	e8 84 f7 ff ff       	call   802695 <free_block>
  802f11:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802f14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f17:	e9 2c 01 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  802f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802f21:	e9 22 01 00 00       	jmp    803048 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f2e:	0f 86 d8 00 00 00    	jbe    80300c <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f3c:	83 f8 0f             	cmp    $0xf,%eax
  802f3f:	0f 86 b4 00 00 00    	jbe    802ff9 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802f45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4b:	01 d0                	add    %edx,%eax
  802f4d:	83 c0 10             	add    $0x10,%eax
  802f50:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f5b:	8d 50 f0             	lea    -0x10(%eax),%edx
  802f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f61:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802f63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f67:	74 06                	je     802f6f <realloc_block_FF+0x2d3>
  802f69:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f6d:	75 17                	jne    802f86 <realloc_block_FF+0x2ea>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 dc 3b 80 00       	push   $0x803bdc
  802f77:	68 dd 01 00 00       	push   $0x1dd
  802f7c:	68 c3 3b 80 00       	push   $0x803bc3
  802f81:	e8 7b d4 ff ff       	call   800401 <_panic>
  802f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f89:	8b 50 08             	mov    0x8(%eax),%edx
  802f8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f8f:	89 50 08             	mov    %edx,0x8(%eax)
  802f92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f95:	8b 40 08             	mov    0x8(%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0c                	je     802fa8 <realloc_block_FF+0x30c>
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	8b 40 08             	mov    0x8(%eax),%eax
  802fa2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802fa5:	89 50 0c             	mov    %edx,0xc(%eax)
  802fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802fae:	89 50 08             	mov    %edx,0x8(%eax)
  802fb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb7:	89 50 0c             	mov    %edx,0xc(%eax)
  802fba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	75 08                	jne    802fcc <realloc_block_FF+0x330>
  802fc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fc7:	a3 44 41 90 00       	mov    %eax,0x904144
  802fcc:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  802fd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fda:	83 c0 10             	add    $0x10,%eax
  802fdd:	83 ec 0c             	sub    $0xc,%esp
  802fe0:	50                   	push   %eax
  802fe1:	e8 af f6 ff ff       	call   802695 <free_block>
  802fe6:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  802fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fec:	8d 50 10             	lea    0x10(%eax),%edx
  802fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff2:	89 10                	mov    %edx,(%eax)
					return va;
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	eb 4f                	jmp    803048 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  802ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffc:	8d 50 10             	lea    0x10(%eax),%edx
  802fff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803002:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	83 c0 10             	add    $0x10,%eax
  80300a:	eb 3c                	jmp    803048 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  80300c:	a1 48 41 90 00       	mov    0x904148,%eax
  803011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803014:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803018:	74 08                	je     803022 <realloc_block_FF+0x386>
  80301a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301d:	8b 40 08             	mov    0x8(%eax),%eax
  803020:	eb 05                	jmp    803027 <realloc_block_FF+0x38b>
  803022:	b8 00 00 00 00       	mov    $0x0,%eax
  803027:	a3 48 41 90 00       	mov    %eax,0x904148
  80302c:	a1 48 41 90 00       	mov    0x904148,%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	0f 85 d9 fc ff ff    	jne    802d12 <realloc_block_FF+0x76>
  803039:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80303d:	0f 85 cf fc ff ff    	jne    802d12 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80304b:	5b                   	pop    %ebx
  80304c:	5e                   	pop    %esi
  80304d:	5f                   	pop    %edi
  80304e:	5d                   	pop    %ebp
  80304f:	c3                   	ret    

00803050 <__udivdi3>:
  803050:	55                   	push   %ebp
  803051:	57                   	push   %edi
  803052:	56                   	push   %esi
  803053:	53                   	push   %ebx
  803054:	83 ec 1c             	sub    $0x1c,%esp
  803057:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80305b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80305f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803063:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803067:	89 ca                	mov    %ecx,%edx
  803069:	89 f8                	mov    %edi,%eax
  80306b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80306f:	85 f6                	test   %esi,%esi
  803071:	75 2d                	jne    8030a0 <__udivdi3+0x50>
  803073:	39 cf                	cmp    %ecx,%edi
  803075:	77 65                	ja     8030dc <__udivdi3+0x8c>
  803077:	89 fd                	mov    %edi,%ebp
  803079:	85 ff                	test   %edi,%edi
  80307b:	75 0b                	jne    803088 <__udivdi3+0x38>
  80307d:	b8 01 00 00 00       	mov    $0x1,%eax
  803082:	31 d2                	xor    %edx,%edx
  803084:	f7 f7                	div    %edi
  803086:	89 c5                	mov    %eax,%ebp
  803088:	31 d2                	xor    %edx,%edx
  80308a:	89 c8                	mov    %ecx,%eax
  80308c:	f7 f5                	div    %ebp
  80308e:	89 c1                	mov    %eax,%ecx
  803090:	89 d8                	mov    %ebx,%eax
  803092:	f7 f5                	div    %ebp
  803094:	89 cf                	mov    %ecx,%edi
  803096:	89 fa                	mov    %edi,%edx
  803098:	83 c4 1c             	add    $0x1c,%esp
  80309b:	5b                   	pop    %ebx
  80309c:	5e                   	pop    %esi
  80309d:	5f                   	pop    %edi
  80309e:	5d                   	pop    %ebp
  80309f:	c3                   	ret    
  8030a0:	39 ce                	cmp    %ecx,%esi
  8030a2:	77 28                	ja     8030cc <__udivdi3+0x7c>
  8030a4:	0f bd fe             	bsr    %esi,%edi
  8030a7:	83 f7 1f             	xor    $0x1f,%edi
  8030aa:	75 40                	jne    8030ec <__udivdi3+0x9c>
  8030ac:	39 ce                	cmp    %ecx,%esi
  8030ae:	72 0a                	jb     8030ba <__udivdi3+0x6a>
  8030b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b4:	0f 87 9e 00 00 00    	ja     803158 <__udivdi3+0x108>
  8030ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bf:	89 fa                	mov    %edi,%edx
  8030c1:	83 c4 1c             	add    $0x1c,%esp
  8030c4:	5b                   	pop    %ebx
  8030c5:	5e                   	pop    %esi
  8030c6:	5f                   	pop    %edi
  8030c7:	5d                   	pop    %ebp
  8030c8:	c3                   	ret    
  8030c9:	8d 76 00             	lea    0x0(%esi),%esi
  8030cc:	31 ff                	xor    %edi,%edi
  8030ce:	31 c0                	xor    %eax,%eax
  8030d0:	89 fa                	mov    %edi,%edx
  8030d2:	83 c4 1c             	add    $0x1c,%esp
  8030d5:	5b                   	pop    %ebx
  8030d6:	5e                   	pop    %esi
  8030d7:	5f                   	pop    %edi
  8030d8:	5d                   	pop    %ebp
  8030d9:	c3                   	ret    
  8030da:	66 90                	xchg   %ax,%ax
  8030dc:	89 d8                	mov    %ebx,%eax
  8030de:	f7 f7                	div    %edi
  8030e0:	31 ff                	xor    %edi,%edi
  8030e2:	89 fa                	mov    %edi,%edx
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    
  8030ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030f1:	89 eb                	mov    %ebp,%ebx
  8030f3:	29 fb                	sub    %edi,%ebx
  8030f5:	89 f9                	mov    %edi,%ecx
  8030f7:	d3 e6                	shl    %cl,%esi
  8030f9:	89 c5                	mov    %eax,%ebp
  8030fb:	88 d9                	mov    %bl,%cl
  8030fd:	d3 ed                	shr    %cl,%ebp
  8030ff:	89 e9                	mov    %ebp,%ecx
  803101:	09 f1                	or     %esi,%ecx
  803103:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803107:	89 f9                	mov    %edi,%ecx
  803109:	d3 e0                	shl    %cl,%eax
  80310b:	89 c5                	mov    %eax,%ebp
  80310d:	89 d6                	mov    %edx,%esi
  80310f:	88 d9                	mov    %bl,%cl
  803111:	d3 ee                	shr    %cl,%esi
  803113:	89 f9                	mov    %edi,%ecx
  803115:	d3 e2                	shl    %cl,%edx
  803117:	8b 44 24 08          	mov    0x8(%esp),%eax
  80311b:	88 d9                	mov    %bl,%cl
  80311d:	d3 e8                	shr    %cl,%eax
  80311f:	09 c2                	or     %eax,%edx
  803121:	89 d0                	mov    %edx,%eax
  803123:	89 f2                	mov    %esi,%edx
  803125:	f7 74 24 0c          	divl   0xc(%esp)
  803129:	89 d6                	mov    %edx,%esi
  80312b:	89 c3                	mov    %eax,%ebx
  80312d:	f7 e5                	mul    %ebp
  80312f:	39 d6                	cmp    %edx,%esi
  803131:	72 19                	jb     80314c <__udivdi3+0xfc>
  803133:	74 0b                	je     803140 <__udivdi3+0xf0>
  803135:	89 d8                	mov    %ebx,%eax
  803137:	31 ff                	xor    %edi,%edi
  803139:	e9 58 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  80313e:	66 90                	xchg   %ax,%ax
  803140:	8b 54 24 08          	mov    0x8(%esp),%edx
  803144:	89 f9                	mov    %edi,%ecx
  803146:	d3 e2                	shl    %cl,%edx
  803148:	39 c2                	cmp    %eax,%edx
  80314a:	73 e9                	jae    803135 <__udivdi3+0xe5>
  80314c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80314f:	31 ff                	xor    %edi,%edi
  803151:	e9 40 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  803156:	66 90                	xchg   %ax,%ax
  803158:	31 c0                	xor    %eax,%eax
  80315a:	e9 37 ff ff ff       	jmp    803096 <__udivdi3+0x46>
  80315f:	90                   	nop

00803160 <__umoddi3>:
  803160:	55                   	push   %ebp
  803161:	57                   	push   %edi
  803162:	56                   	push   %esi
  803163:	53                   	push   %ebx
  803164:	83 ec 1c             	sub    $0x1c,%esp
  803167:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80316b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80316f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803173:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803177:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80317b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80317f:	89 f3                	mov    %esi,%ebx
  803181:	89 fa                	mov    %edi,%edx
  803183:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803187:	89 34 24             	mov    %esi,(%esp)
  80318a:	85 c0                	test   %eax,%eax
  80318c:	75 1a                	jne    8031a8 <__umoddi3+0x48>
  80318e:	39 f7                	cmp    %esi,%edi
  803190:	0f 86 a2 00 00 00    	jbe    803238 <__umoddi3+0xd8>
  803196:	89 c8                	mov    %ecx,%eax
  803198:	89 f2                	mov    %esi,%edx
  80319a:	f7 f7                	div    %edi
  80319c:	89 d0                	mov    %edx,%eax
  80319e:	31 d2                	xor    %edx,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	39 f0                	cmp    %esi,%eax
  8031aa:	0f 87 ac 00 00 00    	ja     80325c <__umoddi3+0xfc>
  8031b0:	0f bd e8             	bsr    %eax,%ebp
  8031b3:	83 f5 1f             	xor    $0x1f,%ebp
  8031b6:	0f 84 ac 00 00 00    	je     803268 <__umoddi3+0x108>
  8031bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8031c1:	29 ef                	sub    %ebp,%edi
  8031c3:	89 fe                	mov    %edi,%esi
  8031c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c9:	89 e9                	mov    %ebp,%ecx
  8031cb:	d3 e0                	shl    %cl,%eax
  8031cd:	89 d7                	mov    %edx,%edi
  8031cf:	89 f1                	mov    %esi,%ecx
  8031d1:	d3 ef                	shr    %cl,%edi
  8031d3:	09 c7                	or     %eax,%edi
  8031d5:	89 e9                	mov    %ebp,%ecx
  8031d7:	d3 e2                	shl    %cl,%edx
  8031d9:	89 14 24             	mov    %edx,(%esp)
  8031dc:	89 d8                	mov    %ebx,%eax
  8031de:	d3 e0                	shl    %cl,%eax
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e6:	d3 e0                	shl    %cl,%eax
  8031e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f0:	89 f1                	mov    %esi,%ecx
  8031f2:	d3 e8                	shr    %cl,%eax
  8031f4:	09 d0                	or     %edx,%eax
  8031f6:	d3 eb                	shr    %cl,%ebx
  8031f8:	89 da                	mov    %ebx,%edx
  8031fa:	f7 f7                	div    %edi
  8031fc:	89 d3                	mov    %edx,%ebx
  8031fe:	f7 24 24             	mull   (%esp)
  803201:	89 c6                	mov    %eax,%esi
  803203:	89 d1                	mov    %edx,%ecx
  803205:	39 d3                	cmp    %edx,%ebx
  803207:	0f 82 87 00 00 00    	jb     803294 <__umoddi3+0x134>
  80320d:	0f 84 91 00 00 00    	je     8032a4 <__umoddi3+0x144>
  803213:	8b 54 24 04          	mov    0x4(%esp),%edx
  803217:	29 f2                	sub    %esi,%edx
  803219:	19 cb                	sbb    %ecx,%ebx
  80321b:	89 d8                	mov    %ebx,%eax
  80321d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803221:	d3 e0                	shl    %cl,%eax
  803223:	89 e9                	mov    %ebp,%ecx
  803225:	d3 ea                	shr    %cl,%edx
  803227:	09 d0                	or     %edx,%eax
  803229:	89 e9                	mov    %ebp,%ecx
  80322b:	d3 eb                	shr    %cl,%ebx
  80322d:	89 da                	mov    %ebx,%edx
  80322f:	83 c4 1c             	add    $0x1c,%esp
  803232:	5b                   	pop    %ebx
  803233:	5e                   	pop    %esi
  803234:	5f                   	pop    %edi
  803235:	5d                   	pop    %ebp
  803236:	c3                   	ret    
  803237:	90                   	nop
  803238:	89 fd                	mov    %edi,%ebp
  80323a:	85 ff                	test   %edi,%edi
  80323c:	75 0b                	jne    803249 <__umoddi3+0xe9>
  80323e:	b8 01 00 00 00       	mov    $0x1,%eax
  803243:	31 d2                	xor    %edx,%edx
  803245:	f7 f7                	div    %edi
  803247:	89 c5                	mov    %eax,%ebp
  803249:	89 f0                	mov    %esi,%eax
  80324b:	31 d2                	xor    %edx,%edx
  80324d:	f7 f5                	div    %ebp
  80324f:	89 c8                	mov    %ecx,%eax
  803251:	f7 f5                	div    %ebp
  803253:	89 d0                	mov    %edx,%eax
  803255:	e9 44 ff ff ff       	jmp    80319e <__umoddi3+0x3e>
  80325a:	66 90                	xchg   %ax,%ax
  80325c:	89 c8                	mov    %ecx,%eax
  80325e:	89 f2                	mov    %esi,%edx
  803260:	83 c4 1c             	add    $0x1c,%esp
  803263:	5b                   	pop    %ebx
  803264:	5e                   	pop    %esi
  803265:	5f                   	pop    %edi
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	3b 04 24             	cmp    (%esp),%eax
  80326b:	72 06                	jb     803273 <__umoddi3+0x113>
  80326d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803271:	77 0f                	ja     803282 <__umoddi3+0x122>
  803273:	89 f2                	mov    %esi,%edx
  803275:	29 f9                	sub    %edi,%ecx
  803277:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80327b:	89 14 24             	mov    %edx,(%esp)
  80327e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803282:	8b 44 24 04          	mov    0x4(%esp),%eax
  803286:	8b 14 24             	mov    (%esp),%edx
  803289:	83 c4 1c             	add    $0x1c,%esp
  80328c:	5b                   	pop    %ebx
  80328d:	5e                   	pop    %esi
  80328e:	5f                   	pop    %edi
  80328f:	5d                   	pop    %ebp
  803290:	c3                   	ret    
  803291:	8d 76 00             	lea    0x0(%esi),%esi
  803294:	2b 04 24             	sub    (%esp),%eax
  803297:	19 fa                	sbb    %edi,%edx
  803299:	89 d1                	mov    %edx,%ecx
  80329b:	89 c6                	mov    %eax,%esi
  80329d:	e9 71 ff ff ff       	jmp    803213 <__umoddi3+0xb3>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a8:	72 ea                	jb     803294 <__umoddi3+0x134>
  8032aa:	89 d9                	mov    %ebx,%ecx
  8032ac:	e9 62 ff ff ff       	jmp    803213 <__umoddi3+0xb3>
