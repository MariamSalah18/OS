
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 2a 0e 00 00       	call   800e60 <libmain>
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
  80003d:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
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
  800060:	68 c0 3e 80 00       	push   $0x803ec0
  800065:	6a 1c                	push   $0x1c
  800067:	68 dc 3e 80 00       	push   $0x803edc
  80006c:	e8 1d 0f 00 00       	call   800f8e <_panic>
	//	malloc(0);
	/*=================================================*/

	//cprintf("2\n");

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
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 e6 23 00 00       	call   802493 <sys_calculate_free_frames>
  8000ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000b0:	8d 95 0c ff ff ff    	lea    -0xf4(%ebp),%edx
  8000b6:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	89 d7                	mov    %edx,%edi
  8000c2:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 ca 23 00 00       	call   802493 <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 0d 24 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 8f 1f 00 00       	call   802074 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000ee:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8000f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 f0 3e 80 00       	push   $0x803ef0
  800101:	6a 44                	push   $0x44
  800103:	68 dc 3e 80 00       	push   $0x803edc
  800108:	e8 81 0e 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  80010d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800110:	e8 7e 23 00 00       	call   802493 <sys_calculate_free_frames>
  800115:	29 c3                	sub    %eax,%ebx
  800117:	89 d8                	mov    %ebx,%eax
  800119:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  80011e:	76 14                	jbe    800134 <_main+0xfc>
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	68 20 3f 80 00       	push   $0x803f20
  800128:	6a 45                	push   $0x45
  80012a:	68 dc 3e 80 00       	push   $0x803edc
  80012f:	e8 5a 0e 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800134:	e8 a5 23 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800139:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80013c:	74 14                	je     800152 <_main+0x11a>
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 6c 3f 80 00       	push   $0x803f6c
  800146:	6a 46                	push   $0x46
  800148:	68 dc 3e 80 00       	push   $0x803edc
  80014d:	e8 3c 0e 00 00       	call   800f8e <_panic>


			freeFrames = sys_calculate_free_frames() ;
  800152:	e8 3c 23 00 00       	call   802493 <sys_calculate_free_frames>
  800157:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80015a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015d:	01 c0                	add    %eax,%eax
  80015f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800162:	48                   	dec    %eax
  800163:	89 45 cc             	mov    %eax,-0x34(%ebp)

			byteArr = (char *) ptr_allocations[0];
  800166:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80016c:	89 45 c8             	mov    %eax,-0x38(%ebp)



			byteArr[0] = minByte ;
  80016f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800172:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800175:	88 10                	mov    %dl,(%eax)

			byteArr[lastIndexOfByte] = maxByte ;
  800177:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80017a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80017d:	01 c2                	add    %eax,%edx
  80017f:	8a 45 ea             	mov    -0x16(%ebp),%al
  800182:	88 02                	mov    %al,(%edx)

			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800184:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)

			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80018b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80018e:	e8 00 23 00 00       	call   802493 <sys_calculate_free_frames>
  800193:	29 c3                	sub    %eax,%ebx
  800195:	89 d8                	mov    %ebx,%eax
  800197:	89 45 c0             	mov    %eax,-0x40(%ebp)

			if (actualNumOfFrames < expectedNumOfFrames)
  80019a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80019d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001a0:	7d 1a                	jge    8001bc <_main+0x184>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 c0             	pushl  -0x40(%ebp)
  8001a8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8001ab:	68 9c 3f 80 00       	push   $0x803f9c
  8001b0:	6a 59                	push   $0x59
  8001b2:	68 dc 3e 80 00       	push   $0x803edc
  8001b7:	e8 d2 0d 00 00       	call   800f8e <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  8001bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001bf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ca:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8001d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001e3:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001e9:	6a 02                	push   $0x2
  8001eb:	6a 00                	push   $0x0
  8001ed:	6a 02                	push   $0x2
  8001ef:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001f5:	50                   	push   %eax
  8001f6:	e8 b5 27 00 00       	call   8029b0 <sys_check_WS_list>
  8001fb:	83 c4 10             	add    $0x10,%esp
  8001fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800201:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 18 40 80 00       	push   $0x804018
  80020f:	6a 5d                	push   $0x5d
  800211:	68 dc 3e 80 00       	push   $0x803edc
  800216:	e8 73 0d 00 00       	call   800f8e <_panic>
		}
		//cprintf("4\n");

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80021b:	e8 73 22 00 00       	call   802493 <sys_calculate_free_frames>
  800220:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800223:	e8 b6 22 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800228:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  80022b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022e:	01 c0                	add    %eax,%eax
  800230:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	50                   	push   %eax
  800237:	e8 38 1e 00 00       	call   802074 <malloc>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800245:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800250:	01 c0                	add    %eax,%eax
  800252:	89 c1                	mov    %eax,%ecx
  800254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800257:	01 c8                	add    %ecx,%eax
  800259:	39 c2                	cmp    %eax,%edx
  80025b:	74 14                	je     800271 <_main+0x239>
  80025d:	83 ec 04             	sub    $0x4,%esp
  800260:	68 f0 3e 80 00       	push   $0x803ef0
  800265:	6a 66                	push   $0x66
  800267:	68 dc 3e 80 00       	push   $0x803edc
  80026c:	e8 1d 0d 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800271:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800274:	e8 1a 22 00 00       	call   802493 <sys_calculate_free_frames>
  800279:	29 c3                	sub    %eax,%ebx
  80027b:	89 d8                	mov    %ebx,%eax
  80027d:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  800282:	76 14                	jbe    800298 <_main+0x260>
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 20 3f 80 00       	push   $0x803f20
  80028c:	6a 67                	push   $0x67
  80028e:	68 dc 3e 80 00       	push   $0x803edc
  800293:	e8 f6 0c 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800298:	e8 41 22 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  80029d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8002a0:	74 14                	je     8002b6 <_main+0x27e>
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	68 6c 3f 80 00       	push   $0x803f6c
  8002aa:	6a 68                	push   $0x68
  8002ac:	68 dc 3e 80 00       	push   $0x803edc
  8002b1:	e8 d8 0c 00 00       	call   800f8e <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8002b6:	e8 d8 21 00 00       	call   802493 <sys_calculate_free_frames>
  8002bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr = (short *) ptr_allocations[1];
  8002be:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8002c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cf:	d1 e8                	shr    %eax
  8002d1:	48                   	dec    %eax
  8002d2:	89 45 ac             	mov    %eax,-0x54(%ebp)
			shortArr[0] = minShort;
  8002d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8002de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002e1:	01 c0                	add    %eax,%eax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002e8:	01 c2                	add    %eax,%edx
  8002ea:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8002ee:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/;
  8002f1:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8002f8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002fb:	e8 93 21 00 00       	call   802493 <sys_calculate_free_frames>
  800300:	29 c3                	sub    %eax,%ebx
  800302:	89 d8                	mov    %ebx,%eax
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800307:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80030a:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80030d:	7d 1a                	jge    800329 <_main+0x2f1>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	ff 75 c0             	pushl  -0x40(%ebp)
  800315:	ff 75 c4             	pushl  -0x3c(%ebp)
  800318:	68 9c 3f 80 00       	push   $0x803f9c
  80031d:	6a 72                	push   $0x72
  80031f:	68 dc 3e 80 00       	push   $0x803edc
  800324:	e8 65 0c 00 00       	call   800f8e <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800329:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80032c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80032f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  80033d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800340:	01 c0                	add    %eax,%eax
  800342:	89 c2                	mov    %eax,%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80034c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80034f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800354:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80035a:	6a 02                	push   $0x2
  80035c:	6a 00                	push   $0x0
  80035e:	6a 02                	push   $0x2
  800360:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	e8 44 26 00 00       	call   8029b0 <sys_check_WS_list>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800372:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800376:	74 14                	je     80038c <_main+0x354>
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 18 40 80 00       	push   $0x804018
  800380:	6a 75                	push   $0x75
  800382:	68 dc 3e 80 00       	push   $0x803edc
  800387:	e8 02 0c 00 00       	call   800f8e <_panic>
		}
		//cprintf("5\n");

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80038c:	e8 4d 21 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800391:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  800394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	01 d2                	add    %edx,%edx
  80039b:	01 d0                	add    %edx,%eax
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	50                   	push   %eax
  8003a1:	e8 ce 1c 00 00       	call   802074 <malloc>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8003af:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ba:	c1 e0 02             	shl    $0x2,%eax
  8003bd:	89 c1                	mov    %eax,%ecx
  8003bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	74 14                	je     8003dc <_main+0x3a4>
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	68 f0 3e 80 00       	push   $0x803ef0
  8003d0:	6a 7e                	push   $0x7e
  8003d2:	68 dc 3e 80 00       	push   $0x803edc
  8003d7:	e8 b2 0b 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003dc:	e8 fd 20 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8003e1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8003e4:	74 14                	je     8003fa <_main+0x3c2>
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 6c 3f 80 00       	push   $0x803f6c
  8003ee:	6a 7f                	push   $0x7f
  8003f0:	68 dc 3e 80 00       	push   $0x803edc
  8003f5:	e8 94 0b 00 00       	call   800f8e <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8003fa:	e8 94 20 00 00       	call   802493 <sys_calculate_free_frames>
  8003ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			intArr = (int *) ptr_allocations[2];
  800402:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800408:	89 45 a0             	mov    %eax,-0x60(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80040b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040e:	01 c0                	add    %eax,%eax
  800410:	c1 e8 02             	shr    $0x2,%eax
  800413:	48                   	dec    %eax
  800414:	89 45 9c             	mov    %eax,-0x64(%ebp)
			intArr[0] = minInt;
  800417:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80041a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80041f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80042c:	01 c2                	add    %eax,%edx
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800433:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80043a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80043d:	e8 51 20 00 00       	call   802493 <sys_calculate_free_frames>
  800442:	29 c3                	sub    %eax,%ebx
  800444:	89 d8                	mov    %ebx,%eax
  800446:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800449:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80044c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80044f:	7d 1d                	jge    80046e <_main+0x436>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	ff 75 c0             	pushl  -0x40(%ebp)
  800457:	ff 75 c4             	pushl  -0x3c(%ebp)
  80045a:	68 9c 3f 80 00       	push   $0x803f9c
  80045f:	68 89 00 00 00       	push   $0x89
  800464:	68 dc 3e 80 00       	push   $0x803edc
  800469:	e8 20 0b 00 00       	call   800f8e <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80046e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800471:	89 45 98             	mov    %eax,-0x68(%ebp)
  800474:	8b 45 98             	mov    -0x68(%ebp),%eax
  800477:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80047c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800482:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800494:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800497:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049c:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8004a2:	6a 02                	push   $0x2
  8004a4:	6a 00                	push   $0x0
  8004a6:	6a 02                	push   $0x2
  8004a8:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  8004ae:	50                   	push   %eax
  8004af:	e8 fc 24 00 00       	call   8029b0 <sys_check_WS_list>
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  8004ba:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8004be:	74 17                	je     8004d7 <_main+0x49f>
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 18 40 80 00       	push   $0x804018
  8004c8:	68 8c 00 00 00       	push   $0x8c
  8004cd:	68 dc 3e 80 00       	push   $0x803edc
  8004d2:	e8 b7 0a 00 00       	call   800f8e <_panic>

		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d7:	e8 02 20 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  8004df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	50                   	push   %eax
  8004ec:	e8 83 1b 00 00       	call   802074 <malloc>
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  8004fa:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800500:	89 c2                	mov    %eax,%edx
  800502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800505:	c1 e0 02             	shl    $0x2,%eax
  800508:	89 c1                	mov    %eax,%ecx
  80050a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80050d:	c1 e0 02             	shl    $0x2,%eax
  800510:	01 c1                	add    %eax,%ecx
  800512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800515:	01 c8                	add    %ecx,%eax
  800517:	39 c2                	cmp    %eax,%edx
  800519:	74 17                	je     800532 <_main+0x4fa>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 f0 3e 80 00       	push   $0x803ef0
  800523:	68 94 00 00 00       	push   $0x94
  800528:	68 dc 3e 80 00       	push   $0x803edc
  80052d:	e8 5c 0a 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800532:	e8 a7 1f 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800537:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80053a:	74 17                	je     800553 <_main+0x51b>
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 6c 3f 80 00       	push   $0x803f6c
  800544:	68 95 00 00 00       	push   $0x95
  800549:	68 dc 3e 80 00       	push   $0x803edc
  80054e:	e8 3b 0a 00 00       	call   800f8e <_panic>

		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800553:	e8 3b 1f 00 00       	call   802493 <sys_calculate_free_frames>
  800558:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80055b:	e8 7e 1f 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800560:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  800563:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800566:	89 d0                	mov    %edx,%eax
  800568:	01 c0                	add    %eax,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	83 ec 0c             	sub    $0xc,%esp
  800573:	50                   	push   %eax
  800574:	e8 fb 1a 00 00       	call   802074 <malloc>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800582:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800588:	89 c2                	mov    %eax,%edx
  80058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058d:	c1 e0 02             	shl    $0x2,%eax
  800590:	89 c1                	mov    %eax,%ecx
  800592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800595:	c1 e0 03             	shl    $0x3,%eax
  800598:	01 c1                	add    %eax,%ecx
  80059a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	39 c2                	cmp    %eax,%edx
  8005a1:	74 17                	je     8005ba <_main+0x582>
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	68 f0 3e 80 00       	push   $0x803ef0
  8005ab:	68 9e 00 00 00       	push   $0x9e
  8005b0:	68 dc 3e 80 00       	push   $0x803edc
  8005b5:	e8 d4 09 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 2) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  8005ba:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005bd:	e8 d1 1e 00 00       	call   802493 <sys_calculate_free_frames>
  8005c2:	29 c3                	sub    %eax,%ebx
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	83 f8 01             	cmp    $0x1,%eax
  8005c9:	76 17                	jbe    8005e2 <_main+0x5aa>
  8005cb:	83 ec 04             	sub    $0x4,%esp
  8005ce:	68 20 3f 80 00       	push   $0x803f20
  8005d3:	68 9f 00 00 00       	push   $0x9f
  8005d8:	68 dc 3e 80 00       	push   $0x803edc
  8005dd:	e8 ac 09 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8005e2:	e8 f7 1e 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8005e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 6c 3f 80 00       	push   $0x803f6c
  8005f4:	68 a0 00 00 00       	push   $0xa0
  8005f9:	68 dc 3e 80 00       	push   $0x803edc
  8005fe:	e8 8b 09 00 00       	call   800f8e <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800603:	e8 8b 1e 00 00       	call   802493 <sys_calculate_free_frames>
  800608:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80060b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800611:	89 45 90             	mov    %eax,-0x70(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800614:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800617:	89 d0                	mov    %edx,%eax
  800619:	01 c0                	add    %eax,%eax
  80061b:	01 d0                	add    %edx,%eax
  80061d:	01 c0                	add    %eax,%eax
  80061f:	01 d0                	add    %edx,%eax
  800621:	c1 e8 03             	shr    $0x3,%eax
  800624:	48                   	dec    %eax
  800625:	89 45 8c             	mov    %eax,-0x74(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800628:	8b 45 90             	mov    -0x70(%ebp),%eax
  80062b:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80062e:	88 10                	mov    %dl,(%eax)
  800630:	8b 55 90             	mov    -0x70(%ebp),%edx
  800633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800636:	66 89 42 02          	mov    %ax,0x2(%edx)
  80063a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80063d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800640:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800643:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800646:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80064d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800650:	01 c2                	add    %eax,%edx
  800652:	8a 45 ea             	mov    -0x16(%ebp),%al
  800655:	88 02                	mov    %al,(%edx)
  800657:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80065a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800661:	8b 45 90             	mov    -0x70(%ebp),%eax
  800664:	01 c2                	add    %eax,%edx
  800666:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  80066a:	66 89 42 02          	mov    %ax,0x2(%edx)
  80066e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800678:	8b 45 90             	mov    -0x70(%ebp),%eax
  80067b:	01 c2                	add    %eax,%edx
  80067d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800680:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800683:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80068a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80068d:	e8 01 1e 00 00       	call   802493 <sys_calculate_free_frames>
  800692:	29 c3                	sub    %eax,%ebx
  800694:	89 d8                	mov    %ebx,%eax
  800696:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800699:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80069c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80069f:	7d 1d                	jge    8006be <_main+0x686>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	ff 75 c0             	pushl  -0x40(%ebp)
  8006a7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8006aa:	68 9c 3f 80 00       	push   $0x803f9c
  8006af:	68 aa 00 00 00       	push   $0xaa
  8006b4:	68 dc 3e 80 00       	push   $0x803edc
  8006b9:	e8 d0 08 00 00       	call   800f8e <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8006be:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c1:	89 45 88             	mov    %eax,-0x78(%ebp)
  8006c4:	8b 45 88             	mov    -0x78(%ebp),%eax
  8006c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006cc:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8006d2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006dc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006df:	01 d0                	add    %edx,%eax
  8006e1:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8006e4:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ec:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8006f2:	6a 02                	push   $0x2
  8006f4:	6a 00                	push   $0x0
  8006f6:	6a 02                	push   $0x2
  8006f8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	e8 ac 22 00 00       	call   8029b0 <sys_check_WS_list>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  80070a:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 18 40 80 00       	push   $0x804018
  800718:	68 ad 00 00 00       	push   $0xad
  80071d:	68 dc 3e 80 00       	push   $0x803edc
  800722:	e8 67 08 00 00       	call   800f8e <_panic>

		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800727:	e8 67 1d 00 00       	call   802493 <sys_calculate_free_frames>
  80072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 aa 1d 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800734:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073a:	89 c2                	mov    %eax,%edx
  80073c:	01 d2                	add    %edx,%edx
  80073e:	01 d0                	add    %edx,%eax
  800740:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	50                   	push   %eax
  800747:	e8 28 19 00 00       	call   802074 <malloc>
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800755:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80075b:	89 c2                	mov    %eax,%edx
  80075d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800760:	c1 e0 02             	shl    $0x2,%eax
  800763:	89 c1                	mov    %eax,%ecx
  800765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800768:	c1 e0 04             	shl    $0x4,%eax
  80076b:	01 c1                	add    %eax,%ecx
  80076d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800770:	01 c8                	add    %ecx,%eax
  800772:	39 c2                	cmp    %eax,%edx
  800774:	74 17                	je     80078d <_main+0x755>
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	68 f0 3e 80 00       	push   $0x803ef0
  80077e:	68 b6 00 00 00       	push   $0xb6
  800783:	68 dc 3e 80 00       	push   $0x803edc
  800788:	e8 01 08 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 3*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  80078d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800790:	e8 fe 1c 00 00       	call   802493 <sys_calculate_free_frames>
  800795:	89 d9                	mov    %ebx,%ecx
  800797:	29 c1                	sub    %eax,%ecx
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	89 c2                	mov    %eax,%edx
  80079e:	01 d2                	add    %edx,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	79 05                	jns    8007ab <_main+0x773>
  8007a6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007ab:	c1 f8 0c             	sar    $0xc,%eax
  8007ae:	39 c1                	cmp    %eax,%ecx
  8007b0:	72 17                	jb     8007c9 <_main+0x791>
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	68 20 3f 80 00       	push   $0x803f20
  8007ba:	68 b7 00 00 00       	push   $0xb7
  8007bf:	68 dc 3e 80 00       	push   $0x803edc
  8007c4:	e8 c5 07 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8007c9:	e8 10 1d 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8007ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 6c 3f 80 00       	push   $0x803f6c
  8007db:	68 b8 00 00 00       	push   $0xb8
  8007e0:	68 dc 3e 80 00       	push   $0x803edc
  8007e5:	e8 a4 07 00 00       	call   800f8e <_panic>

		}

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8007ea:	e8 a4 1c 00 00       	call   802493 <sys_calculate_free_frames>
  8007ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007f2:	e8 e7 1c 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  8007f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8007fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	01 c0                	add    %eax,%eax
  800805:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800808:	83 ec 0c             	sub    $0xc,%esp
  80080b:	50                   	push   %eax
  80080c:	e8 63 18 00 00       	call   802074 <malloc>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80081a:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800820:	89 c1                	mov    %eax,%ecx
  800822:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800825:	89 d0                	mov    %edx,%eax
  800827:	01 c0                	add    %eax,%eax
  800829:	01 d0                	add    %edx,%eax
  80082b:	01 c0                	add    %eax,%eax
  80082d:	01 d0                	add    %edx,%eax
  80082f:	89 c2                	mov    %eax,%edx
  800831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800834:	c1 e0 04             	shl    $0x4,%eax
  800837:	01 c2                	add    %eax,%edx
  800839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80083c:	01 d0                	add    %edx,%eax
  80083e:	39 c1                	cmp    %eax,%ecx
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 f0 3e 80 00       	push   $0x803ef0
  80084a:	68 c1 00 00 00       	push   $0xc1
  80084f:	68 dc 3e 80 00       	push   $0x803edc
  800854:	e8 35 07 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 6*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800859:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80085c:	e8 32 1c 00 00       	call   802493 <sys_calculate_free_frames>
  800861:	89 d9                	mov    %ebx,%ecx
  800863:	29 c1                	sub    %eax,%ecx
  800865:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800868:	89 d0                	mov    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	01 c0                	add    %eax,%eax
  800870:	85 c0                	test   %eax,%eax
  800872:	79 05                	jns    800879 <_main+0x841>
  800874:	05 ff 0f 00 00       	add    $0xfff,%eax
  800879:	c1 f8 0c             	sar    $0xc,%eax
  80087c:	39 c1                	cmp    %eax,%ecx
  80087e:	72 17                	jb     800897 <_main+0x85f>
  800880:	83 ec 04             	sub    $0x4,%esp
  800883:	68 20 3f 80 00       	push   $0x803f20
  800888:	68 c2 00 00 00       	push   $0xc2
  80088d:	68 dc 3e 80 00       	push   $0x803edc
  800892:	e8 f7 06 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800897:	e8 42 1c 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  80089c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80089f:	74 17                	je     8008b8 <_main+0x880>
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	68 6c 3f 80 00       	push   $0x803f6c
  8008a9:	68 c3 00 00 00       	push   $0xc3
  8008ae:	68 dc 3e 80 00       	push   $0x803edc
  8008b3:	e8 d6 06 00 00       	call   800f8e <_panic>



			freeFrames = sys_calculate_free_frames() ;
  8008b8:	e8 d6 1b 00 00       	call   802493 <sys_calculate_free_frames>
  8008bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  8008c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008c3:	89 d0                	mov    %edx,%eax
  8008c5:	01 c0                	add    %eax,%eax
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	01 c0                	add    %eax,%eax
  8008cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8008ce:	48                   	dec    %eax
  8008cf:	89 45 80             	mov    %eax,-0x80(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  8008d2:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8008d8:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			byteArr2[0] = minByte ;
  8008de:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008e4:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8008e7:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8008e9:	8b 45 80             	mov    -0x80(%ebp),%eax
  8008ec:	89 c2                	mov    %eax,%edx
  8008ee:	c1 ea 1f             	shr    $0x1f,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	d1 f8                	sar    %eax
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008fd:	01 c2                	add    %eax,%edx
  8008ff:	8a 45 ea             	mov    -0x16(%ebp),%al
  800902:	88 c1                	mov    %al,%cl
  800904:	c0 e9 07             	shr    $0x7,%cl
  800907:	01 c8                	add    %ecx,%eax
  800909:	d0 f8                	sar    %al
  80090b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  80090d:	8b 55 80             	mov    -0x80(%ebp),%edx
  800910:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800916:	01 c2                	add    %eax,%edx
  800918:	8a 45 ea             	mov    -0x16(%ebp),%al
  80091b:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 /*+2 tables already created in malloc due to marking the allocated pages*/ ;
  80091d:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800924:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800927:	e8 67 1b 00 00       	call   802493 <sys_calculate_free_frames>
  80092c:	29 c3                	sub    %eax,%ebx
  80092e:	89 d8                	mov    %ebx,%eax
  800930:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800933:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800936:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800939:	7d 1d                	jge    800958 <_main+0x920>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80093b:	83 ec 0c             	sub    $0xc,%esp
  80093e:	ff 75 c0             	pushl  -0x40(%ebp)
  800941:	ff 75 c4             	pushl  -0x3c(%ebp)
  800944:	68 9c 3f 80 00       	push   $0x803f9c
  800949:	68 d0 00 00 00       	push   $0xd0
  80094e:	68 dc 3e 80 00       	push   $0x803edc
  800953:	e8 36 06 00 00       	call   800f8e <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800958:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80095e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800964:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80096a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80096f:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  800975:	8b 45 80             	mov    -0x80(%ebp),%eax
  800978:	89 c2                	mov    %eax,%edx
  80097a:	c1 ea 1f             	shr    $0x1f,%edx
  80097d:	01 d0                	add    %edx,%eax
  80097f:	d1 f8                	sar    %eax
  800981:	89 c2                	mov    %eax,%edx
  800983:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800989:	01 d0                	add    %edx,%eax
  80098b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800991:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800997:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80099c:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  8009a2:	8b 55 80             	mov    -0x80(%ebp),%edx
  8009a5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8009b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  8009c4:	6a 02                	push   $0x2
  8009c6:	6a 00                	push   $0x0
  8009c8:	6a 03                	push   $0x3
  8009ca:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  8009d0:	50                   	push   %eax
  8009d1:	e8 da 1f 00 00       	call   8029b0 <sys_check_WS_list>
  8009d6:	83 c4 10             	add    $0x10,%esp
  8009d9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  8009dc:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 18 40 80 00       	push   $0x804018
  8009ea:	68 d3 00 00 00       	push   $0xd3
  8009ef:	68 dc 3e 80 00       	push   $0x803edc
  8009f4:	e8 95 05 00 00       	call   800f8e <_panic>

		}

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009f9:	e8 95 1a 00 00       	call   802493 <sys_calculate_free_frames>
  8009fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a01:	e8 d8 1a 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	01 c0                	add    %eax,%eax
  800a10:	01 d0                	add    %edx,%eax
  800a12:	01 c0                	add    %eax,%eax
  800a14:	01 d0                	add    %edx,%eax
  800a16:	01 c0                	add    %eax,%eax
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	50                   	push   %eax
  800a1c:	e8 53 16 00 00       	call   802074 <malloc>
  800a21:	83 c4 10             	add    $0x10,%esp
  800a24:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800a2a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a35:	89 d0                	mov    %edx,%eax
  800a37:	01 c0                	add    %eax,%eax
  800a39:	01 d0                	add    %edx,%eax
  800a3b:	c1 e0 02             	shl    $0x2,%eax
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	89 c2                	mov    %eax,%edx
  800a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a45:	c1 e0 04             	shl    $0x4,%eax
  800a48:	01 c2                	add    %eax,%edx
  800a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a4d:	01 d0                	add    %edx,%eax
  800a4f:	39 c1                	cmp    %eax,%ecx
  800a51:	74 17                	je     800a6a <_main+0xa32>
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	68 f0 3e 80 00       	push   $0x803ef0
  800a5b:	68 dd 00 00 00       	push   $0xdd
  800a60:	68 dc 3e 80 00       	push   $0x803edc
  800a65:	e8 24 05 00 00       	call   800f8e <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 16*kilo/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800a6a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a6d:	e8 21 1a 00 00       	call   802493 <sys_calculate_free_frames>
  800a72:	29 c3                	sub    %eax,%ebx
  800a74:	89 da                	mov    %ebx,%edx
  800a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a79:	c1 e0 04             	shl    $0x4,%eax
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	79 05                	jns    800a85 <_main+0xa4d>
  800a80:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a85:	c1 f8 0c             	sar    $0xc,%eax
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	72 17                	jb     800aa3 <_main+0xa6b>
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	68 20 3f 80 00       	push   $0x803f20
  800a94:	68 de 00 00 00       	push   $0xde
  800a99:	68 dc 3e 80 00       	push   $0x803edc
  800a9e:	e8 eb 04 00 00       	call   800f8e <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800aa3:	e8 36 1a 00 00       	call   8024de <sys_pf_calculate_allocated_pages>
  800aa8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800aab:	74 17                	je     800ac4 <_main+0xa8c>
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	68 6c 3f 80 00       	push   $0x803f6c
  800ab5:	68 df 00 00 00       	push   $0xdf
  800aba:	68 dc 3e 80 00       	push   $0x803edc
  800abf:	e8 ca 04 00 00       	call   800f8e <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800ac4:	e8 ca 19 00 00       	call   802493 <sys_calculate_free_frames>
  800ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800acc:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800ad2:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800ad8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800adb:	89 d0                	mov    %edx,%eax
  800add:	01 c0                	add    %eax,%eax
  800adf:	01 d0                	add    %edx,%eax
  800ae1:	01 c0                	add    %eax,%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	01 c0                	add    %eax,%eax
  800ae7:	d1 e8                	shr    %eax
  800ae9:	48                   	dec    %eax
  800aea:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
			shortArr2[0] = minShort;
  800af0:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af9:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800afc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	c1 ea 1f             	shr    $0x1f,%edx
  800b07:	01 d0                	add    %edx,%eax
  800b09:	d1 f8                	sar    %eax
  800b0b:	01 c0                	add    %eax,%eax
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b15:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800b18:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	66 c1 ea 0f          	shr    $0xf,%dx
  800b22:	01 d0                	add    %edx,%eax
  800b24:	66 d1 f8             	sar    %ax
  800b27:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800b2a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b30:	01 c0                	add    %eax,%eax
  800b32:	89 c2                	mov    %eax,%edx
  800b34:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b3a:	01 c2                	add    %eax,%edx
  800b3c:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800b40:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800b43:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b4a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800b4d:	e8 41 19 00 00       	call   802493 <sys_calculate_free_frames>
  800b52:	29 c3                	sub    %eax,%ebx
  800b54:	89 d8                	mov    %ebx,%eax
  800b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800b59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b5c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b5f:	7d 1d                	jge    800b7e <_main+0xb46>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800b61:	83 ec 0c             	sub    $0xc,%esp
  800b64:	ff 75 c0             	pushl  -0x40(%ebp)
  800b67:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b6a:	68 9c 3f 80 00       	push   $0x803f9c
  800b6f:	68 ea 00 00 00       	push   $0xea
  800b74:	68 dc 3e 80 00       	push   $0x803edc
  800b79:	e8 10 04 00 00       	call   800f8e <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800b7e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b84:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800b8a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b95:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  800b9b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ba1:	89 c2                	mov    %eax,%edx
  800ba3:	c1 ea 1f             	shr    $0x1f,%edx
  800ba6:	01 d0                	add    %edx,%eax
  800ba8:	d1 f8                	sar    %eax
  800baa:	01 c0                	add    %eax,%eax
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bb4:	01 d0                	add    %edx,%eax
  800bb6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800bbc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc7:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800bcd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800bd3:	01 c0                	add    %eax,%eax
  800bd5:	89 c2                	mov    %eax,%edx
  800bd7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
  800bdf:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800be5:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800beb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bf0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf6:	6a 02                	push   $0x2
  800bf8:	6a 00                	push   $0x0
  800bfa:	6a 03                	push   $0x3
  800bfc:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 a8 1d 00 00       	call   8029b0 <sys_check_WS_list>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800c0e:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800c12:	74 17                	je     800c2b <_main+0xbf3>
  800c14:	83 ec 04             	sub    $0x4,%esp
  800c17:	68 18 40 80 00       	push   $0x804018
  800c1c:	68 ed 00 00 00       	push   $0xed
  800c21:	68 dc 3e 80 00       	push   $0x803edc
  800c26:	e8 63 03 00 00       	call   800f8e <_panic>
		}
	}

	//Check that the values are successfully stored
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800c2b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800c33:	75 0f                	jne    800c44 <_main+0xc0c>
  800c35:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800c38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800c42:	74 17                	je     800c5b <_main+0xc23>
  800c44:	83 ec 04             	sub    $0x4,%esp
  800c47:	68 38 40 80 00       	push   $0x804038
  800c4c:	68 f5 00 00 00       	push   $0xf5
  800c51:	68 dc 3e 80 00       	push   $0x803edc
  800c56:	e8 33 03 00 00       	call   800f8e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800c5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c5e:	66 8b 00             	mov    (%eax),%ax
  800c61:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800c65:	75 15                	jne    800c7c <_main+0xc44>
  800c67:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800c6a:	01 c0                	add    %eax,%eax
  800c6c:	89 c2                	mov    %eax,%edx
  800c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c71:	01 d0                	add    %edx,%eax
  800c73:	66 8b 00             	mov    (%eax),%ax
  800c76:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800c7a:	74 17                	je     800c93 <_main+0xc5b>
  800c7c:	83 ec 04             	sub    $0x4,%esp
  800c7f:	68 38 40 80 00       	push   $0x804038
  800c84:	68 f6 00 00 00       	push   $0xf6
  800c89:	68 dc 3e 80 00       	push   $0x803edc
  800c8e:	e8 fb 02 00 00       	call   800f8e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  800c93:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c9b:	75 16                	jne    800cb3 <_main+0xc7b>
  800c9d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800ca0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ca7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800caa:	01 d0                	add    %edx,%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 38 40 80 00       	push   $0x804038
  800cbb:	68 f7 00 00 00       	push   $0xf7
  800cc0:	68 dc 3e 80 00       	push   $0x803edc
  800cc5:	e8 c4 02 00 00       	call   800f8e <_panic>



		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800cca:	8b 45 90             	mov    -0x70(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800cd2:	75 16                	jne    800cea <_main+0xcb2>
  800cd4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800cd7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800cde:	8b 45 90             	mov    -0x70(%ebp),%eax
  800ce1:	01 d0                	add    %edx,%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800ce8:	74 17                	je     800d01 <_main+0xcc9>
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	68 38 40 80 00       	push   $0x804038
  800cf2:	68 fb 00 00 00       	push   $0xfb
  800cf7:	68 dc 3e 80 00       	push   $0x803edc
  800cfc:	e8 8d 02 00 00       	call   800f8e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800d01:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d04:	66 8b 40 02          	mov    0x2(%eax),%ax
  800d08:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800d0c:	75 19                	jne    800d27 <_main+0xcef>
  800d0e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800d11:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800d18:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d1b:	01 d0                	add    %edx,%eax
  800d1d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800d21:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800d25:	74 17                	je     800d3e <_main+0xd06>
  800d27:	83 ec 04             	sub    $0x4,%esp
  800d2a:	68 38 40 80 00       	push   $0x804038
  800d2f:	68 fc 00 00 00       	push   $0xfc
  800d34:	68 dc 3e 80 00       	push   $0x803edc
  800d39:	e8 50 02 00 00       	call   800f8e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800d3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d41:	8b 40 04             	mov    0x4(%eax),%eax
  800d44:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800d47:	75 17                	jne    800d60 <_main+0xd28>
  800d49:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800d4c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800d53:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	8b 40 04             	mov    0x4(%eax),%eax
  800d5b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d5e:	74 17                	je     800d77 <_main+0xd3f>
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	68 38 40 80 00       	push   $0x804038
  800d68:	68 fd 00 00 00       	push   $0xfd
  800d6d:	68 dc 3e 80 00       	push   $0x803edc
  800d72:	e8 17 02 00 00       	call   800f8e <_panic>



		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800d77:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800d82:	75 3a                	jne    800dbe <_main+0xd86>
  800d84:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d87:	89 c2                	mov    %eax,%edx
  800d89:	c1 ea 1f             	shr    $0x1f,%edx
  800d8c:	01 d0                	add    %edx,%eax
  800d8e:	d1 f8                	sar    %eax
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d98:	01 d0                	add    %edx,%eax
  800d9a:	8a 10                	mov    (%eax),%dl
  800d9c:	8a 45 ea             	mov    -0x16(%ebp),%al
  800d9f:	88 c1                	mov    %al,%cl
  800da1:	c0 e9 07             	shr    $0x7,%cl
  800da4:	01 c8                	add    %ecx,%eax
  800da6:	d0 f8                	sar    %al
  800da8:	38 c2                	cmp    %al,%dl
  800daa:	75 12                	jne    800dbe <_main+0xd86>
  800dac:	8b 55 80             	mov    -0x80(%ebp),%edx
  800daf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800db5:	01 d0                	add    %edx,%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800dbc:	74 17                	je     800dd5 <_main+0xd9d>
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 38 40 80 00       	push   $0x804038
  800dc6:	68 01 01 00 00       	push   $0x101
  800dcb:	68 dc 3e 80 00       	push   $0x803edc
  800dd0:	e8 b9 01 00 00       	call   800f8e <_panic>
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800dd5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800ddb:	66 8b 00             	mov    (%eax),%ax
  800dde:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800de2:	75 4d                	jne    800e31 <_main+0xdf9>
  800de4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800dea:	89 c2                	mov    %eax,%edx
  800dec:	c1 ea 1f             	shr    $0x1f,%edx
  800def:	01 d0                	add    %edx,%eax
  800df1:	d1 f8                	sar    %eax
  800df3:	01 c0                	add    %eax,%eax
  800df5:	89 c2                	mov    %eax,%edx
  800df7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800dfd:	01 d0                	add    %edx,%eax
  800dff:	66 8b 10             	mov    (%eax),%dx
  800e02:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800e06:	89 c1                	mov    %eax,%ecx
  800e08:	66 c1 e9 0f          	shr    $0xf,%cx
  800e0c:	01 c8                	add    %ecx,%eax
  800e0e:	66 d1 f8             	sar    %ax
  800e11:	66 39 c2             	cmp    %ax,%dx
  800e14:	75 1b                	jne    800e31 <_main+0xdf9>
  800e16:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800e1c:	01 c0                	add    %eax,%eax
  800e1e:	89 c2                	mov    %eax,%edx
  800e20:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800e26:	01 d0                	add    %edx,%eax
  800e28:	66 8b 00             	mov    (%eax),%ax
  800e2b:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800e2f:	74 17                	je     800e48 <_main+0xe10>
  800e31:	83 ec 04             	sub    $0x4,%esp
  800e34:	68 38 40 80 00       	push   $0x804038
  800e39:	68 02 01 00 00       	push   $0x102
  800e3e:	68 dc 3e 80 00       	push   $0x803edc
  800e43:	e8 46 01 00 00       	call   800f8e <_panic>



	}
	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	68 70 40 80 00       	push   $0x804070
  800e50:	e8 f6 03 00 00       	call   80124b <cprintf>
  800e55:	83 c4 10             	add    $0x10,%esp

	return;
  800e58:	90                   	nop
}
  800e59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e66:	e8 b3 18 00 00       	call   80271e <sys_getenvindex>
  800e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	89 d0                	mov    %edx,%eax
  800e73:	01 c0                	add    %eax,%eax
  800e75:	01 d0                	add    %edx,%eax
  800e77:	c1 e0 06             	shl    $0x6,%eax
  800e7a:	29 d0                	sub    %edx,%eax
  800e7c:	c1 e0 03             	shl    $0x3,%eax
  800e7f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e84:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e89:	a1 20 50 80 00       	mov    0x805020,%eax
  800e8e:	8a 40 68             	mov    0x68(%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	74 0d                	je     800ea2 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800e95:	a1 20 50 80 00       	mov    0x805020,%eax
  800e9a:	83 c0 68             	add    $0x68,%eax
  800e9d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea6:	7e 0a                	jle    800eb2 <libmain+0x52>
		binaryname = argv[0];
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	ff 75 08             	pushl  0x8(%ebp)
  800ebb:	e8 78 f1 ff ff       	call   800038 <_main>
  800ec0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ec3:	e8 63 16 00 00       	call   80252b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 c4 40 80 00       	push   $0x8040c4
  800ed0:	e8 76 03 00 00       	call   80124b <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ed8:	a1 20 50 80 00       	mov    0x805020,%eax
  800edd:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800ee3:	a1 20 50 80 00       	mov    0x805020,%eax
  800ee8:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	52                   	push   %edx
  800ef2:	50                   	push   %eax
  800ef3:	68 ec 40 80 00       	push   $0x8040ec
  800ef8:	e8 4e 03 00 00       	call   80124b <cprintf>
  800efd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800f00:	a1 20 50 80 00       	mov    0x805020,%eax
  800f05:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800f16:	a1 20 50 80 00       	mov    0x805020,%eax
  800f1b:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800f21:	51                   	push   %ecx
  800f22:	52                   	push   %edx
  800f23:	50                   	push   %eax
  800f24:	68 14 41 80 00       	push   $0x804114
  800f29:	e8 1d 03 00 00       	call   80124b <cprintf>
  800f2e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f31:	a1 20 50 80 00       	mov    0x805020,%eax
  800f36:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	50                   	push   %eax
  800f40:	68 6c 41 80 00       	push   $0x80416c
  800f45:	e8 01 03 00 00       	call   80124b <cprintf>
  800f4a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	68 c4 40 80 00       	push   $0x8040c4
  800f55:	e8 f1 02 00 00       	call   80124b <cprintf>
  800f5a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f5d:	e8 e3 15 00 00       	call   802545 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f62:	e8 19 00 00 00       	call   800f80 <exit>
}
  800f67:	90                   	nop
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	6a 00                	push   $0x0
  800f75:	e8 70 17 00 00       	call   8026ea <sys_destroy_env>
  800f7a:	83 c4 10             	add    $0x10,%esp
}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <exit>:

void
exit(void)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f86:	e8 c5 17 00 00       	call   802750 <sys_exit_env>
}
  800f8b:	90                   	nop
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f94:	8d 45 10             	lea    0x10(%ebp),%eax
  800f97:	83 c0 04             	add    $0x4,%eax
  800f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f9d:	a1 18 51 80 00       	mov    0x805118,%eax
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	74 16                	je     800fbc <_panic+0x2e>
		cprintf("%s: ", argv0);
  800fa6:	a1 18 51 80 00       	mov    0x805118,%eax
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	50                   	push   %eax
  800faf:	68 80 41 80 00       	push   $0x804180
  800fb4:	e8 92 02 00 00       	call   80124b <cprintf>
  800fb9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fbc:	a1 00 50 80 00       	mov    0x805000,%eax
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	ff 75 08             	pushl  0x8(%ebp)
  800fc7:	50                   	push   %eax
  800fc8:	68 85 41 80 00       	push   $0x804185
  800fcd:	e8 79 02 00 00       	call   80124b <cprintf>
  800fd2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fde:	50                   	push   %eax
  800fdf:	e8 fc 01 00 00       	call   8011e0 <vcprintf>
  800fe4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	6a 00                	push   $0x0
  800fec:	68 a1 41 80 00       	push   $0x8041a1
  800ff1:	e8 ea 01 00 00       	call   8011e0 <vcprintf>
  800ff6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ff9:	e8 82 ff ff ff       	call   800f80 <exit>

	// should not return here
	while (1) ;
  800ffe:	eb fe                	jmp    800ffe <_panic+0x70>

00801000 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	39 c2                	cmp    %eax,%edx
  801016:	74 14                	je     80102c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	68 a4 41 80 00       	push   $0x8041a4
  801020:	6a 26                	push   $0x26
  801022:	68 f0 41 80 00       	push   $0x8041f0
  801027:	e8 62 ff ff ff       	call   800f8e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80102c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801033:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80103a:	e9 c5 00 00 00       	jmp    801104 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80103f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	85 c0                	test   %eax,%eax
  801052:	75 08                	jne    80105c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801054:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801057:	e9 a5 00 00 00       	jmp    801101 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80105c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801063:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80106a:	eb 69                	jmp    8010d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80106c:	a1 20 50 80 00       	mov    0x805020,%eax
  801071:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801077:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80107a:	89 d0                	mov    %edx,%eax
  80107c:	01 c0                	add    %eax,%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	c1 e0 03             	shl    $0x3,%eax
  801083:	01 c8                	add    %ecx,%eax
  801085:	8a 40 04             	mov    0x4(%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	75 46                	jne    8010d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80108c:	a1 20 50 80 00       	mov    0x805020,%eax
  801091:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801097:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	01 c0                	add    %eax,%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	c1 e0 03             	shl    $0x3,%eax
  8010a3:	01 c8                	add    %ecx,%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	01 c8                	add    %ecx,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010c5:	39 c2                	cmp    %eax,%edx
  8010c7:	75 09                	jne    8010d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010d0:	eb 15                	jmp    8010e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010d2:	ff 45 e8             	incl   -0x18(%ebp)
  8010d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8010da:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8010e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010e3:	39 c2                	cmp    %eax,%edx
  8010e5:	77 85                	ja     80106c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010eb:	75 14                	jne    801101 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	68 fc 41 80 00       	push   $0x8041fc
  8010f5:	6a 3a                	push   $0x3a
  8010f7:	68 f0 41 80 00       	push   $0x8041f0
  8010fc:	e8 8d fe ff ff       	call   800f8e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801101:	ff 45 f0             	incl   -0x10(%ebp)
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80110a:	0f 8c 2f ff ff ff    	jl     80103f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801110:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80111e:	eb 26                	jmp    801146 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801120:	a1 20 50 80 00       	mov    0x805020,%eax
  801125:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80112b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80112e:	89 d0                	mov    %edx,%eax
  801130:	01 c0                	add    %eax,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	c1 e0 03             	shl    $0x3,%eax
  801137:	01 c8                	add    %ecx,%eax
  801139:	8a 40 04             	mov    0x4(%eax),%al
  80113c:	3c 01                	cmp    $0x1,%al
  80113e:	75 03                	jne    801143 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801140:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801143:	ff 45 e0             	incl   -0x20(%ebp)
  801146:	a1 20 50 80 00       	mov    0x805020,%eax
  80114b:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  801151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801154:	39 c2                	cmp    %eax,%edx
  801156:	77 c8                	ja     801120 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80115e:	74 14                	je     801174 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801160:	83 ec 04             	sub    $0x4,%esp
  801163:	68 50 42 80 00       	push   $0x804250
  801168:	6a 44                	push   $0x44
  80116a:	68 f0 41 80 00       	push   $0x8041f0
  80116f:	e8 1a fe ff ff       	call   800f8e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 48 01             	lea    0x1(%eax),%ecx
  801185:	8b 55 0c             	mov    0xc(%ebp),%edx
  801188:	89 0a                	mov    %ecx,(%edx)
  80118a:	8b 55 08             	mov    0x8(%ebp),%edx
  80118d:	88 d1                	mov    %dl,%cl
  80118f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801192:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 00                	mov    (%eax),%eax
  80119b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a0:	75 2c                	jne    8011ce <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8011a2:	a0 24 50 80 00       	mov    0x805024,%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ad:	8b 12                	mov    (%edx),%edx
  8011af:	89 d1                	mov    %edx,%ecx
  8011b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b4:	83 c2 08             	add    $0x8,%edx
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	50                   	push   %eax
  8011bb:	51                   	push   %ecx
  8011bc:	52                   	push   %edx
  8011bd:	e8 10 12 00 00       	call   8023d2 <sys_cputs>
  8011c2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	8b 40 04             	mov    0x4(%eax),%eax
  8011d4:	8d 50 01             	lea    0x1(%eax),%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011dd:	90                   	nop
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011f0:	00 00 00 
	b.cnt = 0;
  8011f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	68 77 11 80 00       	push   $0x801177
  80120f:	e8 11 02 00 00       	call   801425 <vprintfmt>
  801214:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801217:	a0 24 50 80 00       	mov    0x805024,%al
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	50                   	push   %eax
  801229:	52                   	push   %edx
  80122a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801230:	83 c0 08             	add    $0x8,%eax
  801233:	50                   	push   %eax
  801234:	e8 99 11 00 00       	call   8023d2 <sys_cputs>
  801239:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80123c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <cprintf>:

int cprintf(const char *fmt, ...) {
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801251:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801258:	8d 45 0c             	lea    0xc(%ebp),%eax
  80125b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 f4             	pushl  -0xc(%ebp)
  801267:	50                   	push   %eax
  801268:	e8 73 ff ff ff       	call   8011e0 <vcprintf>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801273:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80127e:	e8 a8 12 00 00       	call   80252b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801283:	8d 45 0c             	lea    0xc(%ebp),%eax
  801286:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	50                   	push   %eax
  801293:	e8 48 ff ff ff       	call   8011e0 <vcprintf>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80129e:	e8 a2 12 00 00       	call   802545 <sys_enable_interrupt>
	return cnt;
  8012a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 14             	sub    $0x14,%esp
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8012be:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012c6:	77 55                	ja     80131d <printnum+0x75>
  8012c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012cb:	72 05                	jb     8012d2 <printnum+0x2a>
  8012cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d0:	77 4b                	ja     80131d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8012db:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e0:	52                   	push   %edx
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e8:	e8 67 29 00 00       	call   803c54 <__udivdi3>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	ff 75 20             	pushl  0x20(%ebp)
  8012f6:	53                   	push   %ebx
  8012f7:	ff 75 18             	pushl  0x18(%ebp)
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	ff 75 08             	pushl  0x8(%ebp)
  801302:	e8 a1 ff ff ff       	call   8012a8 <printnum>
  801307:	83 c4 20             	add    $0x20,%esp
  80130a:	eb 1a                	jmp    801326 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80130c:	83 ec 08             	sub    $0x8,%esp
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	ff 75 20             	pushl  0x20(%ebp)
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	ff d0                	call   *%eax
  80131a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80131d:	ff 4d 1c             	decl   0x1c(%ebp)
  801320:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801324:	7f e6                	jg     80130c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801326:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801329:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	53                   	push   %ebx
  801335:	51                   	push   %ecx
  801336:	52                   	push   %edx
  801337:	50                   	push   %eax
  801338:	e8 27 2a 00 00       	call   803d64 <__umoddi3>
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	05 b4 44 80 00       	add    $0x8044b4,%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	0f be c0             	movsbl %al,%eax
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	50                   	push   %eax
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	ff d0                	call   *%eax
  801356:	83 c4 10             	add    $0x10,%esp
}
  801359:	90                   	nop
  80135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801362:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801366:	7e 1c                	jle    801384 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	8d 50 08             	lea    0x8(%eax),%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 10                	mov    %edx,(%eax)
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	83 e8 08             	sub    $0x8,%eax
  80137d:	8b 50 04             	mov    0x4(%eax),%edx
  801380:	8b 00                	mov    (%eax),%eax
  801382:	eb 40                	jmp    8013c4 <getuint+0x65>
	else if (lflag)
  801384:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801388:	74 1e                	je     8013a8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 50 04             	lea    0x4(%eax),%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 10                	mov    %edx,(%eax)
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8b 00                	mov    (%eax),%eax
  80139c:	83 e8 04             	sub    $0x4,%eax
  80139f:	8b 00                	mov    (%eax),%eax
  8013a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a6:	eb 1c                	jmp    8013c4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8b 00                	mov    (%eax),%eax
  8013ad:	8d 50 04             	lea    0x4(%eax),%edx
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	89 10                	mov    %edx,(%eax)
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	83 e8 04             	sub    $0x4,%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013cd:	7e 1c                	jle    8013eb <getint+0x25>
		return va_arg(*ap, long long);
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	8d 50 08             	lea    0x8(%eax),%edx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	89 10                	mov    %edx,(%eax)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	83 e8 08             	sub    $0x8,%eax
  8013e4:	8b 50 04             	mov    0x4(%eax),%edx
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	eb 38                	jmp    801423 <getint+0x5d>
	else if (lflag)
  8013eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ef:	74 1a                	je     80140b <getint+0x45>
		return va_arg(*ap, long);
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8b 00                	mov    (%eax),%eax
  8013f6:	8d 50 04             	lea    0x4(%eax),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	89 10                	mov    %edx,(%eax)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	83 e8 04             	sub    $0x4,%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	99                   	cltd   
  801409:	eb 18                	jmp    801423 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	8d 50 04             	lea    0x4(%eax),%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	89 10                	mov    %edx,(%eax)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	83 e8 04             	sub    $0x4,%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	99                   	cltd   
}
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80142d:	eb 17                	jmp    801446 <vprintfmt+0x21>
			if (ch == '\0')
  80142f:	85 db                	test   %ebx,%ebx
  801431:	0f 84 af 03 00 00    	je     8017e6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	53                   	push   %ebx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	ff d0                	call   *%eax
  801443:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	8d 50 01             	lea    0x1(%eax),%edx
  80144c:	89 55 10             	mov    %edx,0x10(%ebp)
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f b6 d8             	movzbl %al,%ebx
  801454:	83 fb 25             	cmp    $0x25,%ebx
  801457:	75 d6                	jne    80142f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801459:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80145d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801464:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80146b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801472:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	8d 50 01             	lea    0x1(%eax),%edx
  80147f:	89 55 10             	mov    %edx,0x10(%ebp)
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f b6 d8             	movzbl %al,%ebx
  801487:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80148a:	83 f8 55             	cmp    $0x55,%eax
  80148d:	0f 87 2b 03 00 00    	ja     8017be <vprintfmt+0x399>
  801493:	8b 04 85 d8 44 80 00 	mov    0x8044d8(,%eax,4),%eax
  80149a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80149c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8014a0:	eb d7                	jmp    801479 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014a2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8014a6:	eb d1                	jmp    801479 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b2:	89 d0                	mov    %edx,%eax
  8014b4:	c1 e0 02             	shl    $0x2,%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	01 c0                	add    %eax,%eax
  8014bb:	01 d8                	add    %ebx,%eax
  8014bd:	83 e8 30             	sub    $0x30,%eax
  8014c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014cb:	83 fb 2f             	cmp    $0x2f,%ebx
  8014ce:	7e 3e                	jle    80150e <vprintfmt+0xe9>
  8014d0:	83 fb 39             	cmp    $0x39,%ebx
  8014d3:	7f 39                	jg     80150e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014d5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014d8:	eb d5                	jmp    8014af <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	83 c0 04             	add    $0x4,%eax
  8014e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	83 e8 04             	sub    $0x4,%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014ee:	eb 1f                	jmp    80150f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014f4:	79 83                	jns    801479 <vprintfmt+0x54>
				width = 0;
  8014f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014fd:	e9 77 ff ff ff       	jmp    801479 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801502:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801509:	e9 6b ff ff ff       	jmp    801479 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80150e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80150f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801513:	0f 89 60 ff ff ff    	jns    801479 <vprintfmt+0x54>
				width = precision, precision = -1;
  801519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80151f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801526:	e9 4e ff ff ff       	jmp    801479 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80152b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80152e:	e9 46 ff ff ff       	jmp    801479 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801533:	8b 45 14             	mov    0x14(%ebp),%eax
  801536:	83 c0 04             	add    $0x4,%eax
  801539:	89 45 14             	mov    %eax,0x14(%ebp)
  80153c:	8b 45 14             	mov    0x14(%ebp),%eax
  80153f:	83 e8 04             	sub    $0x4,%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	ff d0                	call   *%eax
  801550:	83 c4 10             	add    $0x10,%esp
			break;
  801553:	e9 89 02 00 00       	jmp    8017e1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801558:	8b 45 14             	mov    0x14(%ebp),%eax
  80155b:	83 c0 04             	add    $0x4,%eax
  80155e:	89 45 14             	mov    %eax,0x14(%ebp)
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	83 e8 04             	sub    $0x4,%eax
  801567:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801569:	85 db                	test   %ebx,%ebx
  80156b:	79 02                	jns    80156f <vprintfmt+0x14a>
				err = -err;
  80156d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80156f:	83 fb 64             	cmp    $0x64,%ebx
  801572:	7f 0b                	jg     80157f <vprintfmt+0x15a>
  801574:	8b 34 9d 20 43 80 00 	mov    0x804320(,%ebx,4),%esi
  80157b:	85 f6                	test   %esi,%esi
  80157d:	75 19                	jne    801598 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80157f:	53                   	push   %ebx
  801580:	68 c5 44 80 00       	push   $0x8044c5
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	e8 5e 02 00 00       	call   8017ee <printfmt>
  801590:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801593:	e9 49 02 00 00       	jmp    8017e1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801598:	56                   	push   %esi
  801599:	68 ce 44 80 00       	push   $0x8044ce
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 45 02 00 00       	call   8017ee <printfmt>
  8015a9:	83 c4 10             	add    $0x10,%esp
			break;
  8015ac:	e9 30 02 00 00       	jmp    8017e1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b4:	83 c0 04             	add    $0x4,%eax
  8015b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bd:	83 e8 04             	sub    $0x4,%eax
  8015c0:	8b 30                	mov    (%eax),%esi
  8015c2:	85 f6                	test   %esi,%esi
  8015c4:	75 05                	jne    8015cb <vprintfmt+0x1a6>
				p = "(null)";
  8015c6:	be d1 44 80 00       	mov    $0x8044d1,%esi
			if (width > 0 && padc != '-')
  8015cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015cf:	7e 6d                	jle    80163e <vprintfmt+0x219>
  8015d1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015d5:	74 67                	je     80163e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	50                   	push   %eax
  8015de:	56                   	push   %esi
  8015df:	e8 0c 03 00 00       	call   8018f0 <strnlen>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015ea:	eb 16                	jmp    801602 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015ec:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	50                   	push   %eax
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	ff d0                	call   *%eax
  8015fc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015ff:	ff 4d e4             	decl   -0x1c(%ebp)
  801602:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801606:	7f e4                	jg     8015ec <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801608:	eb 34                	jmp    80163e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80160a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80160e:	74 1c                	je     80162c <vprintfmt+0x207>
  801610:	83 fb 1f             	cmp    $0x1f,%ebx
  801613:	7e 05                	jle    80161a <vprintfmt+0x1f5>
  801615:	83 fb 7e             	cmp    $0x7e,%ebx
  801618:	7e 12                	jle    80162c <vprintfmt+0x207>
					putch('?', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 3f                	push   $0x3f
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	eb 0f                	jmp    80163b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	53                   	push   %ebx
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80163b:	ff 4d e4             	decl   -0x1c(%ebp)
  80163e:	89 f0                	mov    %esi,%eax
  801640:	8d 70 01             	lea    0x1(%eax),%esi
  801643:	8a 00                	mov    (%eax),%al
  801645:	0f be d8             	movsbl %al,%ebx
  801648:	85 db                	test   %ebx,%ebx
  80164a:	74 24                	je     801670 <vprintfmt+0x24b>
  80164c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801650:	78 b8                	js     80160a <vprintfmt+0x1e5>
  801652:	ff 4d e0             	decl   -0x20(%ebp)
  801655:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801659:	79 af                	jns    80160a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80165b:	eb 13                	jmp    801670 <vprintfmt+0x24b>
				putch(' ', putdat);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	6a 20                	push   $0x20
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	ff d0                	call   *%eax
  80166a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80166d:	ff 4d e4             	decl   -0x1c(%ebp)
  801670:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801674:	7f e7                	jg     80165d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801676:	e9 66 01 00 00       	jmp    8017e1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	ff 75 e8             	pushl  -0x18(%ebp)
  801681:	8d 45 14             	lea    0x14(%ebp),%eax
  801684:	50                   	push   %eax
  801685:	e8 3c fd ff ff       	call   8013c6 <getint>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801690:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801699:	85 d2                	test   %edx,%edx
  80169b:	79 23                	jns    8016c0 <vprintfmt+0x29b>
				putch('-', putdat);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	6a 2d                	push   $0x2d
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	ff d0                	call   *%eax
  8016aa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	f7 d8                	neg    %eax
  8016b5:	83 d2 00             	adc    $0x0,%edx
  8016b8:	f7 da                	neg    %edx
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016c7:	e9 bc 00 00 00       	jmp    801788 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	e8 84 fc ff ff       	call   80135f <getuint>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016e4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016eb:	e9 98 00 00 00       	jmp    801788 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	6a 58                	push   $0x58
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	ff d0                	call   *%eax
  8016fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801700:	83 ec 08             	sub    $0x8,%esp
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	6a 58                	push   $0x58
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	ff d0                	call   *%eax
  80170d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	6a 58                	push   $0x58
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	ff d0                	call   *%eax
  80171d:	83 c4 10             	add    $0x10,%esp
			break;
  801720:	e9 bc 00 00 00       	jmp    8017e1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	6a 30                	push   $0x30
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	ff d0                	call   *%eax
  801732:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	6a 78                	push   $0x78
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	ff d0                	call   *%eax
  801742:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	83 c0 04             	add    $0x4,%eax
  80174b:	89 45 14             	mov    %eax,0x14(%ebp)
  80174e:	8b 45 14             	mov    0x14(%ebp),%eax
  801751:	83 e8 04             	sub    $0x4,%eax
  801754:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801760:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801767:	eb 1f                	jmp    801788 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 e8             	pushl  -0x18(%ebp)
  80176f:	8d 45 14             	lea    0x14(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	e8 e7 fb ff ff       	call   80135f <getuint>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80177e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801781:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801788:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80178c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	52                   	push   %edx
  801793:	ff 75 e4             	pushl  -0x1c(%ebp)
  801796:	50                   	push   %eax
  801797:	ff 75 f4             	pushl  -0xc(%ebp)
  80179a:	ff 75 f0             	pushl  -0x10(%ebp)
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	e8 00 fb ff ff       	call   8012a8 <printnum>
  8017a8:	83 c4 20             	add    $0x20,%esp
			break;
  8017ab:	eb 34                	jmp    8017e1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	53                   	push   %ebx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	ff d0                	call   *%eax
  8017b9:	83 c4 10             	add    $0x10,%esp
			break;
  8017bc:	eb 23                	jmp    8017e1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017be:	83 ec 08             	sub    $0x8,%esp
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	6a 25                	push   $0x25
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	ff d0                	call   *%eax
  8017cb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017ce:	ff 4d 10             	decl   0x10(%ebp)
  8017d1:	eb 03                	jmp    8017d6 <vprintfmt+0x3b1>
  8017d3:	ff 4d 10             	decl   0x10(%ebp)
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	48                   	dec    %eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 25                	cmp    $0x25,%al
  8017de:	75 f3                	jne    8017d3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017e0:	90                   	nop
		}
	}
  8017e1:	e9 47 fc ff ff       	jmp    80142d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017e6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f7:	83 c0 04             	add    $0x4,%eax
  8017fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801800:	ff 75 f4             	pushl  -0xc(%ebp)
  801803:	50                   	push   %eax
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	e8 16 fc ff ff       	call   801425 <vprintfmt>
  80180f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	8b 40 08             	mov    0x8(%eax),%eax
  80181e:	8d 50 01             	lea    0x1(%eax),%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	8b 10                	mov    (%eax),%edx
  80182c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182f:	8b 40 04             	mov    0x4(%eax),%eax
  801832:	39 c2                	cmp    %eax,%edx
  801834:	73 12                	jae    801848 <sprintputch+0x33>
		*b->buf++ = ch;
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	8b 00                	mov    (%eax),%eax
  80183b:	8d 48 01             	lea    0x1(%eax),%ecx
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	89 0a                	mov    %ecx,(%edx)
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	88 10                	mov    %dl,(%eax)
}
  801848:	90                   	nop
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80186c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801870:	74 06                	je     801878 <vsnprintf+0x2d>
  801872:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801876:	7f 07                	jg     80187f <vsnprintf+0x34>
		return -E_INVAL;
  801878:	b8 03 00 00 00       	mov    $0x3,%eax
  80187d:	eb 20                	jmp    80189f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80187f:	ff 75 14             	pushl  0x14(%ebp)
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801888:	50                   	push   %eax
  801889:	68 15 18 80 00       	push   $0x801815
  80188e:	e8 92 fb ff ff       	call   801425 <vprintfmt>
  801893:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801899:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8018aa:	83 c0 04             	add    $0x4,%eax
  8018ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 89 ff ff ff       	call   80184b <vsnprintf>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018da:	eb 06                	jmp    8018e2 <strlen+0x15>
		n++;
  8018dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018df:	ff 45 08             	incl   0x8(%ebp)
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	84 c0                	test   %al,%al
  8018e9:	75 f1                	jne    8018dc <strlen+0xf>
		n++;
	return n;
  8018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018fd:	eb 09                	jmp    801908 <strnlen+0x18>
		n++;
  8018ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801902:	ff 45 08             	incl   0x8(%ebp)
  801905:	ff 4d 0c             	decl   0xc(%ebp)
  801908:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80190c:	74 09                	je     801917 <strnlen+0x27>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	84 c0                	test   %al,%al
  801915:	75 e8                	jne    8018ff <strnlen+0xf>
		n++;
	return n;
  801917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801928:	90                   	nop
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8d 50 01             	lea    0x1(%eax),%edx
  80192f:	89 55 08             	mov    %edx,0x8(%ebp)
  801932:	8b 55 0c             	mov    0xc(%ebp),%edx
  801935:	8d 4a 01             	lea    0x1(%edx),%ecx
  801938:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80193b:	8a 12                	mov    (%edx),%dl
  80193d:	88 10                	mov    %dl,(%eax)
  80193f:	8a 00                	mov    (%eax),%al
  801941:	84 c0                	test   %al,%al
  801943:	75 e4                	jne    801929 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801945:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801956:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80195d:	eb 1f                	jmp    80197e <strncpy+0x34>
		*dst++ = *src;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8d 50 01             	lea    0x1(%eax),%edx
  801965:	89 55 08             	mov    %edx,0x8(%ebp)
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8a 12                	mov    (%edx),%dl
  80196d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	8a 00                	mov    (%eax),%al
  801974:	84 c0                	test   %al,%al
  801976:	74 03                	je     80197b <strncpy+0x31>
			src++;
  801978:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80197b:	ff 45 fc             	incl   -0x4(%ebp)
  80197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801981:	3b 45 10             	cmp    0x10(%ebp),%eax
  801984:	72 d9                	jb     80195f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801986:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801997:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80199b:	74 30                	je     8019cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80199d:	eb 16                	jmp    8019b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8d 50 01             	lea    0x1(%eax),%edx
  8019a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019b1:	8a 12                	mov    (%edx),%dl
  8019b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019b5:	ff 4d 10             	decl   0x10(%ebp)
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	74 09                	je     8019c7 <strlcpy+0x3c>
  8019be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	84 c0                	test   %al,%al
  8019c5:	75 d8                	jne    80199f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d3:	29 c2                	sub    %eax,%edx
  8019d5:	89 d0                	mov    %edx,%eax
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019dc:	eb 06                	jmp    8019e4 <strcmp+0xb>
		p++, q++;
  8019de:	ff 45 08             	incl   0x8(%ebp)
  8019e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	8a 00                	mov    (%eax),%al
  8019e9:	84 c0                	test   %al,%al
  8019eb:	74 0e                	je     8019fb <strcmp+0x22>
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8a 10                	mov    (%eax),%dl
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	38 c2                	cmp    %al,%dl
  8019f9:	74 e3                	je     8019de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f b6 d0             	movzbl %al,%edx
  801a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a06:	8a 00                	mov    (%eax),%al
  801a08:	0f b6 c0             	movzbl %al,%eax
  801a0b:	29 c2                	sub    %eax,%edx
  801a0d:	89 d0                	mov    %edx,%eax
}
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    

00801a11 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a14:	eb 09                	jmp    801a1f <strncmp+0xe>
		n--, p++, q++;
  801a16:	ff 4d 10             	decl   0x10(%ebp)
  801a19:	ff 45 08             	incl   0x8(%ebp)
  801a1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a23:	74 17                	je     801a3c <strncmp+0x2b>
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8a 00                	mov    (%eax),%al
  801a2a:	84 c0                	test   %al,%al
  801a2c:	74 0e                	je     801a3c <strncmp+0x2b>
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8a 10                	mov    (%eax),%dl
  801a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a36:	8a 00                	mov    (%eax),%al
  801a38:	38 c2                	cmp    %al,%dl
  801a3a:	74 da                	je     801a16 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a40:	75 07                	jne    801a49 <strncmp+0x38>
		return 0;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
  801a47:	eb 14                	jmp    801a5d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8a 00                	mov    (%eax),%al
  801a4e:	0f b6 d0             	movzbl %al,%edx
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	0f b6 c0             	movzbl %al,%eax
  801a59:	29 c2                	sub    %eax,%edx
  801a5b:	89 d0                	mov    %edx,%eax
}
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a68:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6b:	eb 12                	jmp    801a7f <strchr+0x20>
		if (*s == c)
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8a 00                	mov    (%eax),%al
  801a72:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a75:	75 05                	jne    801a7c <strchr+0x1d>
			return (char *) s;
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	eb 11                	jmp    801a8d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a7c:	ff 45 08             	incl   0x8(%ebp)
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	84 c0                	test   %al,%al
  801a86:	75 e5                	jne    801a6d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a9b:	eb 0d                	jmp    801aaa <strfind+0x1b>
		if (*s == c)
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8a 00                	mov    (%eax),%al
  801aa2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aa5:	74 0e                	je     801ab5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801aa7:	ff 45 08             	incl   0x8(%ebp)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	84 c0                	test   %al,%al
  801ab1:	75 ea                	jne    801a9d <strfind+0xe>
  801ab3:	eb 01                	jmp    801ab6 <strfind+0x27>
		if (*s == c)
			break;
  801ab5:	90                   	nop
	return (char *) s;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801acd:	eb 0e                	jmp    801add <memset+0x22>
		*p++ = c;
  801acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ad2:	8d 50 01             	lea    0x1(%eax),%edx
  801ad5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801add:	ff 4d f8             	decl   -0x8(%ebp)
  801ae0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ae4:	79 e9                	jns    801acf <memset+0x14>
		*p++ = c;

	return v;
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801afd:	eb 16                	jmp    801b15 <memcpy+0x2a>
		*d++ = *s++;
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b02:	8d 50 01             	lea    0x1(%eax),%edx
  801b05:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b0e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b11:	8a 12                	mov    (%edx),%dl
  801b13:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b1b:	89 55 10             	mov    %edx,0x10(%ebp)
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	75 dd                	jne    801aff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b3f:	73 50                	jae    801b91 <memmove+0x6a>
  801b41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b44:	8b 45 10             	mov    0x10(%ebp),%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b4c:	76 43                	jbe    801b91 <memmove+0x6a>
		s += n;
  801b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b51:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b5a:	eb 10                	jmp    801b6c <memmove+0x45>
			*--d = *--s;
  801b5c:	ff 4d f8             	decl   -0x8(%ebp)
  801b5f:	ff 4d fc             	decl   -0x4(%ebp)
  801b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b65:	8a 10                	mov    (%eax),%dl
  801b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b72:	89 55 10             	mov    %edx,0x10(%ebp)
  801b75:	85 c0                	test   %eax,%eax
  801b77:	75 e3                	jne    801b5c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b79:	eb 23                	jmp    801b9e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7e:	8d 50 01             	lea    0x1(%eax),%edx
  801b81:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b8a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b8d:	8a 12                	mov    (%edx),%dl
  801b8f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b91:	8b 45 10             	mov    0x10(%ebp),%eax
  801b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b97:	89 55 10             	mov    %edx,0x10(%ebp)
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	75 dd                	jne    801b7b <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bb5:	eb 2a                	jmp    801be1 <memcmp+0x3e>
		if (*s1 != *s2)
  801bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bba:	8a 10                	mov    (%eax),%dl
  801bbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbf:	8a 00                	mov    (%eax),%al
  801bc1:	38 c2                	cmp    %al,%dl
  801bc3:	74 16                	je     801bdb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	0f b6 d0             	movzbl %al,%edx
  801bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd0:	8a 00                	mov    (%eax),%al
  801bd2:	0f b6 c0             	movzbl %al,%eax
  801bd5:	29 c2                	sub    %eax,%edx
  801bd7:	89 d0                	mov    %edx,%eax
  801bd9:	eb 18                	jmp    801bf3 <memcmp+0x50>
		s1++, s2++;
  801bdb:	ff 45 fc             	incl   -0x4(%ebp)
  801bde:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801be1:	8b 45 10             	mov    0x10(%ebp),%eax
  801be4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801be7:	89 55 10             	mov    %edx,0x10(%ebp)
  801bea:	85 c0                	test   %eax,%eax
  801bec:	75 c9                	jne    801bb7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	01 d0                	add    %edx,%eax
  801c03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c06:	eb 15                	jmp    801c1d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	0f b6 d0             	movzbl %al,%edx
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	0f b6 c0             	movzbl %al,%eax
  801c16:	39 c2                	cmp    %eax,%edx
  801c18:	74 0d                	je     801c27 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c1a:	ff 45 08             	incl   0x8(%ebp)
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c23:	72 e3                	jb     801c08 <memfind+0x13>
  801c25:	eb 01                	jmp    801c28 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c27:	90                   	nop
	return (void *) s;
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c41:	eb 03                	jmp    801c46 <strtol+0x19>
		s++;
  801c43:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	3c 20                	cmp    $0x20,%al
  801c4d:	74 f4                	je     801c43 <strtol+0x16>
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	3c 09                	cmp    $0x9,%al
  801c56:	74 eb                	je     801c43 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8a 00                	mov    (%eax),%al
  801c5d:	3c 2b                	cmp    $0x2b,%al
  801c5f:	75 05                	jne    801c66 <strtol+0x39>
		s++;
  801c61:	ff 45 08             	incl   0x8(%ebp)
  801c64:	eb 13                	jmp    801c79 <strtol+0x4c>
	else if (*s == '-')
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	3c 2d                	cmp    $0x2d,%al
  801c6d:	75 0a                	jne    801c79 <strtol+0x4c>
		s++, neg = 1;
  801c6f:	ff 45 08             	incl   0x8(%ebp)
  801c72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7d:	74 06                	je     801c85 <strtol+0x58>
  801c7f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c83:	75 20                	jne    801ca5 <strtol+0x78>
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	8a 00                	mov    (%eax),%al
  801c8a:	3c 30                	cmp    $0x30,%al
  801c8c:	75 17                	jne    801ca5 <strtol+0x78>
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	40                   	inc    %eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	3c 78                	cmp    $0x78,%al
  801c96:	75 0d                	jne    801ca5 <strtol+0x78>
		s += 2, base = 16;
  801c98:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c9c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ca3:	eb 28                	jmp    801ccd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ca9:	75 15                	jne    801cc0 <strtol+0x93>
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	8a 00                	mov    (%eax),%al
  801cb0:	3c 30                	cmp    $0x30,%al
  801cb2:	75 0c                	jne    801cc0 <strtol+0x93>
		s++, base = 8;
  801cb4:	ff 45 08             	incl   0x8(%ebp)
  801cb7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cbe:	eb 0d                	jmp    801ccd <strtol+0xa0>
	else if (base == 0)
  801cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc4:	75 07                	jne    801ccd <strtol+0xa0>
		base = 10;
  801cc6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	8a 00                	mov    (%eax),%al
  801cd2:	3c 2f                	cmp    $0x2f,%al
  801cd4:	7e 19                	jle    801cef <strtol+0xc2>
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	8a 00                	mov    (%eax),%al
  801cdb:	3c 39                	cmp    $0x39,%al
  801cdd:	7f 10                	jg     801cef <strtol+0xc2>
			dig = *s - '0';
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8a 00                	mov    (%eax),%al
  801ce4:	0f be c0             	movsbl %al,%eax
  801ce7:	83 e8 30             	sub    $0x30,%eax
  801cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ced:	eb 42                	jmp    801d31 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	8a 00                	mov    (%eax),%al
  801cf4:	3c 60                	cmp    $0x60,%al
  801cf6:	7e 19                	jle    801d11 <strtol+0xe4>
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	8a 00                	mov    (%eax),%al
  801cfd:	3c 7a                	cmp    $0x7a,%al
  801cff:	7f 10                	jg     801d11 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8a 00                	mov    (%eax),%al
  801d06:	0f be c0             	movsbl %al,%eax
  801d09:	83 e8 57             	sub    $0x57,%eax
  801d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0f:	eb 20                	jmp    801d31 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	8a 00                	mov    (%eax),%al
  801d16:	3c 40                	cmp    $0x40,%al
  801d18:	7e 39                	jle    801d53 <strtol+0x126>
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	8a 00                	mov    (%eax),%al
  801d1f:	3c 5a                	cmp    $0x5a,%al
  801d21:	7f 30                	jg     801d53 <strtol+0x126>
			dig = *s - 'A' + 10;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8a 00                	mov    (%eax),%al
  801d28:	0f be c0             	movsbl %al,%eax
  801d2b:	83 e8 37             	sub    $0x37,%eax
  801d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d37:	7d 19                	jge    801d52 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d39:	ff 45 08             	incl   0x8(%ebp)
  801d3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d43:	89 c2                	mov    %eax,%edx
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	01 d0                	add    %edx,%eax
  801d4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d4d:	e9 7b ff ff ff       	jmp    801ccd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d52:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d57:	74 08                	je     801d61 <strtol+0x134>
		*endptr = (char *) s;
  801d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d65:	74 07                	je     801d6e <strtol+0x141>
  801d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6a:	f7 d8                	neg    %eax
  801d6c:	eb 03                	jmp    801d71 <strtol+0x144>
  801d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <ltostr>:

void
ltostr(long value, char *str)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d80:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d8b:	79 13                	jns    801da0 <ltostr+0x2d>
	{
		neg = 1;
  801d8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d9a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d9d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801da8:	99                   	cltd   
  801da9:	f7 f9                	idiv   %ecx
  801dab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db1:	8d 50 01             	lea    0x1(%eax),%edx
  801db4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801db7:	89 c2                	mov    %eax,%edx
  801db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbc:	01 d0                	add    %edx,%eax
  801dbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dc1:	83 c2 30             	add    $0x30,%edx
  801dc4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dce:	f7 e9                	imul   %ecx
  801dd0:	c1 fa 02             	sar    $0x2,%edx
  801dd3:	89 c8                	mov    %ecx,%eax
  801dd5:	c1 f8 1f             	sar    $0x1f,%eax
  801dd8:	29 c2                	sub    %eax,%edx
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801de7:	f7 e9                	imul   %ecx
  801de9:	c1 fa 02             	sar    $0x2,%edx
  801dec:	89 c8                	mov    %ecx,%eax
  801dee:	c1 f8 1f             	sar    $0x1f,%eax
  801df1:	29 c2                	sub    %eax,%edx
  801df3:	89 d0                	mov    %edx,%eax
  801df5:	c1 e0 02             	shl    $0x2,%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	01 c0                	add    %eax,%eax
  801dfc:	29 c1                	sub    %eax,%ecx
  801dfe:	89 ca                	mov    %ecx,%edx
  801e00:	85 d2                	test   %edx,%edx
  801e02:	75 9c                	jne    801da0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801e04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801e0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e0e:	48                   	dec    %eax
  801e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e16:	74 3d                	je     801e55 <ltostr+0xe2>
		start = 1 ;
  801e18:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e1f:	eb 34                	jmp    801e55 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	8a 00                	mov    (%eax),%al
  801e2b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 c2                	add    %eax,%edx
  801e36:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3c:	01 c8                	add    %ecx,%eax
  801e3e:	8a 00                	mov    (%eax),%al
  801e40:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	01 c2                	add    %eax,%edx
  801e4a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e4d:	88 02                	mov    %al,(%edx)
		start++ ;
  801e4f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e52:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e5b:	7c c4                	jl     801e21 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e5d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	01 d0                	add    %edx,%eax
  801e65:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e68:	90                   	nop
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	e8 54 fa ff ff       	call   8018cd <strlen>
  801e79:	83 c4 04             	add    $0x4,%esp
  801e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e7f:	ff 75 0c             	pushl  0xc(%ebp)
  801e82:	e8 46 fa ff ff       	call   8018cd <strlen>
  801e87:	83 c4 04             	add    $0x4,%esp
  801e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e9b:	eb 17                	jmp    801eb4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea3:	01 c2                	add    %eax,%edx
  801ea5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	01 c8                	add    %ecx,%eax
  801ead:	8a 00                	mov    (%eax),%al
  801eaf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801eb1:	ff 45 fc             	incl   -0x4(%ebp)
  801eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801eba:	7c e1                	jl     801e9d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ebc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ec3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801eca:	eb 1f                	jmp    801eeb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecf:	8d 50 01             	lea    0x1(%eax),%edx
  801ed2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ed5:	89 c2                	mov    %eax,%edx
  801ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eda:	01 c2                	add    %eax,%edx
  801edc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee2:	01 c8                	add    %ecx,%eax
  801ee4:	8a 00                	mov    (%eax),%al
  801ee6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ee8:	ff 45 f8             	incl   -0x8(%ebp)
  801eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ef1:	7c d9                	jl     801ecc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ef3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	c6 00 00             	movb   $0x0,(%eax)
}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801f04:	8b 45 14             	mov    0x14(%ebp),%eax
  801f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f10:	8b 00                	mov    (%eax),%eax
  801f12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f19:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1c:	01 d0                	add    %edx,%eax
  801f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f24:	eb 0c                	jmp    801f32 <strsplit+0x31>
			*string++ = 0;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8d 50 01             	lea    0x1(%eax),%edx
  801f2c:	89 55 08             	mov    %edx,0x8(%ebp)
  801f2f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	8a 00                	mov    (%eax),%al
  801f37:	84 c0                	test   %al,%al
  801f39:	74 18                	je     801f53 <strsplit+0x52>
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8a 00                	mov    (%eax),%al
  801f40:	0f be c0             	movsbl %al,%eax
  801f43:	50                   	push   %eax
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	e8 13 fb ff ff       	call   801a5f <strchr>
  801f4c:	83 c4 08             	add    $0x8,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	75 d3                	jne    801f26 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	8a 00                	mov    (%eax),%al
  801f58:	84 c0                	test   %al,%al
  801f5a:	74 5a                	je     801fb6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5f:	8b 00                	mov    (%eax),%eax
  801f61:	83 f8 0f             	cmp    $0xf,%eax
  801f64:	75 07                	jne    801f6d <strsplit+0x6c>
		{
			return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	eb 66                	jmp    801fd3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f70:	8b 00                	mov    (%eax),%eax
  801f72:	8d 48 01             	lea    0x1(%eax),%ecx
  801f75:	8b 55 14             	mov    0x14(%ebp),%edx
  801f78:	89 0a                	mov    %ecx,(%edx)
  801f7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f81:	8b 45 10             	mov    0x10(%ebp),%eax
  801f84:	01 c2                	add    %eax,%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f8b:	eb 03                	jmp    801f90 <strsplit+0x8f>
			string++;
  801f8d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	8a 00                	mov    (%eax),%al
  801f95:	84 c0                	test   %al,%al
  801f97:	74 8b                	je     801f24 <strsplit+0x23>
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8a 00                	mov    (%eax),%al
  801f9e:	0f be c0             	movsbl %al,%eax
  801fa1:	50                   	push   %eax
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	e8 b5 fa ff ff       	call   801a5f <strchr>
  801faa:	83 c4 08             	add    $0x8,%esp
  801fad:	85 c0                	test   %eax,%eax
  801faf:	74 dc                	je     801f8d <strsplit+0x8c>
			string++;
	}
  801fb1:	e9 6e ff ff ff       	jmp    801f24 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fb6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801fba:	8b 00                	mov    (%eax),%eax
  801fbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc6:	01 d0                	add    %edx,%eax
  801fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801fdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fe2:	eb 4c                	jmp    802030 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801fe4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	01 d0                	add    %edx,%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 40                	cmp    $0x40,%al
  801ff0:	7e 27                	jle    802019 <str2lower+0x44>
  801ff2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff8:	01 d0                	add    %edx,%eax
  801ffa:	8a 00                	mov    (%eax),%al
  801ffc:	3c 5a                	cmp    $0x5a,%al
  801ffe:	7f 19                	jg     802019 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  802000:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80200b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200e:	01 ca                	add    %ecx,%edx
  802010:	8a 12                	mov    (%edx),%dl
  802012:	83 c2 20             	add    $0x20,%edx
  802015:	88 10                	mov    %dl,(%eax)
  802017:	eb 14                	jmp    80202d <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  802019:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	01 c2                	add    %eax,%edx
  802021:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	01 c8                	add    %ecx,%eax
  802029:	8a 00                	mov    (%eax),%al
  80202b:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80202d:	ff 45 fc             	incl   -0x4(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	e8 95 f8 ff ff       	call   8018cd <strlen>
  802038:	83 c4 04             	add    $0x4,%esp
  80203b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80203e:	7f a4                	jg     801fe4 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  802048:	a1 04 50 80 00       	mov    0x805004,%eax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	74 0a                	je     80205b <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802051:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802058:	00 00 00 
	}
}
  80205b:	90                   	nop
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    

0080205e <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802064:	83 ec 0c             	sub    $0xc,%esp
  802067:	ff 75 08             	pushl  0x8(%ebp)
  80206a:	e8 7e 09 00 00       	call   8029ed <sys_sbrk>
  80206f:	83 c4 10             	add    $0x10,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80207a:	e8 c6 ff ff ff       	call   802045 <InitializeUHeap>
	if (size == 0)
  80207f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802083:	75 0a                	jne    80208f <malloc+0x1b>
		return NULL;
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	e9 3f 01 00 00       	jmp    8021ce <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80208f:	e8 ac 09 00 00       	call   802a40 <sys_get_hard_limit>
  802094:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  802097:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  80209e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8020a6:	c1 e8 0c             	shr    $0xc,%eax
  8020a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8020ac:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8020b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020b9:	01 d0                	add    %edx,%eax
  8020bb:	48                   	dec    %eax
  8020bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8020bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c7:	f7 75 d8             	divl   -0x28(%ebp)
  8020ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020cd:	29 d0                	sub    %edx,%eax
  8020cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8020d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020d5:	c1 e8 0c             	shr    $0xc,%eax
  8020d8:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8020db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020df:	75 0a                	jne    8020eb <malloc+0x77>
		return NULL;
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	e9 e3 00 00 00       	jmp    8021ce <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8020eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ee:	05 00 00 00 80       	add    $0x80000000,%eax
  8020f3:	c1 e8 0c             	shr    $0xc,%eax
  8020f6:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8020fb:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802102:	77 19                	ja     80211d <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	e8 60 0b 00 00       	call   802c6f <alloc_block_FF>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  802115:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802118:	e9 b1 00 00 00       	jmp    8021ce <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80211d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802120:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802123:	eb 4d                	jmp    802172 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  802125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802128:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  80212f:	84 c0                	test   %al,%al
  802131:	75 27                	jne    80215a <malloc+0xe6>
			{
				counter++;
  802133:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  802136:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80213a:	75 14                	jne    802150 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80213c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213f:	05 00 00 08 00       	add    $0x80000,%eax
  802144:	c1 e0 0c             	shl    $0xc,%eax
  802147:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  80214a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80214d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  802150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802153:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802156:	75 17                	jne    80216f <malloc+0xfb>
				{
					break;
  802158:	eb 21                	jmp    80217b <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  80215a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215d:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  802164:	3c 01                	cmp    $0x1,%al
  802166:	75 07                	jne    80216f <malloc+0xfb>
			{
				counter = 0;
  802168:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80216f:	ff 45 e8             	incl   -0x18(%ebp)
  802172:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  802179:	76 aa                	jbe    802125 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80217b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802181:	75 46                	jne    8021c9 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  802183:	83 ec 08             	sub    $0x8,%esp
  802186:	ff 75 d0             	pushl  -0x30(%ebp)
  802189:	ff 75 f4             	pushl  -0xc(%ebp)
  80218c:	e8 93 08 00 00       	call   802a24 <sys_allocate_user_mem>
  802191:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80219a:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021a7:	eb 0e                	jmp    8021b7 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8021a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ac:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  8021b3:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8021b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8021b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	01 d0                	add    %edx,%eax
  8021bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021c2:	77 e5                	ja     8021a9 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	eb 05                	jmp    8021ce <malloc+0x15a>
		}
	}

	return NULL;
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8021d6:	e8 65 08 00 00       	call   802a40 <sys_get_hard_limit>
  8021db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8021e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e8:	0f 84 c1 00 00 00    	je     8022af <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	79 1b                	jns    802210 <free+0x40>
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021fb:	73 13                	jae    802210 <free+0x40>
    {
        free_block(virtual_address);
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	e8 34 10 00 00       	call   80323c <free_block>
  802208:	83 c4 10             	add    $0x10,%esp
    	return;
  80220b:	e9 a6 00 00 00       	jmp    8022b6 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  802210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802213:	05 00 10 00 00       	add    $0x1000,%eax
  802218:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80221b:	0f 87 91 00 00 00    	ja     8022b2 <free+0xe2>
  802221:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802228:	0f 87 84 00 00 00    	ja     8022b2 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80222e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802231:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802237:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80223c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80223f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802242:	05 00 00 00 80       	add    $0x80000000,%eax
  802247:	c1 e8 0c             	shr    $0xc,%eax
  80224a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80224d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802250:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  802257:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  80225a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80225e:	74 55                	je     8022b5 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  802260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802263:	c1 e8 0c             	shr    $0xc,%eax
  802266:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  802269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80226c:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  802273:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  802277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227d:	eb 0e                	jmp    80228d <free+0xbd>
	{
		userArr[i].is_allocated=0;
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  802289:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  80228a:	ff 45 f4             	incl   -0xc(%ebp)
  80228d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802293:	01 c2                	add    %eax,%edx
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	39 c2                	cmp    %eax,%edx
  80229a:	77 e3                	ja     80227f <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80229c:	83 ec 08             	sub    $0x8,%esp
  80229f:	ff 75 e0             	pushl  -0x20(%ebp)
  8022a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8022a5:	e8 5e 07 00 00       	call   802a08 <sys_free_user_mem>
  8022aa:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8022ad:	eb 07                	jmp    8022b6 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8022af:	90                   	nop
  8022b0:	eb 04                	jmp    8022b6 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8022b2:	90                   	nop
  8022b3:	eb 01                	jmp    8022b6 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8022b5:	90                   	nop
    else
     {
    	return;
      }

}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 18             	sub    $0x18,%esp
  8022be:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022c4:	e8 7c fd ff ff       	call   802045 <InitializeUHeap>
	if (size == 0)
  8022c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022cd:	75 07                	jne    8022d6 <smalloc+0x1e>
		return NULL;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	eb 17                	jmp    8022ed <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 30 46 80 00       	push   $0x804630
  8022de:	68 ad 00 00 00       	push   $0xad
  8022e3:	68 56 46 80 00       	push   $0x804656
  8022e8:	e8 a1 ec ff ff       	call   800f8e <_panic>
	return NULL;
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022f5:	e8 4b fd ff ff       	call   802045 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	68 64 46 80 00       	push   $0x804664
  802302:	68 ba 00 00 00       	push   $0xba
  802307:	68 56 46 80 00       	push   $0x804656
  80230c:	e8 7d ec ff ff       	call   800f8e <_panic>

00802311 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802317:	e8 29 fd ff ff       	call   802045 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 88 46 80 00       	push   $0x804688
  802324:	68 d8 00 00 00       	push   $0xd8
  802329:	68 56 46 80 00       	push   $0x804656
  80232e:	e8 5b ec ff ff       	call   800f8e <_panic>

00802333 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 b0 46 80 00       	push   $0x8046b0
  802341:	68 ea 00 00 00       	push   $0xea
  802346:	68 56 46 80 00       	push   $0x804656
  80234b:	e8 3e ec ff ff       	call   800f8e <_panic>

00802350 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 d4 46 80 00       	push   $0x8046d4
  80235e:	68 f2 00 00 00       	push   $0xf2
  802363:	68 56 46 80 00       	push   $0x804656
  802368:	e8 21 ec ff ff       	call   800f8e <_panic>

0080236d <shrink>:

}
void shrink(uint32 newSize) {
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 d4 46 80 00       	push   $0x8046d4
  80237b:	68 f6 00 00 00       	push   $0xf6
  802380:	68 56 46 80 00       	push   $0x804656
  802385:	e8 04 ec ff ff       	call   800f8e <_panic>

0080238a <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	68 d4 46 80 00       	push   $0x8046d4
  802398:	68 fa 00 00 00       	push   $0xfa
  80239d:	68 56 46 80 00       	push   $0x804656
  8023a2:	e8 e7 eb ff ff       	call   800f8e <_panic>

008023a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	57                   	push   %edi
  8023ab:	56                   	push   %esi
  8023ac:	53                   	push   %ebx
  8023ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023c2:	cd 30                	int    $0x30
  8023c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023ca:	83 c4 10             	add    $0x10,%esp
  8023cd:	5b                   	pop    %ebx
  8023ce:	5e                   	pop    %esi
  8023cf:	5f                   	pop    %edi
  8023d0:	5d                   	pop    %ebp
  8023d1:	c3                   	ret    

008023d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	52                   	push   %edx
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	50                   	push   %eax
  8023ee:	6a 00                	push   $0x0
  8023f0:	e8 b2 ff ff ff       	call   8023a7 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	90                   	nop
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 01                	push   $0x1
  80240a:	e8 98 ff ff ff       	call   8023a7 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	6a 05                	push   $0x5
  802427:	e8 7b ff ff ff       	call   8023a7 <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	56                   	push   %esi
  802435:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802436:	8b 75 18             	mov    0x18(%ebp),%esi
  802439:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80243c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	56                   	push   %esi
  802446:	53                   	push   %ebx
  802447:	51                   	push   %ecx
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	6a 06                	push   $0x6
  80244c:	e8 56 ff ff ff       	call   8023a7 <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802457:	5b                   	pop    %ebx
  802458:	5e                   	pop    %esi
  802459:	5d                   	pop    %ebp
  80245a:	c3                   	ret    

0080245b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80245e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	52                   	push   %edx
  80246b:	50                   	push   %eax
  80246c:	6a 07                	push   $0x7
  80246e:	e8 34 ff ff ff       	call   8023a7 <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	ff 75 08             	pushl  0x8(%ebp)
  802487:	6a 08                	push   $0x8
  802489:	e8 19 ff ff ff       	call   8023a7 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 09                	push   $0x9
  8024a2:	e8 00 ff ff ff       	call   8023a7 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 0a                	push   $0xa
  8024bb:	e8 e7 fe ff ff       	call   8023a7 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 0b                	push   $0xb
  8024d4:	e8 ce fe ff ff       	call   8023a7 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 0c                	push   $0xc
  8024ed:	e8 b5 fe ff ff       	call   8023a7 <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	6a 0d                	push   $0xd
  802507:	e8 9b fe ff ff       	call   8023a7 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 0e                	push   $0xe
  802520:	e8 82 fe ff ff       	call   8023a7 <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	90                   	nop
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 11                	push   $0x11
  80253a:	e8 68 fe ff ff       	call   8023a7 <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	90                   	nop
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 12                	push   $0x12
  802554:	e8 4e fe ff ff       	call   8023a7 <syscall>
  802559:	83 c4 18             	add    $0x18,%esp
}
  80255c:	90                   	nop
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <sys_cputc>:


void
sys_cputc(const char c)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80256b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	50                   	push   %eax
  802578:	6a 13                	push   $0x13
  80257a:	e8 28 fe ff ff       	call   8023a7 <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
}
  802582:	90                   	nop
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 14                	push   $0x14
  802594:	e8 0e fe ff ff       	call   8023a7 <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
}
  80259c:	90                   	nop
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	ff 75 0c             	pushl  0xc(%ebp)
  8025ae:	50                   	push   %eax
  8025af:	6a 15                	push   $0x15
  8025b1:	e8 f1 fd ff ff       	call   8023a7 <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	52                   	push   %edx
  8025cb:	50                   	push   %eax
  8025cc:	6a 18                	push   $0x18
  8025ce:	e8 d4 fd ff ff       	call   8023a7 <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	52                   	push   %edx
  8025e8:	50                   	push   %eax
  8025e9:	6a 16                	push   $0x16
  8025eb:	e8 b7 fd ff ff       	call   8023a7 <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	90                   	nop
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	52                   	push   %edx
  802606:	50                   	push   %eax
  802607:	6a 17                	push   $0x17
  802609:	e8 99 fd ff ff       	call   8023a7 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
}
  802611:	90                   	nop
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	8b 45 10             	mov    0x10(%ebp),%eax
  80261d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802620:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802623:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	51                   	push   %ecx
  80262d:	52                   	push   %edx
  80262e:	ff 75 0c             	pushl  0xc(%ebp)
  802631:	50                   	push   %eax
  802632:	6a 19                	push   $0x19
  802634:	e8 6e fd ff ff       	call   8023a7 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802641:	8b 55 0c             	mov    0xc(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	52                   	push   %edx
  80264e:	50                   	push   %eax
  80264f:	6a 1a                	push   $0x1a
  802651:	e8 51 fd ff ff       	call   8023a7 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80265e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802661:	8b 55 0c             	mov    0xc(%ebp),%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	51                   	push   %ecx
  80266c:	52                   	push   %edx
  80266d:	50                   	push   %eax
  80266e:	6a 1b                	push   $0x1b
  802670:	e8 32 fd ff ff       	call   8023a7 <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80267d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	52                   	push   %edx
  80268a:	50                   	push   %eax
  80268b:	6a 1c                	push   $0x1c
  80268d:	e8 15 fd ff ff       	call   8023a7 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 1d                	push   $0x1d
  8026a6:	e8 fc fc ff ff       	call   8023a7 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	6a 00                	push   $0x0
  8026b8:	ff 75 14             	pushl  0x14(%ebp)
  8026bb:	ff 75 10             	pushl  0x10(%ebp)
  8026be:	ff 75 0c             	pushl  0xc(%ebp)
  8026c1:	50                   	push   %eax
  8026c2:	6a 1e                	push   $0x1e
  8026c4:	e8 de fc ff ff       	call   8023a7 <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	50                   	push   %eax
  8026dd:	6a 1f                	push   $0x1f
  8026df:	e8 c3 fc ff ff       	call   8023a7 <syscall>
  8026e4:	83 c4 18             	add    $0x18,%esp
}
  8026e7:	90                   	nop
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	50                   	push   %eax
  8026f9:	6a 20                	push   $0x20
  8026fb:	e8 a7 fc ff ff       	call   8023a7 <syscall>
  802700:	83 c4 18             	add    $0x18,%esp
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    

00802705 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 02                	push   $0x2
  802714:	e8 8e fc ff ff       	call   8023a7 <syscall>
  802719:	83 c4 18             	add    $0x18,%esp
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 03                	push   $0x3
  80272d:	e8 75 fc ff ff       	call   8023a7 <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 04                	push   $0x4
  802746:	e8 5c fc ff ff       	call   8023a7 <syscall>
  80274b:	83 c4 18             	add    $0x18,%esp
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <sys_exit_env>:


void sys_exit_env(void)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 21                	push   $0x21
  80275f:	e8 43 fc ff ff       	call   8023a7 <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
}
  802767:	90                   	nop
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802770:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802773:	8d 50 04             	lea    0x4(%eax),%edx
  802776:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	52                   	push   %edx
  802780:	50                   	push   %eax
  802781:	6a 22                	push   $0x22
  802783:	e8 1f fc ff ff       	call   8023a7 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
	return result;
  80278b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80278e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802791:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802794:	89 01                	mov    %eax,(%ecx)
  802796:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	c9                   	leave  
  80279d:	c2 04 00             	ret    $0x4

008027a0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	ff 75 10             	pushl  0x10(%ebp)
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	ff 75 08             	pushl  0x8(%ebp)
  8027b0:	6a 10                	push   $0x10
  8027b2:	e8 f0 fb ff ff       	call   8023a7 <syscall>
  8027b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ba:	90                   	nop
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <sys_rcr2>:
uint32 sys_rcr2()
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 23                	push   $0x23
  8027cc:	e8 d6 fb ff ff       	call   8023a7 <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027e2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	50                   	push   %eax
  8027ef:	6a 24                	push   $0x24
  8027f1:	e8 b1 fb ff ff       	call   8023a7 <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f9:	90                   	nop
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <rsttst>:
void rsttst()
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 26                	push   $0x26
  80280b:	e8 97 fb ff ff       	call   8023a7 <syscall>
  802810:	83 c4 18             	add    $0x18,%esp
	return ;
  802813:	90                   	nop
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	8b 45 14             	mov    0x14(%ebp),%eax
  80281f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802822:	8b 55 18             	mov    0x18(%ebp),%edx
  802825:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802829:	52                   	push   %edx
  80282a:	50                   	push   %eax
  80282b:	ff 75 10             	pushl  0x10(%ebp)
  80282e:	ff 75 0c             	pushl  0xc(%ebp)
  802831:	ff 75 08             	pushl  0x8(%ebp)
  802834:	6a 25                	push   $0x25
  802836:	e8 6c fb ff ff       	call   8023a7 <syscall>
  80283b:	83 c4 18             	add    $0x18,%esp
	return ;
  80283e:	90                   	nop
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <chktst>:
void chktst(uint32 n)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	ff 75 08             	pushl  0x8(%ebp)
  80284f:	6a 27                	push   $0x27
  802851:	e8 51 fb ff ff       	call   8023a7 <syscall>
  802856:	83 c4 18             	add    $0x18,%esp
	return ;
  802859:	90                   	nop
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <inctst>:

void inctst()
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 28                	push   $0x28
  80286b:	e8 37 fb ff ff       	call   8023a7 <syscall>
  802870:	83 c4 18             	add    $0x18,%esp
	return ;
  802873:	90                   	nop
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <gettst>:
uint32 gettst()
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 29                	push   $0x29
  802885:	e8 1d fb ff ff       	call   8023a7 <syscall>
  80288a:	83 c4 18             	add    $0x18,%esp
}
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 2a                	push   $0x2a
  8028a1:	e8 01 fb ff ff       	call   8023a7 <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
  8028a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028ac:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028b0:	75 07                	jne    8028b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b7:	eb 05                	jmp    8028be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 2a                	push   $0x2a
  8028d2:	e8 d0 fa ff ff       	call   8023a7 <syscall>
  8028d7:	83 c4 18             	add    $0x18,%esp
  8028da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028dd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028e1:	75 07                	jne    8028ea <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e8:	eb 05                	jmp    8028ef <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ef:	c9                   	leave  
  8028f0:	c3                   	ret    

008028f1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 2a                	push   $0x2a
  802903:	e8 9f fa ff ff       	call   8023a7 <syscall>
  802908:	83 c4 18             	add    $0x18,%esp
  80290b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80290e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802912:	75 07                	jne    80291b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802914:	b8 01 00 00 00       	mov    $0x1,%eax
  802919:	eb 05                	jmp    802920 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 2a                	push   $0x2a
  802934:	e8 6e fa ff ff       	call   8023a7 <syscall>
  802939:	83 c4 18             	add    $0x18,%esp
  80293c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80293f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802943:	75 07                	jne    80294c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802945:	b8 01 00 00 00       	mov    $0x1,%eax
  80294a:	eb 05                	jmp    802951 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	ff 75 08             	pushl  0x8(%ebp)
  802961:	6a 2b                	push   $0x2b
  802963:	e8 3f fa ff ff       	call   8023a7 <syscall>
  802968:	83 c4 18             	add    $0x18,%esp
	return ;
  80296b:	90                   	nop
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802972:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802975:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	6a 00                	push   $0x0
  802980:	53                   	push   %ebx
  802981:	51                   	push   %ecx
  802982:	52                   	push   %edx
  802983:	50                   	push   %eax
  802984:	6a 2c                	push   $0x2c
  802986:	e8 1c fa ff ff       	call   8023a7 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802996:	8b 55 0c             	mov    0xc(%ebp),%edx
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	52                   	push   %edx
  8029a3:	50                   	push   %eax
  8029a4:	6a 2d                	push   $0x2d
  8029a6:	e8 fc f9 ff ff       	call   8023a7 <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
}
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8029b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	6a 00                	push   $0x0
  8029be:	51                   	push   %ecx
  8029bf:	ff 75 10             	pushl  0x10(%ebp)
  8029c2:	52                   	push   %edx
  8029c3:	50                   	push   %eax
  8029c4:	6a 2e                	push   $0x2e
  8029c6:	e8 dc f9 ff ff       	call   8023a7 <syscall>
  8029cb:	83 c4 18             	add    $0x18,%esp
}
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	ff 75 10             	pushl  0x10(%ebp)
  8029da:	ff 75 0c             	pushl  0xc(%ebp)
  8029dd:	ff 75 08             	pushl  0x8(%ebp)
  8029e0:	6a 0f                	push   $0xf
  8029e2:	e8 c0 f9 ff ff       	call   8023a7 <syscall>
  8029e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ea:	90                   	nop
}
  8029eb:	c9                   	leave  
  8029ec:	c3                   	ret    

008029ed <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	50                   	push   %eax
  8029fc:	6a 2f                	push   $0x2f
  8029fe:	e8 a4 f9 ff ff       	call   8023a7 <syscall>
  802a03:	83 c4 18             	add    $0x18,%esp

}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	ff 75 0c             	pushl  0xc(%ebp)
  802a14:	ff 75 08             	pushl  0x8(%ebp)
  802a17:	6a 30                	push   $0x30
  802a19:	e8 89 f9 ff ff       	call   8023a7 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
	return;
  802a21:	90                   	nop
}
  802a22:	c9                   	leave  
  802a23:	c3                   	ret    

00802a24 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a24:	55                   	push   %ebp
  802a25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	ff 75 0c             	pushl  0xc(%ebp)
  802a30:	ff 75 08             	pushl  0x8(%ebp)
  802a33:	6a 31                	push   $0x31
  802a35:	e8 6d f9 ff ff       	call   8023a7 <syscall>
  802a3a:	83 c4 18             	add    $0x18,%esp
	return;
  802a3d:	90                   	nop
}
  802a3e:	c9                   	leave  
  802a3f:	c3                   	ret    

00802a40 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 32                	push   $0x32
  802a4f:	e8 53 f9 ff ff       	call   8023a7 <syscall>
  802a54:	83 c4 18             	add    $0x18,%esp
}
  802a57:	c9                   	leave  
  802a58:	c3                   	ret    

00802a59 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	50                   	push   %eax
  802a68:	6a 33                	push   $0x33
  802a6a:	e8 38 f9 ff ff       	call   8023a7 <syscall>
  802a6f:	83 c4 18             	add    $0x18,%esp
}
  802a72:	90                   	nop
  802a73:	c9                   	leave  
  802a74:	c3                   	ret    

00802a75 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	83 e8 10             	sub    $0x10,%eax
  802a81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	83 e8 10             	sub    $0x10,%eax
  802a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a9d:	8a 40 04             	mov    0x4(%eax),%al
}
  802aa0:	c9                   	leave  
  802aa1:	c3                   	ret    

00802aa2 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802aa2:	55                   	push   %ebp
  802aa3:	89 e5                	mov    %esp,%ebp
  802aa5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802aa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab2:	83 f8 02             	cmp    $0x2,%eax
  802ab5:	74 2b                	je     802ae2 <alloc_block+0x40>
  802ab7:	83 f8 02             	cmp    $0x2,%eax
  802aba:	7f 07                	jg     802ac3 <alloc_block+0x21>
  802abc:	83 f8 01             	cmp    $0x1,%eax
  802abf:	74 0e                	je     802acf <alloc_block+0x2d>
  802ac1:	eb 58                	jmp    802b1b <alloc_block+0x79>
  802ac3:	83 f8 03             	cmp    $0x3,%eax
  802ac6:	74 2d                	je     802af5 <alloc_block+0x53>
  802ac8:	83 f8 04             	cmp    $0x4,%eax
  802acb:	74 3b                	je     802b08 <alloc_block+0x66>
  802acd:	eb 4c                	jmp    802b1b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802acf:	83 ec 0c             	sub    $0xc,%esp
  802ad2:	ff 75 08             	pushl  0x8(%ebp)
  802ad5:	e8 95 01 00 00       	call   802c6f <alloc_block_FF>
  802ada:	83 c4 10             	add    $0x10,%esp
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ae0:	eb 4a                	jmp    802b2c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ae2:	83 ec 0c             	sub    $0xc,%esp
  802ae5:	ff 75 08             	pushl  0x8(%ebp)
  802ae8:	e8 32 07 00 00       	call   80321f <alloc_block_NF>
  802aed:	83 c4 10             	add    $0x10,%esp
  802af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802af3:	eb 37                	jmp    802b2c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802af5:	83 ec 0c             	sub    $0xc,%esp
  802af8:	ff 75 08             	pushl  0x8(%ebp)
  802afb:	e8 a3 04 00 00       	call   802fa3 <alloc_block_BF>
  802b00:	83 c4 10             	add    $0x10,%esp
  802b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b06:	eb 24                	jmp    802b2c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802b08:	83 ec 0c             	sub    $0xc,%esp
  802b0b:	ff 75 08             	pushl  0x8(%ebp)
  802b0e:	e8 ef 06 00 00       	call   803202 <alloc_block_WF>
  802b13:	83 c4 10             	add    $0x10,%esp
  802b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b19:	eb 11                	jmp    802b2c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802b1b:	83 ec 0c             	sub    $0xc,%esp
  802b1e:	68 e4 46 80 00       	push   $0x8046e4
  802b23:	e8 23 e7 ff ff       	call   80124b <cprintf>
  802b28:	83 c4 10             	add    $0x10,%esp
		break;
  802b2b:	90                   	nop
	}
	return va;
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b2f:	c9                   	leave  
  802b30:	c3                   	ret    

00802b31 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
  802b34:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802b37:	83 ec 0c             	sub    $0xc,%esp
  802b3a:	68 04 47 80 00       	push   $0x804704
  802b3f:	e8 07 e7 ff ff       	call   80124b <cprintf>
  802b44:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802b47:	83 ec 0c             	sub    $0xc,%esp
  802b4a:	68 2f 47 80 00       	push   $0x80472f
  802b4f:	e8 f7 e6 ff ff       	call   80124b <cprintf>
  802b54:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5d:	eb 26                	jmp    802b85 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8a 40 04             	mov    0x4(%eax),%al
  802b65:	0f b6 d0             	movzbl %al,%edx
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	52                   	push   %edx
  802b71:	50                   	push   %eax
  802b72:	68 47 47 80 00       	push   $0x804747
  802b77:	e8 cf e6 ff ff       	call   80124b <cprintf>
  802b7c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	74 08                	je     802b93 <print_blocks_list+0x62>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 08             	mov    0x8(%eax),%eax
  802b91:	eb 05                	jmp    802b98 <print_blocks_list+0x67>
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	89 45 10             	mov    %eax,0x10(%ebp)
  802b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 bd                	jne    802b5f <print_blocks_list+0x2e>
  802ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba6:	75 b7                	jne    802b5f <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802ba8:	83 ec 0c             	sub    $0xc,%esp
  802bab:	68 04 47 80 00       	push   $0x804704
  802bb0:	e8 96 e6 ff ff       	call   80124b <cprintf>
  802bb5:	83 c4 10             	add    $0x10,%esp

}
  802bb8:	90                   	nop
  802bb9:	c9                   	leave  
  802bba:	c3                   	ret    

00802bbb <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
  802bbe:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc5:	0f 84 a1 00 00 00    	je     802c6c <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802bcb:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802bd2:	00 00 00 
	LIST_INIT(&list);
  802bd5:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802bdc:	00 00 00 
  802bdf:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  802be6:	00 00 00 
  802be9:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802bf0:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c06:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0c:	75 14                	jne    802c22 <initialize_dynamic_allocator+0x67>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 60 47 80 00       	push   $0x804760
  802c16:	6a 64                	push   $0x64
  802c18:	68 83 47 80 00       	push   $0x804783
  802c1d:	e8 6c e3 ff ff       	call   800f8e <_panic>
  802c22:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	89 50 0c             	mov    %edx,0xc(%eax)
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 40 0c             	mov    0xc(%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 0d                	je     802c45 <initialize_dynamic_allocator+0x8a>
  802c38:	a1 44 51 90 00       	mov    0x905144,%eax
  802c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c40:	89 50 08             	mov    %edx,0x8(%eax)
  802c43:	eb 08                	jmp    802c4d <initialize_dynamic_allocator+0x92>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	a3 40 51 90 00       	mov    %eax,0x905140
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	a3 44 51 90 00       	mov    %eax,0x905144
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c5f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c64:	40                   	inc    %eax
  802c65:	a3 4c 51 90 00       	mov    %eax,0x90514c
  802c6a:	eb 01                	jmp    802c6d <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802c6c:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802c75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c79:	75 0a                	jne    802c85 <alloc_block_FF+0x16>
	{
		return NULL;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	e9 1c 03 00 00       	jmp    802fa1 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802c85:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	75 40                	jne    802cce <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	83 c0 10             	add    $0x10,%eax
  802c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	83 ec 0c             	sub    $0xc,%esp
  802c9d:	50                   	push   %eax
  802c9e:	e8 bb f3 ff ff       	call   80205e <sbrk>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802ca9:	83 ec 0c             	sub    $0xc,%esp
  802cac:	6a 00                	push   $0x0
  802cae:	e8 ab f3 ff ff       	call   80205e <sbrk>
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbc:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802cbf:	83 ec 08             	sub    $0x8,%esp
  802cc2:	50                   	push   %eax
  802cc3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc6:	e8 f0 fe ff ff       	call   802bbb <initialize_dynamic_allocator>
  802ccb:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802cce:	a1 40 51 90 00       	mov    0x905140,%eax
  802cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd6:	e9 1e 01 00 00       	jmp    802df9 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8d 50 10             	lea    0x10(%eax),%edx
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	39 c2                	cmp    %eax,%edx
  802ce8:	75 1c                	jne    802d06 <alloc_block_FF+0x97>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8a 40 04             	mov    0x4(%eax),%al
  802cf0:	3c 01                	cmp    $0x1,%al
  802cf2:	75 12                	jne    802d06 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	83 c0 10             	add    $0x10,%eax
  802d01:	e9 9b 02 00 00       	jmp    802fa1 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8d 50 10             	lea    0x10(%eax),%edx
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	39 c2                	cmp    %eax,%edx
  802d13:	0f 83 d8 00 00 00    	jae    802df1 <alloc_block_FF+0x182>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8a 40 04             	mov    0x4(%eax),%al
  802d1f:	3c 01                	cmp    $0x1,%al
  802d21:	0f 85 ca 00 00 00    	jne    802df1 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2f:	83 e8 10             	sub    $0x10,%eax
  802d32:	83 f8 0f             	cmp    $0xf,%eax
  802d35:	0f 86 a4 00 00 00    	jbe    802ddf <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	01 d0                	add    %edx,%eax
  802d43:	83 c0 10             	add    $0x10,%eax
  802d46:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d51:	8d 50 f0             	lea    -0x10(%eax),%edx
  802d54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d57:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802d59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d5c:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d64:	74 06                	je     802d6c <alloc_block_FF+0xfd>
  802d66:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d6a:	75 17                	jne    802d83 <alloc_block_FF+0x114>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 9c 47 80 00       	push   $0x80479c
  802d74:	68 8f 00 00 00       	push   $0x8f
  802d79:	68 83 47 80 00       	push   $0x804783
  802d7e:	e8 0b e2 ff ff       	call   800f8e <_panic>
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 50 08             	mov    0x8(%eax),%edx
  802d89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d8c:	89 50 08             	mov    %edx,0x8(%eax)
  802d8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d92:	8b 40 08             	mov    0x8(%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 0c                	je     802da5 <alloc_block_FF+0x136>
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 40 08             	mov    0x8(%eax),%eax
  802d9f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802da2:	89 50 0c             	mov    %edx,0xc(%eax)
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dab:	89 50 08             	mov    %edx,0x8(%eax)
  802dae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db4:	89 50 0c             	mov    %edx,0xc(%eax)
  802db7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dba:	8b 40 08             	mov    0x8(%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	75 08                	jne    802dc9 <alloc_block_FF+0x15a>
  802dc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc4:	a3 44 51 90 00       	mov    %eax,0x905144
  802dc9:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802dce:	40                   	inc    %eax
  802dcf:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8d 50 10             	lea    0x10(%eax),%edx
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	83 c0 10             	add    $0x10,%eax
  802dec:	e9 b0 01 00 00       	jmp    802fa1 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802df1:	a1 48 51 90 00       	mov    0x905148,%eax
  802df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfd:	74 08                	je     802e07 <alloc_block_FF+0x198>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	eb 05                	jmp    802e0c <alloc_block_FF+0x19d>
  802e07:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0c:	a3 48 51 90 00       	mov    %eax,0x905148
  802e11:	a1 48 51 90 00       	mov    0x905148,%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	0f 85 bd fe ff ff    	jne    802cdb <alloc_block_FF+0x6c>
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e22:	0f 85 b3 fe ff ff    	jne    802cdb <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	83 c0 10             	add    $0x10,%eax
  802e2e:	83 ec 0c             	sub    $0xc,%esp
  802e31:	50                   	push   %eax
  802e32:	e8 27 f2 ff ff       	call   80205e <sbrk>
  802e37:	83 c4 10             	add    $0x10,%esp
  802e3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802e3d:	83 ec 0c             	sub    $0xc,%esp
  802e40:	6a 00                	push   $0x0
  802e42:	e8 17 f2 ff ff       	call   80205e <sbrk>
  802e47:	83 c4 10             	add    $0x10,%esp
  802e4a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802e4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e53:	29 c2                	sub    %eax,%edx
  802e55:	89 d0                	mov    %edx,%eax
  802e57:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802e5a:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802e5e:	0f 84 38 01 00 00    	je     802f9c <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e67:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802e6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e6e:	75 17                	jne    802e87 <alloc_block_FF+0x218>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 60 47 80 00       	push   $0x804760
  802e78:	68 9f 00 00 00       	push   $0x9f
  802e7d:	68 83 47 80 00       	push   $0x804783
  802e82:	e8 07 e1 ff ff       	call   800f8e <_panic>
  802e87:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802e8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e90:	89 50 0c             	mov    %edx,0xc(%eax)
  802e93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e96:	8b 40 0c             	mov    0xc(%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 0d                	je     802eaa <alloc_block_FF+0x23b>
  802e9d:	a1 44 51 90 00       	mov    0x905144,%eax
  802ea2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ea5:	89 50 08             	mov    %edx,0x8(%eax)
  802ea8:	eb 08                	jmp    802eb2 <alloc_block_FF+0x243>
  802eaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ead:	a3 40 51 90 00       	mov    %eax,0x905140
  802eb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802eb5:	a3 44 51 90 00       	mov    %eax,0x905144
  802eba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ebd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ec4:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ec9:	40                   	inc    %eax
  802eca:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8d 50 10             	lea    0x10(%eax),%edx
  802ed5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ed8:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802eda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802edd:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802ee1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee7:	83 f8 10             	cmp    $0x10,%eax
  802eea:	0f 84 a4 00 00 00    	je     802f94 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ef6:	83 e8 10             	sub    $0x10,%eax
  802ef9:	83 f8 0f             	cmp    $0xf,%eax
  802efc:	0f 86 8a 00 00 00    	jbe    802f8c <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	01 d0                	add    %edx,%eax
  802f0a:	83 c0 10             	add    $0x10,%eax
  802f0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802f10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f14:	75 17                	jne    802f2d <alloc_block_FF+0x2be>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 60 47 80 00       	push   $0x804760
  802f1e:	68 a7 00 00 00       	push   $0xa7
  802f23:	68 83 47 80 00       	push   $0x804783
  802f28:	e8 61 e0 ff ff       	call   800f8e <_panic>
  802f2d:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802f33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f36:	89 50 0c             	mov    %edx,0xc(%eax)
  802f39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 0d                	je     802f50 <alloc_block_FF+0x2e1>
  802f43:	a1 44 51 90 00       	mov    0x905144,%eax
  802f48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f4b:	89 50 08             	mov    %edx,0x8(%eax)
  802f4e:	eb 08                	jmp    802f58 <alloc_block_FF+0x2e9>
  802f50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f53:	a3 40 51 90 00       	mov    %eax,0x905140
  802f58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f5b:	a3 44 51 90 00       	mov    %eax,0x905144
  802f60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f6a:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f6f:	40                   	inc    %eax
  802f70:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f78:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7b:	8d 50 f0             	lea    -0x10(%eax),%edx
  802f7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f81:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802f83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f86:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802f8a:	eb 08                	jmp    802f94 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802f8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f92:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802f94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f97:	83 c0 10             	add    $0x10,%eax
  802f9a:	eb 05                	jmp    802fa1 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802f9c:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
  802fa6:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802fa9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802fb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb4:	75 0a                	jne    802fc0 <alloc_block_BF+0x1d>
	{
		return NULL;
  802fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbb:	e9 40 02 00 00       	jmp    803200 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802fc0:	a1 40 51 90 00       	mov    0x905140,%eax
  802fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc8:	eb 66                	jmp    803030 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8a 40 04             	mov    0x4(%eax),%al
  802fd0:	3c 01                	cmp    $0x1,%al
  802fd2:	75 21                	jne    802ff5 <alloc_block_BF+0x52>
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8d 50 10             	lea    0x10(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	39 c2                	cmp    %eax,%edx
  802fe1:	75 12                	jne    802ff5 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	83 c0 10             	add    $0x10,%eax
  802ff0:	e9 0b 02 00 00       	jmp    803200 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8a 40 04             	mov    0x4(%eax),%al
  802ffb:	3c 01                	cmp    $0x1,%al
  802ffd:	75 29                	jne    803028 <alloc_block_BF+0x85>
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8d 50 10             	lea    0x10(%eax),%edx
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	39 c2                	cmp    %eax,%edx
  80300c:	77 1a                	ja     803028 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  80300e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803012:	74 0e                	je     803022 <alloc_block_BF+0x7f>
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 10                	mov    (%eax),%edx
  803019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	39 c2                	cmp    %eax,%edx
  803020:	73 06                	jae    803028 <alloc_block_BF+0x85>
			{
				BF = iterator;
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  803028:	a1 48 51 90 00       	mov    0x905148,%eax
  80302d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803034:	74 08                	je     80303e <alloc_block_BF+0x9b>
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 40 08             	mov    0x8(%eax),%eax
  80303c:	eb 05                	jmp    803043 <alloc_block_BF+0xa0>
  80303e:	b8 00 00 00 00       	mov    $0x0,%eax
  803043:	a3 48 51 90 00       	mov    %eax,0x905148
  803048:	a1 48 51 90 00       	mov    0x905148,%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	0f 85 75 ff ff ff    	jne    802fca <alloc_block_BF+0x27>
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803059:	0f 85 6b ff ff ff    	jne    802fca <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  80305f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803063:	0f 84 f8 00 00 00    	je     803161 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	8d 50 10             	lea    0x10(%eax),%edx
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	39 c2                	cmp    %eax,%edx
  803076:	0f 87 e5 00 00 00    	ja     803161 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	2b 45 08             	sub    0x8(%ebp),%eax
  803084:	83 e8 10             	sub    $0x10,%eax
  803087:	83 f8 0f             	cmp    $0xf,%eax
  80308a:	0f 86 bf 00 00 00    	jbe    80314f <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  803090:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	01 d0                	add    %edx,%eax
  803098:	83 c0 10             	add    $0x10,%eax
  80309b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  80309e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8030af:	8d 50 f0             	lea    -0x10(%eax),%edx
  8030b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b5:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ba:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8030be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c2:	74 06                	je     8030ca <alloc_block_BF+0x127>
  8030c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030c8:	75 17                	jne    8030e1 <alloc_block_BF+0x13e>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 9c 47 80 00       	push   $0x80479c
  8030d2:	68 e3 00 00 00       	push   $0xe3
  8030d7:	68 83 47 80 00       	push   $0x804783
  8030dc:	e8 ad de ff ff       	call   800f8e <_panic>
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	8b 50 08             	mov    0x8(%eax),%edx
  8030e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ea:	89 50 08             	mov    %edx,0x8(%eax)
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	8b 40 08             	mov    0x8(%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	74 0c                	je     803103 <alloc_block_BF+0x160>
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	8b 40 08             	mov    0x8(%eax),%eax
  8030fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803100:	89 50 0c             	mov    %edx,0xc(%eax)
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803109:	89 50 08             	mov    %edx,0x8(%eax)
  80310c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803112:	89 50 0c             	mov    %edx,0xc(%eax)
  803115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803118:	8b 40 08             	mov    0x8(%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	75 08                	jne    803127 <alloc_block_BF+0x184>
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	a3 44 51 90 00       	mov    %eax,0x905144
  803127:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80312c:	40                   	inc    %eax
  80312d:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	8d 50 10             	lea    0x10(%eax),%edx
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80313d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803140:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  803144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803147:	83 c0 10             	add    $0x10,%eax
  80314a:	e9 b1 00 00 00       	jmp    803200 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	83 c0 10             	add    $0x10,%eax
  80315c:	e9 9f 00 00 00       	jmp    803200 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	83 c0 10             	add    $0x10,%eax
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	50                   	push   %eax
  80316b:	e8 ee ee ff ff       	call   80205e <sbrk>
  803170:	83 c4 10             	add    $0x10,%esp
  803173:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  803176:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80317a:	74 7f                	je     8031fb <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  80317c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803180:	75 17                	jne    803199 <alloc_block_BF+0x1f6>
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	68 60 47 80 00       	push   $0x804760
  80318a:	68 f6 00 00 00       	push   $0xf6
  80318f:	68 83 47 80 00       	push   $0x804783
  803194:	e8 f5 dd ff ff       	call   800f8e <_panic>
  803199:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	89 50 0c             	mov    %edx,0xc(%eax)
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 0d                	je     8031bc <alloc_block_BF+0x219>
  8031af:	a1 44 51 90 00       	mov    0x905144,%eax
  8031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b7:	89 50 08             	mov    %edx,0x8(%eax)
  8031ba:	eb 08                	jmp    8031c4 <alloc_block_BF+0x221>
  8031bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bf:	a3 40 51 90 00       	mov    %eax,0x905140
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	a3 44 51 90 00       	mov    %eax,0x905144
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031d6:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8031db:	40                   	inc    %eax
  8031dc:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8d 50 10             	lea    0x10(%eax),%edx
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	83 c0 10             	add    $0x10,%eax
  8031f9:	eb 05                	jmp    803200 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8031fb:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 d0 47 80 00       	push   $0x8047d0
  803210:	68 07 01 00 00       	push   $0x107
  803215:	68 83 47 80 00       	push   $0x804783
  80321a:	e8 6f dd ff ff       	call   800f8e <_panic>

0080321f <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80321f:	55                   	push   %ebp
  803220:	89 e5                	mov    %esp,%ebp
  803222:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	68 f8 47 80 00       	push   $0x8047f8
  80322d:	68 0f 01 00 00       	push   $0x10f
  803232:	68 83 47 80 00       	push   $0x804783
  803237:	e8 52 dd ff ff       	call   800f8e <_panic>

0080323c <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80323c:	55                   	push   %ebp
  80323d:	89 e5                	mov    %esp,%ebp
  80323f:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  803242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803246:	0f 84 ee 05 00 00    	je     80383a <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	83 e8 10             	sub    $0x10,%eax
  803252:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  803255:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803259:	a1 40 51 90 00       	mov    0x905140,%eax
  80325e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803261:	eb 16                	jmp    803279 <free_block+0x3d>
	{
		if (block_pointer == it)
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803269:	75 06                	jne    803271 <free_block+0x35>
		{
			flagx = 1;
  80326b:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  80326f:	eb 2f                	jmp    8032a0 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803271:	a1 48 51 90 00       	mov    0x905148,%eax
  803276:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80327d:	74 08                	je     803287 <free_block+0x4b>
  80327f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803282:	8b 40 08             	mov    0x8(%eax),%eax
  803285:	eb 05                	jmp    80328c <free_block+0x50>
  803287:	b8 00 00 00 00       	mov    $0x0,%eax
  80328c:	a3 48 51 90 00       	mov    %eax,0x905148
  803291:	a1 48 51 90 00       	mov    0x905148,%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	75 c9                	jne    803263 <free_block+0x27>
  80329a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80329e:	75 c3                	jne    803263 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  8032a0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8032a4:	0f 84 93 05 00 00    	je     80383d <free_block+0x601>
		return;
	if (va == NULL)
  8032aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ae:	0f 84 8c 05 00 00    	je     803840 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8032bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c0:	8b 40 08             	mov    0x8(%eax),%eax
  8032c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8032c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ca:	75 12                	jne    8032de <free_block+0xa2>
  8032cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032d0:	75 0c                	jne    8032de <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8032d9:	e9 63 05 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8032de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e2:	0f 85 ca 00 00 00    	jne    8033b2 <free_block+0x176>
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	8a 40 04             	mov    0x4(%eax),%al
  8032ee:	3c 01                	cmp    $0x1,%al
  8032f0:	0f 85 bc 00 00 00    	jne    8033b2 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803300:	8b 10                	mov    (%eax),%edx
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	01 c2                	add    %eax,%edx
  803309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330c:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80330e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80331e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803322:	75 17                	jne    80333b <free_block+0xff>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 1e 48 80 00       	push   $0x80481e
  80332c:	68 3c 01 00 00       	push   $0x13c
  803331:	68 83 47 80 00       	push   $0x804783
  803336:	e8 53 dc ff ff       	call   800f8e <_panic>
  80333b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333e:	8b 40 08             	mov    0x8(%eax),%eax
  803341:	85 c0                	test   %eax,%eax
  803343:	74 11                	je     803356 <free_block+0x11a>
  803345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803348:	8b 40 08             	mov    0x8(%eax),%eax
  80334b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80334e:	8b 52 0c             	mov    0xc(%edx),%edx
  803351:	89 50 0c             	mov    %edx,0xc(%eax)
  803354:	eb 0b                	jmp    803361 <free_block+0x125>
  803356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803359:	8b 40 0c             	mov    0xc(%eax),%eax
  80335c:	a3 44 51 90 00       	mov    %eax,0x905144
  803361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803364:	8b 40 0c             	mov    0xc(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 11                	je     80337c <free_block+0x140>
  80336b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336e:	8b 40 0c             	mov    0xc(%eax),%eax
  803371:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803374:	8b 52 08             	mov    0x8(%edx),%edx
  803377:	89 50 08             	mov    %edx,0x8(%eax)
  80337a:	eb 0b                	jmp    803387 <free_block+0x14b>
  80337c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337f:	8b 40 08             	mov    0x8(%eax),%eax
  803382:	a3 40 51 90 00       	mov    %eax,0x905140
  803387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803394:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80339b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8033a0:	48                   	dec    %eax
  8033a1:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  8033a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8033ad:	e9 8f 04 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8033b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b6:	75 16                	jne    8033ce <free_block+0x192>
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8a 40 04             	mov    0x4(%eax),%al
  8033be:	84 c0                	test   %al,%al
  8033c0:	75 0c                	jne    8033ce <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8033c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8033c9:	e9 73 04 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8033ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033d2:	0f 85 c3 00 00 00    	jne    80349b <free_block+0x25f>
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8a 40 04             	mov    0x4(%eax),%al
  8033de:	3c 01                	cmp    $0x1,%al
  8033e0:	0f 85 b5 00 00 00    	jne    80349b <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e9:	8b 10                	mov    (%eax),%edx
  8033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	01 c2                	add    %eax,%edx
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803403:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80340b:	75 17                	jne    803424 <free_block+0x1e8>
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	68 1e 48 80 00       	push   $0x80481e
  803415:	68 49 01 00 00       	push   $0x149
  80341a:	68 83 47 80 00       	push   $0x804783
  80341f:	e8 6a db ff ff       	call   800f8e <_panic>
  803424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803427:	8b 40 08             	mov    0x8(%eax),%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	74 11                	je     80343f <free_block+0x203>
  80342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803431:	8b 40 08             	mov    0x8(%eax),%eax
  803434:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803437:	8b 52 0c             	mov    0xc(%edx),%edx
  80343a:	89 50 0c             	mov    %edx,0xc(%eax)
  80343d:	eb 0b                	jmp    80344a <free_block+0x20e>
  80343f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803442:	8b 40 0c             	mov    0xc(%eax),%eax
  803445:	a3 44 51 90 00       	mov    %eax,0x905144
  80344a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344d:	8b 40 0c             	mov    0xc(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 11                	je     803465 <free_block+0x229>
  803454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803457:	8b 40 0c             	mov    0xc(%eax),%eax
  80345a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80345d:	8b 52 08             	mov    0x8(%edx),%edx
  803460:	89 50 08             	mov    %edx,0x8(%eax)
  803463:	eb 0b                	jmp    803470 <free_block+0x234>
  803465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803468:	8b 40 08             	mov    0x8(%eax),%eax
  80346b:	a3 40 51 90 00       	mov    %eax,0x905140
  803470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803473:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80347a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803484:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803489:	48                   	dec    %eax
  80348a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  80348f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803496:	e9 a6 03 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  80349b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80349f:	75 16                	jne    8034b7 <free_block+0x27b>
  8034a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a4:	8a 40 04             	mov    0x4(%eax),%al
  8034a7:	84 c0                	test   %al,%al
  8034a9:	75 0c                	jne    8034b7 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  8034ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ae:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8034b2:	e9 8a 03 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8034b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034bb:	0f 84 81 01 00 00    	je     803642 <free_block+0x406>
  8034c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034c5:	0f 84 77 01 00 00    	je     803642 <free_block+0x406>
  8034cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ce:	8a 40 04             	mov    0x4(%eax),%al
  8034d1:	3c 01                	cmp    $0x1,%al
  8034d3:	0f 85 69 01 00 00    	jne    803642 <free_block+0x406>
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	8a 40 04             	mov    0x4(%eax),%al
  8034df:	3c 01                	cmp    $0x1,%al
  8034e1:	0f 85 5b 01 00 00    	jne    803642 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8034e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ea:	8b 10                	mov    (%eax),%edx
  8034ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ef:	8b 08                	mov    (%eax),%ecx
  8034f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	01 c8                	add    %ecx,%eax
  8034f8:	01 c2                	add    %eax,%edx
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80350f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80351f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803523:	75 17                	jne    80353c <free_block+0x300>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 1e 48 80 00       	push   $0x80481e
  80352d:	68 59 01 00 00       	push   $0x159
  803532:	68 83 47 80 00       	push   $0x804783
  803537:	e8 52 da ff ff       	call   800f8e <_panic>
  80353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353f:	8b 40 08             	mov    0x8(%eax),%eax
  803542:	85 c0                	test   %eax,%eax
  803544:	74 11                	je     803557 <free_block+0x31b>
  803546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803549:	8b 40 08             	mov    0x8(%eax),%eax
  80354c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80354f:	8b 52 0c             	mov    0xc(%edx),%edx
  803552:	89 50 0c             	mov    %edx,0xc(%eax)
  803555:	eb 0b                	jmp    803562 <free_block+0x326>
  803557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355a:	8b 40 0c             	mov    0xc(%eax),%eax
  80355d:	a3 44 51 90 00       	mov    %eax,0x905144
  803562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803565:	8b 40 0c             	mov    0xc(%eax),%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	74 11                	je     80357d <free_block+0x341>
  80356c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803575:	8b 52 08             	mov    0x8(%edx),%edx
  803578:	89 50 08             	mov    %edx,0x8(%eax)
  80357b:	eb 0b                	jmp    803588 <free_block+0x34c>
  80357d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803580:	8b 40 08             	mov    0x8(%eax),%eax
  803583:	a3 40 51 90 00       	mov    %eax,0x905140
  803588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80359c:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8035a1:	48                   	dec    %eax
  8035a2:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8035a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ab:	75 17                	jne    8035c4 <free_block+0x388>
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	68 1e 48 80 00       	push   $0x80481e
  8035b5:	68 5a 01 00 00       	push   $0x15a
  8035ba:	68 83 47 80 00       	push   $0x804783
  8035bf:	e8 ca d9 ff ff       	call   800f8e <_panic>
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 11                	je     8035df <free_block+0x3a3>
  8035ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d1:	8b 40 08             	mov    0x8(%eax),%eax
  8035d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8035da:	89 50 0c             	mov    %edx,0xc(%eax)
  8035dd:	eb 0b                	jmp    8035ea <free_block+0x3ae>
  8035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e5:	a3 44 51 90 00       	mov    %eax,0x905144
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f0:	85 c0                	test   %eax,%eax
  8035f2:	74 11                	je     803605 <free_block+0x3c9>
  8035f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035fd:	8b 52 08             	mov    0x8(%edx),%edx
  803600:	89 50 08             	mov    %edx,0x8(%eax)
  803603:	eb 0b                	jmp    803610 <free_block+0x3d4>
  803605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803608:	8b 40 08             	mov    0x8(%eax),%eax
  80360b:	a3 40 51 90 00       	mov    %eax,0x905140
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803624:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803629:	48                   	dec    %eax
  80362a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80362f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  803636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80363d:	e9 ff 01 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803646:	0f 84 db 00 00 00    	je     803727 <free_block+0x4eb>
  80364c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803650:	0f 84 d1 00 00 00    	je     803727 <free_block+0x4eb>
  803656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803659:	8a 40 04             	mov    0x4(%eax),%al
  80365c:	84 c0                	test   %al,%al
  80365e:	0f 85 c3 00 00 00    	jne    803727 <free_block+0x4eb>
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	8a 40 04             	mov    0x4(%eax),%al
  80366a:	3c 01                	cmp    $0x1,%al
  80366c:	0f 85 b5 00 00 00    	jne    803727 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803675:	8b 10                	mov    (%eax),%edx
  803677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	01 c2                	add    %eax,%edx
  80367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803681:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80368c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803693:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803697:	75 17                	jne    8036b0 <free_block+0x474>
  803699:	83 ec 04             	sub    $0x4,%esp
  80369c:	68 1e 48 80 00       	push   $0x80481e
  8036a1:	68 64 01 00 00       	push   $0x164
  8036a6:	68 83 47 80 00       	push   $0x804783
  8036ab:	e8 de d8 ff ff       	call   800f8e <_panic>
  8036b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b3:	8b 40 08             	mov    0x8(%eax),%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	74 11                	je     8036cb <free_block+0x48f>
  8036ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bd:	8b 40 08             	mov    0x8(%eax),%eax
  8036c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c3:	8b 52 0c             	mov    0xc(%edx),%edx
  8036c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8036c9:	eb 0b                	jmp    8036d6 <free_block+0x49a>
  8036cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d1:	a3 44 51 90 00       	mov    %eax,0x905144
  8036d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 11                	je     8036f1 <free_block+0x4b5>
  8036e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e9:	8b 52 08             	mov    0x8(%edx),%edx
  8036ec:	89 50 08             	mov    %edx,0x8(%eax)
  8036ef:	eb 0b                	jmp    8036fc <free_block+0x4c0>
  8036f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f4:	8b 40 08             	mov    0x8(%eax),%eax
  8036f7:	a3 40 51 90 00       	mov    %eax,0x905140
  8036fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803709:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803710:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803715:	48                   	dec    %eax
  803716:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  80371b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803722:	e9 1a 01 00 00       	jmp    803841 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80372b:	0f 84 df 00 00 00    	je     803810 <free_block+0x5d4>
  803731:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803735:	0f 84 d5 00 00 00    	je     803810 <free_block+0x5d4>
  80373b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373e:	8a 40 04             	mov    0x4(%eax),%al
  803741:	3c 01                	cmp    $0x1,%al
  803743:	0f 85 c7 00 00 00    	jne    803810 <free_block+0x5d4>
  803749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374c:	8a 40 04             	mov    0x4(%eax),%al
  80374f:	84 c0                	test   %al,%al
  803751:	0f 85 b9 00 00 00    	jne    803810 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  803757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80375e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803761:	8b 10                	mov    (%eax),%edx
  803763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	01 c2                	add    %eax,%edx
  80376a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376d:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80376f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80377f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803783:	75 17                	jne    80379c <free_block+0x560>
  803785:	83 ec 04             	sub    $0x4,%esp
  803788:	68 1e 48 80 00       	push   $0x80481e
  80378d:	68 6e 01 00 00       	push   $0x16e
  803792:	68 83 47 80 00       	push   $0x804783
  803797:	e8 f2 d7 ff ff       	call   800f8e <_panic>
  80379c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379f:	8b 40 08             	mov    0x8(%eax),%eax
  8037a2:	85 c0                	test   %eax,%eax
  8037a4:	74 11                	je     8037b7 <free_block+0x57b>
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	8b 40 08             	mov    0x8(%eax),%eax
  8037ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037af:	8b 52 0c             	mov    0xc(%edx),%edx
  8037b2:	89 50 0c             	mov    %edx,0xc(%eax)
  8037b5:	eb 0b                	jmp    8037c2 <free_block+0x586>
  8037b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8037bd:	a3 44 51 90 00       	mov    %eax,0x905144
  8037c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 11                	je     8037dd <free_block+0x5a1>
  8037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d5:	8b 52 08             	mov    0x8(%edx),%edx
  8037d8:	89 50 08             	mov    %edx,0x8(%eax)
  8037db:	eb 0b                	jmp    8037e8 <free_block+0x5ac>
  8037dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e0:	8b 40 08             	mov    0x8(%eax),%eax
  8037e3:	a3 40 51 90 00       	mov    %eax,0x905140
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8037fc:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803801:	48                   	dec    %eax
  803802:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803807:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80380e:	eb 31                	jmp    803841 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803814:	74 2b                	je     803841 <free_block+0x605>
  803816:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80381a:	74 25                	je     803841 <free_block+0x605>
  80381c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381f:	8a 40 04             	mov    0x4(%eax),%al
  803822:	84 c0                	test   %al,%al
  803824:	75 1b                	jne    803841 <free_block+0x605>
  803826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803829:	8a 40 04             	mov    0x4(%eax),%al
  80382c:	84 c0                	test   %al,%al
  80382e:	75 11                	jne    803841 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803833:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803837:	90                   	nop
  803838:	eb 07                	jmp    803841 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  80383a:	90                   	nop
  80383b:	eb 04                	jmp    803841 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  80383d:	90                   	nop
  80383e:	eb 01                	jmp    803841 <free_block+0x605>
	if (va == NULL)
		return;
  803840:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803841:	c9                   	leave  
  803842:	c3                   	ret    

00803843 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803843:	55                   	push   %ebp
  803844:	89 e5                	mov    %esp,%ebp
  803846:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803849:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80384d:	75 19                	jne    803868 <realloc_block_FF+0x25>
  80384f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803853:	74 13                	je     803868 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  803855:	83 ec 0c             	sub    $0xc,%esp
  803858:	ff 75 0c             	pushl  0xc(%ebp)
  80385b:	e8 0f f4 ff ff       	call   802c6f <alloc_block_FF>
  803860:	83 c4 10             	add    $0x10,%esp
  803863:	e9 ea 03 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  803868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80386c:	75 3b                	jne    8038a9 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  80386e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803872:	75 17                	jne    80388b <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  803874:	83 ec 0c             	sub    $0xc,%esp
  803877:	6a 00                	push   $0x0
  803879:	e8 f1 f3 ff ff       	call   802c6f <alloc_block_FF>
  80387e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803881:	b8 00 00 00 00       	mov    $0x0,%eax
  803886:	e9 c7 03 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  80388b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388f:	74 18                	je     8038a9 <realloc_block_FF+0x66>
		{
			free_block(va);
  803891:	83 ec 0c             	sub    $0xc,%esp
  803894:	ff 75 08             	pushl  0x8(%ebp)
  803897:	e8 a0 f9 ff ff       	call   80323c <free_block>
  80389c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80389f:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a4:	e9 a9 03 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  8038a9:	a1 40 51 90 00       	mov    0x905140,%eax
  8038ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038b1:	e9 68 03 00 00       	jmp    803c1e <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	83 e8 10             	sub    $0x10,%eax
  8038bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038bf:	0f 85 51 03 00 00    	jne    803c16 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8038c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038cd:	83 c2 10             	add    $0x10,%edx
  8038d0:	39 d0                	cmp    %edx,%eax
  8038d2:	75 08                	jne    8038dc <realloc_block_FF+0x99>
			{
				return va;
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	e9 76 03 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038e4:	0f 83 45 02 00 00    	jae    803b2f <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8038ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ed:	8b 40 08             	mov    0x8(%eax),%eax
  8038f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  8038f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f6:	8a 40 04             	mov    0x4(%eax),%al
  8038f9:	3c 01                	cmp    $0x1,%al
  8038fb:	0f 85 6b 01 00 00    	jne    803a6c <realloc_block_FF+0x229>
  803901:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803905:	0f 84 61 01 00 00    	je     803a6c <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  80390b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390e:	8b 10                	mov    (%eax),%edx
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803918:	29 c1                	sub    %eax,%ecx
  80391a:	89 c8                	mov    %ecx,%eax
  80391c:	39 c2                	cmp    %eax,%edx
  80391e:	0f 86 e3 00 00 00    	jbe    803a07 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  803924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803927:	8b 10                	mov    (%eax),%edx
  803929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392c:	8b 00                	mov    (%eax),%eax
  80392e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803931:	01 d0                	add    %edx,%eax
  803933:	83 f8 0f             	cmp    $0xf,%eax
  803936:	0f 86 b5 00 00 00    	jbe    8039f1 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  80393c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80393f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803942:	01 d0                	add    %edx,%eax
  803944:	83 c0 10             	add    $0x10,%eax
  803947:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  80394a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  803953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803956:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  80395a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395e:	74 06                	je     803966 <realloc_block_FF+0x123>
  803960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803964:	75 17                	jne    80397d <realloc_block_FF+0x13a>
  803966:	83 ec 04             	sub    $0x4,%esp
  803969:	68 9c 47 80 00       	push   $0x80479c
  80396e:	68 ae 01 00 00       	push   $0x1ae
  803973:	68 83 47 80 00       	push   $0x804783
  803978:	e8 11 d6 ff ff       	call   800f8e <_panic>
  80397d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803980:	8b 50 08             	mov    0x8(%eax),%edx
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	89 50 08             	mov    %edx,0x8(%eax)
  803989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398c:	8b 40 08             	mov    0x8(%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	74 0c                	je     80399f <realloc_block_FF+0x15c>
  803993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803996:	8b 40 08             	mov    0x8(%eax),%eax
  803999:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80399c:	89 50 0c             	mov    %edx,0xc(%eax)
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a5:	89 50 08             	mov    %edx,0x8(%eax)
  8039a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ae:	89 50 0c             	mov    %edx,0xc(%eax)
  8039b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b4:	8b 40 08             	mov    0x8(%eax),%eax
  8039b7:	85 c0                	test   %eax,%eax
  8039b9:	75 08                	jne    8039c3 <realloc_block_FF+0x180>
  8039bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039be:	a3 44 51 90 00       	mov    %eax,0x905144
  8039c3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8039c8:	40                   	inc    %eax
  8039c9:	a3 4c 51 90 00       	mov    %eax,0x90514c
							next->size = 0;
  8039ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  8039d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039da:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  8039de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e1:	8d 50 10             	lea    0x10(%eax),%edx
  8039e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e7:	89 10                	mov    %edx,(%eax)
							return va;
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	e9 61 02 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  8039f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f4:	8d 50 10             	lea    0x10(%eax),%edx
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  8039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ff:	83 c0 10             	add    $0x10,%eax
  803a02:	e9 4b 02 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  803a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0a:	8b 10                	mov    (%eax),%edx
  803a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0f:	8b 00                	mov    (%eax),%eax
  803a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a14:	29 c1                	sub    %eax,%ecx
  803a16:	89 c8                	mov    %ecx,%eax
  803a18:	39 c2                	cmp    %eax,%edx
  803a1a:	0f 83 f5 01 00 00    	jae    803c15 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803a20:	83 ec 0c             	sub    $0xc,%esp
  803a23:	ff 75 0c             	pushl  0xc(%ebp)
  803a26:	e8 44 f2 ff ff       	call   802c6f <alloc_block_FF>
  803a2b:	83 c4 10             	add    $0x10,%esp
  803a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  803a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a35:	74 2d                	je     803a64 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	83 ec 04             	sub    $0x4,%esp
  803a3f:	50                   	push   %eax
  803a40:	ff 75 08             	pushl  0x8(%ebp)
  803a43:	ff 75 ec             	pushl  -0x14(%ebp)
  803a46:	e8 a0 e0 ff ff       	call   801aeb <memcpy>
  803a4b:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  803a4e:	83 ec 0c             	sub    $0xc,%esp
  803a51:	ff 75 08             	pushl  0x8(%ebp)
  803a54:	e8 e3 f7 ff ff       	call   80323c <free_block>
  803a59:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  803a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5f:	e9 ee 01 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	e9 e6 01 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6f:	8a 40 04             	mov    0x4(%eax),%al
  803a72:	3c 01                	cmp    $0x1,%al
  803a74:	75 59                	jne    803acf <realloc_block_FF+0x28c>
  803a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a79:	8b 10                	mov    (%eax),%edx
  803a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a83:	29 c1                	sub    %eax,%ecx
  803a85:	89 c8                	mov    %ecx,%eax
  803a87:	39 c2                	cmp    %eax,%edx
  803a89:	75 44                	jne    803acf <realloc_block_FF+0x28c>
  803a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a8f:	74 3e                	je     803acf <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a94:	8b 40 08             	mov    0x8(%eax),%eax
  803a97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa0:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aa9:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abf:	8d 50 10             	lea    0x10(%eax),%edx
  803ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac5:	89 10                	mov    %edx,(%eax)
					return va;
  803ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aca:	e9 83 01 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad2:	8a 40 04             	mov    0x4(%eax),%al
  803ad5:	84 c0                	test   %al,%al
  803ad7:	74 0a                	je     803ae3 <realloc_block_FF+0x2a0>
  803ad9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803add:	0f 85 33 01 00 00    	jne    803c16 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803ae3:	83 ec 0c             	sub    $0xc,%esp
  803ae6:	ff 75 0c             	pushl  0xc(%ebp)
  803ae9:	e8 81 f1 ff ff       	call   802c6f <alloc_block_FF>
  803aee:	83 c4 10             	add    $0x10,%esp
  803af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  803af4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803af8:	74 2d                	je     803b27 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  803afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afd:	8b 00                	mov    (%eax),%eax
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	50                   	push   %eax
  803b03:	ff 75 08             	pushl  0x8(%ebp)
  803b06:	ff 75 e0             	pushl  -0x20(%ebp)
  803b09:	e8 dd df ff ff       	call   801aeb <memcpy>
  803b0e:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  803b11:	83 ec 0c             	sub    $0xc,%esp
  803b14:	ff 75 08             	pushl  0x8(%ebp)
  803b17:	e8 20 f7 ff ff       	call   80323c <free_block>
  803b1c:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b22:	e9 2b 01 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	e9 23 01 00 00       	jmp    803c52 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b37:	0f 86 d9 00 00 00    	jbe    803c16 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b40:	8b 00                	mov    (%eax),%eax
  803b42:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b45:	83 f8 0f             	cmp    $0xf,%eax
  803b48:	0f 86 b4 00 00 00    	jbe    803c02 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b54:	01 d0                	add    %edx,%eax
  803b56:	83 c0 10             	add    $0x10,%eax
  803b59:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5f:	8b 00                	mov    (%eax),%eax
  803b61:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b64:	8d 50 f0             	lea    -0x10(%eax),%edx
  803b67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b6a:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b70:	74 06                	je     803b78 <realloc_block_FF+0x335>
  803b72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b76:	75 17                	jne    803b8f <realloc_block_FF+0x34c>
  803b78:	83 ec 04             	sub    $0x4,%esp
  803b7b:	68 9c 47 80 00       	push   $0x80479c
  803b80:	68 ed 01 00 00       	push   $0x1ed
  803b85:	68 83 47 80 00       	push   $0x804783
  803b8a:	e8 ff d3 ff ff       	call   800f8e <_panic>
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	8b 50 08             	mov    0x8(%eax),%edx
  803b95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b98:	89 50 08             	mov    %edx,0x8(%eax)
  803b9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b9e:	8b 40 08             	mov    0x8(%eax),%eax
  803ba1:	85 c0                	test   %eax,%eax
  803ba3:	74 0c                	je     803bb1 <realloc_block_FF+0x36e>
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 40 08             	mov    0x8(%eax),%eax
  803bab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bae:	89 50 0c             	mov    %edx,0xc(%eax)
  803bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bb7:	89 50 08             	mov    %edx,0x8(%eax)
  803bba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bc0:	89 50 0c             	mov    %edx,0xc(%eax)
  803bc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bc6:	8b 40 08             	mov    0x8(%eax),%eax
  803bc9:	85 c0                	test   %eax,%eax
  803bcb:	75 08                	jne    803bd5 <realloc_block_FF+0x392>
  803bcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bd0:	a3 44 51 90 00       	mov    %eax,0x905144
  803bd5:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803bda:	40                   	inc    %eax
  803bdb:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803be0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be3:	83 c0 10             	add    $0x10,%eax
  803be6:	83 ec 0c             	sub    $0xc,%esp
  803be9:	50                   	push   %eax
  803bea:	e8 4d f6 ff ff       	call   80323c <free_block>
  803bef:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf5:	8d 50 10             	lea    0x10(%eax),%edx
  803bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfb:	89 10                	mov    %edx,(%eax)
					return va;
  803bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803c00:	eb 50                	jmp    803c52 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c05:	8d 50 10             	lea    0x10(%eax),%edx
  803c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0b:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c10:	83 c0 10             	add    $0x10,%eax
  803c13:	eb 3d                	jmp    803c52 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803c15:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803c16:	a1 48 51 90 00       	mov    0x905148,%eax
  803c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c22:	74 08                	je     803c2c <realloc_block_FF+0x3e9>
  803c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c27:	8b 40 08             	mov    0x8(%eax),%eax
  803c2a:	eb 05                	jmp    803c31 <realloc_block_FF+0x3ee>
  803c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c31:	a3 48 51 90 00       	mov    %eax,0x905148
  803c36:	a1 48 51 90 00       	mov    0x905148,%eax
  803c3b:	85 c0                	test   %eax,%eax
  803c3d:	0f 85 73 fc ff ff    	jne    8038b6 <realloc_block_FF+0x73>
  803c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c47:	0f 85 69 fc ff ff    	jne    8038b6 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c52:	c9                   	leave  
  803c53:	c3                   	ret    

00803c54 <__udivdi3>:
  803c54:	55                   	push   %ebp
  803c55:	57                   	push   %edi
  803c56:	56                   	push   %esi
  803c57:	53                   	push   %ebx
  803c58:	83 ec 1c             	sub    $0x1c,%esp
  803c5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c6b:	89 ca                	mov    %ecx,%edx
  803c6d:	89 f8                	mov    %edi,%eax
  803c6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c73:	85 f6                	test   %esi,%esi
  803c75:	75 2d                	jne    803ca4 <__udivdi3+0x50>
  803c77:	39 cf                	cmp    %ecx,%edi
  803c79:	77 65                	ja     803ce0 <__udivdi3+0x8c>
  803c7b:	89 fd                	mov    %edi,%ebp
  803c7d:	85 ff                	test   %edi,%edi
  803c7f:	75 0b                	jne    803c8c <__udivdi3+0x38>
  803c81:	b8 01 00 00 00       	mov    $0x1,%eax
  803c86:	31 d2                	xor    %edx,%edx
  803c88:	f7 f7                	div    %edi
  803c8a:	89 c5                	mov    %eax,%ebp
  803c8c:	31 d2                	xor    %edx,%edx
  803c8e:	89 c8                	mov    %ecx,%eax
  803c90:	f7 f5                	div    %ebp
  803c92:	89 c1                	mov    %eax,%ecx
  803c94:	89 d8                	mov    %ebx,%eax
  803c96:	f7 f5                	div    %ebp
  803c98:	89 cf                	mov    %ecx,%edi
  803c9a:	89 fa                	mov    %edi,%edx
  803c9c:	83 c4 1c             	add    $0x1c,%esp
  803c9f:	5b                   	pop    %ebx
  803ca0:	5e                   	pop    %esi
  803ca1:	5f                   	pop    %edi
  803ca2:	5d                   	pop    %ebp
  803ca3:	c3                   	ret    
  803ca4:	39 ce                	cmp    %ecx,%esi
  803ca6:	77 28                	ja     803cd0 <__udivdi3+0x7c>
  803ca8:	0f bd fe             	bsr    %esi,%edi
  803cab:	83 f7 1f             	xor    $0x1f,%edi
  803cae:	75 40                	jne    803cf0 <__udivdi3+0x9c>
  803cb0:	39 ce                	cmp    %ecx,%esi
  803cb2:	72 0a                	jb     803cbe <__udivdi3+0x6a>
  803cb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cb8:	0f 87 9e 00 00 00    	ja     803d5c <__udivdi3+0x108>
  803cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc3:	89 fa                	mov    %edi,%edx
  803cc5:	83 c4 1c             	add    $0x1c,%esp
  803cc8:	5b                   	pop    %ebx
  803cc9:	5e                   	pop    %esi
  803cca:	5f                   	pop    %edi
  803ccb:	5d                   	pop    %ebp
  803ccc:	c3                   	ret    
  803ccd:	8d 76 00             	lea    0x0(%esi),%esi
  803cd0:	31 ff                	xor    %edi,%edi
  803cd2:	31 c0                	xor    %eax,%eax
  803cd4:	89 fa                	mov    %edi,%edx
  803cd6:	83 c4 1c             	add    $0x1c,%esp
  803cd9:	5b                   	pop    %ebx
  803cda:	5e                   	pop    %esi
  803cdb:	5f                   	pop    %edi
  803cdc:	5d                   	pop    %ebp
  803cdd:	c3                   	ret    
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	89 d8                	mov    %ebx,%eax
  803ce2:	f7 f7                	div    %edi
  803ce4:	31 ff                	xor    %edi,%edi
  803ce6:	89 fa                	mov    %edi,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cf5:	89 eb                	mov    %ebp,%ebx
  803cf7:	29 fb                	sub    %edi,%ebx
  803cf9:	89 f9                	mov    %edi,%ecx
  803cfb:	d3 e6                	shl    %cl,%esi
  803cfd:	89 c5                	mov    %eax,%ebp
  803cff:	88 d9                	mov    %bl,%cl
  803d01:	d3 ed                	shr    %cl,%ebp
  803d03:	89 e9                	mov    %ebp,%ecx
  803d05:	09 f1                	or     %esi,%ecx
  803d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d0b:	89 f9                	mov    %edi,%ecx
  803d0d:	d3 e0                	shl    %cl,%eax
  803d0f:	89 c5                	mov    %eax,%ebp
  803d11:	89 d6                	mov    %edx,%esi
  803d13:	88 d9                	mov    %bl,%cl
  803d15:	d3 ee                	shr    %cl,%esi
  803d17:	89 f9                	mov    %edi,%ecx
  803d19:	d3 e2                	shl    %cl,%edx
  803d1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1f:	88 d9                	mov    %bl,%cl
  803d21:	d3 e8                	shr    %cl,%eax
  803d23:	09 c2                	or     %eax,%edx
  803d25:	89 d0                	mov    %edx,%eax
  803d27:	89 f2                	mov    %esi,%edx
  803d29:	f7 74 24 0c          	divl   0xc(%esp)
  803d2d:	89 d6                	mov    %edx,%esi
  803d2f:	89 c3                	mov    %eax,%ebx
  803d31:	f7 e5                	mul    %ebp
  803d33:	39 d6                	cmp    %edx,%esi
  803d35:	72 19                	jb     803d50 <__udivdi3+0xfc>
  803d37:	74 0b                	je     803d44 <__udivdi3+0xf0>
  803d39:	89 d8                	mov    %ebx,%eax
  803d3b:	31 ff                	xor    %edi,%edi
  803d3d:	e9 58 ff ff ff       	jmp    803c9a <__udivdi3+0x46>
  803d42:	66 90                	xchg   %ax,%ax
  803d44:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d48:	89 f9                	mov    %edi,%ecx
  803d4a:	d3 e2                	shl    %cl,%edx
  803d4c:	39 c2                	cmp    %eax,%edx
  803d4e:	73 e9                	jae    803d39 <__udivdi3+0xe5>
  803d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d53:	31 ff                	xor    %edi,%edi
  803d55:	e9 40 ff ff ff       	jmp    803c9a <__udivdi3+0x46>
  803d5a:	66 90                	xchg   %ax,%ax
  803d5c:	31 c0                	xor    %eax,%eax
  803d5e:	e9 37 ff ff ff       	jmp    803c9a <__udivdi3+0x46>
  803d63:	90                   	nop

00803d64 <__umoddi3>:
  803d64:	55                   	push   %ebp
  803d65:	57                   	push   %edi
  803d66:	56                   	push   %esi
  803d67:	53                   	push   %ebx
  803d68:	83 ec 1c             	sub    $0x1c,%esp
  803d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d83:	89 f3                	mov    %esi,%ebx
  803d85:	89 fa                	mov    %edi,%edx
  803d87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d8b:	89 34 24             	mov    %esi,(%esp)
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	75 1a                	jne    803dac <__umoddi3+0x48>
  803d92:	39 f7                	cmp    %esi,%edi
  803d94:	0f 86 a2 00 00 00    	jbe    803e3c <__umoddi3+0xd8>
  803d9a:	89 c8                	mov    %ecx,%eax
  803d9c:	89 f2                	mov    %esi,%edx
  803d9e:	f7 f7                	div    %edi
  803da0:	89 d0                	mov    %edx,%eax
  803da2:	31 d2                	xor    %edx,%edx
  803da4:	83 c4 1c             	add    $0x1c,%esp
  803da7:	5b                   	pop    %ebx
  803da8:	5e                   	pop    %esi
  803da9:	5f                   	pop    %edi
  803daa:	5d                   	pop    %ebp
  803dab:	c3                   	ret    
  803dac:	39 f0                	cmp    %esi,%eax
  803dae:	0f 87 ac 00 00 00    	ja     803e60 <__umoddi3+0xfc>
  803db4:	0f bd e8             	bsr    %eax,%ebp
  803db7:	83 f5 1f             	xor    $0x1f,%ebp
  803dba:	0f 84 ac 00 00 00    	je     803e6c <__umoddi3+0x108>
  803dc0:	bf 20 00 00 00       	mov    $0x20,%edi
  803dc5:	29 ef                	sub    %ebp,%edi
  803dc7:	89 fe                	mov    %edi,%esi
  803dc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dcd:	89 e9                	mov    %ebp,%ecx
  803dcf:	d3 e0                	shl    %cl,%eax
  803dd1:	89 d7                	mov    %edx,%edi
  803dd3:	89 f1                	mov    %esi,%ecx
  803dd5:	d3 ef                	shr    %cl,%edi
  803dd7:	09 c7                	or     %eax,%edi
  803dd9:	89 e9                	mov    %ebp,%ecx
  803ddb:	d3 e2                	shl    %cl,%edx
  803ddd:	89 14 24             	mov    %edx,(%esp)
  803de0:	89 d8                	mov    %ebx,%eax
  803de2:	d3 e0                	shl    %cl,%eax
  803de4:	89 c2                	mov    %eax,%edx
  803de6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dea:	d3 e0                	shl    %cl,%eax
  803dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803df0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803df4:	89 f1                	mov    %esi,%ecx
  803df6:	d3 e8                	shr    %cl,%eax
  803df8:	09 d0                	or     %edx,%eax
  803dfa:	d3 eb                	shr    %cl,%ebx
  803dfc:	89 da                	mov    %ebx,%edx
  803dfe:	f7 f7                	div    %edi
  803e00:	89 d3                	mov    %edx,%ebx
  803e02:	f7 24 24             	mull   (%esp)
  803e05:	89 c6                	mov    %eax,%esi
  803e07:	89 d1                	mov    %edx,%ecx
  803e09:	39 d3                	cmp    %edx,%ebx
  803e0b:	0f 82 87 00 00 00    	jb     803e98 <__umoddi3+0x134>
  803e11:	0f 84 91 00 00 00    	je     803ea8 <__umoddi3+0x144>
  803e17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e1b:	29 f2                	sub    %esi,%edx
  803e1d:	19 cb                	sbb    %ecx,%ebx
  803e1f:	89 d8                	mov    %ebx,%eax
  803e21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e25:	d3 e0                	shl    %cl,%eax
  803e27:	89 e9                	mov    %ebp,%ecx
  803e29:	d3 ea                	shr    %cl,%edx
  803e2b:	09 d0                	or     %edx,%eax
  803e2d:	89 e9                	mov    %ebp,%ecx
  803e2f:	d3 eb                	shr    %cl,%ebx
  803e31:	89 da                	mov    %ebx,%edx
  803e33:	83 c4 1c             	add    $0x1c,%esp
  803e36:	5b                   	pop    %ebx
  803e37:	5e                   	pop    %esi
  803e38:	5f                   	pop    %edi
  803e39:	5d                   	pop    %ebp
  803e3a:	c3                   	ret    
  803e3b:	90                   	nop
  803e3c:	89 fd                	mov    %edi,%ebp
  803e3e:	85 ff                	test   %edi,%edi
  803e40:	75 0b                	jne    803e4d <__umoddi3+0xe9>
  803e42:	b8 01 00 00 00       	mov    $0x1,%eax
  803e47:	31 d2                	xor    %edx,%edx
  803e49:	f7 f7                	div    %edi
  803e4b:	89 c5                	mov    %eax,%ebp
  803e4d:	89 f0                	mov    %esi,%eax
  803e4f:	31 d2                	xor    %edx,%edx
  803e51:	f7 f5                	div    %ebp
  803e53:	89 c8                	mov    %ecx,%eax
  803e55:	f7 f5                	div    %ebp
  803e57:	89 d0                	mov    %edx,%eax
  803e59:	e9 44 ff ff ff       	jmp    803da2 <__umoddi3+0x3e>
  803e5e:	66 90                	xchg   %ax,%ax
  803e60:	89 c8                	mov    %ecx,%eax
  803e62:	89 f2                	mov    %esi,%edx
  803e64:	83 c4 1c             	add    $0x1c,%esp
  803e67:	5b                   	pop    %ebx
  803e68:	5e                   	pop    %esi
  803e69:	5f                   	pop    %edi
  803e6a:	5d                   	pop    %ebp
  803e6b:	c3                   	ret    
  803e6c:	3b 04 24             	cmp    (%esp),%eax
  803e6f:	72 06                	jb     803e77 <__umoddi3+0x113>
  803e71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e75:	77 0f                	ja     803e86 <__umoddi3+0x122>
  803e77:	89 f2                	mov    %esi,%edx
  803e79:	29 f9                	sub    %edi,%ecx
  803e7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e7f:	89 14 24             	mov    %edx,(%esp)
  803e82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e8a:	8b 14 24             	mov    (%esp),%edx
  803e8d:	83 c4 1c             	add    $0x1c,%esp
  803e90:	5b                   	pop    %ebx
  803e91:	5e                   	pop    %esi
  803e92:	5f                   	pop    %edi
  803e93:	5d                   	pop    %ebp
  803e94:	c3                   	ret    
  803e95:	8d 76 00             	lea    0x0(%esi),%esi
  803e98:	2b 04 24             	sub    (%esp),%eax
  803e9b:	19 fa                	sbb    %edi,%edx
  803e9d:	89 d1                	mov    %edx,%ecx
  803e9f:	89 c6                	mov    %eax,%esi
  803ea1:	e9 71 ff ff ff       	jmp    803e17 <__umoddi3+0xb3>
  803ea6:	66 90                	xchg   %ax,%ax
  803ea8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803eac:	72 ea                	jb     803e98 <__umoddi3+0x134>
  803eae:	89 d9                	mov    %ebx,%ecx
  803eb0:	e9 62 ff ff ff       	jmp    803e17 <__umoddi3+0xb3>
