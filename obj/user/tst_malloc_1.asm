
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
  800031:	e8 a3 0f 00 00       	call   800fd9 <libmain>
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
  800060:	68 e0 3f 80 00       	push   $0x803fe0
  800065:	6a 1c                	push   $0x1c
  800067:	68 fc 3f 80 00       	push   $0x803ffc
  80006c:	e8 96 10 00 00       	call   801107 <_panic>
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
  8000a8:	e8 5f 25 00 00       	call   80260c <sys_calculate_free_frames>
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
  8000c4:	e8 43 25 00 00       	call   80260c <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 86 25 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 08 21 00 00       	call   8021ed <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			cprintf("in test 1 \n");
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 10 40 80 00       	push   $0x804010
  8000f6:	e8 c9 12 00 00       	call   8013c4 <cprintf>
  8000fb:	83 c4 10             	add    $0x10,%esp
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000fe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  800104:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800107:	74 14                	je     80011d <_main+0xe5>
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 1c 40 80 00       	push   $0x80401c
  800111:	6a 45                	push   $0x45
  800113:	68 fc 3f 80 00       	push   $0x803ffc
  800118:	e8 ea 0f 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  80011d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800120:	e8 e7 24 00 00       	call   80260c <sys_calculate_free_frames>
  800125:	29 c3                	sub    %eax,%ebx
  800127:	89 d8                	mov    %ebx,%eax
  800129:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  80012e:	76 14                	jbe    800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 4c 40 80 00       	push   $0x80404c
  800138:	6a 46                	push   $0x46
  80013a:	68 fc 3f 80 00       	push   $0x803ffc
  80013f:	e8 c3 0f 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800144:	e8 0e 25 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800149:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 98 40 80 00       	push   $0x804098
  800156:	6a 47                	push   $0x47
  800158:	68 fc 3f 80 00       	push   $0x803ffc
  80015d:	e8 a5 0f 00 00       	call   801107 <_panic>
			cprintf("in test 2 \n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 c6 40 80 00       	push   $0x8040c6
  80016a:	e8 55 12 00 00       	call   8013c4 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp


			freeFrames = sys_calculate_free_frames() ;
  800172:	e8 95 24 00 00       	call   80260c <sys_calculate_free_frames>
  800177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			cprintf("in test 3 \n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 d2 40 80 00       	push   $0x8040d2
  800182:	e8 3d 12 00 00       	call   8013c4 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80018a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80018d:	01 c0                	add    %eax,%eax
  80018f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800192:	48                   	dec    %eax
  800193:	89 45 cc             	mov    %eax,-0x34(%ebp)
			cprintf("in test 4 \n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 de 40 80 00       	push   $0x8040de
  80019e:	e8 21 12 00 00       	call   8013c4 <cprintf>
  8001a3:	83 c4 10             	add    $0x10,%esp

			byteArr = (char *) ptr_allocations[0];
  8001a6:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8001ac:	89 45 c8             	mov    %eax,-0x38(%ebp)

			cprintf("in test 5 \n");
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	68 ea 40 80 00       	push   $0x8040ea
  8001b7:	e8 08 12 00 00       	call   8013c4 <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp


			byteArr[0] = minByte ;
  8001bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c2:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8001c5:	88 10                	mov    %dl,(%eax)
			cprintf("in test 6 \n");
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	68 f6 40 80 00       	push   $0x8040f6
  8001cf:	e8 f0 11 00 00       	call   8013c4 <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp

			byteArr[lastIndexOfByte] = maxByte ;
  8001d7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001dd:	01 c2                	add    %eax,%edx
  8001df:	8a 45 ea             	mov    -0x16(%ebp),%al
  8001e2:	88 02                	mov    %al,(%edx)
			cprintf("in test 7 \n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 02 41 80 00       	push   $0x804102
  8001ec:	e8 d3 11 00 00       	call   8013c4 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp

			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  8001f4:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			cprintf("in test 8 \n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 0e 41 80 00       	push   $0x80410e
  800203:	e8 bc 11 00 00       	call   8013c4 <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp

			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80020b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80020e:	e8 f9 23 00 00       	call   80260c <sys_calculate_free_frames>
  800213:	29 c3                	sub    %eax,%ebx
  800215:	89 d8                	mov    %ebx,%eax
  800217:	89 45 c0             	mov    %eax,-0x40(%ebp)
			cprintf("in test 9 \n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 1a 41 80 00       	push   $0x80411a
  800222:	e8 9d 11 00 00       	call   8013c4 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp

			if (actualNumOfFrames < expectedNumOfFrames)
  80022a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80022d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800230:	7d 1a                	jge    80024c <_main+0x214>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	ff 75 c0             	pushl  -0x40(%ebp)
  800238:	ff 75 c4             	pushl  -0x3c(%ebp)
  80023b:	68 28 41 80 00       	push   $0x804128
  800240:	6a 62                	push   $0x62
  800242:	68 fc 3f 80 00       	push   $0x803ffc
  800247:	e8 bb 0e 00 00       	call   801107 <_panic>
			cprintf("in test 10 \n");
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	68 a3 41 80 00       	push   $0x8041a3
  800254:	e8 6b 11 00 00       	call   8013c4 <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80025c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025f:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800262:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800265:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026a:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  800270:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800273:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80027b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80027e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800283:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800289:	6a 02                	push   $0x2
  80028b:	6a 00                	push   $0x0
  80028d:	6a 02                	push   $0x2
  80028f:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800295:	50                   	push   %eax
  800296:	e8 8e 28 00 00       	call   802b29 <sys_check_WS_list>
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  8002a1:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 b0 41 80 00       	push   $0x8041b0
  8002af:	6a 67                	push   $0x67
  8002b1:	68 fc 3f 80 00       	push   $0x803ffc
  8002b6:	e8 4c 0e 00 00       	call   801107 <_panic>
			cprintf("in test 11 \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 d0 41 80 00       	push   $0x8041d0
  8002c3:	e8 fc 10 00 00       	call   8013c4 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("4\n");

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 3c 23 00 00       	call   80260c <sys_calculate_free_frames>
  8002d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002d3:	e8 7f 23 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8002d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	01 c0                	add    %eax,%eax
  8002e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	e8 01 1f 00 00       	call   8021ed <malloc>
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8002f5:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8002fb:	89 c2                	mov    %eax,%edx
  8002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800300:	01 c0                	add    %eax,%eax
  800302:	89 c1                	mov    %eax,%ecx
  800304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	39 c2                	cmp    %eax,%edx
  80030b:	74 14                	je     800321 <_main+0x2e9>
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	68 1c 40 80 00       	push   $0x80401c
  800315:	6a 71                	push   $0x71
  800317:	68 fc 3f 80 00       	push   $0x803ffc
  80031c:	e8 e6 0d 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800321:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800324:	e8 e3 22 00 00       	call   80260c <sys_calculate_free_frames>
  800329:	29 c3                	sub    %eax,%ebx
  80032b:	89 d8                	mov    %ebx,%eax
  80032d:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  800332:	76 14                	jbe    800348 <_main+0x310>
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	68 4c 40 80 00       	push   $0x80404c
  80033c:	6a 72                	push   $0x72
  80033e:	68 fc 3f 80 00       	push   $0x803ffc
  800343:	e8 bf 0d 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800348:	e8 0a 23 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800350:	74 14                	je     800366 <_main+0x32e>
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	68 98 40 80 00       	push   $0x804098
  80035a:	6a 73                	push   $0x73
  80035c:	68 fc 3f 80 00       	push   $0x803ffc
  800361:	e8 a1 0d 00 00       	call   801107 <_panic>
			cprintf("in test 12 \n");
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	68 dd 41 80 00       	push   $0x8041dd
  80036e:	e8 51 10 00 00       	call   8013c4 <cprintf>
  800373:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800376:	e8 91 22 00 00       	call   80260c <sys_calculate_free_frames>
  80037b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80037e:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800384:	89 45 b0             	mov    %eax,-0x50(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80038f:	d1 e8                	shr    %eax
  800391:	48                   	dec    %eax
  800392:	89 45 ac             	mov    %eax,-0x54(%ebp)
			shortArr[0] = minShort;
  800395:	8b 55 b0             	mov    -0x50(%ebp),%edx
  800398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80039b:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  80039e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	89 c2                	mov    %eax,%edx
  8003a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003a8:	01 c2                	add    %eax,%edx
  8003aa:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8003ae:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/;
  8003b1:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003b8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003bb:	e8 4c 22 00 00       	call   80260c <sys_calculate_free_frames>
  8003c0:	29 c3                	sub    %eax,%ebx
  8003c2:	89 d8                	mov    %ebx,%eax
  8003c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  8003c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003ca:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003cd:	7d 1a                	jge    8003e9 <_main+0x3b1>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff 75 c0             	pushl  -0x40(%ebp)
  8003d5:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d8:	68 28 41 80 00       	push   $0x804128
  8003dd:	6a 7e                	push   $0x7e
  8003df:	68 fc 3f 80 00       	push   $0x803ffc
  8003e4:	e8 1e 0d 00 00       	call   801107 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8003e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003ec:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8003ef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f7:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  8003fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	89 c2                	mov    %eax,%edx
  800404:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80040c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80040f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800414:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80041a:	6a 02                	push   $0x2
  80041c:	6a 00                	push   $0x0
  80041e:	6a 02                	push   $0x2
  800420:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	e8 fd 26 00 00       	call   802b29 <sys_check_WS_list>
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800432:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800436:	74 17                	je     80044f <_main+0x417>
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	68 b0 41 80 00       	push   $0x8041b0
  800440:	68 81 00 00 00       	push   $0x81
  800445:	68 fc 3f 80 00       	push   $0x803ffc
  80044a:	e8 b8 0c 00 00       	call   801107 <_panic>
			cprintf("in test 13 \n");
  80044f:	83 ec 0c             	sub    $0xc,%esp
  800452:	68 ea 41 80 00       	push   $0x8041ea
  800457:	e8 68 0f 00 00       	call   8013c4 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("5\n");

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80045f:	e8 f3 21 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800464:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  800467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	01 d2                	add    %edx,%edx
  80046e:	01 d0                	add    %edx,%eax
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	50                   	push   %eax
  800474:	e8 74 1d 00 00       	call   8021ed <malloc>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800482:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800488:	89 c2                	mov    %eax,%edx
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	c1 e0 02             	shl    $0x2,%eax
  800490:	89 c1                	mov    %eax,%ecx
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	01 c8                	add    %ecx,%eax
  800497:	39 c2                	cmp    %eax,%edx
  800499:	74 17                	je     8004b2 <_main+0x47a>
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	68 1c 40 80 00       	push   $0x80401c
  8004a3:	68 8b 00 00 00       	push   $0x8b
  8004a8:	68 fc 3f 80 00       	push   $0x803ffc
  8004ad:	e8 55 0c 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004b2:	e8 a0 21 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8004b7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004ba:	74 17                	je     8004d3 <_main+0x49b>
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 98 40 80 00       	push   $0x804098
  8004c4:	68 8c 00 00 00       	push   $0x8c
  8004c9:	68 fc 3f 80 00       	push   $0x803ffc
  8004ce:	e8 34 0c 00 00       	call   801107 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8004d3:	e8 34 21 00 00       	call   80260c <sys_calculate_free_frames>
  8004d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			intArr = (int *) ptr_allocations[2];
  8004db:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8004e1:	89 45 a0             	mov    %eax,-0x60(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	c1 e8 02             	shr    $0x2,%eax
  8004ec:	48                   	dec    %eax
  8004ed:	89 45 9c             	mov    %eax,-0x64(%ebp)
			intArr[0] = minInt;
  8004f0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f6:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  8004f8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800502:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800505:	01 c2                	add    %eax,%edx
  800507:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050a:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  80050c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800513:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800516:	e8 f1 20 00 00       	call   80260c <sys_calculate_free_frames>
  80051b:	29 c3                	sub    %eax,%ebx
  80051d:	89 d8                	mov    %ebx,%eax
  80051f:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800522:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800525:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800528:	7d 1d                	jge    800547 <_main+0x50f>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	ff 75 c0             	pushl  -0x40(%ebp)
  800530:	ff 75 c4             	pushl  -0x3c(%ebp)
  800533:	68 28 41 80 00       	push   $0x804128
  800538:	68 96 00 00 00       	push   $0x96
  80053d:	68 fc 3f 80 00       	push   $0x803ffc
  800542:	e8 c0 0b 00 00       	call   801107 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800547:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80054a:	89 45 98             	mov    %eax,-0x68(%ebp)
  80054d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800550:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800555:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  80055b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80055e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800565:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80056d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800570:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800575:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80057b:	6a 02                	push   $0x2
  80057d:	6a 00                	push   $0x0
  80057f:	6a 02                	push   $0x2
  800581:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	e8 9c 25 00 00       	call   802b29 <sys_check_WS_list>
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800593:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800597:	74 17                	je     8005b0 <_main+0x578>
  800599:	83 ec 04             	sub    $0x4,%esp
  80059c:	68 b0 41 80 00       	push   $0x8041b0
  8005a1:	68 99 00 00 00       	push   $0x99
  8005a6:	68 fc 3f 80 00       	push   $0x803ffc
  8005ab:	e8 57 0b 00 00       	call   801107 <_panic>
			cprintf("in test 14 \n");
  8005b0:	83 ec 0c             	sub    $0xc,%esp
  8005b3:	68 f7 41 80 00       	push   $0x8041f7
  8005b8:	e8 07 0e 00 00       	call   8013c4 <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp

		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005c0:	e8 92 20 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	50                   	push   %eax
  8005d5:	e8 13 1c 00 00       	call   8021ed <malloc>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ee:	c1 e0 02             	shl    $0x2,%eax
  8005f1:	89 c1                	mov    %eax,%ecx
  8005f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f6:	c1 e0 02             	shl    $0x2,%eax
  8005f9:	01 c1                	add    %eax,%ecx
  8005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fe:	01 c8                	add    %ecx,%eax
  800600:	39 c2                	cmp    %eax,%edx
  800602:	74 17                	je     80061b <_main+0x5e3>
  800604:	83 ec 04             	sub    $0x4,%esp
  800607:	68 1c 40 80 00       	push   $0x80401c
  80060c:	68 a2 00 00 00       	push   $0xa2
  800611:	68 fc 3f 80 00       	push   $0x803ffc
  800616:	e8 ec 0a 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80061b:	e8 37 20 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800620:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 98 40 80 00       	push   $0x804098
  80062d:	68 a3 00 00 00       	push   $0xa3
  800632:	68 fc 3f 80 00       	push   $0x803ffc
  800637:	e8 cb 0a 00 00       	call   801107 <_panic>
			cprintf("in test 15 \n");
  80063c:	83 ec 0c             	sub    $0xc,%esp
  80063f:	68 04 42 80 00       	push   $0x804204
  800644:	e8 7b 0d 00 00       	call   8013c4 <cprintf>
  800649:	83 c4 10             	add    $0x10,%esp

		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80064c:	e8 bb 1f 00 00       	call   80260c <sys_calculate_free_frames>
  800651:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800654:	e8 fe 1f 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800659:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  80065c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80065f:	89 d0                	mov    %edx,%eax
  800661:	01 c0                	add    %eax,%eax
  800663:	01 d0                	add    %edx,%eax
  800665:	01 c0                	add    %eax,%eax
  800667:	01 d0                	add    %edx,%eax
  800669:	83 ec 0c             	sub    $0xc,%esp
  80066c:	50                   	push   %eax
  80066d:	e8 7b 1b 00 00       	call   8021ed <malloc>
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  80067b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800681:	89 c2                	mov    %eax,%edx
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	89 c1                	mov    %eax,%ecx
  80068b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80068e:	c1 e0 03             	shl    $0x3,%eax
  800691:	01 c1                	add    %eax,%ecx
  800693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800696:	01 c8                	add    %ecx,%eax
  800698:	39 c2                	cmp    %eax,%edx
  80069a:	74 17                	je     8006b3 <_main+0x67b>
  80069c:	83 ec 04             	sub    $0x4,%esp
  80069f:	68 1c 40 80 00       	push   $0x80401c
  8006a4:	68 ad 00 00 00       	push   $0xad
  8006a9:	68 fc 3f 80 00       	push   $0x803ffc
  8006ae:	e8 54 0a 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 2) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  8006b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b6:	e8 51 1f 00 00       	call   80260c <sys_calculate_free_frames>
  8006bb:	29 c3                	sub    %eax,%ebx
  8006bd:	89 d8                	mov    %ebx,%eax
  8006bf:	83 f8 01             	cmp    $0x1,%eax
  8006c2:	76 17                	jbe    8006db <_main+0x6a3>
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	68 4c 40 80 00       	push   $0x80404c
  8006cc:	68 ae 00 00 00       	push   $0xae
  8006d1:	68 fc 3f 80 00       	push   $0x803ffc
  8006d6:	e8 2c 0a 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006db:	e8 77 1f 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8006e0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	83 ec 04             	sub    $0x4,%esp
  8006e8:	68 98 40 80 00       	push   $0x804098
  8006ed:	68 af 00 00 00       	push   $0xaf
  8006f2:	68 fc 3f 80 00       	push   $0x803ffc
  8006f7:	e8 0b 0a 00 00       	call   801107 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 0b 1f 00 00       	call   80260c <sys_calculate_free_frames>
  800701:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  800704:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80070a:	89 45 90             	mov    %eax,-0x70(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80070d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800710:	89 d0                	mov    %edx,%eax
  800712:	01 c0                	add    %eax,%eax
  800714:	01 d0                	add    %edx,%eax
  800716:	01 c0                	add    %eax,%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	c1 e8 03             	shr    $0x3,%eax
  80071d:	48                   	dec    %eax
  80071e:	89 45 8c             	mov    %eax,-0x74(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800721:	8b 45 90             	mov    -0x70(%ebp),%eax
  800724:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800727:	88 10                	mov    %dl,(%eax)
  800729:	8b 55 90             	mov    -0x70(%ebp),%edx
  80072c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80072f:	66 89 42 02          	mov    %ax,0x2(%edx)
  800733:	8b 45 90             	mov    -0x70(%ebp),%eax
  800736:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800739:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80073c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80073f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800746:	8b 45 90             	mov    -0x70(%ebp),%eax
  800749:	01 c2                	add    %eax,%edx
  80074b:	8a 45 ea             	mov    -0x16(%ebp),%al
  80074e:	88 02                	mov    %al,(%edx)
  800750:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800753:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80075a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80075d:	01 c2                	add    %eax,%edx
  80075f:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800763:	66 89 42 02          	mov    %ax,0x2(%edx)
  800767:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 45 90             	mov    -0x70(%ebp),%eax
  800774:	01 c2                	add    %eax,%edx
  800776:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800779:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  80077c:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800783:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800786:	e8 81 1e 00 00       	call   80260c <sys_calculate_free_frames>
  80078b:	29 c3                	sub    %eax,%ebx
  80078d:	89 d8                	mov    %ebx,%eax
  80078f:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800792:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800795:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800798:	7d 1d                	jge    8007b7 <_main+0x77f>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80079a:	83 ec 0c             	sub    $0xc,%esp
  80079d:	ff 75 c0             	pushl  -0x40(%ebp)
  8007a0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8007a3:	68 28 41 80 00       	push   $0x804128
  8007a8:	68 b9 00 00 00       	push   $0xb9
  8007ad:	68 fc 3f 80 00       	push   $0x803ffc
  8007b2:	e8 50 09 00 00       	call   801107 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8007b7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8007ba:	89 45 88             	mov    %eax,-0x78(%ebp)
  8007bd:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007c5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8007cb:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8007d8:	01 d0                	add    %edx,%eax
  8007da:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8007dd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8007eb:	6a 02                	push   $0x2
  8007ed:	6a 00                	push   $0x0
  8007ef:	6a 02                	push   $0x2
  8007f1:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 2c 23 00 00       	call   802b29 <sys_check_WS_list>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800803:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800807:	74 17                	je     800820 <_main+0x7e8>
  800809:	83 ec 04             	sub    $0x4,%esp
  80080c:	68 b0 41 80 00       	push   $0x8041b0
  800811:	68 bc 00 00 00       	push   $0xbc
  800816:	68 fc 3f 80 00       	push   $0x803ffc
  80081b:	e8 e7 08 00 00       	call   801107 <_panic>
			cprintf("in test 16 \n");
  800820:	83 ec 0c             	sub    $0xc,%esp
  800823:	68 11 42 80 00       	push   $0x804211
  800828:	e8 97 0b 00 00       	call   8013c4 <cprintf>
  80082d:	83 c4 10             	add    $0x10,%esp

		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800830:	e8 d7 1d 00 00       	call   80260c <sys_calculate_free_frames>
  800835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800838:	e8 1a 1e 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  80083d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800843:	89 c2                	mov    %eax,%edx
  800845:	01 d2                	add    %edx,%edx
  800847:	01 d0                	add    %edx,%eax
  800849:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80084c:	83 ec 0c             	sub    $0xc,%esp
  80084f:	50                   	push   %eax
  800850:	e8 98 19 00 00       	call   8021ed <malloc>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80085e:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800864:	89 c2                	mov    %eax,%edx
  800866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800869:	c1 e0 02             	shl    $0x2,%eax
  80086c:	89 c1                	mov    %eax,%ecx
  80086e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800871:	c1 e0 04             	shl    $0x4,%eax
  800874:	01 c1                	add    %eax,%ecx
  800876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800879:	01 c8                	add    %ecx,%eax
  80087b:	39 c2                	cmp    %eax,%edx
  80087d:	74 17                	je     800896 <_main+0x85e>
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 1c 40 80 00       	push   $0x80401c
  800887:	68 c6 00 00 00       	push   $0xc6
  80088c:	68 fc 3f 80 00       	push   $0x803ffc
  800891:	e8 71 08 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 3*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800896:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800899:	e8 6e 1d 00 00       	call   80260c <sys_calculate_free_frames>
  80089e:	89 d9                	mov    %ebx,%ecx
  8008a0:	29 c1                	sub    %eax,%ecx
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	89 c2                	mov    %eax,%edx
  8008a7:	01 d2                	add    %edx,%edx
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	85 c0                	test   %eax,%eax
  8008ad:	79 05                	jns    8008b4 <_main+0x87c>
  8008af:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008b4:	c1 f8 0c             	sar    $0xc,%eax
  8008b7:	39 c1                	cmp    %eax,%ecx
  8008b9:	72 17                	jb     8008d2 <_main+0x89a>
  8008bb:	83 ec 04             	sub    $0x4,%esp
  8008be:	68 4c 40 80 00       	push   $0x80404c
  8008c3:	68 c7 00 00 00       	push   $0xc7
  8008c8:	68 fc 3f 80 00       	push   $0x803ffc
  8008cd:	e8 35 08 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8008d2:	e8 80 1d 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8008d7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8008da:	74 17                	je     8008f3 <_main+0x8bb>
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 98 40 80 00       	push   $0x804098
  8008e4:	68 c8 00 00 00       	push   $0xc8
  8008e9:	68 fc 3f 80 00       	push   $0x803ffc
  8008ee:	e8 14 08 00 00       	call   801107 <_panic>
			cprintf("in test 17 \n");
  8008f3:	83 ec 0c             	sub    $0xc,%esp
  8008f6:	68 1e 42 80 00       	push   $0x80421e
  8008fb:	e8 c4 0a 00 00       	call   8013c4 <cprintf>
  800900:	83 c4 10             	add    $0x10,%esp

		}

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800903:	e8 04 1d 00 00       	call   80260c <sys_calculate_free_frames>
  800908:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80090b:	e8 47 1d 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800910:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  800913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800916:	89 d0                	mov    %edx,%eax
  800918:	01 c0                	add    %eax,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800921:	83 ec 0c             	sub    $0xc,%esp
  800924:	50                   	push   %eax
  800925:	e8 c3 18 00 00       	call   8021ed <malloc>
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800933:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800939:	89 c1                	mov    %eax,%ecx
  80093b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	01 c0                	add    %eax,%eax
  800942:	01 d0                	add    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	89 c2                	mov    %eax,%edx
  80094a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094d:	c1 e0 04             	shl    $0x4,%eax
  800950:	01 c2                	add    %eax,%edx
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	01 d0                	add    %edx,%eax
  800957:	39 c1                	cmp    %eax,%ecx
  800959:	74 17                	je     800972 <_main+0x93a>
  80095b:	83 ec 04             	sub    $0x4,%esp
  80095e:	68 1c 40 80 00       	push   $0x80401c
  800963:	68 d2 00 00 00       	push   $0xd2
  800968:	68 fc 3f 80 00       	push   $0x803ffc
  80096d:	e8 95 07 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 6*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800972:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800975:	e8 92 1c 00 00       	call   80260c <sys_calculate_free_frames>
  80097a:	89 d9                	mov    %ebx,%ecx
  80097c:	29 c1                	sub    %eax,%ecx
  80097e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	01 c0                	add    %eax,%eax
  800985:	01 d0                	add    %edx,%eax
  800987:	01 c0                	add    %eax,%eax
  800989:	85 c0                	test   %eax,%eax
  80098b:	79 05                	jns    800992 <_main+0x95a>
  80098d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800992:	c1 f8 0c             	sar    $0xc,%eax
  800995:	39 c1                	cmp    %eax,%ecx
  800997:	72 17                	jb     8009b0 <_main+0x978>
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	68 4c 40 80 00       	push   $0x80404c
  8009a1:	68 d3 00 00 00       	push   $0xd3
  8009a6:	68 fc 3f 80 00       	push   $0x803ffc
  8009ab:	e8 57 07 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8009b0:	e8 a2 1c 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  8009b5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8009b8:	74 17                	je     8009d1 <_main+0x999>
  8009ba:	83 ec 04             	sub    $0x4,%esp
  8009bd:	68 98 40 80 00       	push   $0x804098
  8009c2:	68 d4 00 00 00       	push   $0xd4
  8009c7:	68 fc 3f 80 00       	push   $0x803ffc
  8009cc:	e8 36 07 00 00       	call   801107 <_panic>

			cprintf("in test 18 \n");
  8009d1:	83 ec 0c             	sub    $0xc,%esp
  8009d4:	68 2b 42 80 00       	push   $0x80422b
  8009d9:	e8 e6 09 00 00       	call   8013c4 <cprintf>
  8009de:	83 c4 10             	add    $0x10,%esp


			freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 26 1c 00 00       	call   80260c <sys_calculate_free_frames>
  8009e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  8009e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009ec:	89 d0                	mov    %edx,%eax
  8009ee:	01 c0                	add    %eax,%eax
  8009f0:	01 d0                	add    %edx,%eax
  8009f2:	01 c0                	add    %eax,%eax
  8009f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8009f7:	48                   	dec    %eax
  8009f8:	89 45 80             	mov    %eax,-0x80(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  8009fb:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800a01:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			byteArr2[0] = minByte ;
  800a07:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a0d:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800a10:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a12:	8b 45 80             	mov    -0x80(%ebp),%eax
  800a15:	89 c2                	mov    %eax,%edx
  800a17:	c1 ea 1f             	shr    $0x1f,%edx
  800a1a:	01 d0                	add    %edx,%eax
  800a1c:	d1 f8                	sar    %eax
  800a1e:	89 c2                	mov    %eax,%edx
  800a20:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a26:	01 c2                	add    %eax,%edx
  800a28:	8a 45 ea             	mov    -0x16(%ebp),%al
  800a2b:	88 c1                	mov    %al,%cl
  800a2d:	c0 e9 07             	shr    $0x7,%cl
  800a30:	01 c8                	add    %ecx,%eax
  800a32:	d0 f8                	sar    %al
  800a34:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800a36:	8b 55 80             	mov    -0x80(%ebp),%edx
  800a39:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a3f:	01 c2                	add    %eax,%edx
  800a41:	8a 45 ea             	mov    -0x16(%ebp),%al
  800a44:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 /*+2 tables already created in malloc due to marking the allocated pages*/ ;
  800a46:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800a4d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a50:	e8 b7 1b 00 00       	call   80260c <sys_calculate_free_frames>
  800a55:	29 c3                	sub    %eax,%ebx
  800a57:	89 d8                	mov    %ebx,%eax
  800a59:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800a5c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a5f:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a62:	7d 1d                	jge    800a81 <_main+0xa49>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	ff 75 c0             	pushl  -0x40(%ebp)
  800a6a:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a6d:	68 28 41 80 00       	push   $0x804128
  800a72:	68 e2 00 00 00       	push   $0xe2
  800a77:	68 fc 3f 80 00       	push   $0x803ffc
  800a7c:	e8 86 06 00 00       	call   801107 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800a81:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a87:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800a8d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a98:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  800a9e:	8b 45 80             	mov    -0x80(%ebp),%eax
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	c1 ea 1f             	shr    $0x1f,%edx
  800aa6:	01 d0                	add    %edx,%eax
  800aa8:	d1 f8                	sar    %eax
  800aaa:	89 c2                	mov    %eax,%edx
  800aac:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800ab2:	01 d0                	add    %edx,%eax
  800ab4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800aba:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ac0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac5:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800acb:	8b 55 80             	mov    -0x80(%ebp),%edx
  800ace:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800ad4:	01 d0                	add    %edx,%eax
  800ad6:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800adc:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ae7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800aed:	6a 02                	push   $0x2
  800aef:	6a 00                	push   $0x0
  800af1:	6a 03                	push   $0x3
  800af3:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800af9:	50                   	push   %eax
  800afa:	e8 2a 20 00 00       	call   802b29 <sys_check_WS_list>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800b05:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 b0 41 80 00       	push   $0x8041b0
  800b13:	68 e5 00 00 00       	push   $0xe5
  800b18:	68 fc 3f 80 00       	push   $0x803ffc
  800b1d:	e8 e5 05 00 00       	call   801107 <_panic>

			cprintf("in test 19 \n");
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	68 38 42 80 00       	push   $0x804238
  800b2a:	e8 95 08 00 00       	call   8013c4 <cprintf>
  800b2f:	83 c4 10             	add    $0x10,%esp

		}

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800b32:	e8 d5 1a 00 00       	call   80260c <sys_calculate_free_frames>
  800b37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b3a:	e8 18 1b 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800b3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800b42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b45:	89 d0                	mov    %edx,%eax
  800b47:	01 c0                	add    %eax,%eax
  800b49:	01 d0                	add    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 93 16 00 00       	call   8021ed <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800b63:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800b69:	89 c1                	mov    %eax,%ecx
  800b6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	01 c0                	add    %eax,%eax
  800b72:	01 d0                	add    %edx,%eax
  800b74:	c1 e0 02             	shl    $0x2,%eax
  800b77:	01 d0                	add    %edx,%eax
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7e:	c1 e0 04             	shl    $0x4,%eax
  800b81:	01 c2                	add    %eax,%edx
  800b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	39 c1                	cmp    %eax,%ecx
  800b8a:	74 17                	je     800ba3 <_main+0xb6b>
  800b8c:	83 ec 04             	sub    $0x4,%esp
  800b8f:	68 1c 40 80 00       	push   $0x80401c
  800b94:	68 f0 00 00 00       	push   $0xf0
  800b99:	68 fc 3f 80 00       	push   $0x803ffc
  800b9e:	e8 64 05 00 00       	call   801107 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 16*kilo/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800ba3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ba6:	e8 61 1a 00 00       	call   80260c <sys_calculate_free_frames>
  800bab:	29 c3                	sub    %eax,%ebx
  800bad:	89 da                	mov    %ebx,%edx
  800baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb2:	c1 e0 04             	shl    $0x4,%eax
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	79 05                	jns    800bbe <_main+0xb86>
  800bb9:	05 ff 0f 00 00       	add    $0xfff,%eax
  800bbe:	c1 f8 0c             	sar    $0xc,%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	72 17                	jb     800bdc <_main+0xba4>
  800bc5:	83 ec 04             	sub    $0x4,%esp
  800bc8:	68 4c 40 80 00       	push   $0x80404c
  800bcd:	68 f1 00 00 00       	push   $0xf1
  800bd2:	68 fc 3f 80 00       	push   $0x803ffc
  800bd7:	e8 2b 05 00 00       	call   801107 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800bdc:	e8 76 1a 00 00       	call   802657 <sys_pf_calculate_allocated_pages>
  800be1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800be4:	74 17                	je     800bfd <_main+0xbc5>
  800be6:	83 ec 04             	sub    $0x4,%esp
  800be9:	68 98 40 80 00       	push   $0x804098
  800bee:	68 f2 00 00 00       	push   $0xf2
  800bf3:	68 fc 3f 80 00       	push   $0x803ffc
  800bf8:	e8 0a 05 00 00       	call   801107 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800bfd:	e8 0a 1a 00 00       	call   80260c <sys_calculate_free_frames>
  800c02:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800c05:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800c0b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c14:	89 d0                	mov    %edx,%eax
  800c16:	01 c0                	add    %eax,%eax
  800c18:	01 d0                	add    %edx,%eax
  800c1a:	01 c0                	add    %eax,%eax
  800c1c:	01 d0                	add    %edx,%eax
  800c1e:	01 c0                	add    %eax,%eax
  800c20:	d1 e8                	shr    %eax
  800c22:	48                   	dec    %eax
  800c23:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
			shortArr2[0] = minShort;
  800c29:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c32:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800c35:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	c1 ea 1f             	shr    $0x1f,%edx
  800c40:	01 d0                	add    %edx,%eax
  800c42:	d1 f8                	sar    %eax
  800c44:	01 c0                	add    %eax,%eax
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800c4e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800c51:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800c55:	89 c2                	mov    %eax,%edx
  800c57:	66 c1 ea 0f          	shr    $0xf,%dx
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	66 d1 f8             	sar    %ax
  800c60:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800c63:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800c69:	01 c0                	add    %eax,%eax
  800c6b:	89 c2                	mov    %eax,%edx
  800c6d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800c73:	01 c2                	add    %eax,%edx
  800c75:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800c79:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800c7c:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800c83:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c86:	e8 81 19 00 00       	call   80260c <sys_calculate_free_frames>
  800c8b:	29 c3                	sub    %eax,%ebx
  800c8d:	89 d8                	mov    %ebx,%eax
  800c8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800c92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c95:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c98:	7d 1d                	jge    800cb7 <_main+0xc7f>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	ff 75 c0             	pushl  -0x40(%ebp)
  800ca0:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ca3:	68 28 41 80 00       	push   $0x804128
  800ca8:	68 fd 00 00 00       	push   $0xfd
  800cad:	68 fc 3f 80 00       	push   $0x803ffc
  800cb2:	e8 50 04 00 00       	call   801107 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800cb7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800cbd:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800cc3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800cc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cce:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  800cd4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800cda:	89 c2                	mov    %eax,%edx
  800cdc:	c1 ea 1f             	shr    $0x1f,%edx
  800cdf:	01 d0                	add    %edx,%eax
  800ce1:	d1 f8                	sar    %eax
  800ce3:	01 c0                	add    %eax,%eax
  800ce5:	89 c2                	mov    %eax,%edx
  800ce7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800ced:	01 d0                	add    %edx,%eax
  800cef:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800cf5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800cfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d00:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800d06:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800d0c:	01 c0                	add    %eax,%eax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800d1e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800d24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d29:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800d2f:	6a 02                	push   $0x2
  800d31:	6a 00                	push   $0x0
  800d33:	6a 03                	push   $0x3
  800d35:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800d3b:	50                   	push   %eax
  800d3c:	e8 e8 1d 00 00       	call   802b29 <sys_check_WS_list>
  800d41:	83 c4 10             	add    $0x10,%esp
  800d44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800d47:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800d4b:	74 17                	je     800d64 <_main+0xd2c>
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	68 b0 41 80 00       	push   $0x8041b0
  800d55:	68 00 01 00 00       	push   $0x100
  800d5a:	68 fc 3f 80 00       	push   $0x803ffc
  800d5f:	e8 a3 03 00 00       	call   801107 <_panic>

			cprintf("in test 20 \n");
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	68 45 42 80 00       	push   $0x804245
  800d6c:	e8 53 06 00 00       	call   8013c4 <cprintf>
  800d71:	83 c4 10             	add    $0x10,%esp
		}
	}

	//Check that the values are successfully stored
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800d74:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800d7c:	75 0f                	jne    800d8d <_main+0xd55>
  800d7e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800d81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800d8b:	74 17                	je     800da4 <_main+0xd6c>
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	68 54 42 80 00       	push   $0x804254
  800d95:	68 09 01 00 00       	push   $0x109
  800d9a:	68 fc 3f 80 00       	push   $0x803ffc
  800d9f:	e8 63 03 00 00       	call   801107 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800da4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800da7:	66 8b 00             	mov    (%eax),%ax
  800daa:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800dae:	75 15                	jne    800dc5 <_main+0xd8d>
  800db0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800db3:	01 c0                	add    %eax,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
  800dbc:	66 8b 00             	mov    (%eax),%ax
  800dbf:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800dc3:	74 17                	je     800ddc <_main+0xda4>
  800dc5:	83 ec 04             	sub    $0x4,%esp
  800dc8:	68 54 42 80 00       	push   $0x804254
  800dcd:	68 0a 01 00 00       	push   $0x10a
  800dd2:	68 fc 3f 80 00       	push   $0x803ffc
  800dd7:	e8 2b 03 00 00       	call   801107 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  800ddc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800de4:	75 16                	jne    800dfc <_main+0xdc4>
  800de6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800df0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800df3:	01 d0                	add    %edx,%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dfa:	74 17                	je     800e13 <_main+0xddb>
  800dfc:	83 ec 04             	sub    $0x4,%esp
  800dff:	68 54 42 80 00       	push   $0x804254
  800e04:	68 0b 01 00 00       	push   $0x10b
  800e09:	68 fc 3f 80 00       	push   $0x803ffc
  800e0e:	e8 f4 02 00 00       	call   801107 <_panic>

		cprintf("in test 21 \n");
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	68 89 42 80 00       	push   $0x804289
  800e1b:	e8 a4 05 00 00       	call   8013c4 <cprintf>
  800e20:	83 c4 10             	add    $0x10,%esp


		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800e23:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800e2b:	75 16                	jne    800e43 <_main+0xe0b>
  800e2d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800e30:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e37:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e3a:	01 d0                	add    %edx,%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800e41:	74 17                	je     800e5a <_main+0xe22>
  800e43:	83 ec 04             	sub    $0x4,%esp
  800e46:	68 54 42 80 00       	push   $0x804254
  800e4b:	68 10 01 00 00       	push   $0x110
  800e50:	68 fc 3f 80 00       	push   $0x803ffc
  800e55:	e8 ad 02 00 00       	call   801107 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800e5a:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e5d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800e61:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800e65:	75 19                	jne    800e80 <_main+0xe48>
  800e67:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800e6a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e71:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
  800e76:	66 8b 40 02          	mov    0x2(%eax),%ax
  800e7a:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	83 ec 04             	sub    $0x4,%esp
  800e83:	68 54 42 80 00       	push   $0x804254
  800e88:	68 11 01 00 00       	push   $0x111
  800e8d:	68 fc 3f 80 00       	push   $0x803ffc
  800e92:	e8 70 02 00 00       	call   801107 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800e97:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e9a:	8b 40 04             	mov    0x4(%eax),%eax
  800e9d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800ea0:	75 17                	jne    800eb9 <_main+0xe81>
  800ea2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800ea5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800eac:	8b 45 90             	mov    -0x70(%ebp),%eax
  800eaf:	01 d0                	add    %edx,%eax
  800eb1:	8b 40 04             	mov    0x4(%eax),%eax
  800eb4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800eb7:	74 17                	je     800ed0 <_main+0xe98>
  800eb9:	83 ec 04             	sub    $0x4,%esp
  800ebc:	68 54 42 80 00       	push   $0x804254
  800ec1:	68 12 01 00 00       	push   $0x112
  800ec6:	68 fc 3f 80 00       	push   $0x803ffc
  800ecb:	e8 37 02 00 00       	call   801107 <_panic>

		cprintf("in test 22 \n");
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	68 96 42 80 00       	push   $0x804296
  800ed8:	e8 e7 04 00 00       	call   8013c4 <cprintf>
  800edd:	83 c4 10             	add    $0x10,%esp


		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800ee0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800eeb:	75 3a                	jne    800f27 <_main+0xeef>
  800eed:	8b 45 80             	mov    -0x80(%ebp),%eax
  800ef0:	89 c2                	mov    %eax,%edx
  800ef2:	c1 ea 1f             	shr    $0x1f,%edx
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	d1 f8                	sar    %eax
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800f01:	01 d0                	add    %edx,%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8a 45 ea             	mov    -0x16(%ebp),%al
  800f08:	88 c1                	mov    %al,%cl
  800f0a:	c0 e9 07             	shr    $0x7,%cl
  800f0d:	01 c8                	add    %ecx,%eax
  800f0f:	d0 f8                	sar    %al
  800f11:	38 c2                	cmp    %al,%dl
  800f13:	75 12                	jne    800f27 <_main+0xeef>
  800f15:	8b 55 80             	mov    -0x80(%ebp),%edx
  800f18:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800f25:	74 17                	je     800f3e <_main+0xf06>
  800f27:	83 ec 04             	sub    $0x4,%esp
  800f2a:	68 54 42 80 00       	push   $0x804254
  800f2f:	68 17 01 00 00       	push   $0x117
  800f34:	68 fc 3f 80 00       	push   $0x803ffc
  800f39:	e8 c9 01 00 00       	call   801107 <_panic>
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800f3e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800f44:	66 8b 00             	mov    (%eax),%ax
  800f47:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800f4b:	75 4d                	jne    800f9a <_main+0xf62>
  800f4d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 1f             	shr    $0x1f,%edx
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	d1 f8                	sar    %eax
  800f5c:	01 c0                	add    %eax,%eax
  800f5e:	89 c2                	mov    %eax,%edx
  800f60:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800f66:	01 d0                	add    %edx,%eax
  800f68:	66 8b 10             	mov    (%eax),%dx
  800f6b:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800f6f:	89 c1                	mov    %eax,%ecx
  800f71:	66 c1 e9 0f          	shr    $0xf,%cx
  800f75:	01 c8                	add    %ecx,%eax
  800f77:	66 d1 f8             	sar    %ax
  800f7a:	66 39 c2             	cmp    %ax,%dx
  800f7d:	75 1b                	jne    800f9a <_main+0xf62>
  800f7f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800f85:	01 c0                	add    %eax,%eax
  800f87:	89 c2                	mov    %eax,%edx
  800f89:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800f8f:	01 d0                	add    %edx,%eax
  800f91:	66 8b 00             	mov    (%eax),%ax
  800f94:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800f98:	74 17                	je     800fb1 <_main+0xf79>
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	68 54 42 80 00       	push   $0x804254
  800fa2:	68 18 01 00 00       	push   $0x118
  800fa7:	68 fc 3f 80 00       	push   $0x803ffc
  800fac:	e8 56 01 00 00       	call   801107 <_panic>


		cprintf("in test 23 \n");
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	68 a3 42 80 00       	push   $0x8042a3
  800fb9:	e8 06 04 00 00       	call   8013c4 <cprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp

	}
	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  800fc1:	83 ec 0c             	sub    $0xc,%esp
  800fc4:	68 b0 42 80 00       	push   $0x8042b0
  800fc9:	e8 f6 03 00 00       	call   8013c4 <cprintf>
  800fce:	83 c4 10             	add    $0x10,%esp

	return;
  800fd1:	90                   	nop
}
  800fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd5:	5b                   	pop    %ebx
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800fdf:	e8 b3 18 00 00       	call   802897 <sys_getenvindex>
  800fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	89 d0                	mov    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	c1 e0 06             	shl    $0x6,%eax
  800ff3:	29 d0                	sub    %edx,%eax
  800ff5:	c1 e0 03             	shl    $0x3,%eax
  800ff8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ffd:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801002:	a1 20 50 80 00       	mov    0x805020,%eax
  801007:	8a 40 68             	mov    0x68(%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	74 0d                	je     80101b <libmain+0x42>
		binaryname = myEnv->prog_name;
  80100e:	a1 20 50 80 00       	mov    0x805020,%eax
  801013:	83 c0 68             	add    $0x68,%eax
  801016:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80101b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101f:	7e 0a                	jle    80102b <libmain+0x52>
		binaryname = argv[0];
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 00                	mov    (%eax),%eax
  801026:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 ff ef ff ff       	call   800038 <_main>
  801039:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80103c:	e8 63 16 00 00       	call   8026a4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	68 04 43 80 00       	push   $0x804304
  801049:	e8 76 03 00 00       	call   8013c4 <cprintf>
  80104e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801051:	a1 20 50 80 00       	mov    0x805020,%eax
  801056:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80105c:	a1 20 50 80 00       	mov    0x805020,%eax
  801061:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  801067:	83 ec 04             	sub    $0x4,%esp
  80106a:	52                   	push   %edx
  80106b:	50                   	push   %eax
  80106c:	68 2c 43 80 00       	push   $0x80432c
  801071:	e8 4e 03 00 00       	call   8013c4 <cprintf>
  801076:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801079:	a1 20 50 80 00       	mov    0x805020,%eax
  80107e:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  801084:	a1 20 50 80 00       	mov    0x805020,%eax
  801089:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80108f:	a1 20 50 80 00       	mov    0x805020,%eax
  801094:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80109a:	51                   	push   %ecx
  80109b:	52                   	push   %edx
  80109c:	50                   	push   %eax
  80109d:	68 54 43 80 00       	push   $0x804354
  8010a2:	e8 1d 03 00 00       	call   8013c4 <cprintf>
  8010a7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8010aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8010af:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	50                   	push   %eax
  8010b9:	68 ac 43 80 00       	push   $0x8043ac
  8010be:	e8 01 03 00 00       	call   8013c4 <cprintf>
  8010c3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8010c6:	83 ec 0c             	sub    $0xc,%esp
  8010c9:	68 04 43 80 00       	push   $0x804304
  8010ce:	e8 f1 02 00 00       	call   8013c4 <cprintf>
  8010d3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8010d6:	e8 e3 15 00 00       	call   8026be <sys_enable_interrupt>

	// exit gracefully
	exit();
  8010db:	e8 19 00 00 00       	call   8010f9 <exit>
}
  8010e0:	90                   	nop
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 70 17 00 00       	call   802863 <sys_destroy_env>
  8010f3:	83 c4 10             	add    $0x10,%esp
}
  8010f6:	90                   	nop
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <exit>:

void
exit(void)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8010ff:	e8 c5 17 00 00       	call   8028c9 <sys_exit_env>
}
  801104:	90                   	nop
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80110d:	8d 45 10             	lea    0x10(%ebp),%eax
  801110:	83 c0 04             	add    $0x4,%eax
  801113:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801116:	a1 18 51 80 00       	mov    0x805118,%eax
  80111b:	85 c0                	test   %eax,%eax
  80111d:	74 16                	je     801135 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80111f:	a1 18 51 80 00       	mov    0x805118,%eax
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	50                   	push   %eax
  801128:	68 c0 43 80 00       	push   $0x8043c0
  80112d:	e8 92 02 00 00       	call   8013c4 <cprintf>
  801132:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801135:	a1 00 50 80 00       	mov    0x805000,%eax
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	50                   	push   %eax
  801141:	68 c5 43 80 00       	push   $0x8043c5
  801146:	e8 79 02 00 00       	call   8013c4 <cprintf>
  80114b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	ff 75 f4             	pushl  -0xc(%ebp)
  801157:	50                   	push   %eax
  801158:	e8 fc 01 00 00       	call   801359 <vcprintf>
  80115d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	6a 00                	push   $0x0
  801165:	68 e1 43 80 00       	push   $0x8043e1
  80116a:	e8 ea 01 00 00       	call   801359 <vcprintf>
  80116f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801172:	e8 82 ff ff ff       	call   8010f9 <exit>

	// should not return here
	while (1) ;
  801177:	eb fe                	jmp    801177 <_panic+0x70>

00801179 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80117f:	a1 20 50 80 00       	mov    0x805020,%eax
  801184:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	39 c2                	cmp    %eax,%edx
  80118f:	74 14                	je     8011a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	68 e4 43 80 00       	push   $0x8043e4
  801199:	6a 26                	push   $0x26
  80119b:	68 30 44 80 00       	push   $0x804430
  8011a0:	e8 62 ff ff ff       	call   801107 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8011ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b3:	e9 c5 00 00 00       	jmp    80127d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	75 08                	jne    8011d5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8011d0:	e9 a5 00 00 00       	jmp    80127a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8011d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8011dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8011e3:	eb 69                	jmp    80124e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8011e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8011ea:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8011f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	01 c0                	add    %eax,%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	c1 e0 03             	shl    $0x3,%eax
  8011fc:	01 c8                	add    %ecx,%eax
  8011fe:	8a 40 04             	mov    0x4(%eax),%al
  801201:	84 c0                	test   %al,%al
  801203:	75 46                	jne    80124b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801205:	a1 20 50 80 00       	mov    0x805020,%eax
  80120a:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801210:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801213:	89 d0                	mov    %edx,%eax
  801215:	01 c0                	add    %eax,%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	c1 e0 03             	shl    $0x3,%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801223:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80122b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801230:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80123e:	39 c2                	cmp    %eax,%edx
  801240:	75 09                	jne    80124b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801242:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801249:	eb 15                	jmp    801260 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80124b:	ff 45 e8             	incl   -0x18(%ebp)
  80124e:	a1 20 50 80 00       	mov    0x805020,%eax
  801253:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  801259:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80125c:	39 c2                	cmp    %eax,%edx
  80125e:	77 85                	ja     8011e5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801260:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801264:	75 14                	jne    80127a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 3c 44 80 00       	push   $0x80443c
  80126e:	6a 3a                	push   $0x3a
  801270:	68 30 44 80 00       	push   $0x804430
  801275:	e8 8d fe ff ff       	call   801107 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80127a:	ff 45 f0             	incl   -0x10(%ebp)
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801283:	0f 8c 2f ff ff ff    	jl     8011b8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801289:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801290:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801297:	eb 26                	jmp    8012bf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801299:	a1 20 50 80 00       	mov    0x805020,%eax
  80129e:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8012a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012a7:	89 d0                	mov    %edx,%eax
  8012a9:	01 c0                	add    %eax,%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c1 e0 03             	shl    $0x3,%eax
  8012b0:	01 c8                	add    %ecx,%eax
  8012b2:	8a 40 04             	mov    0x4(%eax),%al
  8012b5:	3c 01                	cmp    $0x1,%al
  8012b7:	75 03                	jne    8012bc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8012b9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012bc:	ff 45 e0             	incl   -0x20(%ebp)
  8012bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c4:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8012ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012cd:	39 c2                	cmp    %eax,%edx
  8012cf:	77 c8                	ja     801299 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012d7:	74 14                	je     8012ed <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	68 90 44 80 00       	push   $0x804490
  8012e1:	6a 44                	push   $0x44
  8012e3:	68 30 44 80 00       	push   $0x804430
  8012e8:	e8 1a fe ff ff       	call   801107 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8012ed:	90                   	nop
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	8b 00                	mov    (%eax),%eax
  8012fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	89 0a                	mov    %ecx,(%edx)
  801303:	8b 55 08             	mov    0x8(%ebp),%edx
  801306:	88 d1                	mov    %dl,%cl
  801308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80130f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801312:	8b 00                	mov    (%eax),%eax
  801314:	3d ff 00 00 00       	cmp    $0xff,%eax
  801319:	75 2c                	jne    801347 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80131b:	a0 24 50 80 00       	mov    0x805024,%al
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	8b 12                	mov    (%edx),%edx
  801328:	89 d1                	mov    %edx,%ecx
  80132a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132d:	83 c2 08             	add    $0x8,%edx
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	50                   	push   %eax
  801334:	51                   	push   %ecx
  801335:	52                   	push   %edx
  801336:	e8 10 12 00 00       	call   80254b <sys_cputs>
  80133b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	8b 40 04             	mov    0x4(%eax),%eax
  80134d:	8d 50 01             	lea    0x1(%eax),%edx
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	89 50 04             	mov    %edx,0x4(%eax)
}
  801356:	90                   	nop
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801362:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801369:	00 00 00 
	b.cnt = 0;
  80136c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801373:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801376:	ff 75 0c             	pushl  0xc(%ebp)
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	68 f0 12 80 00       	push   $0x8012f0
  801388:	e8 11 02 00 00       	call   80159e <vprintfmt>
  80138d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801390:	a0 24 50 80 00       	mov    0x805024,%al
  801395:	0f b6 c0             	movzbl %al,%eax
  801398:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	50                   	push   %eax
  8013a2:	52                   	push   %edx
  8013a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013a9:	83 c0 08             	add    $0x8,%eax
  8013ac:	50                   	push   %eax
  8013ad:	e8 99 11 00 00       	call   80254b <sys_cputs>
  8013b2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8013b5:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8013bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8013ca:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8013d1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8013d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	83 ec 08             	sub    $0x8,%esp
  8013dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e0:	50                   	push   %eax
  8013e1:	e8 73 ff ff ff       	call   801359 <vcprintf>
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8013ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013f7:	e8 a8 12 00 00       	call   8026a4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8013fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	ff 75 f4             	pushl  -0xc(%ebp)
  80140b:	50                   	push   %eax
  80140c:	e8 48 ff ff ff       	call   801359 <vcprintf>
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801417:	e8 a2 12 00 00       	call   8026be <sys_enable_interrupt>
	return cnt;
  80141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 14             	sub    $0x14,%esp
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142e:	8b 45 14             	mov    0x14(%ebp),%eax
  801431:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801434:	8b 45 18             	mov    0x18(%ebp),%eax
  801437:	ba 00 00 00 00       	mov    $0x0,%edx
  80143c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80143f:	77 55                	ja     801496 <printnum+0x75>
  801441:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801444:	72 05                	jb     80144b <printnum+0x2a>
  801446:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801449:	77 4b                	ja     801496 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80144b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80144e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801451:	8b 45 18             	mov    0x18(%ebp),%eax
  801454:	ba 00 00 00 00       	mov    $0x0,%edx
  801459:	52                   	push   %edx
  80145a:	50                   	push   %eax
  80145b:	ff 75 f4             	pushl  -0xc(%ebp)
  80145e:	ff 75 f0             	pushl  -0x10(%ebp)
  801461:	e8 0a 29 00 00       	call   803d70 <__udivdi3>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	ff 75 20             	pushl  0x20(%ebp)
  80146f:	53                   	push   %ebx
  801470:	ff 75 18             	pushl  0x18(%ebp)
  801473:	52                   	push   %edx
  801474:	50                   	push   %eax
  801475:	ff 75 0c             	pushl  0xc(%ebp)
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 a1 ff ff ff       	call   801421 <printnum>
  801480:	83 c4 20             	add    $0x20,%esp
  801483:	eb 1a                	jmp    80149f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	ff 75 20             	pushl  0x20(%ebp)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	ff d0                	call   *%eax
  801493:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801496:	ff 4d 1c             	decl   0x1c(%ebp)
  801499:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80149d:	7f e6                	jg     801485 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80149f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8014a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ad:	53                   	push   %ebx
  8014ae:	51                   	push   %ecx
  8014af:	52                   	push   %edx
  8014b0:	50                   	push   %eax
  8014b1:	e8 ca 29 00 00       	call   803e80 <__umoddi3>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	05 f4 46 80 00       	add    $0x8046f4,%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	0f be c0             	movsbl %al,%eax
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	50                   	push   %eax
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	ff d0                	call   *%eax
  8014cf:	83 c4 10             	add    $0x10,%esp
}
  8014d2:	90                   	nop
  8014d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8014db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8014df:	7e 1c                	jle    8014fd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	8d 50 08             	lea    0x8(%eax),%edx
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	89 10                	mov    %edx,(%eax)
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	83 e8 08             	sub    $0x8,%eax
  8014f6:	8b 50 04             	mov    0x4(%eax),%edx
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	eb 40                	jmp    80153d <getuint+0x65>
	else if (lflag)
  8014fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801501:	74 1e                	je     801521 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8b 00                	mov    (%eax),%eax
  801508:	8d 50 04             	lea    0x4(%eax),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	89 10                	mov    %edx,(%eax)
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 e8 04             	sub    $0x4,%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	eb 1c                	jmp    80153d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8b 00                	mov    (%eax),%eax
  801526:	8d 50 04             	lea    0x4(%eax),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	89 10                	mov    %edx,(%eax)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8b 00                	mov    (%eax),%eax
  801533:	83 e8 04             	sub    $0x4,%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801542:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801546:	7e 1c                	jle    801564 <getint+0x25>
		return va_arg(*ap, long long);
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	8d 50 08             	lea    0x8(%eax),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	89 10                	mov    %edx,(%eax)
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8b 00                	mov    (%eax),%eax
  80155a:	83 e8 08             	sub    $0x8,%eax
  80155d:	8b 50 04             	mov    0x4(%eax),%edx
  801560:	8b 00                	mov    (%eax),%eax
  801562:	eb 38                	jmp    80159c <getint+0x5d>
	else if (lflag)
  801564:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801568:	74 1a                	je     801584 <getint+0x45>
		return va_arg(*ap, long);
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 50 04             	lea    0x4(%eax),%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 10                	mov    %edx,(%eax)
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8b 00                	mov    (%eax),%eax
  80157c:	83 e8 04             	sub    $0x4,%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	99                   	cltd   
  801582:	eb 18                	jmp    80159c <getint+0x5d>
	else
		return va_arg(*ap, int);
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8b 00                	mov    (%eax),%eax
  801589:	8d 50 04             	lea    0x4(%eax),%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 10                	mov    %edx,(%eax)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8b 00                	mov    (%eax),%eax
  801596:	83 e8 04             	sub    $0x4,%eax
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	99                   	cltd   
}
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015a6:	eb 17                	jmp    8015bf <vprintfmt+0x21>
			if (ch == '\0')
  8015a8:	85 db                	test   %ebx,%ebx
  8015aa:	0f 84 af 03 00 00    	je     80195f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	53                   	push   %ebx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	ff d0                	call   *%eax
  8015bc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	8d 50 01             	lea    0x1(%eax),%edx
  8015c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d8             	movzbl %al,%ebx
  8015cd:	83 fb 25             	cmp    $0x25,%ebx
  8015d0:	75 d6                	jne    8015a8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8015d2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8015d6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8015dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8015e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8015eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	8d 50 01             	lea    0x1(%eax),%edx
  8015f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	0f b6 d8             	movzbl %al,%ebx
  801600:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801603:	83 f8 55             	cmp    $0x55,%eax
  801606:	0f 87 2b 03 00 00    	ja     801937 <vprintfmt+0x399>
  80160c:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  801613:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801615:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801619:	eb d7                	jmp    8015f2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80161b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80161f:	eb d1                	jmp    8015f2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801621:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80162b:	89 d0                	mov    %edx,%eax
  80162d:	c1 e0 02             	shl    $0x2,%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	01 c0                	add    %eax,%eax
  801634:	01 d8                	add    %ebx,%eax
  801636:	83 e8 30             	sub    $0x30,%eax
  801639:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801644:	83 fb 2f             	cmp    $0x2f,%ebx
  801647:	7e 3e                	jle    801687 <vprintfmt+0xe9>
  801649:	83 fb 39             	cmp    $0x39,%ebx
  80164c:	7f 39                	jg     801687 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80164e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801651:	eb d5                	jmp    801628 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801653:	8b 45 14             	mov    0x14(%ebp),%eax
  801656:	83 c0 04             	add    $0x4,%eax
  801659:	89 45 14             	mov    %eax,0x14(%ebp)
  80165c:	8b 45 14             	mov    0x14(%ebp),%eax
  80165f:	83 e8 04             	sub    $0x4,%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801667:	eb 1f                	jmp    801688 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801669:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80166d:	79 83                	jns    8015f2 <vprintfmt+0x54>
				width = 0;
  80166f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801676:	e9 77 ff ff ff       	jmp    8015f2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80167b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801682:	e9 6b ff ff ff       	jmp    8015f2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801687:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801688:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80168c:	0f 89 60 ff ff ff    	jns    8015f2 <vprintfmt+0x54>
				width = precision, precision = -1;
  801692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801698:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80169f:	e9 4e ff ff ff       	jmp    8015f2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8016a4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8016a7:	e9 46 ff ff ff       	jmp    8015f2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8016ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8016af:	83 c0 04             	add    $0x4,%eax
  8016b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8016b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b8:	83 e8 04             	sub    $0x4,%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	ff 75 0c             	pushl  0xc(%ebp)
  8016c3:	50                   	push   %eax
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	ff d0                	call   *%eax
  8016c9:	83 c4 10             	add    $0x10,%esp
			break;
  8016cc:	e9 89 02 00 00       	jmp    80195a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8016d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d4:	83 c0 04             	add    $0x4,%eax
  8016d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	83 e8 04             	sub    $0x4,%eax
  8016e0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8016e2:	85 db                	test   %ebx,%ebx
  8016e4:	79 02                	jns    8016e8 <vprintfmt+0x14a>
				err = -err;
  8016e6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8016e8:	83 fb 64             	cmp    $0x64,%ebx
  8016eb:	7f 0b                	jg     8016f8 <vprintfmt+0x15a>
  8016ed:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  8016f4:	85 f6                	test   %esi,%esi
  8016f6:	75 19                	jne    801711 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8016f8:	53                   	push   %ebx
  8016f9:	68 05 47 80 00       	push   $0x804705
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	e8 5e 02 00 00       	call   801967 <printfmt>
  801709:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80170c:	e9 49 02 00 00       	jmp    80195a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801711:	56                   	push   %esi
  801712:	68 0e 47 80 00       	push   $0x80470e
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	e8 45 02 00 00       	call   801967 <printfmt>
  801722:	83 c4 10             	add    $0x10,%esp
			break;
  801725:	e9 30 02 00 00       	jmp    80195a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80172a:	8b 45 14             	mov    0x14(%ebp),%eax
  80172d:	83 c0 04             	add    $0x4,%eax
  801730:	89 45 14             	mov    %eax,0x14(%ebp)
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	83 e8 04             	sub    $0x4,%eax
  801739:	8b 30                	mov    (%eax),%esi
  80173b:	85 f6                	test   %esi,%esi
  80173d:	75 05                	jne    801744 <vprintfmt+0x1a6>
				p = "(null)";
  80173f:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  801744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801748:	7e 6d                	jle    8017b7 <vprintfmt+0x219>
  80174a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80174e:	74 67                	je     8017b7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	50                   	push   %eax
  801757:	56                   	push   %esi
  801758:	e8 0c 03 00 00       	call   801a69 <strnlen>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801763:	eb 16                	jmp    80177b <vprintfmt+0x1dd>
					putch(padc, putdat);
  801765:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	50                   	push   %eax
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	ff d0                	call   *%eax
  801775:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801778:	ff 4d e4             	decl   -0x1c(%ebp)
  80177b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80177f:	7f e4                	jg     801765 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801781:	eb 34                	jmp    8017b7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801783:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801787:	74 1c                	je     8017a5 <vprintfmt+0x207>
  801789:	83 fb 1f             	cmp    $0x1f,%ebx
  80178c:	7e 05                	jle    801793 <vprintfmt+0x1f5>
  80178e:	83 fb 7e             	cmp    $0x7e,%ebx
  801791:	7e 12                	jle    8017a5 <vprintfmt+0x207>
					putch('?', putdat);
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	6a 3f                	push   $0x3f
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	ff d0                	call   *%eax
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	eb 0f                	jmp    8017b4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	53                   	push   %ebx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	ff d0                	call   *%eax
  8017b1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8017b7:	89 f0                	mov    %esi,%eax
  8017b9:	8d 70 01             	lea    0x1(%eax),%esi
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	0f be d8             	movsbl %al,%ebx
  8017c1:	85 db                	test   %ebx,%ebx
  8017c3:	74 24                	je     8017e9 <vprintfmt+0x24b>
  8017c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017c9:	78 b8                	js     801783 <vprintfmt+0x1e5>
  8017cb:	ff 4d e0             	decl   -0x20(%ebp)
  8017ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d2:	79 af                	jns    801783 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8017d4:	eb 13                	jmp    8017e9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	6a 20                	push   $0x20
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	ff d0                	call   *%eax
  8017e3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8017e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8017e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017ed:	7f e7                	jg     8017d6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8017ef:	e9 66 01 00 00       	jmp    80195a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8017fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8017fd:	50                   	push   %eax
  8017fe:	e8 3c fd ff ff       	call   80153f <getint>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801809:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801812:	85 d2                	test   %edx,%edx
  801814:	79 23                	jns    801839 <vprintfmt+0x29b>
				putch('-', putdat);
  801816:	83 ec 08             	sub    $0x8,%esp
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	6a 2d                	push   $0x2d
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	ff d0                	call   *%eax
  801823:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182c:	f7 d8                	neg    %eax
  80182e:	83 d2 00             	adc    $0x0,%edx
  801831:	f7 da                	neg    %edx
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801839:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801840:	e9 bc 00 00 00       	jmp    801901 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 e8             	pushl  -0x18(%ebp)
  80184b:	8d 45 14             	lea    0x14(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	e8 84 fc ff ff       	call   8014d8 <getuint>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80185d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801864:	e9 98 00 00 00       	jmp    801901 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	6a 58                	push   $0x58
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	ff d0                	call   *%eax
  801876:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801879:	83 ec 08             	sub    $0x8,%esp
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	6a 58                	push   $0x58
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	ff d0                	call   *%eax
  801886:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	6a 58                	push   $0x58
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	ff d0                	call   *%eax
  801896:	83 c4 10             	add    $0x10,%esp
			break;
  801899:	e9 bc 00 00 00       	jmp    80195a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	6a 30                	push   $0x30
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	ff d0                	call   *%eax
  8018ab:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	6a 78                	push   $0x78
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	ff d0                	call   *%eax
  8018bb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8018be:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c1:	83 c0 04             	add    $0x4,%eax
  8018c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8018c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ca:	83 e8 04             	sub    $0x4,%eax
  8018cd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8018d9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8018e0:	eb 1f                	jmp    801901 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8018e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	e8 e7 fb ff ff       	call   8014d8 <getuint>
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8018fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801901:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	52                   	push   %edx
  80190c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80190f:	50                   	push   %eax
  801910:	ff 75 f4             	pushl  -0xc(%ebp)
  801913:	ff 75 f0             	pushl  -0x10(%ebp)
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	e8 00 fb ff ff       	call   801421 <printnum>
  801921:	83 c4 20             	add    $0x20,%esp
			break;
  801924:	eb 34                	jmp    80195a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	53                   	push   %ebx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	ff d0                	call   *%eax
  801932:	83 c4 10             	add    $0x10,%esp
			break;
  801935:	eb 23                	jmp    80195a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	6a 25                	push   $0x25
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	ff d0                	call   *%eax
  801944:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801947:	ff 4d 10             	decl   0x10(%ebp)
  80194a:	eb 03                	jmp    80194f <vprintfmt+0x3b1>
  80194c:	ff 4d 10             	decl   0x10(%ebp)
  80194f:	8b 45 10             	mov    0x10(%ebp),%eax
  801952:	48                   	dec    %eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	3c 25                	cmp    $0x25,%al
  801957:	75 f3                	jne    80194c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801959:	90                   	nop
		}
	}
  80195a:	e9 47 fc ff ff       	jmp    8015a6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80195f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801960:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80196d:	8d 45 10             	lea    0x10(%ebp),%eax
  801970:	83 c0 04             	add    $0x4,%eax
  801973:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801976:	8b 45 10             	mov    0x10(%ebp),%eax
  801979:	ff 75 f4             	pushl  -0xc(%ebp)
  80197c:	50                   	push   %eax
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	e8 16 fc ff ff       	call   80159e <vprintfmt>
  801988:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	8b 40 08             	mov    0x8(%eax),%eax
  801997:	8d 50 01             	lea    0x1(%eax),%edx
  80199a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8019a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a3:	8b 10                	mov    (%eax),%edx
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	8b 40 04             	mov    0x4(%eax),%eax
  8019ab:	39 c2                	cmp    %eax,%edx
  8019ad:	73 12                	jae    8019c1 <sprintputch+0x33>
		*b->buf++ = ch;
  8019af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b2:	8b 00                	mov    (%eax),%eax
  8019b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	89 0a                	mov    %ecx,(%edx)
  8019bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8019bf:	88 10                	mov    %dl,(%eax)
}
  8019c1:	90                   	nop
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    

008019c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	01 d0                	add    %edx,%eax
  8019db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8019e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019e9:	74 06                	je     8019f1 <vsnprintf+0x2d>
  8019eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ef:	7f 07                	jg     8019f8 <vsnprintf+0x34>
		return -E_INVAL;
  8019f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f6:	eb 20                	jmp    801a18 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8019f8:	ff 75 14             	pushl  0x14(%ebp)
  8019fb:	ff 75 10             	pushl  0x10(%ebp)
  8019fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a01:	50                   	push   %eax
  801a02:	68 8e 19 80 00       	push   $0x80198e
  801a07:	e8 92 fb ff ff       	call   80159e <vprintfmt>
  801a0c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a12:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801a20:	8d 45 10             	lea    0x10(%ebp),%eax
  801a23:	83 c0 04             	add    $0x4,%eax
  801a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801a29:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2f:	50                   	push   %eax
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 89 ff ff ff       	call   8019c4 <vsnprintf>
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801a4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a53:	eb 06                	jmp    801a5b <strlen+0x15>
		n++;
  801a55:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801a58:	ff 45 08             	incl   0x8(%ebp)
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	84 c0                	test   %al,%al
  801a62:	75 f1                	jne    801a55 <strlen+0xf>
		n++;
	return n;
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a76:	eb 09                	jmp    801a81 <strnlen+0x18>
		n++;
  801a78:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a7b:	ff 45 08             	incl   0x8(%ebp)
  801a7e:	ff 4d 0c             	decl   0xc(%ebp)
  801a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a85:	74 09                	je     801a90 <strnlen+0x27>
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	8a 00                	mov    (%eax),%al
  801a8c:	84 c0                	test   %al,%al
  801a8e:	75 e8                	jne    801a78 <strnlen+0xf>
		n++;
	return n;
  801a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801aa1:	90                   	nop
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8d 50 01             	lea    0x1(%eax),%edx
  801aa8:	89 55 08             	mov    %edx,0x8(%ebp)
  801aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aae:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ab4:	8a 12                	mov    (%edx),%dl
  801ab6:	88 10                	mov    %dl,(%eax)
  801ab8:	8a 00                	mov    (%eax),%al
  801aba:	84 c0                	test   %al,%al
  801abc:	75 e4                	jne    801aa2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801acf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ad6:	eb 1f                	jmp    801af7 <strncpy+0x34>
		*dst++ = *src;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8d 50 01             	lea    0x1(%eax),%edx
  801ade:	89 55 08             	mov    %edx,0x8(%ebp)
  801ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae4:	8a 12                	mov    (%edx),%dl
  801ae6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	84 c0                	test   %al,%al
  801aef:	74 03                	je     801af4 <strncpy+0x31>
			src++;
  801af1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801af4:	ff 45 fc             	incl   -0x4(%ebp)
  801af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801afa:	3b 45 10             	cmp    0x10(%ebp),%eax
  801afd:	72 d9                	jb     801ad8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801b10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b14:	74 30                	je     801b46 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801b16:	eb 16                	jmp    801b2e <strlcpy+0x2a>
			*dst++ = *src++;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	8d 50 01             	lea    0x1(%eax),%edx
  801b1e:	89 55 08             	mov    %edx,0x8(%ebp)
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b2a:	8a 12                	mov    (%edx),%dl
  801b2c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801b2e:	ff 4d 10             	decl   0x10(%ebp)
  801b31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b35:	74 09                	je     801b40 <strlcpy+0x3c>
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	8a 00                	mov    (%eax),%al
  801b3c:	84 c0                	test   %al,%al
  801b3e:	75 d8                	jne    801b18 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801b46:	8b 55 08             	mov    0x8(%ebp),%edx
  801b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4c:	29 c2                	sub    %eax,%edx
  801b4e:	89 d0                	mov    %edx,%eax
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801b55:	eb 06                	jmp    801b5d <strcmp+0xb>
		p++, q++;
  801b57:	ff 45 08             	incl   0x8(%ebp)
  801b5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	84 c0                	test   %al,%al
  801b64:	74 0e                	je     801b74 <strcmp+0x22>
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	8a 10                	mov    (%eax),%dl
  801b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6e:	8a 00                	mov    (%eax),%al
  801b70:	38 c2                	cmp    %al,%dl
  801b72:	74 e3                	je     801b57 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	8a 00                	mov    (%eax),%al
  801b79:	0f b6 d0             	movzbl %al,%edx
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	8a 00                	mov    (%eax),%al
  801b81:	0f b6 c0             	movzbl %al,%eax
  801b84:	29 c2                	sub    %eax,%edx
  801b86:	89 d0                	mov    %edx,%eax
}
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    

00801b8a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801b8d:	eb 09                	jmp    801b98 <strncmp+0xe>
		n--, p++, q++;
  801b8f:	ff 4d 10             	decl   0x10(%ebp)
  801b92:	ff 45 08             	incl   0x8(%ebp)
  801b95:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801b98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b9c:	74 17                	je     801bb5 <strncmp+0x2b>
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	84 c0                	test   %al,%al
  801ba5:	74 0e                	je     801bb5 <strncmp+0x2b>
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	8a 10                	mov    (%eax),%dl
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	8a 00                	mov    (%eax),%al
  801bb1:	38 c2                	cmp    %al,%dl
  801bb3:	74 da                	je     801b8f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801bb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bb9:	75 07                	jne    801bc2 <strncmp+0x38>
		return 0;
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc0:	eb 14                	jmp    801bd6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	8a 00                	mov    (%eax),%al
  801bc7:	0f b6 d0             	movzbl %al,%edx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	8a 00                	mov    (%eax),%al
  801bcf:	0f b6 c0             	movzbl %al,%eax
  801bd2:	29 c2                	sub    %eax,%edx
  801bd4:	89 d0                	mov    %edx,%eax
}
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801be4:	eb 12                	jmp    801bf8 <strchr+0x20>
		if (*s == c)
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801bee:	75 05                	jne    801bf5 <strchr+0x1d>
			return (char *) s;
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	eb 11                	jmp    801c06 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801bf5:	ff 45 08             	incl   0x8(%ebp)
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	84 c0                	test   %al,%al
  801bff:	75 e5                	jne    801be6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c11:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c14:	eb 0d                	jmp    801c23 <strfind+0x1b>
		if (*s == c)
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8a 00                	mov    (%eax),%al
  801c1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c1e:	74 0e                	je     801c2e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801c20:	ff 45 08             	incl   0x8(%ebp)
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	84 c0                	test   %al,%al
  801c2a:	75 ea                	jne    801c16 <strfind+0xe>
  801c2c:	eb 01                	jmp    801c2f <strfind+0x27>
		if (*s == c)
			break;
  801c2e:	90                   	nop
	return (char *) s;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801c46:	eb 0e                	jmp    801c56 <memset+0x22>
		*p++ = c;
  801c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4b:	8d 50 01             	lea    0x1(%eax),%edx
  801c4e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801c56:	ff 4d f8             	decl   -0x8(%ebp)
  801c59:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801c5d:	79 e9                	jns    801c48 <memset+0x14>
		*p++ = c;

	return v;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801c76:	eb 16                	jmp    801c8e <memcpy+0x2a>
		*d++ = *s++;
  801c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7b:	8d 50 01             	lea    0x1(%eax),%edx
  801c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c8a:	8a 12                	mov    (%edx),%dl
  801c8c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c94:	89 55 10             	mov    %edx,0x10(%ebp)
  801c97:	85 c0                	test   %eax,%eax
  801c99:	75 dd                	jne    801c78 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801cb8:	73 50                	jae    801d0a <memmove+0x6a>
  801cba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801cc5:	76 43                	jbe    801d0a <memmove+0x6a>
		s += n;
  801cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cca:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801cd3:	eb 10                	jmp    801ce5 <memmove+0x45>
			*--d = *--s;
  801cd5:	ff 4d f8             	decl   -0x8(%ebp)
  801cd8:	ff 4d fc             	decl   -0x4(%ebp)
  801cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cde:	8a 10                	mov    (%eax),%dl
  801ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ceb:	89 55 10             	mov    %edx,0x10(%ebp)
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	75 e3                	jne    801cd5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801cf2:	eb 23                	jmp    801d17 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8d 50 01             	lea    0x1(%eax),%edx
  801cfa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801cfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d00:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d03:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d06:	8a 12                	mov    (%edx),%dl
  801d08:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d10:	89 55 10             	mov    %edx,0x10(%ebp)
  801d13:	85 c0                	test   %eax,%eax
  801d15:	75 dd                	jne    801cf4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801d2e:	eb 2a                	jmp    801d5a <memcmp+0x3e>
		if (*s1 != *s2)
  801d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d33:	8a 10                	mov    (%eax),%dl
  801d35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d38:	8a 00                	mov    (%eax),%al
  801d3a:	38 c2                	cmp    %al,%dl
  801d3c:	74 16                	je     801d54 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d41:	8a 00                	mov    (%eax),%al
  801d43:	0f b6 d0             	movzbl %al,%edx
  801d46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	0f b6 c0             	movzbl %al,%eax
  801d4e:	29 c2                	sub    %eax,%edx
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	eb 18                	jmp    801d6c <memcmp+0x50>
		s1++, s2++;
  801d54:	ff 45 fc             	incl   -0x4(%ebp)
  801d57:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d60:	89 55 10             	mov    %edx,0x10(%ebp)
  801d63:	85 c0                	test   %eax,%eax
  801d65:	75 c9                	jne    801d30 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801d74:	8b 55 08             	mov    0x8(%ebp),%edx
  801d77:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7a:	01 d0                	add    %edx,%eax
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801d7f:	eb 15                	jmp    801d96 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	8a 00                	mov    (%eax),%al
  801d86:	0f b6 d0             	movzbl %al,%edx
  801d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8c:	0f b6 c0             	movzbl %al,%eax
  801d8f:	39 c2                	cmp    %eax,%edx
  801d91:	74 0d                	je     801da0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801d93:	ff 45 08             	incl   0x8(%ebp)
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d9c:	72 e3                	jb     801d81 <memfind+0x13>
  801d9e:	eb 01                	jmp    801da1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801da0:	90                   	nop
	return (void *) s;
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801dac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801db3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dba:	eb 03                	jmp    801dbf <strtol+0x19>
		s++;
  801dbc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8a 00                	mov    (%eax),%al
  801dc4:	3c 20                	cmp    $0x20,%al
  801dc6:	74 f4                	je     801dbc <strtol+0x16>
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	8a 00                	mov    (%eax),%al
  801dcd:	3c 09                	cmp    $0x9,%al
  801dcf:	74 eb                	je     801dbc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	8a 00                	mov    (%eax),%al
  801dd6:	3c 2b                	cmp    $0x2b,%al
  801dd8:	75 05                	jne    801ddf <strtol+0x39>
		s++;
  801dda:	ff 45 08             	incl   0x8(%ebp)
  801ddd:	eb 13                	jmp    801df2 <strtol+0x4c>
	else if (*s == '-')
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	3c 2d                	cmp    $0x2d,%al
  801de6:	75 0a                	jne    801df2 <strtol+0x4c>
		s++, neg = 1;
  801de8:	ff 45 08             	incl   0x8(%ebp)
  801deb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df6:	74 06                	je     801dfe <strtol+0x58>
  801df8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801dfc:	75 20                	jne    801e1e <strtol+0x78>
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	8a 00                	mov    (%eax),%al
  801e03:	3c 30                	cmp    $0x30,%al
  801e05:	75 17                	jne    801e1e <strtol+0x78>
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	40                   	inc    %eax
  801e0b:	8a 00                	mov    (%eax),%al
  801e0d:	3c 78                	cmp    $0x78,%al
  801e0f:	75 0d                	jne    801e1e <strtol+0x78>
		s += 2, base = 16;
  801e11:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801e15:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801e1c:	eb 28                	jmp    801e46 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e22:	75 15                	jne    801e39 <strtol+0x93>
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	8a 00                	mov    (%eax),%al
  801e29:	3c 30                	cmp    $0x30,%al
  801e2b:	75 0c                	jne    801e39 <strtol+0x93>
		s++, base = 8;
  801e2d:	ff 45 08             	incl   0x8(%ebp)
  801e30:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801e37:	eb 0d                	jmp    801e46 <strtol+0xa0>
	else if (base == 0)
  801e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3d:	75 07                	jne    801e46 <strtol+0xa0>
		base = 10;
  801e3f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	8a 00                	mov    (%eax),%al
  801e4b:	3c 2f                	cmp    $0x2f,%al
  801e4d:	7e 19                	jle    801e68 <strtol+0xc2>
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	8a 00                	mov    (%eax),%al
  801e54:	3c 39                	cmp    $0x39,%al
  801e56:	7f 10                	jg     801e68 <strtol+0xc2>
			dig = *s - '0';
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	8a 00                	mov    (%eax),%al
  801e5d:	0f be c0             	movsbl %al,%eax
  801e60:	83 e8 30             	sub    $0x30,%eax
  801e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e66:	eb 42                	jmp    801eaa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8a 00                	mov    (%eax),%al
  801e6d:	3c 60                	cmp    $0x60,%al
  801e6f:	7e 19                	jle    801e8a <strtol+0xe4>
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	8a 00                	mov    (%eax),%al
  801e76:	3c 7a                	cmp    $0x7a,%al
  801e78:	7f 10                	jg     801e8a <strtol+0xe4>
			dig = *s - 'a' + 10;
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	8a 00                	mov    (%eax),%al
  801e7f:	0f be c0             	movsbl %al,%eax
  801e82:	83 e8 57             	sub    $0x57,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 20                	jmp    801eaa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8a 00                	mov    (%eax),%al
  801e8f:	3c 40                	cmp    $0x40,%al
  801e91:	7e 39                	jle    801ecc <strtol+0x126>
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	8a 00                	mov    (%eax),%al
  801e98:	3c 5a                	cmp    $0x5a,%al
  801e9a:	7f 30                	jg     801ecc <strtol+0x126>
			dig = *s - 'A' + 10;
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	8a 00                	mov    (%eax),%al
  801ea1:	0f be c0             	movsbl %al,%eax
  801ea4:	83 e8 37             	sub    $0x37,%eax
  801ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	3b 45 10             	cmp    0x10(%ebp),%eax
  801eb0:	7d 19                	jge    801ecb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801eb2:	ff 45 08             	incl   0x8(%ebp)
  801eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb8:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	01 d0                	add    %edx,%eax
  801ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ec6:	e9 7b ff ff ff       	jmp    801e46 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ecb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed0:	74 08                	je     801eda <strtol+0x134>
		*endptr = (char *) s;
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ede:	74 07                	je     801ee7 <strtol+0x141>
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	f7 d8                	neg    %eax
  801ee5:	eb 03                	jmp    801eea <strtol+0x144>
  801ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <ltostr>:

void
ltostr(long value, char *str)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ef2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ef9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801f00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f04:	79 13                	jns    801f19 <ltostr+0x2d>
	{
		neg = 1;
  801f06:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801f13:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801f16:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801f21:	99                   	cltd   
  801f22:	f7 f9                	idiv   %ecx
  801f24:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f2a:	8d 50 01             	lea    0x1(%eax),%edx
  801f2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f35:	01 d0                	add    %edx,%eax
  801f37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f3a:	83 c2 30             	add    $0x30,%edx
  801f3d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801f3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f42:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801f47:	f7 e9                	imul   %ecx
  801f49:	c1 fa 02             	sar    $0x2,%edx
  801f4c:	89 c8                	mov    %ecx,%eax
  801f4e:	c1 f8 1f             	sar    $0x1f,%eax
  801f51:	29 c2                	sub    %eax,%edx
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801f60:	f7 e9                	imul   %ecx
  801f62:	c1 fa 02             	sar    $0x2,%edx
  801f65:	89 c8                	mov    %ecx,%eax
  801f67:	c1 f8 1f             	sar    $0x1f,%eax
  801f6a:	29 c2                	sub    %eax,%edx
  801f6c:	89 d0                	mov    %edx,%eax
  801f6e:	c1 e0 02             	shl    $0x2,%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	01 c0                	add    %eax,%eax
  801f75:	29 c1                	sub    %eax,%ecx
  801f77:	89 ca                	mov    %ecx,%edx
  801f79:	85 d2                	test   %edx,%edx
  801f7b:	75 9c                	jne    801f19 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801f84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f87:	48                   	dec    %eax
  801f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f8f:	74 3d                	je     801fce <ltostr+0xe2>
		start = 1 ;
  801f91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801f98:	eb 34                	jmp    801fce <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	8a 00                	mov    (%eax),%al
  801fa4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fad:	01 c2                	add    %eax,%edx
  801faf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb5:	01 c8                	add    %ecx,%eax
  801fb7:	8a 00                	mov    (%eax),%al
  801fb9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801fbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	01 c2                	add    %eax,%edx
  801fc3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801fc6:	88 02                	mov    %al,(%edx)
		start++ ;
  801fc8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801fcb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fd4:	7c c4                	jl     801f9a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801fd6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 54 fa ff ff       	call   801a46 <strlen>
  801ff2:	83 c4 04             	add    $0x4,%esp
  801ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	e8 46 fa ff ff       	call   801a46 <strlen>
  802000:	83 c4 04             	add    $0x4,%esp
  802003:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80200d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802014:	eb 17                	jmp    80202d <strcconcat+0x49>
		final[s] = str1[s] ;
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8b 45 10             	mov    0x10(%ebp),%eax
  80201c:	01 c2                	add    %eax,%edx
  80201e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	01 c8                	add    %ecx,%eax
  802026:	8a 00                	mov    (%eax),%al
  802028:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80202a:	ff 45 fc             	incl   -0x4(%ebp)
  80202d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802030:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802033:	7c e1                	jl     802016 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802035:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80203c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802043:	eb 1f                	jmp    802064 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802045:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802048:	8d 50 01             	lea    0x1(%eax),%edx
  80204b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80204e:	89 c2                	mov    %eax,%edx
  802050:	8b 45 10             	mov    0x10(%ebp),%eax
  802053:	01 c2                	add    %eax,%edx
  802055:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205b:	01 c8                	add    %ecx,%eax
  80205d:	8a 00                	mov    (%eax),%al
  80205f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802061:	ff 45 f8             	incl   -0x8(%ebp)
  802064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80206a:	7c d9                	jl     802045 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80206c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80206f:	8b 45 10             	mov    0x10(%ebp),%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	c6 00 00             	movb   $0x0,(%eax)
}
  802077:	90                   	nop
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80207d:	8b 45 14             	mov    0x14(%ebp),%eax
  802080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802086:	8b 45 14             	mov    0x14(%ebp),%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802092:	8b 45 10             	mov    0x10(%ebp),%eax
  802095:	01 d0                	add    %edx,%eax
  802097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80209d:	eb 0c                	jmp    8020ab <strsplit+0x31>
			*string++ = 0;
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8d 50 01             	lea    0x1(%eax),%edx
  8020a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8020a8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	8a 00                	mov    (%eax),%al
  8020b0:	84 c0                	test   %al,%al
  8020b2:	74 18                	je     8020cc <strsplit+0x52>
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	8a 00                	mov    (%eax),%al
  8020b9:	0f be c0             	movsbl %al,%eax
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	e8 13 fb ff ff       	call   801bd8 <strchr>
  8020c5:	83 c4 08             	add    $0x8,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 d3                	jne    80209f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8a 00                	mov    (%eax),%al
  8020d1:	84 c0                	test   %al,%al
  8020d3:	74 5a                	je     80212f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8020d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	83 f8 0f             	cmp    $0xf,%eax
  8020dd:	75 07                	jne    8020e6 <strsplit+0x6c>
		{
			return 0;
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	eb 66                	jmp    80214c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8020e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e9:	8b 00                	mov    (%eax),%eax
  8020eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8020ee:	8b 55 14             	mov    0x14(%ebp),%edx
  8020f1:	89 0a                	mov    %ecx,(%edx)
  8020f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fd:	01 c2                	add    %eax,%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802104:	eb 03                	jmp    802109 <strsplit+0x8f>
			string++;
  802106:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8a 00                	mov    (%eax),%al
  80210e:	84 c0                	test   %al,%al
  802110:	74 8b                	je     80209d <strsplit+0x23>
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8a 00                	mov    (%eax),%al
  802117:	0f be c0             	movsbl %al,%eax
  80211a:	50                   	push   %eax
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	e8 b5 fa ff ff       	call   801bd8 <strchr>
  802123:	83 c4 08             	add    $0x8,%esp
  802126:	85 c0                	test   %eax,%eax
  802128:	74 dc                	je     802106 <strsplit+0x8c>
			string++;
	}
  80212a:	e9 6e ff ff ff       	jmp    80209d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80212f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802130:	8b 45 14             	mov    0x14(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802147:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  802154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80215b:	eb 4c                	jmp    8021a9 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80215d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802160:	8b 45 0c             	mov    0xc(%ebp),%eax
  802163:	01 d0                	add    %edx,%eax
  802165:	8a 00                	mov    (%eax),%al
  802167:	3c 40                	cmp    $0x40,%al
  802169:	7e 27                	jle    802192 <str2lower+0x44>
  80216b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80216e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	8a 00                	mov    (%eax),%al
  802175:	3c 5a                	cmp    $0x5a,%al
  802177:	7f 19                	jg     802192 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  802179:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	01 ca                	add    %ecx,%edx
  802189:	8a 12                	mov    (%edx),%dl
  80218b:	83 c2 20             	add    $0x20,%edx
  80218e:	88 10                	mov    %dl,(%eax)
  802190:	eb 14                	jmp    8021a6 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  802192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	01 c2                	add    %eax,%edx
  80219a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80219d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a0:	01 c8                	add    %ecx,%eax
  8021a2:	8a 00                	mov    (%eax),%al
  8021a4:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8021a6:	ff 45 fc             	incl   -0x4(%ebp)
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	e8 95 f8 ff ff       	call   801a46 <strlen>
  8021b1:	83 c4 04             	add    $0x4,%esp
  8021b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8021b7:	7f a4                	jg     80215d <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  8021c1:	a1 04 50 80 00       	mov    0x805004,%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 0a                	je     8021d4 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8021ca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8021d1:	00 00 00 
	}
}
  8021d4:	90                   	nop
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    

008021d7 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	ff 75 08             	pushl  0x8(%ebp)
  8021e3:	e8 7e 09 00 00       	call   802b66 <sys_sbrk>
  8021e8:	83 c4 10             	add    $0x10,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021f3:	e8 c6 ff ff ff       	call   8021be <InitializeUHeap>
	if (size == 0)
  8021f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fc:	75 0a                	jne    802208 <malloc+0x1b>
		return NULL;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	e9 3f 01 00 00       	jmp    802347 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  802208:	e8 ac 09 00 00       	call   802bb9 <sys_get_hard_limit>
  80220d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  802210:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  802217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80221f:	c1 e8 0c             	shr    $0xc,%eax
  802222:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  802225:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
  80222f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802232:	01 d0                	add    %edx,%eax
  802234:	48                   	dec    %eax
  802235:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80223b:	ba 00 00 00 00       	mov    $0x0,%edx
  802240:	f7 75 d8             	divl   -0x28(%ebp)
  802243:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802246:	29 d0                	sub    %edx,%eax
  802248:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  80224b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80224e:	c1 e8 0c             	shr    $0xc,%eax
  802251:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  802254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802258:	75 0a                	jne    802264 <malloc+0x77>
		return NULL;
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	e9 e3 00 00 00       	jmp    802347 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  802264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802267:	05 00 00 00 80       	add    $0x80000000,%eax
  80226c:	c1 e8 0c             	shr    $0xc,%eax
  80226f:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802274:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80227b:	77 19                	ja     802296 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	e8 60 0b 00 00       	call   802de8 <alloc_block_FF>
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  80228e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802291:	e9 b1 00 00 00       	jmp    802347 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  802296:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802299:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80229c:	eb 4d                	jmp    8022eb <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  80229e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a1:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	75 27                	jne    8022d3 <malloc+0xe6>
			{
				counter++;
  8022ac:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  8022af:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8022b3:	75 14                	jne    8022c9 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  8022b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b8:	05 00 00 08 00       	add    $0x80000,%eax
  8022bd:	c1 e0 0c             	shl    $0xc,%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  8022c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  8022c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8022cf:	75 17                	jne    8022e8 <malloc+0xfb>
				{
					break;
  8022d1:	eb 21                	jmp    8022f4 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  8022d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d6:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  8022dd:	3c 01                	cmp    $0x1,%al
  8022df:	75 07                	jne    8022e8 <malloc+0xfb>
			{
				counter = 0;
  8022e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  8022e8:	ff 45 e8             	incl   -0x18(%ebp)
  8022eb:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  8022f2:	76 aa                	jbe    80229e <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  8022f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f7:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8022fa:	75 46                	jne    802342 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  8022fc:	83 ec 08             	sub    $0x8,%esp
  8022ff:	ff 75 d0             	pushl  -0x30(%ebp)
  802302:	ff 75 f4             	pushl  -0xc(%ebp)
  802305:	e8 93 08 00 00       	call   802b9d <sys_allocate_user_mem>
  80230a:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802313:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  80231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802320:	eb 0e                	jmp    802330 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  802322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802325:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  80232c:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  80232d:	ff 45 e4             	incl   -0x1c(%ebp)
  802330:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802336:	01 d0                	add    %edx,%eax
  802338:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80233b:	77 e5                	ja     802322 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	eb 05                	jmp    802347 <malloc+0x15a>
		}
	}

	return NULL;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80234f:	e8 65 08 00 00       	call   802bb9 <sys_get_hard_limit>
  802354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  80235d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802361:	0f 84 c1 00 00 00    	je     802428 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  802367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	79 1b                	jns    802389 <free+0x40>
  80236e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802371:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802374:	73 13                	jae    802389 <free+0x40>
    {
        free_block(virtual_address);
  802376:	83 ec 0c             	sub    $0xc,%esp
  802379:	ff 75 08             	pushl  0x8(%ebp)
  80237c:	e8 34 10 00 00       	call   8033b5 <free_block>
  802381:	83 c4 10             	add    $0x10,%esp
    	return;
  802384:	e9 a6 00 00 00       	jmp    80242f <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	05 00 10 00 00       	add    $0x1000,%eax
  802391:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802394:	0f 87 91 00 00 00    	ja     80242b <free+0xe2>
  80239a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8023a1:	0f 87 84 00 00 00    	ja     80242b <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  8023a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	05 00 00 00 80       	add    $0x80000000,%eax
  8023c0:	c1 e8 0c             	shr    $0xc,%eax
  8023c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  8023c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c9:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  8023d0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  8023d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023d7:	74 55                	je     80242e <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  8023d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023dc:	c1 e8 0c             	shr    $0xc,%eax
  8023df:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  8023e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e5:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  8023ec:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  8023f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f6:	eb 0e                	jmp    802406 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  802402:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  802403:	ff 45 f4             	incl   -0xc(%ebp)
  802406:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240c:	01 c2                	add    %eax,%edx
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	39 c2                	cmp    %eax,%edx
  802413:	77 e3                	ja     8023f8 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  802415:	83 ec 08             	sub    $0x8,%esp
  802418:	ff 75 e0             	pushl  -0x20(%ebp)
  80241b:	ff 75 ec             	pushl  -0x14(%ebp)
  80241e:	e8 5e 07 00 00       	call   802b81 <sys_free_user_mem>
  802423:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  802426:	eb 07                	jmp    80242f <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  802428:	90                   	nop
  802429:	eb 04                	jmp    80242f <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  80242b:	90                   	nop
  80242c:	eb 01                	jmp    80242f <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  80242e:	90                   	nop
    else
     {
    	return;
      }

}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 18             	sub    $0x18,%esp
  802437:	8b 45 10             	mov    0x10(%ebp),%eax
  80243a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80243d:	e8 7c fd ff ff       	call   8021be <InitializeUHeap>
	if (size == 0)
  802442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802446:	75 07                	jne    80244f <smalloc+0x1e>
		return NULL;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	eb 17                	jmp    802466 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	68 70 48 80 00       	push   $0x804870
  802457:	68 ad 00 00 00       	push   $0xad
  80245c:	68 96 48 80 00       	push   $0x804896
  802461:	e8 a1 ec ff ff       	call   801107 <_panic>
	return NULL;
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80246e:	e8 4b fd ff ff       	call   8021be <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 a4 48 80 00       	push   $0x8048a4
  80247b:	68 ba 00 00 00       	push   $0xba
  802480:	68 96 48 80 00       	push   $0x804896
  802485:	e8 7d ec ff ff       	call   801107 <_panic>

0080248a <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802490:	e8 29 fd ff ff       	call   8021be <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 c8 48 80 00       	push   $0x8048c8
  80249d:	68 d8 00 00 00       	push   $0xd8
  8024a2:	68 96 48 80 00       	push   $0x804896
  8024a7:	e8 5b ec ff ff       	call   801107 <_panic>

008024ac <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	68 f0 48 80 00       	push   $0x8048f0
  8024ba:	68 ea 00 00 00       	push   $0xea
  8024bf:	68 96 48 80 00       	push   $0x804896
  8024c4:	e8 3e ec ff ff       	call   801107 <_panic>

008024c9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 14 49 80 00       	push   $0x804914
  8024d7:	68 f2 00 00 00       	push   $0xf2
  8024dc:	68 96 48 80 00       	push   $0x804896
  8024e1:	e8 21 ec ff ff       	call   801107 <_panic>

008024e6 <shrink>:

}
void shrink(uint32 newSize) {
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	68 14 49 80 00       	push   $0x804914
  8024f4:	68 f6 00 00 00       	push   $0xf6
  8024f9:	68 96 48 80 00       	push   $0x804896
  8024fe:	e8 04 ec ff ff       	call   801107 <_panic>

00802503 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 14 49 80 00       	push   $0x804914
  802511:	68 fa 00 00 00       	push   $0xfa
  802516:	68 96 48 80 00       	push   $0x804896
  80251b:	e8 e7 eb ff ff       	call   801107 <_panic>

00802520 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	57                   	push   %edi
  802524:	56                   	push   %esi
  802525:	53                   	push   %ebx
  802526:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802532:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802535:	8b 7d 18             	mov    0x18(%ebp),%edi
  802538:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80253b:	cd 30                	int    $0x30
  80253d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	5b                   	pop    %ebx
  802547:	5e                   	pop    %esi
  802548:	5f                   	pop    %edi
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    

0080254b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	83 ec 04             	sub    $0x4,%esp
  802551:	8b 45 10             	mov    0x10(%ebp),%eax
  802554:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802557:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	52                   	push   %edx
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	50                   	push   %eax
  802567:	6a 00                	push   $0x0
  802569:	e8 b2 ff ff ff       	call   802520 <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
}
  802571:	90                   	nop
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_cgetc>:

int
sys_cgetc(void)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 01                	push   $0x1
  802583:	e8 98 ff ff ff       	call   802520 <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	52                   	push   %edx
  80259d:	50                   	push   %eax
  80259e:	6a 05                	push   $0x5
  8025a0:	e8 7b ff ff ff       	call   802520 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	56                   	push   %esi
  8025ae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025af:	8b 75 18             	mov    0x18(%ebp),%esi
  8025b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	56                   	push   %esi
  8025bf:	53                   	push   %ebx
  8025c0:	51                   	push   %ecx
  8025c1:	52                   	push   %edx
  8025c2:	50                   	push   %eax
  8025c3:	6a 06                	push   $0x6
  8025c5:	e8 56 ff ff ff       	call   802520 <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
}
  8025cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8025d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	52                   	push   %edx
  8025e4:	50                   	push   %eax
  8025e5:	6a 07                	push   $0x7
  8025e7:	e8 34 ff ff ff       	call   802520 <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	ff 75 0c             	pushl  0xc(%ebp)
  8025fd:	ff 75 08             	pushl  0x8(%ebp)
  802600:	6a 08                	push   $0x8
  802602:	e8 19 ff ff ff       	call   802520 <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 09                	push   $0x9
  80261b:	e8 00 ff ff ff       	call   802520 <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 0a                	push   $0xa
  802634:	e8 e7 fe ff ff       	call   802520 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 0b                	push   $0xb
  80264d:	e8 ce fe ff ff       	call   802520 <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 0c                	push   $0xc
  802666:	e8 b5 fe ff ff       	call   802520 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	ff 75 08             	pushl  0x8(%ebp)
  80267e:	6a 0d                	push   $0xd
  802680:	e8 9b fe ff ff       	call   802520 <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 0e                	push   $0xe
  802699:	e8 82 fe ff ff       	call   802520 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	90                   	nop
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 11                	push   $0x11
  8026b3:	e8 68 fe ff ff       	call   802520 <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	90                   	nop
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 12                	push   $0x12
  8026cd:	e8 4e fe ff ff       	call   802520 <syscall>
  8026d2:	83 c4 18             	add    $0x18,%esp
}
  8026d5:	90                   	nop
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	50                   	push   %eax
  8026f1:	6a 13                	push   $0x13
  8026f3:	e8 28 fe ff ff       	call   802520 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
}
  8026fb:	90                   	nop
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 14                	push   $0x14
  80270d:	e8 0e fe ff ff       	call   802520 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
}
  802715:	90                   	nop
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	ff 75 0c             	pushl  0xc(%ebp)
  802727:	50                   	push   %eax
  802728:	6a 15                	push   $0x15
  80272a:	e8 f1 fd ff ff       	call   802520 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	52                   	push   %edx
  802744:	50                   	push   %eax
  802745:	6a 18                	push   $0x18
  802747:	e8 d4 fd ff ff       	call   802520 <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802754:	8b 55 0c             	mov    0xc(%ebp),%edx
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	52                   	push   %edx
  802761:	50                   	push   %eax
  802762:	6a 16                	push   $0x16
  802764:	e8 b7 fd ff ff       	call   802520 <syscall>
  802769:	83 c4 18             	add    $0x18,%esp
}
  80276c:	90                   	nop
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802772:	8b 55 0c             	mov    0xc(%ebp),%edx
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	52                   	push   %edx
  80277f:	50                   	push   %eax
  802780:	6a 17                	push   $0x17
  802782:	e8 99 fd ff ff       	call   802520 <syscall>
  802787:	83 c4 18             	add    $0x18,%esp
}
  80278a:	90                   	nop
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	8b 45 10             	mov    0x10(%ebp),%eax
  802796:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802799:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80279c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	6a 00                	push   $0x0
  8027a5:	51                   	push   %ecx
  8027a6:	52                   	push   %edx
  8027a7:	ff 75 0c             	pushl  0xc(%ebp)
  8027aa:	50                   	push   %eax
  8027ab:	6a 19                	push   $0x19
  8027ad:	e8 6e fd ff ff       	call   802520 <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	52                   	push   %edx
  8027c7:	50                   	push   %eax
  8027c8:	6a 1a                	push   $0x1a
  8027ca:	e8 51 fd ff ff       	call   802520 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	51                   	push   %ecx
  8027e5:	52                   	push   %edx
  8027e6:	50                   	push   %eax
  8027e7:	6a 1b                	push   $0x1b
  8027e9:	e8 32 fd ff ff       	call   802520 <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	52                   	push   %edx
  802803:	50                   	push   %eax
  802804:	6a 1c                	push   $0x1c
  802806:	e8 15 fd ff ff       	call   802520 <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 1d                	push   $0x1d
  80281f:	e8 fc fc ff ff       	call   802520 <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	6a 00                	push   $0x0
  802831:	ff 75 14             	pushl  0x14(%ebp)
  802834:	ff 75 10             	pushl  0x10(%ebp)
  802837:	ff 75 0c             	pushl  0xc(%ebp)
  80283a:	50                   	push   %eax
  80283b:	6a 1e                	push   $0x1e
  80283d:	e8 de fc ff ff       	call   802520 <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	50                   	push   %eax
  802856:	6a 1f                	push   $0x1f
  802858:	e8 c3 fc ff ff       	call   802520 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
}
  802860:	90                   	nop
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	50                   	push   %eax
  802872:	6a 20                	push   $0x20
  802874:	e8 a7 fc ff ff       	call   802520 <syscall>
  802879:	83 c4 18             	add    $0x18,%esp
}
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 02                	push   $0x2
  80288d:	e8 8e fc ff ff       	call   802520 <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 03                	push   $0x3
  8028a6:	e8 75 fc ff ff       	call   802520 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 04                	push   $0x4
  8028bf:	e8 5c fc ff ff       	call   802520 <syscall>
  8028c4:	83 c4 18             	add    $0x18,%esp
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <sys_exit_env>:


void sys_exit_env(void)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 21                	push   $0x21
  8028d8:	e8 43 fc ff ff       	call   802520 <syscall>
  8028dd:	83 c4 18             	add    $0x18,%esp
}
  8028e0:	90                   	nop
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ec:	8d 50 04             	lea    0x4(%eax),%edx
  8028ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	52                   	push   %edx
  8028f9:	50                   	push   %eax
  8028fa:	6a 22                	push   $0x22
  8028fc:	e8 1f fc ff ff       	call   802520 <syscall>
  802901:	83 c4 18             	add    $0x18,%esp
	return result;
  802904:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802907:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80290a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80290d:	89 01                	mov    %eax,(%ecx)
  80290f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	c9                   	leave  
  802916:	c2 04 00             	ret    $0x4

00802919 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	ff 75 10             	pushl  0x10(%ebp)
  802923:	ff 75 0c             	pushl  0xc(%ebp)
  802926:	ff 75 08             	pushl  0x8(%ebp)
  802929:	6a 10                	push   $0x10
  80292b:	e8 f0 fb ff ff       	call   802520 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
	return ;
  802933:	90                   	nop
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <sys_rcr2>:
uint32 sys_rcr2()
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 23                	push   $0x23
  802945:	e8 d6 fb ff ff       	call   802520 <syscall>
  80294a:	83 c4 18             	add    $0x18,%esp
}
  80294d:	c9                   	leave  
  80294e:	c3                   	ret    

0080294f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80295b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	50                   	push   %eax
  802968:	6a 24                	push   $0x24
  80296a:	e8 b1 fb ff ff       	call   802520 <syscall>
  80296f:	83 c4 18             	add    $0x18,%esp
	return ;
  802972:	90                   	nop
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <rsttst>:
void rsttst()
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 26                	push   $0x26
  802984:	e8 97 fb ff ff       	call   802520 <syscall>
  802989:	83 c4 18             	add    $0x18,%esp
	return ;
  80298c:	90                   	nop
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	8b 45 14             	mov    0x14(%ebp),%eax
  802998:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80299b:	8b 55 18             	mov    0x18(%ebp),%edx
  80299e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029a2:	52                   	push   %edx
  8029a3:	50                   	push   %eax
  8029a4:	ff 75 10             	pushl  0x10(%ebp)
  8029a7:	ff 75 0c             	pushl  0xc(%ebp)
  8029aa:	ff 75 08             	pushl  0x8(%ebp)
  8029ad:	6a 25                	push   $0x25
  8029af:	e8 6c fb ff ff       	call   802520 <syscall>
  8029b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b7:	90                   	nop
}
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <chktst>:
void chktst(uint32 n)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	ff 75 08             	pushl  0x8(%ebp)
  8029c8:	6a 27                	push   $0x27
  8029ca:	e8 51 fb ff ff       	call   802520 <syscall>
  8029cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d2:	90                   	nop
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <inctst>:

void inctst()
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 28                	push   $0x28
  8029e4:	e8 37 fb ff ff       	call   802520 <syscall>
  8029e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ec:	90                   	nop
}
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

008029ef <gettst>:
uint32 gettst()
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 29                	push   $0x29
  8029fe:	e8 1d fb ff ff       	call   802520 <syscall>
  802a03:	83 c4 18             	add    $0x18,%esp
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
  802a0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 2a                	push   $0x2a
  802a1a:	e8 01 fb ff ff       	call   802520 <syscall>
  802a1f:	83 c4 18             	add    $0x18,%esp
  802a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a25:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a29:	75 07                	jne    802a32 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  802a30:	eb 05                	jmp    802a37 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 2a                	push   $0x2a
  802a4b:	e8 d0 fa ff ff       	call   802520 <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
  802a53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a56:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a5a:	75 07                	jne    802a63 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a5c:	b8 01 00 00 00       	mov    $0x1,%eax
  802a61:	eb 05                	jmp    802a68 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 2a                	push   $0x2a
  802a7c:	e8 9f fa ff ff       	call   802520 <syscall>
  802a81:	83 c4 18             	add    $0x18,%esp
  802a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a87:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a8b:	75 07                	jne    802a94 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a92:	eb 05                	jmp    802a99 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 2a                	push   $0x2a
  802aad:	e8 6e fa ff ff       	call   802520 <syscall>
  802ab2:	83 c4 18             	add    $0x18,%esp
  802ab5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ab8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802abc:	75 07                	jne    802ac5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	eb 05                	jmp    802aca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aca:	c9                   	leave  
  802acb:	c3                   	ret    

00802acc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802acc:	55                   	push   %ebp
  802acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	ff 75 08             	pushl  0x8(%ebp)
  802ada:	6a 2b                	push   $0x2b
  802adc:	e8 3f fa ff ff       	call   802520 <syscall>
  802ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae4:	90                   	nop
}
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aeb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	6a 00                	push   $0x0
  802af9:	53                   	push   %ebx
  802afa:	51                   	push   %ecx
  802afb:	52                   	push   %edx
  802afc:	50                   	push   %eax
  802afd:	6a 2c                	push   $0x2c
  802aff:	e8 1c fa ff ff       	call   802520 <syscall>
  802b04:	83 c4 18             	add    $0x18,%esp
}
  802b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	52                   	push   %edx
  802b1c:	50                   	push   %eax
  802b1d:	6a 2d                	push   $0x2d
  802b1f:	e8 fc f9 ff ff       	call   802520 <syscall>
  802b24:	83 c4 18             	add    $0x18,%esp
}
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b2c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	6a 00                	push   $0x0
  802b37:	51                   	push   %ecx
  802b38:	ff 75 10             	pushl  0x10(%ebp)
  802b3b:	52                   	push   %edx
  802b3c:	50                   	push   %eax
  802b3d:	6a 2e                	push   $0x2e
  802b3f:	e8 dc f9 ff ff       	call   802520 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 00                	push   $0x0
  802b50:	ff 75 10             	pushl  0x10(%ebp)
  802b53:	ff 75 0c             	pushl  0xc(%ebp)
  802b56:	ff 75 08             	pushl  0x8(%ebp)
  802b59:	6a 0f                	push   $0xf
  802b5b:	e8 c0 f9 ff ff       	call   802520 <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
	return ;
  802b63:	90                   	nop
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	50                   	push   %eax
  802b75:	6a 2f                	push   $0x2f
  802b77:	e8 a4 f9 ff ff       	call   802520 <syscall>
  802b7c:	83 c4 18             	add    $0x18,%esp

}
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802b84:	6a 00                	push   $0x0
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	ff 75 0c             	pushl  0xc(%ebp)
  802b8d:	ff 75 08             	pushl  0x8(%ebp)
  802b90:	6a 30                	push   $0x30
  802b92:	e8 89 f9 ff ff       	call   802520 <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
	return;
  802b9a:	90                   	nop
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	ff 75 0c             	pushl  0xc(%ebp)
  802ba9:	ff 75 08             	pushl  0x8(%ebp)
  802bac:	6a 31                	push   $0x31
  802bae:	e8 6d f9 ff ff       	call   802520 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
	return;
  802bb6:	90                   	nop
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 32                	push   $0x32
  802bc8:	e8 53 f9 ff ff       	call   802520 <syscall>
  802bcd:	83 c4 18             	add    $0x18,%esp
}
  802bd0:	c9                   	leave  
  802bd1:	c3                   	ret    

00802bd2 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802bd2:	55                   	push   %ebp
  802bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	50                   	push   %eax
  802be1:	6a 33                	push   $0x33
  802be3:	e8 38 f9 ff ff       	call   802520 <syscall>
  802be8:	83 c4 18             	add    $0x18,%esp
}
  802beb:	90                   	nop
  802bec:	c9                   	leave  
  802bed:	c3                   	ret    

00802bee <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802bee:	55                   	push   %ebp
  802bef:	89 e5                	mov    %esp,%ebp
  802bf1:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	83 e8 10             	sub    $0x10,%eax
  802bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	83 e8 10             	sub    $0x10,%eax
  802c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c16:	8a 40 04             	mov    0x4(%eax),%al
}
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    

00802c1b <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
  802c1e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2b:	83 f8 02             	cmp    $0x2,%eax
  802c2e:	74 2b                	je     802c5b <alloc_block+0x40>
  802c30:	83 f8 02             	cmp    $0x2,%eax
  802c33:	7f 07                	jg     802c3c <alloc_block+0x21>
  802c35:	83 f8 01             	cmp    $0x1,%eax
  802c38:	74 0e                	je     802c48 <alloc_block+0x2d>
  802c3a:	eb 58                	jmp    802c94 <alloc_block+0x79>
  802c3c:	83 f8 03             	cmp    $0x3,%eax
  802c3f:	74 2d                	je     802c6e <alloc_block+0x53>
  802c41:	83 f8 04             	cmp    $0x4,%eax
  802c44:	74 3b                	je     802c81 <alloc_block+0x66>
  802c46:	eb 4c                	jmp    802c94 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	ff 75 08             	pushl  0x8(%ebp)
  802c4e:	e8 95 01 00 00       	call   802de8 <alloc_block_FF>
  802c53:	83 c4 10             	add    $0x10,%esp
  802c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c59:	eb 4a                	jmp    802ca5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802c5b:	83 ec 0c             	sub    $0xc,%esp
  802c5e:	ff 75 08             	pushl  0x8(%ebp)
  802c61:	e8 32 07 00 00       	call   803398 <alloc_block_NF>
  802c66:	83 c4 10             	add    $0x10,%esp
  802c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c6c:	eb 37                	jmp    802ca5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	e8 a3 04 00 00       	call   80311c <alloc_block_BF>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c7f:	eb 24                	jmp    802ca5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802c81:	83 ec 0c             	sub    $0xc,%esp
  802c84:	ff 75 08             	pushl  0x8(%ebp)
  802c87:	e8 ef 06 00 00       	call   80337b <alloc_block_WF>
  802c8c:	83 c4 10             	add    $0x10,%esp
  802c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c92:	eb 11                	jmp    802ca5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802c94:	83 ec 0c             	sub    $0xc,%esp
  802c97:	68 24 49 80 00       	push   $0x804924
  802c9c:	e8 23 e7 ff ff       	call   8013c4 <cprintf>
  802ca1:	83 c4 10             	add    $0x10,%esp
		break;
  802ca4:	90                   	nop
	}
	return va;
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
  802cad:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802cb0:	83 ec 0c             	sub    $0xc,%esp
  802cb3:	68 44 49 80 00       	push   $0x804944
  802cb8:	e8 07 e7 ff ff       	call   8013c4 <cprintf>
  802cbd:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802cc0:	83 ec 0c             	sub    $0xc,%esp
  802cc3:	68 6f 49 80 00       	push   $0x80496f
  802cc8:	e8 f7 e6 ff ff       	call   8013c4 <cprintf>
  802ccd:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd6:	eb 26                	jmp    802cfe <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8a 40 04             	mov    0x4(%eax),%al
  802cde:	0f b6 d0             	movzbl %al,%edx
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	52                   	push   %edx
  802cea:	50                   	push   %eax
  802ceb:	68 87 49 80 00       	push   $0x804987
  802cf0:	e8 cf e6 ff ff       	call   8013c4 <cprintf>
  802cf5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  802cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d02:	74 08                	je     802d0c <print_blocks_list+0x62>
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 08             	mov    0x8(%eax),%eax
  802d0a:	eb 05                	jmp    802d11 <print_blocks_list+0x67>
  802d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d11:	89 45 10             	mov    %eax,0x10(%ebp)
  802d14:	8b 45 10             	mov    0x10(%ebp),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	75 bd                	jne    802cd8 <print_blocks_list+0x2e>
  802d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1f:	75 b7                	jne    802cd8 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	68 44 49 80 00       	push   $0x804944
  802d29:	e8 96 e6 ff ff       	call   8013c4 <cprintf>
  802d2e:	83 c4 10             	add    $0x10,%esp

}
  802d31:	90                   	nop
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
  802d37:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802d3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d3e:	0f 84 a1 00 00 00    	je     802de5 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802d44:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802d4b:	00 00 00 
	LIST_INIT(&list);
  802d4e:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802d55:	00 00 00 
  802d58:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  802d5f:	00 00 00 
  802d62:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802d69:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d85:	75 14                	jne    802d9b <initialize_dynamic_allocator+0x67>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 a0 49 80 00       	push   $0x8049a0
  802d8f:	6a 64                	push   $0x64
  802d91:	68 c3 49 80 00       	push   $0x8049c3
  802d96:	e8 6c e3 ff ff       	call   801107 <_panic>
  802d9b:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	89 50 0c             	mov    %edx,0xc(%eax)
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0d                	je     802dbe <initialize_dynamic_allocator+0x8a>
  802db1:	a1 44 51 90 00       	mov    0x905144,%eax
  802db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db9:	89 50 08             	mov    %edx,0x8(%eax)
  802dbc:	eb 08                	jmp    802dc6 <initialize_dynamic_allocator+0x92>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	a3 40 51 90 00       	mov    %eax,0x905140
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	a3 44 51 90 00       	mov    %eax,0x905144
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dd8:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ddd:	40                   	inc    %eax
  802dde:	a3 4c 51 90 00       	mov    %eax,0x90514c
  802de3:	eb 01                	jmp    802de6 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802de5:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
  802deb:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df2:	75 0a                	jne    802dfe <alloc_block_FF+0x16>
	{
		return NULL;
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	e9 1c 03 00 00       	jmp    80311a <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802dfe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	75 40                	jne    802e47 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	83 c0 10             	add    $0x10,%eax
  802e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	83 ec 0c             	sub    $0xc,%esp
  802e16:	50                   	push   %eax
  802e17:	e8 bb f3 ff ff       	call   8021d7 <sbrk>
  802e1c:	83 c4 10             	add    $0x10,%esp
  802e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	6a 00                	push   $0x0
  802e27:	e8 ab f3 ff ff       	call   8021d7 <sbrk>
  802e2c:	83 c4 10             	add    $0x10,%esp
  802e2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802e38:	83 ec 08             	sub    $0x8,%esp
  802e3b:	50                   	push   %eax
  802e3c:	ff 75 ec             	pushl  -0x14(%ebp)
  802e3f:	e8 f0 fe ff ff       	call   802d34 <initialize_dynamic_allocator>
  802e44:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802e47:	a1 40 51 90 00       	mov    0x905140,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	e9 1e 01 00 00       	jmp    802f72 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8d 50 10             	lea    0x10(%eax),%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	75 1c                	jne    802e7f <alloc_block_FF+0x97>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8a 40 04             	mov    0x4(%eax),%al
  802e69:	3c 01                	cmp    $0x1,%al
  802e6b:	75 12                	jne    802e7f <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	83 c0 10             	add    $0x10,%eax
  802e7a:	e9 9b 02 00 00       	jmp    80311a <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8d 50 10             	lea    0x10(%eax),%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	39 c2                	cmp    %eax,%edx
  802e8c:	0f 83 d8 00 00 00    	jae    802f6a <alloc_block_FF+0x182>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8a 40 04             	mov    0x4(%eax),%al
  802e98:	3c 01                	cmp    $0x1,%al
  802e9a:	0f 85 ca 00 00 00    	jne    802f6a <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	2b 45 08             	sub    0x8(%ebp),%eax
  802ea8:	83 e8 10             	sub    $0x10,%eax
  802eab:	83 f8 0f             	cmp    $0xf,%eax
  802eae:	0f 86 a4 00 00 00    	jbe    802f58 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	01 d0                	add    %edx,%eax
  802ebc:	83 c0 10             	add    $0x10,%eax
  802ebf:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	2b 45 08             	sub    0x8(%ebp),%eax
  802eca:	8d 50 f0             	lea    -0x10(%eax),%edx
  802ecd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ed0:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802ed2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ed5:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edd:	74 06                	je     802ee5 <alloc_block_FF+0xfd>
  802edf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802ee3:	75 17                	jne    802efc <alloc_block_FF+0x114>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 dc 49 80 00       	push   $0x8049dc
  802eed:	68 8f 00 00 00       	push   $0x8f
  802ef2:	68 c3 49 80 00       	push   $0x8049c3
  802ef7:	e8 0b e2 ff ff       	call   801107 <_panic>
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 50 08             	mov    0x8(%eax),%edx
  802f02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f05:	89 50 08             	mov    %edx,0x8(%eax)
  802f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 0c                	je     802f1e <alloc_block_FF+0x136>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 08             	mov    0x8(%eax),%eax
  802f18:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f1b:	89 50 0c             	mov    %edx,0xc(%eax)
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f24:	89 50 08             	mov    %edx,0x8(%eax)
  802f27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2d:	89 50 0c             	mov    %edx,0xc(%eax)
  802f30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	75 08                	jne    802f42 <alloc_block_FF+0x15a>
  802f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3d:	a3 44 51 90 00       	mov    %eax,0x905144
  802f42:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f47:	40                   	inc    %eax
  802f48:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8d 50 10             	lea    0x10(%eax),%edx
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	83 c0 10             	add    $0x10,%eax
  802f65:	e9 b0 01 00 00       	jmp    80311a <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802f6a:	a1 48 51 90 00       	mov    0x905148,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	74 08                	je     802f80 <alloc_block_FF+0x198>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	eb 05                	jmp    802f85 <alloc_block_FF+0x19d>
  802f80:	b8 00 00 00 00       	mov    $0x0,%eax
  802f85:	a3 48 51 90 00       	mov    %eax,0x905148
  802f8a:	a1 48 51 90 00       	mov    0x905148,%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	0f 85 bd fe ff ff    	jne    802e54 <alloc_block_FF+0x6c>
  802f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9b:	0f 85 b3 fe ff ff    	jne    802e54 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	83 c0 10             	add    $0x10,%eax
  802fa7:	83 ec 0c             	sub    $0xc,%esp
  802faa:	50                   	push   %eax
  802fab:	e8 27 f2 ff ff       	call   8021d7 <sbrk>
  802fb0:	83 c4 10             	add    $0x10,%esp
  802fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802fb6:	83 ec 0c             	sub    $0xc,%esp
  802fb9:	6a 00                	push   $0x0
  802fbb:	e8 17 f2 ff ff       	call   8021d7 <sbrk>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802fc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcc:	29 c2                	sub    %eax,%edx
  802fce:	89 d0                	mov    %edx,%eax
  802fd0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802fd3:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802fd7:	0f 84 38 01 00 00    	je     803115 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802fe3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802fe7:	75 17                	jne    803000 <alloc_block_FF+0x218>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 a0 49 80 00       	push   $0x8049a0
  802ff1:	68 9f 00 00 00       	push   $0x9f
  802ff6:	68 c3 49 80 00       	push   $0x8049c3
  802ffb:	e8 07 e1 ff ff       	call   801107 <_panic>
  803000:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803006:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803009:	89 50 0c             	mov    %edx,0xc(%eax)
  80300c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0d                	je     803023 <alloc_block_FF+0x23b>
  803016:	a1 44 51 90 00       	mov    0x905144,%eax
  80301b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80301e:	89 50 08             	mov    %edx,0x8(%eax)
  803021:	eb 08                	jmp    80302b <alloc_block_FF+0x243>
  803023:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803026:	a3 40 51 90 00       	mov    %eax,0x905140
  80302b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80302e:	a3 44 51 90 00       	mov    %eax,0x905144
  803033:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803036:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80303d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803042:	40                   	inc    %eax
  803043:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	8d 50 10             	lea    0x10(%eax),%edx
  80304e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  803053:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803056:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	2b 45 08             	sub    0x8(%ebp),%eax
  803060:	83 f8 10             	cmp    $0x10,%eax
  803063:	0f 84 a4 00 00 00    	je     80310d <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  803069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306c:	2b 45 08             	sub    0x8(%ebp),%eax
  80306f:	83 e8 10             	sub    $0x10,%eax
  803072:	83 f8 0f             	cmp    $0xf,%eax
  803075:	0f 86 8a 00 00 00    	jbe    803105 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  80307b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	01 d0                	add    %edx,%eax
  803083:	83 c0 10             	add    $0x10,%eax
  803086:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  803089:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80308d:	75 17                	jne    8030a6 <alloc_block_FF+0x2be>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 a0 49 80 00       	push   $0x8049a0
  803097:	68 a7 00 00 00       	push   $0xa7
  80309c:	68 c3 49 80 00       	push   $0x8049c3
  8030a1:	e8 61 e0 ff ff       	call   801107 <_panic>
  8030a6:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8030ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030af:	89 50 0c             	mov    %edx,0xc(%eax)
  8030b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0d                	je     8030c9 <alloc_block_FF+0x2e1>
  8030bc:	a1 44 51 90 00       	mov    0x905144,%eax
  8030c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030c4:	89 50 08             	mov    %edx,0x8(%eax)
  8030c7:	eb 08                	jmp    8030d1 <alloc_block_FF+0x2e9>
  8030c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030cc:	a3 40 51 90 00       	mov    %eax,0x905140
  8030d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030d4:	a3 44 51 90 00       	mov    %eax,0x905144
  8030d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030e3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030e8:	40                   	inc    %eax
  8030e9:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8030f4:	8d 50 f0             	lea    -0x10(%eax),%edx
  8030f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030fa:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8030fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030ff:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  803103:	eb 08                	jmp    80310d <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  803105:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803108:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310b:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  80310d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803110:	83 c0 10             	add    $0x10,%eax
  803113:	eb 05                	jmp    80311a <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  80311a:	c9                   	leave  
  80311b:	c3                   	ret    

0080311c <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80311c:	55                   	push   %ebp
  80311d:	89 e5                	mov    %esp,%ebp
  80311f:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  803122:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  803129:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312d:	75 0a                	jne    803139 <alloc_block_BF+0x1d>
	{
		return NULL;
  80312f:	b8 00 00 00 00       	mov    $0x0,%eax
  803134:	e9 40 02 00 00       	jmp    803379 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  803139:	a1 40 51 90 00       	mov    0x905140,%eax
  80313e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803141:	eb 66                	jmp    8031a9 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8a 40 04             	mov    0x4(%eax),%al
  803149:	3c 01                	cmp    $0x1,%al
  80314b:	75 21                	jne    80316e <alloc_block_BF+0x52>
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8d 50 10             	lea    0x10(%eax),%edx
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	39 c2                	cmp    %eax,%edx
  80315a:	75 12                	jne    80316e <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	83 c0 10             	add    $0x10,%eax
  803169:	e9 0b 02 00 00       	jmp    803379 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8a 40 04             	mov    0x4(%eax),%al
  803174:	3c 01                	cmp    $0x1,%al
  803176:	75 29                	jne    8031a1 <alloc_block_BF+0x85>
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	8d 50 10             	lea    0x10(%eax),%edx
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	39 c2                	cmp    %eax,%edx
  803185:	77 1a                	ja     8031a1 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  803187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318b:	74 0e                	je     80319b <alloc_block_BF+0x7f>
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 10                	mov    (%eax),%edx
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	39 c2                	cmp    %eax,%edx
  803199:	73 06                	jae    8031a1 <alloc_block_BF+0x85>
			{
				BF = iterator;
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  8031a1:	a1 48 51 90 00       	mov    0x905148,%eax
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ad:	74 08                	je     8031b7 <alloc_block_BF+0x9b>
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 40 08             	mov    0x8(%eax),%eax
  8031b5:	eb 05                	jmp    8031bc <alloc_block_BF+0xa0>
  8031b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bc:	a3 48 51 90 00       	mov    %eax,0x905148
  8031c1:	a1 48 51 90 00       	mov    0x905148,%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	0f 85 75 ff ff ff    	jne    803143 <alloc_block_BF+0x27>
  8031ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d2:	0f 85 6b ff ff ff    	jne    803143 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  8031d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031dc:	0f 84 f8 00 00 00    	je     8032da <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8d 50 10             	lea    0x10(%eax),%edx
  8031e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	39 c2                	cmp    %eax,%edx
  8031ef:	0f 87 e5 00 00 00    	ja     8032da <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	2b 45 08             	sub    0x8(%ebp),%eax
  8031fd:	83 e8 10             	sub    $0x10,%eax
  803200:	83 f8 0f             	cmp    $0xf,%eax
  803203:	0f 86 bf 00 00 00    	jbe    8032c8 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  803209:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	01 d0                	add    %edx,%eax
  803211:	83 c0 10             	add    $0x10,%eax
  803214:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  803217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	2b 45 08             	sub    0x8(%ebp),%eax
  803228:	8d 50 f0             	lea    -0x10(%eax),%edx
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  803230:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803233:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  803237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323b:	74 06                	je     803243 <alloc_block_BF+0x127>
  80323d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803241:	75 17                	jne    80325a <alloc_block_BF+0x13e>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 dc 49 80 00       	push   $0x8049dc
  80324b:	68 e3 00 00 00       	push   $0xe3
  803250:	68 c3 49 80 00       	push   $0x8049c3
  803255:	e8 ad de ff ff       	call   801107 <_panic>
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	8b 50 08             	mov    0x8(%eax),%edx
  803260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803263:	89 50 08             	mov    %edx,0x8(%eax)
  803266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803269:	8b 40 08             	mov    0x8(%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0c                	je     80327c <alloc_block_BF+0x160>
  803270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803273:	8b 40 08             	mov    0x8(%eax),%eax
  803276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803279:	89 50 0c             	mov    %edx,0xc(%eax)
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803282:	89 50 08             	mov    %edx,0x8(%eax)
  803285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803288:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328b:	89 50 0c             	mov    %edx,0xc(%eax)
  80328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	85 c0                	test   %eax,%eax
  803296:	75 08                	jne    8032a0 <alloc_block_BF+0x184>
  803298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329b:	a3 44 51 90 00       	mov    %eax,0x905144
  8032a0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	8d 50 10             	lea    0x10(%eax),%edx
  8032b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b4:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	83 c0 10             	add    $0x10,%eax
  8032c3:	e9 b1 00 00 00       	jmp    803379 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  8032c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  8032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d2:	83 c0 10             	add    $0x10,%eax
  8032d5:	e9 9f 00 00 00       	jmp    803379 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	83 c0 10             	add    $0x10,%eax
  8032e0:	83 ec 0c             	sub    $0xc,%esp
  8032e3:	50                   	push   %eax
  8032e4:	e8 ee ee ff ff       	call   8021d7 <sbrk>
  8032e9:	83 c4 10             	add    $0x10,%esp
  8032ec:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  8032ef:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8032f3:	74 7f                	je     803374 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8032f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f9:	75 17                	jne    803312 <alloc_block_BF+0x1f6>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 a0 49 80 00       	push   $0x8049a0
  803303:	68 f6 00 00 00       	push   $0xf6
  803308:	68 c3 49 80 00       	push   $0x8049c3
  80330d:	e8 f5 dd ff ff       	call   801107 <_panic>
  803312:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	89 50 0c             	mov    %edx,0xc(%eax)
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 40 0c             	mov    0xc(%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	74 0d                	je     803335 <alloc_block_BF+0x219>
  803328:	a1 44 51 90 00       	mov    0x905144,%eax
  80332d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803330:	89 50 08             	mov    %edx,0x8(%eax)
  803333:	eb 08                	jmp    80333d <alloc_block_BF+0x221>
  803335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803338:	a3 40 51 90 00       	mov    %eax,0x905140
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	a3 44 51 90 00       	mov    %eax,0x905144
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80334f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803354:	40                   	inc    %eax
  803355:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8d 50 10             	lea    0x10(%eax),%edx
  803360:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803363:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  80336c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336f:	83 c0 10             	add    $0x10,%eax
  803372:	eb 05                	jmp    803379 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  803374:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  803379:	c9                   	leave  
  80337a:	c3                   	ret    

0080337b <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  80337b:	55                   	push   %ebp
  80337c:	89 e5                	mov    %esp,%ebp
  80337e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803381:	83 ec 04             	sub    $0x4,%esp
  803384:	68 10 4a 80 00       	push   $0x804a10
  803389:	68 07 01 00 00       	push   $0x107
  80338e:	68 c3 49 80 00       	push   $0x8049c3
  803393:	e8 6f dd ff ff       	call   801107 <_panic>

00803398 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
  80339b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 38 4a 80 00       	push   $0x804a38
  8033a6:	68 0f 01 00 00       	push   $0x10f
  8033ab:	68 c3 49 80 00       	push   $0x8049c3
  8033b0:	e8 52 dd ff ff       	call   801107 <_panic>

008033b5 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
  8033b8:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  8033bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bf:	0f 84 ee 05 00 00    	je     8039b3 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	83 e8 10             	sub    $0x10,%eax
  8033cb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  8033ce:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8033d2:	a1 40 51 90 00       	mov    0x905140,%eax
  8033d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8033da:	eb 16                	jmp    8033f2 <free_block+0x3d>
	{
		if (block_pointer == it)
  8033dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033e2:	75 06                	jne    8033ea <free_block+0x35>
		{
			flagx = 1;
  8033e4:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  8033e8:	eb 2f                	jmp    803419 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  8033ea:	a1 48 51 90 00       	mov    0x905148,%eax
  8033ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8033f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f6:	74 08                	je     803400 <free_block+0x4b>
  8033f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fb:	8b 40 08             	mov    0x8(%eax),%eax
  8033fe:	eb 05                	jmp    803405 <free_block+0x50>
  803400:	b8 00 00 00 00       	mov    $0x0,%eax
  803405:	a3 48 51 90 00       	mov    %eax,0x905148
  80340a:	a1 48 51 90 00       	mov    0x905148,%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	75 c9                	jne    8033dc <free_block+0x27>
  803413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803417:	75 c3                	jne    8033dc <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  803419:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80341d:	0f 84 93 05 00 00    	je     8039b6 <free_block+0x601>
		return;
	if (va == NULL)
  803423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803427:	0f 84 8c 05 00 00    	je     8039b9 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  80342d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803430:	8b 40 0c             	mov    0xc(%eax),%eax
  803433:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  803436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803439:	8b 40 08             	mov    0x8(%eax),%eax
  80343c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  80343f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803443:	75 12                	jne    803457 <free_block+0xa2>
  803445:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803449:	75 0c                	jne    803457 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  80344b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803452:	e9 63 05 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  803457:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80345b:	0f 85 ca 00 00 00    	jne    80352b <free_block+0x176>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8a 40 04             	mov    0x4(%eax),%al
  803467:	3c 01                	cmp    $0x1,%al
  803469:	0f 85 bc 00 00 00    	jne    80352b <free_block+0x176>
	{
		block_pointer->is_free = 1;
  80346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803472:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803479:	8b 10                	mov    (%eax),%edx
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	01 c2                	add    %eax,%edx
  803482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803485:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803493:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803497:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80349b:	75 17                	jne    8034b4 <free_block+0xff>
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 5e 4a 80 00       	push   $0x804a5e
  8034a5:	68 3c 01 00 00       	push   $0x13c
  8034aa:	68 c3 49 80 00       	push   $0x8049c3
  8034af:	e8 53 dc ff ff       	call   801107 <_panic>
  8034b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b7:	8b 40 08             	mov    0x8(%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 11                	je     8034cf <free_block+0x11a>
  8034be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c1:	8b 40 08             	mov    0x8(%eax),%eax
  8034c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c7:	8b 52 0c             	mov    0xc(%edx),%edx
  8034ca:	89 50 0c             	mov    %edx,0xc(%eax)
  8034cd:	eb 0b                	jmp    8034da <free_block+0x125>
  8034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	a3 44 51 90 00       	mov    %eax,0x905144
  8034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e0:	85 c0                	test   %eax,%eax
  8034e2:	74 11                	je     8034f5 <free_block+0x140>
  8034e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ed:	8b 52 08             	mov    0x8(%edx),%edx
  8034f0:	89 50 08             	mov    %edx,0x8(%eax)
  8034f3:	eb 0b                	jmp    803500 <free_block+0x14b>
  8034f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f8:	8b 40 08             	mov    0x8(%eax),%eax
  8034fb:	a3 40 51 90 00       	mov    %eax,0x905140
  803500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803503:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80350a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803514:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803519:	48                   	dec    %eax
  80351a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80351f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803526:	e9 8f 04 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  80352b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80352f:	75 16                	jne    803547 <free_block+0x192>
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	8a 40 04             	mov    0x4(%eax),%al
  803537:	84 c0                	test   %al,%al
  803539:	75 0c                	jne    803547 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  80353b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  803542:	e9 73 04 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  803547:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80354b:	0f 85 c3 00 00 00    	jne    803614 <free_block+0x25f>
  803551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803554:	8a 40 04             	mov    0x4(%eax),%al
  803557:	3c 01                	cmp    $0x1,%al
  803559:	0f 85 b5 00 00 00    	jne    803614 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	8b 10                	mov    (%eax),%edx
  803564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	01 c2                	add    %eax,%edx
  80356b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356e:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803580:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803584:	75 17                	jne    80359d <free_block+0x1e8>
  803586:	83 ec 04             	sub    $0x4,%esp
  803589:	68 5e 4a 80 00       	push   $0x804a5e
  80358e:	68 49 01 00 00       	push   $0x149
  803593:	68 c3 49 80 00       	push   $0x8049c3
  803598:	e8 6a db ff ff       	call   801107 <_panic>
  80359d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a0:	8b 40 08             	mov    0x8(%eax),%eax
  8035a3:	85 c0                	test   %eax,%eax
  8035a5:	74 11                	je     8035b8 <free_block+0x203>
  8035a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035aa:	8b 40 08             	mov    0x8(%eax),%eax
  8035ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b0:	8b 52 0c             	mov    0xc(%edx),%edx
  8035b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8035b6:	eb 0b                	jmp    8035c3 <free_block+0x20e>
  8035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035be:	a3 44 51 90 00       	mov    %eax,0x905144
  8035c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 11                	je     8035de <free_block+0x229>
  8035cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035d6:	8b 52 08             	mov    0x8(%edx),%edx
  8035d9:	89 50 08             	mov    %edx,0x8(%eax)
  8035dc:	eb 0b                	jmp    8035e9 <free_block+0x234>
  8035de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e1:	8b 40 08             	mov    0x8(%eax),%eax
  8035e4:	a3 40 51 90 00       	mov    %eax,0x905140
  8035e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8035fd:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803602:	48                   	dec    %eax
  803603:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803608:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80360f:	e9 a6 03 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  803614:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803618:	75 16                	jne    803630 <free_block+0x27b>
  80361a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361d:	8a 40 04             	mov    0x4(%eax),%al
  803620:	84 c0                	test   %al,%al
  803622:	75 0c                	jne    803630 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  803624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803627:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80362b:	e9 8a 03 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  803630:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803634:	0f 84 81 01 00 00    	je     8037bb <free_block+0x406>
  80363a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80363e:	0f 84 77 01 00 00    	je     8037bb <free_block+0x406>
  803644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803647:	8a 40 04             	mov    0x4(%eax),%al
  80364a:	3c 01                	cmp    $0x1,%al
  80364c:	0f 85 69 01 00 00    	jne    8037bb <free_block+0x406>
  803652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803655:	8a 40 04             	mov    0x4(%eax),%al
  803658:	3c 01                	cmp    $0x1,%al
  80365a:	0f 85 5b 01 00 00    	jne    8037bb <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  803660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803663:	8b 10                	mov    (%eax),%edx
  803665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803668:	8b 08                	mov    (%eax),%ecx
  80366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366d:	8b 00                	mov    (%eax),%eax
  80366f:	01 c8                	add    %ecx,%eax
  803671:	01 c2                	add    %eax,%edx
  803673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803676:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803684:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  803688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803694:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803698:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80369c:	75 17                	jne    8036b5 <free_block+0x300>
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	68 5e 4a 80 00       	push   $0x804a5e
  8036a6:	68 59 01 00 00       	push   $0x159
  8036ab:	68 c3 49 80 00       	push   $0x8049c3
  8036b0:	e8 52 da ff ff       	call   801107 <_panic>
  8036b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b8:	8b 40 08             	mov    0x8(%eax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 11                	je     8036d0 <free_block+0x31b>
  8036bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c2:	8b 40 08             	mov    0x8(%eax),%eax
  8036c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8036ce:	eb 0b                	jmp    8036db <free_block+0x326>
  8036d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d6:	a3 44 51 90 00       	mov    %eax,0x905144
  8036db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036de:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 11                	je     8036f6 <free_block+0x341>
  8036e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ee:	8b 52 08             	mov    0x8(%edx),%edx
  8036f1:	89 50 08             	mov    %edx,0x8(%eax)
  8036f4:	eb 0b                	jmp    803701 <free_block+0x34c>
  8036f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f9:	8b 40 08             	mov    0x8(%eax),%eax
  8036fc:	a3 40 51 90 00       	mov    %eax,0x905140
  803701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803704:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80370b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803715:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80371a:	48                   	dec    %eax
  80371b:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  803720:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803724:	75 17                	jne    80373d <free_block+0x388>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 5e 4a 80 00       	push   $0x804a5e
  80372e:	68 5a 01 00 00       	push   $0x15a
  803733:	68 c3 49 80 00       	push   $0x8049c3
  803738:	e8 ca d9 ff ff       	call   801107 <_panic>
  80373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803740:	8b 40 08             	mov    0x8(%eax),%eax
  803743:	85 c0                	test   %eax,%eax
  803745:	74 11                	je     803758 <free_block+0x3a3>
  803747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374a:	8b 40 08             	mov    0x8(%eax),%eax
  80374d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803750:	8b 52 0c             	mov    0xc(%edx),%edx
  803753:	89 50 0c             	mov    %edx,0xc(%eax)
  803756:	eb 0b                	jmp    803763 <free_block+0x3ae>
  803758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375b:	8b 40 0c             	mov    0xc(%eax),%eax
  80375e:	a3 44 51 90 00       	mov    %eax,0x905144
  803763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803766:	8b 40 0c             	mov    0xc(%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 11                	je     80377e <free_block+0x3c9>
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	8b 40 0c             	mov    0xc(%eax),%eax
  803773:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803776:	8b 52 08             	mov    0x8(%edx),%edx
  803779:	89 50 08             	mov    %edx,0x8(%eax)
  80377c:	eb 0b                	jmp    803789 <free_block+0x3d4>
  80377e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803781:	8b 40 08             	mov    0x8(%eax),%eax
  803784:	a3 40 51 90 00       	mov    %eax,0x905140
  803789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803796:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80379d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8037a2:	48                   	dec    %eax
  8037a3:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  8037a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  8037af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8037b6:	e9 ff 01 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  8037bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037bf:	0f 84 db 00 00 00    	je     8038a0 <free_block+0x4eb>
  8037c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c9:	0f 84 d1 00 00 00    	je     8038a0 <free_block+0x4eb>
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	8a 40 04             	mov    0x4(%eax),%al
  8037d5:	84 c0                	test   %al,%al
  8037d7:	0f 85 c3 00 00 00    	jne    8038a0 <free_block+0x4eb>
  8037dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e0:	8a 40 04             	mov    0x4(%eax),%al
  8037e3:	3c 01                	cmp    $0x1,%al
  8037e5:	0f 85 b5 00 00 00    	jne    8038a0 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  8037eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ee:	8b 10                	mov    (%eax),%edx
  8037f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	01 c2                	add    %eax,%edx
  8037f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fa:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803808:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80380c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803810:	75 17                	jne    803829 <free_block+0x474>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 5e 4a 80 00       	push   $0x804a5e
  80381a:	68 64 01 00 00       	push   $0x164
  80381f:	68 c3 49 80 00       	push   $0x8049c3
  803824:	e8 de d8 ff ff       	call   801107 <_panic>
  803829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382c:	8b 40 08             	mov    0x8(%eax),%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	74 11                	je     803844 <free_block+0x48f>
  803833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803836:	8b 40 08             	mov    0x8(%eax),%eax
  803839:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383c:	8b 52 0c             	mov    0xc(%edx),%edx
  80383f:	89 50 0c             	mov    %edx,0xc(%eax)
  803842:	eb 0b                	jmp    80384f <free_block+0x49a>
  803844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803847:	8b 40 0c             	mov    0xc(%eax),%eax
  80384a:	a3 44 51 90 00       	mov    %eax,0x905144
  80384f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803852:	8b 40 0c             	mov    0xc(%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 11                	je     80386a <free_block+0x4b5>
  803859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385c:	8b 40 0c             	mov    0xc(%eax),%eax
  80385f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803862:	8b 52 08             	mov    0x8(%edx),%edx
  803865:	89 50 08             	mov    %edx,0x8(%eax)
  803868:	eb 0b                	jmp    803875 <free_block+0x4c0>
  80386a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386d:	8b 40 08             	mov    0x8(%eax),%eax
  803870:	a3 40 51 90 00       	mov    %eax,0x905140
  803875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803878:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80387f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803882:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803889:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80388e:	48                   	dec    %eax
  80388f:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803894:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80389b:	e9 1a 01 00 00       	jmp    8039ba <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  8038a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038a4:	0f 84 df 00 00 00    	je     803989 <free_block+0x5d4>
  8038aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ae:	0f 84 d5 00 00 00    	je     803989 <free_block+0x5d4>
  8038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b7:	8a 40 04             	mov    0x4(%eax),%al
  8038ba:	3c 01                	cmp    $0x1,%al
  8038bc:	0f 85 c7 00 00 00    	jne    803989 <free_block+0x5d4>
  8038c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c5:	8a 40 04             	mov    0x4(%eax),%al
  8038c8:	84 c0                	test   %al,%al
  8038ca:	0f 85 b9 00 00 00    	jne    803989 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  8038d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8038d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038da:	8b 10                	mov    (%eax),%edx
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	01 c2                	add    %eax,%edx
  8038e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e6:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8038f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038fc:	75 17                	jne    803915 <free_block+0x560>
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 5e 4a 80 00       	push   $0x804a5e
  803906:	68 6e 01 00 00       	push   $0x16e
  80390b:	68 c3 49 80 00       	push   $0x8049c3
  803910:	e8 f2 d7 ff ff       	call   801107 <_panic>
  803915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803918:	8b 40 08             	mov    0x8(%eax),%eax
  80391b:	85 c0                	test   %eax,%eax
  80391d:	74 11                	je     803930 <free_block+0x57b>
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	8b 40 08             	mov    0x8(%eax),%eax
  803925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803928:	8b 52 0c             	mov    0xc(%edx),%edx
  80392b:	89 50 0c             	mov    %edx,0xc(%eax)
  80392e:	eb 0b                	jmp    80393b <free_block+0x586>
  803930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803933:	8b 40 0c             	mov    0xc(%eax),%eax
  803936:	a3 44 51 90 00       	mov    %eax,0x905144
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 40 0c             	mov    0xc(%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 11                	je     803956 <free_block+0x5a1>
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	8b 40 0c             	mov    0xc(%eax),%eax
  80394b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394e:	8b 52 08             	mov    0x8(%edx),%edx
  803951:	89 50 08             	mov    %edx,0x8(%eax)
  803954:	eb 0b                	jmp    803961 <free_block+0x5ac>
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	8b 40 08             	mov    0x8(%eax),%eax
  80395c:	a3 40 51 90 00       	mov    %eax,0x905140
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80396b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803975:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80397a:	48                   	dec    %eax
  80397b:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803980:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803987:	eb 31                	jmp    8039ba <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398d:	74 2b                	je     8039ba <free_block+0x605>
  80398f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803993:	74 25                	je     8039ba <free_block+0x605>
  803995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803998:	8a 40 04             	mov    0x4(%eax),%al
  80399b:	84 c0                	test   %al,%al
  80399d:	75 1b                	jne    8039ba <free_block+0x605>
  80399f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a2:	8a 40 04             	mov    0x4(%eax),%al
  8039a5:	84 c0                	test   %al,%al
  8039a7:	75 11                	jne    8039ba <free_block+0x605>
	{
		block_pointer->is_free = 1;
  8039a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ac:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8039b0:	90                   	nop
  8039b1:	eb 07                	jmp    8039ba <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  8039b3:	90                   	nop
  8039b4:	eb 04                	jmp    8039ba <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  8039b6:	90                   	nop
  8039b7:	eb 01                	jmp    8039ba <free_block+0x605>
	if (va == NULL)
		return;
  8039b9:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  8039ba:	c9                   	leave  
  8039bb:	c3                   	ret    

008039bc <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
  8039bf:	57                   	push   %edi
  8039c0:	56                   	push   %esi
  8039c1:	53                   	push   %ebx
  8039c2:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  8039c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039c9:	75 19                	jne    8039e4 <realloc_block_FF+0x28>
  8039cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039cf:	74 13                	je     8039e4 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  8039d1:	83 ec 0c             	sub    $0xc,%esp
  8039d4:	ff 75 0c             	pushl  0xc(%ebp)
  8039d7:	e8 0c f4 ff ff       	call   802de8 <alloc_block_FF>
  8039dc:	83 c4 10             	add    $0x10,%esp
  8039df:	e9 84 03 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  8039e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039e8:	75 3b                	jne    803a25 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  8039ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ee:	75 17                	jne    803a07 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  8039f0:	83 ec 0c             	sub    $0xc,%esp
  8039f3:	6a 00                	push   $0x0
  8039f5:	e8 ee f3 ff ff       	call   802de8 <alloc_block_FF>
  8039fa:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8039fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803a02:	e9 61 03 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  803a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a0b:	74 18                	je     803a25 <realloc_block_FF+0x69>
		{
			free_block(va);
  803a0d:	83 ec 0c             	sub    $0xc,%esp
  803a10:	ff 75 08             	pushl  0x8(%ebp)
  803a13:	e8 9d f9 ff ff       	call   8033b5 <free_block>
  803a18:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a20:	e9 43 03 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803a25:	a1 40 51 90 00       	mov    0x905140,%eax
  803a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803a2d:	e9 02 03 00 00       	jmp    803d34 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	83 e8 10             	sub    $0x10,%eax
  803a38:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a3b:	0f 85 eb 02 00 00    	jne    803d2c <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a44:	8b 00                	mov    (%eax),%eax
  803a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a49:	83 c2 10             	add    $0x10,%edx
  803a4c:	39 d0                	cmp    %edx,%eax
  803a4e:	75 08                	jne    803a58 <realloc_block_FF+0x9c>
			{
				return va;
  803a50:	8b 45 08             	mov    0x8(%ebp),%eax
  803a53:	e9 10 03 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a60:	0f 83 e0 01 00 00    	jae    803c46 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	8b 40 08             	mov    0x8(%eax),%eax
  803a6c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  803a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a72:	8a 40 04             	mov    0x4(%eax),%al
  803a75:	3c 01                	cmp    $0x1,%al
  803a77:	0f 85 06 01 00 00    	jne    803b83 <realloc_block_FF+0x1c7>
  803a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a80:	8b 10                	mov    (%eax),%edx
  803a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a85:	8b 00                	mov    (%eax),%eax
  803a87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a8a:	29 c1                	sub    %eax,%ecx
  803a8c:	89 c8                	mov    %ecx,%eax
  803a8e:	39 c2                	cmp    %eax,%edx
  803a90:	0f 86 ed 00 00 00    	jbe    803b83 <realloc_block_FF+0x1c7>
  803a96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a9a:	0f 84 e3 00 00 00    	je     803b83 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  803aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa3:	8b 10                	mov    (%eax),%edx
  803aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa8:	8b 00                	mov    (%eax),%eax
  803aaa:	2b 45 0c             	sub    0xc(%ebp),%eax
  803aad:	01 d0                	add    %edx,%eax
  803aaf:	83 f8 0f             	cmp    $0xf,%eax
  803ab2:	0f 86 b5 00 00 00    	jbe    803b6d <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803ab8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abe:	01 d0                	add    %edx,%eax
  803ac0:	83 c0 10             	add    $0x10,%eax
  803ac3:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803ac6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  803acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803ad6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ada:	74 06                	je     803ae2 <realloc_block_FF+0x126>
  803adc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ae0:	75 17                	jne    803af9 <realloc_block_FF+0x13d>
  803ae2:	83 ec 04             	sub    $0x4,%esp
  803ae5:	68 dc 49 80 00       	push   $0x8049dc
  803aea:	68 ad 01 00 00       	push   $0x1ad
  803aef:	68 c3 49 80 00       	push   $0x8049c3
  803af4:	e8 0e d6 ff ff       	call   801107 <_panic>
  803af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afc:	8b 50 08             	mov    0x8(%eax),%edx
  803aff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b02:	89 50 08             	mov    %edx,0x8(%eax)
  803b05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b08:	8b 40 08             	mov    0x8(%eax),%eax
  803b0b:	85 c0                	test   %eax,%eax
  803b0d:	74 0c                	je     803b1b <realloc_block_FF+0x15f>
  803b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b12:	8b 40 08             	mov    0x8(%eax),%eax
  803b15:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b18:	89 50 0c             	mov    %edx,0xc(%eax)
  803b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b21:	89 50 08             	mov    %edx,0x8(%eax)
  803b24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b2a:	89 50 0c             	mov    %edx,0xc(%eax)
  803b2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b30:	8b 40 08             	mov    0x8(%eax),%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	75 08                	jne    803b3f <realloc_block_FF+0x183>
  803b37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3a:	a3 44 51 90 00       	mov    %eax,0x905144
  803b3f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803b44:	40                   	inc    %eax
  803b45:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  803b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  803b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b56:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  803b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5d:	8d 50 10             	lea    0x10(%eax),%edx
  803b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b63:	89 10                	mov    %edx,(%eax)
						return va;
  803b65:	8b 45 08             	mov    0x8(%ebp),%eax
  803b68:	e9 fb 01 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  803b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b70:	8d 50 10             	lea    0x10(%eax),%edx
  803b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b76:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  803b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7b:	83 c0 10             	add    $0x10,%eax
  803b7e:	e9 e5 01 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803b83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b86:	8a 40 04             	mov    0x4(%eax),%al
  803b89:	3c 01                	cmp    $0x1,%al
  803b8b:	75 59                	jne    803be6 <realloc_block_FF+0x22a>
  803b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b90:	8b 10                	mov    (%eax),%edx
  803b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b95:	8b 00                	mov    (%eax),%eax
  803b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803b9a:	29 c1                	sub    %eax,%ecx
  803b9c:	89 c8                	mov    %ecx,%eax
  803b9e:	39 c2                	cmp    %eax,%edx
  803ba0:	75 44                	jne    803be6 <realloc_block_FF+0x22a>
  803ba2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ba6:	74 3e                	je     803be6 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bab:	8b 40 08             	mov    0x8(%eax),%eax
  803bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bb7:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803bba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc0:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803bcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bcf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd6:	8d 50 10             	lea    0x10(%eax),%edx
  803bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdc:	89 10                	mov    %edx,(%eax)
					return va;
  803bde:	8b 45 08             	mov    0x8(%ebp),%eax
  803be1:	e9 82 01 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be9:	8a 40 04             	mov    0x4(%eax),%al
  803bec:	84 c0                	test   %al,%al
  803bee:	74 0a                	je     803bfa <realloc_block_FF+0x23e>
  803bf0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bf4:	0f 85 32 01 00 00    	jne    803d2c <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803bfa:	83 ec 0c             	sub    $0xc,%esp
  803bfd:	ff 75 0c             	pushl  0xc(%ebp)
  803c00:	e8 e3 f1 ff ff       	call   802de8 <alloc_block_FF>
  803c05:	83 c4 10             	add    $0x10,%esp
  803c08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  803c0b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0f:	74 2b                	je     803c3c <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803c11:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c14:	8b 45 08             	mov    0x8(%ebp),%eax
  803c17:	89 c3                	mov    %eax,%ebx
  803c19:	b8 04 00 00 00       	mov    $0x4,%eax
  803c1e:	89 d7                	mov    %edx,%edi
  803c20:	89 de                	mov    %ebx,%esi
  803c22:	89 c1                	mov    %eax,%ecx
  803c24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  803c26:	83 ec 0c             	sub    $0xc,%esp
  803c29:	ff 75 08             	pushl  0x8(%ebp)
  803c2c:	e8 84 f7 ff ff       	call   8033b5 <free_block>
  803c31:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803c34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c37:	e9 2c 01 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  803c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803c41:	e9 22 01 00 00       	jmp    803d68 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c4e:	0f 86 d8 00 00 00    	jbe    803d2c <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c5c:	83 f8 0f             	cmp    $0xf,%eax
  803c5f:	0f 86 b4 00 00 00    	jbe    803d19 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803c65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6b:	01 d0                	add    %edx,%eax
  803c6d:	83 c0 10             	add    $0x10,%eax
  803c70:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c7b:	8d 50 f0             	lea    -0x10(%eax),%edx
  803c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c81:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803c83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c87:	74 06                	je     803c8f <realloc_block_FF+0x2d3>
  803c89:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c8d:	75 17                	jne    803ca6 <realloc_block_FF+0x2ea>
  803c8f:	83 ec 04             	sub    $0x4,%esp
  803c92:	68 dc 49 80 00       	push   $0x8049dc
  803c97:	68 dd 01 00 00       	push   $0x1dd
  803c9c:	68 c3 49 80 00       	push   $0x8049c3
  803ca1:	e8 61 d4 ff ff       	call   801107 <_panic>
  803ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca9:	8b 50 08             	mov    0x8(%eax),%edx
  803cac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803caf:	89 50 08             	mov    %edx,0x8(%eax)
  803cb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cb5:	8b 40 08             	mov    0x8(%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	74 0c                	je     803cc8 <realloc_block_FF+0x30c>
  803cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbf:	8b 40 08             	mov    0x8(%eax),%eax
  803cc2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cc5:	89 50 0c             	mov    %edx,0xc(%eax)
  803cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cce:	89 50 08             	mov    %edx,0x8(%eax)
  803cd1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd7:	89 50 0c             	mov    %edx,0xc(%eax)
  803cda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cdd:	8b 40 08             	mov    0x8(%eax),%eax
  803ce0:	85 c0                	test   %eax,%eax
  803ce2:	75 08                	jne    803cec <realloc_block_FF+0x330>
  803ce4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ce7:	a3 44 51 90 00       	mov    %eax,0x905144
  803cec:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803cf1:	40                   	inc    %eax
  803cf2:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cfa:	83 c0 10             	add    $0x10,%eax
  803cfd:	83 ec 0c             	sub    $0xc,%esp
  803d00:	50                   	push   %eax
  803d01:	e8 af f6 ff ff       	call   8033b5 <free_block>
  803d06:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0c:	8d 50 10             	lea    0x10(%eax),%edx
  803d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d12:	89 10                	mov    %edx,(%eax)
					return va;
  803d14:	8b 45 08             	mov    0x8(%ebp),%eax
  803d17:	eb 4f                	jmp    803d68 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1c:	8d 50 10             	lea    0x10(%eax),%edx
  803d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d22:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d27:	83 c0 10             	add    $0x10,%eax
  803d2a:	eb 3c                	jmp    803d68 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803d2c:	a1 48 51 90 00       	mov    0x905148,%eax
  803d31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d38:	74 08                	je     803d42 <realloc_block_FF+0x386>
  803d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3d:	8b 40 08             	mov    0x8(%eax),%eax
  803d40:	eb 05                	jmp    803d47 <realloc_block_FF+0x38b>
  803d42:	b8 00 00 00 00       	mov    $0x0,%eax
  803d47:	a3 48 51 90 00       	mov    %eax,0x905148
  803d4c:	a1 48 51 90 00       	mov    0x905148,%eax
  803d51:	85 c0                	test   %eax,%eax
  803d53:	0f 85 d9 fc ff ff    	jne    803a32 <realloc_block_FF+0x76>
  803d59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d5d:	0f 85 cf fc ff ff    	jne    803a32 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803d6b:	5b                   	pop    %ebx
  803d6c:	5e                   	pop    %esi
  803d6d:	5f                   	pop    %edi
  803d6e:	5d                   	pop    %ebp
  803d6f:	c3                   	ret    

00803d70 <__udivdi3>:
  803d70:	55                   	push   %ebp
  803d71:	57                   	push   %edi
  803d72:	56                   	push   %esi
  803d73:	53                   	push   %ebx
  803d74:	83 ec 1c             	sub    $0x1c,%esp
  803d77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d87:	89 ca                	mov    %ecx,%edx
  803d89:	89 f8                	mov    %edi,%eax
  803d8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d8f:	85 f6                	test   %esi,%esi
  803d91:	75 2d                	jne    803dc0 <__udivdi3+0x50>
  803d93:	39 cf                	cmp    %ecx,%edi
  803d95:	77 65                	ja     803dfc <__udivdi3+0x8c>
  803d97:	89 fd                	mov    %edi,%ebp
  803d99:	85 ff                	test   %edi,%edi
  803d9b:	75 0b                	jne    803da8 <__udivdi3+0x38>
  803d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803da2:	31 d2                	xor    %edx,%edx
  803da4:	f7 f7                	div    %edi
  803da6:	89 c5                	mov    %eax,%ebp
  803da8:	31 d2                	xor    %edx,%edx
  803daa:	89 c8                	mov    %ecx,%eax
  803dac:	f7 f5                	div    %ebp
  803dae:	89 c1                	mov    %eax,%ecx
  803db0:	89 d8                	mov    %ebx,%eax
  803db2:	f7 f5                	div    %ebp
  803db4:	89 cf                	mov    %ecx,%edi
  803db6:	89 fa                	mov    %edi,%edx
  803db8:	83 c4 1c             	add    $0x1c,%esp
  803dbb:	5b                   	pop    %ebx
  803dbc:	5e                   	pop    %esi
  803dbd:	5f                   	pop    %edi
  803dbe:	5d                   	pop    %ebp
  803dbf:	c3                   	ret    
  803dc0:	39 ce                	cmp    %ecx,%esi
  803dc2:	77 28                	ja     803dec <__udivdi3+0x7c>
  803dc4:	0f bd fe             	bsr    %esi,%edi
  803dc7:	83 f7 1f             	xor    $0x1f,%edi
  803dca:	75 40                	jne    803e0c <__udivdi3+0x9c>
  803dcc:	39 ce                	cmp    %ecx,%esi
  803dce:	72 0a                	jb     803dda <__udivdi3+0x6a>
  803dd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dd4:	0f 87 9e 00 00 00    	ja     803e78 <__udivdi3+0x108>
  803dda:	b8 01 00 00 00       	mov    $0x1,%eax
  803ddf:	89 fa                	mov    %edi,%edx
  803de1:	83 c4 1c             	add    $0x1c,%esp
  803de4:	5b                   	pop    %ebx
  803de5:	5e                   	pop    %esi
  803de6:	5f                   	pop    %edi
  803de7:	5d                   	pop    %ebp
  803de8:	c3                   	ret    
  803de9:	8d 76 00             	lea    0x0(%esi),%esi
  803dec:	31 ff                	xor    %edi,%edi
  803dee:	31 c0                	xor    %eax,%eax
  803df0:	89 fa                	mov    %edi,%edx
  803df2:	83 c4 1c             	add    $0x1c,%esp
  803df5:	5b                   	pop    %ebx
  803df6:	5e                   	pop    %esi
  803df7:	5f                   	pop    %edi
  803df8:	5d                   	pop    %ebp
  803df9:	c3                   	ret    
  803dfa:	66 90                	xchg   %ax,%ax
  803dfc:	89 d8                	mov    %ebx,%eax
  803dfe:	f7 f7                	div    %edi
  803e00:	31 ff                	xor    %edi,%edi
  803e02:	89 fa                	mov    %edi,%edx
  803e04:	83 c4 1c             	add    $0x1c,%esp
  803e07:	5b                   	pop    %ebx
  803e08:	5e                   	pop    %esi
  803e09:	5f                   	pop    %edi
  803e0a:	5d                   	pop    %ebp
  803e0b:	c3                   	ret    
  803e0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e11:	89 eb                	mov    %ebp,%ebx
  803e13:	29 fb                	sub    %edi,%ebx
  803e15:	89 f9                	mov    %edi,%ecx
  803e17:	d3 e6                	shl    %cl,%esi
  803e19:	89 c5                	mov    %eax,%ebp
  803e1b:	88 d9                	mov    %bl,%cl
  803e1d:	d3 ed                	shr    %cl,%ebp
  803e1f:	89 e9                	mov    %ebp,%ecx
  803e21:	09 f1                	or     %esi,%ecx
  803e23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e27:	89 f9                	mov    %edi,%ecx
  803e29:	d3 e0                	shl    %cl,%eax
  803e2b:	89 c5                	mov    %eax,%ebp
  803e2d:	89 d6                	mov    %edx,%esi
  803e2f:	88 d9                	mov    %bl,%cl
  803e31:	d3 ee                	shr    %cl,%esi
  803e33:	89 f9                	mov    %edi,%ecx
  803e35:	d3 e2                	shl    %cl,%edx
  803e37:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e3b:	88 d9                	mov    %bl,%cl
  803e3d:	d3 e8                	shr    %cl,%eax
  803e3f:	09 c2                	or     %eax,%edx
  803e41:	89 d0                	mov    %edx,%eax
  803e43:	89 f2                	mov    %esi,%edx
  803e45:	f7 74 24 0c          	divl   0xc(%esp)
  803e49:	89 d6                	mov    %edx,%esi
  803e4b:	89 c3                	mov    %eax,%ebx
  803e4d:	f7 e5                	mul    %ebp
  803e4f:	39 d6                	cmp    %edx,%esi
  803e51:	72 19                	jb     803e6c <__udivdi3+0xfc>
  803e53:	74 0b                	je     803e60 <__udivdi3+0xf0>
  803e55:	89 d8                	mov    %ebx,%eax
  803e57:	31 ff                	xor    %edi,%edi
  803e59:	e9 58 ff ff ff       	jmp    803db6 <__udivdi3+0x46>
  803e5e:	66 90                	xchg   %ax,%ax
  803e60:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e64:	89 f9                	mov    %edi,%ecx
  803e66:	d3 e2                	shl    %cl,%edx
  803e68:	39 c2                	cmp    %eax,%edx
  803e6a:	73 e9                	jae    803e55 <__udivdi3+0xe5>
  803e6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e6f:	31 ff                	xor    %edi,%edi
  803e71:	e9 40 ff ff ff       	jmp    803db6 <__udivdi3+0x46>
  803e76:	66 90                	xchg   %ax,%ax
  803e78:	31 c0                	xor    %eax,%eax
  803e7a:	e9 37 ff ff ff       	jmp    803db6 <__udivdi3+0x46>
  803e7f:	90                   	nop

00803e80 <__umoddi3>:
  803e80:	55                   	push   %ebp
  803e81:	57                   	push   %edi
  803e82:	56                   	push   %esi
  803e83:	53                   	push   %ebx
  803e84:	83 ec 1c             	sub    $0x1c,%esp
  803e87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e9f:	89 f3                	mov    %esi,%ebx
  803ea1:	89 fa                	mov    %edi,%edx
  803ea3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ea7:	89 34 24             	mov    %esi,(%esp)
  803eaa:	85 c0                	test   %eax,%eax
  803eac:	75 1a                	jne    803ec8 <__umoddi3+0x48>
  803eae:	39 f7                	cmp    %esi,%edi
  803eb0:	0f 86 a2 00 00 00    	jbe    803f58 <__umoddi3+0xd8>
  803eb6:	89 c8                	mov    %ecx,%eax
  803eb8:	89 f2                	mov    %esi,%edx
  803eba:	f7 f7                	div    %edi
  803ebc:	89 d0                	mov    %edx,%eax
  803ebe:	31 d2                	xor    %edx,%edx
  803ec0:	83 c4 1c             	add    $0x1c,%esp
  803ec3:	5b                   	pop    %ebx
  803ec4:	5e                   	pop    %esi
  803ec5:	5f                   	pop    %edi
  803ec6:	5d                   	pop    %ebp
  803ec7:	c3                   	ret    
  803ec8:	39 f0                	cmp    %esi,%eax
  803eca:	0f 87 ac 00 00 00    	ja     803f7c <__umoddi3+0xfc>
  803ed0:	0f bd e8             	bsr    %eax,%ebp
  803ed3:	83 f5 1f             	xor    $0x1f,%ebp
  803ed6:	0f 84 ac 00 00 00    	je     803f88 <__umoddi3+0x108>
  803edc:	bf 20 00 00 00       	mov    $0x20,%edi
  803ee1:	29 ef                	sub    %ebp,%edi
  803ee3:	89 fe                	mov    %edi,%esi
  803ee5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ee9:	89 e9                	mov    %ebp,%ecx
  803eeb:	d3 e0                	shl    %cl,%eax
  803eed:	89 d7                	mov    %edx,%edi
  803eef:	89 f1                	mov    %esi,%ecx
  803ef1:	d3 ef                	shr    %cl,%edi
  803ef3:	09 c7                	or     %eax,%edi
  803ef5:	89 e9                	mov    %ebp,%ecx
  803ef7:	d3 e2                	shl    %cl,%edx
  803ef9:	89 14 24             	mov    %edx,(%esp)
  803efc:	89 d8                	mov    %ebx,%eax
  803efe:	d3 e0                	shl    %cl,%eax
  803f00:	89 c2                	mov    %eax,%edx
  803f02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f06:	d3 e0                	shl    %cl,%eax
  803f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f10:	89 f1                	mov    %esi,%ecx
  803f12:	d3 e8                	shr    %cl,%eax
  803f14:	09 d0                	or     %edx,%eax
  803f16:	d3 eb                	shr    %cl,%ebx
  803f18:	89 da                	mov    %ebx,%edx
  803f1a:	f7 f7                	div    %edi
  803f1c:	89 d3                	mov    %edx,%ebx
  803f1e:	f7 24 24             	mull   (%esp)
  803f21:	89 c6                	mov    %eax,%esi
  803f23:	89 d1                	mov    %edx,%ecx
  803f25:	39 d3                	cmp    %edx,%ebx
  803f27:	0f 82 87 00 00 00    	jb     803fb4 <__umoddi3+0x134>
  803f2d:	0f 84 91 00 00 00    	je     803fc4 <__umoddi3+0x144>
  803f33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f37:	29 f2                	sub    %esi,%edx
  803f39:	19 cb                	sbb    %ecx,%ebx
  803f3b:	89 d8                	mov    %ebx,%eax
  803f3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f41:	d3 e0                	shl    %cl,%eax
  803f43:	89 e9                	mov    %ebp,%ecx
  803f45:	d3 ea                	shr    %cl,%edx
  803f47:	09 d0                	or     %edx,%eax
  803f49:	89 e9                	mov    %ebp,%ecx
  803f4b:	d3 eb                	shr    %cl,%ebx
  803f4d:	89 da                	mov    %ebx,%edx
  803f4f:	83 c4 1c             	add    $0x1c,%esp
  803f52:	5b                   	pop    %ebx
  803f53:	5e                   	pop    %esi
  803f54:	5f                   	pop    %edi
  803f55:	5d                   	pop    %ebp
  803f56:	c3                   	ret    
  803f57:	90                   	nop
  803f58:	89 fd                	mov    %edi,%ebp
  803f5a:	85 ff                	test   %edi,%edi
  803f5c:	75 0b                	jne    803f69 <__umoddi3+0xe9>
  803f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f63:	31 d2                	xor    %edx,%edx
  803f65:	f7 f7                	div    %edi
  803f67:	89 c5                	mov    %eax,%ebp
  803f69:	89 f0                	mov    %esi,%eax
  803f6b:	31 d2                	xor    %edx,%edx
  803f6d:	f7 f5                	div    %ebp
  803f6f:	89 c8                	mov    %ecx,%eax
  803f71:	f7 f5                	div    %ebp
  803f73:	89 d0                	mov    %edx,%eax
  803f75:	e9 44 ff ff ff       	jmp    803ebe <__umoddi3+0x3e>
  803f7a:	66 90                	xchg   %ax,%ax
  803f7c:	89 c8                	mov    %ecx,%eax
  803f7e:	89 f2                	mov    %esi,%edx
  803f80:	83 c4 1c             	add    $0x1c,%esp
  803f83:	5b                   	pop    %ebx
  803f84:	5e                   	pop    %esi
  803f85:	5f                   	pop    %edi
  803f86:	5d                   	pop    %ebp
  803f87:	c3                   	ret    
  803f88:	3b 04 24             	cmp    (%esp),%eax
  803f8b:	72 06                	jb     803f93 <__umoddi3+0x113>
  803f8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f91:	77 0f                	ja     803fa2 <__umoddi3+0x122>
  803f93:	89 f2                	mov    %esi,%edx
  803f95:	29 f9                	sub    %edi,%ecx
  803f97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f9b:	89 14 24             	mov    %edx,(%esp)
  803f9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fa6:	8b 14 24             	mov    (%esp),%edx
  803fa9:	83 c4 1c             	add    $0x1c,%esp
  803fac:	5b                   	pop    %ebx
  803fad:	5e                   	pop    %esi
  803fae:	5f                   	pop    %edi
  803faf:	5d                   	pop    %ebp
  803fb0:	c3                   	ret    
  803fb1:	8d 76 00             	lea    0x0(%esi),%esi
  803fb4:	2b 04 24             	sub    (%esp),%eax
  803fb7:	19 fa                	sbb    %edi,%edx
  803fb9:	89 d1                	mov    %edx,%ecx
  803fbb:	89 c6                	mov    %eax,%esi
  803fbd:	e9 71 ff ff ff       	jmp    803f33 <__umoddi3+0xb3>
  803fc2:	66 90                	xchg   %ax,%ax
  803fc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fc8:	72 ea                	jb     803fb4 <__umoddi3+0x134>
  803fca:	89 d9                	mov    %ebx,%ecx
  803fcc:	e9 62 ff ff ff       	jmp    803f33 <__umoddi3+0xb3>
