
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 58 12 00 00       	call   80128e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec a0 01 00 00    	sub    $0x1a0,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 40 43 80 00       	push   $0x804340
  800065:	6a 1a                	push   $0x1a
  800067:	68 5c 43 80 00       	push   $0x80435c
  80006c:	e8 4b 13 00 00       	call   8013bc <_panic>
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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;

	int start_freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 14 28 00 00       	call   8028c1 <sys_calculate_free_frames>
  8000ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000b0:	8d 95 c8 fe ff ff    	lea    -0x138(%ebp),%edx
  8000b6:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	89 d7                	mov    %edx,%edi
  8000c2:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ALL
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 f8 27 00 00       	call   8028c1 <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 3b 28 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 bd 23 00 00       	call   8024a2 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000ee:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8000f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 70 43 80 00       	push   $0x804370
  800101:	6a 3d                	push   $0x3d
  800103:	68 5c 43 80 00       	push   $0x80435c
  800108:	e8 af 12 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80010d:	e8 fa 27 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800112:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800115:	74 14                	je     80012b <_main+0xf3>
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 a0 43 80 00       	push   $0x8043a0
  80011f:	6a 3e                	push   $0x3e
  800121:	68 5c 43 80 00       	push   $0x80435c
  800126:	e8 91 12 00 00       	call   8013bc <_panic>


			freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 91 27 00 00       	call   8028c1 <sys_calculate_free_frames>
  800130:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800136:	01 c0                	add    %eax,%eax
  800138:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80013b:	48                   	dec    %eax
  80013c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr = (char *) ptr_allocations[0];
  80013f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800145:	89 45 c8             	mov    %eax,-0x38(%ebp)
			byteArr[0] = minByte ;
  800148:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80014b:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80014e:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800150:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800153:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800156:	01 c2                	add    %eax,%edx
  800158:	8a 45 ea             	mov    -0x16(%ebp),%al
  80015b:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  80015d:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800164:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800167:	e8 55 27 00 00       	call   8028c1 <sys_calculate_free_frames>
  80016c:	29 c3                	sub    %eax,%ebx
  80016e:	89 d8                	mov    %ebx,%eax
  800170:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800173:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800176:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800179:	7d 1a                	jge    800195 <_main+0x15d>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	ff 75 c0             	pushl  -0x40(%ebp)
  800181:	ff 75 c4             	pushl  -0x3c(%ebp)
  800184:	68 d0 43 80 00       	push   $0x8043d0
  800189:	6a 49                	push   $0x49
  80018b:	68 5c 43 80 00       	push   $0x80435c
  800190:	e8 27 12 00 00       	call   8013bc <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800195:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800198:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80019b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a3:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  8001a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bc:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001c2:	6a 02                	push   $0x2
  8001c4:	6a 00                	push   $0x0
  8001c6:	6a 02                	push   $0x2
  8001c8:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8001ce:	50                   	push   %eax
  8001cf:	e8 0a 2c 00 00       	call   802dde <sys_check_WS_list>
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001da:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8001de:	74 14                	je     8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 4c 44 80 00       	push   $0x80444c
  8001e8:	6a 4d                	push   $0x4d
  8001ea:	68 5c 43 80 00       	push   $0x80435c
  8001ef:	e8 c8 11 00 00       	call   8013bc <_panic>
		}

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001f4:	e8 c8 26 00 00       	call   8028c1 <sys_calculate_free_frames>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fc:	e8 0b 27 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  800204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 8d 22 00 00       	call   8024a2 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800224:	89 c2                	mov    %eax,%edx
  800226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800229:	01 c0                	add    %eax,%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	01 c8                	add    %ecx,%eax
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 70 43 80 00       	push   $0x804370
  80023e:	6a 55                	push   $0x55
  800240:	68 5c 43 80 00       	push   $0x80435c
  800245:	e8 72 11 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80024a:	e8 bd 26 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80024f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800252:	74 14                	je     800268 <_main+0x230>
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 a0 43 80 00       	push   $0x8043a0
  80025c:	6a 56                	push   $0x56
  80025e:	68 5c 43 80 00       	push   $0x80435c
  800263:	e8 54 11 00 00       	call   8013bc <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800268:	e8 54 26 00 00       	call   8028c1 <sys_calculate_free_frames>
  80026d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr = (short *) ptr_allocations[1];
  800270:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800276:	89 45 b0             	mov    %eax,-0x50(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	01 c0                	add    %eax,%eax
  80027e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800281:	d1 e8                	shr    %eax
  800283:	48                   	dec    %eax
  800284:	89 45 ac             	mov    %eax,-0x54(%ebp)
			shortArr[0] = minShort;
  800287:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  800290:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800293:	01 c0                	add    %eax,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80029a:	01 c2                	add    %eax,%edx
  80029c:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8002a0:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/;
  8002a3:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8002aa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ad:	e8 0f 26 00 00       	call   8028c1 <sys_calculate_free_frames>
  8002b2:	29 c3                	sub    %eax,%ebx
  8002b4:	89 d8                	mov    %ebx,%eax
  8002b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  8002b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002bc:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002bf:	7d 1a                	jge    8002db <_main+0x2a3>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ca:	68 d0 43 80 00       	push   $0x8043d0
  8002cf:	6a 60                	push   $0x60
  8002d1:	68 5c 43 80 00       	push   $0x80435c
  8002d6:	e8 e1 10 00 00       	call   8013bc <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8002db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002de:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8002e1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e9:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  8002ef:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002f2:	01 c0                	add    %eax,%eax
  8002f4:	89 c2                	mov    %eax,%edx
  8002f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8002fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800301:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800306:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80030c:	6a 02                	push   $0x2
  80030e:	6a 00                	push   $0x0
  800310:	6a 02                	push   $0x2
  800312:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800318:	50                   	push   %eax
  800319:	e8 c0 2a 00 00       	call   802dde <sys_check_WS_list>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800324:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800328:	74 14                	je     80033e <_main+0x306>
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 4c 44 80 00       	push   $0x80444c
  800332:	6a 63                	push   $0x63
  800334:	68 5c 43 80 00       	push   $0x80435c
  800339:	e8 7e 10 00 00       	call   8013bc <_panic>
		}
		//cprintf("5\n");

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80033e:	e8 7e 25 00 00       	call   8028c1 <sys_calculate_free_frames>
  800343:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800346:	e8 c1 25 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80034b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80034e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	01 d2                	add    %edx,%edx
  800355:	01 d0                	add    %edx,%eax
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	50                   	push   %eax
  80035b:	e8 42 21 00 00       	call   8024a2 <malloc>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800369:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80036f:	89 c2                	mov    %eax,%edx
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	c1 e0 02             	shl    $0x2,%eax
  800377:	89 c1                	mov    %eax,%ecx
  800379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	39 c2                	cmp    %eax,%edx
  800380:	74 14                	je     800396 <_main+0x35e>
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 70 43 80 00       	push   $0x804370
  80038a:	6a 6c                	push   $0x6c
  80038c:	68 5c 43 80 00       	push   $0x80435c
  800391:	e8 26 10 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800396:	e8 71 25 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80039b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 a0 43 80 00       	push   $0x8043a0
  8003a8:	6a 6d                	push   $0x6d
  8003aa:	68 5c 43 80 00       	push   $0x80435c
  8003af:	e8 08 10 00 00       	call   8013bc <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8003b4:	e8 08 25 00 00       	call   8028c1 <sys_calculate_free_frames>
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			intArr = (int *) ptr_allocations[2];
  8003bc:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8003c2:	89 45 a0             	mov    %eax,-0x60(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8003c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	c1 e8 02             	shr    $0x2,%eax
  8003cd:	48                   	dec    %eax
  8003ce:	89 45 9c             	mov    %eax,-0x64(%ebp)
			intArr[0] = minInt;
  8003d1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d7:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  8003d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  8003ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003f4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003f7:	e8 c5 24 00 00       	call   8028c1 <sys_calculate_free_frames>
  8003fc:	29 c3                	sub    %eax,%ebx
  8003fe:	89 d8                	mov    %ebx,%eax
  800400:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800403:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800406:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800409:	7d 1a                	jge    800425 <_main+0x3ed>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	ff 75 c0             	pushl  -0x40(%ebp)
  800411:	ff 75 c4             	pushl  -0x3c(%ebp)
  800414:	68 d0 43 80 00       	push   $0x8043d0
  800419:	6a 77                	push   $0x77
  80041b:	68 5c 43 80 00       	push   $0x80435c
  800420:	e8 97 0f 00 00       	call   8013bc <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800425:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800428:	89 45 98             	mov    %eax,-0x68(%ebp)
  80042b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80042e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800433:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
  800439:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80043c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800443:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80044b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80044e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800453:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800459:	6a 02                	push   $0x2
  80045b:	6a 00                	push   $0x0
  80045d:	6a 02                	push   $0x2
  80045f:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	e8 73 29 00 00       	call   802dde <sys_check_WS_list>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800471:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800475:	74 14                	je     80048b <_main+0x453>
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	68 4c 44 80 00       	push   $0x80444c
  80047f:	6a 7a                	push   $0x7a
  800481:	68 5c 43 80 00       	push   $0x80435c
  800486:	e8 31 0f 00 00       	call   8013bc <_panic>
		}

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80048b:	e8 31 24 00 00       	call   8028c1 <sys_calculate_free_frames>
  800490:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800493:	e8 74 24 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  80049b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	01 d2                	add    %edx,%edx
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	50                   	push   %eax
  8004a8:	e8 f5 1f 00 00       	call   8024a2 <malloc>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  8004b6:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c1:	c1 e0 02             	shl    $0x2,%eax
  8004c4:	89 c1                	mov    %eax,%ecx
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	c1 e0 02             	shl    $0x2,%eax
  8004cc:	01 c1                	add    %eax,%ecx
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d1:	01 c8                	add    %ecx,%eax
  8004d3:	39 c2                	cmp    %eax,%edx
  8004d5:	74 17                	je     8004ee <_main+0x4b6>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 70 43 80 00       	push   $0x804370
  8004df:	68 82 00 00 00       	push   $0x82
  8004e4:	68 5c 43 80 00       	push   $0x80435c
  8004e9:	e8 ce 0e 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ee:	e8 19 24 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8004f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004f6:	74 17                	je     80050f <_main+0x4d7>
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 a0 43 80 00       	push   $0x8043a0
  800500:	68 83 00 00 00       	push   $0x83
  800505:	68 5c 43 80 00       	push   $0x80435c
  80050a:	e8 ad 0e 00 00       	call   8013bc <_panic>
		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80050f:	e8 ad 23 00 00       	call   8028c1 <sys_calculate_free_frames>
  800514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800517:	e8 f0 23 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80051c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  80051f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800522:	89 d0                	mov    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	01 c0                	add    %eax,%eax
  80052a:	01 d0                	add    %edx,%eax
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	50                   	push   %eax
  800530:	e8 6d 1f 00 00       	call   8024a2 <malloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  80053e:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800544:	89 c2                	mov    %eax,%edx
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	c1 e0 02             	shl    $0x2,%eax
  80054c:	89 c1                	mov    %eax,%ecx
  80054e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800551:	c1 e0 03             	shl    $0x3,%eax
  800554:	01 c1                	add    %eax,%ecx
  800556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800559:	01 c8                	add    %ecx,%eax
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	74 17                	je     800576 <_main+0x53e>
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 70 43 80 00       	push   $0x804370
  800567:	68 8b 00 00 00       	push   $0x8b
  80056c:	68 5c 43 80 00       	push   $0x80435c
  800571:	e8 46 0e 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800576:	e8 91 23 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80057b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 a0 43 80 00       	push   $0x8043a0
  800588:	68 8c 00 00 00       	push   $0x8c
  80058d:	68 5c 43 80 00       	push   $0x80435c
  800592:	e8 25 0e 00 00       	call   8013bc <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800597:	e8 25 23 00 00       	call   8028c1 <sys_calculate_free_frames>
  80059c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80059f:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8005a5:	89 45 90             	mov    %eax,-0x70(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8005a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005ab:	89 d0                	mov    %edx,%eax
  8005ad:	01 c0                	add    %eax,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	01 c0                	add    %eax,%eax
  8005b3:	01 d0                	add    %edx,%eax
  8005b5:	c1 e8 03             	shr    $0x3,%eax
  8005b8:	48                   	dec    %eax
  8005b9:	89 45 8c             	mov    %eax,-0x74(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8005bc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bf:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8005c2:	88 10                	mov    %dl,(%eax)
  8005c4:	8b 55 90             	mov    -0x70(%ebp),%edx
  8005c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ca:	66 89 42 02          	mov    %ax,0x2(%edx)
  8005ce:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d4:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8005d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005e4:	01 c2                	add    %eax,%edx
  8005e6:	8a 45 ea             	mov    -0x16(%ebp),%al
  8005e9:	88 02                	mov    %al,(%edx)
  8005eb:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005f8:	01 c2                	add    %eax,%edx
  8005fa:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8005fe:	66 89 42 02          	mov    %ax,0x2(%edx)
  800602:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800605:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80060f:	01 c2                	add    %eax,%edx
  800611:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800614:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800617:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80061e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800621:	e8 9b 22 00 00       	call   8028c1 <sys_calculate_free_frames>
  800626:	29 c3                	sub    %eax,%ebx
  800628:	89 d8                	mov    %ebx,%eax
  80062a:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80062d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800630:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800633:	7d 1d                	jge    800652 <_main+0x61a>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	ff 75 c0             	pushl  -0x40(%ebp)
  80063b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80063e:	68 d0 43 80 00       	push   $0x8043d0
  800643:	68 96 00 00 00       	push   $0x96
  800648:	68 5c 43 80 00       	push   $0x80435c
  80064d:	e8 6a 0d 00 00       	call   8013bc <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800652:	8b 45 90             	mov    -0x70(%ebp),%eax
  800655:	89 45 88             	mov    %eax,-0x78(%ebp)
  800658:	8b 45 88             	mov    -0x78(%ebp),%eax
  80065b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800660:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
  800666:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800669:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800670:	8b 45 90             	mov    -0x70(%ebp),%eax
  800673:	01 d0                	add    %edx,%eax
  800675:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800678:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80067b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800680:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800686:	6a 02                	push   $0x2
  800688:	6a 00                	push   $0x0
  80068a:	6a 02                	push   $0x2
  80068c:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800692:	50                   	push   %eax
  800693:	e8 46 27 00 00       	call   802dde <sys_check_WS_list>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  80069e:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8006a2:	74 17                	je     8006bb <_main+0x683>
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 4c 44 80 00       	push   $0x80444c
  8006ac:	68 99 00 00 00       	push   $0x99
  8006b1:	68 5c 43 80 00       	push   $0x80435c
  8006b6:	e8 01 0d 00 00       	call   8013bc <_panic>
		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006bb:	e8 01 22 00 00       	call   8028c1 <sys_calculate_free_frames>
  8006c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006c3:	e8 44 22 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8006cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	01 d2                	add    %edx,%edx
  8006d2:	01 d0                	add    %edx,%eax
  8006d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	50                   	push   %eax
  8006db:	e8 c2 1d 00 00       	call   8024a2 <malloc>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006e9:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8006ef:	89 c2                	mov    %eax,%edx
  8006f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f4:	c1 e0 02             	shl    $0x2,%eax
  8006f7:	89 c1                	mov    %eax,%ecx
  8006f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fc:	c1 e0 04             	shl    $0x4,%eax
  8006ff:	01 c1                	add    %eax,%ecx
  800701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800704:	01 c8                	add    %ecx,%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 70 43 80 00       	push   $0x804370
  800712:	68 a1 00 00 00       	push   $0xa1
  800717:	68 5c 43 80 00       	push   $0x80435c
  80071c:	e8 9b 0c 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800721:	e8 e6 21 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800726:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800729:	74 17                	je     800742 <_main+0x70a>
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	68 a0 43 80 00       	push   $0x8043a0
  800733:	68 a2 00 00 00       	push   $0xa2
  800738:	68 5c 43 80 00       	push   $0x80435c
  80073d:	e8 7a 0c 00 00       	call   8013bc <_panic>
		}

		//6 MB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800742:	e8 c5 21 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800747:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80074a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	01 c0                	add    %eax,%eax
  800751:	01 d0                	add    %edx,%eax
  800753:	01 c0                	add    %eax,%eax
  800755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800758:	83 ec 0c             	sub    $0xc,%esp
  80075b:	50                   	push   %eax
  80075c:	e8 41 1d 00 00       	call   8024a2 <malloc>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80076a:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800770:	89 c1                	mov    %eax,%ecx
  800772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800775:	89 d0                	mov    %edx,%eax
  800777:	01 c0                	add    %eax,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	01 c0                	add    %eax,%eax
  80077d:	01 d0                	add    %edx,%eax
  80077f:	89 c2                	mov    %eax,%edx
  800781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800784:	c1 e0 04             	shl    $0x4,%eax
  800787:	01 c2                	add    %eax,%edx
  800789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078c:	01 d0                	add    %edx,%eax
  80078e:	39 c1                	cmp    %eax,%ecx
  800790:	74 17                	je     8007a9 <_main+0x771>
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	68 70 43 80 00       	push   $0x804370
  80079a:	68 a9 00 00 00       	push   $0xa9
  80079f:	68 5c 43 80 00       	push   $0x80435c
  8007a4:	e8 13 0c 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8007a9:	e8 5e 21 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8007ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007b1:	74 17                	je     8007ca <_main+0x792>
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	68 a0 43 80 00       	push   $0x8043a0
  8007bb:	68 aa 00 00 00       	push   $0xaa
  8007c0:	68 5c 43 80 00       	push   $0x80435c
  8007c5:	e8 f2 0b 00 00       	call   8013bc <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8007ca:	e8 f2 20 00 00       	call   8028c1 <sys_calculate_free_frames>
  8007cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  8007d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007d5:	89 d0                	mov    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	01 c0                	add    %eax,%eax
  8007dd:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8007e0:	48                   	dec    %eax
  8007e1:	89 45 80             	mov    %eax,-0x80(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  8007e4:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8007ea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			byteArr2[0] = minByte ;
  8007f0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8007f6:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8007f9:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8007fb:	8b 45 80             	mov    -0x80(%ebp),%eax
  8007fe:	89 c2                	mov    %eax,%edx
  800800:	c1 ea 1f             	shr    $0x1f,%edx
  800803:	01 d0                	add    %edx,%eax
  800805:	d1 f8                	sar    %eax
  800807:	89 c2                	mov    %eax,%edx
  800809:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80080f:	01 c2                	add    %eax,%edx
  800811:	8a 45 ea             	mov    -0x16(%ebp),%al
  800814:	88 c1                	mov    %al,%cl
  800816:	c0 e9 07             	shr    $0x7,%cl
  800819:	01 c8                	add    %ecx,%eax
  80081b:	d0 f8                	sar    %al
  80081d:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  80081f:	8b 55 80             	mov    -0x80(%ebp),%edx
  800822:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800828:	01 c2                	add    %eax,%edx
  80082a:	8a 45 ea             	mov    -0x16(%ebp),%al
  80082d:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 /*+2 tables already created in malloc due to marking the allocated pages*/ ;
  80082f:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800836:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800839:	e8 83 20 00 00       	call   8028c1 <sys_calculate_free_frames>
  80083e:	29 c3                	sub    %eax,%ebx
  800840:	89 d8                	mov    %ebx,%eax
  800842:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800845:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800848:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80084b:	7d 1d                	jge    80086a <_main+0x832>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	ff 75 c0             	pushl  -0x40(%ebp)
  800853:	ff 75 c4             	pushl  -0x3c(%ebp)
  800856:	68 d0 43 80 00       	push   $0x8043d0
  80085b:	68 b5 00 00 00       	push   $0xb5
  800860:	68 5c 43 80 00       	push   $0x80435c
  800865:	e8 52 0b 00 00       	call   8013bc <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800876:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800881:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800887:	8b 45 80             	mov    -0x80(%ebp),%eax
  80088a:	89 c2                	mov    %eax,%edx
  80088c:	c1 ea 1f             	shr    $0x1f,%edx
  80088f:	01 d0                	add    %edx,%eax
  800891:	d1 f8                	sar    %eax
  800893:	89 c2                	mov    %eax,%edx
  800895:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8008a3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8008a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ae:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
  8008b4:	8b 55 80             	mov    -0x80(%ebp),%edx
  8008b7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8008c5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8008cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008d0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 3, 0, 2);
  8008d6:	6a 02                	push   $0x2
  8008d8:	6a 00                	push   $0x0
  8008da:	6a 03                	push   $0x3
  8008dc:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8008e2:	50                   	push   %eax
  8008e3:	e8 f6 24 00 00       	call   802dde <sys_check_WS_list>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8008ee:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 4c 44 80 00       	push   $0x80444c
  8008fc:	68 b8 00 00 00       	push   $0xb8
  800901:	68 5c 43 80 00       	push   $0x80435c
  800906:	e8 b1 0a 00 00       	call   8013bc <_panic>
		}

		//14 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80090b:	e8 fc 1f 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800910:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800913:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800916:	89 d0                	mov    %edx,%eax
  800918:	01 c0                	add    %eax,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	01 c0                	add    %eax,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 77 1b 00 00       	call   8024a2 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800934:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80093a:	89 c1                	mov    %eax,%ecx
  80093c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80093f:	89 d0                	mov    %edx,%eax
  800941:	01 c0                	add    %eax,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	c1 e0 02             	shl    $0x2,%eax
  800948:	01 d0                	add    %edx,%eax
  80094a:	89 c2                	mov    %eax,%edx
  80094c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094f:	c1 e0 04             	shl    $0x4,%eax
  800952:	01 c2                	add    %eax,%edx
  800954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	39 c1                	cmp    %eax,%ecx
  80095b:	74 17                	je     800974 <_main+0x93c>
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	68 70 43 80 00       	push   $0x804370
  800965:	68 bf 00 00 00       	push   $0xbf
  80096a:	68 5c 43 80 00       	push   $0x80435c
  80096f:	e8 48 0a 00 00       	call   8013bc <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800974:	e8 93 1f 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800979:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80097c:	74 17                	je     800995 <_main+0x95d>
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	68 a0 43 80 00       	push   $0x8043a0
  800986:	68 c0 00 00 00       	push   $0xc0
  80098b:	68 5c 43 80 00       	push   $0x80435c
  800990:	e8 27 0a 00 00       	call   8013bc <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800995:	e8 27 1f 00 00       	call   8028c1 <sys_calculate_free_frames>
  80099a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  80099d:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8009a3:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8009a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009ac:	89 d0                	mov    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	01 c0                	add    %eax,%eax
  8009b4:	01 d0                	add    %edx,%eax
  8009b6:	01 c0                	add    %eax,%eax
  8009b8:	d1 e8                	shr    %eax
  8009ba:	48                   	dec    %eax
  8009bb:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
			shortArr2[0] = minShort;
  8009c1:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  8009c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ca:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  8009cd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009d3:	89 c2                	mov    %eax,%edx
  8009d5:	c1 ea 1f             	shr    $0x1f,%edx
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	d1 f8                	sar    %eax
  8009dc:	01 c0                	add    %eax,%eax
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8009e6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8009e9:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	66 c1 ea 0f          	shr    $0xf,%dx
  8009f3:	01 d0                	add    %edx,%eax
  8009f5:	66 d1 f8             	sar    %ax
  8009f8:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  8009fb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a01:	01 c0                	add    %eax,%eax
  800a03:	89 c2                	mov    %eax,%edx
  800a05:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a0b:	01 c2                	add    %eax,%edx
  800a0d:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800a11:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800a14:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800a1b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a1e:	e8 9e 1e 00 00       	call   8028c1 <sys_calculate_free_frames>
  800a23:	29 c3                	sub    %eax,%ebx
  800a25:	89 d8                	mov    %ebx,%eax
  800a27:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800a2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a2d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a30:	7d 1d                	jge    800a4f <_main+0xa17>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800a32:	83 ec 0c             	sub    $0xc,%esp
  800a35:	ff 75 c0             	pushl  -0x40(%ebp)
  800a38:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3b:	68 d0 43 80 00       	push   $0x8043d0
  800a40:	68 cb 00 00 00       	push   $0xcb
  800a45:	68 5c 43 80 00       	push   $0x80435c
  800a4a:	e8 6d 09 00 00       	call   8013bc <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800a4f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a55:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800a5b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800a61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a66:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800a6c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a72:	89 c2                	mov    %eax,%edx
  800a74:	c1 ea 1f             	shr    $0x1f,%edx
  800a77:	01 d0                	add    %edx,%eax
  800a79:	d1 f8                	sar    %eax
  800a7b:	01 c0                	add    %eax,%eax
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a85:	01 d0                	add    %edx,%eax
  800a87:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800a8d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a98:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800a9e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800aa4:	01 c0                	add    %eax,%eax
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800aae:	01 d0                	add    %edx,%eax
  800ab0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800ab6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800abc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac1:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			chk = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800ac7:	6a 02                	push   $0x2
  800ac9:	6a 00                	push   $0x0
  800acb:	6a 03                	push   $0x3
  800acd:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ad3:	50                   	push   %eax
  800ad4:	e8 05 23 00 00       	call   802dde <sys_check_WS_list>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800adf:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ae3:	74 17                	je     800afc <_main+0xac4>
  800ae5:	83 ec 04             	sub    $0x4,%esp
  800ae8:	68 4c 44 80 00       	push   $0x80444c
  800aed:	68 ce 00 00 00       	push   $0xce
  800af2:	68 5c 43 80 00       	push   $0x80435c
  800af7:	e8 c0 08 00 00       	call   8013bc <_panic>
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aff:	89 d0                	mov    %edx,%eax
  800b01:	01 c0                	add    %eax,%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	c1 e0 02             	shl    $0x2,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0f:	c1 e0 05             	shl    $0x5,%eax
  800b12:	01 c2                	add    %eax,%edx
  800b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b17:	01 d0                	add    %edx,%eax
  800b19:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

	//FREE ALL
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800b1f:	e8 9d 1d 00 00       	call   8028c1 <sys_calculate_free_frames>
  800b24:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b27:	e8 e0 1d 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[0]);
  800b2f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800b35:	83 ec 0c             	sub    $0xc,%esp
  800b38:	50                   	push   %eax
  800b39:	e8 c0 1a 00 00       	call   8025fe <free>
  800b3e:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800b41:	e8 c6 1d 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800b46:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800b49:	74 17                	je     800b62 <_main+0xb2a>
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	68 6c 44 80 00       	push   $0x80446c
  800b53:	68 db 00 00 00       	push   $0xdb
  800b58:	68 5c 43 80 00       	push   $0x80435c
  800b5d:	e8 5a 08 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800b62:	e8 5a 1d 00 00       	call   8028c1 <sys_calculate_free_frames>
  800b67:	89 c2                	mov    %eax,%edx
  800b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b6c:	29 c2                	sub    %eax,%edx
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	83 f8 02             	cmp    $0x2,%eax
  800b73:	74 17                	je     800b8c <_main+0xb54>
  800b75:	83 ec 04             	sub    $0x4,%esp
  800b78:	68 a8 44 80 00       	push   $0x8044a8
  800b7d:	68 dc 00 00 00       	push   $0xdc
  800b82:	68 5c 43 80 00       	push   $0x80435c
  800b87:	e8 30 08 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800b8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b8f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b95:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba0:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800ba6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800ba9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bac:	01 d0                	add    %edx,%eax
  800bae:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800bb4:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bbf:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800bc5:	6a 03                	push   $0x3
  800bc7:	6a 00                	push   $0x0
  800bc9:	6a 02                	push   $0x2
  800bcb:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800bd1:	50                   	push   %eax
  800bd2:	e8 07 22 00 00       	call   802dde <sys_check_WS_list>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800bdd:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800be1:	74 17                	je     800bfa <_main+0xbc2>
  800be3:	83 ec 04             	sub    $0x4,%esp
  800be6:	68 f4 44 80 00       	push   $0x8044f4
  800beb:	68 df 00 00 00       	push   $0xdf
  800bf0:	68 5c 43 80 00       	push   $0x80435c
  800bf5:	e8 c2 07 00 00       	call   8013bc <_panic>
		}

		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bfa:	e8 c2 1c 00 00       	call   8028c1 <sys_calculate_free_frames>
  800bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c02:	e8 05 1d 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800c07:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[1]);
  800c0a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	e8 e5 19 00 00       	call   8025fe <free>
  800c19:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800c1c:	e8 eb 1c 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800c21:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 6c 44 80 00       	push   $0x80446c
  800c2e:	68 e7 00 00 00       	push   $0xe7
  800c33:	68 5c 43 80 00       	push   $0x80435c
  800c38:	e8 7f 07 00 00       	call   8013bc <_panic>
			cprintf("sys_calculate_free_frames() - freeFrames = %d\n", sys_calculate_free_frames() - freeFrames);
  800c3d:	e8 7f 1c 00 00       	call   8028c1 <sys_calculate_free_frames>
  800c42:	89 c2                	mov    %eax,%edx
  800c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c47:	29 c2                	sub    %eax,%edx
  800c49:	89 d0                	mov    %edx,%eax
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	50                   	push   %eax
  800c4f:	68 18 45 80 00       	push   $0x804518
  800c54:	e8 20 0a 00 00       	call   801679 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800c5c:	e8 60 1c 00 00       	call   8028c1 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c66:	29 c2                	sub    %eax,%edx
  800c68:	89 d0                	mov    %edx,%eax
  800c6a:	83 f8 02             	cmp    $0x2,%eax
  800c6d:	74 17                	je     800c86 <_main+0xc4e>
  800c6f:	83 ec 04             	sub    $0x4,%esp
  800c72:	68 a8 44 80 00       	push   $0x8044a8
  800c77:	68 e9 00 00 00       	push   $0xe9
  800c7c:	68 5c 43 80 00       	push   $0x80435c
  800c81:	e8 36 07 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800c86:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c89:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c8f:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c9a:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
  800ca0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800ca3:	01 c0                	add    %eax,%eax
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800caa:	01 d0                	add    %edx,%eax
  800cac:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800cb2:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cbd:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800cc3:	6a 03                	push   $0x3
  800cc5:	6a 00                	push   $0x0
  800cc7:	6a 02                	push   $0x2
  800cc9:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800ccf:	50                   	push   %eax
  800cd0:	e8 09 21 00 00       	call   802dde <sys_check_WS_list>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800cdb:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800cdf:	74 17                	je     800cf8 <_main+0xcc0>
  800ce1:	83 ec 04             	sub    $0x4,%esp
  800ce4:	68 f4 44 80 00       	push   $0x8044f4
  800ce9:	68 ec 00 00 00       	push   $0xec
  800cee:	68 5c 43 80 00       	push   $0x80435c
  800cf3:	e8 c4 06 00 00       	call   8013bc <_panic>
		}

		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800cf8:	e8 c4 1b 00 00       	call   8028c1 <sys_calculate_free_frames>
  800cfd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d00:	e8 07 1c 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800d05:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[6]);
  800d08:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800d0e:	83 ec 0c             	sub    $0xc,%esp
  800d11:	50                   	push   %eax
  800d12:	e8 e7 18 00 00       	call   8025fe <free>
  800d17:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800d1a:	e8 ed 1b 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800d1f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800d22:	74 17                	je     800d3b <_main+0xd03>
  800d24:	83 ec 04             	sub    $0x4,%esp
  800d27:	68 6c 44 80 00       	push   $0x80446c
  800d2c:	68 f4 00 00 00       	push   $0xf4
  800d31:	68 5c 43 80 00       	push   $0x80435c
  800d36:	e8 81 06 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800d3b:	e8 81 1b 00 00       	call   8028c1 <sys_calculate_free_frames>
  800d40:	89 c2                	mov    %eax,%edx
  800d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
  800d49:	83 f8 03             	cmp    $0x3,%eax
  800d4c:	74 17                	je     800d65 <_main+0xd2d>
  800d4e:	83 ec 04             	sub    $0x4,%esp
  800d51:	68 a8 44 80 00       	push   $0x8044a8
  800d56:	68 f5 00 00 00       	push   $0xf5
  800d5b:	68 5c 43 80 00       	push   $0x80435c
  800d60:	e8 57 06 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800d65:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d6b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800d71:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7c:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	c1 ea 1f             	shr    $0x1f,%edx
  800d8a:	01 d0                	add    %edx,%eax
  800d8c:	d1 f8                	sar    %eax
  800d8e:	89 c2                	mov    %eax,%edx
  800d90:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d96:	01 d0                	add    %edx,%eax
  800d98:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800d9e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800da4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da9:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
  800daf:	8b 55 80             	mov    -0x80(%ebp),%edx
  800db2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800dc0:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  800dd1:	6a 03                	push   $0x3
  800dd3:	6a 00                	push   $0x0
  800dd5:	6a 03                	push   $0x3
  800dd7:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800ddd:	50                   	push   %eax
  800dde:	e8 fb 1f 00 00       	call   802dde <sys_check_WS_list>
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800de9:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ded:	74 17                	je     800e06 <_main+0xdce>
  800def:	83 ec 04             	sub    $0x4,%esp
  800df2:	68 f4 44 80 00       	push   $0x8044f4
  800df7:	68 f8 00 00 00       	push   $0xf8
  800dfc:	68 5c 43 80 00       	push   $0x80435c
  800e01:	e8 b6 05 00 00       	call   8013bc <_panic>
		}

		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e06:	e8 b6 1a 00 00       	call   8028c1 <sys_calculate_free_frames>
  800e0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e0e:	e8 f9 1a 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800e13:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[4]);
  800e16:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	e8 d9 17 00 00       	call   8025fe <free>
  800e25:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e28:	e8 df 1a 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800e2d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800e30:	74 17                	je     800e49 <_main+0xe11>
  800e32:	83 ec 04             	sub    $0x4,%esp
  800e35:	68 6c 44 80 00       	push   $0x80446c
  800e3a:	68 00 01 00 00       	push   $0x100
  800e3f:	68 5c 43 80 00       	push   $0x80435c
  800e44:	e8 73 05 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e49:	e8 73 1a 00 00       	call   8028c1 <sys_calculate_free_frames>
  800e4e:	89 c2                	mov    %eax,%edx
  800e50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e53:	29 c2                	sub    %eax,%edx
  800e55:	89 d0                	mov    %edx,%eax
  800e57:	83 f8 02             	cmp    $0x2,%eax
  800e5a:	74 17                	je     800e73 <_main+0xe3b>
  800e5c:	83 ec 04             	sub    $0x4,%esp
  800e5f:	68 a8 44 80 00       	push   $0x8044a8
  800e64:	68 01 01 00 00       	push   $0x101
  800e69:	68 5c 43 80 00       	push   $0x80435c
  800e6e:	e8 49 05 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800e73:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e76:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800e7c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800e82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e87:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  800e8d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800e90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e97:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e9a:	01 d0                	add    %edx,%eax
  800e9c:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800ea2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ead:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800eb3:	6a 03                	push   $0x3
  800eb5:	6a 00                	push   $0x0
  800eb7:	6a 02                	push   $0x2
  800eb9:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  800ebf:	50                   	push   %eax
  800ec0:	e8 19 1f 00 00       	call   802dde <sys_check_WS_list>
  800ec5:	83 c4 10             	add    $0x10,%esp
  800ec8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800ecb:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ecf:	74 17                	je     800ee8 <_main+0xeb0>
  800ed1:	83 ec 04             	sub    $0x4,%esp
  800ed4:	68 f4 44 80 00       	push   $0x8044f4
  800ed9:	68 04 01 00 00       	push   $0x104
  800ede:	68 5c 43 80 00       	push   $0x80435c
  800ee3:	e8 d4 04 00 00       	call   8013bc <_panic>
		}

		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800ee8:	e8 d4 19 00 00       	call   8028c1 <sys_calculate_free_frames>
  800eed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ef0:	e8 17 1a 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800ef5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[5]);
  800ef8:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	e8 f7 16 00 00       	call   8025fe <free>
  800f07:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f0a:	e8 fd 19 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800f0f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f12:	74 17                	je     800f2b <_main+0xef3>
  800f14:	83 ec 04             	sub    $0x4,%esp
  800f17:	68 6c 44 80 00       	push   $0x80446c
  800f1c:	68 0c 01 00 00       	push   $0x10c
  800f21:	68 5c 43 80 00       	push   $0x80435c
  800f26:	e8 91 04 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f2b:	e8 91 19 00 00       	call   8028c1 <sys_calculate_free_frames>
  800f30:	89 c2                	mov    %eax,%edx
  800f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 17                	je     800f50 <_main+0xf18>
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	68 a8 44 80 00       	push   $0x8044a8
  800f41:	68 0d 01 00 00       	push   $0x10d
  800f46:	68 5c 43 80 00       	push   $0x80435c
  800f4b:	e8 6c 04 00 00       	call   8013bc <_panic>
		}

		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f50:	e8 6c 19 00 00       	call   8028c1 <sys_calculate_free_frames>
  800f55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f58:	e8 af 19 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800f5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[2]);
  800f60:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	50                   	push   %eax
  800f6a:	e8 8f 16 00 00       	call   8025fe <free>
  800f6f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f72:	e8 95 19 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  800f77:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f7a:	74 17                	je     800f93 <_main+0xf5b>
  800f7c:	83 ec 04             	sub    $0x4,%esp
  800f7f:	68 6c 44 80 00       	push   $0x80446c
  800f84:	68 15 01 00 00       	push   $0x115
  800f89:	68 5c 43 80 00       	push   $0x80435c
  800f8e:	e8 29 04 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f93:	e8 29 19 00 00       	call   8028c1 <sys_calculate_free_frames>
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f9d:	29 c2                	sub    %eax,%edx
  800f9f:	89 d0                	mov    %edx,%eax
  800fa1:	83 f8 01             	cmp    $0x1,%eax
  800fa4:	74 17                	je     800fbd <_main+0xf85>
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	68 a8 44 80 00       	push   $0x8044a8
  800fae:	68 16 01 00 00       	push   $0x116
  800fb3:	68 5c 43 80 00       	push   $0x80435c
  800fb8:	e8 ff 03 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800fbd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fc0:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800fc6:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd1:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  800fd7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800fda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800fec:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800ffd:	6a 03                	push   $0x3
  800fff:	6a 00                	push   $0x0
  801001:	6a 02                	push   $0x2
  801003:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  801009:	50                   	push   %eax
  80100a:	e8 cf 1d 00 00       	call   802dde <sys_check_WS_list>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  801015:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  801019:	74 17                	je     801032 <_main+0xffa>
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 f4 44 80 00       	push   $0x8044f4
  801023:	68 19 01 00 00       	push   $0x119
  801028:	68 5c 43 80 00       	push   $0x80435c
  80102d:	e8 8a 03 00 00       	call   8013bc <_panic>
		}

		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801032:	e8 8a 18 00 00       	call   8028c1 <sys_calculate_free_frames>
  801037:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80103a:	e8 cd 18 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  80103f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[3]);
  801042:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	50                   	push   %eax
  80104c:	e8 ad 15 00 00       	call   8025fe <free>
  801051:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801054:	e8 b3 18 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  801059:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80105c:	74 17                	je     801075 <_main+0x103d>
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	68 6c 44 80 00       	push   $0x80446c
  801066:	68 21 01 00 00       	push   $0x121
  80106b:	68 5c 43 80 00       	push   $0x80435c
  801070:	e8 47 03 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801075:	e8 47 18 00 00       	call   8028c1 <sys_calculate_free_frames>
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	74 17                	je     80109a <_main+0x1062>
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	68 a8 44 80 00       	push   $0x8044a8
  80108b:	68 22 01 00 00       	push   $0x122
  801090:	68 5c 43 80 00       	push   $0x80435c
  801095:	e8 22 03 00 00       	call   8013bc <_panic>
		}

		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80109a:	e8 22 18 00 00       	call   8028c1 <sys_calculate_free_frames>
  80109f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010a2:	e8 65 18 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8010a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[7]);
  8010aa:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	e8 45 15 00 00       	call   8025fe <free>
  8010b9:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010bc:	e8 4b 18 00 00       	call   80290c <sys_pf_calculate_allocated_pages>
  8010c1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8010c4:	74 17                	je     8010dd <_main+0x10a5>
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	68 6c 44 80 00       	push   $0x80446c
  8010ce:	68 2a 01 00 00       	push   $0x12a
  8010d3:	68 5c 43 80 00       	push   $0x80435c
  8010d8:	e8 df 02 00 00       	call   8013bc <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8010dd:	e8 df 17 00 00       	call   8028c1 <sys_calculate_free_frames>
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010e7:	29 c2                	sub    %eax,%edx
  8010e9:	89 d0                	mov    %edx,%eax
  8010eb:	83 f8 03             	cmp    $0x3,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 a8 44 80 00       	push   $0x8044a8
  8010f8:	68 2b 01 00 00       	push   $0x12b
  8010fd:	68 5c 43 80 00       	push   $0x80435c
  801102:	e8 b5 02 00 00       	call   8013bc <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  801107:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80110d:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801113:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80111e:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801124:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	c1 ea 1f             	shr    $0x1f,%edx
  80112f:	01 d0                	add    %edx,%eax
  801131:	d1 f8                	sar    %eax
  801133:	01 c0                	add    %eax,%eax
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801145:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80114b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801150:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
  801156:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80115c:	01 c0                	add    %eax,%eax
  80115e:	89 c2                	mov    %eax,%edx
  801160:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116e:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801174:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801179:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  80117f:	6a 03                	push   $0x3
  801181:	6a 00                	push   $0x0
  801183:	6a 03                	push   $0x3
  801185:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	e8 4d 1c 00 00       	call   802dde <sys_check_WS_list>
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  801197:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  80119b:	74 17                	je     8011b4 <_main+0x117c>
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	68 f4 44 80 00       	push   $0x8044f4
  8011a5:	68 2e 01 00 00       	push   $0x12e
  8011aa:	68 5c 43 80 00       	push   $0x80435c
  8011af:	e8 08 02 00 00       	call   8013bc <_panic>
		}
	}

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		rsttst();
  8011b4:	e8 71 1a 00 00       	call   802c2a <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8011b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8011be:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8011c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011c9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8011cf:	89 c1                	mov    %eax,%ecx
  8011d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8011d6:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8011dc:	52                   	push   %edx
  8011dd:	51                   	push   %ecx
  8011de:	50                   	push   %eax
  8011df:	68 47 45 80 00       	push   $0x804547
  8011e4:	e8 f5 18 00 00       	call   802ade <sys_create_env>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		sys_run_env(ID1);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	ff b5 1c ff ff ff    	pushl  -0xe4(%ebp)
  8011fb:	e8 fc 18 00 00       	call   802afc <sys_run_env>
  801200:	83 c4 10             	add    $0x10,%esp

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801203:	a1 20 50 80 00       	mov    0x805020,%eax
  801208:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  80120e:	a1 20 50 80 00       	mov    0x805020,%eax
  801213:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801219:	89 c1                	mov    %eax,%ecx
  80121b:	a1 20 50 80 00       	mov    0x805020,%eax
  801220:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  801226:	52                   	push   %edx
  801227:	51                   	push   %ecx
  801228:	50                   	push   %eax
  801229:	68 52 45 80 00       	push   $0x804552
  80122e:	e8 ab 18 00 00       	call   802ade <sys_create_env>
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		sys_run_env(ID2);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	ff b5 18 ff ff ff    	pushl  -0xe8(%ebp)
  801245:	e8 b2 18 00 00       	call   802afc <sys_run_env>
  80124a:	83 c4 10             	add    $0x10,%esp

		env_sleep(10000);
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	68 10 27 00 00       	push   $0x2710
  801255:	e8 cb 2d 00 00       	call   804025 <env_sleep>
  80125a:	83 c4 10             	add    $0x10,%esp

		if (gettst() != 0)
  80125d:	e8 42 1a 00 00       	call   802ca4 <gettst>
  801262:	85 c0                	test   %eax,%eax
  801264:	74 10                	je     801276 <_main+0x123e>
			cprintf("\nFree: successful access to freed space!! (processes should be killed by the validation of the fault handler)\n");
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	68 60 45 80 00       	push   $0x804560
  80126e:	e8 06 04 00 00       	call   801679 <cprintf>
  801273:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Congratulations!! test free [1] [PAGE ALLOCATOR] completed successfully.\n");
  801276:	83 ec 0c             	sub    $0xc,%esp
  801279:	68 d0 45 80 00       	push   $0x8045d0
  80127e:	e8 f6 03 00 00       	call   801679 <cprintf>
  801283:	83 c4 10             	add    $0x10,%esp

	return;
  801286:	90                   	nop
}
  801287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128a:	5b                   	pop    %ebx
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801294:	e8 b3 18 00 00       	call   802b4c <sys_getenvindex>
  801299:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80129c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129f:	89 d0                	mov    %edx,%eax
  8012a1:	01 c0                	add    %eax,%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	c1 e0 06             	shl    $0x6,%eax
  8012a8:	29 d0                	sub    %edx,%eax
  8012aa:	c1 e0 03             	shl    $0x3,%eax
  8012ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012b2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8012b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8012bc:	8a 40 68             	mov    0x68(%eax),%al
  8012bf:	84 c0                	test   %al,%al
  8012c1:	74 0d                	je     8012d0 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8012c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c8:	83 c0 68             	add    $0x68,%eax
  8012cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d4:	7e 0a                	jle    8012e0 <libmain+0x52>
		binaryname = argv[0];
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	ff 75 08             	pushl  0x8(%ebp)
  8012e9:	e8 4a ed ff ff       	call   800038 <_main>
  8012ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8012f1:	e8 63 16 00 00       	call   802959 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	68 34 46 80 00       	push   $0x804634
  8012fe:	e8 76 03 00 00       	call   801679 <cprintf>
  801303:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801306:	a1 20 50 80 00       	mov    0x805020,%eax
  80130b:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  801311:	a1 20 50 80 00       	mov    0x805020,%eax
  801316:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	52                   	push   %edx
  801320:	50                   	push   %eax
  801321:	68 5c 46 80 00       	push   $0x80465c
  801326:	e8 4e 03 00 00       	call   801679 <cprintf>
  80132b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80132e:	a1 20 50 80 00       	mov    0x805020,%eax
  801333:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  801339:	a1 20 50 80 00       	mov    0x805020,%eax
  80133e:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  801344:	a1 20 50 80 00       	mov    0x805020,%eax
  801349:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80134f:	51                   	push   %ecx
  801350:	52                   	push   %edx
  801351:	50                   	push   %eax
  801352:	68 84 46 80 00       	push   $0x804684
  801357:	e8 1d 03 00 00       	call   801679 <cprintf>
  80135c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80135f:	a1 20 50 80 00       	mov    0x805020,%eax
  801364:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	50                   	push   %eax
  80136e:	68 dc 46 80 00       	push   $0x8046dc
  801373:	e8 01 03 00 00       	call   801679 <cprintf>
  801378:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80137b:	83 ec 0c             	sub    $0xc,%esp
  80137e:	68 34 46 80 00       	push   $0x804634
  801383:	e8 f1 02 00 00       	call   801679 <cprintf>
  801388:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80138b:	e8 e3 15 00 00       	call   802973 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801390:	e8 19 00 00 00       	call   8013ae <exit>
}
  801395:	90                   	nop
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	6a 00                	push   $0x0
  8013a3:	e8 70 17 00 00       	call   802b18 <sys_destroy_env>
  8013a8:	83 c4 10             	add    $0x10,%esp
}
  8013ab:	90                   	nop
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <exit>:

void
exit(void)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8013b4:	e8 c5 17 00 00       	call   802b7e <sys_exit_env>
}
  8013b9:	90                   	nop
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8013c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c5:	83 c0 04             	add    $0x4,%eax
  8013c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8013cb:	a1 18 51 80 00       	mov    0x805118,%eax
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	74 16                	je     8013ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8013d4:	a1 18 51 80 00       	mov    0x805118,%eax
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	50                   	push   %eax
  8013dd:	68 f0 46 80 00       	push   $0x8046f0
  8013e2:	e8 92 02 00 00       	call   801679 <cprintf>
  8013e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8013ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	68 f5 46 80 00       	push   $0x8046f5
  8013fb:	e8 79 02 00 00       	call   801679 <cprintf>
  801400:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801403:	8b 45 10             	mov    0x10(%ebp),%eax
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	ff 75 f4             	pushl  -0xc(%ebp)
  80140c:	50                   	push   %eax
  80140d:	e8 fc 01 00 00       	call   80160e <vcprintf>
  801412:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	6a 00                	push   $0x0
  80141a:	68 11 47 80 00       	push   $0x804711
  80141f:	e8 ea 01 00 00       	call   80160e <vcprintf>
  801424:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801427:	e8 82 ff ff ff       	call   8013ae <exit>

	// should not return here
	while (1) ;
  80142c:	eb fe                	jmp    80142c <_panic+0x70>

0080142e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801434:	a1 20 50 80 00       	mov    0x805020,%eax
  801439:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	39 c2                	cmp    %eax,%edx
  801444:	74 14                	je     80145a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	68 14 47 80 00       	push   $0x804714
  80144e:	6a 26                	push   $0x26
  801450:	68 60 47 80 00       	push   $0x804760
  801455:	e8 62 ff ff ff       	call   8013bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80145a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801468:	e9 c5 00 00 00       	jmp    801532 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
  80147c:	8b 00                	mov    (%eax),%eax
  80147e:	85 c0                	test   %eax,%eax
  801480:	75 08                	jne    80148a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801482:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801485:	e9 a5 00 00 00       	jmp    80152f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80148a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801491:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801498:	eb 69                	jmp    801503 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80149a:	a1 20 50 80 00       	mov    0x805020,%eax
  80149f:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8014a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014a8:	89 d0                	mov    %edx,%eax
  8014aa:	01 c0                	add    %eax,%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c1 e0 03             	shl    $0x3,%eax
  8014b1:	01 c8                	add    %ecx,%eax
  8014b3:	8a 40 04             	mov    0x4(%eax),%al
  8014b6:	84 c0                	test   %al,%al
  8014b8:	75 46                	jne    801500 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8014ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8014bf:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8014c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014c8:	89 d0                	mov    %edx,%eax
  8014ca:	01 c0                	add    %eax,%eax
  8014cc:	01 d0                	add    %edx,%eax
  8014ce:	c1 e0 03             	shl    $0x3,%eax
  8014d1:	01 c8                	add    %ecx,%eax
  8014d3:	8b 00                	mov    (%eax),%eax
  8014d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	01 c8                	add    %ecx,%eax
  8014f1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8014f3:	39 c2                	cmp    %eax,%edx
  8014f5:	75 09                	jne    801500 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8014f7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8014fe:	eb 15                	jmp    801515 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801500:	ff 45 e8             	incl   -0x18(%ebp)
  801503:	a1 20 50 80 00       	mov    0x805020,%eax
  801508:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80150e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801511:	39 c2                	cmp    %eax,%edx
  801513:	77 85                	ja     80149a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801519:	75 14                	jne    80152f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	68 6c 47 80 00       	push   $0x80476c
  801523:	6a 3a                	push   $0x3a
  801525:	68 60 47 80 00       	push   $0x804760
  80152a:	e8 8d fe ff ff       	call   8013bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80152f:	ff 45 f0             	incl   -0x10(%ebp)
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801538:	0f 8c 2f ff ff ff    	jl     80146d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80153e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801545:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80154c:	eb 26                	jmp    801574 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80154e:	a1 20 50 80 00       	mov    0x805020,%eax
  801553:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801559:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80155c:	89 d0                	mov    %edx,%eax
  80155e:	01 c0                	add    %eax,%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	c1 e0 03             	shl    $0x3,%eax
  801565:	01 c8                	add    %ecx,%eax
  801567:	8a 40 04             	mov    0x4(%eax),%al
  80156a:	3c 01                	cmp    $0x1,%al
  80156c:	75 03                	jne    801571 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80156e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801571:	ff 45 e0             	incl   -0x20(%ebp)
  801574:	a1 20 50 80 00       	mov    0x805020,%eax
  801579:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80157f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801582:	39 c2                	cmp    %eax,%edx
  801584:	77 c8                	ja     80154e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80158c:	74 14                	je     8015a2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	68 c0 47 80 00       	push   $0x8047c0
  801596:	6a 44                	push   $0x44
  801598:	68 60 47 80 00       	push   $0x804760
  80159d:	e8 1a fe ff ff       	call   8013bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8015a2:	90                   	nop
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	89 0a                	mov    %ecx,(%edx)
  8015b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bb:	88 d1                	mov    %dl,%cl
  8015bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	8b 00                	mov    (%eax),%eax
  8015c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8015ce:	75 2c                	jne    8015fc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8015d0:	a0 24 50 80 00       	mov    0x805024,%al
  8015d5:	0f b6 c0             	movzbl %al,%eax
  8015d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015db:	8b 12                	mov    (%edx),%edx
  8015dd:	89 d1                	mov    %edx,%ecx
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	83 c2 08             	add    $0x8,%edx
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	50                   	push   %eax
  8015e9:	51                   	push   %ecx
  8015ea:	52                   	push   %edx
  8015eb:	e8 10 12 00 00       	call   802800 <sys_cputs>
  8015f0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	8d 50 01             	lea    0x1(%eax),%edx
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	89 50 04             	mov    %edx,0x4(%eax)
}
  80160b:	90                   	nop
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801617:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80161e:	00 00 00 
	b.cnt = 0;
  801621:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801628:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80162b:	ff 75 0c             	pushl  0xc(%ebp)
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	68 a5 15 80 00       	push   $0x8015a5
  80163d:	e8 11 02 00 00       	call   801853 <vprintfmt>
  801642:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801645:	a0 24 50 80 00       	mov    0x805024,%al
  80164a:	0f b6 c0             	movzbl %al,%eax
  80164d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	50                   	push   %eax
  801657:	52                   	push   %edx
  801658:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80165e:	83 c0 08             	add    $0x8,%eax
  801661:	50                   	push   %eax
  801662:	e8 99 11 00 00       	call   802800 <sys_cputs>
  801667:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80166a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801671:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <cprintf>:

int cprintf(const char *fmt, ...) {
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80167f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801686:	8d 45 0c             	lea    0xc(%ebp),%eax
  801689:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 f4             	pushl  -0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	e8 73 ff ff ff       	call   80160e <vcprintf>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8016ac:	e8 a8 12 00 00       	call   802959 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c0:	50                   	push   %eax
  8016c1:	e8 48 ff ff ff       	call   80160e <vcprintf>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8016cc:	e8 a2 12 00 00       	call   802973 <sys_enable_interrupt>
	return cnt;
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 14             	sub    $0x14,%esp
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016f4:	77 55                	ja     80174b <printnum+0x75>
  8016f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016f9:	72 05                	jb     801700 <printnum+0x2a>
  8016fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016fe:	77 4b                	ja     80174b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801700:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801703:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801706:	8b 45 18             	mov    0x18(%ebp),%eax
  801709:	ba 00 00 00 00       	mov    $0x0,%edx
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	ff 75 f4             	pushl  -0xc(%ebp)
  801713:	ff 75 f0             	pushl  -0x10(%ebp)
  801716:	e8 c1 29 00 00       	call   8040dc <__udivdi3>
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	ff 75 20             	pushl  0x20(%ebp)
  801724:	53                   	push   %ebx
  801725:	ff 75 18             	pushl  0x18(%ebp)
  801728:	52                   	push   %edx
  801729:	50                   	push   %eax
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 a1 ff ff ff       	call   8016d6 <printnum>
  801735:	83 c4 20             	add    $0x20,%esp
  801738:	eb 1a                	jmp    801754 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	ff 75 20             	pushl  0x20(%ebp)
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	ff d0                	call   *%eax
  801748:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80174b:	ff 4d 1c             	decl   0x1c(%ebp)
  80174e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801752:	7f e6                	jg     80173a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801754:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801762:	53                   	push   %ebx
  801763:	51                   	push   %ecx
  801764:	52                   	push   %edx
  801765:	50                   	push   %eax
  801766:	e8 81 2a 00 00       	call   8041ec <__umoddi3>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	05 34 4a 80 00       	add    $0x804a34,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	0f be c0             	movsbl %al,%eax
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	50                   	push   %eax
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	ff d0                	call   *%eax
  801784:	83 c4 10             	add    $0x10,%esp
}
  801787:	90                   	nop
  801788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801790:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801794:	7e 1c                	jle    8017b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	8d 50 08             	lea    0x8(%eax),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	89 10                	mov    %edx,(%eax)
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8b 00                	mov    (%eax),%eax
  8017a8:	83 e8 08             	sub    $0x8,%eax
  8017ab:	8b 50 04             	mov    0x4(%eax),%edx
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	eb 40                	jmp    8017f2 <getuint+0x65>
	else if (lflag)
  8017b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017b6:	74 1e                	je     8017d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	8d 50 04             	lea    0x4(%eax),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	89 10                	mov    %edx,(%eax)
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 00                	mov    (%eax),%eax
  8017ca:	83 e8 04             	sub    $0x4,%eax
  8017cd:	8b 00                	mov    (%eax),%eax
  8017cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d4:	eb 1c                	jmp    8017f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8b 00                	mov    (%eax),%eax
  8017db:	8d 50 04             	lea    0x4(%eax),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	89 10                	mov    %edx,(%eax)
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8b 00                	mov    (%eax),%eax
  8017e8:	83 e8 04             	sub    $0x4,%eax
  8017eb:	8b 00                	mov    (%eax),%eax
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    

008017f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017fb:	7e 1c                	jle    801819 <getint+0x25>
		return va_arg(*ap, long long);
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 00                	mov    (%eax),%eax
  801802:	8d 50 08             	lea    0x8(%eax),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	89 10                	mov    %edx,(%eax)
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 00                	mov    (%eax),%eax
  80180f:	83 e8 08             	sub    $0x8,%eax
  801812:	8b 50 04             	mov    0x4(%eax),%edx
  801815:	8b 00                	mov    (%eax),%eax
  801817:	eb 38                	jmp    801851 <getint+0x5d>
	else if (lflag)
  801819:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181d:	74 1a                	je     801839 <getint+0x45>
		return va_arg(*ap, long);
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 00                	mov    (%eax),%eax
  801824:	8d 50 04             	lea    0x4(%eax),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	89 10                	mov    %edx,(%eax)
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 00                	mov    (%eax),%eax
  801831:	83 e8 04             	sub    $0x4,%eax
  801834:	8b 00                	mov    (%eax),%eax
  801836:	99                   	cltd   
  801837:	eb 18                	jmp    801851 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	8d 50 04             	lea    0x4(%eax),%edx
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 10                	mov    %edx,(%eax)
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	83 e8 04             	sub    $0x4,%eax
  80184e:	8b 00                	mov    (%eax),%eax
  801850:	99                   	cltd   
}
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80185b:	eb 17                	jmp    801874 <vprintfmt+0x21>
			if (ch == '\0')
  80185d:	85 db                	test   %ebx,%ebx
  80185f:	0f 84 af 03 00 00    	je     801c14 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	53                   	push   %ebx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	ff d0                	call   *%eax
  801871:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801874:	8b 45 10             	mov    0x10(%ebp),%eax
  801877:	8d 50 01             	lea    0x1(%eax),%edx
  80187a:	89 55 10             	mov    %edx,0x10(%ebp)
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 d8             	movzbl %al,%ebx
  801882:	83 fb 25             	cmp    $0x25,%ebx
  801885:	75 d6                	jne    80185d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801887:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80188b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801892:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801899:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8018a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	8d 50 01             	lea    0x1(%eax),%edx
  8018ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 d8             	movzbl %al,%ebx
  8018b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8018b8:	83 f8 55             	cmp    $0x55,%eax
  8018bb:	0f 87 2b 03 00 00    	ja     801bec <vprintfmt+0x399>
  8018c1:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
  8018c8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8018ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8018ce:	eb d7                	jmp    8018a7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8018d4:	eb d1                	jmp    8018a7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8018dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	c1 e0 02             	shl    $0x2,%eax
  8018e5:	01 d0                	add    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d8                	add    %ebx,%eax
  8018eb:	83 e8 30             	sub    $0x30,%eax
  8018ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8018f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8018fc:	7e 3e                	jle    80193c <vprintfmt+0xe9>
  8018fe:	83 fb 39             	cmp    $0x39,%ebx
  801901:	7f 39                	jg     80193c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801903:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801906:	eb d5                	jmp    8018dd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801908:	8b 45 14             	mov    0x14(%ebp),%eax
  80190b:	83 c0 04             	add    $0x4,%eax
  80190e:	89 45 14             	mov    %eax,0x14(%ebp)
  801911:	8b 45 14             	mov    0x14(%ebp),%eax
  801914:	83 e8 04             	sub    $0x4,%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80191c:	eb 1f                	jmp    80193d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80191e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801922:	79 83                	jns    8018a7 <vprintfmt+0x54>
				width = 0;
  801924:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80192b:	e9 77 ff ff ff       	jmp    8018a7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801930:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801937:	e9 6b ff ff ff       	jmp    8018a7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80193c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80193d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801941:	0f 89 60 ff ff ff    	jns    8018a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  801947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80194d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801954:	e9 4e ff ff ff       	jmp    8018a7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801959:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80195c:	e9 46 ff ff ff       	jmp    8018a7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801961:	8b 45 14             	mov    0x14(%ebp),%eax
  801964:	83 c0 04             	add    $0x4,%eax
  801967:	89 45 14             	mov    %eax,0x14(%ebp)
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	83 e8 04             	sub    $0x4,%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	50                   	push   %eax
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	ff d0                	call   *%eax
  80197e:	83 c4 10             	add    $0x10,%esp
			break;
  801981:	e9 89 02 00 00       	jmp    801c0f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801986:	8b 45 14             	mov    0x14(%ebp),%eax
  801989:	83 c0 04             	add    $0x4,%eax
  80198c:	89 45 14             	mov    %eax,0x14(%ebp)
  80198f:	8b 45 14             	mov    0x14(%ebp),%eax
  801992:	83 e8 04             	sub    $0x4,%eax
  801995:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801997:	85 db                	test   %ebx,%ebx
  801999:	79 02                	jns    80199d <vprintfmt+0x14a>
				err = -err;
  80199b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80199d:	83 fb 64             	cmp    $0x64,%ebx
  8019a0:	7f 0b                	jg     8019ad <vprintfmt+0x15a>
  8019a2:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  8019a9:	85 f6                	test   %esi,%esi
  8019ab:	75 19                	jne    8019c6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8019ad:	53                   	push   %ebx
  8019ae:	68 45 4a 80 00       	push   $0x804a45
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	e8 5e 02 00 00       	call   801c1c <printfmt>
  8019be:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8019c1:	e9 49 02 00 00       	jmp    801c0f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8019c6:	56                   	push   %esi
  8019c7:	68 4e 4a 80 00       	push   $0x804a4e
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	e8 45 02 00 00       	call   801c1c <printfmt>
  8019d7:	83 c4 10             	add    $0x10,%esp
			break;
  8019da:	e9 30 02 00 00       	jmp    801c0f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8019df:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e2:	83 c0 04             	add    $0x4,%eax
  8019e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8019e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019eb:	83 e8 04             	sub    $0x4,%eax
  8019ee:	8b 30                	mov    (%eax),%esi
  8019f0:	85 f6                	test   %esi,%esi
  8019f2:	75 05                	jne    8019f9 <vprintfmt+0x1a6>
				p = "(null)";
  8019f4:	be 51 4a 80 00       	mov    $0x804a51,%esi
			if (width > 0 && padc != '-')
  8019f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019fd:	7e 6d                	jle    801a6c <vprintfmt+0x219>
  8019ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a03:	74 67                	je     801a6c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	50                   	push   %eax
  801a0c:	56                   	push   %esi
  801a0d:	e8 0c 03 00 00       	call   801d1e <strnlen>
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a18:	eb 16                	jmp    801a30 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a1a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	50                   	push   %eax
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	ff d0                	call   *%eax
  801a2a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a2d:	ff 4d e4             	decl   -0x1c(%ebp)
  801a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a34:	7f e4                	jg     801a1a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a36:	eb 34                	jmp    801a6c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a3c:	74 1c                	je     801a5a <vprintfmt+0x207>
  801a3e:	83 fb 1f             	cmp    $0x1f,%ebx
  801a41:	7e 05                	jle    801a48 <vprintfmt+0x1f5>
  801a43:	83 fb 7e             	cmp    $0x7e,%ebx
  801a46:	7e 12                	jle    801a5a <vprintfmt+0x207>
					putch('?', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 3f                	push   $0x3f
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	eb 0f                	jmp    801a69 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801a5a:	83 ec 08             	sub    $0x8,%esp
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	53                   	push   %ebx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	ff d0                	call   *%eax
  801a66:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a69:	ff 4d e4             	decl   -0x1c(%ebp)
  801a6c:	89 f0                	mov    %esi,%eax
  801a6e:	8d 70 01             	lea    0x1(%eax),%esi
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	0f be d8             	movsbl %al,%ebx
  801a76:	85 db                	test   %ebx,%ebx
  801a78:	74 24                	je     801a9e <vprintfmt+0x24b>
  801a7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a7e:	78 b8                	js     801a38 <vprintfmt+0x1e5>
  801a80:	ff 4d e0             	decl   -0x20(%ebp)
  801a83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a87:	79 af                	jns    801a38 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a89:	eb 13                	jmp    801a9e <vprintfmt+0x24b>
				putch(' ', putdat);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	6a 20                	push   $0x20
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	ff d0                	call   *%eax
  801a98:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a9b:	ff 4d e4             	decl   -0x1c(%ebp)
  801a9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aa2:	7f e7                	jg     801a8b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801aa4:	e9 66 01 00 00       	jmp    801c0f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	ff 75 e8             	pushl  -0x18(%ebp)
  801aaf:	8d 45 14             	lea    0x14(%ebp),%eax
  801ab2:	50                   	push   %eax
  801ab3:	e8 3c fd ff ff       	call   8017f4 <getint>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac7:	85 d2                	test   %edx,%edx
  801ac9:	79 23                	jns    801aee <vprintfmt+0x29b>
				putch('-', putdat);
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	6a 2d                	push   $0x2d
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	ff d0                	call   *%eax
  801ad8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae1:	f7 d8                	neg    %eax
  801ae3:	83 d2 00             	adc    $0x0,%edx
  801ae6:	f7 da                	neg    %edx
  801ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801aee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801af5:	e9 bc 00 00 00       	jmp    801bb6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	ff 75 e8             	pushl  -0x18(%ebp)
  801b00:	8d 45 14             	lea    0x14(%ebp),%eax
  801b03:	50                   	push   %eax
  801b04:	e8 84 fc ff ff       	call   80178d <getuint>
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b19:	e9 98 00 00 00       	jmp    801bb6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	6a 58                	push   $0x58
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	ff d0                	call   *%eax
  801b2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b2e:	83 ec 08             	sub    $0x8,%esp
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	6a 58                	push   $0x58
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	ff d0                	call   *%eax
  801b3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	6a 58                	push   $0x58
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	ff d0                	call   *%eax
  801b4b:	83 c4 10             	add    $0x10,%esp
			break;
  801b4e:	e9 bc 00 00 00       	jmp    801c0f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	6a 30                	push   $0x30
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	ff d0                	call   *%eax
  801b60:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	6a 78                	push   $0x78
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	ff d0                	call   *%eax
  801b70:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	83 c0 04             	add    $0x4,%eax
  801b79:	89 45 14             	mov    %eax,0x14(%ebp)
  801b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7f:	83 e8 04             	sub    $0x4,%eax
  801b82:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b8e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b95:	eb 1f                	jmp    801bb6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b97:	83 ec 08             	sub    $0x8,%esp
  801b9a:	ff 75 e8             	pushl  -0x18(%ebp)
  801b9d:	8d 45 14             	lea    0x14(%ebp),%eax
  801ba0:	50                   	push   %eax
  801ba1:	e8 e7 fb ff ff       	call   80178d <getuint>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801baf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801bb6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	52                   	push   %edx
  801bc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bc4:	50                   	push   %eax
  801bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	e8 00 fb ff ff       	call   8016d6 <printnum>
  801bd6:	83 c4 20             	add    $0x20,%esp
			break;
  801bd9:	eb 34                	jmp    801c0f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801bdb:	83 ec 08             	sub    $0x8,%esp
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	53                   	push   %ebx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	ff d0                	call   *%eax
  801be7:	83 c4 10             	add    $0x10,%esp
			break;
  801bea:	eb 23                	jmp    801c0f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	6a 25                	push   $0x25
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	ff d0                	call   *%eax
  801bf9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bfc:	ff 4d 10             	decl   0x10(%ebp)
  801bff:	eb 03                	jmp    801c04 <vprintfmt+0x3b1>
  801c01:	ff 4d 10             	decl   0x10(%ebp)
  801c04:	8b 45 10             	mov    0x10(%ebp),%eax
  801c07:	48                   	dec    %eax
  801c08:	8a 00                	mov    (%eax),%al
  801c0a:	3c 25                	cmp    $0x25,%al
  801c0c:	75 f3                	jne    801c01 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c0e:	90                   	nop
		}
	}
  801c0f:	e9 47 fc ff ff       	jmp    80185b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c14:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    

00801c1c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c22:	8d 45 10             	lea    0x10(%ebp),%eax
  801c25:	83 c0 04             	add    $0x4,%eax
  801c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c31:	50                   	push   %eax
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	e8 16 fc ff ff       	call   801853 <vprintfmt>
  801c3d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c49:	8b 40 08             	mov    0x8(%eax),%eax
  801c4c:	8d 50 01             	lea    0x1(%eax),%edx
  801c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c52:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c58:	8b 10                	mov    (%eax),%edx
  801c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5d:	8b 40 04             	mov    0x4(%eax),%eax
  801c60:	39 c2                	cmp    %eax,%edx
  801c62:	73 12                	jae    801c76 <sprintputch+0x33>
		*b->buf++ = ch;
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 48 01             	lea    0x1(%eax),%ecx
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6f:	89 0a                	mov    %ecx,(%edx)
  801c71:	8b 55 08             	mov    0x8(%ebp),%edx
  801c74:	88 10                	mov    %dl,(%eax)
}
  801c76:	90                   	nop
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	01 d0                	add    %edx,%eax
  801c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c9e:	74 06                	je     801ca6 <vsnprintf+0x2d>
  801ca0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ca4:	7f 07                	jg     801cad <vsnprintf+0x34>
		return -E_INVAL;
  801ca6:	b8 03 00 00 00       	mov    $0x3,%eax
  801cab:	eb 20                	jmp    801ccd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cad:	ff 75 14             	pushl  0x14(%ebp)
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cb6:	50                   	push   %eax
  801cb7:	68 43 1c 80 00       	push   $0x801c43
  801cbc:	e8 92 fb ff ff       	call   801853 <vprintfmt>
  801cc1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cd5:	8d 45 10             	lea    0x10(%ebp),%eax
  801cd8:	83 c0 04             	add    $0x4,%eax
  801cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce4:	50                   	push   %eax
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	ff 75 08             	pushl  0x8(%ebp)
  801ceb:	e8 89 ff ff ff       	call   801c79 <vsnprintf>
  801cf0:	83 c4 10             	add    $0x10,%esp
  801cf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d08:	eb 06                	jmp    801d10 <strlen+0x15>
		n++;
  801d0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d0d:	ff 45 08             	incl   0x8(%ebp)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	8a 00                	mov    (%eax),%al
  801d15:	84 c0                	test   %al,%al
  801d17:	75 f1                	jne    801d0a <strlen+0xf>
		n++;
	return n;
  801d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d2b:	eb 09                	jmp    801d36 <strnlen+0x18>
		n++;
  801d2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d30:	ff 45 08             	incl   0x8(%ebp)
  801d33:	ff 4d 0c             	decl   0xc(%ebp)
  801d36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3a:	74 09                	je     801d45 <strnlen+0x27>
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	8a 00                	mov    (%eax),%al
  801d41:	84 c0                	test   %al,%al
  801d43:	75 e8                	jne    801d2d <strnlen+0xf>
		n++;
	return n;
  801d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d56:	90                   	nop
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	8d 50 01             	lea    0x1(%eax),%edx
  801d5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d69:	8a 12                	mov    (%edx),%dl
  801d6b:	88 10                	mov    %dl,(%eax)
  801d6d:	8a 00                	mov    (%eax),%al
  801d6f:	84 c0                	test   %al,%al
  801d71:	75 e4                	jne    801d57 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8b:	eb 1f                	jmp    801dac <strncpy+0x34>
		*dst++ = *src;
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8d 50 01             	lea    0x1(%eax),%edx
  801d93:	89 55 08             	mov    %edx,0x8(%ebp)
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8a 12                	mov    (%edx),%dl
  801d9b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da0:	8a 00                	mov    (%eax),%al
  801da2:	84 c0                	test   %al,%al
  801da4:	74 03                	je     801da9 <strncpy+0x31>
			src++;
  801da6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801da9:	ff 45 fc             	incl   -0x4(%ebp)
  801dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801daf:	3b 45 10             	cmp    0x10(%ebp),%eax
  801db2:	72 d9                	jb     801d8d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801dc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dc9:	74 30                	je     801dfb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801dcb:	eb 16                	jmp    801de3 <strlcpy+0x2a>
			*dst++ = *src++;
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8d 50 01             	lea    0x1(%eax),%edx
  801dd3:	89 55 08             	mov    %edx,0x8(%ebp)
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ddc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ddf:	8a 12                	mov    (%edx),%dl
  801de1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801de3:	ff 4d 10             	decl   0x10(%ebp)
  801de6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dea:	74 09                	je     801df5 <strlcpy+0x3c>
  801dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	75 d8                	jne    801dcd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e01:	29 c2                	sub    %eax,%edx
  801e03:	89 d0                	mov    %edx,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e0a:	eb 06                	jmp    801e12 <strcmp+0xb>
		p++, q++;
  801e0c:	ff 45 08             	incl   0x8(%ebp)
  801e0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	84 c0                	test   %al,%al
  801e19:	74 0e                	je     801e29 <strcmp+0x22>
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	8a 10                	mov    (%eax),%dl
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	38 c2                	cmp    %al,%dl
  801e27:	74 e3                	je     801e0c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	8a 00                	mov    (%eax),%al
  801e2e:	0f b6 d0             	movzbl %al,%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	8a 00                	mov    (%eax),%al
  801e36:	0f b6 c0             	movzbl %al,%eax
  801e39:	29 c2                	sub    %eax,%edx
  801e3b:	89 d0                	mov    %edx,%eax
}
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e42:	eb 09                	jmp    801e4d <strncmp+0xe>
		n--, p++, q++;
  801e44:	ff 4d 10             	decl   0x10(%ebp)
  801e47:	ff 45 08             	incl   0x8(%ebp)
  801e4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e51:	74 17                	je     801e6a <strncmp+0x2b>
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	8a 00                	mov    (%eax),%al
  801e58:	84 c0                	test   %al,%al
  801e5a:	74 0e                	je     801e6a <strncmp+0x2b>
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8a 10                	mov    (%eax),%dl
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	8a 00                	mov    (%eax),%al
  801e66:	38 c2                	cmp    %al,%dl
  801e68:	74 da                	je     801e44 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e6e:	75 07                	jne    801e77 <strncmp+0x38>
		return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	eb 14                	jmp    801e8b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	8a 00                	mov    (%eax),%al
  801e7c:	0f b6 d0             	movzbl %al,%edx
  801e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e82:	8a 00                	mov    (%eax),%al
  801e84:	0f b6 c0             	movzbl %al,%eax
  801e87:	29 c2                	sub    %eax,%edx
  801e89:	89 d0                	mov    %edx,%eax
}
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    

00801e8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e99:	eb 12                	jmp    801ead <strchr+0x20>
		if (*s == c)
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	8a 00                	mov    (%eax),%al
  801ea0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ea3:	75 05                	jne    801eaa <strchr+0x1d>
			return (char *) s;
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	eb 11                	jmp    801ebb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801eaa:	ff 45 08             	incl   0x8(%ebp)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8a 00                	mov    (%eax),%al
  801eb2:	84 c0                	test   %al,%al
  801eb4:	75 e5                	jne    801e9b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ec9:	eb 0d                	jmp    801ed8 <strfind+0x1b>
		if (*s == c)
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8a 00                	mov    (%eax),%al
  801ed0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ed3:	74 0e                	je     801ee3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ed5:	ff 45 08             	incl   0x8(%ebp)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	84 c0                	test   %al,%al
  801edf:	75 ea                	jne    801ecb <strfind+0xe>
  801ee1:	eb 01                	jmp    801ee4 <strfind+0x27>
		if (*s == c)
			break;
  801ee3:	90                   	nop
	return (char *) s;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801efb:	eb 0e                	jmp    801f0b <memset+0x22>
		*p++ = c;
  801efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f00:	8d 50 01             	lea    0x1(%eax),%edx
  801f03:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f0b:	ff 4d f8             	decl   -0x8(%ebp)
  801f0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f12:	79 e9                	jns    801efd <memset+0x14>
		*p++ = c;

	return v;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f2b:	eb 16                	jmp    801f43 <memcpy+0x2a>
		*d++ = *s++;
  801f2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f30:	8d 50 01             	lea    0x1(%eax),%edx
  801f33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f39:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f3f:	8a 12                	mov    (%edx),%dl
  801f41:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f49:	89 55 10             	mov    %edx,0x10(%ebp)
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	75 dd                	jne    801f2d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f6d:	73 50                	jae    801fbf <memmove+0x6a>
  801f6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f72:	8b 45 10             	mov    0x10(%ebp),%eax
  801f75:	01 d0                	add    %edx,%eax
  801f77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f7a:	76 43                	jbe    801fbf <memmove+0x6a>
		s += n;
  801f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f82:	8b 45 10             	mov    0x10(%ebp),%eax
  801f85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f88:	eb 10                	jmp    801f9a <memmove+0x45>
			*--d = *--s;
  801f8a:	ff 4d f8             	decl   -0x8(%ebp)
  801f8d:	ff 4d fc             	decl   -0x4(%ebp)
  801f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f93:	8a 10                	mov    (%eax),%dl
  801f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fa0:	89 55 10             	mov    %edx,0x10(%ebp)
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	75 e3                	jne    801f8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fa7:	eb 23                	jmp    801fcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fac:	8d 50 01             	lea    0x1(%eax),%edx
  801faf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fbb:	8a 12                	mov    (%edx),%dl
  801fbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	75 dd                	jne    801fa9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801fe3:	eb 2a                	jmp    80200f <memcmp+0x3e>
		if (*s1 != *s2)
  801fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe8:	8a 10                	mov    (%eax),%dl
  801fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	38 c2                	cmp    %al,%dl
  801ff1:	74 16                	je     802009 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f b6 d0             	movzbl %al,%edx
  801ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	0f b6 c0             	movzbl %al,%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
  802007:	eb 18                	jmp    802021 <memcmp+0x50>
		s1++, s2++;
  802009:	ff 45 fc             	incl   -0x4(%ebp)
  80200c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80200f:	8b 45 10             	mov    0x10(%ebp),%eax
  802012:	8d 50 ff             	lea    -0x1(%eax),%edx
  802015:	89 55 10             	mov    %edx,0x10(%ebp)
  802018:	85 c0                	test   %eax,%eax
  80201a:	75 c9                	jne    801fe5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802029:	8b 55 08             	mov    0x8(%ebp),%edx
  80202c:	8b 45 10             	mov    0x10(%ebp),%eax
  80202f:	01 d0                	add    %edx,%eax
  802031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802034:	eb 15                	jmp    80204b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f b6 d0             	movzbl %al,%edx
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	0f b6 c0             	movzbl %al,%eax
  802044:	39 c2                	cmp    %eax,%edx
  802046:	74 0d                	je     802055 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802048:	ff 45 08             	incl   0x8(%ebp)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802051:	72 e3                	jb     802036 <memfind+0x13>
  802053:	eb 01                	jmp    802056 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802055:	90                   	nop
	return (void *) s;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80206f:	eb 03                	jmp    802074 <strtol+0x19>
		s++;
  802071:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	8a 00                	mov    (%eax),%al
  802079:	3c 20                	cmp    $0x20,%al
  80207b:	74 f4                	je     802071 <strtol+0x16>
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8a 00                	mov    (%eax),%al
  802082:	3c 09                	cmp    $0x9,%al
  802084:	74 eb                	je     802071 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	3c 2b                	cmp    $0x2b,%al
  80208d:	75 05                	jne    802094 <strtol+0x39>
		s++;
  80208f:	ff 45 08             	incl   0x8(%ebp)
  802092:	eb 13                	jmp    8020a7 <strtol+0x4c>
	else if (*s == '-')
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8a 00                	mov    (%eax),%al
  802099:	3c 2d                	cmp    $0x2d,%al
  80209b:	75 0a                	jne    8020a7 <strtol+0x4c>
		s++, neg = 1;
  80209d:	ff 45 08             	incl   0x8(%ebp)
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ab:	74 06                	je     8020b3 <strtol+0x58>
  8020ad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020b1:	75 20                	jne    8020d3 <strtol+0x78>
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8a 00                	mov    (%eax),%al
  8020b8:	3c 30                	cmp    $0x30,%al
  8020ba:	75 17                	jne    8020d3 <strtol+0x78>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	40                   	inc    %eax
  8020c0:	8a 00                	mov    (%eax),%al
  8020c2:	3c 78                	cmp    $0x78,%al
  8020c4:	75 0d                	jne    8020d3 <strtol+0x78>
		s += 2, base = 16;
  8020c6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8020ca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8020d1:	eb 28                	jmp    8020fb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8020d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d7:	75 15                	jne    8020ee <strtol+0x93>
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	8a 00                	mov    (%eax),%al
  8020de:	3c 30                	cmp    $0x30,%al
  8020e0:	75 0c                	jne    8020ee <strtol+0x93>
		s++, base = 8;
  8020e2:	ff 45 08             	incl   0x8(%ebp)
  8020e5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8020ec:	eb 0d                	jmp    8020fb <strtol+0xa0>
	else if (base == 0)
  8020ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f2:	75 07                	jne    8020fb <strtol+0xa0>
		base = 10;
  8020f4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8a 00                	mov    (%eax),%al
  802100:	3c 2f                	cmp    $0x2f,%al
  802102:	7e 19                	jle    80211d <strtol+0xc2>
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8a 00                	mov    (%eax),%al
  802109:	3c 39                	cmp    $0x39,%al
  80210b:	7f 10                	jg     80211d <strtol+0xc2>
			dig = *s - '0';
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8a 00                	mov    (%eax),%al
  802112:	0f be c0             	movsbl %al,%eax
  802115:	83 e8 30             	sub    $0x30,%eax
  802118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211b:	eb 42                	jmp    80215f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8a 00                	mov    (%eax),%al
  802122:	3c 60                	cmp    $0x60,%al
  802124:	7e 19                	jle    80213f <strtol+0xe4>
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8a 00                	mov    (%eax),%al
  80212b:	3c 7a                	cmp    $0x7a,%al
  80212d:	7f 10                	jg     80213f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8a 00                	mov    (%eax),%al
  802134:	0f be c0             	movsbl %al,%eax
  802137:	83 e8 57             	sub    $0x57,%eax
  80213a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213d:	eb 20                	jmp    80215f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	8a 00                	mov    (%eax),%al
  802144:	3c 40                	cmp    $0x40,%al
  802146:	7e 39                	jle    802181 <strtol+0x126>
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8a 00                	mov    (%eax),%al
  80214d:	3c 5a                	cmp    $0x5a,%al
  80214f:	7f 30                	jg     802181 <strtol+0x126>
			dig = *s - 'A' + 10;
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8a 00                	mov    (%eax),%al
  802156:	0f be c0             	movsbl %al,%eax
  802159:	83 e8 37             	sub    $0x37,%eax
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	3b 45 10             	cmp    0x10(%ebp),%eax
  802165:	7d 19                	jge    802180 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802167:	ff 45 08             	incl   0x8(%ebp)
  80216a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80216d:	0f af 45 10          	imul   0x10(%ebp),%eax
  802171:	89 c2                	mov    %eax,%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80217b:	e9 7b ff ff ff       	jmp    8020fb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802180:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802185:	74 08                	je     80218f <strtol+0x134>
		*endptr = (char *) s;
  802187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218a:	8b 55 08             	mov    0x8(%ebp),%edx
  80218d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80218f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802193:	74 07                	je     80219c <strtol+0x141>
  802195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802198:	f7 d8                	neg    %eax
  80219a:	eb 03                	jmp    80219f <strtol+0x144>
  80219c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <ltostr>:

void
ltostr(long value, char *str)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b9:	79 13                	jns    8021ce <ltostr+0x2d>
	{
		neg = 1;
  8021bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8021c8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8021cb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021d6:	99                   	cltd   
  8021d7:	f7 f9                	idiv   %ecx
  8021d9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8021dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021df:	8d 50 01             	lea    0x1(%eax),%edx
  8021e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	01 d0                	add    %edx,%eax
  8021ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ef:	83 c2 30             	add    $0x30,%edx
  8021f2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8021f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8021fc:	f7 e9                	imul   %ecx
  8021fe:	c1 fa 02             	sar    $0x2,%edx
  802201:	89 c8                	mov    %ecx,%eax
  802203:	c1 f8 1f             	sar    $0x1f,%eax
  802206:	29 c2                	sub    %eax,%edx
  802208:	89 d0                	mov    %edx,%eax
  80220a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80220d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802210:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802215:	f7 e9                	imul   %ecx
  802217:	c1 fa 02             	sar    $0x2,%edx
  80221a:	89 c8                	mov    %ecx,%eax
  80221c:	c1 f8 1f             	sar    $0x1f,%eax
  80221f:	29 c2                	sub    %eax,%edx
  802221:	89 d0                	mov    %edx,%eax
  802223:	c1 e0 02             	shl    $0x2,%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	01 c0                	add    %eax,%eax
  80222a:	29 c1                	sub    %eax,%ecx
  80222c:	89 ca                	mov    %ecx,%edx
  80222e:	85 d2                	test   %edx,%edx
  802230:	75 9c                	jne    8021ce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802239:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80223c:	48                   	dec    %eax
  80223d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802240:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802244:	74 3d                	je     802283 <ltostr+0xe2>
		start = 1 ;
  802246:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80224d:	eb 34                	jmp    802283 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	8b 45 0c             	mov    0xc(%ebp),%eax
  802255:	01 d0                	add    %edx,%eax
  802257:	8a 00                	mov    (%eax),%al
  802259:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80225c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802262:	01 c2                	add    %eax,%edx
  802264:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	01 c8                	add    %ecx,%eax
  80226c:	8a 00                	mov    (%eax),%al
  80226e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802270:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802273:	8b 45 0c             	mov    0xc(%ebp),%eax
  802276:	01 c2                	add    %eax,%edx
  802278:	8a 45 eb             	mov    -0x15(%ebp),%al
  80227b:	88 02                	mov    %al,(%edx)
		start++ ;
  80227d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802280:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802289:	7c c4                	jl     80224f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80228b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80228e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802291:	01 d0                	add    %edx,%eax
  802293:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802296:	90                   	nop
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80229f:	ff 75 08             	pushl  0x8(%ebp)
  8022a2:	e8 54 fa ff ff       	call   801cfb <strlen>
  8022a7:	83 c4 04             	add    $0x4,%esp
  8022aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022ad:	ff 75 0c             	pushl  0xc(%ebp)
  8022b0:	e8 46 fa ff ff       	call   801cfb <strlen>
  8022b5:	83 c4 04             	add    $0x4,%esp
  8022b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022c9:	eb 17                	jmp    8022e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8022cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d1:	01 c2                	add    %eax,%edx
  8022d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	01 c8                	add    %ecx,%eax
  8022db:	8a 00                	mov    (%eax),%al
  8022dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022df:	ff 45 fc             	incl   -0x4(%ebp)
  8022e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022e8:	7c e1                	jl     8022cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8022ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8022f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8022f8:	eb 1f                	jmp    802319 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8022fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fd:	8d 50 01             	lea    0x1(%eax),%edx
  802300:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802303:	89 c2                	mov    %eax,%edx
  802305:	8b 45 10             	mov    0x10(%ebp),%eax
  802308:	01 c2                	add    %eax,%edx
  80230a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	01 c8                	add    %ecx,%eax
  802312:	8a 00                	mov    (%eax),%al
  802314:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802316:	ff 45 f8             	incl   -0x8(%ebp)
  802319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80231f:	7c d9                	jl     8022fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802321:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802324:	8b 45 10             	mov    0x10(%ebp),%eax
  802327:	01 d0                	add    %edx,%eax
  802329:	c6 00 00             	movb   $0x0,(%eax)
}
  80232c:	90                   	nop
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802332:	8b 45 14             	mov    0x14(%ebp),%eax
  802335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80233b:	8b 45 14             	mov    0x14(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802347:	8b 45 10             	mov    0x10(%ebp),%eax
  80234a:	01 d0                	add    %edx,%eax
  80234c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802352:	eb 0c                	jmp    802360 <strsplit+0x31>
			*string++ = 0;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	8d 50 01             	lea    0x1(%eax),%edx
  80235a:	89 55 08             	mov    %edx,0x8(%ebp)
  80235d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8a 00                	mov    (%eax),%al
  802365:	84 c0                	test   %al,%al
  802367:	74 18                	je     802381 <strsplit+0x52>
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8a 00                	mov    (%eax),%al
  80236e:	0f be c0             	movsbl %al,%eax
  802371:	50                   	push   %eax
  802372:	ff 75 0c             	pushl  0xc(%ebp)
  802375:	e8 13 fb ff ff       	call   801e8d <strchr>
  80237a:	83 c4 08             	add    $0x8,%esp
  80237d:	85 c0                	test   %eax,%eax
  80237f:	75 d3                	jne    802354 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	8a 00                	mov    (%eax),%al
  802386:	84 c0                	test   %al,%al
  802388:	74 5a                	je     8023e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80238a:	8b 45 14             	mov    0x14(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	83 f8 0f             	cmp    $0xf,%eax
  802392:	75 07                	jne    80239b <strsplit+0x6c>
		{
			return 0;
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	eb 66                	jmp    802401 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80239b:	8b 45 14             	mov    0x14(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8023a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8023a6:	89 0a                	mov    %ecx,(%edx)
  8023a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023af:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b2:	01 c2                	add    %eax,%edx
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023b9:	eb 03                	jmp    8023be <strsplit+0x8f>
			string++;
  8023bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8a 00                	mov    (%eax),%al
  8023c3:	84 c0                	test   %al,%al
  8023c5:	74 8b                	je     802352 <strsplit+0x23>
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8a 00                	mov    (%eax),%al
  8023cc:	0f be c0             	movsbl %al,%eax
  8023cf:	50                   	push   %eax
  8023d0:	ff 75 0c             	pushl  0xc(%ebp)
  8023d3:	e8 b5 fa ff ff       	call   801e8d <strchr>
  8023d8:	83 c4 08             	add    $0x8,%esp
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 dc                	je     8023bb <strsplit+0x8c>
			string++;
	}
  8023df:	e9 6e ff ff ff       	jmp    802352 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f4:	01 d0                	add    %edx,%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8023fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  802409:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802410:	eb 4c                	jmp    80245e <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  802412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	01 d0                	add    %edx,%eax
  80241a:	8a 00                	mov    (%eax),%al
  80241c:	3c 40                	cmp    $0x40,%al
  80241e:	7e 27                	jle    802447 <str2lower+0x44>
  802420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802423:	8b 45 0c             	mov    0xc(%ebp),%eax
  802426:	01 d0                	add    %edx,%eax
  802428:	8a 00                	mov    (%eax),%al
  80242a:	3c 5a                	cmp    $0x5a,%al
  80242c:	7f 19                	jg     802447 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80242e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	01 d0                	add    %edx,%eax
  802436:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243c:	01 ca                	add    %ecx,%edx
  80243e:	8a 12                	mov    (%edx),%dl
  802440:	83 c2 20             	add    $0x20,%edx
  802443:	88 10                	mov    %dl,(%eax)
  802445:	eb 14                	jmp    80245b <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  802447:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	01 c2                	add    %eax,%edx
  80244f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802452:	8b 45 0c             	mov    0xc(%ebp),%eax
  802455:	01 c8                	add    %ecx,%eax
  802457:	8a 00                	mov    (%eax),%al
  802459:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80245b:	ff 45 fc             	incl   -0x4(%ebp)
  80245e:	ff 75 0c             	pushl  0xc(%ebp)
  802461:	e8 95 f8 ff ff       	call   801cfb <strlen>
  802466:	83 c4 04             	add    $0x4,%esp
  802469:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80246c:	7f a4                	jg     802412 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  802476:	a1 04 50 80 00       	mov    0x805004,%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 0a                	je     802489 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80247f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802486:	00 00 00 
	}
}
  802489:	90                   	nop
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    

0080248c <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802492:	83 ec 0c             	sub    $0xc,%esp
  802495:	ff 75 08             	pushl  0x8(%ebp)
  802498:	e8 7e 09 00 00       	call   802e1b <sys_sbrk>
  80249d:	83 c4 10             	add    $0x10,%esp
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024a8:	e8 c6 ff ff ff       	call   802473 <InitializeUHeap>
	if (size == 0)
  8024ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b1:	75 0a                	jne    8024bd <malloc+0x1b>
		return NULL;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b8:	e9 3f 01 00 00       	jmp    8025fc <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8024bd:	e8 ac 09 00 00       	call   802e6e <sys_get_hard_limit>
  8024c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  8024c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  8024cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024cf:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8024d4:	c1 e8 0c             	shr    $0xc,%eax
  8024d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8024da:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	48                   	dec    %eax
  8024ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f5:	f7 75 d8             	divl   -0x28(%ebp)
  8024f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024fb:	29 d0                	sub    %edx,%eax
  8024fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  802500:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802503:	c1 e8 0c             	shr    $0xc,%eax
  802506:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  802509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250d:	75 0a                	jne    802519 <malloc+0x77>
		return NULL;
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
  802514:	e9 e3 00 00 00       	jmp    8025fc <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  802519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251c:	05 00 00 00 80       	add    $0x80000000,%eax
  802521:	c1 e8 0c             	shr    $0xc,%eax
  802524:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802529:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802530:	77 19                	ja     80254b <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	ff 75 08             	pushl  0x8(%ebp)
  802538:	e8 60 0b 00 00       	call   80309d <alloc_block_FF>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  802543:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802546:	e9 b1 00 00 00       	jmp    8025fc <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80254b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80254e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802551:	eb 4d                	jmp    8025a0 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  802553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802556:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  80255d:	84 c0                	test   %al,%al
  80255f:	75 27                	jne    802588 <malloc+0xe6>
			{
				counter++;
  802561:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  802564:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  802568:	75 14                	jne    80257e <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80256a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80256d:	05 00 00 08 00       	add    $0x80000,%eax
  802572:	c1 e0 0c             	shl    $0xc,%eax
  802575:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  802578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80257b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802584:	75 17                	jne    80259d <malloc+0xfb>
				{
					break;
  802586:	eb 21                	jmp    8025a9 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  802588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80258b:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  802592:	3c 01                	cmp    $0x1,%al
  802594:	75 07                	jne    80259d <malloc+0xfb>
			{
				counter = 0;
  802596:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80259d:	ff 45 e8             	incl   -0x18(%ebp)
  8025a0:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8025a7:	76 aa                	jbe    802553 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8025af:	75 46                	jne    8025f7 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  8025b1:	83 ec 08             	sub    $0x8,%esp
  8025b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8025b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ba:	e8 93 08 00 00       	call   802e52 <sys_allocate_user_mem>
  8025bf:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8025c8:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025d5:	eb 0e                	jmp    8025e5 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8025d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025da:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  8025e1:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8025e2:	ff 45 e4             	incl   -0x1c(%ebp)
  8025e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025f0:	77 e5                	ja     8025d7 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	eb 05                	jmp    8025fc <malloc+0x15a>
		}
	}

	return NULL;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  802604:	e8 65 08 00 00       	call   802e6e <sys_get_hard_limit>
  802609:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  802612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802616:	0f 84 c1 00 00 00    	je     8026dd <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  80261c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	79 1b                	jns    80263e <free+0x40>
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802629:	73 13                	jae    80263e <free+0x40>
    {
        free_block(virtual_address);
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	ff 75 08             	pushl  0x8(%ebp)
  802631:	e8 34 10 00 00       	call   80366a <free_block>
  802636:	83 c4 10             	add    $0x10,%esp
    	return;
  802639:	e9 a6 00 00 00       	jmp    8026e4 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	05 00 10 00 00       	add    $0x1000,%eax
  802646:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802649:	0f 87 91 00 00 00    	ja     8026e0 <free+0xe2>
  80264f:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802656:	0f 87 84 00 00 00    	ja     8026e0 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80265c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802665:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80266a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80266d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802670:	05 00 00 00 80       	add    $0x80000000,%eax
  802675:	c1 e8 0c             	shr    $0xc,%eax
  802678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  802685:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  802688:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80268c:	74 55                	je     8026e3 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  80268e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802691:	c1 e8 0c             	shr    $0xc,%eax
  802694:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  802697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269a:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  8026a1:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8026a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	eb 0e                	jmp    8026bb <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  8026b7:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  8026b8:	ff 45 f4             	incl   -0xc(%ebp)
  8026bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c1:	01 c2                	add    %eax,%edx
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	39 c2                	cmp    %eax,%edx
  8026c8:	77 e3                	ja     8026ad <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  8026ca:	83 ec 08             	sub    $0x8,%esp
  8026cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8026d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8026d3:	e8 5e 07 00 00       	call   802e36 <sys_free_user_mem>
  8026d8:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8026db:	eb 07                	jmp    8026e4 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8026dd:	90                   	nop
  8026de:	eb 04                	jmp    8026e4 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8026e0:	90                   	nop
  8026e1:	eb 01                	jmp    8026e4 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8026e3:	90                   	nop
    else
     {
    	return;
      }

}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 18             	sub    $0x18,%esp
  8026ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ef:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026f2:	e8 7c fd ff ff       	call   802473 <InitializeUHeap>
	if (size == 0)
  8026f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026fb:	75 07                	jne    802704 <smalloc+0x1e>
		return NULL;
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802702:	eb 17                	jmp    80271b <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	68 b0 4b 80 00       	push   $0x804bb0
  80270c:	68 ad 00 00 00       	push   $0xad
  802711:	68 d6 4b 80 00       	push   $0x804bd6
  802716:	e8 a1 ec ff ff       	call   8013bc <_panic>
	return NULL;
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802723:	e8 4b fd ff ff       	call   802473 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 e4 4b 80 00       	push   $0x804be4
  802730:	68 ba 00 00 00       	push   $0xba
  802735:	68 d6 4b 80 00       	push   $0x804bd6
  80273a:	e8 7d ec ff ff       	call   8013bc <_panic>

0080273f <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802745:	e8 29 fd ff ff       	call   802473 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80274a:	83 ec 04             	sub    $0x4,%esp
  80274d:	68 08 4c 80 00       	push   $0x804c08
  802752:	68 d8 00 00 00       	push   $0xd8
  802757:	68 d6 4b 80 00       	push   $0x804bd6
  80275c:	e8 5b ec ff ff       	call   8013bc <_panic>

00802761 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 30 4c 80 00       	push   $0x804c30
  80276f:	68 ea 00 00 00       	push   $0xea
  802774:	68 d6 4b 80 00       	push   $0x804bd6
  802779:	e8 3e ec ff ff       	call   8013bc <_panic>

0080277e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 54 4c 80 00       	push   $0x804c54
  80278c:	68 f2 00 00 00       	push   $0xf2
  802791:	68 d6 4b 80 00       	push   $0x804bd6
  802796:	e8 21 ec ff ff       	call   8013bc <_panic>

0080279b <shrink>:

}
void shrink(uint32 newSize) {
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 54 4c 80 00       	push   $0x804c54
  8027a9:	68 f6 00 00 00       	push   $0xf6
  8027ae:	68 d6 4b 80 00       	push   $0x804bd6
  8027b3:	e8 04 ec ff ff       	call   8013bc <_panic>

008027b8 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	68 54 4c 80 00       	push   $0x804c54
  8027c6:	68 fa 00 00 00       	push   $0xfa
  8027cb:	68 d6 4b 80 00       	push   $0x804bd6
  8027d0:	e8 e7 eb ff ff       	call   8013bc <_panic>

008027d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	57                   	push   %edi
  8027d9:	56                   	push   %esi
  8027da:	53                   	push   %ebx
  8027db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027f0:	cd 30                	int    $0x30
  8027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027f8:	83 c4 10             	add    $0x10,%esp
  8027fb:	5b                   	pop    %ebx
  8027fc:	5e                   	pop    %esi
  8027fd:	5f                   	pop    %edi
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    

00802800 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	8b 45 10             	mov    0x10(%ebp),%eax
  802809:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80280c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	52                   	push   %edx
  802818:	ff 75 0c             	pushl  0xc(%ebp)
  80281b:	50                   	push   %eax
  80281c:	6a 00                	push   $0x0
  80281e:	e8 b2 ff ff ff       	call   8027d5 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
}
  802826:	90                   	nop
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <sys_cgetc>:

int
sys_cgetc(void)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 01                	push   $0x1
  802838:	e8 98 ff ff ff       	call   8027d5 <syscall>
  80283d:	83 c4 18             	add    $0x18,%esp
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802845:	8b 55 0c             	mov    0xc(%ebp),%edx
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	52                   	push   %edx
  802852:	50                   	push   %eax
  802853:	6a 05                	push   $0x5
  802855:	e8 7b ff ff ff       	call   8027d5 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	56                   	push   %esi
  802863:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802864:	8b 75 18             	mov    0x18(%ebp),%esi
  802867:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80286a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	56                   	push   %esi
  802874:	53                   	push   %ebx
  802875:	51                   	push   %ecx
  802876:	52                   	push   %edx
  802877:	50                   	push   %eax
  802878:	6a 06                	push   $0x6
  80287a:	e8 56 ff ff ff       	call   8027d5 <syscall>
  80287f:	83 c4 18             	add    $0x18,%esp
}
  802882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802885:	5b                   	pop    %ebx
  802886:	5e                   	pop    %esi
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    

00802889 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80288c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	52                   	push   %edx
  802899:	50                   	push   %eax
  80289a:	6a 07                	push   $0x7
  80289c:	e8 34 ff ff ff       	call   8027d5 <syscall>
  8028a1:	83 c4 18             	add    $0x18,%esp
}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	ff 75 0c             	pushl  0xc(%ebp)
  8028b2:	ff 75 08             	pushl  0x8(%ebp)
  8028b5:	6a 08                	push   $0x8
  8028b7:	e8 19 ff ff ff       	call   8027d5 <syscall>
  8028bc:	83 c4 18             	add    $0x18,%esp
}
  8028bf:	c9                   	leave  
  8028c0:	c3                   	ret    

008028c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 09                	push   $0x9
  8028d0:	e8 00 ff ff ff       	call   8027d5 <syscall>
  8028d5:	83 c4 18             	add    $0x18,%esp
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 0a                	push   $0xa
  8028e9:	e8 e7 fe ff ff       	call   8027d5 <syscall>
  8028ee:	83 c4 18             	add    $0x18,%esp
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 0b                	push   $0xb
  802902:	e8 ce fe ff ff       	call   8027d5 <syscall>
  802907:	83 c4 18             	add    $0x18,%esp
}
  80290a:	c9                   	leave  
  80290b:	c3                   	ret    

0080290c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 0c                	push   $0xc
  80291b:	e8 b5 fe ff ff       	call   8027d5 <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
}
  802923:	c9                   	leave  
  802924:	c3                   	ret    

00802925 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	ff 75 08             	pushl  0x8(%ebp)
  802933:	6a 0d                	push   $0xd
  802935:	e8 9b fe ff ff       	call   8027d5 <syscall>
  80293a:	83 c4 18             	add    $0x18,%esp
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 0e                	push   $0xe
  80294e:	e8 82 fe ff ff       	call   8027d5 <syscall>
  802953:	83 c4 18             	add    $0x18,%esp
}
  802956:	90                   	nop
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 11                	push   $0x11
  802968:	e8 68 fe ff ff       	call   8027d5 <syscall>
  80296d:	83 c4 18             	add    $0x18,%esp
}
  802970:	90                   	nop
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 12                	push   $0x12
  802982:	e8 4e fe ff ff       	call   8027d5 <syscall>
  802987:	83 c4 18             	add    $0x18,%esp
}
  80298a:	90                   	nop
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <sys_cputc>:


void
sys_cputc(const char c)
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
  802990:	83 ec 04             	sub    $0x4,%esp
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802999:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	50                   	push   %eax
  8029a6:	6a 13                	push   $0x13
  8029a8:	e8 28 fe ff ff       	call   8027d5 <syscall>
  8029ad:	83 c4 18             	add    $0x18,%esp
}
  8029b0:	90                   	nop
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 14                	push   $0x14
  8029c2:	e8 0e fe ff ff       	call   8027d5 <syscall>
  8029c7:	83 c4 18             	add    $0x18,%esp
}
  8029ca:	90                   	nop
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	ff 75 0c             	pushl  0xc(%ebp)
  8029dc:	50                   	push   %eax
  8029dd:	6a 15                	push   $0x15
  8029df:	e8 f1 fd ff ff       	call   8027d5 <syscall>
  8029e4:	83 c4 18             	add    $0x18,%esp
}
  8029e7:	c9                   	leave  
  8029e8:	c3                   	ret    

008029e9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	52                   	push   %edx
  8029f9:	50                   	push   %eax
  8029fa:	6a 18                	push   $0x18
  8029fc:	e8 d4 fd ff ff       	call   8027d5 <syscall>
  802a01:	83 c4 18             	add    $0x18,%esp
}
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	52                   	push   %edx
  802a16:	50                   	push   %eax
  802a17:	6a 16                	push   $0x16
  802a19:	e8 b7 fd ff ff       	call   8027d5 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	90                   	nop
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	52                   	push   %edx
  802a34:	50                   	push   %eax
  802a35:	6a 17                	push   $0x17
  802a37:	e8 99 fd ff ff       	call   8027d5 <syscall>
  802a3c:	83 c4 18             	add    $0x18,%esp
}
  802a3f:	90                   	nop
  802a40:	c9                   	leave  
  802a41:	c3                   	ret    

00802a42 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a42:	55                   	push   %ebp
  802a43:	89 e5                	mov    %esp,%ebp
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	8b 45 10             	mov    0x10(%ebp),%eax
  802a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a51:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	6a 00                	push   $0x0
  802a5a:	51                   	push   %ecx
  802a5b:	52                   	push   %edx
  802a5c:	ff 75 0c             	pushl  0xc(%ebp)
  802a5f:	50                   	push   %eax
  802a60:	6a 19                	push   $0x19
  802a62:	e8 6e fd ff ff       	call   8027d5 <syscall>
  802a67:	83 c4 18             	add    $0x18,%esp
}
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	52                   	push   %edx
  802a7c:	50                   	push   %eax
  802a7d:	6a 1a                	push   $0x1a
  802a7f:	e8 51 fd ff ff       	call   8027d5 <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	51                   	push   %ecx
  802a9a:	52                   	push   %edx
  802a9b:	50                   	push   %eax
  802a9c:	6a 1b                	push   $0x1b
  802a9e:	e8 32 fd ff ff       	call   8027d5 <syscall>
  802aa3:	83 c4 18             	add    $0x18,%esp
}
  802aa6:	c9                   	leave  
  802aa7:	c3                   	ret    

00802aa8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	52                   	push   %edx
  802ab8:	50                   	push   %eax
  802ab9:	6a 1c                	push   $0x1c
  802abb:	e8 15 fd ff ff       	call   8027d5 <syscall>
  802ac0:	83 c4 18             	add    $0x18,%esp
}
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

00802ac5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 1d                	push   $0x1d
  802ad4:	e8 fc fc ff ff       	call   8027d5 <syscall>
  802ad9:	83 c4 18             	add    $0x18,%esp
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	6a 00                	push   $0x0
  802ae6:	ff 75 14             	pushl  0x14(%ebp)
  802ae9:	ff 75 10             	pushl  0x10(%ebp)
  802aec:	ff 75 0c             	pushl  0xc(%ebp)
  802aef:	50                   	push   %eax
  802af0:	6a 1e                	push   $0x1e
  802af2:	e8 de fc ff ff       	call   8027d5 <syscall>
  802af7:	83 c4 18             	add    $0x18,%esp
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	6a 00                	push   $0x0
  802b0a:	50                   	push   %eax
  802b0b:	6a 1f                	push   $0x1f
  802b0d:	e8 c3 fc ff ff       	call   8027d5 <syscall>
  802b12:	83 c4 18             	add    $0x18,%esp
}
  802b15:	90                   	nop
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	50                   	push   %eax
  802b27:	6a 20                	push   $0x20
  802b29:	e8 a7 fc ff ff       	call   8027d5 <syscall>
  802b2e:	83 c4 18             	add    $0x18,%esp
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 02                	push   $0x2
  802b42:	e8 8e fc ff ff       	call   8027d5 <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 03                	push   $0x3
  802b5b:	e8 75 fc ff ff       	call   8027d5 <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    

00802b65 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 04                	push   $0x4
  802b74:	e8 5c fc ff ff       	call   8027d5 <syscall>
  802b79:	83 c4 18             	add    $0x18,%esp
}
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <sys_exit_env>:


void sys_exit_env(void)
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b81:	6a 00                	push   $0x0
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 21                	push   $0x21
  802b8d:	e8 43 fc ff ff       	call   8027d5 <syscall>
  802b92:	83 c4 18             	add    $0x18,%esp
}
  802b95:	90                   	nop
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
  802b9b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b9e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ba1:	8d 50 04             	lea    0x4(%eax),%edx
  802ba4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	52                   	push   %edx
  802bae:	50                   	push   %eax
  802baf:	6a 22                	push   $0x22
  802bb1:	e8 1f fc ff ff       	call   8027d5 <syscall>
  802bb6:	83 c4 18             	add    $0x18,%esp
	return result;
  802bb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bbf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bc2:	89 01                	mov    %eax,(%ecx)
  802bc4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	c9                   	leave  
  802bcb:	c2 04 00             	ret    $0x4

00802bce <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	ff 75 10             	pushl  0x10(%ebp)
  802bd8:	ff 75 0c             	pushl  0xc(%ebp)
  802bdb:	ff 75 08             	pushl  0x8(%ebp)
  802bde:	6a 10                	push   $0x10
  802be0:	e8 f0 fb ff ff       	call   8027d5 <syscall>
  802be5:	83 c4 18             	add    $0x18,%esp
	return ;
  802be8:	90                   	nop
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    

00802beb <sys_rcr2>:
uint32 sys_rcr2()
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 23                	push   $0x23
  802bfa:	e8 d6 fb ff ff       	call   8027d5 <syscall>
  802bff:	83 c4 18             	add    $0x18,%esp
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c10:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	50                   	push   %eax
  802c1d:	6a 24                	push   $0x24
  802c1f:	e8 b1 fb ff ff       	call   8027d5 <syscall>
  802c24:	83 c4 18             	add    $0x18,%esp
	return ;
  802c27:	90                   	nop
}
  802c28:	c9                   	leave  
  802c29:	c3                   	ret    

00802c2a <rsttst>:
void rsttst()
{
  802c2a:	55                   	push   %ebp
  802c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 00                	push   $0x0
  802c33:	6a 00                	push   $0x0
  802c35:	6a 00                	push   $0x0
  802c37:	6a 26                	push   $0x26
  802c39:	e8 97 fb ff ff       	call   8027d5 <syscall>
  802c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802c41:	90                   	nop
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  802c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c50:	8b 55 18             	mov    0x18(%ebp),%edx
  802c53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c57:	52                   	push   %edx
  802c58:	50                   	push   %eax
  802c59:	ff 75 10             	pushl  0x10(%ebp)
  802c5c:	ff 75 0c             	pushl  0xc(%ebp)
  802c5f:	ff 75 08             	pushl  0x8(%ebp)
  802c62:	6a 25                	push   $0x25
  802c64:	e8 6c fb ff ff       	call   8027d5 <syscall>
  802c69:	83 c4 18             	add    $0x18,%esp
	return ;
  802c6c:	90                   	nop
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <chktst>:
void chktst(uint32 n)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c72:	6a 00                	push   $0x0
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	ff 75 08             	pushl  0x8(%ebp)
  802c7d:	6a 27                	push   $0x27
  802c7f:	e8 51 fb ff ff       	call   8027d5 <syscall>
  802c84:	83 c4 18             	add    $0x18,%esp
	return ;
  802c87:	90                   	nop
}
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <inctst>:

void inctst()
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 28                	push   $0x28
  802c99:	e8 37 fb ff ff       	call   8027d5 <syscall>
  802c9e:	83 c4 18             	add    $0x18,%esp
	return ;
  802ca1:	90                   	nop
}
  802ca2:	c9                   	leave  
  802ca3:	c3                   	ret    

00802ca4 <gettst>:
uint32 gettst()
{
  802ca4:	55                   	push   %ebp
  802ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 29                	push   $0x29
  802cb3:	e8 1d fb ff ff       	call   8027d5 <syscall>
  802cb8:	83 c4 18             	add    $0x18,%esp
}
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
  802cc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 00                	push   $0x0
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 2a                	push   $0x2a
  802ccf:	e8 01 fb ff ff       	call   8027d5 <syscall>
  802cd4:	83 c4 18             	add    $0x18,%esp
  802cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802cda:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802cde:	75 07                	jne    802ce7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ce0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce5:	eb 05                	jmp    802cec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
  802cf1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 00                	push   $0x0
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 2a                	push   $0x2a
  802d00:	e8 d0 fa ff ff       	call   8027d5 <syscall>
  802d05:	83 c4 18             	add    $0x18,%esp
  802d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802d0b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802d0f:	75 07                	jne    802d18 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802d11:	b8 01 00 00 00       	mov    $0x1,%eax
  802d16:	eb 05                	jmp    802d1d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1d:	c9                   	leave  
  802d1e:	c3                   	ret    

00802d1f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802d1f:	55                   	push   %ebp
  802d20:	89 e5                	mov    %esp,%ebp
  802d22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 2a                	push   $0x2a
  802d31:	e8 9f fa ff ff       	call   8027d5 <syscall>
  802d36:	83 c4 18             	add    $0x18,%esp
  802d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802d3c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802d40:	75 07                	jne    802d49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802d42:	b8 01 00 00 00       	mov    $0x1,%eax
  802d47:	eb 05                	jmp    802d4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4e:	c9                   	leave  
  802d4f:	c3                   	ret    

00802d50 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d56:	6a 00                	push   $0x0
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 2a                	push   $0x2a
  802d62:	e8 6e fa ff ff       	call   8027d5 <syscall>
  802d67:	83 c4 18             	add    $0x18,%esp
  802d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802d6d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802d71:	75 07                	jne    802d7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802d73:	b8 01 00 00 00       	mov    $0x1,%eax
  802d78:	eb 05                	jmp    802d7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7f:	c9                   	leave  
  802d80:	c3                   	ret    

00802d81 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	ff 75 08             	pushl  0x8(%ebp)
  802d8f:	6a 2b                	push   $0x2b
  802d91:	e8 3f fa ff ff       	call   8027d5 <syscall>
  802d96:	83 c4 18             	add    $0x18,%esp
	return ;
  802d99:	90                   	nop
}
  802d9a:	c9                   	leave  
  802d9b:	c3                   	ret    

00802d9c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d9c:	55                   	push   %ebp
  802d9d:	89 e5                	mov    %esp,%ebp
  802d9f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802da0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802da3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	6a 00                	push   $0x0
  802dae:	53                   	push   %ebx
  802daf:	51                   	push   %ecx
  802db0:	52                   	push   %edx
  802db1:	50                   	push   %eax
  802db2:	6a 2c                	push   $0x2c
  802db4:	e8 1c fa ff ff       	call   8027d5 <syscall>
  802db9:	83 c4 18             	add    $0x18,%esp
}
  802dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dbf:	c9                   	leave  
  802dc0:	c3                   	ret    

00802dc1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	52                   	push   %edx
  802dd1:	50                   	push   %eax
  802dd2:	6a 2d                	push   $0x2d
  802dd4:	e8 fc f9 ff ff       	call   8027d5 <syscall>
  802dd9:	83 c4 18             	add    $0x18,%esp
}
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802de1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	6a 00                	push   $0x0
  802dec:	51                   	push   %ecx
  802ded:	ff 75 10             	pushl  0x10(%ebp)
  802df0:	52                   	push   %edx
  802df1:	50                   	push   %eax
  802df2:	6a 2e                	push   $0x2e
  802df4:	e8 dc f9 ff ff       	call   8027d5 <syscall>
  802df9:	83 c4 18             	add    $0x18,%esp
}
  802dfc:	c9                   	leave  
  802dfd:	c3                   	ret    

00802dfe <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802dfe:	55                   	push   %ebp
  802dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	ff 75 10             	pushl  0x10(%ebp)
  802e08:	ff 75 0c             	pushl  0xc(%ebp)
  802e0b:	ff 75 08             	pushl  0x8(%ebp)
  802e0e:	6a 0f                	push   $0xf
  802e10:	e8 c0 f9 ff ff       	call   8027d5 <syscall>
  802e15:	83 c4 18             	add    $0x18,%esp
	return ;
  802e18:	90                   	nop
}
  802e19:	c9                   	leave  
  802e1a:	c3                   	ret    

00802e1b <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802e1b:	55                   	push   %ebp
  802e1c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	6a 00                	push   $0x0
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	50                   	push   %eax
  802e2a:	6a 2f                	push   $0x2f
  802e2c:	e8 a4 f9 ff ff       	call   8027d5 <syscall>
  802e31:	83 c4 18             	add    $0x18,%esp

}
  802e34:	c9                   	leave  
  802e35:	c3                   	ret    

00802e36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	ff 75 0c             	pushl  0xc(%ebp)
  802e42:	ff 75 08             	pushl  0x8(%ebp)
  802e45:	6a 30                	push   $0x30
  802e47:	e8 89 f9 ff ff       	call   8027d5 <syscall>
  802e4c:	83 c4 18             	add    $0x18,%esp
	return;
  802e4f:	90                   	nop
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	ff 75 0c             	pushl  0xc(%ebp)
  802e5e:	ff 75 08             	pushl  0x8(%ebp)
  802e61:	6a 31                	push   $0x31
  802e63:	e8 6d f9 ff ff       	call   8027d5 <syscall>
  802e68:	83 c4 18             	add    $0x18,%esp
	return;
  802e6b:	90                   	nop
}
  802e6c:	c9                   	leave  
  802e6d:	c3                   	ret    

00802e6e <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802e6e:	55                   	push   %ebp
  802e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802e71:	6a 00                	push   $0x0
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 00                	push   $0x0
  802e79:	6a 00                	push   $0x0
  802e7b:	6a 32                	push   $0x32
  802e7d:	e8 53 f9 ff ff       	call   8027d5 <syscall>
  802e82:	83 c4 18             	add    $0x18,%esp
}
  802e85:	c9                   	leave  
  802e86:	c3                   	ret    

00802e87 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802e87:	55                   	push   %ebp
  802e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	6a 00                	push   $0x0
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	50                   	push   %eax
  802e96:	6a 33                	push   $0x33
  802e98:	e8 38 f9 ff ff       	call   8027d5 <syscall>
  802e9d:	83 c4 18             	add    $0x18,%esp
}
  802ea0:	90                   	nop
  802ea1:	c9                   	leave  
  802ea2:	c3                   	ret    

00802ea3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802ea3:	55                   	push   %ebp
  802ea4:	89 e5                	mov    %esp,%ebp
  802ea6:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	83 e8 10             	sub    $0x10,%eax
  802eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
}
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	83 e8 10             	sub    $0x10,%eax
  802ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ecb:	8a 40 04             	mov    0x4(%eax),%al
}
  802ece:	c9                   	leave  
  802ecf:	c3                   	ret    

00802ed0 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
  802ed3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802ed6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee0:	83 f8 02             	cmp    $0x2,%eax
  802ee3:	74 2b                	je     802f10 <alloc_block+0x40>
  802ee5:	83 f8 02             	cmp    $0x2,%eax
  802ee8:	7f 07                	jg     802ef1 <alloc_block+0x21>
  802eea:	83 f8 01             	cmp    $0x1,%eax
  802eed:	74 0e                	je     802efd <alloc_block+0x2d>
  802eef:	eb 58                	jmp    802f49 <alloc_block+0x79>
  802ef1:	83 f8 03             	cmp    $0x3,%eax
  802ef4:	74 2d                	je     802f23 <alloc_block+0x53>
  802ef6:	83 f8 04             	cmp    $0x4,%eax
  802ef9:	74 3b                	je     802f36 <alloc_block+0x66>
  802efb:	eb 4c                	jmp    802f49 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802efd:	83 ec 0c             	sub    $0xc,%esp
  802f00:	ff 75 08             	pushl  0x8(%ebp)
  802f03:	e8 95 01 00 00       	call   80309d <alloc_block_FF>
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f0e:	eb 4a                	jmp    802f5a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	e8 32 07 00 00       	call   80364d <alloc_block_NF>
  802f1b:	83 c4 10             	add    $0x10,%esp
  802f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f21:	eb 37                	jmp    802f5a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	e8 a3 04 00 00       	call   8033d1 <alloc_block_BF>
  802f2e:	83 c4 10             	add    $0x10,%esp
  802f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f34:	eb 24                	jmp    802f5a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802f36:	83 ec 0c             	sub    $0xc,%esp
  802f39:	ff 75 08             	pushl  0x8(%ebp)
  802f3c:	e8 ef 06 00 00       	call   803630 <alloc_block_WF>
  802f41:	83 c4 10             	add    $0x10,%esp
  802f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f47:	eb 11                	jmp    802f5a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802f49:	83 ec 0c             	sub    $0xc,%esp
  802f4c:	68 64 4c 80 00       	push   $0x804c64
  802f51:	e8 23 e7 ff ff       	call   801679 <cprintf>
  802f56:	83 c4 10             	add    $0x10,%esp
		break;
  802f59:	90                   	nop
	}
	return va;
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
  802f62:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802f65:	83 ec 0c             	sub    $0xc,%esp
  802f68:	68 84 4c 80 00       	push   $0x804c84
  802f6d:	e8 07 e7 ff ff       	call   801679 <cprintf>
  802f72:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802f75:	83 ec 0c             	sub    $0xc,%esp
  802f78:	68 af 4c 80 00       	push   $0x804caf
  802f7d:	e8 f7 e6 ff ff       	call   801679 <cprintf>
  802f82:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8b:	eb 26                	jmp    802fb3 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8a 40 04             	mov    0x4(%eax),%al
  802f93:	0f b6 d0             	movzbl %al,%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	52                   	push   %edx
  802f9f:	50                   	push   %eax
  802fa0:	68 c7 4c 80 00       	push   $0x804cc7
  802fa5:	e8 cf e6 ff ff       	call   801679 <cprintf>
  802faa:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802fad:	8b 45 10             	mov    0x10(%ebp),%eax
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb7:	74 08                	je     802fc1 <print_blocks_list+0x62>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 40 08             	mov    0x8(%eax),%eax
  802fbf:	eb 05                	jmp    802fc6 <print_blocks_list+0x67>
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc6:	89 45 10             	mov    %eax,0x10(%ebp)
  802fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	75 bd                	jne    802f8d <print_blocks_list+0x2e>
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	75 b7                	jne    802f8d <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802fd6:	83 ec 0c             	sub    $0xc,%esp
  802fd9:	68 84 4c 80 00       	push   $0x804c84
  802fde:	e8 96 e6 ff ff       	call   801679 <cprintf>
  802fe3:	83 c4 10             	add    $0x10,%esp

}
  802fe6:	90                   	nop
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
  802fec:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802fef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff3:	0f 84 a1 00 00 00    	je     80309a <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802ff9:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  803000:	00 00 00 
	LIST_INIT(&list);
  803003:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  80300a:	00 00 00 
  80300d:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  803014:	00 00 00 
  803017:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  80301e:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 55 0c             	mov    0xc(%ebp),%edx
  803034:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  803036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303a:	75 14                	jne    803050 <initialize_dynamic_allocator+0x67>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 e0 4c 80 00       	push   $0x804ce0
  803044:	6a 64                	push   $0x64
  803046:	68 03 4d 80 00       	push   $0x804d03
  80304b:	e8 6c e3 ff ff       	call   8013bc <_panic>
  803050:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	89 50 0c             	mov    %edx,0xc(%eax)
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 0d                	je     803073 <initialize_dynamic_allocator+0x8a>
  803066:	a1 44 51 90 00       	mov    0x905144,%eax
  80306b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306e:	89 50 08             	mov    %edx,0x8(%eax)
  803071:	eb 08                	jmp    80307b <initialize_dynamic_allocator+0x92>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	a3 40 51 90 00       	mov    %eax,0x905140
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	a3 44 51 90 00       	mov    %eax,0x905144
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80308d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803092:	40                   	inc    %eax
  803093:	a3 4c 51 90 00       	mov    %eax,0x90514c
  803098:	eb 01                	jmp    80309b <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  80309a:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  80309b:	c9                   	leave  
  80309c:	c3                   	ret    

0080309d <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80309d:	55                   	push   %ebp
  80309e:	89 e5                	mov    %esp,%ebp
  8030a0:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8030a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a7:	75 0a                	jne    8030b3 <alloc_block_FF+0x16>
	{
		return NULL;
  8030a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ae:	e9 1c 03 00 00       	jmp    8033cf <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8030b3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	75 40                	jne    8030fc <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	83 c0 10             	add    $0x10,%eax
  8030c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	83 ec 0c             	sub    $0xc,%esp
  8030cb:	50                   	push   %eax
  8030cc:	e8 bb f3 ff ff       	call   80248c <sbrk>
  8030d1:	83 c4 10             	add    $0x10,%esp
  8030d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8030d7:	83 ec 0c             	sub    $0xc,%esp
  8030da:	6a 00                	push   $0x0
  8030dc:	e8 ab f3 ff ff       	call   80248c <sbrk>
  8030e1:	83 c4 10             	add    $0x10,%esp
  8030e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8030e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ea:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8030ed:	83 ec 08             	sub    $0x8,%esp
  8030f0:	50                   	push   %eax
  8030f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8030f4:	e8 f0 fe ff ff       	call   802fe9 <initialize_dynamic_allocator>
  8030f9:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8030fc:	a1 40 51 90 00       	mov    0x905140,%eax
  803101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803104:	e9 1e 01 00 00       	jmp    803227 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	8d 50 10             	lea    0x10(%eax),%edx
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	39 c2                	cmp    %eax,%edx
  803116:	75 1c                	jne    803134 <alloc_block_FF+0x97>
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8a 40 04             	mov    0x4(%eax),%al
  80311e:	3c 01                	cmp    $0x1,%al
  803120:	75 12                	jne    803134 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	83 c0 10             	add    $0x10,%eax
  80312f:	e9 9b 02 00 00       	jmp    8033cf <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8d 50 10             	lea    0x10(%eax),%edx
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 00                	mov    (%eax),%eax
  80313f:	39 c2                	cmp    %eax,%edx
  803141:	0f 83 d8 00 00 00    	jae    80321f <alloc_block_FF+0x182>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8a 40 04             	mov    0x4(%eax),%al
  80314d:	3c 01                	cmp    $0x1,%al
  80314f:	0f 85 ca 00 00 00    	jne    80321f <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	2b 45 08             	sub    0x8(%ebp),%eax
  80315d:	83 e8 10             	sub    $0x10,%eax
  803160:	83 f8 0f             	cmp    $0xf,%eax
  803163:	0f 86 a4 00 00 00    	jbe    80320d <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  803169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	01 d0                	add    %edx,%eax
  803171:	83 c0 10             	add    $0x10,%eax
  803174:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	2b 45 08             	sub    0x8(%ebp),%eax
  80317f:	8d 50 f0             	lea    -0x10(%eax),%edx
  803182:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803185:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  803187:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80318a:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80318e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803192:	74 06                	je     80319a <alloc_block_FF+0xfd>
  803194:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803198:	75 17                	jne    8031b1 <alloc_block_FF+0x114>
  80319a:	83 ec 04             	sub    $0x4,%esp
  80319d:	68 1c 4d 80 00       	push   $0x804d1c
  8031a2:	68 8f 00 00 00       	push   $0x8f
  8031a7:	68 03 4d 80 00       	push   $0x804d03
  8031ac:	e8 0b e2 ff ff       	call   8013bc <_panic>
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	8b 50 08             	mov    0x8(%eax),%edx
  8031b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031ba:	89 50 08             	mov    %edx,0x8(%eax)
  8031bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c0:	8b 40 08             	mov    0x8(%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 0c                	je     8031d3 <alloc_block_FF+0x136>
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 40 08             	mov    0x8(%eax),%eax
  8031cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031d9:	89 50 08             	mov    %edx,0x8(%eax)
  8031dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e2:	89 50 0c             	mov    %edx,0xc(%eax)
  8031e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	75 08                	jne    8031f7 <alloc_block_FF+0x15a>
  8031ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031f2:	a3 44 51 90 00       	mov    %eax,0x905144
  8031f7:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8031fc:	40                   	inc    %eax
  8031fd:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8d 50 10             	lea    0x10(%eax),%edx
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	83 c0 10             	add    $0x10,%eax
  80321a:	e9 b0 01 00 00       	jmp    8033cf <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  80321f:	a1 48 51 90 00       	mov    0x905148,%eax
  803224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322b:	74 08                	je     803235 <alloc_block_FF+0x198>
  80322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803230:	8b 40 08             	mov    0x8(%eax),%eax
  803233:	eb 05                	jmp    80323a <alloc_block_FF+0x19d>
  803235:	b8 00 00 00 00       	mov    $0x0,%eax
  80323a:	a3 48 51 90 00       	mov    %eax,0x905148
  80323f:	a1 48 51 90 00       	mov    0x905148,%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	0f 85 bd fe ff ff    	jne    803109 <alloc_block_FF+0x6c>
  80324c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803250:	0f 85 b3 fe ff ff    	jne    803109 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	83 c0 10             	add    $0x10,%eax
  80325c:	83 ec 0c             	sub    $0xc,%esp
  80325f:	50                   	push   %eax
  803260:	e8 27 f2 ff ff       	call   80248c <sbrk>
  803265:	83 c4 10             	add    $0x10,%esp
  803268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  80326b:	83 ec 0c             	sub    $0xc,%esp
  80326e:	6a 00                	push   $0x0
  803270:	e8 17 f2 ff ff       	call   80248c <sbrk>
  803275:	83 c4 10             	add    $0x10,%esp
  803278:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  80327b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80327e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803281:	29 c2                	sub    %eax,%edx
  803283:	89 d0                	mov    %edx,%eax
  803285:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  803288:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80328c:	0f 84 38 01 00 00    	je     8033ca <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  803292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803295:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  803298:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80329c:	75 17                	jne    8032b5 <alloc_block_FF+0x218>
  80329e:	83 ec 04             	sub    $0x4,%esp
  8032a1:	68 e0 4c 80 00       	push   $0x804ce0
  8032a6:	68 9f 00 00 00       	push   $0x9f
  8032ab:	68 03 4d 80 00       	push   $0x804d03
  8032b0:	e8 07 e1 ff ff       	call   8013bc <_panic>
  8032b5:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8032bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032be:	89 50 0c             	mov    %edx,0xc(%eax)
  8032c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 0d                	je     8032d8 <alloc_block_FF+0x23b>
  8032cb:	a1 44 51 90 00       	mov    0x905144,%eax
  8032d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032d3:	89 50 08             	mov    %edx,0x8(%eax)
  8032d6:	eb 08                	jmp    8032e0 <alloc_block_FF+0x243>
  8032d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032db:	a3 40 51 90 00       	mov    %eax,0x905140
  8032e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e3:	a3 44 51 90 00       	mov    %eax,0x905144
  8032e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032f2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8032f7:	40                   	inc    %eax
  8032f8:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8d 50 10             	lea    0x10(%eax),%edx
  803303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803306:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  803308:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  80330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803312:	2b 45 08             	sub    0x8(%ebp),%eax
  803315:	83 f8 10             	cmp    $0x10,%eax
  803318:	0f 84 a4 00 00 00    	je     8033c2 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  80331e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803321:	2b 45 08             	sub    0x8(%ebp),%eax
  803324:	83 e8 10             	sub    $0x10,%eax
  803327:	83 f8 0f             	cmp    $0xf,%eax
  80332a:	0f 86 8a 00 00 00    	jbe    8033ba <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  803330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	01 d0                	add    %edx,%eax
  803338:	83 c0 10             	add    $0x10,%eax
  80333b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  80333e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803342:	75 17                	jne    80335b <alloc_block_FF+0x2be>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 e0 4c 80 00       	push   $0x804ce0
  80334c:	68 a7 00 00 00       	push   $0xa7
  803351:	68 03 4d 80 00       	push   $0x804d03
  803356:	e8 61 e0 ff ff       	call   8013bc <_panic>
  80335b:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803361:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803364:	89 50 0c             	mov    %edx,0xc(%eax)
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0d                	je     80337e <alloc_block_FF+0x2e1>
  803371:	a1 44 51 90 00       	mov    0x905144,%eax
  803376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803379:	89 50 08             	mov    %edx,0x8(%eax)
  80337c:	eb 08                	jmp    803386 <alloc_block_FF+0x2e9>
  80337e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803381:	a3 40 51 90 00       	mov    %eax,0x905140
  803386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803389:	a3 44 51 90 00       	mov    %eax,0x905144
  80338e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803391:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803398:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80339d:	40                   	inc    %eax
  80339e:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8033a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8033a9:	8d 50 f0             	lea    -0x10(%eax),%edx
  8033ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033af:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8033b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8033b8:	eb 08                	jmp    8033c2 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  8033ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033c0:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  8033c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c5:	83 c0 10             	add    $0x10,%eax
  8033c8:	eb 05                	jmp    8033cf <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  8033d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  8033de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e2:	75 0a                	jne    8033ee <alloc_block_BF+0x1d>
	{
		return NULL;
  8033e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e9:	e9 40 02 00 00       	jmp    80362e <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8033ee:	a1 40 51 90 00       	mov    0x905140,%eax
  8033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f6:	eb 66                	jmp    80345e <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	8a 40 04             	mov    0x4(%eax),%al
  8033fe:	3c 01                	cmp    $0x1,%al
  803400:	75 21                	jne    803423 <alloc_block_BF+0x52>
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8d 50 10             	lea    0x10(%eax),%edx
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	39 c2                	cmp    %eax,%edx
  80340f:	75 12                	jne    803423 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	83 c0 10             	add    $0x10,%eax
  80341e:	e9 0b 02 00 00       	jmp    80362e <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8a 40 04             	mov    0x4(%eax),%al
  803429:	3c 01                	cmp    $0x1,%al
  80342b:	75 29                	jne    803456 <alloc_block_BF+0x85>
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	8d 50 10             	lea    0x10(%eax),%edx
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	39 c2                	cmp    %eax,%edx
  80343a:	77 1a                	ja     803456 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  80343c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803440:	74 0e                	je     803450 <alloc_block_BF+0x7f>
  803442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803445:	8b 10                	mov    (%eax),%edx
  803447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344a:	8b 00                	mov    (%eax),%eax
  80344c:	39 c2                	cmp    %eax,%edx
  80344e:	73 06                	jae    803456 <alloc_block_BF+0x85>
			{
				BF = iterator;
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  803456:	a1 48 51 90 00       	mov    0x905148,%eax
  80345b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	74 08                	je     80346c <alloc_block_BF+0x9b>
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 40 08             	mov    0x8(%eax),%eax
  80346a:	eb 05                	jmp    803471 <alloc_block_BF+0xa0>
  80346c:	b8 00 00 00 00       	mov    $0x0,%eax
  803471:	a3 48 51 90 00       	mov    %eax,0x905148
  803476:	a1 48 51 90 00       	mov    0x905148,%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	0f 85 75 ff ff ff    	jne    8033f8 <alloc_block_BF+0x27>
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	0f 85 6b ff ff ff    	jne    8033f8 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  80348d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803491:	0f 84 f8 00 00 00    	je     80358f <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8d 50 10             	lea    0x10(%eax),%edx
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	39 c2                	cmp    %eax,%edx
  8034a4:	0f 87 e5 00 00 00    	ja     80358f <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8034aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	2b 45 08             	sub    0x8(%ebp),%eax
  8034b2:	83 e8 10             	sub    $0x10,%eax
  8034b5:	83 f8 0f             	cmp    $0xf,%eax
  8034b8:	0f 86 bf 00 00 00    	jbe    80357d <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  8034be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	01 d0                	add    %edx,%eax
  8034c6:	83 c0 10             	add    $0x10,%eax
  8034c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  8034cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  8034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	2b 45 08             	sub    0x8(%ebp),%eax
  8034dd:	8d 50 f0             	lea    -0x10(%eax),%edx
  8034e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e3:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8034e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8034ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f0:	74 06                	je     8034f8 <alloc_block_BF+0x127>
  8034f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034f6:	75 17                	jne    80350f <alloc_block_BF+0x13e>
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	68 1c 4d 80 00       	push   $0x804d1c
  803500:	68 e3 00 00 00       	push   $0xe3
  803505:	68 03 4d 80 00       	push   $0x804d03
  80350a:	e8 ad de ff ff       	call   8013bc <_panic>
  80350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803512:	8b 50 08             	mov    0x8(%eax),%edx
  803515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803518:	89 50 08             	mov    %edx,0x8(%eax)
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 40 08             	mov    0x8(%eax),%eax
  803521:	85 c0                	test   %eax,%eax
  803523:	74 0c                	je     803531 <alloc_block_BF+0x160>
  803525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803528:	8b 40 08             	mov    0x8(%eax),%eax
  80352b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80352e:	89 50 0c             	mov    %edx,0xc(%eax)
  803531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803534:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803537:	89 50 08             	mov    %edx,0x8(%eax)
  80353a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803540:	89 50 0c             	mov    %edx,0xc(%eax)
  803543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803546:	8b 40 08             	mov    0x8(%eax),%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	75 08                	jne    803555 <alloc_block_BF+0x184>
  80354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803550:	a3 44 51 90 00       	mov    %eax,0x905144
  803555:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80355a:	40                   	inc    %eax
  80355b:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	8d 50 10             	lea    0x10(%eax),%edx
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  803572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803575:	83 c0 10             	add    $0x10,%eax
  803578:	e9 b1 00 00 00       	jmp    80362e <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  803584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803587:	83 c0 10             	add    $0x10,%eax
  80358a:	e9 9f 00 00 00       	jmp    80362e <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	83 c0 10             	add    $0x10,%eax
  803595:	83 ec 0c             	sub    $0xc,%esp
  803598:	50                   	push   %eax
  803599:	e8 ee ee ff ff       	call   80248c <sbrk>
  80359e:	83 c4 10             	add    $0x10,%esp
  8035a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8035a4:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8035a8:	74 7f                	je     803629 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8035aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ae:	75 17                	jne    8035c7 <alloc_block_BF+0x1f6>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 e0 4c 80 00       	push   $0x804ce0
  8035b8:	68 f6 00 00 00       	push   $0xf6
  8035bd:	68 03 4d 80 00       	push   $0x804d03
  8035c2:	e8 f5 dd ff ff       	call   8013bc <_panic>
  8035c7:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8035cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8035d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	74 0d                	je     8035ea <alloc_block_BF+0x219>
  8035dd:	a1 44 51 90 00       	mov    0x905144,%eax
  8035e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e5:	89 50 08             	mov    %edx,0x8(%eax)
  8035e8:	eb 08                	jmp    8035f2 <alloc_block_BF+0x221>
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	a3 40 51 90 00       	mov    %eax,0x905140
  8035f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f5:	a3 44 51 90 00       	mov    %eax,0x905144
  8035fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803604:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803609:	40                   	inc    %eax
  80360a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	8d 50 10             	lea    0x10(%eax),%edx
  803615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803618:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  80361a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  803621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803624:	83 c0 10             	add    $0x10,%eax
  803627:	eb 05                	jmp    80362e <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  803629:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  80362e:	c9                   	leave  
  80362f:	c3                   	ret    

00803630 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  803630:	55                   	push   %ebp
  803631:	89 e5                	mov    %esp,%ebp
  803633:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803636:	83 ec 04             	sub    $0x4,%esp
  803639:	68 50 4d 80 00       	push   $0x804d50
  80363e:	68 07 01 00 00       	push   $0x107
  803643:	68 03 4d 80 00       	push   $0x804d03
  803648:	e8 6f dd ff ff       	call   8013bc <_panic>

0080364d <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80364d:	55                   	push   %ebp
  80364e:	89 e5                	mov    %esp,%ebp
  803650:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803653:	83 ec 04             	sub    $0x4,%esp
  803656:	68 78 4d 80 00       	push   $0x804d78
  80365b:	68 0f 01 00 00       	push   $0x10f
  803660:	68 03 4d 80 00       	push   $0x804d03
  803665:	e8 52 dd ff ff       	call   8013bc <_panic>

0080366a <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80366a:	55                   	push   %ebp
  80366b:	89 e5                	mov    %esp,%ebp
  80366d:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  803670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803674:	0f 84 ee 05 00 00    	je     803c68 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	83 e8 10             	sub    $0x10,%eax
  803680:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  803683:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803687:	a1 40 51 90 00       	mov    0x905140,%eax
  80368c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80368f:	eb 16                	jmp    8036a7 <free_block+0x3d>
	{
		if (block_pointer == it)
  803691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803694:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803697:	75 06                	jne    80369f <free_block+0x35>
		{
			flagx = 1;
  803699:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  80369d:	eb 2f                	jmp    8036ce <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80369f:	a1 48 51 90 00       	mov    0x905148,%eax
  8036a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8036a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ab:	74 08                	je     8036b5 <free_block+0x4b>
  8036ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b0:	8b 40 08             	mov    0x8(%eax),%eax
  8036b3:	eb 05                	jmp    8036ba <free_block+0x50>
  8036b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ba:	a3 48 51 90 00       	mov    %eax,0x905148
  8036bf:	a1 48 51 90 00       	mov    0x905148,%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	75 c9                	jne    803691 <free_block+0x27>
  8036c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036cc:	75 c3                	jne    803691 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  8036ce:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8036d2:	0f 84 93 05 00 00    	je     803c6b <free_block+0x601>
		return;
	if (va == NULL)
  8036d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036dc:	0f 84 8c 05 00 00    	je     803c6e <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8036e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8036eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ee:	8b 40 08             	mov    0x8(%eax),%eax
  8036f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8036f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036f8:	75 12                	jne    80370c <free_block+0xa2>
  8036fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036fe:	75 0c                	jne    80370c <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  803700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803703:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803707:	e9 63 05 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  80370c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803710:	0f 85 ca 00 00 00    	jne    8037e0 <free_block+0x176>
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	8a 40 04             	mov    0x4(%eax),%al
  80371c:	3c 01                	cmp    $0x1,%al
  80371e:	0f 85 bc 00 00 00    	jne    8037e0 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  803724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803727:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80372b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372e:	8b 10                	mov    (%eax),%edx
  803730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803733:	8b 00                	mov    (%eax),%eax
  803735:	01 c2                	add    %eax,%edx
  803737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373a:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80373c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803748:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80374c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803750:	75 17                	jne    803769 <free_block+0xff>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 9e 4d 80 00       	push   $0x804d9e
  80375a:	68 3c 01 00 00       	push   $0x13c
  80375f:	68 03 4d 80 00       	push   $0x804d03
  803764:	e8 53 dc ff ff       	call   8013bc <_panic>
  803769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376c:	8b 40 08             	mov    0x8(%eax),%eax
  80376f:	85 c0                	test   %eax,%eax
  803771:	74 11                	je     803784 <free_block+0x11a>
  803773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803776:	8b 40 08             	mov    0x8(%eax),%eax
  803779:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377c:	8b 52 0c             	mov    0xc(%edx),%edx
  80377f:	89 50 0c             	mov    %edx,0xc(%eax)
  803782:	eb 0b                	jmp    80378f <free_block+0x125>
  803784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803787:	8b 40 0c             	mov    0xc(%eax),%eax
  80378a:	a3 44 51 90 00       	mov    %eax,0x905144
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 40 0c             	mov    0xc(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 11                	je     8037aa <free_block+0x140>
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a2:	8b 52 08             	mov    0x8(%edx),%edx
  8037a5:	89 50 08             	mov    %edx,0x8(%eax)
  8037a8:	eb 0b                	jmp    8037b5 <free_block+0x14b>
  8037aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ad:	8b 40 08             	mov    0x8(%eax),%eax
  8037b0:	a3 40 51 90 00       	mov    %eax,0x905140
  8037b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8037c9:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8037ce:	48                   	dec    %eax
  8037cf:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  8037d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8037db:	e9 8f 04 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8037e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037e4:	75 16                	jne    8037fc <free_block+0x192>
  8037e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e9:	8a 40 04             	mov    0x4(%eax),%al
  8037ec:	84 c0                	test   %al,%al
  8037ee:	75 0c                	jne    8037fc <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8037f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8037f7:	e9 73 04 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8037fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803800:	0f 85 c3 00 00 00    	jne    8038c9 <free_block+0x25f>
  803806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803809:	8a 40 04             	mov    0x4(%eax),%al
  80380c:	3c 01                	cmp    $0x1,%al
  80380e:	0f 85 b5 00 00 00    	jne    8038c9 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  803814:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803817:	8b 10                	mov    (%eax),%edx
  803819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	01 c2                	add    %eax,%edx
  803820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803823:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803828:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80382e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803831:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803835:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803839:	75 17                	jne    803852 <free_block+0x1e8>
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 9e 4d 80 00       	push   $0x804d9e
  803843:	68 49 01 00 00       	push   $0x149
  803848:	68 03 4d 80 00       	push   $0x804d03
  80384d:	e8 6a db ff ff       	call   8013bc <_panic>
  803852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803855:	8b 40 08             	mov    0x8(%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 11                	je     80386d <free_block+0x203>
  80385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385f:	8b 40 08             	mov    0x8(%eax),%eax
  803862:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803865:	8b 52 0c             	mov    0xc(%edx),%edx
  803868:	89 50 0c             	mov    %edx,0xc(%eax)
  80386b:	eb 0b                	jmp    803878 <free_block+0x20e>
  80386d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803870:	8b 40 0c             	mov    0xc(%eax),%eax
  803873:	a3 44 51 90 00       	mov    %eax,0x905144
  803878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80387b:	8b 40 0c             	mov    0xc(%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 11                	je     803893 <free_block+0x229>
  803882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803885:	8b 40 0c             	mov    0xc(%eax),%eax
  803888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388b:	8b 52 08             	mov    0x8(%edx),%edx
  80388e:	89 50 08             	mov    %edx,0x8(%eax)
  803891:	eb 0b                	jmp    80389e <free_block+0x234>
  803893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803896:	8b 40 08             	mov    0x8(%eax),%eax
  803899:	a3 40 51 90 00       	mov    %eax,0x905140
  80389e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8038a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8038b2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8038b7:	48                   	dec    %eax
  8038b8:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  8038bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8038c4:	e9 a6 03 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  8038c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038cd:	75 16                	jne    8038e5 <free_block+0x27b>
  8038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d2:	8a 40 04             	mov    0x4(%eax),%al
  8038d5:	84 c0                	test   %al,%al
  8038d7:	75 0c                	jne    8038e5 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  8038d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038dc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8038e0:	e9 8a 03 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8038e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e9:	0f 84 81 01 00 00    	je     803a70 <free_block+0x406>
  8038ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038f3:	0f 84 77 01 00 00    	je     803a70 <free_block+0x406>
  8038f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fc:	8a 40 04             	mov    0x4(%eax),%al
  8038ff:	3c 01                	cmp    $0x1,%al
  803901:	0f 85 69 01 00 00    	jne    803a70 <free_block+0x406>
  803907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390a:	8a 40 04             	mov    0x4(%eax),%al
  80390d:	3c 01                	cmp    $0x1,%al
  80390f:	0f 85 5b 01 00 00    	jne    803a70 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  803915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803918:	8b 10                	mov    (%eax),%edx
  80391a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391d:	8b 08                	mov    (%eax),%ecx
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	01 c8                	add    %ecx,%eax
  803926:	01 c2                	add    %eax,%edx
  803928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392b:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803939:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80393d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803949:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80394d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803951:	75 17                	jne    80396a <free_block+0x300>
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	68 9e 4d 80 00       	push   $0x804d9e
  80395b:	68 59 01 00 00       	push   $0x159
  803960:	68 03 4d 80 00       	push   $0x804d03
  803965:	e8 52 da ff ff       	call   8013bc <_panic>
  80396a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396d:	8b 40 08             	mov    0x8(%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 11                	je     803985 <free_block+0x31b>
  803974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803977:	8b 40 08             	mov    0x8(%eax),%eax
  80397a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80397d:	8b 52 0c             	mov    0xc(%edx),%edx
  803980:	89 50 0c             	mov    %edx,0xc(%eax)
  803983:	eb 0b                	jmp    803990 <free_block+0x326>
  803985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803988:	8b 40 0c             	mov    0xc(%eax),%eax
  80398b:	a3 44 51 90 00       	mov    %eax,0x905144
  803990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803993:	8b 40 0c             	mov    0xc(%eax),%eax
  803996:	85 c0                	test   %eax,%eax
  803998:	74 11                	je     8039ab <free_block+0x341>
  80399a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399d:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039a3:	8b 52 08             	mov    0x8(%edx),%edx
  8039a6:	89 50 08             	mov    %edx,0x8(%eax)
  8039a9:	eb 0b                	jmp    8039b6 <free_block+0x34c>
  8039ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ae:	8b 40 08             	mov    0x8(%eax),%eax
  8039b1:	a3 40 51 90 00       	mov    %eax,0x905140
  8039b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8039ca:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8039cf:	48                   	dec    %eax
  8039d0:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8039d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d9:	75 17                	jne    8039f2 <free_block+0x388>
  8039db:	83 ec 04             	sub    $0x4,%esp
  8039de:	68 9e 4d 80 00       	push   $0x804d9e
  8039e3:	68 5a 01 00 00       	push   $0x15a
  8039e8:	68 03 4d 80 00       	push   $0x804d03
  8039ed:	e8 ca d9 ff ff       	call   8013bc <_panic>
  8039f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f5:	8b 40 08             	mov    0x8(%eax),%eax
  8039f8:	85 c0                	test   %eax,%eax
  8039fa:	74 11                	je     803a0d <free_block+0x3a3>
  8039fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ff:	8b 40 08             	mov    0x8(%eax),%eax
  803a02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a05:	8b 52 0c             	mov    0xc(%edx),%edx
  803a08:	89 50 0c             	mov    %edx,0xc(%eax)
  803a0b:	eb 0b                	jmp    803a18 <free_block+0x3ae>
  803a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a10:	8b 40 0c             	mov    0xc(%eax),%eax
  803a13:	a3 44 51 90 00       	mov    %eax,0x905144
  803a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1e:	85 c0                	test   %eax,%eax
  803a20:	74 11                	je     803a33 <free_block+0x3c9>
  803a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a25:	8b 40 0c             	mov    0xc(%eax),%eax
  803a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2b:	8b 52 08             	mov    0x8(%edx),%edx
  803a2e:	89 50 08             	mov    %edx,0x8(%eax)
  803a31:	eb 0b                	jmp    803a3e <free_block+0x3d4>
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	8b 40 08             	mov    0x8(%eax),%eax
  803a39:	a3 40 51 90 00       	mov    %eax,0x905140
  803a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803a52:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803a57:	48                   	dec    %eax
  803a58:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803a5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  803a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803a6b:	e9 ff 01 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803a70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a74:	0f 84 db 00 00 00    	je     803b55 <free_block+0x4eb>
  803a7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a7e:	0f 84 d1 00 00 00    	je     803b55 <free_block+0x4eb>
  803a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a87:	8a 40 04             	mov    0x4(%eax),%al
  803a8a:	84 c0                	test   %al,%al
  803a8c:	0f 85 c3 00 00 00    	jne    803b55 <free_block+0x4eb>
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	8a 40 04             	mov    0x4(%eax),%al
  803a98:	3c 01                	cmp    $0x1,%al
  803a9a:	0f 85 b5 00 00 00    	jne    803b55 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa3:	8b 10                	mov    (%eax),%edx
  803aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa8:	8b 00                	mov    (%eax),%eax
  803aaa:	01 c2                	add    %eax,%edx
  803aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aaf:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abd:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803ac1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ac5:	75 17                	jne    803ade <free_block+0x474>
  803ac7:	83 ec 04             	sub    $0x4,%esp
  803aca:	68 9e 4d 80 00       	push   $0x804d9e
  803acf:	68 64 01 00 00       	push   $0x164
  803ad4:	68 03 4d 80 00       	push   $0x804d03
  803ad9:	e8 de d8 ff ff       	call   8013bc <_panic>
  803ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae1:	8b 40 08             	mov    0x8(%eax),%eax
  803ae4:	85 c0                	test   %eax,%eax
  803ae6:	74 11                	je     803af9 <free_block+0x48f>
  803ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aeb:	8b 40 08             	mov    0x8(%eax),%eax
  803aee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803af1:	8b 52 0c             	mov    0xc(%edx),%edx
  803af4:	89 50 0c             	mov    %edx,0xc(%eax)
  803af7:	eb 0b                	jmp    803b04 <free_block+0x49a>
  803af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afc:	8b 40 0c             	mov    0xc(%eax),%eax
  803aff:	a3 44 51 90 00       	mov    %eax,0x905144
  803b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b07:	8b 40 0c             	mov    0xc(%eax),%eax
  803b0a:	85 c0                	test   %eax,%eax
  803b0c:	74 11                	je     803b1f <free_block+0x4b5>
  803b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b11:	8b 40 0c             	mov    0xc(%eax),%eax
  803b14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b17:	8b 52 08             	mov    0x8(%edx),%edx
  803b1a:	89 50 08             	mov    %edx,0x8(%eax)
  803b1d:	eb 0b                	jmp    803b2a <free_block+0x4c0>
  803b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b22:	8b 40 08             	mov    0x8(%eax),%eax
  803b25:	a3 40 51 90 00       	mov    %eax,0x905140
  803b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803b3e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803b43:	48                   	dec    %eax
  803b44:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803b49:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803b50:	e9 1a 01 00 00       	jmp    803c6f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803b55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b59:	0f 84 df 00 00 00    	je     803c3e <free_block+0x5d4>
  803b5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b63:	0f 84 d5 00 00 00    	je     803c3e <free_block+0x5d4>
  803b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6c:	8a 40 04             	mov    0x4(%eax),%al
  803b6f:	3c 01                	cmp    $0x1,%al
  803b71:	0f 85 c7 00 00 00    	jne    803c3e <free_block+0x5d4>
  803b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7a:	8a 40 04             	mov    0x4(%eax),%al
  803b7d:	84 c0                	test   %al,%al
  803b7f:	0f 85 b9 00 00 00    	jne    803c3e <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  803b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b88:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b8f:	8b 10                	mov    (%eax),%edx
  803b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b94:	8b 00                	mov    (%eax),%eax
  803b96:	01 c2                	add    %eax,%edx
  803b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9b:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803bad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb1:	75 17                	jne    803bca <free_block+0x560>
  803bb3:	83 ec 04             	sub    $0x4,%esp
  803bb6:	68 9e 4d 80 00       	push   $0x804d9e
  803bbb:	68 6e 01 00 00       	push   $0x16e
  803bc0:	68 03 4d 80 00       	push   $0x804d03
  803bc5:	e8 f2 d7 ff ff       	call   8013bc <_panic>
  803bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcd:	8b 40 08             	mov    0x8(%eax),%eax
  803bd0:	85 c0                	test   %eax,%eax
  803bd2:	74 11                	je     803be5 <free_block+0x57b>
  803bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd7:	8b 40 08             	mov    0x8(%eax),%eax
  803bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bdd:	8b 52 0c             	mov    0xc(%edx),%edx
  803be0:	89 50 0c             	mov    %edx,0xc(%eax)
  803be3:	eb 0b                	jmp    803bf0 <free_block+0x586>
  803be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be8:	8b 40 0c             	mov    0xc(%eax),%eax
  803beb:	a3 44 51 90 00       	mov    %eax,0x905144
  803bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf3:	8b 40 0c             	mov    0xc(%eax),%eax
  803bf6:	85 c0                	test   %eax,%eax
  803bf8:	74 11                	je     803c0b <free_block+0x5a1>
  803bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  803c00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c03:	8b 52 08             	mov    0x8(%edx),%edx
  803c06:	89 50 08             	mov    %edx,0x8(%eax)
  803c09:	eb 0b                	jmp    803c16 <free_block+0x5ac>
  803c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0e:	8b 40 08             	mov    0x8(%eax),%eax
  803c11:	a3 40 51 90 00       	mov    %eax,0x905140
  803c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803c2a:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803c2f:	48                   	dec    %eax
  803c30:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803c35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803c3c:	eb 31                	jmp    803c6f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803c3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c42:	74 2b                	je     803c6f <free_block+0x605>
  803c44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c48:	74 25                	je     803c6f <free_block+0x605>
  803c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4d:	8a 40 04             	mov    0x4(%eax),%al
  803c50:	84 c0                	test   %al,%al
  803c52:	75 1b                	jne    803c6f <free_block+0x605>
  803c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c57:	8a 40 04             	mov    0x4(%eax),%al
  803c5a:	84 c0                	test   %al,%al
  803c5c:	75 11                	jne    803c6f <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c61:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803c65:	90                   	nop
  803c66:	eb 07                	jmp    803c6f <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803c68:	90                   	nop
  803c69:	eb 04                	jmp    803c6f <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803c6b:	90                   	nop
  803c6c:	eb 01                	jmp    803c6f <free_block+0x605>
	if (va == NULL)
		return;
  803c6e:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803c6f:	c9                   	leave  
  803c70:	c3                   	ret    

00803c71 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803c71:	55                   	push   %ebp
  803c72:	89 e5                	mov    %esp,%ebp
  803c74:	57                   	push   %edi
  803c75:	56                   	push   %esi
  803c76:	53                   	push   %ebx
  803c77:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803c7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c7e:	75 19                	jne    803c99 <realloc_block_FF+0x28>
  803c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c84:	74 13                	je     803c99 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  803c86:	83 ec 0c             	sub    $0xc,%esp
  803c89:	ff 75 0c             	pushl  0xc(%ebp)
  803c8c:	e8 0c f4 ff ff       	call   80309d <alloc_block_FF>
  803c91:	83 c4 10             	add    $0x10,%esp
  803c94:	e9 84 03 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  803c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c9d:	75 3b                	jne    803cda <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  803c9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ca3:	75 17                	jne    803cbc <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  803ca5:	83 ec 0c             	sub    $0xc,%esp
  803ca8:	6a 00                	push   $0x0
  803caa:	e8 ee f3 ff ff       	call   80309d <alloc_block_FF>
  803caf:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb7:	e9 61 03 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  803cbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cc0:	74 18                	je     803cda <realloc_block_FF+0x69>
		{
			free_block(va);
  803cc2:	83 ec 0c             	sub    $0xc,%esp
  803cc5:	ff 75 08             	pushl  0x8(%ebp)
  803cc8:	e8 9d f9 ff ff       	call   80366a <free_block>
  803ccd:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd5:	e9 43 03 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803cda:	a1 40 51 90 00       	mov    0x905140,%eax
  803cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803ce2:	e9 02 03 00 00       	jmp    803fe9 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cea:	83 e8 10             	sub    $0x10,%eax
  803ced:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cf0:	0f 85 eb 02 00 00    	jne    803fe1 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf9:	8b 00                	mov    (%eax),%eax
  803cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cfe:	83 c2 10             	add    $0x10,%edx
  803d01:	39 d0                	cmp    %edx,%eax
  803d03:	75 08                	jne    803d0d <realloc_block_FF+0x9c>
			{
				return va;
  803d05:	8b 45 08             	mov    0x8(%ebp),%eax
  803d08:	e9 10 03 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  803d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d15:	0f 83 e0 01 00 00    	jae    803efb <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1e:	8b 40 08             	mov    0x8(%eax),%eax
  803d21:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  803d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d27:	8a 40 04             	mov    0x4(%eax),%al
  803d2a:	3c 01                	cmp    $0x1,%al
  803d2c:	0f 85 06 01 00 00    	jne    803e38 <realloc_block_FF+0x1c7>
  803d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d35:	8b 10                	mov    (%eax),%edx
  803d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3a:	8b 00                	mov    (%eax),%eax
  803d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803d3f:	29 c1                	sub    %eax,%ecx
  803d41:	89 c8                	mov    %ecx,%eax
  803d43:	39 c2                	cmp    %eax,%edx
  803d45:	0f 86 ed 00 00 00    	jbe    803e38 <realloc_block_FF+0x1c7>
  803d4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d4f:	0f 84 e3 00 00 00    	je     803e38 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  803d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d58:	8b 10                	mov    (%eax),%edx
  803d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5d:	8b 00                	mov    (%eax),%eax
  803d5f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803d62:	01 d0                	add    %edx,%eax
  803d64:	83 f8 0f             	cmp    $0xf,%eax
  803d67:	0f 86 b5 00 00 00    	jbe    803e22 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803d6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d73:	01 d0                	add    %edx,%eax
  803d75:	83 c0 10             	add    $0x10,%eax
  803d78:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803d7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  803d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d87:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803d8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d8f:	74 06                	je     803d97 <realloc_block_FF+0x126>
  803d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d95:	75 17                	jne    803dae <realloc_block_FF+0x13d>
  803d97:	83 ec 04             	sub    $0x4,%esp
  803d9a:	68 1c 4d 80 00       	push   $0x804d1c
  803d9f:	68 ad 01 00 00       	push   $0x1ad
  803da4:	68 03 4d 80 00       	push   $0x804d03
  803da9:	e8 0e d6 ff ff       	call   8013bc <_panic>
  803dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db1:	8b 50 08             	mov    0x8(%eax),%edx
  803db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db7:	89 50 08             	mov    %edx,0x8(%eax)
  803dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dbd:	8b 40 08             	mov    0x8(%eax),%eax
  803dc0:	85 c0                	test   %eax,%eax
  803dc2:	74 0c                	je     803dd0 <realloc_block_FF+0x15f>
  803dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc7:	8b 40 08             	mov    0x8(%eax),%eax
  803dca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dcd:	89 50 0c             	mov    %edx,0xc(%eax)
  803dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dd6:	89 50 08             	mov    %edx,0x8(%eax)
  803dd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ddf:	89 50 0c             	mov    %edx,0xc(%eax)
  803de2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de5:	8b 40 08             	mov    0x8(%eax),%eax
  803de8:	85 c0                	test   %eax,%eax
  803dea:	75 08                	jne    803df4 <realloc_block_FF+0x183>
  803dec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803def:	a3 44 51 90 00       	mov    %eax,0x905144
  803df4:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803df9:	40                   	inc    %eax
  803dfa:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  803dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  803e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e0b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  803e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e12:	8d 50 10             	lea    0x10(%eax),%edx
  803e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e18:	89 10                	mov    %edx,(%eax)
						return va;
  803e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1d:	e9 fb 01 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  803e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e25:	8d 50 10             	lea    0x10(%eax),%edx
  803e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2b:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  803e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e30:	83 c0 10             	add    $0x10,%eax
  803e33:	e9 e5 01 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3b:	8a 40 04             	mov    0x4(%eax),%al
  803e3e:	3c 01                	cmp    $0x1,%al
  803e40:	75 59                	jne    803e9b <realloc_block_FF+0x22a>
  803e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e45:	8b 10                	mov    (%eax),%edx
  803e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4a:	8b 00                	mov    (%eax),%eax
  803e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e4f:	29 c1                	sub    %eax,%ecx
  803e51:	89 c8                	mov    %ecx,%eax
  803e53:	39 c2                	cmp    %eax,%edx
  803e55:	75 44                	jne    803e9b <realloc_block_FF+0x22a>
  803e57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803e5b:	74 3e                	je     803e9b <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e60:	8b 40 08             	mov    0x8(%eax),%eax
  803e63:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e69:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e6c:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e75:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e84:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e8b:	8d 50 10             	lea    0x10(%eax),%edx
  803e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e91:	89 10                	mov    %edx,(%eax)
					return va;
  803e93:	8b 45 08             	mov    0x8(%ebp),%eax
  803e96:	e9 82 01 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e9e:	8a 40 04             	mov    0x4(%eax),%al
  803ea1:	84 c0                	test   %al,%al
  803ea3:	74 0a                	je     803eaf <realloc_block_FF+0x23e>
  803ea5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ea9:	0f 85 32 01 00 00    	jne    803fe1 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803eaf:	83 ec 0c             	sub    $0xc,%esp
  803eb2:	ff 75 0c             	pushl  0xc(%ebp)
  803eb5:	e8 e3 f1 ff ff       	call   80309d <alloc_block_FF>
  803eba:	83 c4 10             	add    $0x10,%esp
  803ebd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  803ec0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ec4:	74 2b                	je     803ef1 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803ec6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecc:	89 c3                	mov    %eax,%ebx
  803ece:	b8 04 00 00 00       	mov    $0x4,%eax
  803ed3:	89 d7                	mov    %edx,%edi
  803ed5:	89 de                	mov    %ebx,%esi
  803ed7:	89 c1                	mov    %eax,%ecx
  803ed9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  803edb:	83 ec 0c             	sub    $0xc,%esp
  803ede:	ff 75 08             	pushl  0x8(%ebp)
  803ee1:	e8 84 f7 ff ff       	call   80366a <free_block>
  803ee6:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803ee9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eec:	e9 2c 01 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  803ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803ef6:	e9 22 01 00 00       	jmp    80401d <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efe:	8b 00                	mov    (%eax),%eax
  803f00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f03:	0f 86 d8 00 00 00    	jbe    803fe1 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0c:	8b 00                	mov    (%eax),%eax
  803f0e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f11:	83 f8 0f             	cmp    $0xf,%eax
  803f14:	0f 86 b4 00 00 00    	jbe    803fce <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f20:	01 d0                	add    %edx,%eax
  803f22:	83 c0 10             	add    $0x10,%eax
  803f25:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2b:	8b 00                	mov    (%eax),%eax
  803f2d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f30:	8d 50 f0             	lea    -0x10(%eax),%edx
  803f33:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f36:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f3c:	74 06                	je     803f44 <realloc_block_FF+0x2d3>
  803f3e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f42:	75 17                	jne    803f5b <realloc_block_FF+0x2ea>
  803f44:	83 ec 04             	sub    $0x4,%esp
  803f47:	68 1c 4d 80 00       	push   $0x804d1c
  803f4c:	68 dd 01 00 00       	push   $0x1dd
  803f51:	68 03 4d 80 00       	push   $0x804d03
  803f56:	e8 61 d4 ff ff       	call   8013bc <_panic>
  803f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5e:	8b 50 08             	mov    0x8(%eax),%edx
  803f61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f64:	89 50 08             	mov    %edx,0x8(%eax)
  803f67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f6a:	8b 40 08             	mov    0x8(%eax),%eax
  803f6d:	85 c0                	test   %eax,%eax
  803f6f:	74 0c                	je     803f7d <realloc_block_FF+0x30c>
  803f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f74:	8b 40 08             	mov    0x8(%eax),%eax
  803f77:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f7a:	89 50 0c             	mov    %edx,0xc(%eax)
  803f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f80:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f83:	89 50 08             	mov    %edx,0x8(%eax)
  803f86:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f8c:	89 50 0c             	mov    %edx,0xc(%eax)
  803f8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f92:	8b 40 08             	mov    0x8(%eax),%eax
  803f95:	85 c0                	test   %eax,%eax
  803f97:	75 08                	jne    803fa1 <realloc_block_FF+0x330>
  803f99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f9c:	a3 44 51 90 00       	mov    %eax,0x905144
  803fa1:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803fa6:	40                   	inc    %eax
  803fa7:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803fac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803faf:	83 c0 10             	add    $0x10,%eax
  803fb2:	83 ec 0c             	sub    $0xc,%esp
  803fb5:	50                   	push   %eax
  803fb6:	e8 af f6 ff ff       	call   80366a <free_block>
  803fbb:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc1:	8d 50 10             	lea    0x10(%eax),%edx
  803fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc7:	89 10                	mov    %edx,(%eax)
					return va;
  803fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fcc:	eb 4f                	jmp    80401d <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd1:	8d 50 10             	lea    0x10(%eax),%edx
  803fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd7:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdc:	83 c0 10             	add    $0x10,%eax
  803fdf:	eb 3c                	jmp    80401d <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803fe1:	a1 48 51 90 00       	mov    0x905148,%eax
  803fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803fe9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fed:	74 08                	je     803ff7 <realloc_block_FF+0x386>
  803fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff2:	8b 40 08             	mov    0x8(%eax),%eax
  803ff5:	eb 05                	jmp    803ffc <realloc_block_FF+0x38b>
  803ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffc:	a3 48 51 90 00       	mov    %eax,0x905148
  804001:	a1 48 51 90 00       	mov    0x905148,%eax
  804006:	85 c0                	test   %eax,%eax
  804008:	0f 85 d9 fc ff ff    	jne    803ce7 <realloc_block_FF+0x76>
  80400e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804012:	0f 85 cf fc ff ff    	jne    803ce7 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  804018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80401d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  804020:	5b                   	pop    %ebx
  804021:	5e                   	pop    %esi
  804022:	5f                   	pop    %edi
  804023:	5d                   	pop    %ebp
  804024:	c3                   	ret    

00804025 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804025:	55                   	push   %ebp
  804026:	89 e5                	mov    %esp,%ebp
  804028:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80402b:	8b 55 08             	mov    0x8(%ebp),%edx
  80402e:	89 d0                	mov    %edx,%eax
  804030:	c1 e0 02             	shl    $0x2,%eax
  804033:	01 d0                	add    %edx,%eax
  804035:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80403c:	01 d0                	add    %edx,%eax
  80403e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804045:	01 d0                	add    %edx,%eax
  804047:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80404e:	01 d0                	add    %edx,%eax
  804050:	c1 e0 04             	shl    $0x4,%eax
  804053:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80405d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804060:	83 ec 0c             	sub    $0xc,%esp
  804063:	50                   	push   %eax
  804064:	e8 2f eb ff ff       	call   802b98 <sys_get_virtual_time>
  804069:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80406c:	eb 41                	jmp    8040af <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80406e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804071:	83 ec 0c             	sub    $0xc,%esp
  804074:	50                   	push   %eax
  804075:	e8 1e eb ff ff       	call   802b98 <sys_get_virtual_time>
  80407a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80407d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804083:	29 c2                	sub    %eax,%edx
  804085:	89 d0                	mov    %edx,%eax
  804087:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80408a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80408d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804090:	89 d1                	mov    %edx,%ecx
  804092:	29 c1                	sub    %eax,%ecx
  804094:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80409a:	39 c2                	cmp    %eax,%edx
  80409c:	0f 97 c0             	seta   %al
  80409f:	0f b6 c0             	movzbl %al,%eax
  8040a2:	29 c1                	sub    %eax,%ecx
  8040a4:	89 c8                	mov    %ecx,%eax
  8040a6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8040a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8040af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8040b5:	72 b7                	jb     80406e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8040b7:	90                   	nop
  8040b8:	c9                   	leave  
  8040b9:	c3                   	ret    

008040ba <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8040ba:	55                   	push   %ebp
  8040bb:	89 e5                	mov    %esp,%ebp
  8040bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8040c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8040c7:	eb 03                	jmp    8040cc <busy_wait+0x12>
  8040c9:	ff 45 fc             	incl   -0x4(%ebp)
  8040cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8040cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040d2:	72 f5                	jb     8040c9 <busy_wait+0xf>
	return i;
  8040d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8040d7:	c9                   	leave  
  8040d8:	c3                   	ret    
  8040d9:	66 90                	xchg   %ax,%ax
  8040db:	90                   	nop

008040dc <__udivdi3>:
  8040dc:	55                   	push   %ebp
  8040dd:	57                   	push   %edi
  8040de:	56                   	push   %esi
  8040df:	53                   	push   %ebx
  8040e0:	83 ec 1c             	sub    $0x1c,%esp
  8040e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040f3:	89 ca                	mov    %ecx,%edx
  8040f5:	89 f8                	mov    %edi,%eax
  8040f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040fb:	85 f6                	test   %esi,%esi
  8040fd:	75 2d                	jne    80412c <__udivdi3+0x50>
  8040ff:	39 cf                	cmp    %ecx,%edi
  804101:	77 65                	ja     804168 <__udivdi3+0x8c>
  804103:	89 fd                	mov    %edi,%ebp
  804105:	85 ff                	test   %edi,%edi
  804107:	75 0b                	jne    804114 <__udivdi3+0x38>
  804109:	b8 01 00 00 00       	mov    $0x1,%eax
  80410e:	31 d2                	xor    %edx,%edx
  804110:	f7 f7                	div    %edi
  804112:	89 c5                	mov    %eax,%ebp
  804114:	31 d2                	xor    %edx,%edx
  804116:	89 c8                	mov    %ecx,%eax
  804118:	f7 f5                	div    %ebp
  80411a:	89 c1                	mov    %eax,%ecx
  80411c:	89 d8                	mov    %ebx,%eax
  80411e:	f7 f5                	div    %ebp
  804120:	89 cf                	mov    %ecx,%edi
  804122:	89 fa                	mov    %edi,%edx
  804124:	83 c4 1c             	add    $0x1c,%esp
  804127:	5b                   	pop    %ebx
  804128:	5e                   	pop    %esi
  804129:	5f                   	pop    %edi
  80412a:	5d                   	pop    %ebp
  80412b:	c3                   	ret    
  80412c:	39 ce                	cmp    %ecx,%esi
  80412e:	77 28                	ja     804158 <__udivdi3+0x7c>
  804130:	0f bd fe             	bsr    %esi,%edi
  804133:	83 f7 1f             	xor    $0x1f,%edi
  804136:	75 40                	jne    804178 <__udivdi3+0x9c>
  804138:	39 ce                	cmp    %ecx,%esi
  80413a:	72 0a                	jb     804146 <__udivdi3+0x6a>
  80413c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804140:	0f 87 9e 00 00 00    	ja     8041e4 <__udivdi3+0x108>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	89 fa                	mov    %edi,%edx
  80414d:	83 c4 1c             	add    $0x1c,%esp
  804150:	5b                   	pop    %ebx
  804151:	5e                   	pop    %esi
  804152:	5f                   	pop    %edi
  804153:	5d                   	pop    %ebp
  804154:	c3                   	ret    
  804155:	8d 76 00             	lea    0x0(%esi),%esi
  804158:	31 ff                	xor    %edi,%edi
  80415a:	31 c0                	xor    %eax,%eax
  80415c:	89 fa                	mov    %edi,%edx
  80415e:	83 c4 1c             	add    $0x1c,%esp
  804161:	5b                   	pop    %ebx
  804162:	5e                   	pop    %esi
  804163:	5f                   	pop    %edi
  804164:	5d                   	pop    %ebp
  804165:	c3                   	ret    
  804166:	66 90                	xchg   %ax,%ax
  804168:	89 d8                	mov    %ebx,%eax
  80416a:	f7 f7                	div    %edi
  80416c:	31 ff                	xor    %edi,%edi
  80416e:	89 fa                	mov    %edi,%edx
  804170:	83 c4 1c             	add    $0x1c,%esp
  804173:	5b                   	pop    %ebx
  804174:	5e                   	pop    %esi
  804175:	5f                   	pop    %edi
  804176:	5d                   	pop    %ebp
  804177:	c3                   	ret    
  804178:	bd 20 00 00 00       	mov    $0x20,%ebp
  80417d:	89 eb                	mov    %ebp,%ebx
  80417f:	29 fb                	sub    %edi,%ebx
  804181:	89 f9                	mov    %edi,%ecx
  804183:	d3 e6                	shl    %cl,%esi
  804185:	89 c5                	mov    %eax,%ebp
  804187:	88 d9                	mov    %bl,%cl
  804189:	d3 ed                	shr    %cl,%ebp
  80418b:	89 e9                	mov    %ebp,%ecx
  80418d:	09 f1                	or     %esi,%ecx
  80418f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804193:	89 f9                	mov    %edi,%ecx
  804195:	d3 e0                	shl    %cl,%eax
  804197:	89 c5                	mov    %eax,%ebp
  804199:	89 d6                	mov    %edx,%esi
  80419b:	88 d9                	mov    %bl,%cl
  80419d:	d3 ee                	shr    %cl,%esi
  80419f:	89 f9                	mov    %edi,%ecx
  8041a1:	d3 e2                	shl    %cl,%edx
  8041a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a7:	88 d9                	mov    %bl,%cl
  8041a9:	d3 e8                	shr    %cl,%eax
  8041ab:	09 c2                	or     %eax,%edx
  8041ad:	89 d0                	mov    %edx,%eax
  8041af:	89 f2                	mov    %esi,%edx
  8041b1:	f7 74 24 0c          	divl   0xc(%esp)
  8041b5:	89 d6                	mov    %edx,%esi
  8041b7:	89 c3                	mov    %eax,%ebx
  8041b9:	f7 e5                	mul    %ebp
  8041bb:	39 d6                	cmp    %edx,%esi
  8041bd:	72 19                	jb     8041d8 <__udivdi3+0xfc>
  8041bf:	74 0b                	je     8041cc <__udivdi3+0xf0>
  8041c1:	89 d8                	mov    %ebx,%eax
  8041c3:	31 ff                	xor    %edi,%edi
  8041c5:	e9 58 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041ca:	66 90                	xchg   %ax,%ax
  8041cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041d0:	89 f9                	mov    %edi,%ecx
  8041d2:	d3 e2                	shl    %cl,%edx
  8041d4:	39 c2                	cmp    %eax,%edx
  8041d6:	73 e9                	jae    8041c1 <__udivdi3+0xe5>
  8041d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041db:	31 ff                	xor    %edi,%edi
  8041dd:	e9 40 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	31 c0                	xor    %eax,%eax
  8041e6:	e9 37 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041eb:	90                   	nop

008041ec <__umoddi3>:
  8041ec:	55                   	push   %ebp
  8041ed:	57                   	push   %edi
  8041ee:	56                   	push   %esi
  8041ef:	53                   	push   %ebx
  8041f0:	83 ec 1c             	sub    $0x1c,%esp
  8041f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80420b:	89 f3                	mov    %esi,%ebx
  80420d:	89 fa                	mov    %edi,%edx
  80420f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804213:	89 34 24             	mov    %esi,(%esp)
  804216:	85 c0                	test   %eax,%eax
  804218:	75 1a                	jne    804234 <__umoddi3+0x48>
  80421a:	39 f7                	cmp    %esi,%edi
  80421c:	0f 86 a2 00 00 00    	jbe    8042c4 <__umoddi3+0xd8>
  804222:	89 c8                	mov    %ecx,%eax
  804224:	89 f2                	mov    %esi,%edx
  804226:	f7 f7                	div    %edi
  804228:	89 d0                	mov    %edx,%eax
  80422a:	31 d2                	xor    %edx,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	39 f0                	cmp    %esi,%eax
  804236:	0f 87 ac 00 00 00    	ja     8042e8 <__umoddi3+0xfc>
  80423c:	0f bd e8             	bsr    %eax,%ebp
  80423f:	83 f5 1f             	xor    $0x1f,%ebp
  804242:	0f 84 ac 00 00 00    	je     8042f4 <__umoddi3+0x108>
  804248:	bf 20 00 00 00       	mov    $0x20,%edi
  80424d:	29 ef                	sub    %ebp,%edi
  80424f:	89 fe                	mov    %edi,%esi
  804251:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804255:	89 e9                	mov    %ebp,%ecx
  804257:	d3 e0                	shl    %cl,%eax
  804259:	89 d7                	mov    %edx,%edi
  80425b:	89 f1                	mov    %esi,%ecx
  80425d:	d3 ef                	shr    %cl,%edi
  80425f:	09 c7                	or     %eax,%edi
  804261:	89 e9                	mov    %ebp,%ecx
  804263:	d3 e2                	shl    %cl,%edx
  804265:	89 14 24             	mov    %edx,(%esp)
  804268:	89 d8                	mov    %ebx,%eax
  80426a:	d3 e0                	shl    %cl,%eax
  80426c:	89 c2                	mov    %eax,%edx
  80426e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804272:	d3 e0                	shl    %cl,%eax
  804274:	89 44 24 04          	mov    %eax,0x4(%esp)
  804278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80427c:	89 f1                	mov    %esi,%ecx
  80427e:	d3 e8                	shr    %cl,%eax
  804280:	09 d0                	or     %edx,%eax
  804282:	d3 eb                	shr    %cl,%ebx
  804284:	89 da                	mov    %ebx,%edx
  804286:	f7 f7                	div    %edi
  804288:	89 d3                	mov    %edx,%ebx
  80428a:	f7 24 24             	mull   (%esp)
  80428d:	89 c6                	mov    %eax,%esi
  80428f:	89 d1                	mov    %edx,%ecx
  804291:	39 d3                	cmp    %edx,%ebx
  804293:	0f 82 87 00 00 00    	jb     804320 <__umoddi3+0x134>
  804299:	0f 84 91 00 00 00    	je     804330 <__umoddi3+0x144>
  80429f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042a3:	29 f2                	sub    %esi,%edx
  8042a5:	19 cb                	sbb    %ecx,%ebx
  8042a7:	89 d8                	mov    %ebx,%eax
  8042a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042ad:	d3 e0                	shl    %cl,%eax
  8042af:	89 e9                	mov    %ebp,%ecx
  8042b1:	d3 ea                	shr    %cl,%edx
  8042b3:	09 d0                	or     %edx,%eax
  8042b5:	89 e9                	mov    %ebp,%ecx
  8042b7:	d3 eb                	shr    %cl,%ebx
  8042b9:	89 da                	mov    %ebx,%edx
  8042bb:	83 c4 1c             	add    $0x1c,%esp
  8042be:	5b                   	pop    %ebx
  8042bf:	5e                   	pop    %esi
  8042c0:	5f                   	pop    %edi
  8042c1:	5d                   	pop    %ebp
  8042c2:	c3                   	ret    
  8042c3:	90                   	nop
  8042c4:	89 fd                	mov    %edi,%ebp
  8042c6:	85 ff                	test   %edi,%edi
  8042c8:	75 0b                	jne    8042d5 <__umoddi3+0xe9>
  8042ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8042cf:	31 d2                	xor    %edx,%edx
  8042d1:	f7 f7                	div    %edi
  8042d3:	89 c5                	mov    %eax,%ebp
  8042d5:	89 f0                	mov    %esi,%eax
  8042d7:	31 d2                	xor    %edx,%edx
  8042d9:	f7 f5                	div    %ebp
  8042db:	89 c8                	mov    %ecx,%eax
  8042dd:	f7 f5                	div    %ebp
  8042df:	89 d0                	mov    %edx,%eax
  8042e1:	e9 44 ff ff ff       	jmp    80422a <__umoddi3+0x3e>
  8042e6:	66 90                	xchg   %ax,%ax
  8042e8:	89 c8                	mov    %ecx,%eax
  8042ea:	89 f2                	mov    %esi,%edx
  8042ec:	83 c4 1c             	add    $0x1c,%esp
  8042ef:	5b                   	pop    %ebx
  8042f0:	5e                   	pop    %esi
  8042f1:	5f                   	pop    %edi
  8042f2:	5d                   	pop    %ebp
  8042f3:	c3                   	ret    
  8042f4:	3b 04 24             	cmp    (%esp),%eax
  8042f7:	72 06                	jb     8042ff <__umoddi3+0x113>
  8042f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042fd:	77 0f                	ja     80430e <__umoddi3+0x122>
  8042ff:	89 f2                	mov    %esi,%edx
  804301:	29 f9                	sub    %edi,%ecx
  804303:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804307:	89 14 24             	mov    %edx,(%esp)
  80430a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804312:	8b 14 24             	mov    (%esp),%edx
  804315:	83 c4 1c             	add    $0x1c,%esp
  804318:	5b                   	pop    %ebx
  804319:	5e                   	pop    %esi
  80431a:	5f                   	pop    %edi
  80431b:	5d                   	pop    %ebp
  80431c:	c3                   	ret    
  80431d:	8d 76 00             	lea    0x0(%esi),%esi
  804320:	2b 04 24             	sub    (%esp),%eax
  804323:	19 fa                	sbb    %edi,%edx
  804325:	89 d1                	mov    %edx,%ecx
  804327:	89 c6                	mov    %eax,%esi
  804329:	e9 71 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
  80432e:	66 90                	xchg   %ax,%ax
  804330:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804334:	72 ea                	jb     804320 <__umoddi3+0x134>
  804336:	89 d9                	mov    %ebx,%ecx
  804338:	e9 62 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
