
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
  800060:	68 c0 32 80 00       	push   $0x8032c0
  800065:	6a 14                	push   $0x14
  800067:	68 dc 32 80 00       	push   $0x8032dc
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
  8000bc:	e8 51 18 00 00       	call   801912 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 94 18 00 00       	call   80195d <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 16 14 00 00       	call   8014f3 <malloc>
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
  800100:	e8 06 03 00 00       	call   80040b <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 53 18 00 00       	call   80195d <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 33 80 00       	push   $0x803328
  800117:	6a 34                	push   $0x34
  800119:	68 dc 32 80 00       	push   $0x8032dc
  80011e:	e8 e8 02 00 00       	call   80040b <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 ea 17 00 00       	call   801912 <sys_calculate_free_frames>
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
  80015f:	e8 ae 17 00 00       	call   801912 <sys_calculate_free_frames>
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
  8001c7:	e8 63 1c 00 00       	call   801e2f <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 33 80 00       	push   $0x8033d4
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 dc 32 80 00       	push   $0x8032dc
  8001e7:	e8 1f 02 00 00       	call   80040b <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 21 17 00 00       	call   801912 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 64 17 00 00       	call   80195d <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 44 14 00 00       	call   80164f <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 4a 17 00 00       	call   80195d <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 33 80 00       	push   $0x8033f4
  800220:	6a 4f                	push   $0x4f
  800222:	68 dc 32 80 00       	push   $0x8032dc
  800227:	e8 df 01 00 00       	call   80040b <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 e1 16 00 00       	call   801912 <sys_calculate_free_frames>
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
  80028d:	e8 9d 1b 00 00       	call   801e2f <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 34 80 00       	push   $0x80347c
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 dc 32 80 00       	push   $0x8032dc
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
  8002c4:	e8 12 1a 00 00       	call   801cdb <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	68 a0 34 80 00       	push   $0x8034a0
  8002d1:	6a 5b                	push   $0x5b
  8002d3:	68 dc 32 80 00       	push   $0x8032dc
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
  8002e3:	e8 b5 18 00 00       	call   801b9d <sys_getenvindex>
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
  800340:	e8 65 16 00 00       	call   8019aa <sys_disable_interrupt>
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 04 35 80 00       	push   $0x803504
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
  800370:	68 2c 35 80 00       	push   $0x80352c
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
  8003a1:	68 54 35 80 00       	push   $0x803554
  8003a6:	e8 1d 03 00 00       	call   8006c8 <cprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b3:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	50                   	push   %eax
  8003bd:	68 ac 35 80 00       	push   $0x8035ac
  8003c2:	e8 01 03 00 00       	call   8006c8 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	68 04 35 80 00       	push   $0x803504
  8003d2:	e8 f1 02 00 00       	call   8006c8 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003da:	e8 e5 15 00 00       	call   8019c4 <sys_enable_interrupt>

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
  8003f2:	e8 72 17 00 00       	call   801b69 <sys_destroy_env>
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
  800403:	e8 c7 17 00 00       	call   801bcf <sys_exit_env>
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
  80042c:	68 c0 35 80 00       	push   $0x8035c0
  800431:	e8 92 02 00 00       	call   8006c8 <cprintf>
  800436:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800439:	a1 00 40 80 00       	mov    0x804000,%eax
  80043e:	ff 75 0c             	pushl  0xc(%ebp)
  800441:	ff 75 08             	pushl  0x8(%ebp)
  800444:	50                   	push   %eax
  800445:	68 c5 35 80 00       	push   $0x8035c5
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
  800469:	68 e1 35 80 00       	push   $0x8035e1
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
  800498:	68 e4 35 80 00       	push   $0x8035e4
  80049d:	6a 26                	push   $0x26
  80049f:	68 30 36 80 00       	push   $0x803630
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
  80056d:	68 3c 36 80 00       	push   $0x80363c
  800572:	6a 3a                	push   $0x3a
  800574:	68 30 36 80 00       	push   $0x803630
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
  8005e0:	68 90 36 80 00       	push   $0x803690
  8005e5:	6a 44                	push   $0x44
  8005e7:	68 30 36 80 00       	push   $0x803630
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
  80063a:	e8 12 12 00 00       	call   801851 <sys_cputs>
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
  8006b1:	e8 9b 11 00 00       	call   801851 <sys_cputs>
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
  8006fb:	e8 aa 12 00 00       	call   8019aa <sys_disable_interrupt>
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
  80071b:	e8 a4 12 00 00       	call   8019c4 <sys_enable_interrupt>
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
  800765:	e8 f2 28 00 00       	call   80305c <__udivdi3>
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
  8007b5:	e8 b2 29 00 00       	call   80316c <__umoddi3>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	05 f4 38 80 00       	add    $0x8038f4,%eax
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
  800910:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
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
  8009f1:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8009f8:	85 f6                	test   %esi,%esi
  8009fa:	75 19                	jne    800a15 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009fc:	53                   	push   %ebx
  8009fd:	68 05 39 80 00       	push   $0x803905
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
  800a16:	68 0e 39 80 00       	push   $0x80390e
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
  800a43:	be 11 39 80 00       	mov    $0x803911,%esi
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
	return NULL;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  8014c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 0a                	je     8014da <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014d7:	00 00 00 
	}
}
  8014da:	90                   	nop
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    

008014dd <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014e3:	83 ec 0c             	sub    $0xc,%esp
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	e8 7e 09 00 00       	call   801e6c <sys_sbrk>
  8014ee:	83 c4 10             	add    $0x10,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f9:	e8 c6 ff ff ff       	call   8014c4 <InitializeUHeap>
	if (size == 0)
  8014fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801502:	75 0a                	jne    80150e <malloc+0x1b>
		return NULL;
  801504:	b8 00 00 00 00       	mov    $0x0,%eax
  801509:	e9 3f 01 00 00       	jmp    80164d <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80150e:	e8 ac 09 00 00       	call   801ebf <sys_get_hard_limit>
  801513:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  80151d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801520:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801525:	c1 e8 0c             	shr    $0xc,%eax
  801528:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  80152b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801532:	8b 55 08             	mov    0x8(%ebp),%edx
  801535:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801538:	01 d0                	add    %edx,%eax
  80153a:	48                   	dec    %eax
  80153b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80153e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801541:	ba 00 00 00 00       	mov    $0x0,%edx
  801546:	f7 75 d8             	divl   -0x28(%ebp)
  801549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80154c:	29 d0                	sub    %edx,%eax
  80154e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801551:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801554:	c1 e8 0c             	shr    $0xc,%eax
  801557:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  80155a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155e:	75 0a                	jne    80156a <malloc+0x77>
		return NULL;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	e9 e3 00 00 00       	jmp    80164d <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  80156a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156d:	05 00 00 00 80       	add    $0x80000000,%eax
  801572:	c1 e8 0c             	shr    $0xc,%eax
  801575:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80157a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801581:	77 19                	ja     80159c <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	e8 44 0b 00 00       	call   8020d2 <alloc_block_FF>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801594:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801597:	e9 b1 00 00 00       	jmp    80164d <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80159c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015a2:	eb 4d                	jmp    8015f1 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  8015a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a7:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015ae:	84 c0                	test   %al,%al
  8015b0:	75 27                	jne    8015d9 <malloc+0xe6>
			{
				counter++;
  8015b2:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  8015b5:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8015b9:	75 14                	jne    8015cf <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  8015bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015be:	05 00 00 08 00       	add    $0x80000,%eax
  8015c3:	c1 e0 0c             	shl    $0xc,%eax
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  8015c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015d5:	75 17                	jne    8015ee <malloc+0xfb>
				{
					break;
  8015d7:	eb 21                	jmp    8015fa <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  8015d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015dc:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015e3:	3c 01                	cmp    $0x1,%al
  8015e5:	75 07                	jne    8015ee <malloc+0xfb>
			{
				counter = 0;
  8015e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  8015ee:	ff 45 e8             	incl   -0x18(%ebp)
  8015f1:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8015f8:	76 aa                	jbe    8015a4 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8015fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fd:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801600:	75 46                	jne    801648 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	ff 75 d0             	pushl  -0x30(%ebp)
  801608:	ff 75 f4             	pushl  -0xc(%ebp)
  80160b:	e8 93 08 00 00       	call   801ea3 <sys_allocate_user_mem>
  801610:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801616:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801619:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801626:	eb 0e                	jmp    801636 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162b:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  801632:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801633:	ff 45 e4             	incl   -0x1c(%ebp)
  801636:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	01 d0                	add    %edx,%eax
  80163e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801641:	77 e5                	ja     801628 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	eb 05                	jmp    80164d <malloc+0x15a>
		}
	}

	return NULL;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801655:	e8 65 08 00 00       	call   801ebf <sys_get_hard_limit>
  80165a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801663:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801667:	0f 84 c1 00 00 00    	je     80172e <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  80166d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	79 1b                	jns    80168f <free+0x40>
  801674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801677:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80167a:	73 13                	jae    80168f <free+0x40>
    {
        free_block(virtual_address);
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	e8 18 10 00 00       	call   80269f <free_block>
  801687:	83 c4 10             	add    $0x10,%esp
    	return;
  80168a:	e9 a6 00 00 00       	jmp    801735 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	05 00 10 00 00       	add    $0x1000,%eax
  801697:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80169a:	0f 87 91 00 00 00    	ja     801731 <free+0xe2>
  8016a0:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016a7:	0f 87 84 00 00 00    	ja     801731 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  8016ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  8016be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c1:	05 00 00 00 80       	add    $0x80000000,%eax
  8016c6:	c1 e8 0c             	shr    $0xc,%eax
  8016c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  8016cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016cf:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8016d6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  8016d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016dd:	74 55                	je     801734 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  8016df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e2:	c1 e8 0c             	shr    $0xc,%eax
  8016e5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  8016e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016eb:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  8016f2:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8016f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fc:	eb 0e                	jmp    80170c <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  801708:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801709:	ff 45 f4             	incl   -0xc(%ebp)
  80170c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80170f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801712:	01 c2                	add    %eax,%edx
  801714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801717:	39 c2                	cmp    %eax,%edx
  801719:	77 e3                	ja     8016fe <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	ff 75 e0             	pushl  -0x20(%ebp)
  801721:	ff 75 ec             	pushl  -0x14(%ebp)
  801724:	e8 5e 07 00 00       	call   801e87 <sys_free_user_mem>
  801729:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  80172c:	eb 07                	jmp    801735 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  80172e:	90                   	nop
  80172f:	eb 04                	jmp    801735 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801731:	90                   	nop
  801732:	eb 01                	jmp    801735 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801734:	90                   	nop
    else
     {
    	return;
      }

}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 18             	sub    $0x18,%esp
  80173d:	8b 45 10             	mov    0x10(%ebp),%eax
  801740:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801743:	e8 7c fd ff ff       	call   8014c4 <InitializeUHeap>
	if (size == 0)
  801748:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174c:	75 07                	jne    801755 <smalloc+0x1e>
		return NULL;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	eb 17                	jmp    80176c <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	68 70 3a 80 00       	push   $0x803a70
  80175d:	68 ad 00 00 00       	push   $0xad
  801762:	68 96 3a 80 00       	push   $0x803a96
  801767:	e8 9f ec ff ff       	call   80040b <_panic>
	return NULL;
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801774:	e8 4b fd ff ff       	call   8014c4 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	68 a4 3a 80 00       	push   $0x803aa4
  801781:	68 ba 00 00 00       	push   $0xba
  801786:	68 96 3a 80 00       	push   $0x803a96
  80178b:	e8 7b ec ff ff       	call   80040b <_panic>

00801790 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801796:	e8 29 fd ff ff       	call   8014c4 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 c8 3a 80 00       	push   $0x803ac8
  8017a3:	68 d8 00 00 00       	push   $0xd8
  8017a8:	68 96 3a 80 00       	push   $0x803a96
  8017ad:	e8 59 ec ff ff       	call   80040b <_panic>

008017b2 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 f0 3a 80 00       	push   $0x803af0
  8017c0:	68 ea 00 00 00       	push   $0xea
  8017c5:	68 96 3a 80 00       	push   $0x803a96
  8017ca:	e8 3c ec ff ff       	call   80040b <_panic>

008017cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 14 3b 80 00       	push   $0x803b14
  8017dd:	68 f2 00 00 00       	push   $0xf2
  8017e2:	68 96 3a 80 00       	push   $0x803a96
  8017e7:	e8 1f ec ff ff       	call   80040b <_panic>

008017ec <shrink>:

}
void shrink(uint32 newSize) {
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 14 3b 80 00       	push   $0x803b14
  8017fa:	68 f6 00 00 00       	push   $0xf6
  8017ff:	68 96 3a 80 00       	push   $0x803a96
  801804:	e8 02 ec ff ff       	call   80040b <_panic>

00801809 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 14 3b 80 00       	push   $0x803b14
  801817:	68 fa 00 00 00       	push   $0xfa
  80181c:	68 96 3a 80 00       	push   $0x803a96
  801821:	e8 e5 eb ff ff       	call   80040b <_panic>

00801826 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801838:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801841:	cd 30                	int    $0x30
  801843:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	5b                   	pop    %ebx
  80184d:	5e                   	pop    %esi
  80184e:	5f                   	pop    %edi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    

00801851 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	52                   	push   %edx
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	50                   	push   %eax
  80186d:	6a 00                	push   $0x0
  80186f:	e8 b2 ff ff ff       	call   801826 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_cgetc>:

int
sys_cgetc(void)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 01                	push   $0x1
  801889:	e8 98 ff ff ff       	call   801826 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 05                	push   $0x5
  8018a6:	e8 7b ff ff ff       	call   801826 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	56                   	push   %esi
  8018b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	51                   	push   %ecx
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 06                	push   $0x6
  8018cb:	e8 56 ff ff ff       	call   801826 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d6:	5b                   	pop    %ebx
  8018d7:	5e                   	pop    %esi
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    

008018da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	52                   	push   %edx
  8018ea:	50                   	push   %eax
  8018eb:	6a 07                	push   $0x7
  8018ed:	e8 34 ff ff ff       	call   801826 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 08                	push   $0x8
  801908:	e8 19 ff ff ff       	call   801826 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 09                	push   $0x9
  801921:	e8 00 ff ff ff       	call   801826 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 0a                	push   $0xa
  80193a:	e8 e7 fe ff ff       	call   801826 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 0b                	push   $0xb
  801953:	e8 ce fe ff ff       	call   801826 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 0c                	push   $0xc
  80196c:	e8 b5 fe ff ff       	call   801826 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 0d                	push   $0xd
  801986:	e8 9b fe ff ff       	call   801826 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 0e                	push   $0xe
  80199f:	e8 82 fe ff ff       	call   801826 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 11                	push   $0x11
  8019b9:	e8 68 fe ff ff       	call   801826 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 12                	push   $0x12
  8019d3:	e8 4e fe ff ff       	call   801826 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_cputc>:


void
sys_cputc(const char c)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	50                   	push   %eax
  8019f7:	6a 13                	push   $0x13
  8019f9:	e8 28 fe ff ff       	call   801826 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 14                	push   $0x14
  801a13:	e8 0e fe ff ff       	call   801826 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	90                   	nop
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	50                   	push   %eax
  801a2e:	6a 15                	push   $0x15
  801a30:	e8 f1 fd ff ff       	call   801826 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	52                   	push   %edx
  801a4a:	50                   	push   %eax
  801a4b:	6a 18                	push   $0x18
  801a4d:	e8 d4 fd ff ff       	call   801826 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	52                   	push   %edx
  801a67:	50                   	push   %eax
  801a68:	6a 16                	push   $0x16
  801a6a:	e8 b7 fd ff ff       	call   801826 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	90                   	nop
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 17                	push   $0x17
  801a88:	e8 99 fd ff ff       	call   801826 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	51                   	push   %ecx
  801aac:	52                   	push   %edx
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	6a 19                	push   $0x19
  801ab3:	e8 6e fd ff ff       	call   801826 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 1a                	push   $0x1a
  801ad0:	e8 51 fd ff ff       	call   801826 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801add:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	51                   	push   %ecx
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 1b                	push   $0x1b
  801aef:	e8 32 fd ff ff       	call   801826 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 1c                	push   $0x1c
  801b0c:	e8 15 fd ff ff       	call   801826 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 1d                	push   $0x1d
  801b25:	e8 fc fc ff ff       	call   801826 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	ff 75 14             	pushl  0x14(%ebp)
  801b3a:	ff 75 10             	pushl  0x10(%ebp)
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	6a 1e                	push   $0x1e
  801b43:	e8 de fc ff ff       	call   801826 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	50                   	push   %eax
  801b5c:	6a 1f                	push   $0x1f
  801b5e:	e8 c3 fc ff ff       	call   801826 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	50                   	push   %eax
  801b78:	6a 20                	push   $0x20
  801b7a:	e8 a7 fc ff ff       	call   801826 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 02                	push   $0x2
  801b93:	e8 8e fc ff ff       	call   801826 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 03                	push   $0x3
  801bac:	e8 75 fc ff ff       	call   801826 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 04                	push   $0x4
  801bc5:	e8 5c fc ff ff       	call   801826 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_exit_env>:


void sys_exit_env(void)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 21                	push   $0x21
  801bde:	e8 43 fc ff ff       	call   801826 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf2:	8d 50 04             	lea    0x4(%eax),%edx
  801bf5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 22                	push   $0x22
  801c02:	e8 1f fc ff ff       	call   801826 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c13:	89 01                	mov    %eax,(%ecx)
  801c15:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	c9                   	leave  
  801c1c:	c2 04 00             	ret    $0x4

00801c1f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 10                	push   $0x10
  801c31:	e8 f0 fb ff ff       	call   801826 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return ;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 23                	push   $0x23
  801c4b:	e8 d6 fb ff ff       	call   801826 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c61:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	50                   	push   %eax
  801c6e:	6a 24                	push   $0x24
  801c70:	e8 b1 fb ff ff       	call   801826 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
	return ;
  801c78:	90                   	nop
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <rsttst>:
void rsttst()
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 26                	push   $0x26
  801c8a:	e8 97 fb ff ff       	call   801826 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	ff 75 10             	pushl  0x10(%ebp)
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	6a 25                	push   $0x25
  801cb5:	e8 6c fb ff ff       	call   801826 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbd:	90                   	nop
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <chktst>:
void chktst(uint32 n)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	6a 27                	push   $0x27
  801cd0:	e8 51 fb ff ff       	call   801826 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <inctst>:

void inctst()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 28                	push   $0x28
  801cea:	e8 37 fb ff ff       	call   801826 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf2:	90                   	nop
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <gettst>:
uint32 gettst()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 29                	push   $0x29
  801d04:	e8 1d fb ff ff       	call   801826 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 2a                	push   $0x2a
  801d20:	e8 01 fb ff ff       	call   801826 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
  801d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d2f:	75 07                	jne    801d38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	eb 05                	jmp    801d3d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 2a                	push   $0x2a
  801d51:	e8 d0 fa ff ff       	call   801826 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
  801d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d60:	75 07                	jne    801d69 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	eb 05                	jmp    801d6e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 2a                	push   $0x2a
  801d82:	e8 9f fa ff ff       	call   801826 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
  801d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d8d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d91:	75 07                	jne    801d9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d93:	b8 01 00 00 00       	mov    $0x1,%eax
  801d98:	eb 05                	jmp    801d9f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 2a                	push   $0x2a
  801db3:	e8 6e fa ff ff       	call   801826 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
  801dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dbe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc2:	75 07                	jne    801dcb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc9:	eb 05                	jmp    801dd0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 2b                	push   $0x2b
  801de2:	e8 3f fa ff ff       	call   801826 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	6a 00                	push   $0x0
  801dff:	53                   	push   %ebx
  801e00:	51                   	push   %ecx
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	6a 2c                	push   $0x2c
  801e05:	e8 1c fa ff ff       	call   801826 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 2d                	push   $0x2d
  801e25:	e8 fc f9 ff ff       	call   801826 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	51                   	push   %ecx
  801e3e:	ff 75 10             	pushl  0x10(%ebp)
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 2e                	push   $0x2e
  801e45:	e8 dc f9 ff ff       	call   801826 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 10             	pushl  0x10(%ebp)
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 0f                	push   $0xf
  801e61:	e8 c0 f9 ff ff       	call   801826 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	50                   	push   %eax
  801e7b:	6a 2f                	push   $0x2f
  801e7d:	e8 a4 f9 ff ff       	call   801826 <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp

}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 30                	push   $0x30
  801e98:	e8 89 f9 ff ff       	call   801826 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	6a 31                	push   $0x31
  801eb4:	e8 6d f9 ff ff       	call   801826 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
	return;
  801ebc:	90                   	nop
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 32                	push   $0x32
  801ece:	e8 53 f9 ff ff       	call   801826 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	83 e8 10             	sub    $0x10,%eax
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eea:	8b 00                	mov    (%eax),%eax
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	83 e8 10             	sub    $0x10,%eax
  801efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f00:	8a 40 04             	mov    0x4(%eax),%al
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	83 f8 02             	cmp    $0x2,%eax
  801f18:	74 2b                	je     801f45 <alloc_block+0x40>
  801f1a:	83 f8 02             	cmp    $0x2,%eax
  801f1d:	7f 07                	jg     801f26 <alloc_block+0x21>
  801f1f:	83 f8 01             	cmp    $0x1,%eax
  801f22:	74 0e                	je     801f32 <alloc_block+0x2d>
  801f24:	eb 58                	jmp    801f7e <alloc_block+0x79>
  801f26:	83 f8 03             	cmp    $0x3,%eax
  801f29:	74 2d                	je     801f58 <alloc_block+0x53>
  801f2b:	83 f8 04             	cmp    $0x4,%eax
  801f2e:	74 3b                	je     801f6b <alloc_block+0x66>
  801f30:	eb 4c                	jmp    801f7e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	e8 95 01 00 00       	call   8020d2 <alloc_block_FF>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f43:	eb 4a                	jmp    801f8f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	e8 32 07 00 00       	call   802682 <alloc_block_NF>
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f56:	eb 37                	jmp    801f8f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	e8 a3 04 00 00       	call   802406 <alloc_block_BF>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f69:	eb 24                	jmp    801f8f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	e8 ef 06 00 00       	call   802665 <alloc_block_WF>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f7c:	eb 11                	jmp    801f8f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	68 24 3b 80 00       	push   $0x803b24
  801f86:	e8 3d e7 ff ff       	call   8006c8 <cprintf>
  801f8b:	83 c4 10             	add    $0x10,%esp
		break;
  801f8e:	90                   	nop
	}
	return va;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	68 44 3b 80 00       	push   $0x803b44
  801fa2:	e8 21 e7 ff ff       	call   8006c8 <cprintf>
  801fa7:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	68 6f 3b 80 00       	push   $0x803b6f
  801fb2:	e8 11 e7 ff ff       	call   8006c8 <cprintf>
  801fb7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc0:	eb 26                	jmp    801fe8 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	8a 40 04             	mov    0x4(%eax),%al
  801fc8:	0f b6 d0             	movzbl %al,%edx
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	83 ec 04             	sub    $0x4,%esp
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	68 87 3b 80 00       	push   $0x803b87
  801fda:	e8 e9 e6 ff ff       	call   8006c8 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fec:	74 08                	je     801ff6 <print_blocks_list+0x62>
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 40 08             	mov    0x8(%eax),%eax
  801ff4:	eb 05                	jmp    801ffb <print_blocks_list+0x67>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	89 45 10             	mov    %eax,0x10(%ebp)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	75 bd                	jne    801fc2 <print_blocks_list+0x2e>
  802005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802009:	75 b7                	jne    801fc2 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	68 44 3b 80 00       	push   $0x803b44
  802013:	e8 b0 e6 ff ff       	call   8006c8 <cprintf>
  802018:	83 c4 10             	add    $0x10,%esp

}
  80201b:	90                   	nop
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802028:	0f 84 a1 00 00 00    	je     8020cf <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  80202e:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  802035:	00 00 00 
	LIST_INIT(&list);
  802038:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  80203f:	00 00 00 
  802042:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  802049:	00 00 00 
  80204c:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  802053:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 55 0c             	mov    0xc(%ebp),%edx
  802069:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  80206b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206f:	75 14                	jne    802085 <initialize_dynamic_allocator+0x67>
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 a0 3b 80 00       	push   $0x803ba0
  802079:	6a 64                	push   $0x64
  80207b:	68 c3 3b 80 00       	push   $0x803bc3
  802080:	e8 86 e3 ff ff       	call   80040b <_panic>
  802085:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	89 50 0c             	mov    %edx,0xc(%eax)
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 40 0c             	mov    0xc(%eax),%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 0d                	je     8020a8 <initialize_dynamic_allocator+0x8a>
  80209b:	a1 44 41 90 00       	mov    0x904144,%eax
  8020a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a3:	89 50 08             	mov    %edx,0x8(%eax)
  8020a6:	eb 08                	jmp    8020b0 <initialize_dynamic_allocator+0x92>
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	a3 40 41 90 00       	mov    %eax,0x904140
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	a3 44 41 90 00       	mov    %eax,0x904144
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020c2:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8020c7:	40                   	inc    %eax
  8020c8:	a3 4c 41 90 00       	mov    %eax,0x90414c
  8020cd:	eb 01                	jmp    8020d0 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8020cf:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8020d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020dc:	75 0a                	jne    8020e8 <alloc_block_FF+0x16>
	{
		return NULL;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e3:	e9 1c 03 00 00       	jmp    802404 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8020e8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 40                	jne    802131 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	83 c0 10             	add    $0x10,%eax
  8020f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8020fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	50                   	push   %eax
  802101:	e8 d7 f3 ff ff       	call   8014dd <sbrk>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	6a 00                	push   $0x0
  802111:	e8 c7 f3 ff ff       	call   8014dd <sbrk>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  80211c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802122:	83 ec 08             	sub    $0x8,%esp
  802125:	50                   	push   %eax
  802126:	ff 75 ec             	pushl  -0x14(%ebp)
  802129:	e8 f0 fe ff ff       	call   80201e <initialize_dynamic_allocator>
  80212e:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802131:	a1 40 41 90 00       	mov    0x904140,%eax
  802136:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802139:	e9 1e 01 00 00       	jmp    80225c <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8d 50 10             	lea    0x10(%eax),%edx
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	39 c2                	cmp    %eax,%edx
  80214b:	75 1c                	jne    802169 <alloc_block_FF+0x97>
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8a 40 04             	mov    0x4(%eax),%al
  802153:	3c 01                	cmp    $0x1,%al
  802155:	75 12                	jne    802169 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	83 c0 10             	add    $0x10,%eax
  802164:	e9 9b 02 00 00       	jmp    802404 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8d 50 10             	lea    0x10(%eax),%edx
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	39 c2                	cmp    %eax,%edx
  802176:	0f 83 d8 00 00 00    	jae    802254 <alloc_block_FF+0x182>
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8a 40 04             	mov    0x4(%eax),%al
  802182:	3c 01                	cmp    $0x1,%al
  802184:	0f 85 ca 00 00 00    	jne    802254 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	2b 45 08             	sub    0x8(%ebp),%eax
  802192:	83 e8 10             	sub    $0x10,%eax
  802195:	83 f8 0f             	cmp    $0xf,%eax
  802198:	0f 86 a4 00 00 00    	jbe    802242 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	83 c0 10             	add    $0x10,%eax
  8021a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8021b4:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ba:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8021bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021bf:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	74 06                	je     8021cf <alloc_block_FF+0xfd>
  8021c9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021cd:	75 17                	jne    8021e6 <alloc_block_FF+0x114>
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	68 dc 3b 80 00       	push   $0x803bdc
  8021d7:	68 8f 00 00 00       	push   $0x8f
  8021dc:	68 c3 3b 80 00       	push   $0x803bc3
  8021e1:	e8 25 e2 ff ff       	call   80040b <_panic>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 50 08             	mov    0x8(%eax),%edx
  8021ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ef:	89 50 08             	mov    %edx,0x8(%eax)
  8021f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	74 0c                	je     802208 <alloc_block_FF+0x136>
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802205:	89 50 0c             	mov    %edx,0xc(%eax)
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80220e:	89 50 08             	mov    %edx,0x8(%eax)
  802211:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802217:	89 50 0c             	mov    %edx,0xc(%eax)
  80221a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80221d:	8b 40 08             	mov    0x8(%eax),%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	75 08                	jne    80222c <alloc_block_FF+0x15a>
  802224:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802227:	a3 44 41 90 00       	mov    %eax,0x904144
  80222c:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802231:	40                   	inc    %eax
  802232:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8d 50 10             	lea    0x10(%eax),%edx
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	83 c0 10             	add    $0x10,%eax
  80224f:	e9 b0 01 00 00       	jmp    802404 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802254:	a1 48 41 90 00       	mov    0x904148,%eax
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	74 08                	je     80226a <alloc_block_FF+0x198>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	eb 05                	jmp    80226f <alloc_block_FF+0x19d>
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	a3 48 41 90 00       	mov    %eax,0x904148
  802274:	a1 48 41 90 00       	mov    0x904148,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	0f 85 bd fe ff ff    	jne    80213e <alloc_block_FF+0x6c>
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	0f 85 b3 fe ff ff    	jne    80213e <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	83 c0 10             	add    $0x10,%eax
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	50                   	push   %eax
  802295:	e8 43 f2 ff ff       	call   8014dd <sbrk>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 33 f2 ff ff       	call   8014dd <sbrk>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8022b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b6:	29 c2                	sub    %eax,%edx
  8022b8:	89 d0                	mov    %edx,%eax
  8022ba:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8022bd:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8022c1:	0f 84 38 01 00 00    	je     8023ff <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8022c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8022cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022d1:	75 17                	jne    8022ea <alloc_block_FF+0x218>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 a0 3b 80 00       	push   $0x803ba0
  8022db:	68 9f 00 00 00       	push   $0x9f
  8022e0:	68 c3 3b 80 00       	push   $0x803bc3
  8022e5:	e8 21 e1 ff ff       	call   80040b <_panic>
  8022ea:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8022f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f3:	89 50 0c             	mov    %edx,0xc(%eax)
  8022f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 0d                	je     80230d <alloc_block_FF+0x23b>
  802300:	a1 44 41 90 00       	mov    0x904144,%eax
  802305:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802308:	89 50 08             	mov    %edx,0x8(%eax)
  80230b:	eb 08                	jmp    802315 <alloc_block_FF+0x243>
  80230d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802310:	a3 40 41 90 00       	mov    %eax,0x904140
  802315:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802318:	a3 44 41 90 00       	mov    %eax,0x904144
  80231d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802320:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802327:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80232c:	40                   	inc    %eax
  80232d:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8d 50 10             	lea    0x10(%eax),%edx
  802338:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80233b:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  80233d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802340:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802344:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802347:	2b 45 08             	sub    0x8(%ebp),%eax
  80234a:	83 f8 10             	cmp    $0x10,%eax
  80234d:	0f 84 a4 00 00 00    	je     8023f7 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802356:	2b 45 08             	sub    0x8(%ebp),%eax
  802359:	83 e8 10             	sub    $0x10,%eax
  80235c:	83 f8 0f             	cmp    $0xf,%eax
  80235f:	0f 86 8a 00 00 00    	jbe    8023ef <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802365:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	01 d0                	add    %edx,%eax
  80236d:	83 c0 10             	add    $0x10,%eax
  802370:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802373:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802377:	75 17                	jne    802390 <alloc_block_FF+0x2be>
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 a0 3b 80 00       	push   $0x803ba0
  802381:	68 a7 00 00 00       	push   $0xa7
  802386:	68 c3 3b 80 00       	push   $0x803bc3
  80238b:	e8 7b e0 ff ff       	call   80040b <_panic>
  802390:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802399:	89 50 0c             	mov    %edx,0xc(%eax)
  80239c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239f:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 0d                	je     8023b3 <alloc_block_FF+0x2e1>
  8023a6:	a1 44 41 90 00       	mov    0x904144,%eax
  8023ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023ae:	89 50 08             	mov    %edx,0x8(%eax)
  8023b1:	eb 08                	jmp    8023bb <alloc_block_FF+0x2e9>
  8023b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b6:	a3 40 41 90 00       	mov    %eax,0x904140
  8023bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023be:	a3 44 41 90 00       	mov    %eax,0x904144
  8023c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023cd:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8023d2:	40                   	inc    %eax
  8023d3:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8023d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023db:	2b 45 08             	sub    0x8(%ebp),%eax
  8023de:	8d 50 f0             	lea    -0x10(%eax),%edx
  8023e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e4:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8023e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8023ed:	eb 08                	jmp    8023f7 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  8023ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023f5:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  8023f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023fa:	83 c0 10             	add    $0x10,%eax
  8023fd:	eb 05                	jmp    802404 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  80240c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802417:	75 0a                	jne    802423 <alloc_block_BF+0x1d>
	{
		return NULL;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
  80241e:	e9 40 02 00 00       	jmp    802663 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802423:	a1 40 41 90 00       	mov    0x904140,%eax
  802428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242b:	eb 66                	jmp    802493 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8a 40 04             	mov    0x4(%eax),%al
  802433:	3c 01                	cmp    $0x1,%al
  802435:	75 21                	jne    802458 <alloc_block_BF+0x52>
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	8d 50 10             	lea    0x10(%eax),%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	39 c2                	cmp    %eax,%edx
  802444:	75 12                	jne    802458 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	83 c0 10             	add    $0x10,%eax
  802453:	e9 0b 02 00 00       	jmp    802663 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8a 40 04             	mov    0x4(%eax),%al
  80245e:	3c 01                	cmp    $0x1,%al
  802460:	75 29                	jne    80248b <alloc_block_BF+0x85>
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	8d 50 10             	lea    0x10(%eax),%edx
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	39 c2                	cmp    %eax,%edx
  80246f:	77 1a                	ja     80248b <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802471:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802475:	74 0e                	je     802485 <alloc_block_BF+0x7f>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 10                	mov    (%eax),%edx
  80247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	39 c2                	cmp    %eax,%edx
  802483:	73 06                	jae    80248b <alloc_block_BF+0x85>
			{
				BF = iterator;
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  80248b:	a1 48 41 90 00       	mov    0x904148,%eax
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	74 08                	je     8024a1 <alloc_block_BF+0x9b>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 08             	mov    0x8(%eax),%eax
  80249f:	eb 05                	jmp    8024a6 <alloc_block_BF+0xa0>
  8024a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a6:	a3 48 41 90 00       	mov    %eax,0x904148
  8024ab:	a1 48 41 90 00       	mov    0x904148,%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	0f 85 75 ff ff ff    	jne    80242d <alloc_block_BF+0x27>
  8024b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bc:	0f 85 6b ff ff ff    	jne    80242d <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  8024c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c6:	0f 84 f8 00 00 00    	je     8025c4 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8d 50 10             	lea    0x10(%eax),%edx
  8024d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	39 c2                	cmp    %eax,%edx
  8024d9:	0f 87 e5 00 00 00    	ja     8025c4 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e7:	83 e8 10             	sub    $0x10,%eax
  8024ea:	83 f8 0f             	cmp    $0xf,%eax
  8024ed:	0f 86 bf 00 00 00    	jbe    8025b2 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  8024f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	01 d0                	add    %edx,%eax
  8024fb:	83 c0 10             	add    $0x10,%eax
  8024fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	2b 45 08             	sub    0x8(%ebp),%eax
  802512:	8d 50 f0             	lea    -0x10(%eax),%edx
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802525:	74 06                	je     80252d <alloc_block_BF+0x127>
  802527:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80252b:	75 17                	jne    802544 <alloc_block_BF+0x13e>
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 dc 3b 80 00       	push   $0x803bdc
  802535:	68 e3 00 00 00       	push   $0xe3
  80253a:	68 c3 3b 80 00       	push   $0x803bc3
  80253f:	e8 c7 de ff ff       	call   80040b <_panic>
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	8b 50 08             	mov    0x8(%eax),%edx
  80254a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254d:	89 50 08             	mov    %edx,0x8(%eax)
  802550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802553:	8b 40 08             	mov    0x8(%eax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 0c                	je     802566 <alloc_block_BF+0x160>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 40 08             	mov    0x8(%eax),%eax
  802560:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802563:	89 50 0c             	mov    %edx,0xc(%eax)
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
  80256f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802575:	89 50 0c             	mov    %edx,0xc(%eax)
  802578:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257b:	8b 40 08             	mov    0x8(%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	75 08                	jne    80258a <alloc_block_BF+0x184>
  802582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802585:	a3 44 41 90 00       	mov    %eax,0x904144
  80258a:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80258f:	40                   	inc    %eax
  802590:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8d 50 10             	lea    0x10(%eax),%edx
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	83 c0 10             	add    $0x10,%eax
  8025ad:	e9 b1 00 00 00       	jmp    802663 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	83 c0 10             	add    $0x10,%eax
  8025bf:	e9 9f 00 00 00       	jmp    802663 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	83 c0 10             	add    $0x10,%eax
  8025ca:	83 ec 0c             	sub    $0xc,%esp
  8025cd:	50                   	push   %eax
  8025ce:	e8 0a ef ff ff       	call   8014dd <sbrk>
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8025d9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025dd:	74 7f                	je     80265e <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8025df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e3:	75 17                	jne    8025fc <alloc_block_BF+0x1f6>
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	68 a0 3b 80 00       	push   $0x803ba0
  8025ed:	68 f6 00 00 00       	push   $0xf6
  8025f2:	68 c3 3b 80 00       	push   $0x803bc3
  8025f7:	e8 0f de ff ff       	call   80040b <_panic>
  8025fc:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802605:	89 50 0c             	mov    %edx,0xc(%eax)
  802608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	74 0d                	je     80261f <alloc_block_BF+0x219>
  802612:	a1 44 41 90 00       	mov    0x904144,%eax
  802617:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80261a:	89 50 08             	mov    %edx,0x8(%eax)
  80261d:	eb 08                	jmp    802627 <alloc_block_BF+0x221>
  80261f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802622:	a3 40 41 90 00       	mov    %eax,0x904140
  802627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262a:	a3 44 41 90 00       	mov    %eax,0x904144
  80262f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802632:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802639:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80263e:	40                   	inc    %eax
  80263f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	8d 50 10             	lea    0x10(%eax),%edx
  80264a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264d:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  80264f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802652:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802659:	83 c0 10             	add    $0x10,%eax
  80265c:	eb 05                	jmp    802663 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 10 3c 80 00       	push   $0x803c10
  802673:	68 07 01 00 00       	push   $0x107
  802678:	68 c3 3b 80 00       	push   $0x803bc3
  80267d:	e8 89 dd ff ff       	call   80040b <_panic>

00802682 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 38 3c 80 00       	push   $0x803c38
  802690:	68 0f 01 00 00       	push   $0x10f
  802695:	68 c3 3b 80 00       	push   $0x803bc3
  80269a:	e8 6c dd ff ff       	call   80040b <_panic>

0080269f <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  8026a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a9:	0f 84 ee 05 00 00    	je     802c9d <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	83 e8 10             	sub    $0x10,%eax
  8026b5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  8026b8:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026bc:	a1 40 41 90 00       	mov    0x904140,%eax
  8026c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026c4:	eb 16                	jmp    8026dc <free_block+0x3d>
	{
		if (block_pointer == it)
  8026c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026cc:	75 06                	jne    8026d4 <free_block+0x35>
		{
			flagx = 1;
  8026ce:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  8026d2:	eb 2f                	jmp    802703 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026d4:	a1 48 41 90 00       	mov    0x904148,%eax
  8026d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e0:	74 08                	je     8026ea <free_block+0x4b>
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	8b 40 08             	mov    0x8(%eax),%eax
  8026e8:	eb 05                	jmp    8026ef <free_block+0x50>
  8026ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ef:	a3 48 41 90 00       	mov    %eax,0x904148
  8026f4:	a1 48 41 90 00       	mov    0x904148,%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	75 c9                	jne    8026c6 <free_block+0x27>
  8026fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802701:	75 c3                	jne    8026c6 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802703:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802707:	0f 84 93 05 00 00    	je     802ca0 <free_block+0x601>
		return;
	if (va == NULL)
  80270d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802711:	0f 84 8c 05 00 00    	je     802ca3 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271a:	8b 40 0c             	mov    0xc(%eax),%eax
  80271d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802723:	8b 40 08             	mov    0x8(%eax),%eax
  802726:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802729:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80272d:	75 12                	jne    802741 <free_block+0xa2>
  80272f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802733:	75 0c                	jne    802741 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80273c:	e9 63 05 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802741:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802745:	0f 85 ca 00 00 00    	jne    802815 <free_block+0x176>
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	8a 40 04             	mov    0x4(%eax),%al
  802751:	3c 01                	cmp    $0x1,%al
  802753:	0f 85 bc 00 00 00    	jne    802815 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	8b 10                	mov    (%eax),%edx
  802765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	01 c2                	add    %eax,%edx
  80276c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276f:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802781:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802785:	75 17                	jne    80279e <free_block+0xff>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 5e 3c 80 00       	push   $0x803c5e
  80278f:	68 3c 01 00 00       	push   $0x13c
  802794:	68 c3 3b 80 00       	push   $0x803bc3
  802799:	e8 6d dc ff ff       	call   80040b <_panic>
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	8b 40 08             	mov    0x8(%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 11                	je     8027b9 <free_block+0x11a>
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	8b 40 08             	mov    0x8(%eax),%eax
  8027ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8027b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8027b7:	eb 0b                	jmp    8027c4 <free_block+0x125>
  8027b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bf:	a3 44 41 90 00       	mov    %eax,0x904144
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 11                	je     8027df <free_block+0x140>
  8027ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d7:	8b 52 08             	mov    0x8(%edx),%edx
  8027da:	89 50 08             	mov    %edx,0x8(%eax)
  8027dd:	eb 0b                	jmp    8027ea <free_block+0x14b>
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	8b 40 08             	mov    0x8(%eax),%eax
  8027e5:	a3 40 41 90 00       	mov    %eax,0x904140
  8027ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027fe:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802803:	48                   	dec    %eax
  802804:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802810:	e9 8f 04 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802819:	75 16                	jne    802831 <free_block+0x192>
  80281b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281e:	8a 40 04             	mov    0x4(%eax),%al
  802821:	84 c0                	test   %al,%al
  802823:	75 0c                	jne    802831 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802828:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80282c:	e9 73 04 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802831:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802835:	0f 85 c3 00 00 00    	jne    8028fe <free_block+0x25f>
  80283b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283e:	8a 40 04             	mov    0x4(%eax),%al
  802841:	3c 01                	cmp    $0x1,%al
  802843:	0f 85 b5 00 00 00    	jne    8028fe <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284c:	8b 10                	mov    (%eax),%edx
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	01 c2                	add    %eax,%edx
  802855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802858:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  80285a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802866:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80286a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80286e:	75 17                	jne    802887 <free_block+0x1e8>
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	68 5e 3c 80 00       	push   $0x803c5e
  802878:	68 49 01 00 00       	push   $0x149
  80287d:	68 c3 3b 80 00       	push   $0x803bc3
  802882:	e8 84 db ff ff       	call   80040b <_panic>
  802887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288a:	8b 40 08             	mov    0x8(%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 11                	je     8028a2 <free_block+0x203>
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	8b 40 08             	mov    0x8(%eax),%eax
  802897:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289a:	8b 52 0c             	mov    0xc(%edx),%edx
  80289d:	89 50 0c             	mov    %edx,0xc(%eax)
  8028a0:	eb 0b                	jmp    8028ad <free_block+0x20e>
  8028a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	a3 44 41 90 00       	mov    %eax,0x904144
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 11                	je     8028c8 <free_block+0x229>
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c0:	8b 52 08             	mov    0x8(%edx),%edx
  8028c3:	89 50 08             	mov    %edx,0x8(%eax)
  8028c6:	eb 0b                	jmp    8028d3 <free_block+0x234>
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ce:	a3 40 41 90 00       	mov    %eax,0x904140
  8028d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028e7:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028ec:	48                   	dec    %eax
  8028ed:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  8028f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8028f9:	e9 a6 03 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  8028fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802902:	75 16                	jne    80291a <free_block+0x27b>
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	8a 40 04             	mov    0x4(%eax),%al
  80290a:	84 c0                	test   %al,%al
  80290c:	75 0c                	jne    80291a <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802915:	e9 8a 03 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  80291a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80291e:	0f 84 81 01 00 00    	je     802aa5 <free_block+0x406>
  802924:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802928:	0f 84 77 01 00 00    	je     802aa5 <free_block+0x406>
  80292e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802931:	8a 40 04             	mov    0x4(%eax),%al
  802934:	3c 01                	cmp    $0x1,%al
  802936:	0f 85 69 01 00 00    	jne    802aa5 <free_block+0x406>
  80293c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293f:	8a 40 04             	mov    0x4(%eax),%al
  802942:	3c 01                	cmp    $0x1,%al
  802944:	0f 85 5b 01 00 00    	jne    802aa5 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  80294a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294d:	8b 10                	mov    (%eax),%edx
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	8b 08                	mov    (%eax),%ecx
  802954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	01 c8                	add    %ecx,%eax
  80295b:	01 c2                	add    %eax,%edx
  80295d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802960:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802965:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80296b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802982:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802986:	75 17                	jne    80299f <free_block+0x300>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 5e 3c 80 00       	push   $0x803c5e
  802990:	68 59 01 00 00       	push   $0x159
  802995:	68 c3 3b 80 00       	push   $0x803bc3
  80299a:	e8 6c da ff ff       	call   80040b <_panic>
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 40 08             	mov    0x8(%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 11                	je     8029ba <free_block+0x31b>
  8029a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ac:	8b 40 08             	mov    0x8(%eax),%eax
  8029af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8029b5:	89 50 0c             	mov    %edx,0xc(%eax)
  8029b8:	eb 0b                	jmp    8029c5 <free_block+0x326>
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	a3 44 41 90 00       	mov    %eax,0x904144
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	74 11                	je     8029e0 <free_block+0x341>
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d8:	8b 52 08             	mov    0x8(%edx),%edx
  8029db:	89 50 08             	mov    %edx,0x8(%eax)
  8029de:	eb 0b                	jmp    8029eb <free_block+0x34c>
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	a3 40 41 90 00       	mov    %eax,0x904140
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8029ff:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a04:	48                   	dec    %eax
  802a05:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a0e:	75 17                	jne    802a27 <free_block+0x388>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 5e 3c 80 00       	push   $0x803c5e
  802a18:	68 5a 01 00 00       	push   $0x15a
  802a1d:	68 c3 3b 80 00       	push   $0x803bc3
  802a22:	e8 e4 d9 ff ff       	call   80040b <_panic>
  802a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 11                	je     802a42 <free_block+0x3a3>
  802a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a34:	8b 40 08             	mov    0x8(%eax),%eax
  802a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3a:	8b 52 0c             	mov    0xc(%edx),%edx
  802a3d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a40:	eb 0b                	jmp    802a4d <free_block+0x3ae>
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	8b 40 0c             	mov    0xc(%eax),%eax
  802a48:	a3 44 41 90 00       	mov    %eax,0x904144
  802a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a50:	8b 40 0c             	mov    0xc(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 11                	je     802a68 <free_block+0x3c9>
  802a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a60:	8b 52 08             	mov    0x8(%edx),%edx
  802a63:	89 50 08             	mov    %edx,0x8(%eax)
  802a66:	eb 0b                	jmp    802a73 <free_block+0x3d4>
  802a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6b:	8b 40 08             	mov    0x8(%eax),%eax
  802a6e:	a3 40 41 90 00       	mov    %eax,0x904140
  802a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a87:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a8c:	48                   	dec    %eax
  802a8d:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802a92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802a99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802aa0:	e9 ff 01 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802aa5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aa9:	0f 84 db 00 00 00    	je     802b8a <free_block+0x4eb>
  802aaf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab3:	0f 84 d1 00 00 00    	je     802b8a <free_block+0x4eb>
  802ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abc:	8a 40 04             	mov    0x4(%eax),%al
  802abf:	84 c0                	test   %al,%al
  802ac1:	0f 85 c3 00 00 00    	jne    802b8a <free_block+0x4eb>
  802ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aca:	8a 40 04             	mov    0x4(%eax),%al
  802acd:	3c 01                	cmp    $0x1,%al
  802acf:	0f 85 b5 00 00 00    	jne    802b8a <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad8:	8b 10                	mov    (%eax),%edx
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	01 c2                	add    %eax,%edx
  802ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae4:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802af6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802afa:	75 17                	jne    802b13 <free_block+0x474>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 5e 3c 80 00       	push   $0x803c5e
  802b04:	68 64 01 00 00       	push   $0x164
  802b09:	68 c3 3b 80 00       	push   $0x803bc3
  802b0e:	e8 f8 d8 ff ff       	call   80040b <_panic>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 40 08             	mov    0x8(%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 11                	je     802b2e <free_block+0x48f>
  802b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b20:	8b 40 08             	mov    0x8(%eax),%eax
  802b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b26:	8b 52 0c             	mov    0xc(%edx),%edx
  802b29:	89 50 0c             	mov    %edx,0xc(%eax)
  802b2c:	eb 0b                	jmp    802b39 <free_block+0x49a>
  802b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	a3 44 41 90 00       	mov    %eax,0x904144
  802b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 11                	je     802b54 <free_block+0x4b5>
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4c:	8b 52 08             	mov    0x8(%edx),%edx
  802b4f:	89 50 08             	mov    %edx,0x8(%eax)
  802b52:	eb 0b                	jmp    802b5f <free_block+0x4c0>
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	8b 40 08             	mov    0x8(%eax),%eax
  802b5a:	a3 40 41 90 00       	mov    %eax,0x904140
  802b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b73:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802b78:	48                   	dec    %eax
  802b79:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802b7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802b85:	e9 1a 01 00 00       	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802b8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b8e:	0f 84 df 00 00 00    	je     802c73 <free_block+0x5d4>
  802b94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b98:	0f 84 d5 00 00 00    	je     802c73 <free_block+0x5d4>
  802b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba1:	8a 40 04             	mov    0x4(%eax),%al
  802ba4:	3c 01                	cmp    $0x1,%al
  802ba6:	0f 85 c7 00 00 00    	jne    802c73 <free_block+0x5d4>
  802bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baf:	8a 40 04             	mov    0x4(%eax),%al
  802bb2:	84 c0                	test   %al,%al
  802bb4:	0f 85 b9 00 00 00    	jne    802c73 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc4:	8b 10                	mov    (%eax),%edx
  802bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	01 c2                	add    %eax,%edx
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bde:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802be2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802be6:	75 17                	jne    802bff <free_block+0x560>
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 5e 3c 80 00       	push   $0x803c5e
  802bf0:	68 6e 01 00 00       	push   $0x16e
  802bf5:	68 c3 3b 80 00       	push   $0x803bc3
  802bfa:	e8 0c d8 ff ff       	call   80040b <_panic>
  802bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 11                	je     802c1a <free_block+0x57b>
  802c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0c:	8b 40 08             	mov    0x8(%eax),%eax
  802c0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c12:	8b 52 0c             	mov    0xc(%edx),%edx
  802c15:	89 50 0c             	mov    %edx,0xc(%eax)
  802c18:	eb 0b                	jmp    802c25 <free_block+0x586>
  802c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	a3 44 41 90 00       	mov    %eax,0x904144
  802c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 11                	je     802c40 <free_block+0x5a1>
  802c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c32:	8b 40 0c             	mov    0xc(%eax),%eax
  802c35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c38:	8b 52 08             	mov    0x8(%edx),%edx
  802c3b:	89 50 08             	mov    %edx,0x8(%eax)
  802c3e:	eb 0b                	jmp    802c4b <free_block+0x5ac>
  802c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c43:	8b 40 08             	mov    0x8(%eax),%eax
  802c46:	a3 40 41 90 00       	mov    %eax,0x904140
  802c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c5f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c64:	48                   	dec    %eax
  802c65:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802c6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802c71:	eb 31                	jmp    802ca4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c77:	74 2b                	je     802ca4 <free_block+0x605>
  802c79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c7d:	74 25                	je     802ca4 <free_block+0x605>
  802c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c82:	8a 40 04             	mov    0x4(%eax),%al
  802c85:	84 c0                	test   %al,%al
  802c87:	75 1b                	jne    802ca4 <free_block+0x605>
  802c89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8c:	8a 40 04             	mov    0x4(%eax),%al
  802c8f:	84 c0                	test   %al,%al
  802c91:	75 11                	jne    802ca4 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802c9a:	90                   	nop
  802c9b:	eb 07                	jmp    802ca4 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802c9d:	90                   	nop
  802c9e:	eb 04                	jmp    802ca4 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802ca0:	90                   	nop
  802ca1:	eb 01                	jmp    802ca4 <free_block+0x605>
	if (va == NULL)
		return;
  802ca3:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	57                   	push   %edi
  802caa:	56                   	push   %esi
  802cab:	53                   	push   %ebx
  802cac:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb3:	75 19                	jne    802cce <realloc_block_FF+0x28>
  802cb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb9:	74 13                	je     802cce <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  802cbb:	83 ec 0c             	sub    $0xc,%esp
  802cbe:	ff 75 0c             	pushl  0xc(%ebp)
  802cc1:	e8 0c f4 ff ff       	call   8020d2 <alloc_block_FF>
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	e9 84 03 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  802cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd2:	75 3b                	jne    802d0f <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802cd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd8:	75 17                	jne    802cf1 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  802cda:	83 ec 0c             	sub    $0xc,%esp
  802cdd:	6a 00                	push   $0x0
  802cdf:	e8 ee f3 ff ff       	call   8020d2 <alloc_block_FF>
  802ce4:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	e9 61 03 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  802cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf5:	74 18                	je     802d0f <realloc_block_FF+0x69>
		{
			free_block(va);
  802cf7:	83 ec 0c             	sub    $0xc,%esp
  802cfa:	ff 75 08             	pushl  0x8(%ebp)
  802cfd:	e8 9d f9 ff ff       	call   80269f <free_block>
  802d02:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	e9 43 03 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  802d0f:	a1 40 41 90 00       	mov    0x904140,%eax
  802d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d17:	e9 02 03 00 00       	jmp    80301e <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	83 e8 10             	sub    $0x10,%eax
  802d22:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d25:	0f 85 eb 02 00 00    	jne    803016 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d33:	83 c2 10             	add    $0x10,%edx
  802d36:	39 d0                	cmp    %edx,%eax
  802d38:	75 08                	jne    802d42 <realloc_block_FF+0x9c>
			{
				return va;
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	e9 10 03 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  802d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d4a:	0f 83 e0 01 00 00    	jae    802f30 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d53:	8b 40 08             	mov    0x8(%eax),%eax
  802d56:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  802d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5c:	8a 40 04             	mov    0x4(%eax),%al
  802d5f:	3c 01                	cmp    $0x1,%al
  802d61:	0f 85 06 01 00 00    	jne    802e6d <realloc_block_FF+0x1c7>
  802d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6a:	8b 10                	mov    (%eax),%edx
  802d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d74:	29 c1                	sub    %eax,%ecx
  802d76:	89 c8                	mov    %ecx,%eax
  802d78:	39 c2                	cmp    %eax,%edx
  802d7a:	0f 86 ed 00 00 00    	jbe    802e6d <realloc_block_FF+0x1c7>
  802d80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d84:	0f 84 e3 00 00 00    	je     802e6d <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  802d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8d:	8b 10                	mov    (%eax),%edx
  802d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	2b 45 0c             	sub    0xc(%ebp),%eax
  802d97:	01 d0                	add    %edx,%eax
  802d99:	83 f8 0f             	cmp    $0xf,%eax
  802d9c:	0f 86 b5 00 00 00    	jbe    802e57 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  802da2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	83 c0 10             	add    $0x10,%eax
  802dad:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  802db0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  802db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802dc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dc4:	74 06                	je     802dcc <realloc_block_FF+0x126>
  802dc6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dca:	75 17                	jne    802de3 <realloc_block_FF+0x13d>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 dc 3b 80 00       	push   $0x803bdc
  802dd4:	68 ad 01 00 00       	push   $0x1ad
  802dd9:	68 c3 3b 80 00       	push   $0x803bc3
  802dde:	e8 28 d6 ff ff       	call   80040b <_panic>
  802de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
  802def:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df2:	8b 40 08             	mov    0x8(%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 0c                	je     802e05 <realloc_block_FF+0x15f>
  802df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfc:	8b 40 08             	mov    0x8(%eax),%eax
  802dff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e02:	89 50 0c             	mov    %edx,0xc(%eax)
  802e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e0b:	89 50 08             	mov    %edx,0x8(%eax)
  802e0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e14:	89 50 0c             	mov    %edx,0xc(%eax)
  802e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1a:	8b 40 08             	mov    0x8(%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	75 08                	jne    802e29 <realloc_block_FF+0x183>
  802e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e24:	a3 44 41 90 00       	mov    %eax,0x904144
  802e29:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 4c 41 90 00       	mov    %eax,0x90414c
						next->size = 0;
  802e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  802e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e40:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  802e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e47:	8d 50 10             	lea    0x10(%eax),%edx
  802e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4d:	89 10                	mov    %edx,(%eax)
						return va;
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	e9 fb 01 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  802e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5a:	8d 50 10             	lea    0x10(%eax),%edx
  802e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e60:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	83 c0 10             	add    $0x10,%eax
  802e68:	e9 e5 01 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e70:	8a 40 04             	mov    0x4(%eax),%al
  802e73:	3c 01                	cmp    $0x1,%al
  802e75:	75 59                	jne    802ed0 <realloc_block_FF+0x22a>
  802e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7a:	8b 10                	mov    (%eax),%edx
  802e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e84:	29 c1                	sub    %eax,%ecx
  802e86:	89 c8                	mov    %ecx,%eax
  802e88:	39 c2                	cmp    %eax,%edx
  802e8a:	75 44                	jne    802ed0 <realloc_block_FF+0x22a>
  802e8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e90:	74 3e                	je     802ed0 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e95:	8b 40 08             	mov    0x8(%eax),%eax
  802e98:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ea1:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802ea4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ea7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eaa:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802ead:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec0:	8d 50 10             	lea    0x10(%eax),%edx
  802ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec6:	89 10                	mov    %edx,(%eax)
					return va;
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	e9 82 01 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed3:	8a 40 04             	mov    0x4(%eax),%al
  802ed6:	84 c0                	test   %al,%al
  802ed8:	74 0a                	je     802ee4 <realloc_block_FF+0x23e>
  802eda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ede:	0f 85 32 01 00 00    	jne    803016 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802ee4:	83 ec 0c             	sub    $0xc,%esp
  802ee7:	ff 75 0c             	pushl  0xc(%ebp)
  802eea:	e8 e3 f1 ff ff       	call   8020d2 <alloc_block_FF>
  802eef:	83 c4 10             	add    $0x10,%esp
  802ef2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  802ef5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ef9:	74 2b                	je     802f26 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  802efb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	89 c3                	mov    %eax,%ebx
  802f03:	b8 04 00 00 00       	mov    $0x4,%eax
  802f08:	89 d7                	mov    %edx,%edi
  802f0a:	89 de                	mov    %ebx,%esi
  802f0c:	89 c1                	mov    %eax,%ecx
  802f0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	e8 84 f7 ff ff       	call   80269f <free_block>
  802f1b:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802f1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f21:	e9 2c 01 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  802f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802f2b:	e9 22 01 00 00       	jmp    803052 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f38:	0f 86 d8 00 00 00    	jbe    803016 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f46:	83 f8 0f             	cmp    $0xf,%eax
  802f49:	0f 86 b4 00 00 00    	jbe    803003 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802f4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f55:	01 d0                	add    %edx,%eax
  802f57:	83 c0 10             	add    $0x10,%eax
  802f5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f65:	8d 50 f0             	lea    -0x10(%eax),%edx
  802f68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f6b:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f71:	74 06                	je     802f79 <realloc_block_FF+0x2d3>
  802f73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f77:	75 17                	jne    802f90 <realloc_block_FF+0x2ea>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 dc 3b 80 00       	push   $0x803bdc
  802f81:	68 dd 01 00 00       	push   $0x1dd
  802f86:	68 c3 3b 80 00       	push   $0x803bc3
  802f8b:	e8 7b d4 ff ff       	call   80040b <_panic>
  802f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f93:	8b 50 08             	mov    0x8(%eax),%edx
  802f96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f99:	89 50 08             	mov    %edx,0x8(%eax)
  802f9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f9f:	8b 40 08             	mov    0x8(%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 0c                	je     802fb2 <realloc_block_FF+0x30c>
  802fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa9:	8b 40 08             	mov    0x8(%eax),%eax
  802fac:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802faf:	89 50 0c             	mov    %edx,0xc(%eax)
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802fb8:	89 50 08             	mov    %edx,0x8(%eax)
  802fbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fc1:	89 50 0c             	mov    %edx,0xc(%eax)
  802fc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fc7:	8b 40 08             	mov    0x8(%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	75 08                	jne    802fd6 <realloc_block_FF+0x330>
  802fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd1:	a3 44 41 90 00       	mov    %eax,0x904144
  802fd6:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802fdb:	40                   	inc    %eax
  802fdc:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  802fe1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe4:	83 c0 10             	add    $0x10,%eax
  802fe7:	83 ec 0c             	sub    $0xc,%esp
  802fea:	50                   	push   %eax
  802feb:	e8 af f6 ff ff       	call   80269f <free_block>
  802ff0:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  802ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff6:	8d 50 10             	lea    0x10(%eax),%edx
  802ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffc:	89 10                	mov    %edx,(%eax)
					return va;
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	eb 4f                	jmp    803052 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803003:	8b 45 0c             	mov    0xc(%ebp),%eax
  803006:	8d 50 10             	lea    0x10(%eax),%edx
  803009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  80300e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803011:	83 c0 10             	add    $0x10,%eax
  803014:	eb 3c                	jmp    803052 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803016:	a1 48 41 90 00       	mov    0x904148,%eax
  80301b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80301e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803022:	74 08                	je     80302c <realloc_block_FF+0x386>
  803024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803027:	8b 40 08             	mov    0x8(%eax),%eax
  80302a:	eb 05                	jmp    803031 <realloc_block_FF+0x38b>
  80302c:	b8 00 00 00 00       	mov    $0x0,%eax
  803031:	a3 48 41 90 00       	mov    %eax,0x904148
  803036:	a1 48 41 90 00       	mov    0x904148,%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	0f 85 d9 fc ff ff    	jne    802d1c <realloc_block_FF+0x76>
  803043:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803047:	0f 85 cf fc ff ff    	jne    802d1c <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  80304d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803052:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803055:	5b                   	pop    %ebx
  803056:	5e                   	pop    %esi
  803057:	5f                   	pop    %edi
  803058:	5d                   	pop    %ebp
  803059:	c3                   	ret    
  80305a:	66 90                	xchg   %ax,%ax

0080305c <__udivdi3>:
  80305c:	55                   	push   %ebp
  80305d:	57                   	push   %edi
  80305e:	56                   	push   %esi
  80305f:	53                   	push   %ebx
  803060:	83 ec 1c             	sub    $0x1c,%esp
  803063:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803067:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80306b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80306f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803073:	89 ca                	mov    %ecx,%edx
  803075:	89 f8                	mov    %edi,%eax
  803077:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80307b:	85 f6                	test   %esi,%esi
  80307d:	75 2d                	jne    8030ac <__udivdi3+0x50>
  80307f:	39 cf                	cmp    %ecx,%edi
  803081:	77 65                	ja     8030e8 <__udivdi3+0x8c>
  803083:	89 fd                	mov    %edi,%ebp
  803085:	85 ff                	test   %edi,%edi
  803087:	75 0b                	jne    803094 <__udivdi3+0x38>
  803089:	b8 01 00 00 00       	mov    $0x1,%eax
  80308e:	31 d2                	xor    %edx,%edx
  803090:	f7 f7                	div    %edi
  803092:	89 c5                	mov    %eax,%ebp
  803094:	31 d2                	xor    %edx,%edx
  803096:	89 c8                	mov    %ecx,%eax
  803098:	f7 f5                	div    %ebp
  80309a:	89 c1                	mov    %eax,%ecx
  80309c:	89 d8                	mov    %ebx,%eax
  80309e:	f7 f5                	div    %ebp
  8030a0:	89 cf                	mov    %ecx,%edi
  8030a2:	89 fa                	mov    %edi,%edx
  8030a4:	83 c4 1c             	add    $0x1c,%esp
  8030a7:	5b                   	pop    %ebx
  8030a8:	5e                   	pop    %esi
  8030a9:	5f                   	pop    %edi
  8030aa:	5d                   	pop    %ebp
  8030ab:	c3                   	ret    
  8030ac:	39 ce                	cmp    %ecx,%esi
  8030ae:	77 28                	ja     8030d8 <__udivdi3+0x7c>
  8030b0:	0f bd fe             	bsr    %esi,%edi
  8030b3:	83 f7 1f             	xor    $0x1f,%edi
  8030b6:	75 40                	jne    8030f8 <__udivdi3+0x9c>
  8030b8:	39 ce                	cmp    %ecx,%esi
  8030ba:	72 0a                	jb     8030c6 <__udivdi3+0x6a>
  8030bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030c0:	0f 87 9e 00 00 00    	ja     803164 <__udivdi3+0x108>
  8030c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030cb:	89 fa                	mov    %edi,%edx
  8030cd:	83 c4 1c             	add    $0x1c,%esp
  8030d0:	5b                   	pop    %ebx
  8030d1:	5e                   	pop    %esi
  8030d2:	5f                   	pop    %edi
  8030d3:	5d                   	pop    %ebp
  8030d4:	c3                   	ret    
  8030d5:	8d 76 00             	lea    0x0(%esi),%esi
  8030d8:	31 ff                	xor    %edi,%edi
  8030da:	31 c0                	xor    %eax,%eax
  8030dc:	89 fa                	mov    %edi,%edx
  8030de:	83 c4 1c             	add    $0x1c,%esp
  8030e1:	5b                   	pop    %ebx
  8030e2:	5e                   	pop    %esi
  8030e3:	5f                   	pop    %edi
  8030e4:	5d                   	pop    %ebp
  8030e5:	c3                   	ret    
  8030e6:	66 90                	xchg   %ax,%ax
  8030e8:	89 d8                	mov    %ebx,%eax
  8030ea:	f7 f7                	div    %edi
  8030ec:	31 ff                	xor    %edi,%edi
  8030ee:	89 fa                	mov    %edi,%edx
  8030f0:	83 c4 1c             	add    $0x1c,%esp
  8030f3:	5b                   	pop    %ebx
  8030f4:	5e                   	pop    %esi
  8030f5:	5f                   	pop    %edi
  8030f6:	5d                   	pop    %ebp
  8030f7:	c3                   	ret    
  8030f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030fd:	89 eb                	mov    %ebp,%ebx
  8030ff:	29 fb                	sub    %edi,%ebx
  803101:	89 f9                	mov    %edi,%ecx
  803103:	d3 e6                	shl    %cl,%esi
  803105:	89 c5                	mov    %eax,%ebp
  803107:	88 d9                	mov    %bl,%cl
  803109:	d3 ed                	shr    %cl,%ebp
  80310b:	89 e9                	mov    %ebp,%ecx
  80310d:	09 f1                	or     %esi,%ecx
  80310f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803113:	89 f9                	mov    %edi,%ecx
  803115:	d3 e0                	shl    %cl,%eax
  803117:	89 c5                	mov    %eax,%ebp
  803119:	89 d6                	mov    %edx,%esi
  80311b:	88 d9                	mov    %bl,%cl
  80311d:	d3 ee                	shr    %cl,%esi
  80311f:	89 f9                	mov    %edi,%ecx
  803121:	d3 e2                	shl    %cl,%edx
  803123:	8b 44 24 08          	mov    0x8(%esp),%eax
  803127:	88 d9                	mov    %bl,%cl
  803129:	d3 e8                	shr    %cl,%eax
  80312b:	09 c2                	or     %eax,%edx
  80312d:	89 d0                	mov    %edx,%eax
  80312f:	89 f2                	mov    %esi,%edx
  803131:	f7 74 24 0c          	divl   0xc(%esp)
  803135:	89 d6                	mov    %edx,%esi
  803137:	89 c3                	mov    %eax,%ebx
  803139:	f7 e5                	mul    %ebp
  80313b:	39 d6                	cmp    %edx,%esi
  80313d:	72 19                	jb     803158 <__udivdi3+0xfc>
  80313f:	74 0b                	je     80314c <__udivdi3+0xf0>
  803141:	89 d8                	mov    %ebx,%eax
  803143:	31 ff                	xor    %edi,%edi
  803145:	e9 58 ff ff ff       	jmp    8030a2 <__udivdi3+0x46>
  80314a:	66 90                	xchg   %ax,%ax
  80314c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803150:	89 f9                	mov    %edi,%ecx
  803152:	d3 e2                	shl    %cl,%edx
  803154:	39 c2                	cmp    %eax,%edx
  803156:	73 e9                	jae    803141 <__udivdi3+0xe5>
  803158:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80315b:	31 ff                	xor    %edi,%edi
  80315d:	e9 40 ff ff ff       	jmp    8030a2 <__udivdi3+0x46>
  803162:	66 90                	xchg   %ax,%ax
  803164:	31 c0                	xor    %eax,%eax
  803166:	e9 37 ff ff ff       	jmp    8030a2 <__udivdi3+0x46>
  80316b:	90                   	nop

0080316c <__umoddi3>:
  80316c:	55                   	push   %ebp
  80316d:	57                   	push   %edi
  80316e:	56                   	push   %esi
  80316f:	53                   	push   %ebx
  803170:	83 ec 1c             	sub    $0x1c,%esp
  803173:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803177:	8b 74 24 34          	mov    0x34(%esp),%esi
  80317b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80317f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803187:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80318b:	89 f3                	mov    %esi,%ebx
  80318d:	89 fa                	mov    %edi,%edx
  80318f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803193:	89 34 24             	mov    %esi,(%esp)
  803196:	85 c0                	test   %eax,%eax
  803198:	75 1a                	jne    8031b4 <__umoddi3+0x48>
  80319a:	39 f7                	cmp    %esi,%edi
  80319c:	0f 86 a2 00 00 00    	jbe    803244 <__umoddi3+0xd8>
  8031a2:	89 c8                	mov    %ecx,%eax
  8031a4:	89 f2                	mov    %esi,%edx
  8031a6:	f7 f7                	div    %edi
  8031a8:	89 d0                	mov    %edx,%eax
  8031aa:	31 d2                	xor    %edx,%edx
  8031ac:	83 c4 1c             	add    $0x1c,%esp
  8031af:	5b                   	pop    %ebx
  8031b0:	5e                   	pop    %esi
  8031b1:	5f                   	pop    %edi
  8031b2:	5d                   	pop    %ebp
  8031b3:	c3                   	ret    
  8031b4:	39 f0                	cmp    %esi,%eax
  8031b6:	0f 87 ac 00 00 00    	ja     803268 <__umoddi3+0xfc>
  8031bc:	0f bd e8             	bsr    %eax,%ebp
  8031bf:	83 f5 1f             	xor    $0x1f,%ebp
  8031c2:	0f 84 ac 00 00 00    	je     803274 <__umoddi3+0x108>
  8031c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031cd:	29 ef                	sub    %ebp,%edi
  8031cf:	89 fe                	mov    %edi,%esi
  8031d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031d5:	89 e9                	mov    %ebp,%ecx
  8031d7:	d3 e0                	shl    %cl,%eax
  8031d9:	89 d7                	mov    %edx,%edi
  8031db:	89 f1                	mov    %esi,%ecx
  8031dd:	d3 ef                	shr    %cl,%edi
  8031df:	09 c7                	or     %eax,%edi
  8031e1:	89 e9                	mov    %ebp,%ecx
  8031e3:	d3 e2                	shl    %cl,%edx
  8031e5:	89 14 24             	mov    %edx,(%esp)
  8031e8:	89 d8                	mov    %ebx,%eax
  8031ea:	d3 e0                	shl    %cl,%eax
  8031ec:	89 c2                	mov    %eax,%edx
  8031ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f2:	d3 e0                	shl    %cl,%eax
  8031f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031fc:	89 f1                	mov    %esi,%ecx
  8031fe:	d3 e8                	shr    %cl,%eax
  803200:	09 d0                	or     %edx,%eax
  803202:	d3 eb                	shr    %cl,%ebx
  803204:	89 da                	mov    %ebx,%edx
  803206:	f7 f7                	div    %edi
  803208:	89 d3                	mov    %edx,%ebx
  80320a:	f7 24 24             	mull   (%esp)
  80320d:	89 c6                	mov    %eax,%esi
  80320f:	89 d1                	mov    %edx,%ecx
  803211:	39 d3                	cmp    %edx,%ebx
  803213:	0f 82 87 00 00 00    	jb     8032a0 <__umoddi3+0x134>
  803219:	0f 84 91 00 00 00    	je     8032b0 <__umoddi3+0x144>
  80321f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803223:	29 f2                	sub    %esi,%edx
  803225:	19 cb                	sbb    %ecx,%ebx
  803227:	89 d8                	mov    %ebx,%eax
  803229:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80322d:	d3 e0                	shl    %cl,%eax
  80322f:	89 e9                	mov    %ebp,%ecx
  803231:	d3 ea                	shr    %cl,%edx
  803233:	09 d0                	or     %edx,%eax
  803235:	89 e9                	mov    %ebp,%ecx
  803237:	d3 eb                	shr    %cl,%ebx
  803239:	89 da                	mov    %ebx,%edx
  80323b:	83 c4 1c             	add    $0x1c,%esp
  80323e:	5b                   	pop    %ebx
  80323f:	5e                   	pop    %esi
  803240:	5f                   	pop    %edi
  803241:	5d                   	pop    %ebp
  803242:	c3                   	ret    
  803243:	90                   	nop
  803244:	89 fd                	mov    %edi,%ebp
  803246:	85 ff                	test   %edi,%edi
  803248:	75 0b                	jne    803255 <__umoddi3+0xe9>
  80324a:	b8 01 00 00 00       	mov    $0x1,%eax
  80324f:	31 d2                	xor    %edx,%edx
  803251:	f7 f7                	div    %edi
  803253:	89 c5                	mov    %eax,%ebp
  803255:	89 f0                	mov    %esi,%eax
  803257:	31 d2                	xor    %edx,%edx
  803259:	f7 f5                	div    %ebp
  80325b:	89 c8                	mov    %ecx,%eax
  80325d:	f7 f5                	div    %ebp
  80325f:	89 d0                	mov    %edx,%eax
  803261:	e9 44 ff ff ff       	jmp    8031aa <__umoddi3+0x3e>
  803266:	66 90                	xchg   %ax,%ax
  803268:	89 c8                	mov    %ecx,%eax
  80326a:	89 f2                	mov    %esi,%edx
  80326c:	83 c4 1c             	add    $0x1c,%esp
  80326f:	5b                   	pop    %ebx
  803270:	5e                   	pop    %esi
  803271:	5f                   	pop    %edi
  803272:	5d                   	pop    %ebp
  803273:	c3                   	ret    
  803274:	3b 04 24             	cmp    (%esp),%eax
  803277:	72 06                	jb     80327f <__umoddi3+0x113>
  803279:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80327d:	77 0f                	ja     80328e <__umoddi3+0x122>
  80327f:	89 f2                	mov    %esi,%edx
  803281:	29 f9                	sub    %edi,%ecx
  803283:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803287:	89 14 24             	mov    %edx,(%esp)
  80328a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803292:	8b 14 24             	mov    (%esp),%edx
  803295:	83 c4 1c             	add    $0x1c,%esp
  803298:	5b                   	pop    %ebx
  803299:	5e                   	pop    %esi
  80329a:	5f                   	pop    %edi
  80329b:	5d                   	pop    %ebp
  80329c:	c3                   	ret    
  80329d:	8d 76 00             	lea    0x0(%esi),%esi
  8032a0:	2b 04 24             	sub    (%esp),%eax
  8032a3:	19 fa                	sbb    %edi,%edx
  8032a5:	89 d1                	mov    %edx,%ecx
  8032a7:	89 c6                	mov    %eax,%esi
  8032a9:	e9 71 ff ff ff       	jmp    80321f <__umoddi3+0xb3>
  8032ae:	66 90                	xchg   %ax,%ax
  8032b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032b4:	72 ea                	jb     8032a0 <__umoddi3+0x134>
  8032b6:	89 d9                	mov    %ebx,%ecx
  8032b8:	e9 62 ff ff ff       	jmp    80321f <__umoddi3+0xb3>
