
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
  800060:	68 40 33 80 00       	push   $0x803340
  800065:	6a 14                	push   $0x14
  800067:	68 5c 33 80 00       	push   $0x80335c
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
  8000bc:	e8 45 18 00 00       	call   801906 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 88 18 00 00       	call   801951 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 0a 14 00 00       	call   8014e7 <malloc>
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
  800100:	e8 fc 02 00 00       	call   800401 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 47 18 00 00       	call   801951 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 33 80 00       	push   $0x8033a8
  800117:	6a 34                	push   $0x34
  800119:	68 5c 33 80 00       	push   $0x80335c
  80011e:	e8 de 02 00 00       	call   800401 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 de 17 00 00       	call   801906 <sys_calculate_free_frames>
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
  80015f:	e8 a2 17 00 00       	call   801906 <sys_calculate_free_frames>
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
  8001c7:	e8 57 1c 00 00       	call   801e23 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 34 80 00       	push   $0x803454
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 5c 33 80 00       	push   $0x80335c
  8001e7:	e8 15 02 00 00       	call   800401 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 15 17 00 00       	call   801906 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 58 17 00 00       	call   801951 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 38 14 00 00       	call   801643 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 3e 17 00 00       	call   801951 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 34 80 00       	push   $0x803474
  800220:	6a 4f                	push   $0x4f
  800222:	68 5c 33 80 00       	push   $0x80335c
  800227:	e8 d5 01 00 00       	call   800401 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 d5 16 00 00       	call   801906 <sys_calculate_free_frames>
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
  80028d:	e8 91 1b 00 00       	call   801e23 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 34 80 00       	push   $0x8034fc
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 5c 33 80 00       	push   $0x80335c
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
  8002ba:	e8 10 1a 00 00       	call   801ccf <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 20 35 80 00       	push   $0x803520
  8002c7:	6a 5b                	push   $0x5b
  8002c9:	68 5c 33 80 00       	push   $0x80335c
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
  8002d9:	e8 b3 18 00 00       	call   801b91 <sys_getenvindex>
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
  800336:	e8 63 16 00 00       	call   80199e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 84 35 80 00       	push   $0x803584
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
  800366:	68 ac 35 80 00       	push   $0x8035ac
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
  800397:	68 d4 35 80 00       	push   $0x8035d4
  80039c:	e8 1d 03 00 00       	call   8006be <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a9:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	50                   	push   %eax
  8003b3:	68 2c 36 80 00       	push   $0x80362c
  8003b8:	e8 01 03 00 00       	call   8006be <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	68 84 35 80 00       	push   $0x803584
  8003c8:	e8 f1 02 00 00       	call   8006be <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d0:	e8 e3 15 00 00       	call   8019b8 <sys_enable_interrupt>

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
  8003e8:	e8 70 17 00 00       	call   801b5d <sys_destroy_env>
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
  8003f9:	e8 c5 17 00 00       	call   801bc3 <sys_exit_env>
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
  800422:	68 40 36 80 00       	push   $0x803640
  800427:	e8 92 02 00 00       	call   8006be <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042f:	a1 00 40 80 00       	mov    0x804000,%eax
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	50                   	push   %eax
  80043b:	68 45 36 80 00       	push   $0x803645
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
  80045f:	68 61 36 80 00       	push   $0x803661
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
  80048e:	68 64 36 80 00       	push   $0x803664
  800493:	6a 26                	push   $0x26
  800495:	68 b0 36 80 00       	push   $0x8036b0
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
  800563:	68 bc 36 80 00       	push   $0x8036bc
  800568:	6a 3a                	push   $0x3a
  80056a:	68 b0 36 80 00       	push   $0x8036b0
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
  8005d6:	68 10 37 80 00       	push   $0x803710
  8005db:	6a 44                	push   $0x44
  8005dd:	68 b0 36 80 00       	push   $0x8036b0
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
  800630:	e8 10 12 00 00       	call   801845 <sys_cputs>
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
  8006a7:	e8 99 11 00 00       	call   801845 <sys_cputs>
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
  8006f1:	e8 a8 12 00 00       	call   80199e <sys_disable_interrupt>
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
  800711:	e8 a2 12 00 00       	call   8019b8 <sys_enable_interrupt>
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
  80075b:	e8 68 29 00 00       	call   8030c8 <__udivdi3>
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
  8007ab:	e8 28 2a 00 00       	call   8031d8 <__umoddi3>
  8007b0:	83 c4 10             	add    $0x10,%esp
  8007b3:	05 74 39 80 00       	add    $0x803974,%eax
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
  800906:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
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
  8009e7:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8009ee:	85 f6                	test   %esi,%esi
  8009f0:	75 19                	jne    800a0b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f2:	53                   	push   %ebx
  8009f3:	68 85 39 80 00       	push   $0x803985
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
  800a0c:	68 8e 39 80 00       	push   $0x80398e
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
  800a39:	be 91 39 80 00       	mov    $0x803991,%esi
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
	return dst;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  8014bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 0a                	je     8014ce <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014c4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014cb:	00 00 00 
	}
}
  8014ce:	90                   	nop
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 7e 09 00 00       	call   801e60 <sys_sbrk>
  8014e2:	83 c4 10             	add    $0x10,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ed:	e8 c6 ff ff ff       	call   8014b8 <InitializeUHeap>
	if (size == 0)
  8014f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f6:	75 0a                	jne    801502 <malloc+0x1b>
		return NULL;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	e9 3f 01 00 00       	jmp    801641 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801502:	e8 ac 09 00 00       	call   801eb3 <sys_get_hard_limit>
  801507:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  80150a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801514:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801519:	c1 e8 0c             	shr    $0xc,%eax
  80151c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  80151f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801526:	8b 55 08             	mov    0x8(%ebp),%edx
  801529:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152c:	01 d0                	add    %edx,%eax
  80152e:	48                   	dec    %eax
  80152f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801535:	ba 00 00 00 00       	mov    $0x0,%edx
  80153a:	f7 75 d8             	divl   -0x28(%ebp)
  80153d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801540:	29 d0                	sub    %edx,%eax
  801542:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801548:	c1 e8 0c             	shr    $0xc,%eax
  80154b:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  80154e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801552:	75 0a                	jne    80155e <malloc+0x77>
		return NULL;
  801554:	b8 00 00 00 00       	mov    $0x0,%eax
  801559:	e9 e3 00 00 00       	jmp    801641 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  80155e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801561:	05 00 00 00 80       	add    $0x80000000,%eax
  801566:	c1 e8 0c             	shr    $0xc,%eax
  801569:	a3 20 41 80 00       	mov    %eax,0x804120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80156e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801575:	77 19                	ja     801590 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 60 0b 00 00       	call   8020e2 <alloc_block_FF>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801588:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80158b:	e9 b1 00 00 00       	jmp    801641 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801590:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801593:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801596:	eb 4d                	jmp    8015e5 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801598:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159b:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 27                	jne    8015cd <malloc+0xe6>
			{
				counter++;
  8015a6:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  8015a9:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8015ad:	75 14                	jne    8015c3 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  8015af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b2:	05 00 00 08 00       	add    $0x80000,%eax
  8015b7:	c1 e0 0c             	shl    $0xc,%eax
  8015ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  8015bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  8015c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c6:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015c9:	75 17                	jne    8015e2 <malloc+0xfb>
				{
					break;
  8015cb:	eb 21                	jmp    8015ee <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  8015cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d0:	8a 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%al
  8015d7:	3c 01                	cmp    $0x1,%al
  8015d9:	75 07                	jne    8015e2 <malloc+0xfb>
			{
				counter = 0;
  8015db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  8015e2:	ff 45 e8             	incl   -0x18(%ebp)
  8015e5:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8015ec:	76 aa                	jbe    801598 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8015f4:	75 46                	jne    80163c <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8015fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ff:	e8 93 08 00 00       	call   801e97 <sys_allocate_user_mem>
  801604:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80160d:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80161a:	eb 0e                	jmp    80162a <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  80161c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161f:	c6 04 c5 40 41 80 00 	movb   $0x1,0x804140(,%eax,8)
  801626:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801627:	ff 45 e4             	incl   -0x1c(%ebp)
  80162a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801635:	77 e5                	ja     80161c <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	eb 05                	jmp    801641 <malloc+0x15a>
		}
	}

	return NULL;
  80163c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801649:	e8 65 08 00 00       	call   801eb3 <sys_get_hard_limit>
  80164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165b:	0f 84 c1 00 00 00    	je     801722 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801664:	85 c0                	test   %eax,%eax
  801666:	79 1b                	jns    801683 <free+0x40>
  801668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80166e:	73 13                	jae    801683 <free+0x40>
    {
        free_block(virtual_address);
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	e8 34 10 00 00       	call   8026af <free_block>
  80167b:	83 c4 10             	add    $0x10,%esp
    	return;
  80167e:	e9 a6 00 00 00       	jmp    801729 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	05 00 10 00 00       	add    $0x1000,%eax
  80168b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80168e:	0f 87 91 00 00 00    	ja     801725 <free+0xe2>
  801694:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80169b:	0f 87 84 00 00 00    	ja     801725 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  8016a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8016ba:	c1 e8 0c             	shr    $0xc,%eax
  8016bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  8016c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c3:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8016ca:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  8016cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016d1:	74 55                	je     801728 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  8016d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d6:	c1 e8 0c             	shr    $0xc,%eax
  8016d9:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  8016dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016df:	c7 04 c5 44 41 80 00 	movl   $0x0,0x804144(,%eax,8)
  8016e6:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8016ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f0:	eb 0e                	jmp    801700 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f5:	c6 04 c5 40 41 80 00 	movb   $0x0,0x804140(,%eax,8)
  8016fc:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  8016fd:	ff 45 f4             	incl   -0xc(%ebp)
  801700:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801706:	01 c2                	add    %eax,%edx
  801708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170b:	39 c2                	cmp    %eax,%edx
  80170d:	77 e3                	ja     8016f2 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	ff 75 e0             	pushl  -0x20(%ebp)
  801715:	ff 75 ec             	pushl  -0x14(%ebp)
  801718:	e8 5e 07 00 00       	call   801e7b <sys_free_user_mem>
  80171d:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801720:	eb 07                	jmp    801729 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801722:	90                   	nop
  801723:	eb 04                	jmp    801729 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801725:	90                   	nop
  801726:	eb 01                	jmp    801729 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801728:	90                   	nop
    else
     {
    	return;
      }

}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 18             	sub    $0x18,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 7c fd ff ff       	call   8014b8 <InitializeUHeap>
	if (size == 0)
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 07                	jne    801749 <smalloc+0x1e>
		return NULL;
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	eb 17                	jmp    801760 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 f0 3a 80 00       	push   $0x803af0
  801751:	68 ad 00 00 00       	push   $0xad
  801756:	68 16 3b 80 00       	push   $0x803b16
  80175b:	e8 a1 ec ff ff       	call   800401 <_panic>
	return NULL;
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801768:	e8 4b fd ff ff       	call   8014b8 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 24 3b 80 00       	push   $0x803b24
  801775:	68 ba 00 00 00       	push   $0xba
  80177a:	68 16 3b 80 00       	push   $0x803b16
  80177f:	e8 7d ec ff ff       	call   800401 <_panic>

00801784 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178a:	e8 29 fd ff ff       	call   8014b8 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	68 48 3b 80 00       	push   $0x803b48
  801797:	68 d8 00 00 00       	push   $0xd8
  80179c:	68 16 3b 80 00       	push   $0x803b16
  8017a1:	e8 5b ec ff ff       	call   800401 <_panic>

008017a6 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 70 3b 80 00       	push   $0x803b70
  8017b4:	68 ea 00 00 00       	push   $0xea
  8017b9:	68 16 3b 80 00       	push   $0x803b16
  8017be:	e8 3e ec ff ff       	call   800401 <_panic>

008017c3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 94 3b 80 00       	push   $0x803b94
  8017d1:	68 f2 00 00 00       	push   $0xf2
  8017d6:	68 16 3b 80 00       	push   $0x803b16
  8017db:	e8 21 ec ff ff       	call   800401 <_panic>

008017e0 <shrink>:

}
void shrink(uint32 newSize) {
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 94 3b 80 00       	push   $0x803b94
  8017ee:	68 f6 00 00 00       	push   $0xf6
  8017f3:	68 16 3b 80 00       	push   $0x803b16
  8017f8:	e8 04 ec ff ff       	call   800401 <_panic>

008017fd <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 94 3b 80 00       	push   $0x803b94
  80180b:	68 fa 00 00 00       	push   $0xfa
  801810:	68 16 3b 80 00       	push   $0x803b16
  801815:	e8 e7 eb ff ff       	call   800401 <_panic>

0080181a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	57                   	push   %edi
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
  801820:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8b 55 0c             	mov    0xc(%ebp),%edx
  801829:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801832:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801835:	cd 30                	int    $0x30
  801837:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5f                   	pop    %edi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    

00801845 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	8b 45 10             	mov    0x10(%ebp),%eax
  80184e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801851:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	6a 00                	push   $0x0
  801863:	e8 b2 ff ff ff       	call   80181a <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_cgetc>:

int
sys_cgetc(void)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 01                	push   $0x1
  80187d:	e8 98 ff ff ff       	call   80181a <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 05                	push   $0x5
  80189a:	e8 7b ff ff ff       	call   80181a <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	51                   	push   %ecx
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 06                	push   $0x6
  8018bf:	e8 56 ff ff ff       	call   80181a <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 07                	push   $0x7
  8018e1:	e8 34 ff ff ff       	call   80181a <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 08                	push   $0x8
  8018fc:	e8 19 ff ff ff       	call   80181a <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 09                	push   $0x9
  801915:	e8 00 ff ff ff       	call   80181a <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 0a                	push   $0xa
  80192e:	e8 e7 fe ff ff       	call   80181a <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 0b                	push   $0xb
  801947:	e8 ce fe ff ff       	call   80181a <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 0c                	push   $0xc
  801960:	e8 b5 fe ff ff       	call   80181a <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 0d                	push   $0xd
  80197a:	e8 9b fe ff ff       	call   80181a <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 0e                	push   $0xe
  801993:	e8 82 fe ff ff       	call   80181a <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 11                	push   $0x11
  8019ad:	e8 68 fe ff ff       	call   80181a <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 12                	push   $0x12
  8019c7:	e8 4e fe ff ff       	call   80181a <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	50                   	push   %eax
  8019eb:	6a 13                	push   $0x13
  8019ed:	e8 28 fe ff ff       	call   80181a <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 14                	push   $0x14
  801a07:	e8 0e fe ff ff       	call   80181a <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	50                   	push   %eax
  801a22:	6a 15                	push   $0x15
  801a24:	e8 f1 fd ff ff       	call   80181a <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 18                	push   $0x18
  801a41:	e8 d4 fd ff ff       	call   80181a <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 16                	push   $0x16
  801a5e:	e8 b7 fd ff ff       	call   80181a <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 17                	push   $0x17
  801a7c:	e8 99 fd ff ff       	call   80181a <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	90                   	nop
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a96:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	51                   	push   %ecx
  801aa0:	52                   	push   %edx
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	50                   	push   %eax
  801aa5:	6a 19                	push   $0x19
  801aa7:	e8 6e fd ff ff       	call   80181a <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 1a                	push   $0x1a
  801ac4:	e8 51 fd ff ff       	call   80181a <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	51                   	push   %ecx
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 1b                	push   $0x1b
  801ae3:	e8 32 fd ff ff       	call   80181a <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	52                   	push   %edx
  801afd:	50                   	push   %eax
  801afe:	6a 1c                	push   $0x1c
  801b00:	e8 15 fd ff ff       	call   80181a <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 1d                	push   $0x1d
  801b19:	e8 fc fc ff ff       	call   80181a <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 14             	pushl  0x14(%ebp)
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	50                   	push   %eax
  801b35:	6a 1e                	push   $0x1e
  801b37:	e8 de fc ff ff       	call   80181a <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 1f                	push   $0x1f
  801b52:	e8 c3 fc ff ff       	call   80181a <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	50                   	push   %eax
  801b6c:	6a 20                	push   $0x20
  801b6e:	e8 a7 fc ff ff       	call   80181a <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 02                	push   $0x2
  801b87:	e8 8e fc ff ff       	call   80181a <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 03                	push   $0x3
  801ba0:	e8 75 fc ff ff       	call   80181a <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 04                	push   $0x4
  801bb9:	e8 5c fc ff ff       	call   80181a <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_exit_env>:


void sys_exit_env(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 21                	push   $0x21
  801bd2:	e8 43 fc ff ff       	call   80181a <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	90                   	nop
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801be3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be6:	8d 50 04             	lea    0x4(%eax),%edx
  801be9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	52                   	push   %edx
  801bf3:	50                   	push   %eax
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 1f fc ff ff       	call   80181a <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return result;
  801bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c07:	89 01                	mov    %eax,(%ecx)
  801c09:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	c9                   	leave  
  801c10:	c2 04 00             	ret    $0x4

00801c13 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	ff 75 10             	pushl  0x10(%ebp)
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	6a 10                	push   $0x10
  801c25:	e8 f0 fb ff ff       	call   80181a <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 23                	push   $0x23
  801c3f:	e8 d6 fb ff ff       	call   80181a <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c55:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	50                   	push   %eax
  801c62:	6a 24                	push   $0x24
  801c64:	e8 b1 fb ff ff       	call   80181a <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <rsttst>:
void rsttst()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 26                	push   $0x26
  801c7e:	e8 97 fb ff ff       	call   80181a <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c95:	8b 55 18             	mov    0x18(%ebp),%edx
  801c98:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	ff 75 10             	pushl  0x10(%ebp)
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	ff 75 08             	pushl  0x8(%ebp)
  801ca7:	6a 25                	push   $0x25
  801ca9:	e8 6c fb ff ff       	call   80181a <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb1:	90                   	nop
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <chktst>:
void chktst(uint32 n)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 27                	push   $0x27
  801cc4:	e8 51 fb ff ff       	call   80181a <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <inctst>:

void inctst()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 28                	push   $0x28
  801cde:	e8 37 fb ff ff       	call   80181a <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <gettst>:
uint32 gettst()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 29                	push   $0x29
  801cf8:	e8 1d fb ff ff       	call   80181a <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 2a                	push   $0x2a
  801d14:	e8 01 fb ff ff       	call   80181a <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
  801d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d1f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d23:	75 07                	jne    801d2c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d25:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2a:	eb 05                	jmp    801d31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 2a                	push   $0x2a
  801d45:	e8 d0 fa ff ff       	call   80181a <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
  801d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d50:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d54:	75 07                	jne    801d5d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	eb 05                	jmp    801d62 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 2a                	push   $0x2a
  801d76:	e8 9f fa ff ff       	call   80181a <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d81:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d85:	75 07                	jne    801d8e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8c:	eb 05                	jmp    801d93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 2a                	push   $0x2a
  801da7:	e8 6e fa ff ff       	call   80181a <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
  801daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db6:	75 07                	jne    801dbf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801db8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbd:	eb 05                	jmp    801dc4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	6a 2b                	push   $0x2b
  801dd6:	e8 3f fa ff ff       	call   80181a <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dde:	90                   	nop
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801de5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	53                   	push   %ebx
  801df4:	51                   	push   %ecx
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	6a 2c                	push   $0x2c
  801df9:	e8 1c fa ff ff       	call   80181a <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	52                   	push   %edx
  801e16:	50                   	push   %eax
  801e17:	6a 2d                	push   $0x2d
  801e19:	e8 fc f9 ff ff       	call   80181a <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	6a 00                	push   $0x0
  801e31:	51                   	push   %ecx
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 2e                	push   $0x2e
  801e39:	e8 dc f9 ff ff       	call   80181a <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 10             	pushl  0x10(%ebp)
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	6a 0f                	push   $0xf
  801e55:	e8 c0 f9 ff ff       	call   80181a <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5d:	90                   	nop
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	50                   	push   %eax
  801e6f:	6a 2f                	push   $0x2f
  801e71:	e8 a4 f9 ff ff       	call   80181a <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp

}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 30                	push   $0x30
  801e8c:	e8 89 f9 ff ff       	call   80181a <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	6a 31                	push   $0x31
  801ea8:	e8 6d f9 ff ff       	call   80181a <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 32                	push   $0x32
  801ec2:	e8 53 f9 ff ff       	call   80181a <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	50                   	push   %eax
  801edb:	6a 33                	push   $0x33
  801edd:	e8 38 f9 ff ff       	call   80181a <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	90                   	nop
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	83 e8 10             	sub    $0x10,%eax
  801ef4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  801ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801efa:	8b 00                	mov    (%eax),%eax
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	83 e8 10             	sub    $0x10,%eax
  801f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  801f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f10:	8a 40 04             	mov    0x4(%eax),%al
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	83 f8 02             	cmp    $0x2,%eax
  801f28:	74 2b                	je     801f55 <alloc_block+0x40>
  801f2a:	83 f8 02             	cmp    $0x2,%eax
  801f2d:	7f 07                	jg     801f36 <alloc_block+0x21>
  801f2f:	83 f8 01             	cmp    $0x1,%eax
  801f32:	74 0e                	je     801f42 <alloc_block+0x2d>
  801f34:	eb 58                	jmp    801f8e <alloc_block+0x79>
  801f36:	83 f8 03             	cmp    $0x3,%eax
  801f39:	74 2d                	je     801f68 <alloc_block+0x53>
  801f3b:	83 f8 04             	cmp    $0x4,%eax
  801f3e:	74 3b                	je     801f7b <alloc_block+0x66>
  801f40:	eb 4c                	jmp    801f8e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f42:	83 ec 0c             	sub    $0xc,%esp
  801f45:	ff 75 08             	pushl  0x8(%ebp)
  801f48:	e8 95 01 00 00       	call   8020e2 <alloc_block_FF>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f53:	eb 4a                	jmp    801f9f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	ff 75 08             	pushl  0x8(%ebp)
  801f5b:	e8 32 07 00 00       	call   802692 <alloc_block_NF>
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f66:	eb 37                	jmp    801f9f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	ff 75 08             	pushl  0x8(%ebp)
  801f6e:	e8 a3 04 00 00       	call   802416 <alloc_block_BF>
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f79:	eb 24                	jmp    801f9f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	e8 ef 06 00 00       	call   802675 <alloc_block_WF>
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8c:	eb 11                	jmp    801f9f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	68 a4 3b 80 00       	push   $0x803ba4
  801f96:	e8 23 e7 ff ff       	call   8006be <cprintf>
  801f9b:	83 c4 10             	add    $0x10,%esp
		break;
  801f9e:	90                   	nop
	}
	return va;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	68 c4 3b 80 00       	push   $0x803bc4
  801fb2:	e8 07 e7 ff ff       	call   8006be <cprintf>
  801fb7:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 ef 3b 80 00       	push   $0x803bef
  801fc2:	e8 f7 e6 ff ff       	call   8006be <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd0:	eb 26                	jmp    801ff8 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8a 40 04             	mov    0x4(%eax),%al
  801fd8:	0f b6 d0             	movzbl %al,%edx
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 00                	mov    (%eax),%eax
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	52                   	push   %edx
  801fe4:	50                   	push   %eax
  801fe5:	68 07 3c 80 00       	push   $0x803c07
  801fea:	e8 cf e6 ff ff       	call   8006be <cprintf>
  801fef:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffc:	74 08                	je     802006 <print_blocks_list+0x62>
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 40 08             	mov    0x8(%eax),%eax
  802004:	eb 05                	jmp    80200b <print_blocks_list+0x67>
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	89 45 10             	mov    %eax,0x10(%ebp)
  80200e:	8b 45 10             	mov    0x10(%ebp),%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	75 bd                	jne    801fd2 <print_blocks_list+0x2e>
  802015:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802019:	75 b7                	jne    801fd2 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	68 c4 3b 80 00       	push   $0x803bc4
  802023:	e8 96 e6 ff ff       	call   8006be <cprintf>
  802028:	83 c4 10             	add    $0x10,%esp

}
  80202b:	90                   	nop
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802038:	0f 84 a1 00 00 00    	je     8020df <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  80203e:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  802045:	00 00 00 
	LIST_INIT(&list);
  802048:	c7 05 40 41 90 00 00 	movl   $0x0,0x904140
  80204f:	00 00 00 
  802052:	c7 05 44 41 90 00 00 	movl   $0x0,0x904144
  802059:	00 00 00 
  80205c:	c7 05 4c 41 90 00 00 	movl   $0x0,0x90414c
  802063:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 55 0c             	mov    0xc(%ebp),%edx
  802079:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  80207b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207f:	75 14                	jne    802095 <initialize_dynamic_allocator+0x67>
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 20 3c 80 00       	push   $0x803c20
  802089:	6a 64                	push   $0x64
  80208b:	68 43 3c 80 00       	push   $0x803c43
  802090:	e8 6c e3 ff ff       	call   800401 <_panic>
  802095:	8b 15 44 41 90 00    	mov    0x904144,%edx
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	89 50 0c             	mov    %edx,0xc(%eax)
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	74 0d                	je     8020b8 <initialize_dynamic_allocator+0x8a>
  8020ab:	a1 44 41 90 00       	mov    0x904144,%eax
  8020b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b3:	89 50 08             	mov    %edx,0x8(%eax)
  8020b6:	eb 08                	jmp    8020c0 <initialize_dynamic_allocator+0x92>
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	a3 40 41 90 00       	mov    %eax,0x904140
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	a3 44 41 90 00       	mov    %eax,0x904144
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020d2:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8020d7:	40                   	inc    %eax
  8020d8:	a3 4c 41 90 00       	mov    %eax,0x90414c
  8020dd:	eb 01                	jmp    8020e0 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8020df:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8020e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ec:	75 0a                	jne    8020f8 <alloc_block_FF+0x16>
	{
		return NULL;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	e9 1c 03 00 00       	jmp    802414 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8020f8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	75 40                	jne    802141 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	83 c0 10             	add    $0x10,%eax
  802107:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	50                   	push   %eax
  802111:	e8 bb f3 ff ff       	call   8014d1 <sbrk>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	6a 00                	push   $0x0
  802121:	e8 ab f3 ff ff       	call   8014d1 <sbrk>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  80212c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80212f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802132:	83 ec 08             	sub    $0x8,%esp
  802135:	50                   	push   %eax
  802136:	ff 75 ec             	pushl  -0x14(%ebp)
  802139:	e8 f0 fe ff ff       	call   80202e <initialize_dynamic_allocator>
  80213e:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802141:	a1 40 41 90 00       	mov    0x904140,%eax
  802146:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802149:	e9 1e 01 00 00       	jmp    80226c <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8d 50 10             	lea    0x10(%eax),%edx
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	39 c2                	cmp    %eax,%edx
  80215b:	75 1c                	jne    802179 <alloc_block_FF+0x97>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8a 40 04             	mov    0x4(%eax),%al
  802163:	3c 01                	cmp    $0x1,%al
  802165:	75 12                	jne    802179 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	83 c0 10             	add    $0x10,%eax
  802174:	e9 9b 02 00 00       	jmp    802414 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8d 50 10             	lea    0x10(%eax),%edx
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	39 c2                	cmp    %eax,%edx
  802186:	0f 83 d8 00 00 00    	jae    802264 <alloc_block_FF+0x182>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8a 40 04             	mov    0x4(%eax),%al
  802192:	3c 01                	cmp    $0x1,%al
  802194:	0f 85 ca 00 00 00    	jne    802264 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 00                	mov    (%eax),%eax
  80219f:	2b 45 08             	sub    0x8(%ebp),%eax
  8021a2:	83 e8 10             	sub    $0x10,%eax
  8021a5:	83 f8 0f             	cmp    $0xf,%eax
  8021a8:	0f 86 a4 00 00 00    	jbe    802252 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	83 c0 10             	add    $0x10,%eax
  8021b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8021c4:	8d 50 f0             	lea    -0x10(%eax),%edx
  8021c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ca:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8021cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021cf:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8021d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d7:	74 06                	je     8021df <alloc_block_FF+0xfd>
  8021d9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021dd:	75 17                	jne    8021f6 <alloc_block_FF+0x114>
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	68 5c 3c 80 00       	push   $0x803c5c
  8021e7:	68 8f 00 00 00       	push   $0x8f
  8021ec:	68 43 3c 80 00       	push   $0x803c43
  8021f1:	e8 0b e2 ff ff       	call   800401 <_panic>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 50 08             	mov    0x8(%eax),%edx
  8021fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ff:	89 50 08             	mov    %edx,0x8(%eax)
  802202:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	74 0c                	je     802218 <alloc_block_FF+0x136>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802215:	89 50 0c             	mov    %edx,0xc(%eax)
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80221e:	89 50 08             	mov    %edx,0x8(%eax)
  802221:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802224:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802227:	89 50 0c             	mov    %edx,0xc(%eax)
  80222a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80222d:	8b 40 08             	mov    0x8(%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	75 08                	jne    80223c <alloc_block_FF+0x15a>
  802234:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802237:	a3 44 41 90 00       	mov    %eax,0x904144
  80223c:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802241:	40                   	inc    %eax
  802242:	a3 4c 41 90 00       	mov    %eax,0x90414c
		    iterator->size = size + sizeOfMetaData();
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8d 50 10             	lea    0x10(%eax),%edx
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	83 c0 10             	add    $0x10,%eax
  80225f:	e9 b0 01 00 00       	jmp    802414 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802264:	a1 48 41 90 00       	mov    0x904148,%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802270:	74 08                	je     80227a <alloc_block_FF+0x198>
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 40 08             	mov    0x8(%eax),%eax
  802278:	eb 05                	jmp    80227f <alloc_block_FF+0x19d>
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	a3 48 41 90 00       	mov    %eax,0x904148
  802284:	a1 48 41 90 00       	mov    0x904148,%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	0f 85 bd fe ff ff    	jne    80214e <alloc_block_FF+0x6c>
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	0f 85 b3 fe ff ff    	jne    80214e <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	83 c0 10             	add    $0x10,%eax
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	50                   	push   %eax
  8022a5:	e8 27 f2 ff ff       	call   8014d1 <sbrk>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	6a 00                	push   $0x0
  8022b5:	e8 17 f2 ff ff       	call   8014d1 <sbrk>
  8022ba:	83 c4 10             	add    $0x10,%esp
  8022bd:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8022c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c6:	29 c2                	sub    %eax,%edx
  8022c8:	89 d0                	mov    %edx,%eax
  8022ca:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8022cd:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8022d1:	0f 84 38 01 00 00    	je     80240f <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8022d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022da:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8022dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022e1:	75 17                	jne    8022fa <alloc_block_FF+0x218>
  8022e3:	83 ec 04             	sub    $0x4,%esp
  8022e6:	68 20 3c 80 00       	push   $0x803c20
  8022eb:	68 9f 00 00 00       	push   $0x9f
  8022f0:	68 43 3c 80 00       	push   $0x803c43
  8022f5:	e8 07 e1 ff ff       	call   800401 <_panic>
  8022fa:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802303:	89 50 0c             	mov    %edx,0xc(%eax)
  802306:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802309:	8b 40 0c             	mov    0xc(%eax),%eax
  80230c:	85 c0                	test   %eax,%eax
  80230e:	74 0d                	je     80231d <alloc_block_FF+0x23b>
  802310:	a1 44 41 90 00       	mov    0x904144,%eax
  802315:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802318:	89 50 08             	mov    %edx,0x8(%eax)
  80231b:	eb 08                	jmp    802325 <alloc_block_FF+0x243>
  80231d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802320:	a3 40 41 90 00       	mov    %eax,0x904140
  802325:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802328:	a3 44 41 90 00       	mov    %eax,0x904144
  80232d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802330:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802337:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80233c:	40                   	inc    %eax
  80233d:	a3 4c 41 90 00       	mov    %eax,0x90414c
			newBlock->size = size + sizeOfMetaData();
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8d 50 10             	lea    0x10(%eax),%edx
  802348:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234b:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  80234d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802350:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802354:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802357:	2b 45 08             	sub    0x8(%ebp),%eax
  80235a:	83 f8 10             	cmp    $0x10,%eax
  80235d:	0f 84 a4 00 00 00    	je     802407 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802363:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802366:	2b 45 08             	sub    0x8(%ebp),%eax
  802369:	83 e8 10             	sub    $0x10,%eax
  80236c:	83 f8 0f             	cmp    $0xf,%eax
  80236f:	0f 86 8a 00 00 00    	jbe    8023ff <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802375:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	01 d0                	add    %edx,%eax
  80237d:	83 c0 10             	add    $0x10,%eax
  802380:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802383:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802387:	75 17                	jne    8023a0 <alloc_block_FF+0x2be>
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	68 20 3c 80 00       	push   $0x803c20
  802391:	68 a7 00 00 00       	push   $0xa7
  802396:	68 43 3c 80 00       	push   $0x803c43
  80239b:	e8 61 e0 ff ff       	call   800401 <_panic>
  8023a0:	8b 15 44 41 90 00    	mov    0x904144,%edx
  8023a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8023ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023af:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	74 0d                	je     8023c3 <alloc_block_FF+0x2e1>
  8023b6:	a1 44 41 90 00       	mov    0x904144,%eax
  8023bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023be:	89 50 08             	mov    %edx,0x8(%eax)
  8023c1:	eb 08                	jmp    8023cb <alloc_block_FF+0x2e9>
  8023c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c6:	a3 40 41 90 00       	mov    %eax,0x904140
  8023cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ce:	a3 44 41 90 00       	mov    %eax,0x904144
  8023d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023dd:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8023e2:	40                   	inc    %eax
  8023e3:	a3 4c 41 90 00       	mov    %eax,0x90414c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8023e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ee:	8d 50 f0             	lea    -0x10(%eax),%edx
  8023f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f4:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8023f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8023fd:	eb 08                	jmp    802407 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  8023ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802402:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802405:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802407:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80240a:	83 c0 10             	add    $0x10,%eax
  80240d:	eb 05                	jmp    802414 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  80241c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802427:	75 0a                	jne    802433 <alloc_block_BF+0x1d>
	{
		return NULL;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	e9 40 02 00 00       	jmp    802673 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802433:	a1 40 41 90 00       	mov    0x904140,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	eb 66                	jmp    8024a3 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8a 40 04             	mov    0x4(%eax),%al
  802443:	3c 01                	cmp    $0x1,%al
  802445:	75 21                	jne    802468 <alloc_block_BF+0x52>
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	8d 50 10             	lea    0x10(%eax),%edx
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 00                	mov    (%eax),%eax
  802452:	39 c2                	cmp    %eax,%edx
  802454:	75 12                	jne    802468 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	83 c0 10             	add    $0x10,%eax
  802463:	e9 0b 02 00 00       	jmp    802673 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8a 40 04             	mov    0x4(%eax),%al
  80246e:	3c 01                	cmp    $0x1,%al
  802470:	75 29                	jne    80249b <alloc_block_BF+0x85>
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	8d 50 10             	lea    0x10(%eax),%edx
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	39 c2                	cmp    %eax,%edx
  80247f:	77 1a                	ja     80249b <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802481:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802485:	74 0e                	je     802495 <alloc_block_BF+0x7f>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 10                	mov    (%eax),%edx
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	39 c2                	cmp    %eax,%edx
  802493:	73 06                	jae    80249b <alloc_block_BF+0x85>
			{
				BF = iterator;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  80249b:	a1 48 41 90 00       	mov    0x904148,%eax
  8024a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a7:	74 08                	je     8024b1 <alloc_block_BF+0x9b>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 08             	mov    0x8(%eax),%eax
  8024af:	eb 05                	jmp    8024b6 <alloc_block_BF+0xa0>
  8024b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b6:	a3 48 41 90 00       	mov    %eax,0x904148
  8024bb:	a1 48 41 90 00       	mov    0x904148,%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	0f 85 75 ff ff ff    	jne    80243d <alloc_block_BF+0x27>
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	0f 85 6b ff ff ff    	jne    80243d <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  8024d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d6:	0f 84 f8 00 00 00    	je     8025d4 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	8d 50 10             	lea    0x10(%eax),%edx
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	39 c2                	cmp    %eax,%edx
  8024e9:	0f 87 e5 00 00 00    	ja     8025d4 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f7:	83 e8 10             	sub    $0x10,%eax
  8024fa:	83 f8 0f             	cmp    $0xf,%eax
  8024fd:	0f 86 bf 00 00 00    	jbe    8025c2 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	83 c0 10             	add    $0x10,%eax
  80250e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	2b 45 08             	sub    0x8(%ebp),%eax
  802522:	8d 50 f0             	lea    -0x10(%eax),%edx
  802525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802528:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  80252a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802535:	74 06                	je     80253d <alloc_block_BF+0x127>
  802537:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80253b:	75 17                	jne    802554 <alloc_block_BF+0x13e>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 5c 3c 80 00       	push   $0x803c5c
  802545:	68 e3 00 00 00       	push   $0xe3
  80254a:	68 43 3c 80 00       	push   $0x803c43
  80254f:	e8 ad de ff ff       	call   800401 <_panic>
  802554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802557:	8b 50 08             	mov    0x8(%eax),%edx
  80255a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255d:	89 50 08             	mov    %edx,0x8(%eax)
  802560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802563:	8b 40 08             	mov    0x8(%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 0c                	je     802576 <alloc_block_BF+0x160>
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802573:	89 50 0c             	mov    %edx,0xc(%eax)
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80257c:	89 50 08             	mov    %edx,0x8(%eax)
  80257f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802585:	89 50 0c             	mov    %edx,0xc(%eax)
  802588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258b:	8b 40 08             	mov    0x8(%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	75 08                	jne    80259a <alloc_block_BF+0x184>
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	a3 44 41 90 00       	mov    %eax,0x904144
  80259a:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80259f:	40                   	inc    %eax
  8025a0:	a3 4c 41 90 00       	mov    %eax,0x90414c

				BF->size = size + sizeOfMetaData();
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8d 50 10             	lea    0x10(%eax),%edx
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	83 c0 10             	add    $0x10,%eax
  8025bd:	e9 b1 00 00 00       	jmp    802673 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	83 c0 10             	add    $0x10,%eax
  8025cf:	e9 9f 00 00 00       	jmp    802673 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	83 c0 10             	add    $0x10,%eax
  8025da:	83 ec 0c             	sub    $0xc,%esp
  8025dd:	50                   	push   %eax
  8025de:	e8 ee ee ff ff       	call   8014d1 <sbrk>
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8025e9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025ed:	74 7f                	je     80266e <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8025ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025f3:	75 17                	jne    80260c <alloc_block_BF+0x1f6>
  8025f5:	83 ec 04             	sub    $0x4,%esp
  8025f8:	68 20 3c 80 00       	push   $0x803c20
  8025fd:	68 f6 00 00 00       	push   $0xf6
  802602:	68 43 3c 80 00       	push   $0x803c43
  802607:	e8 f5 dd ff ff       	call   800401 <_panic>
  80260c:	8b 15 44 41 90 00    	mov    0x904144,%edx
  802612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802615:	89 50 0c             	mov    %edx,0xc(%eax)
  802618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 0d                	je     80262f <alloc_block_BF+0x219>
  802622:	a1 44 41 90 00       	mov    0x904144,%eax
  802627:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80262a:	89 50 08             	mov    %edx,0x8(%eax)
  80262d:	eb 08                	jmp    802637 <alloc_block_BF+0x221>
  80262f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802632:	a3 40 41 90 00       	mov    %eax,0x904140
  802637:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263a:	a3 44 41 90 00       	mov    %eax,0x904144
  80263f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802642:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802649:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80264e:	40                   	inc    %eax
  80264f:	a3 4c 41 90 00       	mov    %eax,0x90414c
		newBlock->size = size + sizeOfMetaData();
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	8d 50 10             	lea    0x10(%eax),%edx
  80265a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  80265f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802662:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802666:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802669:	83 c0 10             	add    $0x10,%eax
  80266c:	eb 05                	jmp    802673 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	68 90 3c 80 00       	push   $0x803c90
  802683:	68 07 01 00 00       	push   $0x107
  802688:	68 43 3c 80 00       	push   $0x803c43
  80268d:	e8 6f dd ff ff       	call   800401 <_panic>

00802692 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 b8 3c 80 00       	push   $0x803cb8
  8026a0:	68 0f 01 00 00       	push   $0x10f
  8026a5:	68 43 3c 80 00       	push   $0x803c43
  8026aa:	e8 52 dd ff ff       	call   800401 <_panic>

008026af <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  8026b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b9:	0f 84 ee 05 00 00    	je     802cad <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	83 e8 10             	sub    $0x10,%eax
  8026c5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  8026c8:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026cc:	a1 40 41 90 00       	mov    0x904140,%eax
  8026d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026d4:	eb 16                	jmp    8026ec <free_block+0x3d>
	{
		if (block_pointer == it)
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026dc:	75 06                	jne    8026e4 <free_block+0x35>
		{
			flagx = 1;
  8026de:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  8026e2:	eb 2f                	jmp    802713 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8026e4:	a1 48 41 90 00       	mov    0x904148,%eax
  8026e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f0:	74 08                	je     8026fa <free_block+0x4b>
  8026f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f5:	8b 40 08             	mov    0x8(%eax),%eax
  8026f8:	eb 05                	jmp    8026ff <free_block+0x50>
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ff:	a3 48 41 90 00       	mov    %eax,0x904148
  802704:	a1 48 41 90 00       	mov    0x904148,%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	75 c9                	jne    8026d6 <free_block+0x27>
  80270d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802711:	75 c3                	jne    8026d6 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802713:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802717:	0f 84 93 05 00 00    	je     802cb0 <free_block+0x601>
		return;
	if (va == NULL)
  80271d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802721:	0f 84 8c 05 00 00    	je     802cb3 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272a:	8b 40 0c             	mov    0xc(%eax),%eax
  80272d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802733:	8b 40 08             	mov    0x8(%eax),%eax
  802736:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802739:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80273d:	75 12                	jne    802751 <free_block+0xa2>
  80273f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802743:	75 0c                	jne    802751 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802748:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80274c:	e9 63 05 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802751:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802755:	0f 85 ca 00 00 00    	jne    802825 <free_block+0x176>
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	8a 40 04             	mov    0x4(%eax),%al
  802761:	3c 01                	cmp    $0x1,%al
  802763:	0f 85 bc 00 00 00    	jne    802825 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802773:	8b 10                	mov    (%eax),%edx
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	01 c2                	add    %eax,%edx
  80277c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277f:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802791:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802795:	75 17                	jne    8027ae <free_block+0xff>
  802797:	83 ec 04             	sub    $0x4,%esp
  80279a:	68 de 3c 80 00       	push   $0x803cde
  80279f:	68 3c 01 00 00       	push   $0x13c
  8027a4:	68 43 3c 80 00       	push   $0x803c43
  8027a9:	e8 53 dc ff ff       	call   800401 <_panic>
  8027ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b1:	8b 40 08             	mov    0x8(%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 11                	je     8027c9 <free_block+0x11a>
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 40 08             	mov    0x8(%eax),%eax
  8027be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8027c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8027c7:	eb 0b                	jmp    8027d4 <free_block+0x125>
  8027c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cf:	a3 44 41 90 00       	mov    %eax,0x904144
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 11                	je     8027ef <free_block+0x140>
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e7:	8b 52 08             	mov    0x8(%edx),%edx
  8027ea:	89 50 08             	mov    %edx,0x8(%eax)
  8027ed:	eb 0b                	jmp    8027fa <free_block+0x14b>
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	8b 40 08             	mov    0x8(%eax),%eax
  8027f5:	a3 40 41 90 00       	mov    %eax,0x904140
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80280e:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802813:	48                   	dec    %eax
  802814:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802819:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802820:	e9 8f 04 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802825:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802829:	75 16                	jne    802841 <free_block+0x192>
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	8a 40 04             	mov    0x4(%eax),%al
  802831:	84 c0                	test   %al,%al
  802833:	75 0c                	jne    802841 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802838:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80283c:	e9 73 04 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802845:	0f 85 c3 00 00 00    	jne    80290e <free_block+0x25f>
  80284b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284e:	8a 40 04             	mov    0x4(%eax),%al
  802851:	3c 01                	cmp    $0x1,%al
  802853:	0f 85 b5 00 00 00    	jne    80290e <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802859:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80285c:	8b 10                	mov    (%eax),%edx
  80285e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	01 c2                	add    %eax,%edx
  802865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802868:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80287a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80287e:	75 17                	jne    802897 <free_block+0x1e8>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 de 3c 80 00       	push   $0x803cde
  802888:	68 49 01 00 00       	push   $0x149
  80288d:	68 43 3c 80 00       	push   $0x803c43
  802892:	e8 6a db ff ff       	call   800401 <_panic>
  802897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289a:	8b 40 08             	mov    0x8(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 11                	je     8028b2 <free_block+0x203>
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	8b 40 08             	mov    0x8(%eax),%eax
  8028a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8028ad:	89 50 0c             	mov    %edx,0xc(%eax)
  8028b0:	eb 0b                	jmp    8028bd <free_block+0x20e>
  8028b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b8:	a3 44 41 90 00       	mov    %eax,0x904144
  8028bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	74 11                	je     8028d8 <free_block+0x229>
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d0:	8b 52 08             	mov    0x8(%edx),%edx
  8028d3:	89 50 08             	mov    %edx,0x8(%eax)
  8028d6:	eb 0b                	jmp    8028e3 <free_block+0x234>
  8028d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	a3 40 41 90 00       	mov    %eax,0x904140
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028f7:	a1 4c 41 90 00       	mov    0x90414c,%eax
  8028fc:	48                   	dec    %eax
  8028fd:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802902:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802909:	e9 a6 03 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  80290e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802912:	75 16                	jne    80292a <free_block+0x27b>
  802914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802917:	8a 40 04             	mov    0x4(%eax),%al
  80291a:	84 c0                	test   %al,%al
  80291c:	75 0c                	jne    80292a <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  80291e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802921:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802925:	e9 8a 03 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  80292a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80292e:	0f 84 81 01 00 00    	je     802ab5 <free_block+0x406>
  802934:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802938:	0f 84 77 01 00 00    	je     802ab5 <free_block+0x406>
  80293e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802941:	8a 40 04             	mov    0x4(%eax),%al
  802944:	3c 01                	cmp    $0x1,%al
  802946:	0f 85 69 01 00 00    	jne    802ab5 <free_block+0x406>
  80294c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294f:	8a 40 04             	mov    0x4(%eax),%al
  802952:	3c 01                	cmp    $0x1,%al
  802954:	0f 85 5b 01 00 00    	jne    802ab5 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	8b 10                	mov    (%eax),%edx
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	8b 08                	mov    (%eax),%ecx
  802964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802967:	8b 00                	mov    (%eax),%eax
  802969:	01 c8                	add    %ecx,%eax
  80296b:	01 c2                	add    %eax,%edx
  80296d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802970:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80297b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802985:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80298b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802992:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802996:	75 17                	jne    8029af <free_block+0x300>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 de 3c 80 00       	push   $0x803cde
  8029a0:	68 59 01 00 00       	push   $0x159
  8029a5:	68 43 3c 80 00       	push   $0x803c43
  8029aa:	e8 52 da ff ff       	call   800401 <_panic>
  8029af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b2:	8b 40 08             	mov    0x8(%eax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 11                	je     8029ca <free_block+0x31b>
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	8b 40 08             	mov    0x8(%eax),%eax
  8029bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8029c5:	89 50 0c             	mov    %edx,0xc(%eax)
  8029c8:	eb 0b                	jmp    8029d5 <free_block+0x326>
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d0:	a3 44 41 90 00       	mov    %eax,0x904144
  8029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 11                	je     8029f0 <free_block+0x341>
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e8:	8b 52 08             	mov    0x8(%edx),%edx
  8029eb:	89 50 08             	mov    %edx,0x8(%eax)
  8029ee:	eb 0b                	jmp    8029fb <free_block+0x34c>
  8029f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f3:	8b 40 08             	mov    0x8(%eax),%eax
  8029f6:	a3 40 41 90 00       	mov    %eax,0x904140
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a0f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a14:	48                   	dec    %eax
  802a15:	a3 4c 41 90 00       	mov    %eax,0x90414c
		LIST_REMOVE(&list, next_block);
  802a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a1e:	75 17                	jne    802a37 <free_block+0x388>
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 de 3c 80 00       	push   $0x803cde
  802a28:	68 5a 01 00 00       	push   $0x15a
  802a2d:	68 43 3c 80 00       	push   $0x803c43
  802a32:	e8 ca d9 ff ff       	call   800401 <_panic>
  802a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3a:	8b 40 08             	mov    0x8(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 11                	je     802a52 <free_block+0x3a3>
  802a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a4a:	8b 52 0c             	mov    0xc(%edx),%edx
  802a4d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a50:	eb 0b                	jmp    802a5d <free_block+0x3ae>
  802a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	a3 44 41 90 00       	mov    %eax,0x904144
  802a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a60:	8b 40 0c             	mov    0xc(%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 11                	je     802a78 <free_block+0x3c9>
  802a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a70:	8b 52 08             	mov    0x8(%edx),%edx
  802a73:	89 50 08             	mov    %edx,0x8(%eax)
  802a76:	eb 0b                	jmp    802a83 <free_block+0x3d4>
  802a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7b:	8b 40 08             	mov    0x8(%eax),%eax
  802a7e:	a3 40 41 90 00       	mov    %eax,0x904140
  802a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a97:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802a9c:	48                   	dec    %eax
  802a9d:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802aa2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802aa9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802ab0:	e9 ff 01 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802ab5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ab9:	0f 84 db 00 00 00    	je     802b9a <free_block+0x4eb>
  802abf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ac3:	0f 84 d1 00 00 00    	je     802b9a <free_block+0x4eb>
  802ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acc:	8a 40 04             	mov    0x4(%eax),%al
  802acf:	84 c0                	test   %al,%al
  802ad1:	0f 85 c3 00 00 00    	jne    802b9a <free_block+0x4eb>
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	8a 40 04             	mov    0x4(%eax),%al
  802add:	3c 01                	cmp    $0x1,%al
  802adf:	0f 85 b5 00 00 00    	jne    802b9a <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 10                	mov    (%eax),%edx
  802aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b0a:	75 17                	jne    802b23 <free_block+0x474>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 de 3c 80 00       	push   $0x803cde
  802b14:	68 64 01 00 00       	push   $0x164
  802b19:	68 43 3c 80 00       	push   $0x803c43
  802b1e:	e8 de d8 ff ff       	call   800401 <_panic>
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8b 40 08             	mov    0x8(%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 11                	je     802b3e <free_block+0x48f>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b36:	8b 52 0c             	mov    0xc(%edx),%edx
  802b39:	89 50 0c             	mov    %edx,0xc(%eax)
  802b3c:	eb 0b                	jmp    802b49 <free_block+0x49a>
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 40 0c             	mov    0xc(%eax),%eax
  802b44:	a3 44 41 90 00       	mov    %eax,0x904144
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 11                	je     802b64 <free_block+0x4b5>
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5c:	8b 52 08             	mov    0x8(%edx),%edx
  802b5f:	89 50 08             	mov    %edx,0x8(%eax)
  802b62:	eb 0b                	jmp    802b6f <free_block+0x4c0>
  802b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	a3 40 41 90 00       	mov    %eax,0x904140
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b83:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802b88:	48                   	dec    %eax
  802b89:	a3 4c 41 90 00       	mov    %eax,0x90414c
		block_pointer = 0;
  802b8e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802b95:	e9 1a 01 00 00       	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b9e:	0f 84 df 00 00 00    	je     802c83 <free_block+0x5d4>
  802ba4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba8:	0f 84 d5 00 00 00    	je     802c83 <free_block+0x5d4>
  802bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb1:	8a 40 04             	mov    0x4(%eax),%al
  802bb4:	3c 01                	cmp    $0x1,%al
  802bb6:	0f 85 c7 00 00 00    	jne    802c83 <free_block+0x5d4>
  802bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbf:	8a 40 04             	mov    0x4(%eax),%al
  802bc2:	84 c0                	test   %al,%al
  802bc4:	0f 85 b9 00 00 00    	jne    802c83 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	8b 10                	mov    (%eax),%edx
  802bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	01 c2                	add    %eax,%edx
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bee:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bf6:	75 17                	jne    802c0f <free_block+0x560>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 de 3c 80 00       	push   $0x803cde
  802c00:	68 6e 01 00 00       	push   $0x16e
  802c05:	68 43 3c 80 00       	push   $0x803c43
  802c0a:	e8 f2 d7 ff ff       	call   800401 <_panic>
  802c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c12:	8b 40 08             	mov    0x8(%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 11                	je     802c2a <free_block+0x57b>
  802c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c22:	8b 52 0c             	mov    0xc(%edx),%edx
  802c25:	89 50 0c             	mov    %edx,0xc(%eax)
  802c28:	eb 0b                	jmp    802c35 <free_block+0x586>
  802c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c30:	a3 44 41 90 00       	mov    %eax,0x904144
  802c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c38:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 11                	je     802c50 <free_block+0x5a1>
  802c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c48:	8b 52 08             	mov    0x8(%edx),%edx
  802c4b:	89 50 08             	mov    %edx,0x8(%eax)
  802c4e:	eb 0b                	jmp    802c5b <free_block+0x5ac>
  802c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c53:	8b 40 08             	mov    0x8(%eax),%eax
  802c56:	a3 40 41 90 00       	mov    %eax,0x904140
  802c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c68:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c6f:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802c74:	48                   	dec    %eax
  802c75:	a3 4c 41 90 00       	mov    %eax,0x90414c
		next_block = 0;
  802c7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802c81:	eb 31                	jmp    802cb4 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802c83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c87:	74 2b                	je     802cb4 <free_block+0x605>
  802c89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c8d:	74 25                	je     802cb4 <free_block+0x605>
  802c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c92:	8a 40 04             	mov    0x4(%eax),%al
  802c95:	84 c0                	test   %al,%al
  802c97:	75 1b                	jne    802cb4 <free_block+0x605>
  802c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9c:	8a 40 04             	mov    0x4(%eax),%al
  802c9f:	84 c0                	test   %al,%al
  802ca1:	75 11                	jne    802cb4 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802caa:	90                   	nop
  802cab:	eb 07                	jmp    802cb4 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802cad:	90                   	nop
  802cae:	eb 04                	jmp    802cb4 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802cb0:	90                   	nop
  802cb1:	eb 01                	jmp    802cb4 <free_block+0x605>
	if (va == NULL)
		return;
  802cb3:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802cb4:	c9                   	leave  
  802cb5:	c3                   	ret    

00802cb6 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802cb6:	55                   	push   %ebp
  802cb7:	89 e5                	mov    %esp,%ebp
  802cb9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802cbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc0:	75 19                	jne    802cdb <realloc_block_FF+0x25>
  802cc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc6:	74 13                	je     802cdb <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  802cc8:	83 ec 0c             	sub    $0xc,%esp
  802ccb:	ff 75 0c             	pushl  0xc(%ebp)
  802cce:	e8 0f f4 ff ff       	call   8020e2 <alloc_block_FF>
  802cd3:	83 c4 10             	add    $0x10,%esp
  802cd6:	e9 ea 03 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  802cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cdf:	75 3b                	jne    802d1c <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  802ce1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce5:	75 17                	jne    802cfe <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  802ce7:	83 ec 0c             	sub    $0xc,%esp
  802cea:	6a 00                	push   $0x0
  802cec:	e8 f1 f3 ff ff       	call   8020e2 <alloc_block_FF>
  802cf1:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf9:	e9 c7 03 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  802cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d02:	74 18                	je     802d1c <realloc_block_FF+0x66>
		{
			free_block(va);
  802d04:	83 ec 0c             	sub    $0xc,%esp
  802d07:	ff 75 08             	pushl  0x8(%ebp)
  802d0a:	e8 a0 f9 ff ff       	call   8026af <free_block>
  802d0f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802d12:	b8 00 00 00 00       	mov    $0x0,%eax
  802d17:	e9 a9 03 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  802d1c:	a1 40 41 90 00       	mov    0x904140,%eax
  802d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d24:	e9 68 03 00 00       	jmp    803091 <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	83 e8 10             	sub    $0x10,%eax
  802d2f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d32:	0f 85 51 03 00 00    	jne    803089 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d40:	83 c2 10             	add    $0x10,%edx
  802d43:	39 d0                	cmp    %edx,%eax
  802d45:	75 08                	jne    802d4f <realloc_block_FF+0x99>
			{
				return va;
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	e9 76 03 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d57:	0f 83 45 02 00 00    	jae    802fa2 <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 08             	mov    0x8(%eax),%eax
  802d63:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8a 40 04             	mov    0x4(%eax),%al
  802d6c:	3c 01                	cmp    $0x1,%al
  802d6e:	0f 85 6b 01 00 00    	jne    802edf <realloc_block_FF+0x229>
  802d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d78:	0f 84 61 01 00 00    	je     802edf <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  802d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d81:	8b 10                	mov    (%eax),%edx
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d8b:	29 c1                	sub    %eax,%ecx
  802d8d:	89 c8                	mov    %ecx,%eax
  802d8f:	39 c2                	cmp    %eax,%edx
  802d91:	0f 86 e3 00 00 00    	jbe    802e7a <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 10                	mov    (%eax),%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	2b 45 0c             	sub    0xc(%ebp),%eax
  802da4:	01 d0                	add    %edx,%eax
  802da6:	83 f8 0f             	cmp    $0xf,%eax
  802da9:	0f 86 b5 00 00 00    	jbe    802e64 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db5:	01 d0                	add    %edx,%eax
  802db7:	83 c0 10             	add    $0x10,%eax
  802dba:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  802dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  802dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd1:	74 06                	je     802dd9 <realloc_block_FF+0x123>
  802dd3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dd7:	75 17                	jne    802df0 <realloc_block_FF+0x13a>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 5c 3c 80 00       	push   $0x803c5c
  802de1:	68 ae 01 00 00       	push   $0x1ae
  802de6:	68 43 3c 80 00       	push   $0x803c43
  802deb:	e8 11 d6 ff ff       	call   800401 <_panic>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 50 08             	mov    0x8(%eax),%edx
  802df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df9:	89 50 08             	mov    %edx,0x8(%eax)
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	8b 40 08             	mov    0x8(%eax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	74 0c                	je     802e12 <realloc_block_FF+0x15c>
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e18:	89 50 08             	mov    %edx,0x8(%eax)
  802e1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e21:	89 50 0c             	mov    %edx,0xc(%eax)
  802e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	75 08                	jne    802e36 <realloc_block_FF+0x180>
  802e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e31:	a3 44 41 90 00       	mov    %eax,0x904144
  802e36:	a1 4c 41 90 00       	mov    0x90414c,%eax
  802e3b:	40                   	inc    %eax
  802e3c:	a3 4c 41 90 00       	mov    %eax,0x90414c
							next->size = 0;
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  802e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e54:	8d 50 10             	lea    0x10(%eax),%edx
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	89 10                	mov    %edx,(%eax)
							return va;
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	e9 61 02 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  802e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e67:	8d 50 10             	lea    0x10(%eax),%edx
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	83 c0 10             	add    $0x10,%eax
  802e75:	e9 4b 02 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	8b 10                	mov    (%eax),%edx
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e87:	29 c1                	sub    %eax,%ecx
  802e89:	89 c8                	mov    %ecx,%eax
  802e8b:	39 c2                	cmp    %eax,%edx
  802e8d:	0f 83 f5 01 00 00    	jae    803088 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 0c             	pushl  0xc(%ebp)
  802e99:	e8 44 f2 ff ff       	call   8020e2 <alloc_block_FF>
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  802ea4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea8:	74 2d                	je     802ed7 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	50                   	push   %eax
  802eb3:	ff 75 08             	pushl  0x8(%ebp)
  802eb6:	ff 75 ec             	pushl  -0x14(%ebp)
  802eb9:	e8 a0 e0 ff ff       	call   800f5e <memcpy>
  802ebe:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  802ec1:	83 ec 0c             	sub    $0xc,%esp
  802ec4:	ff 75 08             	pushl  0x8(%ebp)
  802ec7:	e8 e3 f7 ff ff       	call   8026af <free_block>
  802ecc:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	e9 ee 01 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	e9 e6 01 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8a 40 04             	mov    0x4(%eax),%al
  802ee5:	3c 01                	cmp    $0x1,%al
  802ee7:	75 59                	jne    802f42 <realloc_block_FF+0x28c>
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	8b 10                	mov    (%eax),%edx
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ef6:	29 c1                	sub    %eax,%ecx
  802ef8:	89 c8                	mov    %ecx,%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	75 44                	jne    802f42 <realloc_block_FF+0x28c>
  802efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f02:	74 3e                	je     802f42 <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 40 08             	mov    0x8(%eax),%eax
  802f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f13:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  802f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1c:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  802f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f32:	8d 50 10             	lea    0x10(%eax),%edx
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	89 10                	mov    %edx,(%eax)
					return va;
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	e9 83 01 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	8a 40 04             	mov    0x4(%eax),%al
  802f48:	84 c0                	test   %al,%al
  802f4a:	74 0a                	je     802f56 <realloc_block_FF+0x2a0>
  802f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f50:	0f 85 33 01 00 00    	jne    803089 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  802f56:	83 ec 0c             	sub    $0xc,%esp
  802f59:	ff 75 0c             	pushl  0xc(%ebp)
  802f5c:	e8 81 f1 ff ff       	call   8020e2 <alloc_block_FF>
  802f61:	83 c4 10             	add    $0x10,%esp
  802f64:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  802f67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f6b:	74 2d                	je     802f9a <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	50                   	push   %eax
  802f76:	ff 75 08             	pushl  0x8(%ebp)
  802f79:	ff 75 e0             	pushl  -0x20(%ebp)
  802f7c:	e8 dd df ff ff       	call   800f5e <memcpy>
  802f81:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  802f84:	83 ec 0c             	sub    $0xc,%esp
  802f87:	ff 75 08             	pushl  0x8(%ebp)
  802f8a:	e8 20 f7 ff ff       	call   8026af <free_block>
  802f8f:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  802f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f95:	e9 2b 01 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	e9 23 01 00 00       	jmp    8030c5 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802faa:	0f 86 d9 00 00 00    	jbe    803089 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fb8:	83 f8 0f             	cmp    $0xf,%eax
  802fbb:	0f 86 b4 00 00 00    	jbe    803075 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  802fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	01 d0                	add    %edx,%eax
  802fc9:	83 c0 10             	add    $0x10,%eax
  802fcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fd7:	8d 50 f0             	lea    -0x10(%eax),%edx
  802fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdd:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe3:	74 06                	je     802feb <realloc_block_FF+0x335>
  802fe5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fe9:	75 17                	jne    803002 <realloc_block_FF+0x34c>
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	68 5c 3c 80 00       	push   $0x803c5c
  802ff3:	68 ed 01 00 00       	push   $0x1ed
  802ff8:	68 43 3c 80 00       	push   $0x803c43
  802ffd:	e8 ff d3 ff ff       	call   800401 <_panic>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	89 50 08             	mov    %edx,0x8(%eax)
  80300e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803011:	8b 40 08             	mov    0x8(%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0c                	je     803024 <realloc_block_FF+0x36e>
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	8b 40 08             	mov    0x8(%eax),%eax
  80301e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803021:	89 50 0c             	mov    %edx,0xc(%eax)
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80302a:	89 50 08             	mov    %edx,0x8(%eax)
  80302d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803033:	89 50 0c             	mov    %edx,0xc(%eax)
  803036:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803039:	8b 40 08             	mov    0x8(%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	75 08                	jne    803048 <realloc_block_FF+0x392>
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	a3 44 41 90 00       	mov    %eax,0x904144
  803048:	a1 4c 41 90 00       	mov    0x90414c,%eax
  80304d:	40                   	inc    %eax
  80304e:	a3 4c 41 90 00       	mov    %eax,0x90414c
					free_block((void*) (newBlockAfterSplit + 1));
  803053:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803056:	83 c0 10             	add    $0x10,%eax
  803059:	83 ec 0c             	sub    $0xc,%esp
  80305c:	50                   	push   %eax
  80305d:	e8 4d f6 ff ff       	call   8026af <free_block>
  803062:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803065:	8b 45 0c             	mov    0xc(%ebp),%eax
  803068:	8d 50 10             	lea    0x10(%eax),%edx
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	89 10                	mov    %edx,(%eax)
					return va;
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	eb 50                	jmp    8030c5 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803075:	8b 45 0c             	mov    0xc(%ebp),%eax
  803078:	8d 50 10             	lea    0x10(%eax),%edx
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	83 c0 10             	add    $0x10,%eax
  803086:	eb 3d                	jmp    8030c5 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803088:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803089:	a1 48 41 90 00       	mov    0x904148,%eax
  80308e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803095:	74 08                	je     80309f <realloc_block_FF+0x3e9>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 08             	mov    0x8(%eax),%eax
  80309d:	eb 05                	jmp    8030a4 <realloc_block_FF+0x3ee>
  80309f:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a4:	a3 48 41 90 00       	mov    %eax,0x904148
  8030a9:	a1 48 41 90 00       	mov    0x904148,%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	0f 85 73 fc ff ff    	jne    802d29 <realloc_block_FF+0x73>
  8030b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ba:	0f 85 69 fc ff ff    	jne    802d29 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    
  8030c7:	90                   	nop

008030c8 <__udivdi3>:
  8030c8:	55                   	push   %ebp
  8030c9:	57                   	push   %edi
  8030ca:	56                   	push   %esi
  8030cb:	53                   	push   %ebx
  8030cc:	83 ec 1c             	sub    $0x1c,%esp
  8030cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030df:	89 ca                	mov    %ecx,%edx
  8030e1:	89 f8                	mov    %edi,%eax
  8030e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030e7:	85 f6                	test   %esi,%esi
  8030e9:	75 2d                	jne    803118 <__udivdi3+0x50>
  8030eb:	39 cf                	cmp    %ecx,%edi
  8030ed:	77 65                	ja     803154 <__udivdi3+0x8c>
  8030ef:	89 fd                	mov    %edi,%ebp
  8030f1:	85 ff                	test   %edi,%edi
  8030f3:	75 0b                	jne    803100 <__udivdi3+0x38>
  8030f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fa:	31 d2                	xor    %edx,%edx
  8030fc:	f7 f7                	div    %edi
  8030fe:	89 c5                	mov    %eax,%ebp
  803100:	31 d2                	xor    %edx,%edx
  803102:	89 c8                	mov    %ecx,%eax
  803104:	f7 f5                	div    %ebp
  803106:	89 c1                	mov    %eax,%ecx
  803108:	89 d8                	mov    %ebx,%eax
  80310a:	f7 f5                	div    %ebp
  80310c:	89 cf                	mov    %ecx,%edi
  80310e:	89 fa                	mov    %edi,%edx
  803110:	83 c4 1c             	add    $0x1c,%esp
  803113:	5b                   	pop    %ebx
  803114:	5e                   	pop    %esi
  803115:	5f                   	pop    %edi
  803116:	5d                   	pop    %ebp
  803117:	c3                   	ret    
  803118:	39 ce                	cmp    %ecx,%esi
  80311a:	77 28                	ja     803144 <__udivdi3+0x7c>
  80311c:	0f bd fe             	bsr    %esi,%edi
  80311f:	83 f7 1f             	xor    $0x1f,%edi
  803122:	75 40                	jne    803164 <__udivdi3+0x9c>
  803124:	39 ce                	cmp    %ecx,%esi
  803126:	72 0a                	jb     803132 <__udivdi3+0x6a>
  803128:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80312c:	0f 87 9e 00 00 00    	ja     8031d0 <__udivdi3+0x108>
  803132:	b8 01 00 00 00       	mov    $0x1,%eax
  803137:	89 fa                	mov    %edi,%edx
  803139:	83 c4 1c             	add    $0x1c,%esp
  80313c:	5b                   	pop    %ebx
  80313d:	5e                   	pop    %esi
  80313e:	5f                   	pop    %edi
  80313f:	5d                   	pop    %ebp
  803140:	c3                   	ret    
  803141:	8d 76 00             	lea    0x0(%esi),%esi
  803144:	31 ff                	xor    %edi,%edi
  803146:	31 c0                	xor    %eax,%eax
  803148:	89 fa                	mov    %edi,%edx
  80314a:	83 c4 1c             	add    $0x1c,%esp
  80314d:	5b                   	pop    %ebx
  80314e:	5e                   	pop    %esi
  80314f:	5f                   	pop    %edi
  803150:	5d                   	pop    %ebp
  803151:	c3                   	ret    
  803152:	66 90                	xchg   %ax,%ax
  803154:	89 d8                	mov    %ebx,%eax
  803156:	f7 f7                	div    %edi
  803158:	31 ff                	xor    %edi,%edi
  80315a:	89 fa                	mov    %edi,%edx
  80315c:	83 c4 1c             	add    $0x1c,%esp
  80315f:	5b                   	pop    %ebx
  803160:	5e                   	pop    %esi
  803161:	5f                   	pop    %edi
  803162:	5d                   	pop    %ebp
  803163:	c3                   	ret    
  803164:	bd 20 00 00 00       	mov    $0x20,%ebp
  803169:	89 eb                	mov    %ebp,%ebx
  80316b:	29 fb                	sub    %edi,%ebx
  80316d:	89 f9                	mov    %edi,%ecx
  80316f:	d3 e6                	shl    %cl,%esi
  803171:	89 c5                	mov    %eax,%ebp
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 ed                	shr    %cl,%ebp
  803177:	89 e9                	mov    %ebp,%ecx
  803179:	09 f1                	or     %esi,%ecx
  80317b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80317f:	89 f9                	mov    %edi,%ecx
  803181:	d3 e0                	shl    %cl,%eax
  803183:	89 c5                	mov    %eax,%ebp
  803185:	89 d6                	mov    %edx,%esi
  803187:	88 d9                	mov    %bl,%cl
  803189:	d3 ee                	shr    %cl,%esi
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e2                	shl    %cl,%edx
  80318f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803193:	88 d9                	mov    %bl,%cl
  803195:	d3 e8                	shr    %cl,%eax
  803197:	09 c2                	or     %eax,%edx
  803199:	89 d0                	mov    %edx,%eax
  80319b:	89 f2                	mov    %esi,%edx
  80319d:	f7 74 24 0c          	divl   0xc(%esp)
  8031a1:	89 d6                	mov    %edx,%esi
  8031a3:	89 c3                	mov    %eax,%ebx
  8031a5:	f7 e5                	mul    %ebp
  8031a7:	39 d6                	cmp    %edx,%esi
  8031a9:	72 19                	jb     8031c4 <__udivdi3+0xfc>
  8031ab:	74 0b                	je     8031b8 <__udivdi3+0xf0>
  8031ad:	89 d8                	mov    %ebx,%eax
  8031af:	31 ff                	xor    %edi,%edi
  8031b1:	e9 58 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031bc:	89 f9                	mov    %edi,%ecx
  8031be:	d3 e2                	shl    %cl,%edx
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	73 e9                	jae    8031ad <__udivdi3+0xe5>
  8031c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031c7:	31 ff                	xor    %edi,%edi
  8031c9:	e9 40 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031ce:	66 90                	xchg   %ax,%ax
  8031d0:	31 c0                	xor    %eax,%eax
  8031d2:	e9 37 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031d7:	90                   	nop

008031d8 <__umoddi3>:
  8031d8:	55                   	push   %ebp
  8031d9:	57                   	push   %edi
  8031da:	56                   	push   %esi
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 1c             	sub    $0x1c,%esp
  8031df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031f7:	89 f3                	mov    %esi,%ebx
  8031f9:	89 fa                	mov    %edi,%edx
  8031fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ff:	89 34 24             	mov    %esi,(%esp)
  803202:	85 c0                	test   %eax,%eax
  803204:	75 1a                	jne    803220 <__umoddi3+0x48>
  803206:	39 f7                	cmp    %esi,%edi
  803208:	0f 86 a2 00 00 00    	jbe    8032b0 <__umoddi3+0xd8>
  80320e:	89 c8                	mov    %ecx,%eax
  803210:	89 f2                	mov    %esi,%edx
  803212:	f7 f7                	div    %edi
  803214:	89 d0                	mov    %edx,%eax
  803216:	31 d2                	xor    %edx,%edx
  803218:	83 c4 1c             	add    $0x1c,%esp
  80321b:	5b                   	pop    %ebx
  80321c:	5e                   	pop    %esi
  80321d:	5f                   	pop    %edi
  80321e:	5d                   	pop    %ebp
  80321f:	c3                   	ret    
  803220:	39 f0                	cmp    %esi,%eax
  803222:	0f 87 ac 00 00 00    	ja     8032d4 <__umoddi3+0xfc>
  803228:	0f bd e8             	bsr    %eax,%ebp
  80322b:	83 f5 1f             	xor    $0x1f,%ebp
  80322e:	0f 84 ac 00 00 00    	je     8032e0 <__umoddi3+0x108>
  803234:	bf 20 00 00 00       	mov    $0x20,%edi
  803239:	29 ef                	sub    %ebp,%edi
  80323b:	89 fe                	mov    %edi,%esi
  80323d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803241:	89 e9                	mov    %ebp,%ecx
  803243:	d3 e0                	shl    %cl,%eax
  803245:	89 d7                	mov    %edx,%edi
  803247:	89 f1                	mov    %esi,%ecx
  803249:	d3 ef                	shr    %cl,%edi
  80324b:	09 c7                	or     %eax,%edi
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 e2                	shl    %cl,%edx
  803251:	89 14 24             	mov    %edx,(%esp)
  803254:	89 d8                	mov    %ebx,%eax
  803256:	d3 e0                	shl    %cl,%eax
  803258:	89 c2                	mov    %eax,%edx
  80325a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80325e:	d3 e0                	shl    %cl,%eax
  803260:	89 44 24 04          	mov    %eax,0x4(%esp)
  803264:	8b 44 24 08          	mov    0x8(%esp),%eax
  803268:	89 f1                	mov    %esi,%ecx
  80326a:	d3 e8                	shr    %cl,%eax
  80326c:	09 d0                	or     %edx,%eax
  80326e:	d3 eb                	shr    %cl,%ebx
  803270:	89 da                	mov    %ebx,%edx
  803272:	f7 f7                	div    %edi
  803274:	89 d3                	mov    %edx,%ebx
  803276:	f7 24 24             	mull   (%esp)
  803279:	89 c6                	mov    %eax,%esi
  80327b:	89 d1                	mov    %edx,%ecx
  80327d:	39 d3                	cmp    %edx,%ebx
  80327f:	0f 82 87 00 00 00    	jb     80330c <__umoddi3+0x134>
  803285:	0f 84 91 00 00 00    	je     80331c <__umoddi3+0x144>
  80328b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80328f:	29 f2                	sub    %esi,%edx
  803291:	19 cb                	sbb    %ecx,%ebx
  803293:	89 d8                	mov    %ebx,%eax
  803295:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803299:	d3 e0                	shl    %cl,%eax
  80329b:	89 e9                	mov    %ebp,%ecx
  80329d:	d3 ea                	shr    %cl,%edx
  80329f:	09 d0                	or     %edx,%eax
  8032a1:	89 e9                	mov    %ebp,%ecx
  8032a3:	d3 eb                	shr    %cl,%ebx
  8032a5:	89 da                	mov    %ebx,%edx
  8032a7:	83 c4 1c             	add    $0x1c,%esp
  8032aa:	5b                   	pop    %ebx
  8032ab:	5e                   	pop    %esi
  8032ac:	5f                   	pop    %edi
  8032ad:	5d                   	pop    %ebp
  8032ae:	c3                   	ret    
  8032af:	90                   	nop
  8032b0:	89 fd                	mov    %edi,%ebp
  8032b2:	85 ff                	test   %edi,%edi
  8032b4:	75 0b                	jne    8032c1 <__umoddi3+0xe9>
  8032b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bb:	31 d2                	xor    %edx,%edx
  8032bd:	f7 f7                	div    %edi
  8032bf:	89 c5                	mov    %eax,%ebp
  8032c1:	89 f0                	mov    %esi,%eax
  8032c3:	31 d2                	xor    %edx,%edx
  8032c5:	f7 f5                	div    %ebp
  8032c7:	89 c8                	mov    %ecx,%eax
  8032c9:	f7 f5                	div    %ebp
  8032cb:	89 d0                	mov    %edx,%eax
  8032cd:	e9 44 ff ff ff       	jmp    803216 <__umoddi3+0x3e>
  8032d2:	66 90                	xchg   %ax,%ax
  8032d4:	89 c8                	mov    %ecx,%eax
  8032d6:	89 f2                	mov    %esi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	3b 04 24             	cmp    (%esp),%eax
  8032e3:	72 06                	jb     8032eb <__umoddi3+0x113>
  8032e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032e9:	77 0f                	ja     8032fa <__umoddi3+0x122>
  8032eb:	89 f2                	mov    %esi,%edx
  8032ed:	29 f9                	sub    %edi,%ecx
  8032ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032f3:	89 14 24             	mov    %edx,(%esp)
  8032f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032fe:	8b 14 24             	mov    (%esp),%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	2b 04 24             	sub    (%esp),%eax
  80330f:	19 fa                	sbb    %edi,%edx
  803311:	89 d1                	mov    %edx,%ecx
  803313:	89 c6                	mov    %eax,%esi
  803315:	e9 71 ff ff ff       	jmp    80328b <__umoddi3+0xb3>
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803320:	72 ea                	jb     80330c <__umoddi3+0x134>
  803322:	89 d9                	mov    %ebx,%ecx
  803324:	e9 62 ff ff ff       	jmp    80328b <__umoddi3+0xb3>
