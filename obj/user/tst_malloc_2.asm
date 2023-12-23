
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 1e 04 00 00       	call   800454 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 74             	sub    $0x74,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 40 40 80 00       	mov    0x804040,%eax
  800044:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80004a:	a1 40 40 80 00       	mov    0x804040,%eax
  80004f:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 c0 34 80 00       	push   $0x8034c0
  800061:	6a 21                	push   $0x21
  800063:	68 dc 34 80 00       	push   $0x8034dc
  800068:	e8 15 05 00 00       	call   800582 <_panic>
	}
	/*=================================================*/


	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80007b:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  800082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800089:	e8 44 1a 00 00       	call   801ad2 <sys_pf_calculate_allocated_pages>
  80008e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 f1 19 00 00       	call   801a87 <sys_calculate_free_frames>
  800096:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("	1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 f0 34 80 00       	push   $0x8034f0
  8000a1:	e8 99 07 00 00       	call   80083f <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000b0:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000be:	e9 3d 01 00 00       	jmp    800200 <_main+0x1c8>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000ca:	e9 21 01 00 00       	jmp    8001f0 <_main+0x1b8>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d2:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  8000d9:	83 e8 10             	sub    $0x10,%eax
  8000dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 bc             	pushl  -0x44(%ebp)
  8000e5:	e8 7e 15 00 00       	call   801668 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 c2                	mov    %eax,%edx
  8000ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f2:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
  8000f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fc:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  800103:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800106:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800109:	d1 e8                	shr    %eax
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800110:	01 c2                	add    %eax,%edx
  800112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800115:	89 14 85 20 6d 80 00 	mov    %edx,0x806d20(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  80011c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80011f:	8d 50 fe             	lea    -0x2(%eax),%edx
  800122:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800125:	01 c2                	add    %eax,%edx
  800127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80012a:	89 14 85 20 57 80 00 	mov    %edx,0x805720(,%eax,4)

				//Check returned va
				if(va == NULL || (va < curVA))
  800131:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800135:	74 08                	je     80013f <_main+0x107>
  800137:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80013a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013d:	73 27                	jae    800166 <_main+0x12e>
				{
					if (is_correct)
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 21                	je     800166 <_main+0x12e>
					{
						is_correct = 0;
  800145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
						cprintf("alloc_block_xx #1.%d: WRONG ALLOC - alloc_block_xx return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  80014c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014f:	83 c0 10             	add    $0x10,%eax
  800152:	ff 75 b8             	pushl  -0x48(%ebp)
  800155:	50                   	push   %eax
  800156:	ff 75 ec             	pushl  -0x14(%ebp)
  800159:	68 3c 35 80 00       	push   $0x80353c
  80015e:	e8 dc 06 00 00       	call   80083f <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
					}
				}
				curVA += allocSizes[i] ;
  800166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800169:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  800170:	01 45 e8             	add    %eax,-0x18(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800173:	c7 45 b4 00 10 00 00 	movl   $0x1000,-0x4c(%ebp)
  80017a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80017d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800180:	01 d0                	add    %edx,%eax
  800182:	48                   	dec    %eax
  800183:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800186:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800189:	ba 00 00 00 00       	mov    $0x0,%edx
  80018e:	f7 75 b4             	divl   -0x4c(%ebp)
  800191:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800194:	29 d0                	sub    %edx,%eax
  800196:	89 45 ac             	mov    %eax,-0x54(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800199:	8b 55 ac             	mov    -0x54(%ebp),%edx
  80019c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80019f:	29 c2                	sub    %eax,%edx
  8001a1:	89 d0                	mov    %edx,%eax
  8001a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  8001a6:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  8001aa:	7e 0e                	jle    8001ba <_main+0x182>
  8001ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001af:	83 f8 0f             	cmp    $0xf,%eax
  8001b2:	77 06                	ja     8001ba <_main+0x182>
				{
					curVA = rounded_curVA;
  8001b4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
				//============================================================
				*(startVAs[idx]) = idx ;
  8001ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bd:	8b 14 85 20 41 80 00 	mov    0x804120(,%eax,4),%edx
  8001c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c7:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8001ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001cd:	8b 14 85 20 6d 80 00 	mov    0x806d20(,%eax,4),%edx
  8001d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d7:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8001da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001dd:	8b 14 85 20 57 80 00 	mov    0x805720(,%eax,4),%edx
  8001e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e7:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8001ea:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001ed:	ff 45 e0             	incl   -0x20(%ebp)
  8001f0:	81 7d e0 c7 00 00 00 	cmpl   $0xc7,-0x20(%ebp)
  8001f7:	0f 8e d2 fe ff ff    	jle    8000cf <_main+0x97>
	cprintf("	1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001fd:	ff 45 e4             	incl   -0x1c(%ebp)
  800200:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800204:	0f 8e b9 fe ff ff    	jle    8000c3 <_main+0x8b>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  80020a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80020e:	74 04                	je     800214 <_main+0x1dc>
		{
			eval += 30;
  800210:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("	2: Check stored data inside each allocated block\n\n") ;
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 a0 35 80 00       	push   $0x8035a0
  80021c:	e8 1e 06 00 00       	call   80083f <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800224:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  80022b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800232:	eb 5b                	jmp    80028f <_main+0x257>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  800234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800237:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  80023e:	66 8b 00             	mov    (%eax),%ax
  800241:	98                   	cwtl   
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	75 26                	jne    80026d <_main+0x235>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8b 04 85 20 6d 80 00 	mov    0x806d20(,%eax,4),%eax
  800251:	66 8b 00             	mov    (%eax),%ax
  800254:	98                   	cwtl   
  800255:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800258:	75 13                	jne    80026d <_main+0x235>
  80025a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025d:	8b 04 85 20 57 80 00 	mov    0x805720(,%eax,4),%eax
  800264:	66 8b 00             	mov    (%eax),%ax
  800267:	98                   	cwtl   
  800268:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026b:	74 1f                	je     80028c <_main+0x254>
			{
				is_correct = 0;
  80026d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 dc             	pushl  -0x24(%ebp)
  80027d:	68 d4 35 80 00       	push   $0x8035d4
  800282:	e8 b8 05 00 00       	call   80083f <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
				break;
  80028a:	eb 0b                	jmp    800297 <_main+0x25f>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("	2: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  80028c:	ff 45 dc             	incl   -0x24(%ebp)
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800295:	7c 9d                	jl     800234 <_main+0x1fc>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  800297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80029b:	74 04                	je     8002a1 <_main+0x269>
		{
			eval += 40;
  80029d:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
		}
	}

	/*Check page file*/
	{
		is_correct = 1;
  8002a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8002a8:	e8 25 18 00 00       	call   801ad2 <sys_pf_calculate_allocated_pages>
  8002ad:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002b0:	74 17                	je     8002c9 <_main+0x291>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	68 24 36 80 00       	push   $0x803624
  8002ba:	e8 80 05 00 00       	call   80083f <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8002c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8002c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002cd:	74 04                	je     8002d3 <_main+0x29b>
		{
			eval += 5;
  8002cf:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8002d3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (int i = 0; i < numOfAllocs; ++i)
  8002da:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8002e1:	eb 23                	jmp    800306 <_main+0x2ce>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
  8002e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002e6:	8b 14 85 00 40 80 00 	mov    0x804000(,%eax,4),%edx
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	c1 e0 02             	shl    $0x2,%eax
  8002f2:	01 d0                	add    %edx,%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	01 d0                	add    %edx,%eax
  8002fd:	c1 e0 03             	shl    $0x3,%eax
  800300:	01 45 d8             	add    %eax,-0x28(%ebp)
			eval += 5;
		}
	}

	uint32 expectedAllocatedSize = 0;
	for (int i = 0; i < numOfAllocs; ++i)
  800303:	ff 45 d4             	incl   -0x2c(%ebp)
  800306:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  80030a:	7e d7                	jle    8002e3 <_main+0x2ab>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  80030c:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  800313:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800316:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800319:	01 d0                	add    %edx,%eax
  80031b:	48                   	dec    %eax
  80031c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80031f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	f7 75 a4             	divl   -0x5c(%ebp)
  80032a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032d:	29 d0                	sub    %edx,%eax
  80032f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800332:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800335:	c1 e8 0c             	shr    $0xc,%eax
  800338:	89 45 9c             	mov    %eax,-0x64(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  80033b:	c7 45 98 00 00 40 00 	movl   $0x400000,-0x68(%ebp)
  800342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800345:	8b 45 98             	mov    -0x68(%ebp),%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	48                   	dec    %eax
  80034b:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80034e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800351:	ba 00 00 00 00       	mov    $0x0,%edx
  800356:	f7 75 98             	divl   -0x68(%ebp)
  800359:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80035c:	29 d0                	sub    %edx,%eax
  80035e:	c1 e8 16             	shr    $0x16,%eax
  800361:	89 45 90             	mov    %eax,-0x70(%ebp)

	/*Check memory allocation*/
	{
		is_correct = 1;
  800364:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) < (expectedAllocNumOfPages + expectedAllocNumOfTables))
  80036b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80036e:	e8 14 17 00 00       	call   801a87 <sys_calculate_free_frames>
  800373:	89 d9                	mov    %ebx,%ecx
  800375:	29 c1                	sub    %eax,%ecx
  800377:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80037a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	39 c1                	cmp    %eax,%ecx
  800381:	73 17                	jae    80039a <_main+0x362>
		{
			cprintf("number of allocated pages in MEMORY are less than the its expected lower bound\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 60 36 80 00       	push   $0x803660
  80038b:	e8 af 04 00 00       	call   80083f <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  80039a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80039e:	74 04                	je     8003a4 <_main+0x36c>
		{
			eval += 10;
  8003a0:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  8003ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003ae:	c1 e0 02             	shl    $0x2,%eax
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	50                   	push   %eax
  8003b5:	e8 ae 12 00 00       	call   801668 <malloc>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int i = 0;
  8003c0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  8003c7:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  8003ce:	eb 21                	jmp    8003f1 <_main+0x3b9>
		{
			expectedVAs[i++] = va;
  8003d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d3:	8d 50 01             	lea    0x1(%eax),%edx
  8003d6:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8003d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003e3:	01 c2                	add    %eax,%edx
  8003e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e8:	89 02                	mov    %eax,(%edx)
	/*Check WS elements*/
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  8003ea:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  8003f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003fc:	77 d2                	ja     8003d0 <_main+0x398>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  8003fe:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800401:	6a 02                	push   $0x2
  800403:	6a 00                	push   $0x0
  800405:	50                   	push   %eax
  800406:	ff 75 8c             	pushl  -0x74(%ebp)
  800409:	e8 96 1b 00 00       	call   801fa4 <sys_check_WS_list>
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	89 45 88             	mov    %eax,-0x78(%ebp)
		if (chk != 1)
  800414:	83 7d 88 01          	cmpl   $0x1,-0x78(%ebp)
  800418:	74 17                	je     800431 <_main+0x3f9>
		{
			cprintf("malloc: page is not added to WS\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 b0 36 80 00       	push   $0x8036b0
  800422:	e8 18 04 00 00       	call   80083f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  80042a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800435:	74 04                	je     80043b <_main+0x403>
		{
			eval += 15;
  800437:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		}
	}

	cprintf("test malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 f4             	pushl  -0xc(%ebp)
  800441:	68 d4 36 80 00       	push   $0x8036d4
  800446:	e8 f4 03 00 00       	call   80083f <cprintf>
  80044b:	83 c4 10             	add    $0x10,%esp

	return;
  80044e:	90                   	nop
}
  80044f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80045a:	e8 b3 18 00 00       	call   801d12 <sys_getenvindex>
  80045f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	89 d0                	mov    %edx,%eax
  800467:	01 c0                	add    %eax,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	c1 e0 06             	shl    $0x6,%eax
  80046e:	29 d0                	sub    %edx,%eax
  800470:	c1 e0 03             	shl    $0x3,%eax
  800473:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800478:	a3 40 40 80 00       	mov    %eax,0x804040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80047d:	a1 40 40 80 00       	mov    0x804040,%eax
  800482:	8a 40 68             	mov    0x68(%eax),%al
  800485:	84 c0                	test   %al,%al
  800487:	74 0d                	je     800496 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800489:	a1 40 40 80 00       	mov    0x804040,%eax
  80048e:	83 c0 68             	add    $0x68,%eax
  800491:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80049a:	7e 0a                	jle    8004a6 <libmain+0x52>
		binaryname = argv[0];
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	_main(argc, argv);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ac:	ff 75 08             	pushl  0x8(%ebp)
  8004af:	e8 84 fb ff ff       	call   800038 <_main>
  8004b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004b7:	e8 63 16 00 00       	call   801b1f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004bc:	83 ec 0c             	sub    $0xc,%esp
  8004bf:	68 30 37 80 00       	push   $0x803730
  8004c4:	e8 76 03 00 00       	call   80083f <cprintf>
  8004c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004cc:	a1 40 40 80 00       	mov    0x804040,%eax
  8004d1:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8004d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8004dc:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8004e2:	83 ec 04             	sub    $0x4,%esp
  8004e5:	52                   	push   %edx
  8004e6:	50                   	push   %eax
  8004e7:	68 58 37 80 00       	push   $0x803758
  8004ec:	e8 4e 03 00 00       	call   80083f <cprintf>
  8004f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004f4:	a1 40 40 80 00       	mov    0x804040,%eax
  8004f9:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8004ff:	a1 40 40 80 00       	mov    0x804040,%eax
  800504:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80050a:	a1 40 40 80 00       	mov    0x804040,%eax
  80050f:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800515:	51                   	push   %ecx
  800516:	52                   	push   %edx
  800517:	50                   	push   %eax
  800518:	68 80 37 80 00       	push   $0x803780
  80051d:	e8 1d 03 00 00       	call   80083f <cprintf>
  800522:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800525:	a1 40 40 80 00       	mov    0x804040,%eax
  80052a:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	50                   	push   %eax
  800534:	68 d8 37 80 00       	push   $0x8037d8
  800539:	e8 01 03 00 00       	call   80083f <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 30 37 80 00       	push   $0x803730
  800549:	e8 f1 02 00 00       	call   80083f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800551:	e8 e3 15 00 00       	call   801b39 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800556:	e8 19 00 00 00       	call   800574 <exit>
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	6a 00                	push   $0x0
  800569:	e8 70 17 00 00       	call   801cde <sys_destroy_env>
  80056e:	83 c4 10             	add    $0x10,%esp
}
  800571:	90                   	nop
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <exit>:

void
exit(void)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80057a:	e8 c5 17 00 00       	call   801d44 <sys_exit_env>
}
  80057f:	90                   	nop
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800588:	8d 45 10             	lea    0x10(%ebp),%eax
  80058b:	83 c0 04             	add    $0x4,%eax
  80058e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800591:	a1 1c 83 80 00       	mov    0x80831c,%eax
  800596:	85 c0                	test   %eax,%eax
  800598:	74 16                	je     8005b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80059a:	a1 1c 83 80 00       	mov    0x80831c,%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	50                   	push   %eax
  8005a3:	68 ec 37 80 00       	push   $0x8037ec
  8005a8:	e8 92 02 00 00       	call   80083f <cprintf>
  8005ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b0:	a1 1c 40 80 00       	mov    0x80401c,%eax
  8005b5:	ff 75 0c             	pushl  0xc(%ebp)
  8005b8:	ff 75 08             	pushl  0x8(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	68 f1 37 80 00       	push   $0x8037f1
  8005c1:	e8 79 02 00 00       	call   80083f <cprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	50                   	push   %eax
  8005d3:	e8 fc 01 00 00       	call   8007d4 <vcprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	6a 00                	push   $0x0
  8005e0:	68 0d 38 80 00       	push   $0x80380d
  8005e5:	e8 ea 01 00 00       	call   8007d4 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005ed:	e8 82 ff ff ff       	call   800574 <exit>

	// should not return here
	while (1) ;
  8005f2:	eb fe                	jmp    8005f2 <_panic+0x70>

008005f4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005fa:	a1 40 40 80 00       	mov    0x804040,%eax
  8005ff:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	39 c2                	cmp    %eax,%edx
  80060a:	74 14                	je     800620 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	68 10 38 80 00       	push   $0x803810
  800614:	6a 26                	push   $0x26
  800616:	68 5c 38 80 00       	push   $0x80385c
  80061b:	e8 62 ff ff ff       	call   800582 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800620:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800627:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062e:	e9 c5 00 00 00       	jmp    8006f8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	85 c0                	test   %eax,%eax
  800646:	75 08                	jne    800650 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800648:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80064b:	e9 a5 00 00 00       	jmp    8006f5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800650:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800657:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80065e:	eb 69                	jmp    8006c9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800660:	a1 40 40 80 00       	mov    0x804040,%eax
  800665:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80066b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066e:	89 d0                	mov    %edx,%eax
  800670:	01 c0                	add    %eax,%eax
  800672:	01 d0                	add    %edx,%eax
  800674:	c1 e0 03             	shl    $0x3,%eax
  800677:	01 c8                	add    %ecx,%eax
  800679:	8a 40 04             	mov    0x4(%eax),%al
  80067c:	84 c0                	test   %al,%al
  80067e:	75 46                	jne    8006c6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800680:	a1 40 40 80 00       	mov    0x804040,%eax
  800685:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80068b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80068e:	89 d0                	mov    %edx,%eax
  800690:	01 c0                	add    %eax,%eax
  800692:	01 d0                	add    %edx,%eax
  800694:	c1 e0 03             	shl    $0x3,%eax
  800697:	01 c8                	add    %ecx,%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	01 c8                	add    %ecx,%eax
  8006b7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006b9:	39 c2                	cmp    %eax,%edx
  8006bb:	75 09                	jne    8006c6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006bd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006c4:	eb 15                	jmp    8006db <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006c6:	ff 45 e8             	incl   -0x18(%ebp)
  8006c9:	a1 40 40 80 00       	mov    0x804040,%eax
  8006ce:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8006d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	77 85                	ja     800660 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006df:	75 14                	jne    8006f5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006e1:	83 ec 04             	sub    $0x4,%esp
  8006e4:	68 68 38 80 00       	push   $0x803868
  8006e9:	6a 3a                	push   $0x3a
  8006eb:	68 5c 38 80 00       	push   $0x80385c
  8006f0:	e8 8d fe ff ff       	call   800582 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006f5:	ff 45 f0             	incl   -0x10(%ebp)
  8006f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006fe:	0f 8c 2f ff ff ff    	jl     800633 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800704:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80070b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800712:	eb 26                	jmp    80073a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800714:	a1 40 40 80 00       	mov    0x804040,%eax
  800719:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80071f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800722:	89 d0                	mov    %edx,%eax
  800724:	01 c0                	add    %eax,%eax
  800726:	01 d0                	add    %edx,%eax
  800728:	c1 e0 03             	shl    $0x3,%eax
  80072b:	01 c8                	add    %ecx,%eax
  80072d:	8a 40 04             	mov    0x4(%eax),%al
  800730:	3c 01                	cmp    $0x1,%al
  800732:	75 03                	jne    800737 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800734:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800737:	ff 45 e0             	incl   -0x20(%ebp)
  80073a:	a1 40 40 80 00       	mov    0x804040,%eax
  80073f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800748:	39 c2                	cmp    %eax,%edx
  80074a:	77 c8                	ja     800714 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80074f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800752:	74 14                	je     800768 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800754:	83 ec 04             	sub    $0x4,%esp
  800757:	68 bc 38 80 00       	push   $0x8038bc
  80075c:	6a 44                	push   $0x44
  80075e:	68 5c 38 80 00       	push   $0x80385c
  800763:	e8 1a fe ff ff       	call   800582 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800768:	90                   	nop
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800771:	8b 45 0c             	mov    0xc(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 48 01             	lea    0x1(%eax),%ecx
  800779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077c:	89 0a                	mov    %ecx,(%edx)
  80077e:	8b 55 08             	mov    0x8(%ebp),%edx
  800781:	88 d1                	mov    %dl,%cl
  800783:	8b 55 0c             	mov    0xc(%ebp),%edx
  800786:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800794:	75 2c                	jne    8007c2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800796:	a0 44 40 80 00       	mov    0x804044,%al
  80079b:	0f b6 c0             	movzbl %al,%eax
  80079e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a1:	8b 12                	mov    (%edx),%edx
  8007a3:	89 d1                	mov    %edx,%ecx
  8007a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a8:	83 c2 08             	add    $0x8,%edx
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	50                   	push   %eax
  8007af:	51                   	push   %ecx
  8007b0:	52                   	push   %edx
  8007b1:	e8 10 12 00 00       	call   8019c6 <sys_cputs>
  8007b6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	8b 40 04             	mov    0x4(%eax),%eax
  8007c8:	8d 50 01             	lea    0x1(%eax),%edx
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007d1:	90                   	nop
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007e4:	00 00 00 
	b.cnt = 0;
  8007e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007fd:	50                   	push   %eax
  8007fe:	68 6b 07 80 00       	push   $0x80076b
  800803:	e8 11 02 00 00       	call   800a19 <vprintfmt>
  800808:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80080b:	a0 44 40 80 00       	mov    0x804044,%al
  800810:	0f b6 c0             	movzbl %al,%eax
  800813:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	50                   	push   %eax
  80081d:	52                   	push   %edx
  80081e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800824:	83 c0 08             	add    $0x8,%eax
  800827:	50                   	push   %eax
  800828:	e8 99 11 00 00       	call   8019c6 <sys_cputs>
  80082d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800830:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800837:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80083d:	c9                   	leave  
  80083e:	c3                   	ret    

0080083f <cprintf>:

int cprintf(const char *fmt, ...) {
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800845:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  80084c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80084f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 f4             	pushl  -0xc(%ebp)
  80085b:	50                   	push   %eax
  80085c:	e8 73 ff ff ff       	call   8007d4 <vcprintf>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800867:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800872:	e8 a8 12 00 00       	call   801b1f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800877:	8d 45 0c             	lea    0xc(%ebp),%eax
  80087a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 f4             	pushl  -0xc(%ebp)
  800886:	50                   	push   %eax
  800887:	e8 48 ff ff ff       	call   8007d4 <vcprintf>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800892:	e8 a2 12 00 00       	call   801b39 <sys_enable_interrupt>
	return cnt;
  800897:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	53                   	push   %ebx
  8008a0:	83 ec 14             	sub    $0x14,%esp
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008af:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ba:	77 55                	ja     800911 <printnum+0x75>
  8008bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008bf:	72 05                	jb     8008c6 <printnum+0x2a>
  8008c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008c4:	77 4b                	ja     800911 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	52                   	push   %edx
  8008d5:	50                   	push   %eax
  8008d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008dc:	e8 67 29 00 00       	call   803248 <__udivdi3>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	ff 75 20             	pushl  0x20(%ebp)
  8008ea:	53                   	push   %ebx
  8008eb:	ff 75 18             	pushl  0x18(%ebp)
  8008ee:	52                   	push   %edx
  8008ef:	50                   	push   %eax
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 a1 ff ff ff       	call   80089c <printnum>
  8008fb:	83 c4 20             	add    $0x20,%esp
  8008fe:	eb 1a                	jmp    80091a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 20             	pushl  0x20(%ebp)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800911:	ff 4d 1c             	decl   0x1c(%ebp)
  800914:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800918:	7f e6                	jg     800900 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80091a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80091d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800925:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800928:	53                   	push   %ebx
  800929:	51                   	push   %ecx
  80092a:	52                   	push   %edx
  80092b:	50                   	push   %eax
  80092c:	e8 27 2a 00 00       	call   803358 <__umoddi3>
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	05 34 3b 80 00       	add    $0x803b34,%eax
  800939:	8a 00                	mov    (%eax),%al
  80093b:	0f be c0             	movsbl %al,%eax
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	50                   	push   %eax
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
}
  80094d:	90                   	nop
  80094e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800951:	c9                   	leave  
  800952:	c3                   	ret    

00800953 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800956:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80095a:	7e 1c                	jle    800978 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 08             	lea    0x8(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 08             	sub    $0x8,%eax
  800971:	8b 50 04             	mov    0x4(%eax),%edx
  800974:	8b 00                	mov    (%eax),%eax
  800976:	eb 40                	jmp    8009b8 <getuint+0x65>
	else if (lflag)
  800978:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097c:	74 1e                	je     80099c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	8d 50 04             	lea    0x4(%eax),%edx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	89 10                	mov    %edx,(%eax)
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	ba 00 00 00 00       	mov    $0x0,%edx
  80099a:	eb 1c                	jmp    8009b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	8d 50 04             	lea    0x4(%eax),%edx
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	89 10                	mov    %edx,(%eax)
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	83 e8 04             	sub    $0x4,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009c1:	7e 1c                	jle    8009df <getint+0x25>
		return va_arg(*ap, long long);
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	8d 50 08             	lea    0x8(%eax),%edx
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	89 10                	mov    %edx,(%eax)
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	83 e8 08             	sub    $0x8,%eax
  8009d8:	8b 50 04             	mov    0x4(%eax),%edx
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	eb 38                	jmp    800a17 <getint+0x5d>
	else if (lflag)
  8009df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e3:	74 1a                	je     8009ff <getint+0x45>
		return va_arg(*ap, long);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	8d 50 04             	lea    0x4(%eax),%edx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	89 10                	mov    %edx,(%eax)
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	8b 00                	mov    (%eax),%eax
  8009f7:	83 e8 04             	sub    $0x4,%eax
  8009fa:	8b 00                	mov    (%eax),%eax
  8009fc:	99                   	cltd   
  8009fd:	eb 18                	jmp    800a17 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	8d 50 04             	lea    0x4(%eax),%edx
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	89 10                	mov    %edx,(%eax)
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	83 e8 04             	sub    $0x4,%eax
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	99                   	cltd   
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	56                   	push   %esi
  800a1d:	53                   	push   %ebx
  800a1e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a21:	eb 17                	jmp    800a3a <vprintfmt+0x21>
			if (ch == '\0')
  800a23:	85 db                	test   %ebx,%ebx
  800a25:	0f 84 af 03 00 00    	je     800dda <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3d:	8d 50 01             	lea    0x1(%eax),%edx
  800a40:	89 55 10             	mov    %edx,0x10(%ebp)
  800a43:	8a 00                	mov    (%eax),%al
  800a45:	0f b6 d8             	movzbl %al,%ebx
  800a48:	83 fb 25             	cmp    $0x25,%ebx
  800a4b:	75 d6                	jne    800a23 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a4d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a58:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a5f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a70:	8d 50 01             	lea    0x1(%eax),%edx
  800a73:	89 55 10             	mov    %edx,0x10(%ebp)
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	0f b6 d8             	movzbl %al,%ebx
  800a7b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a7e:	83 f8 55             	cmp    $0x55,%eax
  800a81:	0f 87 2b 03 00 00    	ja     800db2 <vprintfmt+0x399>
  800a87:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  800a8e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a90:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a94:	eb d7                	jmp    800a6d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a96:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a9a:	eb d1                	jmp    800a6d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	c1 e0 02             	shl    $0x2,%eax
  800aab:	01 d0                	add    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d8                	add    %ebx,%eax
  800ab1:	83 e8 30             	sub    $0x30,%eax
  800ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800abf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac2:	7e 3e                	jle    800b02 <vprintfmt+0xe9>
  800ac4:	83 fb 39             	cmp    $0x39,%ebx
  800ac7:	7f 39                	jg     800b02 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800acc:	eb d5                	jmp    800aa3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 e8 04             	sub    $0x4,%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ae2:	eb 1f                	jmp    800b03 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae8:	79 83                	jns    800a6d <vprintfmt+0x54>
				width = 0;
  800aea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800af1:	e9 77 ff ff ff       	jmp    800a6d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800af6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800afd:	e9 6b ff ff ff       	jmp    800a6d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b02:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b07:	0f 89 60 ff ff ff    	jns    800a6d <vprintfmt+0x54>
				width = precision, precision = -1;
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b1a:	e9 4e ff ff ff       	jmp    800a6d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b1f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b22:	e9 46 ff ff ff       	jmp    800a6d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	83 c0 04             	add    $0x4,%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 e8 04             	sub    $0x4,%eax
  800b36:	8b 00                	mov    (%eax),%eax
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	50                   	push   %eax
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
			break;
  800b47:	e9 89 02 00 00       	jmp    800dd5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	83 c0 04             	add    $0x4,%eax
  800b52:	89 45 14             	mov    %eax,0x14(%ebp)
  800b55:	8b 45 14             	mov    0x14(%ebp),%eax
  800b58:	83 e8 04             	sub    $0x4,%eax
  800b5b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	79 02                	jns    800b63 <vprintfmt+0x14a>
				err = -err;
  800b61:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b63:	83 fb 64             	cmp    $0x64,%ebx
  800b66:	7f 0b                	jg     800b73 <vprintfmt+0x15a>
  800b68:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800b6f:	85 f6                	test   %esi,%esi
  800b71:	75 19                	jne    800b8c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b73:	53                   	push   %ebx
  800b74:	68 45 3b 80 00       	push   $0x803b45
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	ff 75 08             	pushl  0x8(%ebp)
  800b7f:	e8 5e 02 00 00       	call   800de2 <printfmt>
  800b84:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b87:	e9 49 02 00 00       	jmp    800dd5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b8c:	56                   	push   %esi
  800b8d:	68 4e 3b 80 00       	push   $0x803b4e
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	ff 75 08             	pushl  0x8(%ebp)
  800b98:	e8 45 02 00 00       	call   800de2 <printfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp
			break;
  800ba0:	e9 30 02 00 00       	jmp    800dd5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 14             	mov    %eax,0x14(%ebp)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 e8 04             	sub    $0x4,%eax
  800bb4:	8b 30                	mov    (%eax),%esi
  800bb6:	85 f6                	test   %esi,%esi
  800bb8:	75 05                	jne    800bbf <vprintfmt+0x1a6>
				p = "(null)";
  800bba:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  800bbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc3:	7e 6d                	jle    800c32 <vprintfmt+0x219>
  800bc5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bc9:	74 67                	je     800c32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	50                   	push   %eax
  800bd2:	56                   	push   %esi
  800bd3:	e8 0c 03 00 00       	call   800ee4 <strnlen>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bde:	eb 16                	jmp    800bf6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800be0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	ff d0                	call   *%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf3:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfa:	7f e4                	jg     800be0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bfc:	eb 34                	jmp    800c32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c02:	74 1c                	je     800c20 <vprintfmt+0x207>
  800c04:	83 fb 1f             	cmp    $0x1f,%ebx
  800c07:	7e 05                	jle    800c0e <vprintfmt+0x1f5>
  800c09:	83 fb 7e             	cmp    $0x7e,%ebx
  800c0c:	7e 12                	jle    800c20 <vprintfmt+0x207>
					putch('?', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	6a 3f                	push   $0x3f
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
  800c1e:	eb 0f                	jmp    800c2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800c32:	89 f0                	mov    %esi,%eax
  800c34:	8d 70 01             	lea    0x1(%eax),%esi
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f be d8             	movsbl %al,%ebx
  800c3c:	85 db                	test   %ebx,%ebx
  800c3e:	74 24                	je     800c64 <vprintfmt+0x24b>
  800c40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c44:	78 b8                	js     800bfe <vprintfmt+0x1e5>
  800c46:	ff 4d e0             	decl   -0x20(%ebp)
  800c49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c4d:	79 af                	jns    800bfe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4f:	eb 13                	jmp    800c64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 20                	push   $0x20
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c61:	ff 4d e4             	decl   -0x1c(%ebp)
  800c64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c68:	7f e7                	jg     800c51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c6a:	e9 66 01 00 00       	jmp    800dd5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 e8             	pushl  -0x18(%ebp)
  800c75:	8d 45 14             	lea    0x14(%ebp),%eax
  800c78:	50                   	push   %eax
  800c79:	e8 3c fd ff ff       	call   8009ba <getint>
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c8d:	85 d2                	test   %edx,%edx
  800c8f:	79 23                	jns    800cb4 <vprintfmt+0x29b>
				putch('-', putdat);
  800c91:	83 ec 08             	sub    $0x8,%esp
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	6a 2d                	push   $0x2d
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	ff d0                	call   *%eax
  800c9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca7:	f7 d8                	neg    %eax
  800ca9:	83 d2 00             	adc    $0x0,%edx
  800cac:	f7 da                	neg    %edx
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cb4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cbb:	e9 bc 00 00 00       	jmp    800d7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc9:	50                   	push   %eax
  800cca:	e8 84 fc ff ff       	call   800953 <getuint>
  800ccf:	83 c4 10             	add    $0x10,%esp
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 98 00 00 00       	jmp    800d7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	6a 58                	push   $0x58
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	ff d0                	call   *%eax
  800cf1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	6a 58                	push   $0x58
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	6a 58                	push   $0x58
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff d0                	call   *%eax
  800d11:	83 c4 10             	add    $0x10,%esp
			break;
  800d14:	e9 bc 00 00 00       	jmp    800dd5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 30                	push   $0x30
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 78                	push   $0x78
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d39:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3c:	83 c0 04             	add    $0x4,%eax
  800d3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d42:	8b 45 14             	mov    0x14(%ebp),%eax
  800d45:	83 e8 04             	sub    $0x4,%eax
  800d48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d5b:	eb 1f                	jmp    800d7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d5d:	83 ec 08             	sub    $0x8,%esp
  800d60:	ff 75 e8             	pushl  -0x18(%ebp)
  800d63:	8d 45 14             	lea    0x14(%ebp),%eax
  800d66:	50                   	push   %eax
  800d67:	e8 e7 fb ff ff       	call   800953 <getuint>
  800d6c:	83 c4 10             	add    $0x10,%esp
  800d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d83:	83 ec 04             	sub    $0x4,%esp
  800d86:	52                   	push   %edx
  800d87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d8a:	50                   	push   %eax
  800d8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	ff 75 08             	pushl  0x8(%ebp)
  800d97:	e8 00 fb ff ff       	call   80089c <printnum>
  800d9c:	83 c4 20             	add    $0x20,%esp
			break;
  800d9f:	eb 34                	jmp    800dd5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	eb 23                	jmp    800dd5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	6a 25                	push   $0x25
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc2:	ff 4d 10             	decl   0x10(%ebp)
  800dc5:	eb 03                	jmp    800dca <vprintfmt+0x3b1>
  800dc7:	ff 4d 10             	decl   0x10(%ebp)
  800dca:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcd:	48                   	dec    %eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	3c 25                	cmp    $0x25,%al
  800dd2:	75 f3                	jne    800dc7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800dd4:	90                   	nop
		}
	}
  800dd5:	e9 47 fc ff ff       	jmp    800a21 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dda:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ddb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800de8:	8d 45 10             	lea    0x10(%ebp),%eax
  800deb:	83 c0 04             	add    $0x4,%eax
  800dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800df1:	8b 45 10             	mov    0x10(%ebp),%eax
  800df4:	ff 75 f4             	pushl  -0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	ff 75 0c             	pushl  0xc(%ebp)
  800dfb:	ff 75 08             	pushl  0x8(%ebp)
  800dfe:	e8 16 fc ff ff       	call   800a19 <vprintfmt>
  800e03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e06:	90                   	nop
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	8b 40 08             	mov    0x8(%eax),%eax
  800e12:	8d 50 01             	lea    0x1(%eax),%edx
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8b 10                	mov    (%eax),%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	8b 40 04             	mov    0x4(%eax),%eax
  800e26:	39 c2                	cmp    %eax,%edx
  800e28:	73 12                	jae    800e3c <sprintputch+0x33>
		*b->buf++ = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 10                	mov    %dl,(%eax)
}
  800e3c:	90                   	nop
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	01 d0                	add    %edx,%eax
  800e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e64:	74 06                	je     800e6c <vsnprintf+0x2d>
  800e66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6a:	7f 07                	jg     800e73 <vsnprintf+0x34>
		return -E_INVAL;
  800e6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e71:	eb 20                	jmp    800e93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e73:	ff 75 14             	pushl  0x14(%ebp)
  800e76:	ff 75 10             	pushl  0x10(%ebp)
  800e79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e7c:	50                   	push   %eax
  800e7d:	68 09 0e 80 00       	push   $0x800e09
  800e82:	e8 92 fb ff ff       	call   800a19 <vprintfmt>
  800e87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e9e:	83 c0 04             	add    $0x4,%eax
  800ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	ff 75 f4             	pushl  -0xc(%ebp)
  800eaa:	50                   	push   %eax
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	ff 75 08             	pushl  0x8(%ebp)
  800eb1:	e8 89 ff ff ff       	call   800e3f <vsnprintf>
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ece:	eb 06                	jmp    800ed6 <strlen+0x15>
		n++;
  800ed0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed3:	ff 45 08             	incl   0x8(%ebp)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	75 f1                	jne    800ed0 <strlen+0xf>
		n++;
	return n;
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef1:	eb 09                	jmp    800efc <strnlen+0x18>
		n++;
  800ef3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef6:	ff 45 08             	incl   0x8(%ebp)
  800ef9:	ff 4d 0c             	decl   0xc(%ebp)
  800efc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f00:	74 09                	je     800f0b <strnlen+0x27>
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	84 c0                	test   %al,%al
  800f09:	75 e8                	jne    800ef3 <strnlen+0xf>
		n++;
	return n;
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f1c:	90                   	nop
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8d 50 01             	lea    0x1(%eax),%edx
  800f23:	89 55 08             	mov    %edx,0x8(%ebp)
  800f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2f:	8a 12                	mov    (%edx),%dl
  800f31:	88 10                	mov    %dl,(%eax)
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	84 c0                	test   %al,%al
  800f37:	75 e4                	jne    800f1d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f51:	eb 1f                	jmp    800f72 <strncpy+0x34>
		*dst++ = *src;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5f:	8a 12                	mov    (%edx),%dl
  800f61:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	84 c0                	test   %al,%al
  800f6a:	74 03                	je     800f6f <strncpy+0x31>
			src++;
  800f6c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f6f:	ff 45 fc             	incl   -0x4(%ebp)
  800f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f78:	72 d9                	jb     800f53 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8f:	74 30                	je     800fc1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f91:	eb 16                	jmp    800fa9 <strlcpy+0x2a>
			*dst++ = *src++;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8d 50 01             	lea    0x1(%eax),%edx
  800f99:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fa5:	8a 12                	mov    (%edx),%dl
  800fa7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa9:	ff 4d 10             	decl   0x10(%ebp)
  800fac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb0:	74 09                	je     800fbb <strlcpy+0x3c>
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	84 c0                	test   %al,%al
  800fb9:	75 d8                	jne    800f93 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc7:	29 c2                	sub    %eax,%edx
  800fc9:	89 d0                	mov    %edx,%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fd0:	eb 06                	jmp    800fd8 <strcmp+0xb>
		p++, q++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
  800fd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strcmp+0x22>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 e3                	je     800fd2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	0f b6 c0             	movzbl %al,%eax
  800fff:	29 c2                	sub    %eax,%edx
  801001:	89 d0                	mov    %edx,%eax
}
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801008:	eb 09                	jmp    801013 <strncmp+0xe>
		n--, p++, q++;
  80100a:	ff 4d 10             	decl   0x10(%ebp)
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801017:	74 17                	je     801030 <strncmp+0x2b>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	74 0e                	je     801030 <strncmp+0x2b>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 10                	mov    (%eax),%dl
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	38 c2                	cmp    %al,%dl
  80102e:	74 da                	je     80100a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801030:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801034:	75 07                	jne    80103d <strncmp+0x38>
		return 0;
  801036:	b8 00 00 00 00       	mov    $0x0,%eax
  80103b:	eb 14                	jmp    801051 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f b6 d0             	movzbl %al,%edx
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	0f b6 c0             	movzbl %al,%eax
  80104d:	29 c2                	sub    %eax,%edx
  80104f:	89 d0                	mov    %edx,%eax
}
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105f:	eb 12                	jmp    801073 <strchr+0x20>
		if (*s == c)
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801069:	75 05                	jne    801070 <strchr+0x1d>
			return (char *) s;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	eb 11                	jmp    801081 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	84 c0                	test   %al,%al
  80107a:	75 e5                	jne    801061 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 04             	sub    $0x4,%esp
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80108f:	eb 0d                	jmp    80109e <strfind+0x1b>
		if (*s == c)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801099:	74 0e                	je     8010a9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 ea                	jne    801091 <strfind+0xe>
  8010a7:	eb 01                	jmp    8010aa <strfind+0x27>
		if (*s == c)
			break;
  8010a9:	90                   	nop
	return (char *) s;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010c1:	eb 0e                	jmp    8010d1 <memset+0x22>
		*p++ = c;
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010d1:	ff 4d f8             	decl   -0x8(%ebp)
  8010d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010d8:	79 e9                	jns    8010c3 <memset+0x14>
		*p++ = c;

	return v;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010f1:	eb 16                	jmp    801109 <memcpy+0x2a>
		*d++ = *s++;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801102:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801105:	8a 12                	mov    (%edx),%dl
  801107:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110f:	89 55 10             	mov    %edx,0x10(%ebp)
  801112:	85 c0                	test   %eax,%eax
  801114:	75 dd                	jne    8010f3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80112d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801130:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801133:	73 50                	jae    801185 <memmove+0x6a>
  801135:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801140:	76 43                	jbe    801185 <memmove+0x6a>
		s += n;
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80114e:	eb 10                	jmp    801160 <memmove+0x45>
			*--d = *--s;
  801150:	ff 4d f8             	decl   -0x8(%ebp)
  801153:	ff 4d fc             	decl   -0x4(%ebp)
  801156:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801159:	8a 10                	mov    (%eax),%dl
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	8d 50 ff             	lea    -0x1(%eax),%edx
  801166:	89 55 10             	mov    %edx,0x10(%ebp)
  801169:	85 c0                	test   %eax,%eax
  80116b:	75 e3                	jne    801150 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80116d:	eb 23                	jmp    801192 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8d 50 01             	lea    0x1(%eax),%edx
  801175:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801178:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80117e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801181:	8a 12                	mov    (%edx),%dl
  801183:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118b:	89 55 10             	mov    %edx,0x10(%ebp)
  80118e:	85 c0                	test   %eax,%eax
  801190:	75 dd                	jne    80116f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a9:	eb 2a                	jmp    8011d5 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	8a 10                	mov    (%eax),%dl
  8011b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	38 c2                	cmp    %al,%dl
  8011b7:	74 16                	je     8011cf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	0f b6 d0             	movzbl %al,%edx
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	29 c2                	sub    %eax,%edx
  8011cb:	89 d0                	mov    %edx,%eax
  8011cd:	eb 18                	jmp    8011e7 <memcmp+0x50>
		s1++, s2++;
  8011cf:	ff 45 fc             	incl   -0x4(%ebp)
  8011d2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011db:	89 55 10             	mov    %edx,0x10(%ebp)
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	75 c9                	jne    8011ab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011fa:	eb 15                	jmp    801211 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f b6 d0             	movzbl %al,%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	0f b6 c0             	movzbl %al,%eax
  80120a:	39 c2                	cmp    %eax,%edx
  80120c:	74 0d                	je     80121b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80120e:	ff 45 08             	incl   0x8(%ebp)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801217:	72 e3                	jb     8011fc <memfind+0x13>
  801219:	eb 01                	jmp    80121c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80121b:	90                   	nop
	return (void *) s;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80122e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801235:	eb 03                	jmp    80123a <strtol+0x19>
		s++;
  801237:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 20                	cmp    $0x20,%al
  801241:	74 f4                	je     801237 <strtol+0x16>
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 09                	cmp    $0x9,%al
  80124a:	74 eb                	je     801237 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 2b                	cmp    $0x2b,%al
  801253:	75 05                	jne    80125a <strtol+0x39>
		s++;
  801255:	ff 45 08             	incl   0x8(%ebp)
  801258:	eb 13                	jmp    80126d <strtol+0x4c>
	else if (*s == '-')
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 2d                	cmp    $0x2d,%al
  801261:	75 0a                	jne    80126d <strtol+0x4c>
		s++, neg = 1;
  801263:	ff 45 08             	incl   0x8(%ebp)
  801266:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80126d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801271:	74 06                	je     801279 <strtol+0x58>
  801273:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801277:	75 20                	jne    801299 <strtol+0x78>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 30                	cmp    $0x30,%al
  801280:	75 17                	jne    801299 <strtol+0x78>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	40                   	inc    %eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	3c 78                	cmp    $0x78,%al
  80128a:	75 0d                	jne    801299 <strtol+0x78>
		s += 2, base = 16;
  80128c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801290:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801297:	eb 28                	jmp    8012c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801299:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129d:	75 15                	jne    8012b4 <strtol+0x93>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 30                	cmp    $0x30,%al
  8012a6:	75 0c                	jne    8012b4 <strtol+0x93>
		s++, base = 8;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b2:	eb 0d                	jmp    8012c1 <strtol+0xa0>
	else if (base == 0)
  8012b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b8:	75 07                	jne    8012c1 <strtol+0xa0>
		base = 10;
  8012ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 2f                	cmp    $0x2f,%al
  8012c8:	7e 19                	jle    8012e3 <strtol+0xc2>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 39                	cmp    $0x39,%al
  8012d1:	7f 10                	jg     8012e3 <strtol+0xc2>
			dig = *s - '0';
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	83 e8 30             	sub    $0x30,%eax
  8012de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e1:	eb 42                	jmp    801325 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 60                	cmp    $0x60,%al
  8012ea:	7e 19                	jle    801305 <strtol+0xe4>
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 7a                	cmp    $0x7a,%al
  8012f3:	7f 10                	jg     801305 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	0f be c0             	movsbl %al,%eax
  8012fd:	83 e8 57             	sub    $0x57,%eax
  801300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801303:	eb 20                	jmp    801325 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 40                	cmp    $0x40,%al
  80130c:	7e 39                	jle    801347 <strtol+0x126>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 5a                	cmp    $0x5a,%al
  801315:	7f 30                	jg     801347 <strtol+0x126>
			dig = *s - 'A' + 10;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	83 e8 37             	sub    $0x37,%eax
  801322:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801328:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132b:	7d 19                	jge    801346 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80132d:	ff 45 08             	incl   0x8(%ebp)
  801330:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801333:	0f af 45 10          	imul   0x10(%ebp),%eax
  801337:	89 c2                	mov    %eax,%edx
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	01 d0                	add    %edx,%eax
  80133e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801341:	e9 7b ff ff ff       	jmp    8012c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801346:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801347:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80134b:	74 08                	je     801355 <strtol+0x134>
		*endptr = (char *) s;
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	8b 55 08             	mov    0x8(%ebp),%edx
  801353:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801355:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801359:	74 07                	je     801362 <strtol+0x141>
  80135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135e:	f7 d8                	neg    %eax
  801360:	eb 03                	jmp    801365 <strtol+0x144>
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <ltostr>:

void
ltostr(long value, char *str)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80136d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801374:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80137b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80137f:	79 13                	jns    801394 <ltostr+0x2d>
	{
		neg = 1;
  801381:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80138e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801391:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80139c:	99                   	cltd   
  80139d:	f7 f9                	idiv   %ecx
  80139f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a5:	8d 50 01             	lea    0x1(%eax),%edx
  8013a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ab:	89 c2                	mov    %eax,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	01 d0                	add    %edx,%eax
  8013b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b5:	83 c2 30             	add    $0x30,%edx
  8013b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c2:	f7 e9                	imul   %ecx
  8013c4:	c1 fa 02             	sar    $0x2,%edx
  8013c7:	89 c8                	mov    %ecx,%eax
  8013c9:	c1 f8 1f             	sar    $0x1f,%eax
  8013cc:	29 c2                	sub    %eax,%edx
  8013ce:	89 d0                	mov    %edx,%eax
  8013d0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013db:	f7 e9                	imul   %ecx
  8013dd:	c1 fa 02             	sar    $0x2,%edx
  8013e0:	89 c8                	mov    %ecx,%eax
  8013e2:	c1 f8 1f             	sar    $0x1f,%eax
  8013e5:	29 c2                	sub    %eax,%edx
  8013e7:	89 d0                	mov    %edx,%eax
  8013e9:	c1 e0 02             	shl    $0x2,%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	01 c0                	add    %eax,%eax
  8013f0:	29 c1                	sub    %eax,%ecx
  8013f2:	89 ca                	mov    %ecx,%edx
  8013f4:	85 d2                	test   %edx,%edx
  8013f6:	75 9c                	jne    801394 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801402:	48                   	dec    %eax
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801406:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80140a:	74 3d                	je     801449 <ltostr+0xe2>
		start = 1 ;
  80140c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801413:	eb 34                	jmp    801449 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 c2                	add    %eax,%edx
  80142a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 c8                	add    %ecx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801441:	88 02                	mov    %al,(%edx)
		start++ ;
  801443:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801446:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144f:	7c c4                	jl     801415 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801451:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 54 fa ff ff       	call   800ec1 <strlen>
  80146d:	83 c4 04             	add    $0x4,%esp
  801470:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	e8 46 fa ff ff       	call   800ec1 <strlen>
  80147b:	83 c4 04             	add    $0x4,%esp
  80147e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148f:	eb 17                	jmp    8014a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801491:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	01 c2                	add    %eax,%edx
  801499:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	01 c8                	add    %ecx,%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a5:	ff 45 fc             	incl   -0x4(%ebp)
  8014a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ae:	7c e1                	jl     801491 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014be:	eb 1f                	jmp    8014df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c3:	8d 50 01             	lea    0x1(%eax),%edx
  8014c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ce:	01 c2                	add    %eax,%edx
  8014d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d6:	01 c8                	add    %ecx,%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014dc:	ff 45 f8             	incl   -0x8(%ebp)
  8014df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e5:	7c d9                	jl     8014c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150d:	8b 45 10             	mov    0x10(%ebp),%eax
  801510:	01 d0                	add    %edx,%eax
  801512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801518:	eb 0c                	jmp    801526 <strsplit+0x31>
			*string++ = 0;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8d 50 01             	lea    0x1(%eax),%edx
  801520:	89 55 08             	mov    %edx,0x8(%ebp)
  801523:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	84 c0                	test   %al,%al
  80152d:	74 18                	je     801547 <strsplit+0x52>
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	0f be c0             	movsbl %al,%eax
  801537:	50                   	push   %eax
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	e8 13 fb ff ff       	call   801053 <strchr>
  801540:	83 c4 08             	add    $0x8,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	75 d3                	jne    80151a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	84 c0                	test   %al,%al
  80154e:	74 5a                	je     8015aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	8b 00                	mov    (%eax),%eax
  801555:	83 f8 0f             	cmp    $0xf,%eax
  801558:	75 07                	jne    801561 <strsplit+0x6c>
		{
			return 0;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 66                	jmp    8015c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	8b 00                	mov    (%eax),%eax
  801566:	8d 48 01             	lea    0x1(%eax),%ecx
  801569:	8b 55 14             	mov    0x14(%ebp),%edx
  80156c:	89 0a                	mov    %ecx,(%edx)
  80156e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	01 c2                	add    %eax,%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157f:	eb 03                	jmp    801584 <strsplit+0x8f>
			string++;
  801581:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	84 c0                	test   %al,%al
  80158b:	74 8b                	je     801518 <strsplit+0x23>
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	0f be c0             	movsbl %al,%eax
  801595:	50                   	push   %eax
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	e8 b5 fa ff ff       	call   801053 <strchr>
  80159e:	83 c4 08             	add    $0x8,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	74 dc                	je     801581 <strsplit+0x8c>
			string++;
	}
  8015a5:	e9 6e ff ff ff       	jmp    801518 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8015cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d6:	eb 4c                	jmp    801624 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8015d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3c 40                	cmp    $0x40,%al
  8015e4:	7e 27                	jle    80160d <str2lower+0x44>
  8015e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ec:	01 d0                	add    %edx,%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 5a                	cmp    $0x5a,%al
  8015f2:	7f 19                	jg     80160d <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8015f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	01 d0                	add    %edx,%eax
  8015fc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	01 ca                	add    %ecx,%edx
  801604:	8a 12                	mov    (%edx),%dl
  801606:	83 c2 20             	add    $0x20,%edx
  801609:	88 10                	mov    %dl,(%eax)
  80160b:	eb 14                	jmp    801621 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	01 c2                	add    %eax,%edx
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	01 c8                	add    %ecx,%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801621:	ff 45 fc             	incl   -0x4(%ebp)
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	e8 95 f8 ff ff       	call   800ec1 <strlen>
  80162c:	83 c4 04             	add    $0x4,%esp
  80162f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801632:	7f a4                	jg     8015d8 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  80163c:	a1 20 40 80 00       	mov    0x804020,%eax
  801641:	85 c0                	test   %eax,%eax
  801643:	74 0a                	je     80164f <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801645:	c7 05 20 40 80 00 00 	movl   $0x0,0x804020
  80164c:	00 00 00 
	}
}
  80164f:	90                   	nop
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	e8 7e 09 00 00       	call   801fe1 <sys_sbrk>
  801663:	83 c4 10             	add    $0x10,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166e:	e8 c6 ff ff ff       	call   801639 <InitializeUHeap>
	if (size == 0)
  801673:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801677:	75 0a                	jne    801683 <malloc+0x1b>
		return NULL;
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
  80167e:	e9 3f 01 00 00       	jmp    8017c2 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801683:	e8 ac 09 00 00       	call   802034 <sys_get_hard_limit>
  801688:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  80168b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801695:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80169a:	c1 e8 0c             	shr    $0xc,%eax
  80169d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8016a0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ad:	01 d0                	add    %edx,%eax
  8016af:	48                   	dec    %eax
  8016b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bb:	f7 75 d8             	divl   -0x28(%ebp)
  8016be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016c1:	29 d0                	sub    %edx,%eax
  8016c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8016c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016c9:	c1 e8 0c             	shr    $0xc,%eax
  8016cc:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8016cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d3:	75 0a                	jne    8016df <malloc+0x77>
		return NULL;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	e9 e3 00 00 00       	jmp    8017c2 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8016df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e2:	05 00 00 00 80       	add    $0x80000000,%eax
  8016e7:	c1 e8 0c             	shr    $0xc,%eax
  8016ea:	a3 20 83 80 00       	mov    %eax,0x808320

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016ef:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016f6:	77 19                	ja     801711 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  8016f8:	83 ec 0c             	sub    $0xc,%esp
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	e8 60 0b 00 00       	call   802263 <alloc_block_FF>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801709:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80170c:	e9 b1 00 00 00       	jmp    8017c2 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801711:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801714:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801717:	eb 4d                	jmp    801766 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171c:	8a 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%al
  801723:	84 c0                	test   %al,%al
  801725:	75 27                	jne    80174e <malloc+0xe6>
			{
				counter++;
  801727:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  80172a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80172e:	75 14                	jne    801744 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801733:	05 00 00 08 00       	add    $0x80000,%eax
  801738:	c1 e0 0c             	shl    $0xc,%eax
  80173b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  80173e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801741:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801747:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80174a:	75 17                	jne    801763 <malloc+0xfb>
				{
					break;
  80174c:	eb 21                	jmp    80176f <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  80174e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801751:	8a 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%al
  801758:	3c 01                	cmp    $0x1,%al
  80175a:	75 07                	jne    801763 <malloc+0xfb>
			{
				counter = 0;
  80175c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801763:	ff 45 e8             	incl   -0x18(%ebp)
  801766:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  80176d:	76 aa                	jbe    801719 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80176f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801772:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801775:	75 46                	jne    8017bd <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801777:	83 ec 08             	sub    $0x8,%esp
  80177a:	ff 75 d0             	pushl  -0x30(%ebp)
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	e8 93 08 00 00       	call   802018 <sys_allocate_user_mem>
  801785:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80178e:	89 14 c5 44 83 80 00 	mov    %edx,0x808344(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80179b:	eb 0e                	jmp    8017ab <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  80179d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a0:	c6 04 c5 40 83 80 00 	movb   $0x1,0x808340(,%eax,8)
  8017a7:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8017a8:	ff 45 e4             	incl   -0x1c(%ebp)
  8017ab:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017b6:	77 e5                	ja     80179d <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	eb 05                	jmp    8017c2 <malloc+0x15a>
		}
	}

	return NULL;
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8017ca:	e8 65 08 00 00       	call   802034 <sys_get_hard_limit>
  8017cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8017d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017dc:	0f 84 c1 00 00 00    	je     8018a3 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8017e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	79 1b                	jns    801804 <free+0x40>
  8017e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ef:	73 13                	jae    801804 <free+0x40>
    {
        free_block(virtual_address);
  8017f1:	83 ec 0c             	sub    $0xc,%esp
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 34 10 00 00       	call   802830 <free_block>
  8017fc:	83 c4 10             	add    $0x10,%esp
    	return;
  8017ff:	e9 a6 00 00 00       	jmp    8018aa <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801807:	05 00 10 00 00       	add    $0x1000,%eax
  80180c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80180f:	0f 87 91 00 00 00    	ja     8018a6 <free+0xe2>
  801815:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80181c:	0f 87 84 00 00 00    	ja     8018a6 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801825:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801830:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801836:	05 00 00 00 80       	add    $0x80000000,%eax
  80183b:	c1 e8 0c             	shr    $0xc,%eax
  80183e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801844:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  80184b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  80184e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801852:	74 55                	je     8018a9 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  80185d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801860:	c7 04 c5 44 83 80 00 	movl   $0x0,0x808344(,%eax,8)
  801867:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  80186b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801871:	eb 0e                	jmp    801881 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801876:	c6 04 c5 40 83 80 00 	movb   $0x0,0x808340(,%eax,8)
  80187d:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  80187e:	ff 45 f4             	incl   -0xc(%ebp)
  801881:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801887:	01 c2                	add    %eax,%edx
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	39 c2                	cmp    %eax,%edx
  80188e:	77 e3                	ja     801873 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 e0             	pushl  -0x20(%ebp)
  801896:	ff 75 ec             	pushl  -0x14(%ebp)
  801899:	e8 5e 07 00 00       	call   801ffc <sys_free_user_mem>
  80189e:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8018a1:	eb 07                	jmp    8018aa <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8018a3:	90                   	nop
  8018a4:	eb 04                	jmp    8018aa <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8018a6:	90                   	nop
  8018a7:	eb 01                	jmp    8018aa <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8018a9:	90                   	nop
    else
     {
    	return;
      }

}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 18             	sub    $0x18,%esp
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b8:	e8 7c fd ff ff       	call   801639 <InitializeUHeap>
	if (size == 0)
  8018bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c1:	75 07                	jne    8018ca <smalloc+0x1e>
		return NULL;
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	eb 17                	jmp    8018e1 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	68 b0 3c 80 00       	push   $0x803cb0
  8018d2:	68 ad 00 00 00       	push   $0xad
  8018d7:	68 d6 3c 80 00       	push   $0x803cd6
  8018dc:	e8 a1 ec ff ff       	call   800582 <_panic>
	return NULL;
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e9:	e8 4b fd ff ff       	call   801639 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 e4 3c 80 00       	push   $0x803ce4
  8018f6:	68 ba 00 00 00       	push   $0xba
  8018fb:	68 d6 3c 80 00       	push   $0x803cd6
  801900:	e8 7d ec ff ff       	call   800582 <_panic>

00801905 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80190b:	e8 29 fd ff ff       	call   801639 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 08 3d 80 00       	push   $0x803d08
  801918:	68 d8 00 00 00       	push   $0xd8
  80191d:	68 d6 3c 80 00       	push   $0x803cd6
  801922:	e8 5b ec ff ff       	call   800582 <_panic>

00801927 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 30 3d 80 00       	push   $0x803d30
  801935:	68 ea 00 00 00       	push   $0xea
  80193a:	68 d6 3c 80 00       	push   $0x803cd6
  80193f:	e8 3e ec ff ff       	call   800582 <_panic>

00801944 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 54 3d 80 00       	push   $0x803d54
  801952:	68 f2 00 00 00       	push   $0xf2
  801957:	68 d6 3c 80 00       	push   $0x803cd6
  80195c:	e8 21 ec ff ff       	call   800582 <_panic>

00801961 <shrink>:

}
void shrink(uint32 newSize) {
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	68 54 3d 80 00       	push   $0x803d54
  80196f:	68 f6 00 00 00       	push   $0xf6
  801974:	68 d6 3c 80 00       	push   $0x803cd6
  801979:	e8 04 ec ff ff       	call   800582 <_panic>

0080197e <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	68 54 3d 80 00       	push   $0x803d54
  80198c:	68 fa 00 00 00       	push   $0xfa
  801991:	68 d6 3c 80 00       	push   $0x803cd6
  801996:	e8 e7 eb ff ff       	call   800582 <_panic>

0080199b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	57                   	push   %edi
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019b6:	cd 30                	int    $0x30
  8019b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	5b                   	pop    %ebx
  8019c2:	5e                   	pop    %esi
  8019c3:	5f                   	pop    %edi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	50                   	push   %eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	e8 b2 ff ff ff       	call   80199b <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 01                	push   $0x1
  8019fe:	e8 98 ff ff ff       	call   80199b <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 05                	push   $0x5
  801a1b:	e8 7b ff ff ff       	call   80199b <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	56                   	push   %esi
  801a29:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a2a:	8b 75 18             	mov    0x18(%ebp),%esi
  801a2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	51                   	push   %ecx
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 06                	push   $0x6
  801a40:	e8 56 ff ff ff       	call   80199b <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 07                	push   $0x7
  801a62:	e8 34 ff ff ff       	call   80199b <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 08                	push   $0x8
  801a7d:	e8 19 ff ff ff       	call   80199b <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 09                	push   $0x9
  801a96:	e8 00 ff ff ff       	call   80199b <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 0a                	push   $0xa
  801aaf:	e8 e7 fe ff ff       	call   80199b <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 0b                	push   $0xb
  801ac8:	e8 ce fe ff ff       	call   80199b <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 0c                	push   $0xc
  801ae1:	e8 b5 fe ff ff       	call   80199b <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	6a 0d                	push   $0xd
  801afb:	e8 9b fe ff ff       	call   80199b <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 0e                	push   $0xe
  801b14:	e8 82 fe ff ff       	call   80199b <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 11                	push   $0x11
  801b2e:	e8 68 fe ff ff       	call   80199b <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 12                	push   $0x12
  801b48:	e8 4e fe ff ff       	call   80199b <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	50                   	push   %eax
  801b6c:	6a 13                	push   $0x13
  801b6e:	e8 28 fe ff ff       	call   80199b <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	90                   	nop
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 14                	push   $0x14
  801b88:	e8 0e fe ff ff       	call   80199b <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	6a 15                	push   $0x15
  801ba5:	e8 f1 fd ff ff       	call   80199b <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 18                	push   $0x18
  801bc2:	e8 d4 fd ff ff       	call   80199b <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 16                	push   $0x16
  801bdf:	e8 b7 fd ff ff       	call   80199b <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	90                   	nop
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 17                	push   $0x17
  801bfd:	e8 99 fd ff ff       	call   80199b <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	90                   	nop
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c11:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	51                   	push   %ecx
  801c21:	52                   	push   %edx
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	6a 19                	push   $0x19
  801c28:	e8 6e fd ff ff       	call   80199b <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 1a                	push   $0x1a
  801c45:	e8 51 fd ff ff       	call   80199b <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	51                   	push   %ecx
  801c60:	52                   	push   %edx
  801c61:	50                   	push   %eax
  801c62:	6a 1b                	push   $0x1b
  801c64:	e8 32 fd ff ff       	call   80199b <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 1c                	push   $0x1c
  801c81:	e8 15 fd ff ff       	call   80199b <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 1d                	push   $0x1d
  801c9a:	e8 fc fc ff ff       	call   80199b <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 14             	pushl  0x14(%ebp)
  801caf:	ff 75 10             	pushl  0x10(%ebp)
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	50                   	push   %eax
  801cb6:	6a 1e                	push   $0x1e
  801cb8:	e8 de fc ff ff       	call   80199b <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	50                   	push   %eax
  801cd1:	6a 1f                	push   $0x1f
  801cd3:	e8 c3 fc ff ff       	call   80199b <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	50                   	push   %eax
  801ced:	6a 20                	push   $0x20
  801cef:	e8 a7 fc ff ff       	call   80199b <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 02                	push   $0x2
  801d08:	e8 8e fc ff ff       	call   80199b <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 03                	push   $0x3
  801d21:	e8 75 fc ff ff       	call   80199b <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 04                	push   $0x4
  801d3a:	e8 5c fc ff ff       	call   80199b <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_exit_env>:


void sys_exit_env(void)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 21                	push   $0x21
  801d53:	e8 43 fc ff ff       	call   80199b <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	90                   	nop
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d67:	8d 50 04             	lea    0x4(%eax),%edx
  801d6a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	6a 22                	push   $0x22
  801d77:	e8 1f fc ff ff       	call   80199b <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d88:	89 01                	mov    %eax,(%ecx)
  801d8a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	c9                   	leave  
  801d91:	c2 04 00             	ret    $0x4

00801d94 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	ff 75 10             	pushl  0x10(%ebp)
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 10                	push   $0x10
  801da6:	e8 f0 fb ff ff       	call   80199b <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return ;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 23                	push   $0x23
  801dc0:	e8 d6 fb ff ff       	call   80199b <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	50                   	push   %eax
  801de3:	6a 24                	push   $0x24
  801de5:	e8 b1 fb ff ff       	call   80199b <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <rsttst>:
void rsttst()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 26                	push   $0x26
  801dff:	e8 97 fb ff ff       	call   80199b <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return ;
  801e07:	90                   	nop
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	8b 45 14             	mov    0x14(%ebp),%eax
  801e13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e16:	8b 55 18             	mov    0x18(%ebp),%edx
  801e19:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	ff 75 10             	pushl  0x10(%ebp)
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 25                	push   $0x25
  801e2a:	e8 6c fb ff ff       	call   80199b <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <chktst>:
void chktst(uint32 n)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 27                	push   $0x27
  801e45:	e8 51 fb ff ff       	call   80199b <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <inctst>:

void inctst()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 28                	push   $0x28
  801e5f:	e8 37 fb ff ff       	call   80199b <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <gettst>:
uint32 gettst()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 29                	push   $0x29
  801e79:	e8 1d fb ff ff       	call   80199b <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 2a                	push   $0x2a
  801e95:	e8 01 fb ff ff       	call   80199b <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
  801e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea4:	75 07                	jne    801ead <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	eb 05                	jmp    801eb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 2a                	push   $0x2a
  801ec6:	e8 d0 fa ff ff       	call   80199b <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
  801ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ed5:	75 07                	jne    801ede <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ed7:	b8 01 00 00 00       	mov    $0x1,%eax
  801edc:	eb 05                	jmp    801ee3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 2a                	push   $0x2a
  801ef7:	e8 9f fa ff ff       	call   80199b <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
  801eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f02:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f06:	75 07                	jne    801f0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f08:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0d:	eb 05                	jmp    801f14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 2a                	push   $0x2a
  801f28:	e8 6e fa ff ff       	call   80199b <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
  801f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f33:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f37:	75 07                	jne    801f40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f39:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3e:	eb 05                	jmp    801f45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	6a 2b                	push   $0x2b
  801f57:	e8 3f fa ff ff       	call   80199b <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	53                   	push   %ebx
  801f75:	51                   	push   %ecx
  801f76:	52                   	push   %edx
  801f77:	50                   	push   %eax
  801f78:	6a 2c                	push   $0x2c
  801f7a:	e8 1c fa ff ff       	call   80199b <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	6a 2d                	push   $0x2d
  801f9a:	e8 fc f9 ff ff       	call   80199b <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fa7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	51                   	push   %ecx
  801fb3:	ff 75 10             	pushl  0x10(%ebp)
  801fb6:	52                   	push   %edx
  801fb7:	50                   	push   %eax
  801fb8:	6a 2e                	push   $0x2e
  801fba:	e8 dc f9 ff ff       	call   80199b <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	ff 75 10             	pushl  0x10(%ebp)
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	6a 0f                	push   $0xf
  801fd6:	e8 c0 f9 ff ff       	call   80199b <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fde:	90                   	nop
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	50                   	push   %eax
  801ff0:	6a 2f                	push   $0x2f
  801ff2:	e8 a4 f9 ff ff       	call   80199b <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp

}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	6a 30                	push   $0x30
  80200d:	e8 89 f9 ff ff       	call   80199b <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	6a 31                	push   $0x31
  802029:	e8 6d f9 ff ff       	call   80199b <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
	return;
  802031:	90                   	nop
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 32                	push   $0x32
  802043:	e8 53 f9 ff ff       	call   80199b <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	50                   	push   %eax
  80205c:	6a 33                	push   $0x33
  80205e:	e8 38 f9 ff ff       	call   80199b <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	90                   	nop
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	83 e8 10             	sub    $0x10,%eax
  802075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	83 e8 10             	sub    $0x10,%eax
  80208b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  80208e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802091:	8a 40 04             	mov    0x4(%eax),%al
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80209c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	83 f8 02             	cmp    $0x2,%eax
  8020a9:	74 2b                	je     8020d6 <alloc_block+0x40>
  8020ab:	83 f8 02             	cmp    $0x2,%eax
  8020ae:	7f 07                	jg     8020b7 <alloc_block+0x21>
  8020b0:	83 f8 01             	cmp    $0x1,%eax
  8020b3:	74 0e                	je     8020c3 <alloc_block+0x2d>
  8020b5:	eb 58                	jmp    80210f <alloc_block+0x79>
  8020b7:	83 f8 03             	cmp    $0x3,%eax
  8020ba:	74 2d                	je     8020e9 <alloc_block+0x53>
  8020bc:	83 f8 04             	cmp    $0x4,%eax
  8020bf:	74 3b                	je     8020fc <alloc_block+0x66>
  8020c1:	eb 4c                	jmp    80210f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	e8 95 01 00 00       	call   802263 <alloc_block_FF>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d4:	eb 4a                	jmp    802120 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	ff 75 08             	pushl  0x8(%ebp)
  8020dc:	e8 32 07 00 00       	call   802813 <alloc_block_NF>
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e7:	eb 37                	jmp    802120 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	ff 75 08             	pushl  0x8(%ebp)
  8020ef:	e8 a3 04 00 00       	call   802597 <alloc_block_BF>
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020fa:	eb 24                	jmp    802120 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	e8 ef 06 00 00       	call   8027f6 <alloc_block_WF>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80210d:	eb 11                	jmp    802120 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	68 64 3d 80 00       	push   $0x803d64
  802117:	e8 23 e7 ff ff       	call   80083f <cprintf>
  80211c:	83 c4 10             	add    $0x10,%esp
		break;
  80211f:	90                   	nop
	}
	return va;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 84 3d 80 00       	push   $0x803d84
  802133:	e8 07 e7 ff ff       	call   80083f <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	68 af 3d 80 00       	push   $0x803daf
  802143:	e8 f7 e6 ff ff       	call   80083f <cprintf>
  802148:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802151:	eb 26                	jmp    802179 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8a 40 04             	mov    0x4(%eax),%al
  802159:	0f b6 d0             	movzbl %al,%edx
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	68 c7 3d 80 00       	push   $0x803dc7
  80216b:	e8 cf e6 ff ff       	call   80083f <cprintf>
  802170:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802173:	8b 45 10             	mov    0x10(%ebp),%eax
  802176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217d:	74 08                	je     802187 <print_blocks_list+0x62>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 08             	mov    0x8(%eax),%eax
  802185:	eb 05                	jmp    80218c <print_blocks_list+0x67>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	89 45 10             	mov    %eax,0x10(%ebp)
  80218f:	8b 45 10             	mov    0x10(%ebp),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 bd                	jne    802153 <print_blocks_list+0x2e>
  802196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219a:	75 b7                	jne    802153 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  80219c:	83 ec 0c             	sub    $0xc,%esp
  80219f:	68 84 3d 80 00       	push   $0x803d84
  8021a4:	e8 96 e6 ff ff       	call   80083f <cprintf>
  8021a9:	83 c4 10             	add    $0x10,%esp

}
  8021ac:	90                   	nop
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8021b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b9:	0f 84 a1 00 00 00    	je     802260 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8021bf:	c7 05 4c 40 80 00 01 	movl   $0x1,0x80404c
  8021c6:	00 00 00 
	LIST_INIT(&list);
  8021c9:	c7 05 40 83 90 00 00 	movl   $0x0,0x908340
  8021d0:	00 00 00 
  8021d3:	c7 05 44 83 90 00 00 	movl   $0x0,0x908344
  8021da:	00 00 00 
  8021dd:	c7 05 4c 83 90 00 00 	movl   $0x0,0x90834c
  8021e4:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	75 14                	jne    802216 <initialize_dynamic_allocator+0x67>
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	68 e0 3d 80 00       	push   $0x803de0
  80220a:	6a 64                	push   $0x64
  80220c:	68 03 3e 80 00       	push   $0x803e03
  802211:	e8 6c e3 ff ff       	call   800582 <_panic>
  802216:	8b 15 44 83 90 00    	mov    0x908344,%edx
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	89 50 0c             	mov    %edx,0xc(%eax)
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 40 0c             	mov    0xc(%eax),%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	74 0d                	je     802239 <initialize_dynamic_allocator+0x8a>
  80222c:	a1 44 83 90 00       	mov    0x908344,%eax
  802231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802234:	89 50 08             	mov    %edx,0x8(%eax)
  802237:	eb 08                	jmp    802241 <initialize_dynamic_allocator+0x92>
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	a3 40 83 90 00       	mov    %eax,0x908340
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	a3 44 83 90 00       	mov    %eax,0x908344
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802253:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802258:	40                   	inc    %eax
  802259:	a3 4c 83 90 00       	mov    %eax,0x90834c
  80225e:	eb 01                	jmp    802261 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802260:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226d:	75 0a                	jne    802279 <alloc_block_FF+0x16>
	{
		return NULL;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	e9 1c 03 00 00       	jmp    802595 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802279:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	75 40                	jne    8022c2 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	83 c0 10             	add    $0x10,%eax
  802288:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  80228b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	50                   	push   %eax
  802292:	e8 bb f3 ff ff       	call   801652 <sbrk>
  802297:	83 c4 10             	add    $0x10,%esp
  80229a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	6a 00                	push   $0x0
  8022a2:	e8 ab f3 ff ff       	call   801652 <sbrk>
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8022ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8022b3:	83 ec 08             	sub    $0x8,%esp
  8022b6:	50                   	push   %eax
  8022b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8022ba:	e8 f0 fe ff ff       	call   8021af <initialize_dynamic_allocator>
  8022bf:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8022c2:	a1 40 83 90 00       	mov    0x908340,%eax
  8022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ca:	e9 1e 01 00 00       	jmp    8023ed <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8d 50 10             	lea    0x10(%eax),%edx
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	39 c2                	cmp    %eax,%edx
  8022dc:	75 1c                	jne    8022fa <alloc_block_FF+0x97>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8a 40 04             	mov    0x4(%eax),%al
  8022e4:	3c 01                	cmp    $0x1,%al
  8022e6:	75 12                	jne    8022fa <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	83 c0 10             	add    $0x10,%eax
  8022f5:	e9 9b 02 00 00       	jmp    802595 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8d 50 10             	lea    0x10(%eax),%edx
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	39 c2                	cmp    %eax,%edx
  802307:	0f 83 d8 00 00 00    	jae    8023e5 <alloc_block_FF+0x182>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8a 40 04             	mov    0x4(%eax),%al
  802313:	3c 01                	cmp    $0x1,%al
  802315:	0f 85 ca 00 00 00    	jne    8023e5 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	2b 45 08             	sub    0x8(%ebp),%eax
  802323:	83 e8 10             	sub    $0x10,%eax
  802326:	83 f8 0f             	cmp    $0xf,%eax
  802329:	0f 86 a4 00 00 00    	jbe    8023d3 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  80232f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	01 d0                	add    %edx,%eax
  802337:	83 c0 10             	add    $0x10,%eax
  80233a:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	2b 45 08             	sub    0x8(%ebp),%eax
  802345:	8d 50 f0             	lea    -0x10(%eax),%edx
  802348:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80234b:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  80234d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802350:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802358:	74 06                	je     802360 <alloc_block_FF+0xfd>
  80235a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80235e:	75 17                	jne    802377 <alloc_block_FF+0x114>
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	68 1c 3e 80 00       	push   $0x803e1c
  802368:	68 8f 00 00 00       	push   $0x8f
  80236d:	68 03 3e 80 00       	push   $0x803e03
  802372:	e8 0b e2 ff ff       	call   800582 <_panic>
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 50 08             	mov    0x8(%eax),%edx
  80237d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802380:	89 50 08             	mov    %edx,0x8(%eax)
  802383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802386:	8b 40 08             	mov    0x8(%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	74 0c                	je     802399 <alloc_block_FF+0x136>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 40 08             	mov    0x8(%eax),%eax
  802393:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802396:	89 50 0c             	mov    %edx,0xc(%eax)
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80239f:	89 50 08             	mov    %edx,0x8(%eax)
  8023a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a8:	89 50 0c             	mov    %edx,0xc(%eax)
  8023ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ae:	8b 40 08             	mov    0x8(%eax),%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	75 08                	jne    8023bd <alloc_block_FF+0x15a>
  8023b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023b8:	a3 44 83 90 00       	mov    %eax,0x908344
  8023bd:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8023c2:	40                   	inc    %eax
  8023c3:	a3 4c 83 90 00       	mov    %eax,0x90834c
		    iterator->size = size + sizeOfMetaData();
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	8d 50 10             	lea    0x10(%eax),%edx
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	83 c0 10             	add    $0x10,%eax
  8023e0:	e9 b0 01 00 00       	jmp    802595 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  8023e5:	a1 48 83 90 00       	mov    0x908348,%eax
  8023ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	74 08                	je     8023fb <alloc_block_FF+0x198>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 08             	mov    0x8(%eax),%eax
  8023f9:	eb 05                	jmp    802400 <alloc_block_FF+0x19d>
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	a3 48 83 90 00       	mov    %eax,0x908348
  802405:	a1 48 83 90 00       	mov    0x908348,%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	0f 85 bd fe ff ff    	jne    8022cf <alloc_block_FF+0x6c>
  802412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802416:	0f 85 b3 fe ff ff    	jne    8022cf <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	83 c0 10             	add    $0x10,%eax
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	50                   	push   %eax
  802426:	e8 27 f2 ff ff       	call   801652 <sbrk>
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	6a 00                	push   $0x0
  802436:	e8 17 f2 ff ff       	call   801652 <sbrk>
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802447:	29 c2                	sub    %eax,%edx
  802449:	89 d0                	mov    %edx,%eax
  80244b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  80244e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802452:	0f 84 38 01 00 00    	je     802590 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  80245e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802462:	75 17                	jne    80247b <alloc_block_FF+0x218>
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	68 e0 3d 80 00       	push   $0x803de0
  80246c:	68 9f 00 00 00       	push   $0x9f
  802471:	68 03 3e 80 00       	push   $0x803e03
  802476:	e8 07 e1 ff ff       	call   800582 <_panic>
  80247b:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802481:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802484:	89 50 0c             	mov    %edx,0xc(%eax)
  802487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 0d                	je     80249e <alloc_block_FF+0x23b>
  802491:	a1 44 83 90 00       	mov    0x908344,%eax
  802496:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802499:	89 50 08             	mov    %edx,0x8(%eax)
  80249c:	eb 08                	jmp    8024a6 <alloc_block_FF+0x243>
  80249e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a1:	a3 40 83 90 00       	mov    %eax,0x908340
  8024a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a9:	a3 44 83 90 00       	mov    %eax,0x908344
  8024ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024b8:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8024bd:	40                   	inc    %eax
  8024be:	a3 4c 83 90 00       	mov    %eax,0x90834c
			newBlock->size = size + sizeOfMetaData();
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8d 50 10             	lea    0x10(%eax),%edx
  8024c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024cc:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8024ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  8024d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8024db:	83 f8 10             	cmp    $0x10,%eax
  8024de:	0f 84 a4 00 00 00    	je     802588 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  8024e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ea:	83 e8 10             	sub    $0x10,%eax
  8024ed:	83 f8 0f             	cmp    $0xf,%eax
  8024f0:	0f 86 8a 00 00 00    	jbe    802580 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  8024f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	01 d0                	add    %edx,%eax
  8024fe:	83 c0 10             	add    $0x10,%eax
  802501:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802504:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802508:	75 17                	jne    802521 <alloc_block_FF+0x2be>
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	68 e0 3d 80 00       	push   $0x803de0
  802512:	68 a7 00 00 00       	push   $0xa7
  802517:	68 03 3e 80 00       	push   $0x803e03
  80251c:	e8 61 e0 ff ff       	call   800582 <_panic>
  802521:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252a:	89 50 0c             	mov    %edx,0xc(%eax)
  80252d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	74 0d                	je     802544 <alloc_block_FF+0x2e1>
  802537:	a1 44 83 90 00       	mov    0x908344,%eax
  80253c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80253f:	89 50 08             	mov    %edx,0x8(%eax)
  802542:	eb 08                	jmp    80254c <alloc_block_FF+0x2e9>
  802544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802547:	a3 40 83 90 00       	mov    %eax,0x908340
  80254c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254f:	a3 44 83 90 00       	mov    %eax,0x908344
  802554:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802557:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80255e:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802563:	40                   	inc    %eax
  802564:	a3 4c 83 90 00       	mov    %eax,0x90834c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802569:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256c:	2b 45 08             	sub    0x8(%ebp),%eax
  80256f:	8d 50 f0             	lea    -0x10(%eax),%edx
  802572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802575:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802577:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80257a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  80257e:	eb 08                	jmp    802588 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802583:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802586:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802588:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80258b:	83 c0 10             	add    $0x10,%eax
  80258e:	eb 05                	jmp    802595 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  80259d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  8025a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a8:	75 0a                	jne    8025b4 <alloc_block_BF+0x1d>
	{
		return NULL;
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025af:	e9 40 02 00 00       	jmp    8027f4 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8025b4:	a1 40 83 90 00       	mov    0x908340,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	eb 66                	jmp    802624 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8a 40 04             	mov    0x4(%eax),%al
  8025c4:	3c 01                	cmp    $0x1,%al
  8025c6:	75 21                	jne    8025e9 <alloc_block_BF+0x52>
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	8d 50 10             	lea    0x10(%eax),%edx
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	39 c2                	cmp    %eax,%edx
  8025d5:	75 12                	jne    8025e9 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	83 c0 10             	add    $0x10,%eax
  8025e4:	e9 0b 02 00 00       	jmp    8027f4 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8a 40 04             	mov    0x4(%eax),%al
  8025ef:	3c 01                	cmp    $0x1,%al
  8025f1:	75 29                	jne    80261c <alloc_block_BF+0x85>
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	8d 50 10             	lea    0x10(%eax),%edx
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	39 c2                	cmp    %eax,%edx
  802600:	77 1a                	ja     80261c <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802602:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802606:	74 0e                	je     802616 <alloc_block_BF+0x7f>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 10                	mov    (%eax),%edx
  80260d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	39 c2                	cmp    %eax,%edx
  802614:	73 06                	jae    80261c <alloc_block_BF+0x85>
			{
				BF = iterator;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  80261c:	a1 48 83 90 00       	mov    0x908348,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	74 08                	je     802632 <alloc_block_BF+0x9b>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 08             	mov    0x8(%eax),%eax
  802630:	eb 05                	jmp    802637 <alloc_block_BF+0xa0>
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	a3 48 83 90 00       	mov    %eax,0x908348
  80263c:	a1 48 83 90 00       	mov    0x908348,%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	0f 85 75 ff ff ff    	jne    8025be <alloc_block_BF+0x27>
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	0f 85 6b ff ff ff    	jne    8025be <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802653:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802657:	0f 84 f8 00 00 00    	je     802755 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	8d 50 10             	lea    0x10(%eax),%edx
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	39 c2                	cmp    %eax,%edx
  80266a:	0f 87 e5 00 00 00    	ja     802755 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	2b 45 08             	sub    0x8(%ebp),%eax
  802678:	83 e8 10             	sub    $0x10,%eax
  80267b:	83 f8 0f             	cmp    $0xf,%eax
  80267e:	0f 86 bf 00 00 00    	jbe    802743 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802684:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	01 d0                	add    %edx,%eax
  80268c:	83 c0 10             	add    $0x10,%eax
  80268f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  80269b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a3:	8d 50 f0             	lea    -0x10(%eax),%edx
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8026b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b6:	74 06                	je     8026be <alloc_block_BF+0x127>
  8026b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bc:	75 17                	jne    8026d5 <alloc_block_BF+0x13e>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 1c 3e 80 00       	push   $0x803e1c
  8026c6:	68 e3 00 00 00       	push   $0xe3
  8026cb:	68 03 3e 80 00       	push   $0x803e03
  8026d0:	e8 ad de ff ff       	call   800582 <_panic>
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	8b 50 08             	mov    0x8(%eax),%edx
  8026db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026de:	89 50 08             	mov    %edx,0x8(%eax)
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	8b 40 08             	mov    0x8(%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 0c                	je     8026f7 <alloc_block_BF+0x160>
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f4:	89 50 0c             	mov    %edx,0xc(%eax)
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fd:	89 50 08             	mov    %edx,0x8(%eax)
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802706:	89 50 0c             	mov    %edx,0xc(%eax)
  802709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270c:	8b 40 08             	mov    0x8(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	75 08                	jne    80271b <alloc_block_BF+0x184>
  802713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802716:	a3 44 83 90 00       	mov    %eax,0x908344
  80271b:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802720:	40                   	inc    %eax
  802721:	a3 4c 83 90 00       	mov    %eax,0x90834c

				BF->size = size + sizeOfMetaData();
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	8d 50 10             	lea    0x10(%eax),%edx
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802734:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	83 c0 10             	add    $0x10,%eax
  80273e:	e9 b1 00 00 00       	jmp    8027f4 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	83 c0 10             	add    $0x10,%eax
  802750:	e9 9f 00 00 00       	jmp    8027f4 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	83 c0 10             	add    $0x10,%eax
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	50                   	push   %eax
  80275f:	e8 ee ee ff ff       	call   801652 <sbrk>
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  80276a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80276e:	74 7f                	je     8027ef <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802770:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802774:	75 17                	jne    80278d <alloc_block_BF+0x1f6>
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 e0 3d 80 00       	push   $0x803de0
  80277e:	68 f6 00 00 00       	push   $0xf6
  802783:	68 03 3e 80 00       	push   $0x803e03
  802788:	e8 f5 dd ff ff       	call   800582 <_panic>
  80278d:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802796:	89 50 0c             	mov    %edx,0xc(%eax)
  802799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 0d                	je     8027b0 <alloc_block_BF+0x219>
  8027a3:	a1 44 83 90 00       	mov    0x908344,%eax
  8027a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
  8027ae:	eb 08                	jmp    8027b8 <alloc_block_BF+0x221>
  8027b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b3:	a3 40 83 90 00       	mov    %eax,0x908340
  8027b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bb:	a3 44 83 90 00       	mov    %eax,0x908344
  8027c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027ca:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8027cf:	40                   	inc    %eax
  8027d0:	a3 4c 83 90 00       	mov    %eax,0x90834c
		newBlock->size = size + sizeOfMetaData();
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	8d 50 10             	lea    0x10(%eax),%edx
  8027db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027de:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8027e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8027e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ea:	83 c0 10             	add    $0x10,%eax
  8027ed:	eb 05                	jmp    8027f4 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	68 50 3e 80 00       	push   $0x803e50
  802804:	68 07 01 00 00       	push   $0x107
  802809:	68 03 3e 80 00       	push   $0x803e03
  80280e:	e8 6f dd ff ff       	call   800582 <_panic>

00802813 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	68 78 3e 80 00       	push   $0x803e78
  802821:	68 0f 01 00 00       	push   $0x10f
  802826:	68 03 3e 80 00       	push   $0x803e03
  80282b:	e8 52 dd ff ff       	call   800582 <_panic>

00802830 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802836:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283a:	0f 84 ee 05 00 00    	je     802e2e <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	83 e8 10             	sub    $0x10,%eax
  802846:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802849:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80284d:	a1 40 83 90 00       	mov    0x908340,%eax
  802852:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802855:	eb 16                	jmp    80286d <free_block+0x3d>
	{
		if (block_pointer == it)
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80285d:	75 06                	jne    802865 <free_block+0x35>
		{
			flagx = 1;
  80285f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802863:	eb 2f                	jmp    802894 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802865:	a1 48 83 90 00       	mov    0x908348,%eax
  80286a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80286d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802871:	74 08                	je     80287b <free_block+0x4b>
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 40 08             	mov    0x8(%eax),%eax
  802879:	eb 05                	jmp    802880 <free_block+0x50>
  80287b:	b8 00 00 00 00       	mov    $0x0,%eax
  802880:	a3 48 83 90 00       	mov    %eax,0x908348
  802885:	a1 48 83 90 00       	mov    0x908348,%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	75 c9                	jne    802857 <free_block+0x27>
  80288e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802892:	75 c3                	jne    802857 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802894:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802898:	0f 84 93 05 00 00    	je     802e31 <free_block+0x601>
		return;
	if (va == NULL)
  80289e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a2:	0f 84 8c 05 00 00    	je     802e34 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	8b 40 08             	mov    0x8(%eax),%eax
  8028b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8028ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028be:	75 12                	jne    8028d2 <free_block+0xa2>
  8028c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028c4:	75 0c                	jne    8028d2 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8028cd:	e9 63 05 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8028d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d6:	0f 85 ca 00 00 00    	jne    8029a6 <free_block+0x176>
  8028dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028df:	8a 40 04             	mov    0x4(%eax),%al
  8028e2:	3c 01                	cmp    $0x1,%al
  8028e4:	0f 85 bc 00 00 00    	jne    8029a6 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8028f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f4:	8b 10                	mov    (%eax),%edx
  8028f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	01 c2                	add    %eax,%edx
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80290b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802912:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802916:	75 17                	jne    80292f <free_block+0xff>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 9e 3e 80 00       	push   $0x803e9e
  802920:	68 3c 01 00 00       	push   $0x13c
  802925:	68 03 3e 80 00       	push   $0x803e03
  80292a:	e8 53 dc ff ff       	call   800582 <_panic>
  80292f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802932:	8b 40 08             	mov    0x8(%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 11                	je     80294a <free_block+0x11a>
  802939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293c:	8b 40 08             	mov    0x8(%eax),%eax
  80293f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802942:	8b 52 0c             	mov    0xc(%edx),%edx
  802945:	89 50 0c             	mov    %edx,0xc(%eax)
  802948:	eb 0b                	jmp    802955 <free_block+0x125>
  80294a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294d:	8b 40 0c             	mov    0xc(%eax),%eax
  802950:	a3 44 83 90 00       	mov    %eax,0x908344
  802955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 11                	je     802970 <free_block+0x140>
  80295f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802962:	8b 40 0c             	mov    0xc(%eax),%eax
  802965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802968:	8b 52 08             	mov    0x8(%edx),%edx
  80296b:	89 50 08             	mov    %edx,0x8(%eax)
  80296e:	eb 0b                	jmp    80297b <free_block+0x14b>
  802970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802973:	8b 40 08             	mov    0x8(%eax),%eax
  802976:	a3 40 83 90 00       	mov    %eax,0x908340
  80297b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802988:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80298f:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802994:	48                   	dec    %eax
  802995:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  80299a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8029a1:	e9 8f 04 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8029a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029aa:	75 16                	jne    8029c2 <free_block+0x192>
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	8a 40 04             	mov    0x4(%eax),%al
  8029b2:	84 c0                	test   %al,%al
  8029b4:	75 0c                	jne    8029c2 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8029b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8029bd:	e9 73 04 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8029c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029c6:	0f 85 c3 00 00 00    	jne    802a8f <free_block+0x25f>
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	8a 40 04             	mov    0x4(%eax),%al
  8029d2:	3c 01                	cmp    $0x1,%al
  8029d4:	0f 85 b5 00 00 00    	jne    802a8f <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8029da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dd:	8b 10                	mov    (%eax),%edx
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	01 c2                	add    %eax,%edx
  8029e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e9:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8029fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ff:	75 17                	jne    802a18 <free_block+0x1e8>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 9e 3e 80 00       	push   $0x803e9e
  802a09:	68 49 01 00 00       	push   $0x149
  802a0e:	68 03 3e 80 00       	push   $0x803e03
  802a13:	e8 6a db ff ff       	call   800582 <_panic>
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	8b 40 08             	mov    0x8(%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 11                	je     802a33 <free_block+0x203>
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	8b 40 08             	mov    0x8(%eax),%eax
  802a28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2b:	8b 52 0c             	mov    0xc(%edx),%edx
  802a2e:	89 50 0c             	mov    %edx,0xc(%eax)
  802a31:	eb 0b                	jmp    802a3e <free_block+0x20e>
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	8b 40 0c             	mov    0xc(%eax),%eax
  802a39:	a3 44 83 90 00       	mov    %eax,0x908344
  802a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a41:	8b 40 0c             	mov    0xc(%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 11                	je     802a59 <free_block+0x229>
  802a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a51:	8b 52 08             	mov    0x8(%edx),%edx
  802a54:	89 50 08             	mov    %edx,0x8(%eax)
  802a57:	eb 0b                	jmp    802a64 <free_block+0x234>
  802a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5c:	8b 40 08             	mov    0x8(%eax),%eax
  802a5f:	a3 40 83 90 00       	mov    %eax,0x908340
  802a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a78:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802a7d:	48                   	dec    %eax
  802a7e:	a3 4c 83 90 00       	mov    %eax,0x90834c
		block_pointer = 0;
  802a83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802a8a:	e9 a6 03 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a93:	75 16                	jne    802aab <free_block+0x27b>
  802a95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a98:	8a 40 04             	mov    0x4(%eax),%al
  802a9b:	84 c0                	test   %al,%al
  802a9d:	75 0c                	jne    802aab <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802aa6:	e9 8a 03 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802aab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aaf:	0f 84 81 01 00 00    	je     802c36 <free_block+0x406>
  802ab5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab9:	0f 84 77 01 00 00    	je     802c36 <free_block+0x406>
  802abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac2:	8a 40 04             	mov    0x4(%eax),%al
  802ac5:	3c 01                	cmp    $0x1,%al
  802ac7:	0f 85 69 01 00 00    	jne    802c36 <free_block+0x406>
  802acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad0:	8a 40 04             	mov    0x4(%eax),%al
  802ad3:	3c 01                	cmp    $0x1,%al
  802ad5:	0f 85 5b 01 00 00    	jne    802c36 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ade:	8b 10                	mov    (%eax),%edx
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	8b 08                	mov    (%eax),%ecx
  802ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	01 c8                	add    %ecx,%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802b13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b17:	75 17                	jne    802b30 <free_block+0x300>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 9e 3e 80 00       	push   $0x803e9e
  802b21:	68 59 01 00 00       	push   $0x159
  802b26:	68 03 3e 80 00       	push   $0x803e03
  802b2b:	e8 52 da ff ff       	call   800582 <_panic>
  802b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 11                	je     802b4b <free_block+0x31b>
  802b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3d:	8b 40 08             	mov    0x8(%eax),%eax
  802b40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b43:	8b 52 0c             	mov    0xc(%edx),%edx
  802b46:	89 50 0c             	mov    %edx,0xc(%eax)
  802b49:	eb 0b                	jmp    802b56 <free_block+0x326>
  802b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b51:	a3 44 83 90 00       	mov    %eax,0x908344
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 11                	je     802b71 <free_block+0x341>
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	8b 40 0c             	mov    0xc(%eax),%eax
  802b66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b69:	8b 52 08             	mov    0x8(%edx),%edx
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
  802b6f:	eb 0b                	jmp    802b7c <free_block+0x34c>
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
  802b77:	a3 40 83 90 00       	mov    %eax,0x908340
  802b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b90:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802b95:	48                   	dec    %eax
  802b96:	a3 4c 83 90 00       	mov    %eax,0x90834c
		LIST_REMOVE(&list, next_block);
  802b9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b9f:	75 17                	jne    802bb8 <free_block+0x388>
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	68 9e 3e 80 00       	push   $0x803e9e
  802ba9:	68 5a 01 00 00       	push   $0x15a
  802bae:	68 03 3e 80 00       	push   $0x803e03
  802bb3:	e8 ca d9 ff ff       	call   800582 <_panic>
  802bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbb:	8b 40 08             	mov    0x8(%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 11                	je     802bd3 <free_block+0x3a3>
  802bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc5:	8b 40 08             	mov    0x8(%eax),%eax
  802bc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bcb:	8b 52 0c             	mov    0xc(%edx),%edx
  802bce:	89 50 0c             	mov    %edx,0xc(%eax)
  802bd1:	eb 0b                	jmp    802bde <free_block+0x3ae>
  802bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd9:	a3 44 83 90 00       	mov    %eax,0x908344
  802bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	74 11                	je     802bf9 <free_block+0x3c9>
  802be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bf1:	8b 52 08             	mov    0x8(%edx),%edx
  802bf4:	89 50 08             	mov    %edx,0x8(%eax)
  802bf7:	eb 0b                	jmp    802c04 <free_block+0x3d4>
  802bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfc:	8b 40 08             	mov    0x8(%eax),%eax
  802bff:	a3 40 83 90 00       	mov    %eax,0x908340
  802c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c18:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802c1d:	48                   	dec    %eax
  802c1e:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  802c23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802c2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802c31:	e9 ff 01 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802c36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c3a:	0f 84 db 00 00 00    	je     802d1b <free_block+0x4eb>
  802c40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c44:	0f 84 d1 00 00 00    	je     802d1b <free_block+0x4eb>
  802c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4d:	8a 40 04             	mov    0x4(%eax),%al
  802c50:	84 c0                	test   %al,%al
  802c52:	0f 85 c3 00 00 00    	jne    802d1b <free_block+0x4eb>
  802c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5b:	8a 40 04             	mov    0x4(%eax),%al
  802c5e:	3c 01                	cmp    $0x1,%al
  802c60:	0f 85 b5 00 00 00    	jne    802d1b <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c69:	8b 10                	mov    (%eax),%edx
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	01 c2                	add    %eax,%edx
  802c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c75:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802c87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c8b:	75 17                	jne    802ca4 <free_block+0x474>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 9e 3e 80 00       	push   $0x803e9e
  802c95:	68 64 01 00 00       	push   $0x164
  802c9a:	68 03 3e 80 00       	push   $0x803e03
  802c9f:	e8 de d8 ff ff       	call   800582 <_panic>
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 40 08             	mov    0x8(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 11                	je     802cbf <free_block+0x48f>
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb7:	8b 52 0c             	mov    0xc(%edx),%edx
  802cba:	89 50 0c             	mov    %edx,0xc(%eax)
  802cbd:	eb 0b                	jmp    802cca <free_block+0x49a>
  802cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc5:	a3 44 83 90 00       	mov    %eax,0x908344
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 11                	je     802ce5 <free_block+0x4b5>
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cdd:	8b 52 08             	mov    0x8(%edx),%edx
  802ce0:	89 50 08             	mov    %edx,0x8(%eax)
  802ce3:	eb 0b                	jmp    802cf0 <free_block+0x4c0>
  802ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	a3 40 83 90 00       	mov    %eax,0x908340
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d04:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802d09:	48                   	dec    %eax
  802d0a:	a3 4c 83 90 00       	mov    %eax,0x90834c
		block_pointer = 0;
  802d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802d16:	e9 1a 01 00 00       	jmp    802e35 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d1f:	0f 84 df 00 00 00    	je     802e04 <free_block+0x5d4>
  802d25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d29:	0f 84 d5 00 00 00    	je     802e04 <free_block+0x5d4>
  802d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d32:	8a 40 04             	mov    0x4(%eax),%al
  802d35:	3c 01                	cmp    $0x1,%al
  802d37:	0f 85 c7 00 00 00    	jne    802e04 <free_block+0x5d4>
  802d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d40:	8a 40 04             	mov    0x4(%eax),%al
  802d43:	84 c0                	test   %al,%al
  802d45:	0f 85 b9 00 00 00    	jne    802e04 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	8b 10                	mov    (%eax),%edx
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	01 c2                	add    %eax,%edx
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802d73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d77:	75 17                	jne    802d90 <free_block+0x560>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 9e 3e 80 00       	push   $0x803e9e
  802d81:	68 6e 01 00 00       	push   $0x16e
  802d86:	68 03 3e 80 00       	push   $0x803e03
  802d8b:	e8 f2 d7 ff ff       	call   800582 <_panic>
  802d90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 11                	je     802dab <free_block+0x57b>
  802d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9d:	8b 40 08             	mov    0x8(%eax),%eax
  802da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da3:	8b 52 0c             	mov    0xc(%edx),%edx
  802da6:	89 50 0c             	mov    %edx,0xc(%eax)
  802da9:	eb 0b                	jmp    802db6 <free_block+0x586>
  802dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dae:	8b 40 0c             	mov    0xc(%eax),%eax
  802db1:	a3 44 83 90 00       	mov    %eax,0x908344
  802db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 11                	je     802dd1 <free_block+0x5a1>
  802dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dc9:	8b 52 08             	mov    0x8(%edx),%edx
  802dcc:	89 50 08             	mov    %edx,0x8(%eax)
  802dcf:	eb 0b                	jmp    802ddc <free_block+0x5ac>
  802dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd4:	8b 40 08             	mov    0x8(%eax),%eax
  802dd7:	a3 40 83 90 00       	mov    %eax,0x908340
  802ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802df0:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802df5:	48                   	dec    %eax
  802df6:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  802dfb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802e02:	eb 31                	jmp    802e35 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802e04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e08:	74 2b                	je     802e35 <free_block+0x605>
  802e0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e0e:	74 25                	je     802e35 <free_block+0x605>
  802e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e13:	8a 40 04             	mov    0x4(%eax),%al
  802e16:	84 c0                	test   %al,%al
  802e18:	75 1b                	jne    802e35 <free_block+0x605>
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	8a 40 04             	mov    0x4(%eax),%al
  802e20:	84 c0                	test   %al,%al
  802e22:	75 11                	jne    802e35 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e2b:	90                   	nop
  802e2c:	eb 07                	jmp    802e35 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802e2e:	90                   	nop
  802e2f:	eb 04                	jmp    802e35 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802e31:	90                   	nop
  802e32:	eb 01                	jmp    802e35 <free_block+0x605>
	if (va == NULL)
		return;
  802e34:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802e35:	c9                   	leave  
  802e36:	c3                   	ret    

00802e37 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802e37:	55                   	push   %ebp
  802e38:	89 e5                	mov    %esp,%ebp
  802e3a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802e3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e41:	75 19                	jne    802e5c <realloc_block_FF+0x25>
  802e43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e47:	74 13                	je     802e5c <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	ff 75 0c             	pushl  0xc(%ebp)
  802e4f:	e8 0f f4 ff ff       	call   802263 <alloc_block_FF>
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	e9 ea 03 00 00       	jmp    803246 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  802e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e60:	75 3b                	jne    802e9d <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  802e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e66:	75 17                	jne    802e7f <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  802e68:	83 ec 0c             	sub    $0xc,%esp
  802e6b:	6a 00                	push   $0x0
  802e6d:	e8 f1 f3 ff ff       	call   802263 <alloc_block_FF>
  802e72:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e75:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7a:	e9 c7 03 00 00       	jmp    803246 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  802e7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e83:	74 18                	je     802e9d <realloc_block_FF+0x66>
		{
			free_block(va);
  802e85:	83 ec 0c             	sub    $0xc,%esp
  802e88:	ff 75 08             	pushl  0x8(%ebp)
  802e8b:	e8 a0 f9 ff ff       	call   802830 <free_block>
  802e90:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
  802e98:	e9 a9 03 00 00       	jmp    803246 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  802e9d:	a1 40 83 90 00       	mov    0x908340,%eax
  802ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea5:	e9 68 03 00 00       	jmp    803212 <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	83 e8 10             	sub    $0x10,%eax
  802eb0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802eb3:	0f 85 51 03 00 00    	jne    80320a <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec1:	83 c2 10             	add    $0x10,%edx
  802ec4:	39 d0                	cmp    %edx,%eax
  802ec6:	75 08                	jne    802ed0 <realloc_block_FF+0x99>
			{
				return va;
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	e9 76 03 00 00       	jmp    803246 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ed8:	0f 83 45 02 00 00    	jae    803123 <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 08             	mov    0x8(%eax),%eax
  802ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  802ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eea:	8a 40 04             	mov    0x4(%eax),%al
  802eed:	3c 01                	cmp    $0x1,%al
  802eef:	0f 85 6b 01 00 00    	jne    803060 <realloc_block_FF+0x229>
  802ef5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef9:	0f 84 61 01 00 00    	je     803060 <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 10                	mov    (%eax),%edx
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f0c:	29 c1                	sub    %eax,%ecx
  802f0e:	89 c8                	mov    %ecx,%eax
  802f10:	39 c2                	cmp    %eax,%edx
  802f12:	0f 86 e3 00 00 00    	jbe    802ffb <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  802f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1b:	8b 10                	mov    (%eax),%edx
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f25:	01 d0                	add    %edx,%eax
  802f27:	83 f8 0f             	cmp    $0xf,%eax
  802f2a:	0f 86 b5 00 00 00    	jbe    802fe5 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  802f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f36:	01 d0                	add    %edx,%eax
  802f38:	83 c0 10             	add    $0x10,%eax
  802f3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  802f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  802f4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f52:	74 06                	je     802f5a <realloc_block_FF+0x123>
  802f54:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f58:	75 17                	jne    802f71 <realloc_block_FF+0x13a>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 1c 3e 80 00       	push   $0x803e1c
  802f62:	68 ae 01 00 00       	push   $0x1ae
  802f67:	68 03 3e 80 00       	push   $0x803e03
  802f6c:	e8 11 d6 ff ff       	call   800582 <_panic>
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 50 08             	mov    0x8(%eax),%edx
  802f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7a:	89 50 08             	mov    %edx,0x8(%eax)
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0c                	je     802f93 <realloc_block_FF+0x15c>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f90:	89 50 0c             	mov    %edx,0xc(%eax)
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f99:	89 50 08             	mov    %edx,0x8(%eax)
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa2:	89 50 0c             	mov    %edx,0xc(%eax)
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 40 08             	mov    0x8(%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	75 08                	jne    802fb7 <realloc_block_FF+0x180>
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	a3 44 83 90 00       	mov    %eax,0x908344
  802fb7:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802fbc:	40                   	inc    %eax
  802fbd:	a3 4c 83 90 00       	mov    %eax,0x90834c
							next->size = 0;
  802fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  802fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd5:	8d 50 10             	lea    0x10(%eax),%edx
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	89 10                	mov    %edx,(%eax)
							return va;
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	e9 61 02 00 00       	jmp    803246 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  802fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe8:	8d 50 10             	lea    0x10(%eax),%edx
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	83 c0 10             	add    $0x10,%eax
  802ff6:	e9 4b 02 00 00       	jmp    803246 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 10                	mov    (%eax),%edx
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803008:	29 c1                	sub    %eax,%ecx
  80300a:	89 c8                	mov    %ecx,%eax
  80300c:	39 c2                	cmp    %eax,%edx
  80300e:	0f 83 f5 01 00 00    	jae    803209 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	ff 75 0c             	pushl  0xc(%ebp)
  80301a:	e8 44 f2 ff ff       	call   802263 <alloc_block_FF>
  80301f:	83 c4 10             	add    $0x10,%esp
  803022:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  803025:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803029:	74 2d                	je     803058 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	50                   	push   %eax
  803034:	ff 75 08             	pushl  0x8(%ebp)
  803037:	ff 75 ec             	pushl  -0x14(%ebp)
  80303a:	e8 a0 e0 ff ff       	call   8010df <memcpy>
  80303f:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  803042:	83 ec 0c             	sub    $0xc,%esp
  803045:	ff 75 08             	pushl  0x8(%ebp)
  803048:	e8 e3 f7 ff ff       	call   802830 <free_block>
  80304d:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  803050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803053:	e9 ee 01 00 00       	jmp    803246 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	e9 e6 01 00 00       	jmp    803246 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803063:	8a 40 04             	mov    0x4(%eax),%al
  803066:	3c 01                	cmp    $0x1,%al
  803068:	75 59                	jne    8030c3 <realloc_block_FF+0x28c>
  80306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306d:	8b 10                	mov    (%eax),%edx
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803077:	29 c1                	sub    %eax,%ecx
  803079:	89 c8                	mov    %ecx,%eax
  80307b:	39 c2                	cmp    %eax,%edx
  80307d:	75 44                	jne    8030c3 <realloc_block_FF+0x28c>
  80307f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803083:	74 3e                	je     8030c3 <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	8b 40 08             	mov    0x8(%eax),%eax
  80308b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803094:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309d:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  8030b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b3:	8d 50 10             	lea    0x10(%eax),%edx
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	89 10                	mov    %edx,(%eax)
					return va;
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	e9 83 01 00 00       	jmp    803246 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  8030c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c6:	8a 40 04             	mov    0x4(%eax),%al
  8030c9:	84 c0                	test   %al,%al
  8030cb:	74 0a                	je     8030d7 <realloc_block_FF+0x2a0>
  8030cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d1:	0f 85 33 01 00 00    	jne    80320a <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8030d7:	83 ec 0c             	sub    $0xc,%esp
  8030da:	ff 75 0c             	pushl  0xc(%ebp)
  8030dd:	e8 81 f1 ff ff       	call   802263 <alloc_block_FF>
  8030e2:	83 c4 10             	add    $0x10,%esp
  8030e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  8030e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030ec:	74 2d                	je     80311b <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	50                   	push   %eax
  8030f7:	ff 75 08             	pushl  0x8(%ebp)
  8030fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8030fd:	e8 dd df ff ff       	call   8010df <memcpy>
  803102:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  803105:	83 ec 0c             	sub    $0xc,%esp
  803108:	ff 75 08             	pushl  0x8(%ebp)
  80310b:	e8 20 f7 ff ff       	call   802830 <free_block>
  803110:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803116:	e9 2b 01 00 00       	jmp    803246 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	e9 23 01 00 00       	jmp    803246 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80312b:	0f 86 d9 00 00 00    	jbe    80320a <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	2b 45 0c             	sub    0xc(%ebp),%eax
  803139:	83 f8 0f             	cmp    $0xf,%eax
  80313c:	0f 86 b4 00 00 00    	jbe    8031f6 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803145:	8b 45 0c             	mov    0xc(%ebp),%eax
  803148:	01 d0                	add    %edx,%eax
  80314a:	83 c0 10             	add    $0x10,%eax
  80314d:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	2b 45 0c             	sub    0xc(%ebp),%eax
  803158:	8d 50 f0             	lea    -0x10(%eax),%edx
  80315b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315e:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803164:	74 06                	je     80316c <realloc_block_FF+0x335>
  803166:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80316a:	75 17                	jne    803183 <realloc_block_FF+0x34c>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 1c 3e 80 00       	push   $0x803e1c
  803174:	68 ed 01 00 00       	push   $0x1ed
  803179:	68 03 3e 80 00       	push   $0x803e03
  80317e:	e8 ff d3 ff ff       	call   800582 <_panic>
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 50 08             	mov    0x8(%eax),%edx
  803189:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318c:	89 50 08             	mov    %edx,0x8(%eax)
  80318f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803192:	8b 40 08             	mov    0x8(%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 0c                	je     8031a5 <realloc_block_FF+0x36e>
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 40 08             	mov    0x8(%eax),%eax
  80319f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031a2:	89 50 0c             	mov    %edx,0xc(%eax)
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ab:	89 50 08             	mov    %edx,0x8(%eax)
  8031ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8031b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	75 08                	jne    8031c9 <realloc_block_FF+0x392>
  8031c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c4:	a3 44 83 90 00       	mov    %eax,0x908344
  8031c9:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8031ce:	40                   	inc    %eax
  8031cf:	a3 4c 83 90 00       	mov    %eax,0x90834c
					free_block((void*) (newBlockAfterSplit + 1));
  8031d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d7:	83 c0 10             	add    $0x10,%eax
  8031da:	83 ec 0c             	sub    $0xc,%esp
  8031dd:	50                   	push   %eax
  8031de:	e8 4d f6 ff ff       	call   802830 <free_block>
  8031e3:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  8031e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e9:	8d 50 10             	lea    0x10(%eax),%edx
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	89 10                	mov    %edx,(%eax)
					return va;
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	eb 50                	jmp    803246 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  8031f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f9:	8d 50 10             	lea    0x10(%eax),%edx
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	83 c0 10             	add    $0x10,%eax
  803207:	eb 3d                	jmp    803246 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803209:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  80320a:	a1 48 83 90 00       	mov    0x908348,%eax
  80320f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803216:	74 08                	je     803220 <realloc_block_FF+0x3e9>
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 40 08             	mov    0x8(%eax),%eax
  80321e:	eb 05                	jmp    803225 <realloc_block_FF+0x3ee>
  803220:	b8 00 00 00 00       	mov    $0x0,%eax
  803225:	a3 48 83 90 00       	mov    %eax,0x908348
  80322a:	a1 48 83 90 00       	mov    0x908348,%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	0f 85 73 fc ff ff    	jne    802eaa <realloc_block_FF+0x73>
  803237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323b:	0f 85 69 fc ff ff    	jne    802eaa <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803241:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803246:	c9                   	leave  
  803247:	c3                   	ret    

00803248 <__udivdi3>:
  803248:	55                   	push   %ebp
  803249:	57                   	push   %edi
  80324a:	56                   	push   %esi
  80324b:	53                   	push   %ebx
  80324c:	83 ec 1c             	sub    $0x1c,%esp
  80324f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803253:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803257:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80325f:	89 ca                	mov    %ecx,%edx
  803261:	89 f8                	mov    %edi,%eax
  803263:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803267:	85 f6                	test   %esi,%esi
  803269:	75 2d                	jne    803298 <__udivdi3+0x50>
  80326b:	39 cf                	cmp    %ecx,%edi
  80326d:	77 65                	ja     8032d4 <__udivdi3+0x8c>
  80326f:	89 fd                	mov    %edi,%ebp
  803271:	85 ff                	test   %edi,%edi
  803273:	75 0b                	jne    803280 <__udivdi3+0x38>
  803275:	b8 01 00 00 00       	mov    $0x1,%eax
  80327a:	31 d2                	xor    %edx,%edx
  80327c:	f7 f7                	div    %edi
  80327e:	89 c5                	mov    %eax,%ebp
  803280:	31 d2                	xor    %edx,%edx
  803282:	89 c8                	mov    %ecx,%eax
  803284:	f7 f5                	div    %ebp
  803286:	89 c1                	mov    %eax,%ecx
  803288:	89 d8                	mov    %ebx,%eax
  80328a:	f7 f5                	div    %ebp
  80328c:	89 cf                	mov    %ecx,%edi
  80328e:	89 fa                	mov    %edi,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	39 ce                	cmp    %ecx,%esi
  80329a:	77 28                	ja     8032c4 <__udivdi3+0x7c>
  80329c:	0f bd fe             	bsr    %esi,%edi
  80329f:	83 f7 1f             	xor    $0x1f,%edi
  8032a2:	75 40                	jne    8032e4 <__udivdi3+0x9c>
  8032a4:	39 ce                	cmp    %ecx,%esi
  8032a6:	72 0a                	jb     8032b2 <__udivdi3+0x6a>
  8032a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032ac:	0f 87 9e 00 00 00    	ja     803350 <__udivdi3+0x108>
  8032b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b7:	89 fa                	mov    %edi,%edx
  8032b9:	83 c4 1c             	add    $0x1c,%esp
  8032bc:	5b                   	pop    %ebx
  8032bd:	5e                   	pop    %esi
  8032be:	5f                   	pop    %edi
  8032bf:	5d                   	pop    %ebp
  8032c0:	c3                   	ret    
  8032c1:	8d 76 00             	lea    0x0(%esi),%esi
  8032c4:	31 ff                	xor    %edi,%edi
  8032c6:	31 c0                	xor    %eax,%eax
  8032c8:	89 fa                	mov    %edi,%edx
  8032ca:	83 c4 1c             	add    $0x1c,%esp
  8032cd:	5b                   	pop    %ebx
  8032ce:	5e                   	pop    %esi
  8032cf:	5f                   	pop    %edi
  8032d0:	5d                   	pop    %ebp
  8032d1:	c3                   	ret    
  8032d2:	66 90                	xchg   %ax,%ax
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	f7 f7                	div    %edi
  8032d8:	31 ff                	xor    %edi,%edi
  8032da:	89 fa                	mov    %edi,%edx
  8032dc:	83 c4 1c             	add    $0x1c,%esp
  8032df:	5b                   	pop    %ebx
  8032e0:	5e                   	pop    %esi
  8032e1:	5f                   	pop    %edi
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    
  8032e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032e9:	89 eb                	mov    %ebp,%ebx
  8032eb:	29 fb                	sub    %edi,%ebx
  8032ed:	89 f9                	mov    %edi,%ecx
  8032ef:	d3 e6                	shl    %cl,%esi
  8032f1:	89 c5                	mov    %eax,%ebp
  8032f3:	88 d9                	mov    %bl,%cl
  8032f5:	d3 ed                	shr    %cl,%ebp
  8032f7:	89 e9                	mov    %ebp,%ecx
  8032f9:	09 f1                	or     %esi,%ecx
  8032fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032ff:	89 f9                	mov    %edi,%ecx
  803301:	d3 e0                	shl    %cl,%eax
  803303:	89 c5                	mov    %eax,%ebp
  803305:	89 d6                	mov    %edx,%esi
  803307:	88 d9                	mov    %bl,%cl
  803309:	d3 ee                	shr    %cl,%esi
  80330b:	89 f9                	mov    %edi,%ecx
  80330d:	d3 e2                	shl    %cl,%edx
  80330f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803313:	88 d9                	mov    %bl,%cl
  803315:	d3 e8                	shr    %cl,%eax
  803317:	09 c2                	or     %eax,%edx
  803319:	89 d0                	mov    %edx,%eax
  80331b:	89 f2                	mov    %esi,%edx
  80331d:	f7 74 24 0c          	divl   0xc(%esp)
  803321:	89 d6                	mov    %edx,%esi
  803323:	89 c3                	mov    %eax,%ebx
  803325:	f7 e5                	mul    %ebp
  803327:	39 d6                	cmp    %edx,%esi
  803329:	72 19                	jb     803344 <__udivdi3+0xfc>
  80332b:	74 0b                	je     803338 <__udivdi3+0xf0>
  80332d:	89 d8                	mov    %ebx,%eax
  80332f:	31 ff                	xor    %edi,%edi
  803331:	e9 58 ff ff ff       	jmp    80328e <__udivdi3+0x46>
  803336:	66 90                	xchg   %ax,%ax
  803338:	8b 54 24 08          	mov    0x8(%esp),%edx
  80333c:	89 f9                	mov    %edi,%ecx
  80333e:	d3 e2                	shl    %cl,%edx
  803340:	39 c2                	cmp    %eax,%edx
  803342:	73 e9                	jae    80332d <__udivdi3+0xe5>
  803344:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803347:	31 ff                	xor    %edi,%edi
  803349:	e9 40 ff ff ff       	jmp    80328e <__udivdi3+0x46>
  80334e:	66 90                	xchg   %ax,%ax
  803350:	31 c0                	xor    %eax,%eax
  803352:	e9 37 ff ff ff       	jmp    80328e <__udivdi3+0x46>
  803357:	90                   	nop

00803358 <__umoddi3>:
  803358:	55                   	push   %ebp
  803359:	57                   	push   %edi
  80335a:	56                   	push   %esi
  80335b:	53                   	push   %ebx
  80335c:	83 ec 1c             	sub    $0x1c,%esp
  80335f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803363:	8b 74 24 34          	mov    0x34(%esp),%esi
  803367:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80336b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80336f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803373:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803377:	89 f3                	mov    %esi,%ebx
  803379:	89 fa                	mov    %edi,%edx
  80337b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80337f:	89 34 24             	mov    %esi,(%esp)
  803382:	85 c0                	test   %eax,%eax
  803384:	75 1a                	jne    8033a0 <__umoddi3+0x48>
  803386:	39 f7                	cmp    %esi,%edi
  803388:	0f 86 a2 00 00 00    	jbe    803430 <__umoddi3+0xd8>
  80338e:	89 c8                	mov    %ecx,%eax
  803390:	89 f2                	mov    %esi,%edx
  803392:	f7 f7                	div    %edi
  803394:	89 d0                	mov    %edx,%eax
  803396:	31 d2                	xor    %edx,%edx
  803398:	83 c4 1c             	add    $0x1c,%esp
  80339b:	5b                   	pop    %ebx
  80339c:	5e                   	pop    %esi
  80339d:	5f                   	pop    %edi
  80339e:	5d                   	pop    %ebp
  80339f:	c3                   	ret    
  8033a0:	39 f0                	cmp    %esi,%eax
  8033a2:	0f 87 ac 00 00 00    	ja     803454 <__umoddi3+0xfc>
  8033a8:	0f bd e8             	bsr    %eax,%ebp
  8033ab:	83 f5 1f             	xor    $0x1f,%ebp
  8033ae:	0f 84 ac 00 00 00    	je     803460 <__umoddi3+0x108>
  8033b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033b9:	29 ef                	sub    %ebp,%edi
  8033bb:	89 fe                	mov    %edi,%esi
  8033bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033c1:	89 e9                	mov    %ebp,%ecx
  8033c3:	d3 e0                	shl    %cl,%eax
  8033c5:	89 d7                	mov    %edx,%edi
  8033c7:	89 f1                	mov    %esi,%ecx
  8033c9:	d3 ef                	shr    %cl,%edi
  8033cb:	09 c7                	or     %eax,%edi
  8033cd:	89 e9                	mov    %ebp,%ecx
  8033cf:	d3 e2                	shl    %cl,%edx
  8033d1:	89 14 24             	mov    %edx,(%esp)
  8033d4:	89 d8                	mov    %ebx,%eax
  8033d6:	d3 e0                	shl    %cl,%eax
  8033d8:	89 c2                	mov    %eax,%edx
  8033da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033de:	d3 e0                	shl    %cl,%eax
  8033e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e8:	89 f1                	mov    %esi,%ecx
  8033ea:	d3 e8                	shr    %cl,%eax
  8033ec:	09 d0                	or     %edx,%eax
  8033ee:	d3 eb                	shr    %cl,%ebx
  8033f0:	89 da                	mov    %ebx,%edx
  8033f2:	f7 f7                	div    %edi
  8033f4:	89 d3                	mov    %edx,%ebx
  8033f6:	f7 24 24             	mull   (%esp)
  8033f9:	89 c6                	mov    %eax,%esi
  8033fb:	89 d1                	mov    %edx,%ecx
  8033fd:	39 d3                	cmp    %edx,%ebx
  8033ff:	0f 82 87 00 00 00    	jb     80348c <__umoddi3+0x134>
  803405:	0f 84 91 00 00 00    	je     80349c <__umoddi3+0x144>
  80340b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80340f:	29 f2                	sub    %esi,%edx
  803411:	19 cb                	sbb    %ecx,%ebx
  803413:	89 d8                	mov    %ebx,%eax
  803415:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803419:	d3 e0                	shl    %cl,%eax
  80341b:	89 e9                	mov    %ebp,%ecx
  80341d:	d3 ea                	shr    %cl,%edx
  80341f:	09 d0                	or     %edx,%eax
  803421:	89 e9                	mov    %ebp,%ecx
  803423:	d3 eb                	shr    %cl,%ebx
  803425:	89 da                	mov    %ebx,%edx
  803427:	83 c4 1c             	add    $0x1c,%esp
  80342a:	5b                   	pop    %ebx
  80342b:	5e                   	pop    %esi
  80342c:	5f                   	pop    %edi
  80342d:	5d                   	pop    %ebp
  80342e:	c3                   	ret    
  80342f:	90                   	nop
  803430:	89 fd                	mov    %edi,%ebp
  803432:	85 ff                	test   %edi,%edi
  803434:	75 0b                	jne    803441 <__umoddi3+0xe9>
  803436:	b8 01 00 00 00       	mov    $0x1,%eax
  80343b:	31 d2                	xor    %edx,%edx
  80343d:	f7 f7                	div    %edi
  80343f:	89 c5                	mov    %eax,%ebp
  803441:	89 f0                	mov    %esi,%eax
  803443:	31 d2                	xor    %edx,%edx
  803445:	f7 f5                	div    %ebp
  803447:	89 c8                	mov    %ecx,%eax
  803449:	f7 f5                	div    %ebp
  80344b:	89 d0                	mov    %edx,%eax
  80344d:	e9 44 ff ff ff       	jmp    803396 <__umoddi3+0x3e>
  803452:	66 90                	xchg   %ax,%ax
  803454:	89 c8                	mov    %ecx,%eax
  803456:	89 f2                	mov    %esi,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	3b 04 24             	cmp    (%esp),%eax
  803463:	72 06                	jb     80346b <__umoddi3+0x113>
  803465:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803469:	77 0f                	ja     80347a <__umoddi3+0x122>
  80346b:	89 f2                	mov    %esi,%edx
  80346d:	29 f9                	sub    %edi,%ecx
  80346f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803473:	89 14 24             	mov    %edx,(%esp)
  803476:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80347a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80347e:	8b 14 24             	mov    (%esp),%edx
  803481:	83 c4 1c             	add    $0x1c,%esp
  803484:	5b                   	pop    %ebx
  803485:	5e                   	pop    %esi
  803486:	5f                   	pop    %edi
  803487:	5d                   	pop    %ebp
  803488:	c3                   	ret    
  803489:	8d 76 00             	lea    0x0(%esi),%esi
  80348c:	2b 04 24             	sub    (%esp),%eax
  80348f:	19 fa                	sbb    %edi,%edx
  803491:	89 d1                	mov    %edx,%ecx
  803493:	89 c6                	mov    %eax,%esi
  803495:	e9 71 ff ff ff       	jmp    80340b <__umoddi3+0xb3>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034a0:	72 ea                	jb     80348c <__umoddi3+0x134>
  8034a2:	89 d9                	mov    %ebx,%ecx
  8034a4:	e9 62 ff ff ff       	jmp    80340b <__umoddi3+0xb3>
