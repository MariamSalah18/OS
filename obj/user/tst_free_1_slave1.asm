
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 a7 02 00 00       	call   8002dd <libmain>
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
  800060:	68 40 33 80 00       	push   $0x803340
  800065:	6a 14                	push   $0x14
  800067:	68 5c 33 80 00       	push   $0x80335c
  80006c:	e8 9a 03 00 00       	call   80040b <_panic>
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
  8000bc:	e8 4f 18 00 00       	call   801910 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 92 18 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 14 14 00 00       	call   8014f1 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 78 33 80 00       	push   $0x803378
  8000f9:	6a 33                	push   $0x33
  8000fb:	68 5c 33 80 00       	push   $0x80335c
  800100:	e8 06 03 00 00       	call   80040b <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 51 18 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 33 80 00       	push   $0x8033a8
  800117:	6a 34                	push   $0x34
  800119:	68 5c 33 80 00       	push   $0x80335c
  80011e:	e8 e8 02 00 00       	call   80040b <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 e8 17 00 00       	call   801910 <sys_calculate_free_frames>
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
  80015f:	e8 ac 17 00 00       	call   801910 <sys_calculate_free_frames>
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
  80017c:	68 d8 33 80 00       	push   $0x8033d8
  800181:	6a 3e                	push   $0x3e
  800183:	68 5c 33 80 00       	push   $0x80335c
  800188:	e8 7e 02 00 00       	call   80040b <_panic>

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
  8001c7:	e8 61 1c 00 00       	call   801e2d <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 34 80 00       	push   $0x803454
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 5c 33 80 00       	push   $0x80335c
  8001e7:	e8 1f 02 00 00       	call   80040b <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 1f 17 00 00       	call   801910 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 62 17 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 42 14 00 00       	call   80164d <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 48 17 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 34 80 00       	push   $0x803474
  800220:	6a 4f                	push   $0x4f
  800222:	68 5c 33 80 00       	push   $0x80335c
  800227:	e8 df 01 00 00       	call   80040b <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 df 16 00 00       	call   801910 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 34 80 00       	push   $0x8034b0
  800247:	6a 50                	push   $0x50
  800249:	68 5c 33 80 00       	push   $0x80335c
  80024e:	e8 b8 01 00 00       	call   80040b <_panic>
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
  80028d:	e8 9b 1b 00 00       	call   801e2d <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 34 80 00       	push   $0x8034fc
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 5c 33 80 00       	push   $0x80335c
  8002ad:	e8 59 01 00 00       	call   80040b <_panic>
		}
	}

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b5:	c1 e0 03             	shl    $0x3,%eax
  8002b8:	89 c2                	mov    %eax,%edx
  8002ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002bd:	01 c2                	add    %eax,%edx
  8002bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002c2:	88 02                	mov    %al,(%edx)
		inctst();
  8002c4:	e8 10 1a 00 00       	call   801cd9 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	68 20 35 80 00       	push   $0x803520
  8002d1:	6a 5b                	push   $0x5b
  8002d3:	68 5c 33 80 00       	push   $0x80335c
  8002d8:	e8 2e 01 00 00       	call   80040b <_panic>

008002dd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002e3:	e8 b3 18 00 00       	call   801b9b <sys_getenvindex>
  8002e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ee:	89 d0                	mov    %edx,%eax
  8002f0:	01 c0                	add    %eax,%eax
  8002f2:	01 d0                	add    %edx,%eax
  8002f4:	c1 e0 06             	shl    $0x6,%eax
  8002f7:	29 d0                	sub    %edx,%eax
  8002f9:	c1 e0 03             	shl    $0x3,%eax
  8002fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800301:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8a 40 68             	mov    0x68(%eax),%al
  80030e:	84 c0                	test   %al,%al
  800310:	74 0d                	je     80031f <libmain+0x42>
		binaryname = myEnv->prog_name;
  800312:	a1 20 40 80 00       	mov    0x804020,%eax
  800317:	83 c0 68             	add    $0x68,%eax
  80031a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800323:	7e 0a                	jle    80032f <libmain+0x52>
		binaryname = argv[0];
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8b 00                	mov    (%eax),%eax
  80032a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	e8 fb fc ff ff       	call   800038 <_main>
  80033d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800340:	e8 63 16 00 00       	call   8019a8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 84 35 80 00       	push   $0x803584
  80034d:	e8 76 03 00 00       	call   8006c8 <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800355:	a1 20 40 80 00       	mov    0x804020,%eax
  80035a:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800360:	a1 20 40 80 00       	mov    0x804020,%eax
  800365:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	68 ac 35 80 00       	push   $0x8035ac
  800375:	e8 4e 03 00 00       	call   8006c8 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800393:	a1 20 40 80 00       	mov    0x804020,%eax
  800398:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80039e:	51                   	push   %ecx
  80039f:	52                   	push   %edx
  8003a0:	50                   	push   %eax
  8003a1:	68 d4 35 80 00       	push   $0x8035d4
  8003a6:	e8 1d 03 00 00       	call   8006c8 <cprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b3:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	50                   	push   %eax
  8003bd:	68 2c 36 80 00       	push   $0x80362c
  8003c2:	e8 01 03 00 00       	call   8006c8 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	68 84 35 80 00       	push   $0x803584
  8003d2:	e8 f1 02 00 00       	call   8006c8 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003da:	e8 e3 15 00 00       	call   8019c2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003df:	e8 19 00 00 00       	call   8003fd <exit>
}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	6a 00                	push   $0x0
  8003f2:	e8 70 17 00 00       	call   801b67 <sys_destroy_env>
  8003f7:	83 c4 10             	add    $0x10,%esp
}
  8003fa:	90                   	nop
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <exit>:

void
exit(void)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800403:	e8 c5 17 00 00       	call   801bcd <sys_exit_env>
}
  800408:	90                   	nop
  800409:	c9                   	leave  
  80040a:	c3                   	ret    

0080040b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800411:	8d 45 10             	lea    0x10(%ebp),%eax
  800414:	83 c0 04             	add    $0x4,%eax
  800417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80041a:	a1 18 41 80 00       	mov    0x804118,%eax
  80041f:	85 c0                	test   %eax,%eax
  800421:	74 16                	je     800439 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800423:	a1 18 41 80 00       	mov    0x804118,%eax
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	50                   	push   %eax
  80042c:	68 40 36 80 00       	push   $0x803640
  800431:	e8 92 02 00 00       	call   8006c8 <cprintf>
  800436:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800439:	a1 00 40 80 00       	mov    0x804000,%eax
  80043e:	ff 75 0c             	pushl  0xc(%ebp)
  800441:	ff 75 08             	pushl  0x8(%ebp)
  800444:	50                   	push   %eax
  800445:	68 45 36 80 00       	push   $0x803645
  80044a:	e8 79 02 00 00       	call   8006c8 <cprintf>
  80044f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800452:	8b 45 10             	mov    0x10(%ebp),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 f4             	pushl  -0xc(%ebp)
  80045b:	50                   	push   %eax
  80045c:	e8 fc 01 00 00       	call   80065d <vcprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	6a 00                	push   $0x0
  800469:	68 61 36 80 00       	push   $0x803661
  80046e:	e8 ea 01 00 00       	call   80065d <vcprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800476:	e8 82 ff ff ff       	call   8003fd <exit>

	// should not return here
	while (1) ;
  80047b:	eb fe                	jmp    80047b <_panic+0x70>

0080047d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80048e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800491:	39 c2                	cmp    %eax,%edx
  800493:	74 14                	je     8004a9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	68 64 36 80 00       	push   $0x803664
  80049d:	6a 26                	push   $0x26
  80049f:	68 b0 36 80 00       	push   $0x8036b0
  8004a4:	e8 62 ff ff ff       	call   80040b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b7:	e9 c5 00 00 00       	jmp    800581 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	01 d0                	add    %edx,%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	75 08                	jne    8004d9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004d1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004d4:	e9 a5 00 00 00       	jmp    80057e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e7:	eb 69                	jmp    800552 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ee:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f7:	89 d0                	mov    %edx,%eax
  8004f9:	01 c0                	add    %eax,%eax
  8004fb:	01 d0                	add    %edx,%eax
  8004fd:	c1 e0 03             	shl    $0x3,%eax
  800500:	01 c8                	add    %ecx,%eax
  800502:	8a 40 04             	mov    0x4(%eax),%al
  800505:	84 c0                	test   %al,%al
  800507:	75 46                	jne    80054f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800509:	a1 20 40 80 00       	mov    0x804020,%eax
  80050e:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800514:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800517:	89 d0                	mov    %edx,%eax
  800519:	01 c0                	add    %eax,%eax
  80051b:	01 d0                	add    %edx,%eax
  80051d:	c1 e0 03             	shl    $0x3,%eax
  800520:	01 c8                	add    %ecx,%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800527:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80052a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80052f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800542:	39 c2                	cmp    %eax,%edx
  800544:	75 09                	jne    80054f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800546:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80054d:	eb 15                	jmp    800564 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80055d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800560:	39 c2                	cmp    %eax,%edx
  800562:	77 85                	ja     8004e9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800564:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800568:	75 14                	jne    80057e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	68 bc 36 80 00       	push   $0x8036bc
  800572:	6a 3a                	push   $0x3a
  800574:	68 b0 36 80 00       	push   $0x8036b0
  800579:	e8 8d fe ff ff       	call   80040b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80057e:	ff 45 f0             	incl   -0x10(%ebp)
  800581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800584:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800587:	0f 8c 2f ff ff ff    	jl     8004bc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80058d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800594:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80059b:	eb 26                	jmp    8005c3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80059d:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a2:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8005a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ab:	89 d0                	mov    %edx,%eax
  8005ad:	01 c0                	add    %eax,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	c1 e0 03             	shl    $0x3,%eax
  8005b4:	01 c8                	add    %ecx,%eax
  8005b6:	8a 40 04             	mov    0x4(%eax),%al
  8005b9:	3c 01                	cmp    $0x1,%al
  8005bb:	75 03                	jne    8005c0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005bd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c0:	ff 45 e0             	incl   -0x20(%ebp)
  8005c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c8:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8005ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d1:	39 c2                	cmp    %eax,%edx
  8005d3:	77 c8                	ja     80059d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005db:	74 14                	je     8005f1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005dd:	83 ec 04             	sub    $0x4,%esp
  8005e0:	68 10 37 80 00       	push   $0x803710
  8005e5:	6a 44                	push   $0x44
  8005e7:	68 b0 36 80 00       	push   $0x8036b0
  8005ec:	e8 1a fe ff ff       	call   80040b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005f1:	90                   	nop
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800602:	8b 55 0c             	mov    0xc(%ebp),%edx
  800605:	89 0a                	mov    %ecx,(%edx)
  800607:	8b 55 08             	mov    0x8(%ebp),%edx
  80060a:	88 d1                	mov    %dl,%cl
  80060c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800613:	8b 45 0c             	mov    0xc(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	3d ff 00 00 00       	cmp    $0xff,%eax
  80061d:	75 2c                	jne    80064b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80061f:	a0 24 40 80 00       	mov    0x804024,%al
  800624:	0f b6 c0             	movzbl %al,%eax
  800627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062a:	8b 12                	mov    (%edx),%edx
  80062c:	89 d1                	mov    %edx,%ecx
  80062e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800631:	83 c2 08             	add    $0x8,%edx
  800634:	83 ec 04             	sub    $0x4,%esp
  800637:	50                   	push   %eax
  800638:	51                   	push   %ecx
  800639:	52                   	push   %edx
  80063a:	e8 10 12 00 00       	call   80184f <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	8b 40 04             	mov    0x4(%eax),%eax
  800651:	8d 50 01             	lea    0x1(%eax),%edx
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	89 50 04             	mov    %edx,0x4(%eax)
}
  80065a:	90                   	nop
  80065b:	c9                   	leave  
  80065c:	c3                   	ret    

0080065d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
  800660:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800666:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80066d:	00 00 00 
	b.cnt = 0;
  800670:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800677:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800686:	50                   	push   %eax
  800687:	68 f4 05 80 00       	push   $0x8005f4
  80068c:	e8 11 02 00 00       	call   8008a2 <vprintfmt>
  800691:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	50                   	push   %eax
  8006a6:	52                   	push   %edx
  8006a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ad:	83 c0 08             	add    $0x8,%eax
  8006b0:	50                   	push   %eax
  8006b1:	e8 99 11 00 00       	call   80184f <sys_cputs>
  8006b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b9:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ce:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	e8 73 ff ff ff       	call   80065d <vcprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006fb:	e8 a8 12 00 00       	call   8019a8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800700:	8d 45 0c             	lea    0xc(%ebp),%eax
  800703:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 f4             	pushl  -0xc(%ebp)
  80070f:	50                   	push   %eax
  800710:	e8 48 ff ff ff       	call   80065d <vcprintf>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80071b:	e8 a2 12 00 00       	call   8019c2 <sys_enable_interrupt>
	return cnt;
  800720:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	53                   	push   %ebx
  800729:	83 ec 14             	sub    $0x14,%esp
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800738:	8b 45 18             	mov    0x18(%ebp),%eax
  80073b:	ba 00 00 00 00       	mov    $0x0,%edx
  800740:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800743:	77 55                	ja     80079a <printnum+0x75>
  800745:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800748:	72 05                	jb     80074f <printnum+0x2a>
  80074a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80074d:	77 4b                	ja     80079a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800752:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800755:	8b 45 18             	mov    0x18(%ebp),%eax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	52                   	push   %edx
  80075e:	50                   	push   %eax
  80075f:	ff 75 f4             	pushl  -0xc(%ebp)
  800762:	ff 75 f0             	pushl  -0x10(%ebp)
  800765:	e8 6a 29 00 00       	call   8030d4 <__udivdi3>
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	ff 75 20             	pushl  0x20(%ebp)
  800773:	53                   	push   %ebx
  800774:	ff 75 18             	pushl  0x18(%ebp)
  800777:	52                   	push   %edx
  800778:	50                   	push   %eax
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	e8 a1 ff ff ff       	call   800725 <printnum>
  800784:	83 c4 20             	add    $0x20,%esp
  800787:	eb 1a                	jmp    8007a3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 20             	pushl  0x20(%ebp)
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	ff d0                	call   *%eax
  800797:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079a:	ff 4d 1c             	decl   0x1c(%ebp)
  80079d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007a1:	7f e6                	jg     800789 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b1:	53                   	push   %ebx
  8007b2:	51                   	push   %ecx
  8007b3:	52                   	push   %edx
  8007b4:	50                   	push   %eax
  8007b5:	e8 2a 2a 00 00       	call   8031e4 <__umoddi3>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	05 74 39 80 00       	add    $0x803974,%eax
  8007c2:	8a 00                	mov    (%eax),%al
  8007c4:	0f be c0             	movsbl %al,%eax
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 0c             	pushl  0xc(%ebp)
  8007cd:	50                   	push   %eax
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
}
  8007d6:	90                   	nop
  8007d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    

008007dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007e3:	7e 1c                	jle    800801 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 08             	lea    0x8(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 08             	sub    $0x8,%eax
  8007fa:	8b 50 04             	mov    0x4(%eax),%edx
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	eb 40                	jmp    800841 <getuint+0x65>
	else if (lflag)
  800801:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800805:	74 1e                	je     800825 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 04             	lea    0x4(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	ba 00 00 00 00       	mov    $0x0,%edx
  800823:	eb 1c                	jmp    800841 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	8d 50 04             	lea    0x4(%eax),%edx
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	89 10                	mov    %edx,(%eax)
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	83 e8 04             	sub    $0x4,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800846:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80084a:	7e 1c                	jle    800868 <getint+0x25>
		return va_arg(*ap, long long);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 08             	lea    0x8(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 08             	sub    $0x8,%eax
  800861:	8b 50 04             	mov    0x4(%eax),%edx
  800864:	8b 00                	mov    (%eax),%eax
  800866:	eb 38                	jmp    8008a0 <getint+0x5d>
	else if (lflag)
  800868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80086c:	74 1a                	je     800888 <getint+0x45>
		return va_arg(*ap, long);
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	8d 50 04             	lea    0x4(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	89 10                	mov    %edx,(%eax)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	83 e8 04             	sub    $0x4,%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	99                   	cltd   
  800886:	eb 18                	jmp    8008a0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	8d 50 04             	lea    0x4(%eax),%edx
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 10                	mov    %edx,(%eax)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	99                   	cltd   
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	56                   	push   %esi
  8008a6:	53                   	push   %ebx
  8008a7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008aa:	eb 17                	jmp    8008c3 <vprintfmt+0x21>
			if (ch == '\0')
  8008ac:	85 db                	test   %ebx,%ebx
  8008ae:	0f 84 af 03 00 00    	je     800c63 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c6:	8d 50 01             	lea    0x1(%eax),%edx
  8008c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f b6 d8             	movzbl %al,%ebx
  8008d1:	83 fb 25             	cmp    $0x25,%ebx
  8008d4:	75 d6                	jne    8008ac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f9:	8d 50 01             	lea    0x1(%eax),%edx
  8008fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ff:	8a 00                	mov    (%eax),%al
  800901:	0f b6 d8             	movzbl %al,%ebx
  800904:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800907:	83 f8 55             	cmp    $0x55,%eax
  80090a:	0f 87 2b 03 00 00    	ja     800c3b <vprintfmt+0x399>
  800910:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
  800917:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800919:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80091d:	eb d7                	jmp    8008f6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80091f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800923:	eb d1                	jmp    8008f6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800925:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80092c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092f:	89 d0                	mov    %edx,%eax
  800931:	c1 e0 02             	shl    $0x2,%eax
  800934:	01 d0                	add    %edx,%eax
  800936:	01 c0                	add    %eax,%eax
  800938:	01 d8                	add    %ebx,%eax
  80093a:	83 e8 30             	sub    $0x30,%eax
  80093d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800940:	8b 45 10             	mov    0x10(%ebp),%eax
  800943:	8a 00                	mov    (%eax),%al
  800945:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800948:	83 fb 2f             	cmp    $0x2f,%ebx
  80094b:	7e 3e                	jle    80098b <vprintfmt+0xe9>
  80094d:	83 fb 39             	cmp    $0x39,%ebx
  800950:	7f 39                	jg     80098b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800952:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800955:	eb d5                	jmp    80092c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80096b:	eb 1f                	jmp    80098c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800971:	79 83                	jns    8008f6 <vprintfmt+0x54>
				width = 0;
  800973:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80097a:	e9 77 ff ff ff       	jmp    8008f6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80097f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800986:	e9 6b ff ff ff       	jmp    8008f6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80098b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80098c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800990:	0f 89 60 ff ff ff    	jns    8008f6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800996:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009a3:	e9 4e ff ff ff       	jmp    8008f6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ab:	e9 46 ff ff ff       	jmp    8008f6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 c0 04             	add    $0x4,%eax
  8009b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	83 e8 04             	sub    $0x4,%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	50                   	push   %eax
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	ff d0                	call   *%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
			break;
  8009d0:	e9 89 02 00 00       	jmp    800c5e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	79 02                	jns    8009ec <vprintfmt+0x14a>
				err = -err;
  8009ea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009ec:	83 fb 64             	cmp    $0x64,%ebx
  8009ef:	7f 0b                	jg     8009fc <vprintfmt+0x15a>
  8009f1:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8009f8:	85 f6                	test   %esi,%esi
  8009fa:	75 19                	jne    800a15 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009fc:	53                   	push   %ebx
  8009fd:	68 85 39 80 00       	push   $0x803985
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	ff 75 08             	pushl  0x8(%ebp)
  800a08:	e8 5e 02 00 00       	call   800c6b <printfmt>
  800a0d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a10:	e9 49 02 00 00       	jmp    800c5e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a15:	56                   	push   %esi
  800a16:	68 8e 39 80 00       	push   $0x80398e
  800a1b:	ff 75 0c             	pushl  0xc(%ebp)
  800a1e:	ff 75 08             	pushl  0x8(%ebp)
  800a21:	e8 45 02 00 00       	call   800c6b <printfmt>
  800a26:	83 c4 10             	add    $0x10,%esp
			break;
  800a29:	e9 30 02 00 00       	jmp    800c5e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 e8 04             	sub    $0x4,%eax
  800a3d:	8b 30                	mov    (%eax),%esi
  800a3f:	85 f6                	test   %esi,%esi
  800a41:	75 05                	jne    800a48 <vprintfmt+0x1a6>
				p = "(null)";
  800a43:	be 91 39 80 00       	mov    $0x803991,%esi
			if (width > 0 && padc != '-')
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4c:	7e 6d                	jle    800abb <vprintfmt+0x219>
  800a4e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a52:	74 67                	je     800abb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	50                   	push   %eax
  800a5b:	56                   	push   %esi
  800a5c:	e8 0c 03 00 00       	call   800d6d <strnlen>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a67:	eb 16                	jmp    800a7f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a69:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	50                   	push   %eax
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a83:	7f e4                	jg     800a69 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a8b:	74 1c                	je     800aa9 <vprintfmt+0x207>
  800a8d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a90:	7e 05                	jle    800a97 <vprintfmt+0x1f5>
  800a92:	83 fb 7e             	cmp    $0x7e,%ebx
  800a95:	7e 12                	jle    800aa9 <vprintfmt+0x207>
					putch('?', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 3f                	push   $0x3f
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	eb 0f                	jmp    800ab8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	53                   	push   %ebx
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab8:	ff 4d e4             	decl   -0x1c(%ebp)
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	8d 70 01             	lea    0x1(%eax),%esi
  800ac0:	8a 00                	mov    (%eax),%al
  800ac2:	0f be d8             	movsbl %al,%ebx
  800ac5:	85 db                	test   %ebx,%ebx
  800ac7:	74 24                	je     800aed <vprintfmt+0x24b>
  800ac9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800acd:	78 b8                	js     800a87 <vprintfmt+0x1e5>
  800acf:	ff 4d e0             	decl   -0x20(%ebp)
  800ad2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ad6:	79 af                	jns    800a87 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad8:	eb 13                	jmp    800aed <vprintfmt+0x24b>
				putch(' ', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 20                	push   $0x20
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aea:	ff 4d e4             	decl   -0x1c(%ebp)
  800aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af1:	7f e7                	jg     800ada <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800af3:	e9 66 01 00 00       	jmp    800c5e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 3c fd ff ff       	call   800843 <getint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b16:	85 d2                	test   %edx,%edx
  800b18:	79 23                	jns    800b3d <vprintfmt+0x29b>
				putch('-', putdat);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	6a 2d                	push   $0x2d
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	ff d0                	call   *%eax
  800b27:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b30:	f7 d8                	neg    %eax
  800b32:	83 d2 00             	adc    $0x0,%edx
  800b35:	f7 da                	neg    %edx
  800b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b3d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b44:	e9 bc 00 00 00       	jmp    800c05 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b52:	50                   	push   %eax
  800b53:	e8 84 fc ff ff       	call   8007dc <getuint>
  800b58:	83 c4 10             	add    $0x10,%esp
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b61:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b68:	e9 98 00 00 00       	jmp    800c05 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	6a 58                	push   $0x58
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	6a 58                	push   $0x58
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			break;
  800b9d:	e9 bc 00 00 00       	jmp    800c5e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	6a 30                	push   $0x30
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	6a 78                	push   $0x78
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 e8 04             	sub    $0x4,%eax
  800bd1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bdd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800be4:	eb 1f                	jmp    800c05 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bec:	8d 45 14             	lea    0x14(%ebp),%eax
  800bef:	50                   	push   %eax
  800bf0:	e8 e7 fb ff ff       	call   8007dc <getuint>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bfe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c05:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c0c:	83 ec 04             	sub    $0x4,%esp
  800c0f:	52                   	push   %edx
  800c10:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c13:	50                   	push   %eax
  800c14:	ff 75 f4             	pushl  -0xc(%ebp)
  800c17:	ff 75 f0             	pushl  -0x10(%ebp)
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	ff 75 08             	pushl  0x8(%ebp)
  800c20:	e8 00 fb ff ff       	call   800725 <printnum>
  800c25:	83 c4 20             	add    $0x20,%esp
			break;
  800c28:	eb 34                	jmp    800c5e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	53                   	push   %ebx
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			break;
  800c39:	eb 23                	jmp    800c5e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 25                	push   $0x25
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c4b:	ff 4d 10             	decl   0x10(%ebp)
  800c4e:	eb 03                	jmp    800c53 <vprintfmt+0x3b1>
  800c50:	ff 4d 10             	decl   0x10(%ebp)
  800c53:	8b 45 10             	mov    0x10(%ebp),%eax
  800c56:	48                   	dec    %eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	3c 25                	cmp    $0x25,%al
  800c5b:	75 f3                	jne    800c50 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c5d:	90                   	nop
		}
	}
  800c5e:	e9 47 fc ff ff       	jmp    8008aa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c63:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c71:	8d 45 10             	lea    0x10(%ebp),%eax
  800c74:	83 c0 04             	add    $0x4,%eax
  800c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c80:	50                   	push   %eax
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	ff 75 08             	pushl  0x8(%ebp)
  800c87:	e8 16 fc ff ff       	call   8008a2 <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8f:	90                   	nop
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8b 40 08             	mov    0x8(%eax),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	8b 10                	mov    (%eax),%edx
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8b 40 04             	mov    0x4(%eax),%eax
  800caf:	39 c2                	cmp    %eax,%edx
  800cb1:	73 12                	jae    800cc5 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	8d 48 01             	lea    0x1(%eax),%ecx
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbe:	89 0a                	mov    %ecx,(%edx)
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	88 10                	mov    %dl,(%eax)
}
  800cc5:	90                   	nop
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	01 d0                	add    %edx,%eax
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ced:	74 06                	je     800cf5 <vsnprintf+0x2d>
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	7f 07                	jg     800cfc <vsnprintf+0x34>
		return -E_INVAL;
  800cf5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfa:	eb 20                	jmp    800d1c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfc:	ff 75 14             	pushl  0x14(%ebp)
  800cff:	ff 75 10             	pushl  0x10(%ebp)
  800d02:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d05:	50                   	push   %eax
  800d06:	68 92 0c 80 00       	push   $0x800c92
  800d0b:	e8 92 fb ff ff       	call   8008a2 <vprintfmt>
  800d10:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d24:	8d 45 10             	lea    0x10(%ebp),%eax
  800d27:	83 c0 04             	add    $0x4,%eax
  800d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	ff 75 f4             	pushl  -0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	ff 75 08             	pushl  0x8(%ebp)
  800d3a:	e8 89 ff ff ff       	call   800cc8 <vsnprintf>
  800d3f:	83 c4 10             	add    $0x10,%esp
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d57:	eb 06                	jmp    800d5f <strlen+0x15>
		n++;
  800d59:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 f1                	jne    800d59 <strlen+0xf>
		n++;
	return n;
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7a:	eb 09                	jmp    800d85 <strnlen+0x18>
		n++;
  800d7c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7f:	ff 45 08             	incl   0x8(%ebp)
  800d82:	ff 4d 0c             	decl   0xc(%ebp)
  800d85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d89:	74 09                	je     800d94 <strnlen+0x27>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	84 c0                	test   %al,%al
  800d92:	75 e8                	jne    800d7c <strnlen+0xf>
		n++;
	return n;
  800d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da5:	90                   	nop
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8d 50 01             	lea    0x1(%eax),%edx
  800dac:	89 55 08             	mov    %edx,0x8(%ebp)
  800daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db8:	8a 12                	mov    (%edx),%dl
  800dba:	88 10                	mov    %dl,(%eax)
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e4                	jne    800da6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dda:	eb 1f                	jmp    800dfb <strncpy+0x34>
		*dst++ = *src;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8d 50 01             	lea    0x1(%eax),%edx
  800de2:	89 55 08             	mov    %edx,0x8(%ebp)
  800de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de8:	8a 12                	mov    (%edx),%dl
  800dea:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	74 03                	je     800df8 <strncpy+0x31>
			src++;
  800df5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df8:	ff 45 fc             	incl   -0x4(%ebp)
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e01:	72 d9                	jb     800ddc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e18:	74 30                	je     800e4a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e1a:	eb 16                	jmp    800e32 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 08             	mov    %edx,0x8(%ebp)
  800e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2e:	8a 12                	mov    (%edx),%dl
  800e30:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e32:	ff 4d 10             	decl   0x10(%ebp)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	74 09                	je     800e44 <strlcpy+0x3c>
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 d8                	jne    800e1c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	29 c2                	sub    %eax,%edx
  800e52:	89 d0                	mov    %edx,%eax
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e59:	eb 06                	jmp    800e61 <strcmp+0xb>
		p++, q++;
  800e5b:	ff 45 08             	incl   0x8(%ebp)
  800e5e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 0e                	je     800e78 <strcmp+0x22>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 10                	mov    (%eax),%dl
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	38 c2                	cmp    %al,%dl
  800e76:	74 e3                	je     800e5b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	0f b6 d0             	movzbl %al,%edx
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	0f b6 c0             	movzbl %al,%eax
  800e88:	29 c2                	sub    %eax,%edx
  800e8a:	89 d0                	mov    %edx,%eax
}
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e91:	eb 09                	jmp    800e9c <strncmp+0xe>
		n--, p++, q++;
  800e93:	ff 4d 10             	decl   0x10(%ebp)
  800e96:	ff 45 08             	incl   0x8(%ebp)
  800e99:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea0:	74 17                	je     800eb9 <strncmp+0x2b>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	84 c0                	test   %al,%al
  800ea9:	74 0e                	je     800eb9 <strncmp+0x2b>
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 10                	mov    (%eax),%dl
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	38 c2                	cmp    %al,%dl
  800eb7:	74 da                	je     800e93 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebd:	75 07                	jne    800ec6 <strncmp+0x38>
		return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	eb 14                	jmp    800eda <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 d0             	movzbl %al,%edx
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f b6 c0             	movzbl %al,%eax
  800ed6:	29 c2                	sub    %eax,%edx
  800ed8:	89 d0                	mov    %edx,%eax
}
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 04             	sub    $0x4,%esp
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee8:	eb 12                	jmp    800efc <strchr+0x20>
		if (*s == c)
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef2:	75 05                	jne    800ef9 <strchr+0x1d>
			return (char *) s;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	eb 11                	jmp    800f0a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	75 e5                	jne    800eea <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 04             	sub    $0x4,%esp
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f18:	eb 0d                	jmp    800f27 <strfind+0x1b>
		if (*s == c)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f22:	74 0e                	je     800f32 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	75 ea                	jne    800f1a <strfind+0xe>
  800f30:	eb 01                	jmp    800f33 <strfind+0x27>
		if (*s == c)
			break;
  800f32:	90                   	nop
	return (char *) s;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f44:	8b 45 10             	mov    0x10(%ebp),%eax
  800f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f4a:	eb 0e                	jmp    800f5a <memset+0x22>
		*p++ = c;
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	8d 50 01             	lea    0x1(%eax),%edx
  800f52:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f58:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f5a:	ff 4d f8             	decl   -0x8(%ebp)
  800f5d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f61:	79 e9                	jns    800f4c <memset+0x14>
		*p++ = c;

	return v;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f7a:	eb 16                	jmp    800f92 <memcpy+0x2a>
		*d++ = *s++;
  800f7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8e:	8a 12                	mov    (%edx),%dl
  800f90:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f98:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	75 dd                	jne    800f7c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbc:	73 50                	jae    80100e <memmove+0x6a>
  800fbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 d0                	add    %edx,%eax
  800fc6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc9:	76 43                	jbe    80100e <memmove+0x6a>
		s += n;
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd7:	eb 10                	jmp    800fe9 <memmove+0x45>
			*--d = *--s;
  800fd9:	ff 4d f8             	decl   -0x8(%ebp)
  800fdc:	ff 4d fc             	decl   -0x4(%ebp)
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8a 10                	mov    (%eax),%dl
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fef:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	75 e3                	jne    800fd9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff6:	eb 23                	jmp    80101b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	8d 50 01             	lea    0x1(%eax),%edx
  800ffe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801001:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801004:	8d 4a 01             	lea    0x1(%edx),%ecx
  801007:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100a:	8a 12                	mov    (%edx),%dl
  80100c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100e:	8b 45 10             	mov    0x10(%ebp),%eax
  801011:	8d 50 ff             	lea    -0x1(%eax),%edx
  801014:	89 55 10             	mov    %edx,0x10(%ebp)
  801017:	85 c0                	test   %eax,%eax
  801019:	75 dd                	jne    800ff8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801032:	eb 2a                	jmp    80105e <memcmp+0x3e>
		if (*s1 != *s2)
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	8a 10                	mov    (%eax),%dl
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	38 c2                	cmp    %al,%dl
  801040:	74 16                	je     801058 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801042:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f b6 d0             	movzbl %al,%edx
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	0f b6 c0             	movzbl %al,%eax
  801052:	29 c2                	sub    %eax,%edx
  801054:	89 d0                	mov    %edx,%eax
  801056:	eb 18                	jmp    801070 <memcmp+0x50>
		s1++, s2++;
  801058:	ff 45 fc             	incl   -0x4(%ebp)
  80105b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 c9                	jne    801034 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80106b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801083:	eb 15                	jmp    80109a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	0f b6 d0             	movzbl %al,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	0f b6 c0             	movzbl %al,%eax
  801093:	39 c2                	cmp    %eax,%edx
  801095:	74 0d                	je     8010a4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a0:	72 e3                	jb     801085 <memfind+0x13>
  8010a2:	eb 01                	jmp    8010a5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a4:	90                   	nop
	return (void *) s;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010be:	eb 03                	jmp    8010c3 <strtol+0x19>
		s++;
  8010c0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 20                	cmp    $0x20,%al
  8010ca:	74 f4                	je     8010c0 <strtol+0x16>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 09                	cmp    $0x9,%al
  8010d3:	74 eb                	je     8010c0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 2b                	cmp    $0x2b,%al
  8010dc:	75 05                	jne    8010e3 <strtol+0x39>
		s++;
  8010de:	ff 45 08             	incl   0x8(%ebp)
  8010e1:	eb 13                	jmp    8010f6 <strtol+0x4c>
	else if (*s == '-')
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 2d                	cmp    $0x2d,%al
  8010ea:	75 0a                	jne    8010f6 <strtol+0x4c>
		s++, neg = 1;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	74 06                	je     801102 <strtol+0x58>
  8010fc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801100:	75 20                	jne    801122 <strtol+0x78>
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3c 30                	cmp    $0x30,%al
  801109:	75 17                	jne    801122 <strtol+0x78>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	40                   	inc    %eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 78                	cmp    $0x78,%al
  801113:	75 0d                	jne    801122 <strtol+0x78>
		s += 2, base = 16;
  801115:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801119:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801120:	eb 28                	jmp    80114a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801126:	75 15                	jne    80113d <strtol+0x93>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 30                	cmp    $0x30,%al
  80112f:	75 0c                	jne    80113d <strtol+0x93>
		s++, base = 8;
  801131:	ff 45 08             	incl   0x8(%ebp)
  801134:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113b:	eb 0d                	jmp    80114a <strtol+0xa0>
	else if (base == 0)
  80113d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801141:	75 07                	jne    80114a <strtol+0xa0>
		base = 10;
  801143:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2f                	cmp    $0x2f,%al
  801151:	7e 19                	jle    80116c <strtol+0xc2>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 39                	cmp    $0x39,%al
  80115a:	7f 10                	jg     80116c <strtol+0xc2>
			dig = *s - '0';
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	0f be c0             	movsbl %al,%eax
  801164:	83 e8 30             	sub    $0x30,%eax
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116a:	eb 42                	jmp    8011ae <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 60                	cmp    $0x60,%al
  801173:	7e 19                	jle    80118e <strtol+0xe4>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 7a                	cmp    $0x7a,%al
  80117c:	7f 10                	jg     80118e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	0f be c0             	movsbl %al,%eax
  801186:	83 e8 57             	sub    $0x57,%eax
  801189:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118c:	eb 20                	jmp    8011ae <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 40                	cmp    $0x40,%al
  801195:	7e 39                	jle    8011d0 <strtol+0x126>
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 5a                	cmp    $0x5a,%al
  80119e:	7f 30                	jg     8011d0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	0f be c0             	movsbl %al,%eax
  8011a8:	83 e8 37             	sub    $0x37,%eax
  8011ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b4:	7d 19                	jge    8011cf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ca:	e9 7b ff ff ff       	jmp    80114a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d4:	74 08                	je     8011de <strtol+0x134>
		*endptr = (char *) s;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e2:	74 07                	je     8011eb <strtol+0x141>
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	f7 d8                	neg    %eax
  8011e9:	eb 03                	jmp    8011ee <strtol+0x144>
  8011eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801208:	79 13                	jns    80121d <ltostr+0x2d>
	{
		neg = 1;
  80120a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801217:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80121a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801225:	99                   	cltd   
  801226:	f7 f9                	idiv   %ecx
  801228:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80122b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801234:	89 c2                	mov    %eax,%edx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123e:	83 c2 30             	add    $0x30,%edx
  801241:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801243:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801246:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124b:	f7 e9                	imul   %ecx
  80124d:	c1 fa 02             	sar    $0x2,%edx
  801250:	89 c8                	mov    %ecx,%eax
  801252:	c1 f8 1f             	sar    $0x1f,%eax
  801255:	29 c2                	sub    %eax,%edx
  801257:	89 d0                	mov    %edx,%eax
  801259:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80125c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801264:	f7 e9                	imul   %ecx
  801266:	c1 fa 02             	sar    $0x2,%edx
  801269:	89 c8                	mov    %ecx,%eax
  80126b:	c1 f8 1f             	sar    $0x1f,%eax
  80126e:	29 c2                	sub    %eax,%edx
  801270:	89 d0                	mov    %edx,%eax
  801272:	c1 e0 02             	shl    $0x2,%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	01 c0                	add    %eax,%eax
  801279:	29 c1                	sub    %eax,%ecx
  80127b:	89 ca                	mov    %ecx,%edx
  80127d:	85 d2                	test   %edx,%edx
  80127f:	75 9c                	jne    80121d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801288:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128b:	48                   	dec    %eax
  80128c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80128f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801293:	74 3d                	je     8012d2 <ltostr+0xe2>
		start = 1 ;
  801295:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80129c:	eb 34                	jmp    8012d2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80129e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 c2                	add    %eax,%edx
  8012c7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012ca:	88 02                	mov    %al,(%edx)
		start++ ;
  8012cc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012cf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c c4                	jl     80129e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012da:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ee:	ff 75 08             	pushl  0x8(%ebp)
  8012f1:	e8 54 fa ff ff       	call   800d4a <strlen>
  8012f6:	83 c4 04             	add    $0x4,%esp
  8012f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	e8 46 fa ff ff       	call   800d4a <strlen>
  801304:	83 c4 04             	add    $0x4,%esp
  801307:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80130a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801311:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801318:	eb 17                	jmp    801331 <strcconcat+0x49>
		final[s] = str1[s] ;
  80131a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131d:	8b 45 10             	mov    0x10(%ebp),%eax
  801320:	01 c2                	add    %eax,%edx
  801322:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	01 c8                	add    %ecx,%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80132e:	ff 45 fc             	incl   -0x4(%ebp)
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801337:	7c e1                	jl     80131a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801339:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801340:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801347:	eb 1f                	jmp    801368 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134c:	8d 50 01             	lea    0x1(%eax),%edx
  80134f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801352:	89 c2                	mov    %eax,%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135f:	01 c8                	add    %ecx,%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
  801368:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136e:	7c d9                	jl     801349 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801370:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c6 00 00             	movb   $0x0,(%eax)
}
  80137b:	90                   	nop
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a1:	eb 0c                	jmp    8013af <strsplit+0x31>
			*string++ = 0;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ac:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 18                	je     8013d0 <strsplit+0x52>
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	0f be c0             	movsbl %al,%eax
  8013c0:	50                   	push   %eax
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	e8 13 fb ff ff       	call   800edc <strchr>
  8013c9:	83 c4 08             	add    $0x8,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	75 d3                	jne    8013a3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	84 c0                	test   %al,%al
  8013d7:	74 5a                	je     801433 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013dc:	8b 00                	mov    (%eax),%eax
  8013de:	83 f8 0f             	cmp    $0xf,%eax
  8013e1:	75 07                	jne    8013ea <strsplit+0x6c>
		{
			return 0;
  8013e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e8:	eb 66                	jmp    801450 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ed:	8b 00                	mov    (%eax),%eax
  8013ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f5:	89 0a                	mov    %ecx,(%edx)
  8013f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801401:	01 c2                	add    %eax,%edx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801408:	eb 03                	jmp    80140d <strsplit+0x8f>
			string++;
  80140a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	84 c0                	test   %al,%al
  801414:	74 8b                	je     8013a1 <strsplit+0x23>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	0f be c0             	movsbl %al,%eax
  80141e:	50                   	push   %eax
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	e8 b5 fa ff ff       	call   800edc <strchr>
  801427:	83 c4 08             	add    $0x8,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	74 dc                	je     80140a <strsplit+0x8c>
			string++;
	}
  80142e:	e9 6e ff ff ff       	jmp    8013a1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801433:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801434:	8b 45 14             	mov    0x14(%ebp),%eax
  801437:	8b 00                	mov    (%eax),%eax
  801439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	01 d0                	add    %edx,%eax
  801445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80144b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145f:	eb 4c                	jmp    8014ad <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	01 d0                	add    %edx,%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 40                	cmp    $0x40,%al
  80146d:	7e 27                	jle    801496 <str2lower+0x44>
  80146f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	01 d0                	add    %edx,%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 5a                	cmp    $0x5a,%al
  80147b:	7f 19                	jg     801496 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	01 ca                	add    %ecx,%edx
  80148d:	8a 12                	mov    (%edx),%dl
  80148f:	83 c2 20             	add    $0x20,%edx
  801492:	88 10                	mov    %dl,(%eax)
  801494:	eb 14                	jmp    8014aa <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	01 c2                	add    %eax,%edx
  80149e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	01 c8                	add    %ecx,%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8014aa:	ff 45 fc             	incl   -0x4(%ebp)
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	e8 95 f8 ff ff       	call   800d4a <strlen>
  8014b5:	83 c4 04             	add    $0x4,%esp
  8014b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014bb:	7f a4                	jg     801461 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  8014c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	74 0a                	je     8014d8 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014ce:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014d5:	00 00 00 
	}
}
  8014d8:	90                   	nop
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    

008014db <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014e1:	83 ec 0c             	sub    $0xc,%esp
  8014e4:	ff 75 08             	pushl  0x8(%ebp)
  8014e7:	e8 7e 09 00 00       	call   801e6a <sys_sbrk>
  8014ec:	83 c4 10             	add    $0x10,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f7:	e8 c6 ff ff ff       	call   8014c2 <InitializeUHeap>
	if (size == 0)
  8014fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801500:	75 0a                	jne    80150c <malloc+0x1b>
		return NULL;
  801502:	b8 00 00 00 00       	mov    $0x0,%eax
  801507:	e9 3f 01 00 00       	jmp    80164b <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80150c:	e8 ac 09 00 00       	call   801ebd <sys_get_hard_limit>
  801511:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801514:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  80151b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801523:	c1 e8 0c             	shr    $0xc,%eax
  801526:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801529:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801530:	8b 55 08             	mov    0x8(%ebp),%edx
  801533:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	48                   	dec    %eax
  801539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80153c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80153f:	ba 00 00 00 00       	mov    $0x0,%edx
  801544:	f7 75 d8             	divl   -0x28(%ebp)
  801547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80154a:	29 d0                	sub    %edx,%eax
  80154c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  80154f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801552:	c1 e8 0c             	shr    $0xc,%eax
  801555:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155c:	75 0a                	jne    801568 <malloc+0x77>
		return NULL;
  80155e:	b8 00 00 00 00       	mov    $0x0,%eax
  801563:	e9 e3 00 00 00       	jmp    80164b <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156b:	05 00 00 00 80       	add    $0x80000000,%eax
  801570:	c1 e8 0c             	shr    $0xc,%eax
  801573:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801578:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80157f:	77 19                	ja     80159a <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801581:	83 ec 0c             	sub    $0xc,%esp
  801584:	ff 75 08             	pushl  0x8(%ebp)
  801587:	e8 60 0b 00 00       	call   8020ec <alloc_block_FF>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801592:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801595:	e9 b1 00 00 00       	jmp    80164b <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80159a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015a0:	eb 4d                	jmp    8015ef <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  8015a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a5:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015ac:	84 c0                	test   %al,%al
  8015ae:	75 27                	jne    8015d7 <malloc+0xe6>
			{
				counter++;
  8015b0:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  8015b3:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8015b7:	75 14                	jne    8015cd <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  8015b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015bc:	05 00 00 08 00       	add    $0x80000,%eax
  8015c1:	c1 e0 0c             	shl    $0xc,%eax
  8015c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  8015c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  8015cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d0:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015d3:	75 17                	jne    8015ec <malloc+0xfb>
				{
					break;
  8015d5:	eb 21                	jmp    8015f8 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  8015d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015da:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015e1:	3c 01                	cmp    $0x1,%al
  8015e3:	75 07                	jne    8015ec <malloc+0xfb>
			{
				counter = 0;
  8015e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  8015ec:	ff 45 e8             	incl   -0x18(%ebp)
  8015ef:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8015f6:	76 aa                	jbe    8015a2 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8015f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fb:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015fe:	75 46                	jne    801646 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	ff 75 d0             	pushl  -0x30(%ebp)
  801606:	ff 75 f4             	pushl  -0xc(%ebp)
  801609:	e8 93 08 00 00       	call   801ea1 <sys_allocate_user_mem>
  80160e:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801617:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801624:	eb 0e                	jmp    801634 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801629:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  801630:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801631:	ff 45 e4             	incl   -0x1c(%ebp)
  801634:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	01 d0                	add    %edx,%eax
  80163c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80163f:	77 e5                	ja     801626 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	eb 05                	jmp    80164b <malloc+0x15a>
		}
	}

	return NULL;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801653:	e8 65 08 00 00       	call   801ebd <sys_get_hard_limit>
  801658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801665:	0f 84 c1 00 00 00    	je     80172c <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	85 c0                	test   %eax,%eax
  801670:	79 1b                	jns    80168d <free+0x40>
  801672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	73 13                	jae    80168d <free+0x40>
    {
        free_block(virtual_address);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	e8 34 10 00 00       	call   8026b9 <free_block>
  801685:	83 c4 10             	add    $0x10,%esp
    	return;
  801688:	e9 a6 00 00 00       	jmp    801733 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  80168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801690:	05 00 10 00 00       	add    $0x1000,%eax
  801695:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801698:	0f 87 91 00 00 00    	ja     80172f <free+0xe2>
  80169e:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016a5:	0f 87 84 00 00 00    	ja     80172f <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  8016ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  8016bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8016c4:	c1 e8 0c             	shr    $0xc,%eax
  8016c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  8016ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016cd:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8016d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  8016d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016db:	74 55                	je     801732 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  8016dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e0:	c1 e8 0c             	shr    $0xc,%eax
  8016e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  8016e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e9:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  8016f0:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8016f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fa:	eb 0e                	jmp    80170a <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  801706:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801707:	ff 45 f4             	incl   -0xc(%ebp)
  80170a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80170d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801710:	01 c2                	add    %eax,%edx
  801712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801715:	39 c2                	cmp    %eax,%edx
  801717:	77 e3                	ja     8016fc <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801719:	83 ec 08             	sub    $0x8,%esp
  80171c:	ff 75 e0             	pushl  -0x20(%ebp)
  80171f:	ff 75 ec             	pushl  -0x14(%ebp)
  801722:	e8 5e 07 00 00       	call   801e85 <sys_free_user_mem>
  801727:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  80172a:	eb 07                	jmp    801733 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  80172c:	90                   	nop
  80172d:	eb 04                	jmp    801733 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  80172f:	90                   	nop
  801730:	eb 01                	jmp    801733 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801732:	90                   	nop
    else
     {
    	return;
      }

}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 18             	sub    $0x18,%esp
  80173b:	8b 45 10             	mov    0x10(%ebp),%eax
  80173e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801741:	e8 7c fd ff ff       	call   8014c2 <InitializeUHeap>
	if (size == 0)
  801746:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174a:	75 07                	jne    801753 <smalloc+0x1e>
		return NULL;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb 17                	jmp    80176a <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	68 f0 3a 80 00       	push   $0x803af0
  80175b:	68 ad 00 00 00       	push   $0xad
  801760:	68 16 3b 80 00       	push   $0x803b16
  801765:	e8 a1 ec ff ff       	call   80040b <_panic>
	return NULL;
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801772:	e8 4b fd ff ff       	call   8014c2 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 24 3b 80 00       	push   $0x803b24
  80177f:	68 ba 00 00 00       	push   $0xba
  801784:	68 16 3b 80 00       	push   $0x803b16
  801789:	e8 7d ec ff ff       	call   80040b <_panic>

0080178e <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801794:	e8 29 fd ff ff       	call   8014c2 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	68 48 3b 80 00       	push   $0x803b48
  8017a1:	68 d8 00 00 00       	push   $0xd8
  8017a6:	68 16 3b 80 00       	push   $0x803b16
  8017ab:	e8 5b ec ff ff       	call   80040b <_panic>

008017b0 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	68 70 3b 80 00       	push   $0x803b70
  8017be:	68 ea 00 00 00       	push   $0xea
  8017c3:	68 16 3b 80 00       	push   $0x803b16
  8017c8:	e8 3e ec ff ff       	call   80040b <_panic>

008017cd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	68 94 3b 80 00       	push   $0x803b94
  8017db:	68 f2 00 00 00       	push   $0xf2
  8017e0:	68 16 3b 80 00       	push   $0x803b16
  8017e5:	e8 21 ec ff ff       	call   80040b <_panic>

008017ea <shrink>:

}
void shrink(uint32 newSize) {
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 94 3b 80 00       	push   $0x803b94
  8017f8:	68 f6 00 00 00       	push   $0xf6
  8017fd:	68 16 3b 80 00       	push   $0x803b16
  801802:	e8 04 ec ff ff       	call   80040b <_panic>

00801807 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	68 94 3b 80 00       	push   $0x803b94
  801815:	68 fa 00 00 00       	push   $0xfa
  80181a:	68 16 3b 80 00       	push   $0x803b16
  80181f:	e8 e7 eb ff ff       	call   80040b <_panic>

00801824 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	57                   	push   %edi
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
  80182a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801836:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801839:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183f:	cd 30                	int    $0x30
  801841:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801844:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	5b                   	pop    %ebx
  80184b:	5e                   	pop    %esi
  80184c:	5f                   	pop    %edi
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	8b 45 10             	mov    0x10(%ebp),%eax
  801858:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	52                   	push   %edx
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	50                   	push   %eax
  80186b:	6a 00                	push   $0x0
  80186d:	e8 b2 ff ff ff       	call   801824 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_cgetc>:

int
sys_cgetc(void)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 01                	push   $0x1
  801887:	e8 98 ff ff ff       	call   801824 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 05                	push   $0x5
  8018a4:	e8 7b ff ff ff       	call   801824 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	56                   	push   %esi
  8018b2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	51                   	push   %ecx
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	6a 06                	push   $0x6
  8018c9:	e8 56 ff ff ff       	call   801824 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    

008018d8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	6a 07                	push   $0x7
  8018eb:	e8 34 ff ff ff       	call   801824 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	6a 08                	push   $0x8
  801906:	e8 19 ff ff ff       	call   801824 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 09                	push   $0x9
  80191f:	e8 00 ff ff ff       	call   801824 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 0a                	push   $0xa
  801938:	e8 e7 fe ff ff       	call   801824 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 0b                	push   $0xb
  801951:	e8 ce fe ff ff       	call   801824 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 0c                	push   $0xc
  80196a:	e8 b5 fe ff ff       	call   801824 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 0d                	push   $0xd
  801984:	e8 9b fe ff ff       	call   801824 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 0e                	push   $0xe
  80199d:	e8 82 fe ff ff       	call   801824 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 11                	push   $0x11
  8019b7:	e8 68 fe ff ff       	call   801824 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 12                	push   $0x12
  8019d1:	e8 4e fe ff ff       	call   801824 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_cputc>:


void
sys_cputc(const char c)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	50                   	push   %eax
  8019f5:	6a 13                	push   $0x13
  8019f7:	e8 28 fe ff ff       	call   801824 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 14                	push   $0x14
  801a11:	e8 0e fe ff ff       	call   801824 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	90                   	nop
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	6a 15                	push   $0x15
  801a2e:	e8 f1 fd ff ff       	call   801824 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 18                	push   $0x18
  801a4b:	e8 d4 fd ff ff       	call   801824 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 16                	push   $0x16
  801a68:	e8 b7 fd ff ff       	call   801824 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	90                   	nop
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 17                	push   $0x17
  801a86:	e8 99 fd ff ff       	call   801824 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a9d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	51                   	push   %ecx
  801aaa:	52                   	push   %edx
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	50                   	push   %eax
  801aaf:	6a 19                	push   $0x19
  801ab1:	e8 6e fd ff ff       	call   801824 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 1a                	push   $0x1a
  801ace:	e8 51 fd ff ff       	call   801824 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	51                   	push   %ecx
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 1b                	push   $0x1b
  801aed:	e8 32 fd ff ff       	call   801824 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 1c                	push   $0x1c
  801b0a:	e8 15 fd ff ff       	call   801824 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 1d                	push   $0x1d
  801b23:	e8 fc fc ff ff       	call   801824 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	ff 75 14             	pushl  0x14(%ebp)
  801b38:	ff 75 10             	pushl  0x10(%ebp)
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	50                   	push   %eax
  801b3f:	6a 1e                	push   $0x1e
  801b41:	e8 de fc ff ff       	call   801824 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	50                   	push   %eax
  801b5a:	6a 1f                	push   $0x1f
  801b5c:	e8 c3 fc ff ff       	call   801824 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	50                   	push   %eax
  801b76:	6a 20                	push   $0x20
  801b78:	e8 a7 fc ff ff       	call   801824 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 02                	push   $0x2
  801b91:	e8 8e fc ff ff       	call   801824 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 03                	push   $0x3
  801baa:	e8 75 fc ff ff       	call   801824 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 04                	push   $0x4
  801bc3:	e8 5c fc ff ff       	call   801824 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_exit_env>:


void sys_exit_env(void)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 21                	push   $0x21
  801bdc:	e8 43 fc ff ff       	call   801824 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	90                   	nop
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf0:	8d 50 04             	lea    0x4(%eax),%edx
  801bf3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	52                   	push   %edx
  801bfd:	50                   	push   %eax
  801bfe:	6a 22                	push   $0x22
  801c00:	e8 1f fc ff ff       	call   801824 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
	return result;
  801c08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c11:	89 01                	mov    %eax,(%ecx)
  801c13:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	c9                   	leave  
  801c1a:	c2 04 00             	ret    $0x4

00801c1d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 10                	push   $0x10
  801c2f:	e8 f0 fb ff ff       	call   801824 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return ;
  801c37:	90                   	nop
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 23                	push   $0x23
  801c49:	e8 d6 fb ff ff       	call   801824 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c5f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	50                   	push   %eax
  801c6c:	6a 24                	push   $0x24
  801c6e:	e8 b1 fb ff ff       	call   801824 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return ;
  801c76:	90                   	nop
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <rsttst>:
void rsttst()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 26                	push   $0x26
  801c88:	e8 97 fb ff ff       	call   801824 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c90:	90                   	nop
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c9f:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	ff 75 10             	pushl  0x10(%ebp)
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	ff 75 08             	pushl  0x8(%ebp)
  801cb1:	6a 25                	push   $0x25
  801cb3:	e8 6c fb ff ff       	call   801824 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbb:	90                   	nop
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <chktst>:
void chktst(uint32 n)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	6a 27                	push   $0x27
  801cce:	e8 51 fb ff ff       	call   801824 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <inctst>:

void inctst()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 28                	push   $0x28
  801ce8:	e8 37 fb ff ff       	call   801824 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf0:	90                   	nop
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <gettst>:
uint32 gettst()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 29                	push   $0x29
  801d02:	e8 1d fb ff ff       	call   801824 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 2a                	push   $0x2a
  801d1e:	e8 01 fb ff ff       	call   801824 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
  801d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d29:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d2d:	75 07                	jne    801d36 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d34:	eb 05                	jmp    801d3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 2a                	push   $0x2a
  801d4f:	e8 d0 fa ff ff       	call   801824 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
  801d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d5e:	75 07                	jne    801d67 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d60:	b8 01 00 00 00       	mov    $0x1,%eax
  801d65:	eb 05                	jmp    801d6c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 2a                	push   $0x2a
  801d80:	e8 9f fa ff ff       	call   801824 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
  801d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d8b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d8f:	75 07                	jne    801d98 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d91:	b8 01 00 00 00       	mov    $0x1,%eax
  801d96:	eb 05                	jmp    801d9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 2a                	push   $0x2a
  801db1:	e8 6e fa ff ff       	call   801824 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
  801db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dbc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc0:	75 07                	jne    801dc9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc7:	eb 05                	jmp    801dce <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	6a 2b                	push   $0x2b
  801de0:	e8 3f fa ff ff       	call   801824 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
	return ;
  801de8:	90                   	nop
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801def:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	53                   	push   %ebx
  801dfe:	51                   	push   %ecx
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 2c                	push   $0x2c
  801e03:	e8 1c fa ff ff       	call   801824 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	6a 2d                	push   $0x2d
  801e23:	e8 fc f9 ff ff       	call   801824 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	51                   	push   %ecx
  801e3c:	ff 75 10             	pushl  0x10(%ebp)
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 2e                	push   $0x2e
  801e43:	e8 dc f9 ff ff       	call   801824 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 10             	pushl  0x10(%ebp)
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 0f                	push   $0xf
  801e5f:	e8 c0 f9 ff ff       	call   801824 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	50                   	push   %eax
  801e79:	6a 2f                	push   $0x2f
  801e7b:	e8 a4 f9 ff ff       	call   801824 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp

}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 0c             	pushl  0xc(%ebp)
  801e91:	ff 75 08             	pushl  0x8(%ebp)
  801e94:	6a 30                	push   $0x30
  801e96:	e8 89 f9 ff ff       	call   801824 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	6a 31                	push   $0x31
  801eb2:	e8 6d f9 ff ff       	call   801824 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 32                	push   $0x32
  801ecc:	e8 53 f9 ff ff       	call   801824 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	50                   	push   %eax
  801ee5:	6a 33                	push   $0x33
  801ee7:	e8 38 f9 ff ff       	call   801824 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	90                   	nop
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	83 e8 10             	sub    $0x10,%eax
  801efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f04:	8b 00                	mov    (%eax),%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	83 e8 10             	sub    $0x10,%eax
  801f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1a:	8a 40 04             	mov    0x4(%eax),%al
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2f:	83 f8 02             	cmp    $0x2,%eax
  801f32:	74 2b                	je     801f5f <alloc_block+0x40>
  801f34:	83 f8 02             	cmp    $0x2,%eax
  801f37:	7f 07                	jg     801f40 <alloc_block+0x21>
  801f39:	83 f8 01             	cmp    $0x1,%eax
  801f3c:	74 0e                	je     801f4c <alloc_block+0x2d>
  801f3e:	eb 58                	jmp    801f98 <alloc_block+0x79>
  801f40:	83 f8 03             	cmp    $0x3,%eax
  801f43:	74 2d                	je     801f72 <alloc_block+0x53>
  801f45:	83 f8 04             	cmp    $0x4,%eax
  801f48:	74 3b                	je     801f85 <alloc_block+0x66>
  801f4a:	eb 4c                	jmp    801f98 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 95 01 00 00       	call   8020ec <alloc_block_FF>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f5d:	eb 4a                	jmp    801fa9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	e8 32 07 00 00       	call   80269c <alloc_block_NF>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f70:	eb 37                	jmp    801fa9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	e8 a3 04 00 00       	call   802420 <alloc_block_BF>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f83:	eb 24                	jmp    801fa9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	e8 ef 06 00 00       	call   80267f <alloc_block_WF>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f96:	eb 11                	jmp    801fa9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	68 a4 3b 80 00       	push   $0x803ba4
  801fa0:	e8 23 e7 ff ff       	call   8006c8 <cprintf>
  801fa5:	83 c4 10             	add    $0x10,%esp
		break;
  801fa8:	90                   	nop
	}
	return va;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	68 c4 3b 80 00       	push   $0x803bc4
  801fbc:	e8 07 e7 ff ff       	call   8006c8 <cprintf>
  801fc1:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	68 ef 3b 80 00       	push   $0x803bef
  801fcc:	e8 f7 e6 ff ff       	call   8006c8 <cprintf>
  801fd1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fda:	eb 26                	jmp    802002 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	8a 40 04             	mov    0x4(%eax),%al
  801fe2:	0f b6 d0             	movzbl %al,%edx
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	68 07 3c 80 00       	push   $0x803c07
  801ff4:	e8 cf e6 ff ff       	call   8006c8 <cprintf>
  801ff9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802002:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802006:	74 08                	je     802010 <print_blocks_list+0x62>
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 40 08             	mov    0x8(%eax),%eax
  80200e:	eb 05                	jmp    802015 <print_blocks_list+0x67>
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	89 45 10             	mov    %eax,0x10(%ebp)
  802018:	8b 45 10             	mov    0x10(%ebp),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 bd                	jne    801fdc <print_blocks_list+0x2e>
  80201f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802023:	75 b7                	jne    801fdc <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	68 c4 3b 80 00       	push   $0x803bc4
  80202d:	e8 96 e6 ff ff       	call   8006c8 <cprintf>
  802032:	83 c4 10             	add    $0x10,%esp

}
  802035:	90                   	nop
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80203e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802042:	0f 84 a1 00 00 00    	je     8020e9 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802048:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  80204f:	00 00 00 
	LIST_INIT(&list);
  802052:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  802059:	00 00 00 
  80205c:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  802063:	00 00 00 
  802066:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  80206d:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802089:	75 14                	jne    80209f <initialize_dynamic_allocator+0x67>
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 20 3c 80 00       	push   $0x803c20
  802093:	6a 64                	push   $0x64
  802095:	68 43 3c 80 00       	push   $0x803c43
  80209a:	e8 6c e3 ff ff       	call   80040b <_panic>
  80209f:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	89 50 0c             	mov    %edx,0xc(%eax)
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 0d                	je     8020c2 <initialize_dynamic_allocator+0x8a>
  8020b5:	a1 44 41 90 00       	mov    0x904144,%eax
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	89 50 08             	mov    %edx,0x8(%eax)
  8020c0:	eb 08                	jmp    8020ca <initialize_dynamic_allocator+0x92>
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	a3 40 41 90 00       	mov    %eax,0x904140
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	a3 44 41 90 00       	mov    %eax,0x904144
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020dc:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8020e1:	40                   	inc    %eax
  8020e2:	a3 4c 41 90 00       	mov    %eax,0x90414c
  8020e7:	eb 01                	jmp    8020ea <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8020e9:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8020f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f6:	75 0a                	jne    802102 <alloc_block_FF+0x16>
	{
		return NULL;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fd:	e9 1c 03 00 00       	jmp    80241e <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802102:	a1 2c 40 80 00       	mov    0x80402c,%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	75 40                	jne    80214b <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	83 c0 10             	add    $0x10,%eax
  802111:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	50                   	push   %eax
  80211b:	e8 bb f3 ff ff       	call   8014db <sbrk>
  802120:	83 c4 10             	add    $0x10,%esp
  802123:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	6a 00                	push   $0x0
  80212b:	e8 ab f3 ff ff       	call   8014db <sbrk>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802139:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80213c:	83 ec 08             	sub    $0x8,%esp
  80213f:	50                   	push   %eax
  802140:	ff 75 ec             	pushl  -0x14(%ebp)
  802143:	e8 f0 fe ff ff       	call   802038 <initialize_dynamic_allocator>
  802148:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  80214b:	a1 40 41 90 00       	mov    0x904140,%eax
  802150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802153:	e9 1e 01 00 00       	jmp    802276 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	8d 50 10             	lea    0x10(%eax),%edx
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	75 1c                	jne    802183 <alloc_block_FF+0x97>
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8a 40 04             	mov    0x4(%eax),%al
  80216d:	3c 01                	cmp    $0x1,%al
  80216f:	75 12                	jne    802183 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	83 c0 10             	add    $0x10,%eax
  80217e:	e9 9b 02 00 00       	jmp    80241e <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8d 50 10             	lea    0x10(%eax),%edx
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	39 c2                	cmp    %eax,%edx
  802190:	0f 83 d8 00 00 00    	jae    80226e <alloc_block_FF+0x182>
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8a 40 04             	mov    0x4(%eax),%al
  80219c:	3c 01                	cmp    $0x1,%al
  80219e:	0f 85 ca 00 00 00    	jne    80226e <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 00                	mov    (%eax),%eax
  8021a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ac:	83 e8 10             	sub    $0x10,%eax
  8021af:	83 f8 0f             	cmp    $0xf,%eax
  8021b2:	0f 86 a4 00 00 00    	jbe    80225c <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 d0                	add    %edx,%eax
  8021c0:	83 c0 10             	add    $0x10,%eax
  8021c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ce:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021d4:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8021d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021d9:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8021dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e1:	74 06                	je     8021e9 <alloc_block_FF+0xfd>
  8021e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021e7:	75 17                	jne    802200 <alloc_block_FF+0x114>
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 5c 3c 80 00       	push   $0x803c5c
  8021f1:	68 8f 00 00 00       	push   $0x8f
  8021f6:	68 43 3c 80 00       	push   $0x803c43
  8021fb:	e8 0b e2 ff ff       	call   80040b <_panic>
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802209:	89 50 08             	mov    %edx,0x8(%eax)
  80220c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	74 0c                	je     802222 <alloc_block_FF+0x136>
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80221f:	89 50 0c             	mov    %edx,0xc(%eax)
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802228:	89 50 08             	mov    %edx,0x8(%eax)
  80222b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80222e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802231:	89 50 0c             	mov    %edx,0xc(%eax)
  802234:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802237:	8b 40 08             	mov    0x8(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	75 08                	jne    802246 <alloc_block_FF+0x15a>
  80223e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802241:	a3 44 41 90 00       	mov    %eax,0x904144
  802246:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80224b:	40                   	inc    %eax
  80224c:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	8d 50 10             	lea    0x10(%eax),%edx
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	83 c0 10             	add    $0x10,%eax
  802269:	e9 b0 01 00 00       	jmp    80241e <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  80226e:	a1 48 41 90 00       	mov    0x904148,%eax
  802273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	74 08                	je     802284 <alloc_block_FF+0x198>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 40 08             	mov    0x8(%eax),%eax
  802282:	eb 05                	jmp    802289 <alloc_block_FF+0x19d>
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	a3 48 41 90 00       	mov    %eax,0x904148
  80228e:	a1 48 41 90 00       	mov    0x904148,%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	0f 85 bd fe ff ff    	jne    802158 <alloc_block_FF+0x6c>
  80229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229f:	0f 85 b3 fe ff ff    	jne    802158 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	83 c0 10             	add    $0x10,%eax
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	50                   	push   %eax
  8022af:	e8 27 f2 ff ff       	call   8014db <sbrk>
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  8022ba:	83 ec 0c             	sub    $0xc,%esp
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 17 f2 ff ff       	call   8014db <sbrk>
  8022c4:	83 c4 10             	add    $0x10,%esp
  8022c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8022ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d0:	29 c2                	sub    %eax,%edx
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8022d7:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8022db:	0f 84 38 01 00 00    	je     802419 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8022e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8022e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022eb:	75 17                	jne    802304 <alloc_block_FF+0x218>
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 20 3c 80 00       	push   $0x803c20
  8022f5:	68 9f 00 00 00       	push   $0x9f
  8022fa:	68 43 3c 80 00       	push   $0x803c43
  8022ff:	e8 07 e1 ff ff       	call   80040b <_panic>
  802304:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80230a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80230d:	89 50 0c             	mov    %edx,0xc(%eax)
  802310:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802313:	8b 40 0c             	mov    0xc(%eax),%eax
  802316:	85 c0                	test   %eax,%eax
  802318:	74 0d                	je     802327 <alloc_block_FF+0x23b>
  80231a:	a1 44 41 90 00       	mov    0x904144,%eax
  80231f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802322:	89 50 08             	mov    %edx,0x8(%eax)
  802325:	eb 08                	jmp    80232f <alloc_block_FF+0x243>
  802327:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80232a:	a3 40 41 90 00       	mov    %eax,0x904140
  80232f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802332:	a3 44 41 90 00       	mov    %eax,0x904144
  802337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80233a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802341:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802346:	40                   	inc    %eax
  802347:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	8d 50 10             	lea    0x10(%eax),%edx
  802352:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802355:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80235a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  80235e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802361:	2b 45 08             	sub    0x8(%ebp),%eax
  802364:	83 f8 10             	cmp    $0x10,%eax
  802367:	0f 84 a4 00 00 00    	je     802411 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  80236d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802370:	2b 45 08             	sub    0x8(%ebp),%eax
  802373:	83 e8 10             	sub    $0x10,%eax
  802376:	83 f8 0f             	cmp    $0xf,%eax
  802379:	0f 86 8a 00 00 00    	jbe    802409 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  80237f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	01 d0                	add    %edx,%eax
  802387:	83 c0 10             	add    $0x10,%eax
  80238a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  80238d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802391:	75 17                	jne    8023aa <alloc_block_FF+0x2be>
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 20 3c 80 00       	push   $0x803c20
  80239b:	68 a7 00 00 00       	push   $0xa7
  8023a0:	68 43 3c 80 00       	push   $0x803c43
  8023a5:	e8 61 e0 ff ff       	call   80040b <_panic>
  8023aa:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8023b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8023b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0d                	je     8023cd <alloc_block_FF+0x2e1>
  8023c0:	a1 44 41 90 00       	mov    0x904144,%eax
  8023c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023c8:	89 50 08             	mov    %edx,0x8(%eax)
  8023cb:	eb 08                	jmp    8023d5 <alloc_block_FF+0x2e9>
  8023cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d0:	a3 40 41 90 00       	mov    %eax,0x904140
  8023d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d8:	a3 44 41 90 00       	mov    %eax,0x904144
  8023dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023e7:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8023ec:	40                   	inc    %eax
  8023ed:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8023f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023f8:	8d 50 f0             	lea    -0x10(%eax),%edx
  8023fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023fe:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802403:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802407:	eb 08                	jmp    802411 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802409:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80240c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80240f:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802414:	83 c0 10             	add    $0x10,%eax
  802417:	eb 05                	jmp    80241e <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802426:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  80242d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802431:	75 0a                	jne    80243d <alloc_block_BF+0x1d>
	{
		return NULL;
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	e9 40 02 00 00       	jmp    80267d <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  80243d:	a1 40 41 90 00       	mov    0x904140,%eax
  802442:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802445:	eb 66                	jmp    8024ad <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8a 40 04             	mov    0x4(%eax),%al
  80244d:	3c 01                	cmp    $0x1,%al
  80244f:	75 21                	jne    802472 <alloc_block_BF+0x52>
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	8d 50 10             	lea    0x10(%eax),%edx
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	39 c2                	cmp    %eax,%edx
  80245e:	75 12                	jne    802472 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	83 c0 10             	add    $0x10,%eax
  80246d:	e9 0b 02 00 00       	jmp    80267d <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8a 40 04             	mov    0x4(%eax),%al
  802478:	3c 01                	cmp    $0x1,%al
  80247a:	75 29                	jne    8024a5 <alloc_block_BF+0x85>
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	8d 50 10             	lea    0x10(%eax),%edx
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	39 c2                	cmp    %eax,%edx
  802489:	77 1a                	ja     8024a5 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  80248b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248f:	74 0e                	je     80249f <alloc_block_BF+0x7f>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 10                	mov    (%eax),%edx
  802496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	39 c2                	cmp    %eax,%edx
  80249d:	73 06                	jae    8024a5 <alloc_block_BF+0x85>
			{
				BF = iterator;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  8024a5:	a1 48 41 90 00       	mov    0x904148,%eax
  8024aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	74 08                	je     8024bb <alloc_block_BF+0x9b>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 08             	mov    0x8(%eax),%eax
  8024b9:	eb 05                	jmp    8024c0 <alloc_block_BF+0xa0>
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c0:	a3 48 41 90 00       	mov    %eax,0x904148
  8024c5:	a1 48 41 90 00       	mov    0x904148,%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	0f 85 75 ff ff ff    	jne    802447 <alloc_block_BF+0x27>
  8024d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d6:	0f 85 6b ff ff ff    	jne    802447 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  8024dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e0:	0f 84 f8 00 00 00    	je     8025de <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	8d 50 10             	lea    0x10(%eax),%edx
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	39 c2                	cmp    %eax,%edx
  8024f3:	0f 87 e5 00 00 00    	ja     8025de <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	2b 45 08             	sub    0x8(%ebp),%eax
  802501:	83 e8 10             	sub    $0x10,%eax
  802504:	83 f8 0f             	cmp    $0xf,%eax
  802507:	0f 86 bf 00 00 00    	jbe    8025cc <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  80250d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	83 c0 10             	add    $0x10,%eax
  802518:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  80251b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	2b 45 08             	sub    0x8(%ebp),%eax
  80252c:	8d 50 f0             	lea    -0x10(%eax),%edx
  80252f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802532:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802537:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  80253b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80253f:	74 06                	je     802547 <alloc_block_BF+0x127>
  802541:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802545:	75 17                	jne    80255e <alloc_block_BF+0x13e>
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	68 5c 3c 80 00       	push   $0x803c5c
  80254f:	68 e3 00 00 00       	push   $0xe3
  802554:	68 43 3c 80 00       	push   $0x803c43
  802559:	e8 ad de ff ff       	call   80040b <_panic>
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802567:	89 50 08             	mov    %edx,0x8(%eax)
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 0c                	je     802580 <alloc_block_BF+0x160>
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	8b 40 08             	mov    0x8(%eax),%eax
  80257a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80257d:	89 50 0c             	mov    %edx,0xc(%eax)
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802586:	89 50 08             	mov    %edx,0x8(%eax)
  802589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258f:	89 50 0c             	mov    %edx,0xc(%eax)
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	8b 40 08             	mov    0x8(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	75 08                	jne    8025a4 <alloc_block_BF+0x184>
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	a3 44 41 90 00       	mov    %eax,0x904144
  8025a4:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8025a9:	40                   	inc    %eax
  8025aa:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	8d 50 10             	lea    0x10(%eax),%edx
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	83 c0 10             	add    $0x10,%eax
  8025c7:	e9 b1 00 00 00       	jmp    80267d <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	83 c0 10             	add    $0x10,%eax
  8025d9:	e9 9f 00 00 00       	jmp    80267d <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	83 c0 10             	add    $0x10,%eax
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	50                   	push   %eax
  8025e8:	e8 ee ee ff ff       	call   8014db <sbrk>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8025f3:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025f7:	74 7f                	je     802678 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8025f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025fd:	75 17                	jne    802616 <alloc_block_BF+0x1f6>
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	68 20 3c 80 00       	push   $0x803c20
  802607:	68 f6 00 00 00       	push   $0xf6
  80260c:	68 43 3c 80 00       	push   $0x803c43
  802611:	e8 f5 dd ff ff       	call   80040b <_panic>
  802616:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80261c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261f:	89 50 0c             	mov    %edx,0xc(%eax)
  802622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802625:	8b 40 0c             	mov    0xc(%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 0d                	je     802639 <alloc_block_BF+0x219>
  80262c:	a1 44 41 90 00       	mov    0x904144,%eax
  802631:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802634:	89 50 08             	mov    %edx,0x8(%eax)
  802637:	eb 08                	jmp    802641 <alloc_block_BF+0x221>
  802639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263c:	a3 40 41 90 00       	mov    %eax,0x904140
  802641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802644:	a3 44 41 90 00       	mov    %eax,0x904144
  802649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802653:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802658:	40                   	inc    %eax
  802659:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	8d 50 10             	lea    0x10(%eax),%edx
  802664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802667:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802673:	83 c0 10             	add    $0x10,%eax
  802676:	eb 05                	jmp    80267d <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
  802682:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802685:	83 ec 04             	sub    $0x4,%esp
  802688:	68 90 3c 80 00       	push   $0x803c90
  80268d:	68 07 01 00 00       	push   $0x107
  802692:	68 43 3c 80 00       	push   $0x803c43
  802697:	e8 6f dd ff ff       	call   80040b <_panic>

0080269c <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	68 b8 3c 80 00       	push   $0x803cb8
  8026aa:	68 0f 01 00 00       	push   $0x10f
  8026af:	68 43 3c 80 00       	push   $0x803c43
  8026b4:	e8 52 dd ff ff       	call   80040b <_panic>

008026b9 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
  8026bc:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  8026bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c3:	0f 84 ee 05 00 00    	je     802cb7 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	83 e8 10             	sub    $0x10,%eax
  8026cf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  8026d2:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026d6:	a1 40 41 90 00       	mov    0x904140,%eax
  8026db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026de:	eb 16                	jmp    8026f6 <free_block+0x3d>
	{
		if (block_pointer == it)
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026e6:	75 06                	jne    8026ee <free_block+0x35>
		{
			flagx = 1;
  8026e8:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  8026ec:	eb 2f                	jmp    80271d <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026ee:	a1 48 41 90 00       	mov    0x904148,%eax
  8026f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fa:	74 08                	je     802704 <free_block+0x4b>
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	8b 40 08             	mov    0x8(%eax),%eax
  802702:	eb 05                	jmp    802709 <free_block+0x50>
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	a3 48 41 90 00       	mov    %eax,0x904148
  80270e:	a1 48 41 90 00       	mov    0x904148,%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	75 c9                	jne    8026e0 <free_block+0x27>
  802717:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271b:	75 c3                	jne    8026e0 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  80271d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802721:	0f 84 93 05 00 00    	je     802cba <free_block+0x601>
		return;
	if (va == NULL)
  802727:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80272b:	0f 84 8c 05 00 00    	je     802cbd <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	8b 40 0c             	mov    0xc(%eax),%eax
  802737:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	8b 40 08             	mov    0x8(%eax),%eax
  802740:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802743:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802747:	75 12                	jne    80275b <free_block+0xa2>
  802749:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80274d:	75 0c                	jne    80275b <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802756:	e9 63 05 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  80275b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275f:	0f 85 ca 00 00 00    	jne    80282f <free_block+0x176>
  802765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802768:	8a 40 04             	mov    0x4(%eax),%al
  80276b:	3c 01                	cmp    $0x1,%al
  80276d:	0f 85 bc 00 00 00    	jne    80282f <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802776:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80277a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277d:	8b 10                	mov    (%eax),%edx
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	01 c2                	add    %eax,%edx
  802786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802789:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80278b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80279b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80279f:	75 17                	jne    8027b8 <free_block+0xff>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 de 3c 80 00       	push   $0x803cde
  8027a9:	68 3c 01 00 00       	push   $0x13c
  8027ae:	68 43 3c 80 00       	push   $0x803c43
  8027b3:	e8 53 dc ff ff       	call   80040b <_panic>
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 40 08             	mov    0x8(%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	74 11                	je     8027d3 <free_block+0x11a>
  8027c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c5:	8b 40 08             	mov    0x8(%eax),%eax
  8027c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8027ce:	89 50 0c             	mov    %edx,0xc(%eax)
  8027d1:	eb 0b                	jmp    8027de <free_block+0x125>
  8027d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	a3 44 41 90 00       	mov    %eax,0x904144
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 11                	je     8027f9 <free_block+0x140>
  8027e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f1:	8b 52 08             	mov    0x8(%edx),%edx
  8027f4:	89 50 08             	mov    %edx,0x8(%eax)
  8027f7:	eb 0b                	jmp    802804 <free_block+0x14b>
  8027f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fc:	8b 40 08             	mov    0x8(%eax),%eax
  8027ff:	a3 40 41 90 00       	mov    %eax,0x904140
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80280e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802811:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802818:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80281d:	48                   	dec    %eax
  80281e:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802823:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80282a:	e9 8f 04 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  80282f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802833:	75 16                	jne    80284b <free_block+0x192>
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	8a 40 04             	mov    0x4(%eax),%al
  80283b:	84 c0                	test   %al,%al
  80283d:	75 0c                	jne    80284b <free_block+0x192>
	{
		block_pointer->is_free = 1;
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802846:	e9 73 04 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  80284b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80284f:	0f 85 c3 00 00 00    	jne    802918 <free_block+0x25f>
  802855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802858:	8a 40 04             	mov    0x4(%eax),%al
  80285b:	3c 01                	cmp    $0x1,%al
  80285d:	0f 85 b5 00 00 00    	jne    802918 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802866:	8b 10                	mov    (%eax),%edx
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802872:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802884:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802888:	75 17                	jne    8028a1 <free_block+0x1e8>
  80288a:	83 ec 04             	sub    $0x4,%esp
  80288d:	68 de 3c 80 00       	push   $0x803cde
  802892:	68 49 01 00 00       	push   $0x149
  802897:	68 43 3c 80 00       	push   $0x803c43
  80289c:	e8 6a db ff ff       	call   80040b <_panic>
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	8b 40 08             	mov    0x8(%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 11                	je     8028bc <free_block+0x203>
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 40 08             	mov    0x8(%eax),%eax
  8028b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8028b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8028ba:	eb 0b                	jmp    8028c7 <free_block+0x20e>
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	a3 44 41 90 00       	mov    %eax,0x904144
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 11                	je     8028e2 <free_block+0x229>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028da:	8b 52 08             	mov    0x8(%edx),%edx
  8028dd:	89 50 08             	mov    %edx,0x8(%eax)
  8028e0:	eb 0b                	jmp    8028ed <free_block+0x234>
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	8b 40 08             	mov    0x8(%eax),%eax
  8028e8:	a3 40 41 90 00       	mov    %eax,0x904140
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802901:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802906:	48                   	dec    %eax
  802907:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  80290c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802913:	e9 a6 03 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802918:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80291c:	75 16                	jne    802934 <free_block+0x27b>
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	8a 40 04             	mov    0x4(%eax),%al
  802924:	84 c0                	test   %al,%al
  802926:	75 0c                	jne    802934 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80292f:	e9 8a 03 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802938:	0f 84 81 01 00 00    	je     802abf <free_block+0x406>
  80293e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802942:	0f 84 77 01 00 00    	je     802abf <free_block+0x406>
  802948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294b:	8a 40 04             	mov    0x4(%eax),%al
  80294e:	3c 01                	cmp    $0x1,%al
  802950:	0f 85 69 01 00 00    	jne    802abf <free_block+0x406>
  802956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802959:	8a 40 04             	mov    0x4(%eax),%al
  80295c:	3c 01                	cmp    $0x1,%al
  80295e:	0f 85 5b 01 00 00    	jne    802abf <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	8b 10                	mov    (%eax),%edx
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	8b 08                	mov    (%eax),%ecx
  80296e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	01 c8                	add    %ecx,%eax
  802975:	01 c2                	add    %eax,%edx
  802977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297a:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80297c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802988:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802998:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80299c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a0:	75 17                	jne    8029b9 <free_block+0x300>
  8029a2:	83 ec 04             	sub    $0x4,%esp
  8029a5:	68 de 3c 80 00       	push   $0x803cde
  8029aa:	68 59 01 00 00       	push   $0x159
  8029af:	68 43 3c 80 00       	push   $0x803c43
  8029b4:	e8 52 da ff ff       	call   80040b <_panic>
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	8b 40 08             	mov    0x8(%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 11                	je     8029d4 <free_block+0x31b>
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	8b 40 08             	mov    0x8(%eax),%eax
  8029c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8029cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8029d2:	eb 0b                	jmp    8029df <free_block+0x326>
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	a3 44 41 90 00       	mov    %eax,0x904144
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 11                	je     8029fa <free_block+0x341>
  8029e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f2:	8b 52 08             	mov    0x8(%edx),%edx
  8029f5:	89 50 08             	mov    %edx,0x8(%eax)
  8029f8:	eb 0b                	jmp    802a05 <free_block+0x34c>
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	8b 40 08             	mov    0x8(%eax),%eax
  802a00:	a3 40 41 90 00       	mov    %eax,0x904140
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a19:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a1e:	48                   	dec    %eax
  802a1f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802a24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a28:	75 17                	jne    802a41 <free_block+0x388>
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	68 de 3c 80 00       	push   $0x803cde
  802a32:	68 5a 01 00 00       	push   $0x15a
  802a37:	68 43 3c 80 00       	push   $0x803c43
  802a3c:	e8 ca d9 ff ff       	call   80040b <_panic>
  802a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 11                	je     802a5c <free_block+0x3a3>
  802a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4e:	8b 40 08             	mov    0x8(%eax),%eax
  802a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a54:	8b 52 0c             	mov    0xc(%edx),%edx
  802a57:	89 50 0c             	mov    %edx,0xc(%eax)
  802a5a:	eb 0b                	jmp    802a67 <free_block+0x3ae>
  802a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	a3 44 41 90 00       	mov    %eax,0x904144
  802a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 11                	je     802a82 <free_block+0x3c9>
  802a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a7a:	8b 52 08             	mov    0x8(%edx),%edx
  802a7d:	89 50 08             	mov    %edx,0x8(%eax)
  802a80:	eb 0b                	jmp    802a8d <free_block+0x3d4>
  802a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	a3 40 41 90 00       	mov    %eax,0x904140
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802aa1:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802aa6:	48                   	dec    %eax
  802aa7:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802ab3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802aba:	e9 ff 01 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ac3:	0f 84 db 00 00 00    	je     802ba4 <free_block+0x4eb>
  802ac9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802acd:	0f 84 d1 00 00 00    	je     802ba4 <free_block+0x4eb>
  802ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad6:	8a 40 04             	mov    0x4(%eax),%al
  802ad9:	84 c0                	test   %al,%al
  802adb:	0f 85 c3 00 00 00    	jne    802ba4 <free_block+0x4eb>
  802ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae4:	8a 40 04             	mov    0x4(%eax),%al
  802ae7:	3c 01                	cmp    $0x1,%al
  802ae9:	0f 85 b5 00 00 00    	jne    802ba4 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af2:	8b 10                	mov    (%eax),%edx
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	01 c2                	add    %eax,%edx
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802b10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b14:	75 17                	jne    802b2d <free_block+0x474>
  802b16:	83 ec 04             	sub    $0x4,%esp
  802b19:	68 de 3c 80 00       	push   $0x803cde
  802b1e:	68 64 01 00 00       	push   $0x164
  802b23:	68 43 3c 80 00       	push   $0x803c43
  802b28:	e8 de d8 ff ff       	call   80040b <_panic>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 11                	je     802b48 <free_block+0x48f>
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 40 08             	mov    0x8(%eax),%eax
  802b3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b40:	8b 52 0c             	mov    0xc(%edx),%edx
  802b43:	89 50 0c             	mov    %edx,0xc(%eax)
  802b46:	eb 0b                	jmp    802b53 <free_block+0x49a>
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	a3 44 41 90 00       	mov    %eax,0x904144
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 11                	je     802b6e <free_block+0x4b5>
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	8b 40 0c             	mov    0xc(%eax),%eax
  802b63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b66:	8b 52 08             	mov    0x8(%edx),%edx
  802b69:	89 50 08             	mov    %edx,0x8(%eax)
  802b6c:	eb 0b                	jmp    802b79 <free_block+0x4c0>
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	a3 40 41 90 00       	mov    %eax,0x904140
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b8d:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802b92:	48                   	dec    %eax
  802b93:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802b98:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802b9f:	e9 1a 01 00 00       	jmp    802cbe <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802ba4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ba8:	0f 84 df 00 00 00    	je     802c8d <free_block+0x5d4>
  802bae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb2:	0f 84 d5 00 00 00    	je     802c8d <free_block+0x5d4>
  802bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbb:	8a 40 04             	mov    0x4(%eax),%al
  802bbe:	3c 01                	cmp    $0x1,%al
  802bc0:	0f 85 c7 00 00 00    	jne    802c8d <free_block+0x5d4>
  802bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc9:	8a 40 04             	mov    0x4(%eax),%al
  802bcc:	84 c0                	test   %al,%al
  802bce:	0f 85 b9 00 00 00    	jne    802c8d <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 10                	mov    (%eax),%edx
  802be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	01 c2                	add    %eax,%edx
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802bfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c00:	75 17                	jne    802c19 <free_block+0x560>
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	68 de 3c 80 00       	push   $0x803cde
  802c0a:	68 6e 01 00 00       	push   $0x16e
  802c0f:	68 43 3c 80 00       	push   $0x803c43
  802c14:	e8 f2 d7 ff ff       	call   80040b <_panic>
  802c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 11                	je     802c34 <free_block+0x57b>
  802c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2c:	8b 52 0c             	mov    0xc(%edx),%edx
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
  802c32:	eb 0b                	jmp    802c3f <free_block+0x586>
  802c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	a3 44 41 90 00       	mov    %eax,0x904144
  802c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 11                	je     802c5a <free_block+0x5a1>
  802c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c52:	8b 52 08             	mov    0x8(%edx),%edx
  802c55:	89 50 08             	mov    %edx,0x8(%eax)
  802c58:	eb 0b                	jmp    802c65 <free_block+0x5ac>
  802c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	a3 40 41 90 00       	mov    %eax,0x904140
  802c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c79:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c7e:	48                   	dec    %eax
  802c7f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802c84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802c8b:	eb 31                	jmp    802cbe <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802c8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c91:	74 2b                	je     802cbe <free_block+0x605>
  802c93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c97:	74 25                	je     802cbe <free_block+0x605>
  802c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9c:	8a 40 04             	mov    0x4(%eax),%al
  802c9f:	84 c0                	test   %al,%al
  802ca1:	75 1b                	jne    802cbe <free_block+0x605>
  802ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca6:	8a 40 04             	mov    0x4(%eax),%al
  802ca9:	84 c0                	test   %al,%al
  802cab:	75 11                	jne    802cbe <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802cb4:	90                   	nop
  802cb5:	eb 07                	jmp    802cbe <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802cb7:	90                   	nop
  802cb8:	eb 04                	jmp    802cbe <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802cba:	90                   	nop
  802cbb:	eb 01                	jmp    802cbe <free_block+0x605>
	if (va == NULL)
		return;
  802cbd:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

00802cc0 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802cc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cca:	75 19                	jne    802ce5 <realloc_block_FF+0x25>
  802ccc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd0:	74 13                	je     802ce5 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	ff 75 0c             	pushl  0xc(%ebp)
  802cd8:	e8 0f f4 ff ff       	call   8020ec <alloc_block_FF>
  802cdd:	83 c4 10             	add    $0x10,%esp
  802ce0:	e9 ea 03 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  802ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce9:	75 3b                	jne    802d26 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  802cf1:	83 ec 0c             	sub    $0xc,%esp
  802cf4:	6a 00                	push   $0x0
  802cf6:	e8 f1 f3 ff ff       	call   8020ec <alloc_block_FF>
  802cfb:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802d03:	e9 c7 03 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  802d08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0c:	74 18                	je     802d26 <realloc_block_FF+0x66>
		{
			free_block(va);
  802d0e:	83 ec 0c             	sub    $0xc,%esp
  802d11:	ff 75 08             	pushl  0x8(%ebp)
  802d14:	e8 a0 f9 ff ff       	call   8026b9 <free_block>
  802d19:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	e9 a9 03 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  802d26:	a1 40 41 90 00       	mov    0x904140,%eax
  802d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d2e:	e9 68 03 00 00       	jmp    80309b <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	83 e8 10             	sub    $0x10,%eax
  802d39:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d3c:	0f 85 51 03 00 00    	jne    803093 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d4a:	83 c2 10             	add    $0x10,%edx
  802d4d:	39 d0                	cmp    %edx,%eax
  802d4f:	75 08                	jne    802d59 <realloc_block_FF+0x99>
			{
				return va;
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	e9 76 03 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d61:	0f 83 45 02 00 00    	jae    802fac <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
  802d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8a 40 04             	mov    0x4(%eax),%al
  802d76:	3c 01                	cmp    $0x1,%al
  802d78:	0f 85 6b 01 00 00    	jne    802ee9 <realloc_block_FF+0x229>
  802d7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d82:	0f 84 61 01 00 00    	je     802ee9 <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 10                	mov    (%eax),%edx
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d95:	29 c1                	sub    %eax,%ecx
  802d97:	89 c8                	mov    %ecx,%eax
  802d99:	39 c2                	cmp    %eax,%edx
  802d9b:	0f 86 e3 00 00 00    	jbe    802e84 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 10                	mov    (%eax),%edx
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	2b 45 0c             	sub    0xc(%ebp),%eax
  802dae:	01 d0                	add    %edx,%eax
  802db0:	83 f8 0f             	cmp    $0xf,%eax
  802db3:	0f 86 b5 00 00 00    	jbe    802e6e <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  802db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	83 c0 10             	add    $0x10,%eax
  802dc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  802dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	74 06                	je     802de3 <realloc_block_FF+0x123>
  802ddd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802de1:	75 17                	jne    802dfa <realloc_block_FF+0x13a>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 5c 3c 80 00       	push   $0x803c5c
  802deb:	68 ae 01 00 00       	push   $0x1ae
  802df0:	68 43 3c 80 00       	push   $0x803c43
  802df5:	e8 11 d6 ff ff       	call   80040b <_panic>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 50 08             	mov    0x8(%eax),%edx
  802e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e03:	89 50 08             	mov    %edx,0x8(%eax)
  802e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0c                	je     802e1c <realloc_block_FF+0x15c>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 08             	mov    0x8(%eax),%eax
  802e16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e19:	89 50 0c             	mov    %edx,0xc(%eax)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e22:	89 50 08             	mov    %edx,0x8(%eax)
  802e25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	89 50 0c             	mov    %edx,0xc(%eax)
  802e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e31:	8b 40 08             	mov    0x8(%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	75 08                	jne    802e40 <realloc_block_FF+0x180>
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	a3 44 41 90 00       	mov    %eax,0x904144
  802e40:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802e45:	40                   	inc    %eax
  802e46:	a3 4c 41 90 00       	mov    %eax,0x90414c
							next->size = 0;
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  802e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5e:	8d 50 10             	lea    0x10(%eax),%edx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	89 10                	mov    %edx,(%eax)
							return va;
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	e9 61 02 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	8d 50 10             	lea    0x10(%eax),%edx
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	83 c0 10             	add    $0x10,%eax
  802e7f:	e9 4b 02 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  802e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e87:	8b 10                	mov    (%eax),%edx
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e91:	29 c1                	sub    %eax,%ecx
  802e93:	89 c8                	mov    %ecx,%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 83 f5 01 00 00    	jae    803092 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802e9d:	83 ec 0c             	sub    $0xc,%esp
  802ea0:	ff 75 0c             	pushl  0xc(%ebp)
  802ea3:	e8 44 f2 ff ff       	call   8020ec <alloc_block_FF>
  802ea8:	83 c4 10             	add    $0x10,%esp
  802eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  802eae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eb2:	74 2d                	je     802ee1 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	50                   	push   %eax
  802ebd:	ff 75 08             	pushl  0x8(%ebp)
  802ec0:	ff 75 ec             	pushl  -0x14(%ebp)
  802ec3:	e8 a0 e0 ff ff       	call   800f68 <memcpy>
  802ec8:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	e8 e3 f7 ff ff       	call   8026b9 <free_block>
  802ed6:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	e9 ee 01 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	e9 e6 01 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	8a 40 04             	mov    0x4(%eax),%al
  802eef:	3c 01                	cmp    $0x1,%al
  802ef1:	75 59                	jne    802f4c <realloc_block_FF+0x28c>
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 10                	mov    (%eax),%edx
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 00                	mov    (%eax),%eax
  802efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f00:	29 c1                	sub    %eax,%ecx
  802f02:	89 c8                	mov    %ecx,%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	75 44                	jne    802f4c <realloc_block_FF+0x28c>
  802f08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0c:	74 3e                	je     802f4c <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	8b 40 08             	mov    0x8(%eax),%eax
  802f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1d:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f26:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3c:	8d 50 10             	lea    0x10(%eax),%edx
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	89 10                	mov    %edx,(%eax)
					return va;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	e9 83 01 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	8a 40 04             	mov    0x4(%eax),%al
  802f52:	84 c0                	test   %al,%al
  802f54:	74 0a                	je     802f60 <realloc_block_FF+0x2a0>
  802f56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5a:	0f 85 33 01 00 00    	jne    803093 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802f60:	83 ec 0c             	sub    $0xc,%esp
  802f63:	ff 75 0c             	pushl  0xc(%ebp)
  802f66:	e8 81 f1 ff ff       	call   8020ec <alloc_block_FF>
  802f6b:	83 c4 10             	add    $0x10,%esp
  802f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  802f71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f75:	74 2d                	je     802fa4 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	50                   	push   %eax
  802f80:	ff 75 08             	pushl  0x8(%ebp)
  802f83:	ff 75 e0             	pushl  -0x20(%ebp)
  802f86:	e8 dd df ff ff       	call   800f68 <memcpy>
  802f8b:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  802f8e:	83 ec 0c             	sub    $0xc,%esp
  802f91:	ff 75 08             	pushl  0x8(%ebp)
  802f94:	e8 20 f7 ff ff       	call   8026b9 <free_block>
  802f99:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9f:	e9 2b 01 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	e9 23 01 00 00       	jmp    8030cf <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fb4:	0f 86 d9 00 00 00    	jbe    803093 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fc2:	83 f8 0f             	cmp    $0xf,%eax
  802fc5:	0f 86 b4 00 00 00    	jbe    80307f <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	01 d0                	add    %edx,%eax
  802fd3:	83 c0 10             	add    $0x10,%eax
  802fd6:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fe1:	8d 50 f0             	lea    -0x10(%eax),%edx
  802fe4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe7:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fed:	74 06                	je     802ff5 <realloc_block_FF+0x335>
  802fef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ff3:	75 17                	jne    80300c <realloc_block_FF+0x34c>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 5c 3c 80 00       	push   $0x803c5c
  802ffd:	68 ed 01 00 00       	push   $0x1ed
  803002:	68 43 3c 80 00       	push   $0x803c43
  803007:	e8 ff d3 ff ff       	call   80040b <_panic>
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 50 08             	mov    0x8(%eax),%edx
  803012:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803015:	89 50 08             	mov    %edx,0x8(%eax)
  803018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301b:	8b 40 08             	mov    0x8(%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0c                	je     80302e <realloc_block_FF+0x36e>
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 40 08             	mov    0x8(%eax),%eax
  803028:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80302b:	89 50 0c             	mov    %edx,0xc(%eax)
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803034:	89 50 08             	mov    %edx,0x8(%eax)
  803037:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303d:	89 50 0c             	mov    %edx,0xc(%eax)
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	8b 40 08             	mov    0x8(%eax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	75 08                	jne    803052 <realloc_block_FF+0x392>
  80304a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304d:	a3 44 41 90 00       	mov    %eax,0x904144
  803052:	a1 4c 41 90 00       	mov    0x90414c,%eax
  803057:	40                   	inc    %eax
  803058:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  80305d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803060:	83 c0 10             	add    $0x10,%eax
  803063:	83 ec 0c             	sub    $0xc,%esp
  803066:	50                   	push   %eax
  803067:	e8 4d f6 ff ff       	call   8026b9 <free_block>
  80306c:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  80306f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803072:	8d 50 10             	lea    0x10(%eax),%edx
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	89 10                	mov    %edx,(%eax)
					return va;
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	eb 50                	jmp    8030cf <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80307f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803082:	8d 50 10             	lea    0x10(%eax),%edx
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	83 c0 10             	add    $0x10,%eax
  803090:	eb 3d                	jmp    8030cf <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803092:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803093:	a1 48 41 90 00       	mov    0x904148,%eax
  803098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309f:	74 08                	je     8030a9 <realloc_block_FF+0x3e9>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 08             	mov    0x8(%eax),%eax
  8030a7:	eb 05                	jmp    8030ae <realloc_block_FF+0x3ee>
  8030a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ae:	a3 48 41 90 00       	mov    %eax,0x904148
  8030b3:	a1 48 41 90 00       	mov    0x904148,%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	0f 85 73 fc ff ff    	jne    802d33 <realloc_block_FF+0x73>
  8030c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c4:	0f 85 69 fc ff ff    	jne    802d33 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8030ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    
  8030d1:	66 90                	xchg   %ax,%ax
  8030d3:	90                   	nop

008030d4 <__udivdi3>:
  8030d4:	55                   	push   %ebp
  8030d5:	57                   	push   %edi
  8030d6:	56                   	push   %esi
  8030d7:	53                   	push   %ebx
  8030d8:	83 ec 1c             	sub    $0x1c,%esp
  8030db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030eb:	89 ca                	mov    %ecx,%edx
  8030ed:	89 f8                	mov    %edi,%eax
  8030ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030f3:	85 f6                	test   %esi,%esi
  8030f5:	75 2d                	jne    803124 <__udivdi3+0x50>
  8030f7:	39 cf                	cmp    %ecx,%edi
  8030f9:	77 65                	ja     803160 <__udivdi3+0x8c>
  8030fb:	89 fd                	mov    %edi,%ebp
  8030fd:	85 ff                	test   %edi,%edi
  8030ff:	75 0b                	jne    80310c <__udivdi3+0x38>
  803101:	b8 01 00 00 00       	mov    $0x1,%eax
  803106:	31 d2                	xor    %edx,%edx
  803108:	f7 f7                	div    %edi
  80310a:	89 c5                	mov    %eax,%ebp
  80310c:	31 d2                	xor    %edx,%edx
  80310e:	89 c8                	mov    %ecx,%eax
  803110:	f7 f5                	div    %ebp
  803112:	89 c1                	mov    %eax,%ecx
  803114:	89 d8                	mov    %ebx,%eax
  803116:	f7 f5                	div    %ebp
  803118:	89 cf                	mov    %ecx,%edi
  80311a:	89 fa                	mov    %edi,%edx
  80311c:	83 c4 1c             	add    $0x1c,%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    
  803124:	39 ce                	cmp    %ecx,%esi
  803126:	77 28                	ja     803150 <__udivdi3+0x7c>
  803128:	0f bd fe             	bsr    %esi,%edi
  80312b:	83 f7 1f             	xor    $0x1f,%edi
  80312e:	75 40                	jne    803170 <__udivdi3+0x9c>
  803130:	39 ce                	cmp    %ecx,%esi
  803132:	72 0a                	jb     80313e <__udivdi3+0x6a>
  803134:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803138:	0f 87 9e 00 00 00    	ja     8031dc <__udivdi3+0x108>
  80313e:	b8 01 00 00 00       	mov    $0x1,%eax
  803143:	89 fa                	mov    %edi,%edx
  803145:	83 c4 1c             	add    $0x1c,%esp
  803148:	5b                   	pop    %ebx
  803149:	5e                   	pop    %esi
  80314a:	5f                   	pop    %edi
  80314b:	5d                   	pop    %ebp
  80314c:	c3                   	ret    
  80314d:	8d 76 00             	lea    0x0(%esi),%esi
  803150:	31 ff                	xor    %edi,%edi
  803152:	31 c0                	xor    %eax,%eax
  803154:	89 fa                	mov    %edi,%edx
  803156:	83 c4 1c             	add    $0x1c,%esp
  803159:	5b                   	pop    %ebx
  80315a:	5e                   	pop    %esi
  80315b:	5f                   	pop    %edi
  80315c:	5d                   	pop    %ebp
  80315d:	c3                   	ret    
  80315e:	66 90                	xchg   %ax,%ax
  803160:	89 d8                	mov    %ebx,%eax
  803162:	f7 f7                	div    %edi
  803164:	31 ff                	xor    %edi,%edi
  803166:	89 fa                	mov    %edi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	bd 20 00 00 00       	mov    $0x20,%ebp
  803175:	89 eb                	mov    %ebp,%ebx
  803177:	29 fb                	sub    %edi,%ebx
  803179:	89 f9                	mov    %edi,%ecx
  80317b:	d3 e6                	shl    %cl,%esi
  80317d:	89 c5                	mov    %eax,%ebp
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 ed                	shr    %cl,%ebp
  803183:	89 e9                	mov    %ebp,%ecx
  803185:	09 f1                	or     %esi,%ecx
  803187:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e0                	shl    %cl,%eax
  80318f:	89 c5                	mov    %eax,%ebp
  803191:	89 d6                	mov    %edx,%esi
  803193:	88 d9                	mov    %bl,%cl
  803195:	d3 ee                	shr    %cl,%esi
  803197:	89 f9                	mov    %edi,%ecx
  803199:	d3 e2                	shl    %cl,%edx
  80319b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80319f:	88 d9                	mov    %bl,%cl
  8031a1:	d3 e8                	shr    %cl,%eax
  8031a3:	09 c2                	or     %eax,%edx
  8031a5:	89 d0                	mov    %edx,%eax
  8031a7:	89 f2                	mov    %esi,%edx
  8031a9:	f7 74 24 0c          	divl   0xc(%esp)
  8031ad:	89 d6                	mov    %edx,%esi
  8031af:	89 c3                	mov    %eax,%ebx
  8031b1:	f7 e5                	mul    %ebp
  8031b3:	39 d6                	cmp    %edx,%esi
  8031b5:	72 19                	jb     8031d0 <__udivdi3+0xfc>
  8031b7:	74 0b                	je     8031c4 <__udivdi3+0xf0>
  8031b9:	89 d8                	mov    %ebx,%eax
  8031bb:	31 ff                	xor    %edi,%edi
  8031bd:	e9 58 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031c2:	66 90                	xchg   %ax,%ax
  8031c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031c8:	89 f9                	mov    %edi,%ecx
  8031ca:	d3 e2                	shl    %cl,%edx
  8031cc:	39 c2                	cmp    %eax,%edx
  8031ce:	73 e9                	jae    8031b9 <__udivdi3+0xe5>
  8031d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031d3:	31 ff                	xor    %edi,%edi
  8031d5:	e9 40 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	31 c0                	xor    %eax,%eax
  8031de:	e9 37 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031e3:	90                   	nop

008031e4 <__umoddi3>:
  8031e4:	55                   	push   %ebp
  8031e5:	57                   	push   %edi
  8031e6:	56                   	push   %esi
  8031e7:	53                   	push   %ebx
  8031e8:	83 ec 1c             	sub    $0x1c,%esp
  8031eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803203:	89 f3                	mov    %esi,%ebx
  803205:	89 fa                	mov    %edi,%edx
  803207:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320b:	89 34 24             	mov    %esi,(%esp)
  80320e:	85 c0                	test   %eax,%eax
  803210:	75 1a                	jne    80322c <__umoddi3+0x48>
  803212:	39 f7                	cmp    %esi,%edi
  803214:	0f 86 a2 00 00 00    	jbe    8032bc <__umoddi3+0xd8>
  80321a:	89 c8                	mov    %ecx,%eax
  80321c:	89 f2                	mov    %esi,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d0                	mov    %edx,%eax
  803222:	31 d2                	xor    %edx,%edx
  803224:	83 c4 1c             	add    $0x1c,%esp
  803227:	5b                   	pop    %ebx
  803228:	5e                   	pop    %esi
  803229:	5f                   	pop    %edi
  80322a:	5d                   	pop    %ebp
  80322b:	c3                   	ret    
  80322c:	39 f0                	cmp    %esi,%eax
  80322e:	0f 87 ac 00 00 00    	ja     8032e0 <__umoddi3+0xfc>
  803234:	0f bd e8             	bsr    %eax,%ebp
  803237:	83 f5 1f             	xor    $0x1f,%ebp
  80323a:	0f 84 ac 00 00 00    	je     8032ec <__umoddi3+0x108>
  803240:	bf 20 00 00 00       	mov    $0x20,%edi
  803245:	29 ef                	sub    %ebp,%edi
  803247:	89 fe                	mov    %edi,%esi
  803249:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 e0                	shl    %cl,%eax
  803251:	89 d7                	mov    %edx,%edi
  803253:	89 f1                	mov    %esi,%ecx
  803255:	d3 ef                	shr    %cl,%edi
  803257:	09 c7                	or     %eax,%edi
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	d3 e2                	shl    %cl,%edx
  80325d:	89 14 24             	mov    %edx,(%esp)
  803260:	89 d8                	mov    %ebx,%eax
  803262:	d3 e0                	shl    %cl,%eax
  803264:	89 c2                	mov    %eax,%edx
  803266:	8b 44 24 08          	mov    0x8(%esp),%eax
  80326a:	d3 e0                	shl    %cl,%eax
  80326c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803270:	8b 44 24 08          	mov    0x8(%esp),%eax
  803274:	89 f1                	mov    %esi,%ecx
  803276:	d3 e8                	shr    %cl,%eax
  803278:	09 d0                	or     %edx,%eax
  80327a:	d3 eb                	shr    %cl,%ebx
  80327c:	89 da                	mov    %ebx,%edx
  80327e:	f7 f7                	div    %edi
  803280:	89 d3                	mov    %edx,%ebx
  803282:	f7 24 24             	mull   (%esp)
  803285:	89 c6                	mov    %eax,%esi
  803287:	89 d1                	mov    %edx,%ecx
  803289:	39 d3                	cmp    %edx,%ebx
  80328b:	0f 82 87 00 00 00    	jb     803318 <__umoddi3+0x134>
  803291:	0f 84 91 00 00 00    	je     803328 <__umoddi3+0x144>
  803297:	8b 54 24 04          	mov    0x4(%esp),%edx
  80329b:	29 f2                	sub    %esi,%edx
  80329d:	19 cb                	sbb    %ecx,%ebx
  80329f:	89 d8                	mov    %ebx,%eax
  8032a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032a5:	d3 e0                	shl    %cl,%eax
  8032a7:	89 e9                	mov    %ebp,%ecx
  8032a9:	d3 ea                	shr    %cl,%edx
  8032ab:	09 d0                	or     %edx,%eax
  8032ad:	89 e9                	mov    %ebp,%ecx
  8032af:	d3 eb                	shr    %cl,%ebx
  8032b1:	89 da                	mov    %ebx,%edx
  8032b3:	83 c4 1c             	add    $0x1c,%esp
  8032b6:	5b                   	pop    %ebx
  8032b7:	5e                   	pop    %esi
  8032b8:	5f                   	pop    %edi
  8032b9:	5d                   	pop    %ebp
  8032ba:	c3                   	ret    
  8032bb:	90                   	nop
  8032bc:	89 fd                	mov    %edi,%ebp
  8032be:	85 ff                	test   %edi,%edi
  8032c0:	75 0b                	jne    8032cd <__umoddi3+0xe9>
  8032c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c7:	31 d2                	xor    %edx,%edx
  8032c9:	f7 f7                	div    %edi
  8032cb:	89 c5                	mov    %eax,%ebp
  8032cd:	89 f0                	mov    %esi,%eax
  8032cf:	31 d2                	xor    %edx,%edx
  8032d1:	f7 f5                	div    %ebp
  8032d3:	89 c8                	mov    %ecx,%eax
  8032d5:	f7 f5                	div    %ebp
  8032d7:	89 d0                	mov    %edx,%eax
  8032d9:	e9 44 ff ff ff       	jmp    803222 <__umoddi3+0x3e>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	89 c8                	mov    %ecx,%eax
  8032e2:	89 f2                	mov    %esi,%edx
  8032e4:	83 c4 1c             	add    $0x1c,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    
  8032ec:	3b 04 24             	cmp    (%esp),%eax
  8032ef:	72 06                	jb     8032f7 <__umoddi3+0x113>
  8032f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032f5:	77 0f                	ja     803306 <__umoddi3+0x122>
  8032f7:	89 f2                	mov    %esi,%edx
  8032f9:	29 f9                	sub    %edi,%ecx
  8032fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032ff:	89 14 24             	mov    %edx,(%esp)
  803302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803306:	8b 44 24 04          	mov    0x4(%esp),%eax
  80330a:	8b 14 24             	mov    (%esp),%edx
  80330d:	83 c4 1c             	add    $0x1c,%esp
  803310:	5b                   	pop    %ebx
  803311:	5e                   	pop    %esi
  803312:	5f                   	pop    %edi
  803313:	5d                   	pop    %ebp
  803314:	c3                   	ret    
  803315:	8d 76 00             	lea    0x0(%esi),%esi
  803318:	2b 04 24             	sub    (%esp),%eax
  80331b:	19 fa                	sbb    %edi,%edx
  80331d:	89 d1                	mov    %edx,%ecx
  80331f:	89 c6                	mov    %eax,%esi
  803321:	e9 71 ff ff ff       	jmp    803297 <__umoddi3+0xb3>
  803326:	66 90                	xchg   %ax,%ax
  803328:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80332c:	72 ea                	jb     803318 <__umoddi3+0x134>
  80332e:	89 d9                	mov    %ebx,%ecx
  803330:	e9 62 ff ff ff       	jmp    803297 <__umoddi3+0xb3>
