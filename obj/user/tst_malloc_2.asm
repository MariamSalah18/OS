
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
  80005c:	68 40 34 80 00       	push   $0x803440
  800061:	6a 21                	push   $0x21
  800063:	68 5c 34 80 00       	push   $0x80345c
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
  800089:	e8 46 1a 00 00       	call   801ad4 <sys_pf_calculate_allocated_pages>
  80008e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 f3 19 00 00       	call   801a89 <sys_calculate_free_frames>
  800096:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("	1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 70 34 80 00       	push   $0x803470
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
  8000e5:	e8 80 15 00 00       	call   80166a <malloc>
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
  800159:	68 bc 34 80 00       	push   $0x8034bc
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
  800217:	68 20 35 80 00       	push   $0x803520
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
  80027d:	68 54 35 80 00       	push   $0x803554
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
  8002a8:	e8 27 18 00 00       	call   801ad4 <sys_pf_calculate_allocated_pages>
  8002ad:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002b0:	74 17                	je     8002c9 <_main+0x291>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	68 a4 35 80 00       	push   $0x8035a4
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
  80036e:	e8 16 17 00 00       	call   801a89 <sys_calculate_free_frames>
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
  800386:	68 e0 35 80 00       	push   $0x8035e0
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
  8003b5:	e8 b0 12 00 00       	call   80166a <malloc>
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
  800409:	e8 98 1b 00 00       	call   801fa6 <sys_check_WS_list>
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	89 45 88             	mov    %eax,-0x78(%ebp)
		if (chk != 1)
  800414:	83 7d 88 01          	cmpl   $0x1,-0x78(%ebp)
  800418:	74 17                	je     800431 <_main+0x3f9>
		{
			cprintf("malloc: page is not added to WS\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 30 36 80 00       	push   $0x803630
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
  800441:	68 54 36 80 00       	push   $0x803654
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
  80045a:	e8 b5 18 00 00       	call   801d14 <sys_getenvindex>
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
  8004b7:	e8 65 16 00 00       	call   801b21 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004bc:	83 ec 0c             	sub    $0xc,%esp
  8004bf:	68 b0 36 80 00       	push   $0x8036b0
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
  8004e7:	68 d8 36 80 00       	push   $0x8036d8
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
  800518:	68 00 37 80 00       	push   $0x803700
  80051d:	e8 1d 03 00 00       	call   80083f <cprintf>
  800522:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800525:	a1 40 40 80 00       	mov    0x804040,%eax
  80052a:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	50                   	push   %eax
  800534:	68 58 37 80 00       	push   $0x803758
  800539:	e8 01 03 00 00       	call   80083f <cprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 b0 36 80 00       	push   $0x8036b0
  800549:	e8 f1 02 00 00       	call   80083f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800551:	e8 e5 15 00 00       	call   801b3b <sys_enable_interrupt>

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
  800569:	e8 72 17 00 00       	call   801ce0 <sys_destroy_env>
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
  80057a:	e8 c7 17 00 00       	call   801d46 <sys_exit_env>
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
  8005a3:	68 6c 37 80 00       	push   $0x80376c
  8005a8:	e8 92 02 00 00       	call   80083f <cprintf>
  8005ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b0:	a1 1c 40 80 00       	mov    0x80401c,%eax
  8005b5:	ff 75 0c             	pushl  0xc(%ebp)
  8005b8:	ff 75 08             	pushl  0x8(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	68 71 37 80 00       	push   $0x803771
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
  8005e0:	68 8d 37 80 00       	push   $0x80378d
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
  80060f:	68 90 37 80 00       	push   $0x803790
  800614:	6a 26                	push   $0x26
  800616:	68 dc 37 80 00       	push   $0x8037dc
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
  8006e4:	68 e8 37 80 00       	push   $0x8037e8
  8006e9:	6a 3a                	push   $0x3a
  8006eb:	68 dc 37 80 00       	push   $0x8037dc
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
  800757:	68 3c 38 80 00       	push   $0x80383c
  80075c:	6a 44                	push   $0x44
  80075e:	68 dc 37 80 00       	push   $0x8037dc
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
  8007b1:	e8 12 12 00 00       	call   8019c8 <sys_cputs>
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
  800828:	e8 9b 11 00 00       	call   8019c8 <sys_cputs>
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
  800872:	e8 aa 12 00 00       	call   801b21 <sys_disable_interrupt>
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
  800892:	e8 a4 12 00 00       	call   801b3b <sys_enable_interrupt>
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
  8008dc:	e8 f3 28 00 00       	call   8031d4 <__udivdi3>
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
  80092c:	e8 b3 29 00 00       	call   8032e4 <__umoddi3>
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	05 b4 3a 80 00       	add    $0x803ab4,%eax
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
  800a87:	8b 04 85 d8 3a 80 00 	mov    0x803ad8(,%eax,4),%eax
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
  800b68:	8b 34 9d 20 39 80 00 	mov    0x803920(,%ebx,4),%esi
  800b6f:	85 f6                	test   %esi,%esi
  800b71:	75 19                	jne    800b8c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b73:	53                   	push   %ebx
  800b74:	68 c5 3a 80 00       	push   $0x803ac5
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
  800b8d:	68 ce 3a 80 00       	push   $0x803ace
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
  800bba:	be d1 3a 80 00       	mov    $0x803ad1,%esi
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
	return NULL;
  801634:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  80163e:	a1 20 40 80 00       	mov    0x804020,%eax
  801643:	85 c0                	test   %eax,%eax
  801645:	74 0a                	je     801651 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801647:	c7 05 20 40 80 00 00 	movl   $0x0,0x804020
  80164e:	00 00 00 
	}
}
  801651:	90                   	nop
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    

00801654 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80165a:	83 ec 0c             	sub    $0xc,%esp
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	e8 7e 09 00 00       	call   801fe3 <sys_sbrk>
  801665:	83 c4 10             	add    $0x10,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801670:	e8 c6 ff ff ff       	call   80163b <InitializeUHeap>
	if (size == 0)
  801675:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801679:	75 0a                	jne    801685 <malloc+0x1b>
		return NULL;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	e9 3f 01 00 00       	jmp    8017c4 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801685:	e8 ac 09 00 00       	call   802036 <sys_get_hard_limit>
  80168a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  80168d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801697:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80169c:	c1 e8 0c             	shr    $0xc,%eax
  80169f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8016a2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	48                   	dec    %eax
  8016b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8016b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	f7 75 d8             	divl   -0x28(%ebp)
  8016c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016c3:	29 d0                	sub    %edx,%eax
  8016c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8016c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016cb:	c1 e8 0c             	shr    $0xc,%eax
  8016ce:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8016d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d5:	75 0a                	jne    8016e1 <malloc+0x77>
		return NULL;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	e9 e3 00 00 00       	jmp    8017c4 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8016e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e4:	05 00 00 00 80       	add    $0x80000000,%eax
  8016e9:	c1 e8 0c             	shr    $0xc,%eax
  8016ec:	a3 20 83 80 00       	mov    %eax,0x808320

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016f1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016f8:	77 19                	ja     801713 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  8016fa:	83 ec 0c             	sub    $0xc,%esp
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	e8 44 0b 00 00       	call   802249 <alloc_block_FF>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  80170b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80170e:	e9 b1 00 00 00       	jmp    8017c4 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801716:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801719:	eb 4d                	jmp    801768 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  80171b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171e:	8a 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%al
  801725:	84 c0                	test   %al,%al
  801727:	75 27                	jne    801750 <malloc+0xe6>
			{
				counter++;
  801729:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  80172c:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801730:	75 14                	jne    801746 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801735:	05 00 00 08 00       	add    $0x80000,%eax
  80173a:	c1 e0 0c             	shl    $0xc,%eax
  80173d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801743:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801749:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80174c:	75 17                	jne    801765 <malloc+0xfb>
				{
					break;
  80174e:	eb 21                	jmp    801771 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801753:	8a 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%al
  80175a:	3c 01                	cmp    $0x1,%al
  80175c:	75 07                	jne    801765 <malloc+0xfb>
			{
				counter = 0;
  80175e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801765:	ff 45 e8             	incl   -0x18(%ebp)
  801768:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  80176f:	76 aa                	jbe    80171b <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801774:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801777:	75 46                	jne    8017bf <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801779:	83 ec 08             	sub    $0x8,%esp
  80177c:	ff 75 d0             	pushl  -0x30(%ebp)
  80177f:	ff 75 f4             	pushl  -0xc(%ebp)
  801782:	e8 93 08 00 00       	call   80201a <sys_allocate_user_mem>
  801787:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  80178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801790:	89 14 c5 44 83 80 00 	mov    %edx,0x808344(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80179d:	eb 0e                	jmp    8017ad <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  80179f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a2:	c6 04 c5 40 83 80 00 	movb   $0x1,0x808340(,%eax,8)
  8017a9:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8017aa:	ff 45 e4             	incl   -0x1c(%ebp)
  8017ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017b8:	77 e5                	ja     80179f <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bd:	eb 05                	jmp    8017c4 <malloc+0x15a>
		}
	}

	return NULL;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8017cc:	e8 65 08 00 00       	call   802036 <sys_get_hard_limit>
  8017d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8017da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017de:	0f 84 c1 00 00 00    	je     8018a5 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8017e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	79 1b                	jns    801806 <free+0x40>
  8017eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f1:	73 13                	jae    801806 <free+0x40>
    {
        free_block(virtual_address);
  8017f3:	83 ec 0c             	sub    $0xc,%esp
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	e8 18 10 00 00       	call   802816 <free_block>
  8017fe:	83 c4 10             	add    $0x10,%esp
    	return;
  801801:	e9 a6 00 00 00       	jmp    8018ac <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	05 00 10 00 00       	add    $0x1000,%eax
  80180e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801811:	0f 87 91 00 00 00    	ja     8018a8 <free+0xe2>
  801817:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80181e:	0f 87 84 00 00 00    	ja     8018a8 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801827:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80182a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801832:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801838:	05 00 00 00 80       	add    $0x80000000,%eax
  80183d:	c1 e8 0c             	shr    $0xc,%eax
  801840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801846:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  80184d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801850:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801854:	74 55                	je     8018ab <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801859:	c1 e8 0c             	shr    $0xc,%eax
  80185c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  80185f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801862:	c7 04 c5 44 83 80 00 	movl   $0x0,0x808344(,%eax,8)
  801869:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  80186d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801873:	eb 0e                	jmp    801883 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	c6 04 c5 40 83 80 00 	movb   $0x0,0x808340(,%eax,8)
  80187f:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801880:	ff 45 f4             	incl   -0xc(%ebp)
  801883:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801889:	01 c2                	add    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	77 e3                	ja     801875 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	ff 75 e0             	pushl  -0x20(%ebp)
  801898:	ff 75 ec             	pushl  -0x14(%ebp)
  80189b:	e8 5e 07 00 00       	call   801ffe <sys_free_user_mem>
  8018a0:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8018a3:	eb 07                	jmp    8018ac <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8018a5:	90                   	nop
  8018a6:	eb 04                	jmp    8018ac <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8018a8:	90                   	nop
  8018a9:	eb 01                	jmp    8018ac <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8018ab:	90                   	nop
    else
     {
    	return;
      }

}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 18             	sub    $0x18,%esp
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ba:	e8 7c fd ff ff       	call   80163b <InitializeUHeap>
	if (size == 0)
  8018bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c3:	75 07                	jne    8018cc <smalloc+0x1e>
		return NULL;
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ca:	eb 17                	jmp    8018e3 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	68 30 3c 80 00       	push   $0x803c30
  8018d4:	68 ad 00 00 00       	push   $0xad
  8018d9:	68 56 3c 80 00       	push   $0x803c56
  8018de:	e8 9f ec ff ff       	call   800582 <_panic>
	return NULL;
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018eb:	e8 4b fd ff ff       	call   80163b <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 64 3c 80 00       	push   $0x803c64
  8018f8:	68 ba 00 00 00       	push   $0xba
  8018fd:	68 56 3c 80 00       	push   $0x803c56
  801902:	e8 7b ec ff ff       	call   800582 <_panic>

00801907 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80190d:	e8 29 fd ff ff       	call   80163b <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 88 3c 80 00       	push   $0x803c88
  80191a:	68 d8 00 00 00       	push   $0xd8
  80191f:	68 56 3c 80 00       	push   $0x803c56
  801924:	e8 59 ec ff ff       	call   800582 <_panic>

00801929 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	68 b0 3c 80 00       	push   $0x803cb0
  801937:	68 ea 00 00 00       	push   $0xea
  80193c:	68 56 3c 80 00       	push   $0x803c56
  801941:	e8 3c ec ff ff       	call   800582 <_panic>

00801946 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	68 d4 3c 80 00       	push   $0x803cd4
  801954:	68 f2 00 00 00       	push   $0xf2
  801959:	68 56 3c 80 00       	push   $0x803c56
  80195e:	e8 1f ec ff ff       	call   800582 <_panic>

00801963 <shrink>:

}
void shrink(uint32 newSize) {
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	68 d4 3c 80 00       	push   $0x803cd4
  801971:	68 f6 00 00 00       	push   $0xf6
  801976:	68 56 3c 80 00       	push   $0x803c56
  80197b:	e8 02 ec ff ff       	call   800582 <_panic>

00801980 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	68 d4 3c 80 00       	push   $0x803cd4
  80198e:	68 fa 00 00 00       	push   $0xfa
  801993:	68 56 3c 80 00       	push   $0x803c56
  801998:	e8 e5 eb ff ff       	call   800582 <_panic>

0080199d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	57                   	push   %edi
  8019a1:	56                   	push   %esi
  8019a2:	53                   	push   %ebx
  8019a3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019b5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019b8:	cd 30                	int    $0x30
  8019ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    

008019c8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019d4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	52                   	push   %edx
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	e8 b2 ff ff ff       	call   80199d <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 01                	push   $0x1
  801a00:	e8 98 ff ff ff       	call   80199d <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 05                	push   $0x5
  801a1d:	e8 7b ff ff ff       	call   80199d <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a2c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	51                   	push   %ecx
  801a3e:	52                   	push   %edx
  801a3f:	50                   	push   %eax
  801a40:	6a 06                	push   $0x6
  801a42:	e8 56 ff ff ff       	call   80199d <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 07                	push   $0x7
  801a64:	e8 34 ff ff ff       	call   80199d <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 08                	push   $0x8
  801a7f:	e8 19 ff ff ff       	call   80199d <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 09                	push   $0x9
  801a98:	e8 00 ff ff ff       	call   80199d <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 0a                	push   $0xa
  801ab1:	e8 e7 fe ff ff       	call   80199d <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 0b                	push   $0xb
  801aca:	e8 ce fe ff ff       	call   80199d <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 0c                	push   $0xc
  801ae3:	e8 b5 fe ff ff       	call   80199d <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	6a 0d                	push   $0xd
  801afd:	e8 9b fe ff ff       	call   80199d <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 0e                	push   $0xe
  801b16:	e8 82 fe ff ff       	call   80199d <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 11                	push   $0x11
  801b30:	e8 68 fe ff ff       	call   80199d <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 12                	push   $0x12
  801b4a:	e8 4e fe ff ff       	call   80199d <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	50                   	push   %eax
  801b6e:	6a 13                	push   $0x13
  801b70:	e8 28 fe ff ff       	call   80199d <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	90                   	nop
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 14                	push   $0x14
  801b8a:	e8 0e fe ff ff       	call   80199d <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	6a 15                	push   $0x15
  801ba7:	e8 f1 fd ff ff       	call   80199d <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 18                	push   $0x18
  801bc4:	e8 d4 fd ff ff       	call   80199d <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 16                	push   $0x16
  801be1:	e8 b7 fd ff ff       	call   80199d <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	52                   	push   %edx
  801bfc:	50                   	push   %eax
  801bfd:	6a 17                	push   $0x17
  801bff:	e8 99 fd ff ff       	call   80199d <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	8b 45 10             	mov    0x10(%ebp),%eax
  801c13:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c16:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	51                   	push   %ecx
  801c23:	52                   	push   %edx
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	6a 19                	push   $0x19
  801c2a:	e8 6e fd ff ff       	call   80199d <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	6a 1a                	push   $0x1a
  801c47:	e8 51 fd ff ff       	call   80199d <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	51                   	push   %ecx
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 1b                	push   $0x1b
  801c66:	e8 32 fd ff ff       	call   80199d <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	52                   	push   %edx
  801c80:	50                   	push   %eax
  801c81:	6a 1c                	push   $0x1c
  801c83:	e8 15 fd ff ff       	call   80199d <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 1d                	push   $0x1d
  801c9c:	e8 fc fc ff ff       	call   80199d <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	ff 75 14             	pushl  0x14(%ebp)
  801cb1:	ff 75 10             	pushl  0x10(%ebp)
  801cb4:	ff 75 0c             	pushl  0xc(%ebp)
  801cb7:	50                   	push   %eax
  801cb8:	6a 1e                	push   $0x1e
  801cba:	e8 de fc ff ff       	call   80199d <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	50                   	push   %eax
  801cd3:	6a 1f                	push   $0x1f
  801cd5:	e8 c3 fc ff ff       	call   80199d <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	90                   	nop
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	50                   	push   %eax
  801cef:	6a 20                	push   $0x20
  801cf1:	e8 a7 fc ff ff       	call   80199d <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 02                	push   $0x2
  801d0a:	e8 8e fc ff ff       	call   80199d <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 03                	push   $0x3
  801d23:	e8 75 fc ff ff       	call   80199d <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 04                	push   $0x4
  801d3c:	e8 5c fc ff ff       	call   80199d <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_exit_env>:


void sys_exit_env(void)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 21                	push   $0x21
  801d55:	e8 43 fc ff ff       	call   80199d <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	90                   	nop
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d69:	8d 50 04             	lea    0x4(%eax),%edx
  801d6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	52                   	push   %edx
  801d76:	50                   	push   %eax
  801d77:	6a 22                	push   $0x22
  801d79:	e8 1f fc ff ff       	call   80199d <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return result;
  801d81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d8a:	89 01                	mov    %eax,(%ecx)
  801d8c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	c9                   	leave  
  801d93:	c2 04 00             	ret    $0x4

00801d96 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	ff 75 10             	pushl  0x10(%ebp)
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 10                	push   $0x10
  801da8:	e8 f0 fb ff ff       	call   80199d <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return ;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 23                	push   $0x23
  801dc2:	e8 d6 fb ff ff       	call   80199d <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	50                   	push   %eax
  801de5:	6a 24                	push   $0x24
  801de7:	e8 b1 fb ff ff       	call   80199d <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
	return ;
  801def:	90                   	nop
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <rsttst>:
void rsttst()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 26                	push   $0x26
  801e01:	e8 97 fb ff ff       	call   80199d <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
	return ;
  801e09:	90                   	nop
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	8b 45 14             	mov    0x14(%ebp),%eax
  801e15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e18:	8b 55 18             	mov    0x18(%ebp),%edx
  801e1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	ff 75 10             	pushl  0x10(%ebp)
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	6a 25                	push   $0x25
  801e2c:	e8 6c fb ff ff       	call   80199d <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
	return ;
  801e34:	90                   	nop
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <chktst>:
void chktst(uint32 n)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	6a 27                	push   $0x27
  801e47:	e8 51 fb ff ff       	call   80199d <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4f:	90                   	nop
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <inctst>:

void inctst()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 28                	push   $0x28
  801e61:	e8 37 fb ff ff       	call   80199d <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <gettst>:
uint32 gettst()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 29                	push   $0x29
  801e7b:	e8 1d fb ff ff       	call   80199d <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 2a                	push   $0x2a
  801e97:	e8 01 fb ff ff       	call   80199d <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
  801e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea6:	75 07                	jne    801eaf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ea8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ead:	eb 05                	jmp    801eb4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 2a                	push   $0x2a
  801ec8:	e8 d0 fa ff ff       	call   80199d <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
  801ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ed7:	75 07                	jne    801ee0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ed9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ede:	eb 05                	jmp    801ee5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 2a                	push   $0x2a
  801ef9:	e8 9f fa ff ff       	call   80199d <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
  801f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f04:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f08:	75 07                	jne    801f11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0f:	eb 05                	jmp    801f16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 2a                	push   $0x2a
  801f2a:	e8 6e fa ff ff       	call   80199d <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
  801f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f35:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f39:	75 07                	jne    801f42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f40:	eb 05                	jmp    801f47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	6a 2b                	push   $0x2b
  801f59:	e8 3f fa ff ff       	call   80199d <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f61:	90                   	nop
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	53                   	push   %ebx
  801f77:	51                   	push   %ecx
  801f78:	52                   	push   %edx
  801f79:	50                   	push   %eax
  801f7a:	6a 2c                	push   $0x2c
  801f7c:	e8 1c fa ff ff       	call   80199d <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	52                   	push   %edx
  801f99:	50                   	push   %eax
  801f9a:	6a 2d                	push   $0x2d
  801f9c:	e8 fc f9 ff ff       	call   80199d <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fa9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	51                   	push   %ecx
  801fb5:	ff 75 10             	pushl  0x10(%ebp)
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 2e                	push   $0x2e
  801fbc:	e8 dc f9 ff ff       	call   80199d <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	ff 75 10             	pushl  0x10(%ebp)
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	6a 0f                	push   $0xf
  801fd8:	e8 c0 f9 ff ff       	call   80199d <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe0:	90                   	nop
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	50                   	push   %eax
  801ff2:	6a 2f                	push   $0x2f
  801ff4:	e8 a4 f9 ff ff       	call   80199d <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp

}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	ff 75 0c             	pushl  0xc(%ebp)
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	6a 30                	push   $0x30
  80200f:	e8 89 f9 ff ff       	call   80199d <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
	return;
  802017:	90                   	nop
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	ff 75 08             	pushl  0x8(%ebp)
  802029:	6a 31                	push   $0x31
  80202b:	e8 6d f9 ff ff       	call   80199d <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
	return;
  802033:	90                   	nop
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 32                	push   $0x32
  802045:	e8 53 f9 ff ff       	call   80199d <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	83 e8 10             	sub    $0x10,%eax
  80205b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  80205e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	83 e8 10             	sub    $0x10,%eax
  802071:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802077:	8a 40 04             	mov    0x4(%eax),%al
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802082:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208c:	83 f8 02             	cmp    $0x2,%eax
  80208f:	74 2b                	je     8020bc <alloc_block+0x40>
  802091:	83 f8 02             	cmp    $0x2,%eax
  802094:	7f 07                	jg     80209d <alloc_block+0x21>
  802096:	83 f8 01             	cmp    $0x1,%eax
  802099:	74 0e                	je     8020a9 <alloc_block+0x2d>
  80209b:	eb 58                	jmp    8020f5 <alloc_block+0x79>
  80209d:	83 f8 03             	cmp    $0x3,%eax
  8020a0:	74 2d                	je     8020cf <alloc_block+0x53>
  8020a2:	83 f8 04             	cmp    $0x4,%eax
  8020a5:	74 3b                	je     8020e2 <alloc_block+0x66>
  8020a7:	eb 4c                	jmp    8020f5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	ff 75 08             	pushl  0x8(%ebp)
  8020af:	e8 95 01 00 00       	call   802249 <alloc_block_FF>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ba:	eb 4a                	jmp    802106 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 08             	pushl  0x8(%ebp)
  8020c2:	e8 32 07 00 00       	call   8027f9 <alloc_block_NF>
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020cd:	eb 37                	jmp    802106 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	e8 a3 04 00 00       	call   80257d <alloc_block_BF>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e0:	eb 24                	jmp    802106 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	ff 75 08             	pushl  0x8(%ebp)
  8020e8:	e8 ef 06 00 00       	call   8027dc <alloc_block_WF>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f3:	eb 11                	jmp    802106 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	68 e4 3c 80 00       	push   $0x803ce4
  8020fd:	e8 3d e7 ff ff       	call   80083f <cprintf>
  802102:	83 c4 10             	add    $0x10,%esp
		break;
  802105:	90                   	nop
	}
	return va;
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	68 04 3d 80 00       	push   $0x803d04
  802119:	e8 21 e7 ff ff       	call   80083f <cprintf>
  80211e:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 2f 3d 80 00       	push   $0x803d2f
  802129:	e8 11 e7 ff ff       	call   80083f <cprintf>
  80212e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802137:	eb 26                	jmp    80215f <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8a 40 04             	mov    0x4(%eax),%al
  80213f:	0f b6 d0             	movzbl %al,%edx
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	68 47 3d 80 00       	push   $0x803d47
  802151:	e8 e9 e6 ff ff       	call   80083f <cprintf>
  802156:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802159:	8b 45 10             	mov    0x10(%ebp),%eax
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802163:	74 08                	je     80216d <print_blocks_list+0x62>
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 40 08             	mov    0x8(%eax),%eax
  80216b:	eb 05                	jmp    802172 <print_blocks_list+0x67>
  80216d:	b8 00 00 00 00       	mov    $0x0,%eax
  802172:	89 45 10             	mov    %eax,0x10(%ebp)
  802175:	8b 45 10             	mov    0x10(%ebp),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	75 bd                	jne    802139 <print_blocks_list+0x2e>
  80217c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802180:	75 b7                	jne    802139 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802182:	83 ec 0c             	sub    $0xc,%esp
  802185:	68 04 3d 80 00       	push   $0x803d04
  80218a:	e8 b0 e6 ff ff       	call   80083f <cprintf>
  80218f:	83 c4 10             	add    $0x10,%esp

}
  802192:	90                   	nop
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80219b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80219f:	0f 84 a1 00 00 00    	je     802246 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8021a5:	c7 05 4c 40 80 00 01 	movl   $0x1,0x80404c
  8021ac:	00 00 00 
	LIST_INIT(&list);
  8021af:	c7 05 40 83 90 00 00 	movl   $0x0,0x908340
  8021b6:	00 00 00 
  8021b9:	c7 05 44 83 90 00 00 	movl   $0x0,0x908344
  8021c0:	00 00 00 
  8021c3:	c7 05 4c 83 90 00 00 	movl   $0x0,0x90834c
  8021ca:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e0:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	75 14                	jne    8021fc <initialize_dynamic_allocator+0x67>
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 60 3d 80 00       	push   $0x803d60
  8021f0:	6a 64                	push   $0x64
  8021f2:	68 83 3d 80 00       	push   $0x803d83
  8021f7:	e8 86 e3 ff ff       	call   800582 <_panic>
  8021fc:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	89 50 0c             	mov    %edx,0xc(%eax)
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 40 0c             	mov    0xc(%eax),%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 0d                	je     80221f <initialize_dynamic_allocator+0x8a>
  802212:	a1 44 83 90 00       	mov    0x908344,%eax
  802217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221a:	89 50 08             	mov    %edx,0x8(%eax)
  80221d:	eb 08                	jmp    802227 <initialize_dynamic_allocator+0x92>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	a3 40 83 90 00       	mov    %eax,0x908340
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	a3 44 83 90 00       	mov    %eax,0x908344
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802239:	a1 4c 83 90 00       	mov    0x90834c,%eax
  80223e:	40                   	inc    %eax
  80223f:	a3 4c 83 90 00       	mov    %eax,0x90834c
  802244:	eb 01                	jmp    802247 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802246:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  80224f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802253:	75 0a                	jne    80225f <alloc_block_FF+0x16>
	{
		return NULL;
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
  80225a:	e9 1c 03 00 00       	jmp    80257b <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  80225f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	75 40                	jne    8022a8 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	83 c0 10             	add    $0x10,%eax
  80226e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	50                   	push   %eax
  802278:	e8 d7 f3 ff ff       	call   801654 <sbrk>
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	6a 00                	push   $0x0
  802288:	e8 c7 f3 ff ff       	call   801654 <sbrk>
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802296:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802299:	83 ec 08             	sub    $0x8,%esp
  80229c:	50                   	push   %eax
  80229d:	ff 75 ec             	pushl  -0x14(%ebp)
  8022a0:	e8 f0 fe ff ff       	call   802195 <initialize_dynamic_allocator>
  8022a5:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8022a8:	a1 40 83 90 00       	mov    0x908340,%eax
  8022ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b0:	e9 1e 01 00 00       	jmp    8023d3 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8d 50 10             	lea    0x10(%eax),%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	39 c2                	cmp    %eax,%edx
  8022c2:	75 1c                	jne    8022e0 <alloc_block_FF+0x97>
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8a 40 04             	mov    0x4(%eax),%al
  8022ca:	3c 01                	cmp    $0x1,%al
  8022cc:	75 12                	jne    8022e0 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	83 c0 10             	add    $0x10,%eax
  8022db:	e9 9b 02 00 00       	jmp    80257b <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	8d 50 10             	lea    0x10(%eax),%edx
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	0f 83 d8 00 00 00    	jae    8023cb <alloc_block_FF+0x182>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8a 40 04             	mov    0x4(%eax),%al
  8022f9:	3c 01                	cmp    $0x1,%al
  8022fb:	0f 85 ca 00 00 00    	jne    8023cb <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	2b 45 08             	sub    0x8(%ebp),%eax
  802309:	83 e8 10             	sub    $0x10,%eax
  80230c:	83 f8 0f             	cmp    $0xf,%eax
  80230f:	0f 86 a4 00 00 00    	jbe    8023b9 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	01 d0                	add    %edx,%eax
  80231d:	83 c0 10             	add    $0x10,%eax
  802320:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	2b 45 08             	sub    0x8(%ebp),%eax
  80232b:	8d 50 f0             	lea    -0x10(%eax),%edx
  80232e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802331:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802333:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802336:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	74 06                	je     802346 <alloc_block_FF+0xfd>
  802340:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802344:	75 17                	jne    80235d <alloc_block_FF+0x114>
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	68 9c 3d 80 00       	push   $0x803d9c
  80234e:	68 8f 00 00 00       	push   $0x8f
  802353:	68 83 3d 80 00       	push   $0x803d83
  802358:	e8 25 e2 ff ff       	call   800582 <_panic>
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 50 08             	mov    0x8(%eax),%edx
  802363:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802366:	89 50 08             	mov    %edx,0x8(%eax)
  802369:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80236c:	8b 40 08             	mov    0x8(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 0c                	je     80237f <alloc_block_FF+0x136>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 08             	mov    0x8(%eax),%eax
  802379:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80237c:	89 50 0c             	mov    %edx,0xc(%eax)
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802385:	89 50 08             	mov    %edx,0x8(%eax)
  802388:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80238b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238e:	89 50 0c             	mov    %edx,0xc(%eax)
  802391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802394:	8b 40 08             	mov    0x8(%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	75 08                	jne    8023a3 <alloc_block_FF+0x15a>
  80239b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80239e:	a3 44 83 90 00       	mov    %eax,0x908344
  8023a3:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8023a8:	40                   	inc    %eax
  8023a9:	a3 4c 83 90 00       	mov    %eax,0x90834c
		    iterator->size = size + sizeOfMetaData();
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	8d 50 10             	lea    0x10(%eax),%edx
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	83 c0 10             	add    $0x10,%eax
  8023c6:	e9 b0 01 00 00       	jmp    80257b <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  8023cb:	a1 48 83 90 00       	mov    0x908348,%eax
  8023d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d7:	74 08                	je     8023e1 <alloc_block_FF+0x198>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 08             	mov    0x8(%eax),%eax
  8023df:	eb 05                	jmp    8023e6 <alloc_block_FF+0x19d>
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e6:	a3 48 83 90 00       	mov    %eax,0x908348
  8023eb:	a1 48 83 90 00       	mov    0x908348,%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	0f 85 bd fe ff ff    	jne    8022b5 <alloc_block_FF+0x6c>
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	0f 85 b3 fe ff ff    	jne    8022b5 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	83 c0 10             	add    $0x10,%eax
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	50                   	push   %eax
  80240c:	e8 43 f2 ff ff       	call   801654 <sbrk>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	6a 00                	push   $0x0
  80241c:	e8 33 f2 ff ff       	call   801654 <sbrk>
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242d:	29 c2                	sub    %eax,%edx
  80242f:	89 d0                	mov    %edx,%eax
  802431:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802434:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802438:	0f 84 38 01 00 00    	je     802576 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  80243e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802441:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802444:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802448:	75 17                	jne    802461 <alloc_block_FF+0x218>
  80244a:	83 ec 04             	sub    $0x4,%esp
  80244d:	68 60 3d 80 00       	push   $0x803d60
  802452:	68 9f 00 00 00       	push   $0x9f
  802457:	68 83 3d 80 00       	push   $0x803d83
  80245c:	e8 21 e1 ff ff       	call   800582 <_panic>
  802461:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802467:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80246a:	89 50 0c             	mov    %edx,0xc(%eax)
  80246d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802470:	8b 40 0c             	mov    0xc(%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	74 0d                	je     802484 <alloc_block_FF+0x23b>
  802477:	a1 44 83 90 00       	mov    0x908344,%eax
  80247c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80247f:	89 50 08             	mov    %edx,0x8(%eax)
  802482:	eb 08                	jmp    80248c <alloc_block_FF+0x243>
  802484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802487:	a3 40 83 90 00       	mov    %eax,0x908340
  80248c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80248f:	a3 44 83 90 00       	mov    %eax,0x908344
  802494:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802497:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80249e:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8024a3:	40                   	inc    %eax
  8024a4:	a3 4c 83 90 00       	mov    %eax,0x90834c
			newBlock->size = size + sizeOfMetaData();
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	8d 50 10             	lea    0x10(%eax),%edx
  8024af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b2:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8024b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  8024bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024be:	2b 45 08             	sub    0x8(%ebp),%eax
  8024c1:	83 f8 10             	cmp    $0x10,%eax
  8024c4:	0f 84 a4 00 00 00    	je     80256e <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  8024ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d0:	83 e8 10             	sub    $0x10,%eax
  8024d3:	83 f8 0f             	cmp    $0xf,%eax
  8024d6:	0f 86 8a 00 00 00    	jbe    802566 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  8024dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	01 d0                	add    %edx,%eax
  8024e4:	83 c0 10             	add    $0x10,%eax
  8024e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  8024ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024ee:	75 17                	jne    802507 <alloc_block_FF+0x2be>
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	68 60 3d 80 00       	push   $0x803d60
  8024f8:	68 a7 00 00 00       	push   $0xa7
  8024fd:	68 83 3d 80 00       	push   $0x803d83
  802502:	e8 7b e0 ff ff       	call   800582 <_panic>
  802507:	8b 15 44 83 90 00    	mov    0x908344,%edx
  80250d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802510:	89 50 0c             	mov    %edx,0xc(%eax)
  802513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802516:	8b 40 0c             	mov    0xc(%eax),%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	74 0d                	je     80252a <alloc_block_FF+0x2e1>
  80251d:	a1 44 83 90 00       	mov    0x908344,%eax
  802522:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802525:	89 50 08             	mov    %edx,0x8(%eax)
  802528:	eb 08                	jmp    802532 <alloc_block_FF+0x2e9>
  80252a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252d:	a3 40 83 90 00       	mov    %eax,0x908340
  802532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802535:	a3 44 83 90 00       	mov    %eax,0x908344
  80253a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802544:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802549:	40                   	inc    %eax
  80254a:	a3 4c 83 90 00       	mov    %eax,0x90834c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  80254f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802552:	2b 45 08             	sub    0x8(%ebp),%eax
  802555:	8d 50 f0             	lea    -0x10(%eax),%edx
  802558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80255b:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  80255d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802560:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802564:	eb 08                	jmp    80256e <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802566:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802569:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80256c:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  80256e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802571:	83 c0 10             	add    $0x10,%eax
  802574:	eb 05                	jmp    80257b <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802583:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  80258a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80258e:	75 0a                	jne    80259a <alloc_block_BF+0x1d>
	{
		return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	e9 40 02 00 00       	jmp    8027da <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  80259a:	a1 40 83 90 00       	mov    0x908340,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a2:	eb 66                	jmp    80260a <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8a 40 04             	mov    0x4(%eax),%al
  8025aa:	3c 01                	cmp    $0x1,%al
  8025ac:	75 21                	jne    8025cf <alloc_block_BF+0x52>
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8d 50 10             	lea    0x10(%eax),%edx
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	39 c2                	cmp    %eax,%edx
  8025bb:	75 12                	jne    8025cf <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	83 c0 10             	add    $0x10,%eax
  8025ca:	e9 0b 02 00 00       	jmp    8027da <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8a 40 04             	mov    0x4(%eax),%al
  8025d5:	3c 01                	cmp    $0x1,%al
  8025d7:	75 29                	jne    802602 <alloc_block_BF+0x85>
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8d 50 10             	lea    0x10(%eax),%edx
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	39 c2                	cmp    %eax,%edx
  8025e6:	77 1a                	ja     802602 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8025e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ec:	74 0e                	je     8025fc <alloc_block_BF+0x7f>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 10                	mov    (%eax),%edx
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	39 c2                	cmp    %eax,%edx
  8025fa:	73 06                	jae    802602 <alloc_block_BF+0x85>
			{
				BF = iterator;
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802602:	a1 48 83 90 00       	mov    0x908348,%eax
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	74 08                	je     802618 <alloc_block_BF+0x9b>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 08             	mov    0x8(%eax),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_BF+0xa0>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 48 83 90 00       	mov    %eax,0x908348
  802622:	a1 48 83 90 00       	mov    0x908348,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 85 75 ff ff ff    	jne    8025a4 <alloc_block_BF+0x27>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	0f 85 6b ff ff ff    	jne    8025a4 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263d:	0f 84 f8 00 00 00    	je     80273b <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	8d 50 10             	lea    0x10(%eax),%edx
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	39 c2                	cmp    %eax,%edx
  802650:	0f 87 e5 00 00 00    	ja     80273b <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	2b 45 08             	sub    0x8(%ebp),%eax
  80265e:	83 e8 10             	sub    $0x10,%eax
  802661:	83 f8 0f             	cmp    $0xf,%eax
  802664:	0f 86 bf 00 00 00    	jbe    802729 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  80266a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	01 d0                	add    %edx,%eax
  802672:	83 c0 10             	add    $0x10,%eax
  802675:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	2b 45 08             	sub    0x8(%ebp),%eax
  802689:	8d 50 f0             	lea    -0x10(%eax),%edx
  80268c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268f:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802694:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802698:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80269c:	74 06                	je     8026a4 <alloc_block_BF+0x127>
  80269e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a2:	75 17                	jne    8026bb <alloc_block_BF+0x13e>
  8026a4:	83 ec 04             	sub    $0x4,%esp
  8026a7:	68 9c 3d 80 00       	push   $0x803d9c
  8026ac:	68 e3 00 00 00       	push   $0xe3
  8026b1:	68 83 3d 80 00       	push   $0x803d83
  8026b6:	e8 c7 de ff ff       	call   800582 <_panic>
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	8b 50 08             	mov    0x8(%eax),%edx
  8026c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c4:	89 50 08             	mov    %edx,0x8(%eax)
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	8b 40 08             	mov    0x8(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0c                	je     8026dd <alloc_block_BF+0x160>
  8026d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d4:	8b 40 08             	mov    0x8(%eax),%eax
  8026d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026da:	89 50 0c             	mov    %edx,0xc(%eax)
  8026dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e3:	89 50 08             	mov    %edx,0x8(%eax)
  8026e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ec:	89 50 0c             	mov    %edx,0xc(%eax)
  8026ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f2:	8b 40 08             	mov    0x8(%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	75 08                	jne    802701 <alloc_block_BF+0x184>
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	a3 44 83 90 00       	mov    %eax,0x908344
  802701:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802706:	40                   	inc    %eax
  802707:	a3 4c 83 90 00       	mov    %eax,0x90834c

				BF->size = size + sizeOfMetaData();
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	8d 50 10             	lea    0x10(%eax),%edx
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	83 c0 10             	add    $0x10,%eax
  802724:	e9 b1 00 00 00       	jmp    8027da <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	83 c0 10             	add    $0x10,%eax
  802736:	e9 9f 00 00 00       	jmp    8027da <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	83 c0 10             	add    $0x10,%eax
  802741:	83 ec 0c             	sub    $0xc,%esp
  802744:	50                   	push   %eax
  802745:	e8 0a ef ff ff       	call   801654 <sbrk>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802750:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802754:	74 7f                	je     8027d5 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802756:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275a:	75 17                	jne    802773 <alloc_block_BF+0x1f6>
  80275c:	83 ec 04             	sub    $0x4,%esp
  80275f:	68 60 3d 80 00       	push   $0x803d60
  802764:	68 f6 00 00 00       	push   $0xf6
  802769:	68 83 3d 80 00       	push   $0x803d83
  80276e:	e8 0f de ff ff       	call   800582 <_panic>
  802773:	8b 15 44 83 90 00    	mov    0x908344,%edx
  802779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277c:	89 50 0c             	mov    %edx,0xc(%eax)
  80277f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802782:	8b 40 0c             	mov    0xc(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0d                	je     802796 <alloc_block_BF+0x219>
  802789:	a1 44 83 90 00       	mov    0x908344,%eax
  80278e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802791:	89 50 08             	mov    %edx,0x8(%eax)
  802794:	eb 08                	jmp    80279e <alloc_block_BF+0x221>
  802796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802799:	a3 40 83 90 00       	mov    %eax,0x908340
  80279e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a1:	a3 44 83 90 00       	mov    %eax,0x908344
  8027a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027b0:	a1 4c 83 90 00       	mov    0x90834c,%eax
  8027b5:	40                   	inc    %eax
  8027b6:	a3 4c 83 90 00       	mov    %eax,0x90834c
		newBlock->size = size + sizeOfMetaData();
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	8d 50 10             	lea    0x10(%eax),%edx
  8027c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c4:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8027c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8027cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d0:	83 c0 10             	add    $0x10,%eax
  8027d3:	eb 05                	jmp    8027da <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 d0 3d 80 00       	push   $0x803dd0
  8027ea:	68 07 01 00 00       	push   $0x107
  8027ef:	68 83 3d 80 00       	push   $0x803d83
  8027f4:	e8 89 dd ff ff       	call   800582 <_panic>

008027f9 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	68 f8 3d 80 00       	push   $0x803df8
  802807:	68 0f 01 00 00       	push   $0x10f
  80280c:	68 83 3d 80 00       	push   $0x803d83
  802811:	e8 6c dd ff ff       	call   800582 <_panic>

00802816 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  80281c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802820:	0f 84 ee 05 00 00    	je     802e14 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	83 e8 10             	sub    $0x10,%eax
  80282c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  80282f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802833:	a1 40 83 90 00       	mov    0x908340,%eax
  802838:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80283b:	eb 16                	jmp    802853 <free_block+0x3d>
	{
		if (block_pointer == it)
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802843:	75 06                	jne    80284b <free_block+0x35>
		{
			flagx = 1;
  802845:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802849:	eb 2f                	jmp    80287a <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80284b:	a1 48 83 90 00       	mov    0x908348,%eax
  802850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802857:	74 08                	je     802861 <free_block+0x4b>
  802859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285c:	8b 40 08             	mov    0x8(%eax),%eax
  80285f:	eb 05                	jmp    802866 <free_block+0x50>
  802861:	b8 00 00 00 00       	mov    $0x0,%eax
  802866:	a3 48 83 90 00       	mov    %eax,0x908348
  80286b:	a1 48 83 90 00       	mov    0x908348,%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	75 c9                	jne    80283d <free_block+0x27>
  802874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802878:	75 c3                	jne    80283d <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  80287a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80287e:	0f 84 93 05 00 00    	je     802e17 <free_block+0x601>
		return;
	if (va == NULL)
  802884:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802888:	0f 84 8c 05 00 00    	je     802e1a <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  80288e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802891:	8b 40 0c             	mov    0xc(%eax),%eax
  802894:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289a:	8b 40 08             	mov    0x8(%eax),%eax
  80289d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8028a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a4:	75 12                	jne    8028b8 <free_block+0xa2>
  8028a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028aa:	75 0c                	jne    8028b8 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8028b3:	e9 63 05 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8028b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028bc:	0f 85 ca 00 00 00    	jne    80298c <free_block+0x176>
  8028c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c5:	8a 40 04             	mov    0x4(%eax),%al
  8028c8:	3c 01                	cmp    $0x1,%al
  8028ca:	0f 85 bc 00 00 00    	jne    80298c <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8028d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028da:	8b 10                	mov    (%eax),%edx
  8028dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	01 c2                	add    %eax,%edx
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8028e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8028f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8028f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028fc:	75 17                	jne    802915 <free_block+0xff>
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 1e 3e 80 00       	push   $0x803e1e
  802906:	68 3c 01 00 00       	push   $0x13c
  80290b:	68 83 3d 80 00       	push   $0x803d83
  802910:	e8 6d dc ff ff       	call   800582 <_panic>
  802915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802918:	8b 40 08             	mov    0x8(%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 11                	je     802930 <free_block+0x11a>
  80291f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802922:	8b 40 08             	mov    0x8(%eax),%eax
  802925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802928:	8b 52 0c             	mov    0xc(%edx),%edx
  80292b:	89 50 0c             	mov    %edx,0xc(%eax)
  80292e:	eb 0b                	jmp    80293b <free_block+0x125>
  802930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802933:	8b 40 0c             	mov    0xc(%eax),%eax
  802936:	a3 44 83 90 00       	mov    %eax,0x908344
  80293b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 11                	je     802956 <free_block+0x140>
  802945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294e:	8b 52 08             	mov    0x8(%edx),%edx
  802951:	89 50 08             	mov    %edx,0x8(%eax)
  802954:	eb 0b                	jmp    802961 <free_block+0x14b>
  802956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802959:	8b 40 08             	mov    0x8(%eax),%eax
  80295c:	a3 40 83 90 00       	mov    %eax,0x908340
  802961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802964:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80296b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802975:	a1 4c 83 90 00       	mov    0x90834c,%eax
  80297a:	48                   	dec    %eax
  80297b:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  802980:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802987:	e9 8f 04 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  80298c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802990:	75 16                	jne    8029a8 <free_block+0x192>
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	8a 40 04             	mov    0x4(%eax),%al
  802998:	84 c0                	test   %al,%al
  80299a:	75 0c                	jne    8029a8 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  80299c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8029a3:	e9 73 04 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8029a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029ac:	0f 85 c3 00 00 00    	jne    802a75 <free_block+0x25f>
  8029b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b5:	8a 40 04             	mov    0x4(%eax),%al
  8029b8:	3c 01                	cmp    $0x1,%al
  8029ba:	0f 85 b5 00 00 00    	jne    802a75 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8029c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c3:	8b 10                	mov    (%eax),%edx
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	01 c2                	add    %eax,%edx
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8029d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8029da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dd:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8029e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e5:	75 17                	jne    8029fe <free_block+0x1e8>
  8029e7:	83 ec 04             	sub    $0x4,%esp
  8029ea:	68 1e 3e 80 00       	push   $0x803e1e
  8029ef:	68 49 01 00 00       	push   $0x149
  8029f4:	68 83 3d 80 00       	push   $0x803d83
  8029f9:	e8 84 db ff ff       	call   800582 <_panic>
  8029fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a01:	8b 40 08             	mov    0x8(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 11                	je     802a19 <free_block+0x203>
  802a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0b:	8b 40 08             	mov    0x8(%eax),%eax
  802a0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a11:	8b 52 0c             	mov    0xc(%edx),%edx
  802a14:	89 50 0c             	mov    %edx,0xc(%eax)
  802a17:	eb 0b                	jmp    802a24 <free_block+0x20e>
  802a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1f:	a3 44 83 90 00       	mov    %eax,0x908344
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 11                	je     802a3f <free_block+0x229>
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a37:	8b 52 08             	mov    0x8(%edx),%edx
  802a3a:	89 50 08             	mov    %edx,0x8(%eax)
  802a3d:	eb 0b                	jmp    802a4a <free_block+0x234>
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	8b 40 08             	mov    0x8(%eax),%eax
  802a45:	a3 40 83 90 00       	mov    %eax,0x908340
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a5e:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802a63:	48                   	dec    %eax
  802a64:	a3 4c 83 90 00       	mov    %eax,0x90834c
		block_pointer = 0;
  802a69:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802a70:	e9 a6 03 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802a75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a79:	75 16                	jne    802a91 <free_block+0x27b>
  802a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7e:	8a 40 04             	mov    0x4(%eax),%al
  802a81:	84 c0                	test   %al,%al
  802a83:	75 0c                	jne    802a91 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802a8c:	e9 8a 03 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802a91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a95:	0f 84 81 01 00 00    	je     802c1c <free_block+0x406>
  802a9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a9f:	0f 84 77 01 00 00    	je     802c1c <free_block+0x406>
  802aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa8:	8a 40 04             	mov    0x4(%eax),%al
  802aab:	3c 01                	cmp    $0x1,%al
  802aad:	0f 85 69 01 00 00    	jne    802c1c <free_block+0x406>
  802ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab6:	8a 40 04             	mov    0x4(%eax),%al
  802ab9:	3c 01                	cmp    $0x1,%al
  802abb:	0f 85 5b 01 00 00    	jne    802c1c <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac4:	8b 10                	mov    (%eax),%edx
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 08                	mov    (%eax),%ecx
  802acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	01 c8                	add    %ecx,%eax
  802ad2:	01 c2                	add    %eax,%edx
  802ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad7:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802af9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802afd:	75 17                	jne    802b16 <free_block+0x300>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 1e 3e 80 00       	push   $0x803e1e
  802b07:	68 59 01 00 00       	push   $0x159
  802b0c:	68 83 3d 80 00       	push   $0x803d83
  802b11:	e8 6c da ff ff       	call   800582 <_panic>
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	8b 40 08             	mov    0x8(%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 11                	je     802b31 <free_block+0x31b>
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b29:	8b 52 0c             	mov    0xc(%edx),%edx
  802b2c:	89 50 0c             	mov    %edx,0xc(%eax)
  802b2f:	eb 0b                	jmp    802b3c <free_block+0x326>
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	a3 44 83 90 00       	mov    %eax,0x908344
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 11                	je     802b57 <free_block+0x341>
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4f:	8b 52 08             	mov    0x8(%edx),%edx
  802b52:	89 50 08             	mov    %edx,0x8(%eax)
  802b55:	eb 0b                	jmp    802b62 <free_block+0x34c>
  802b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5a:	8b 40 08             	mov    0x8(%eax),%eax
  802b5d:	a3 40 83 90 00       	mov    %eax,0x908340
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b76:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802b7b:	48                   	dec    %eax
  802b7c:	a3 4c 83 90 00       	mov    %eax,0x90834c
		LIST_REMOVE(&list, next_block);
  802b81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b85:	75 17                	jne    802b9e <free_block+0x388>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 1e 3e 80 00       	push   $0x803e1e
  802b8f:	68 5a 01 00 00       	push   $0x15a
  802b94:	68 83 3d 80 00       	push   $0x803d83
  802b99:	e8 e4 d9 ff ff       	call   800582 <_panic>
  802b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba1:	8b 40 08             	mov    0x8(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 11                	je     802bb9 <free_block+0x3a3>
  802ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bb1:	8b 52 0c             	mov    0xc(%edx),%edx
  802bb4:	89 50 0c             	mov    %edx,0xc(%eax)
  802bb7:	eb 0b                	jmp    802bc4 <free_block+0x3ae>
  802bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbf:	a3 44 83 90 00       	mov    %eax,0x908344
  802bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 11                	je     802bdf <free_block+0x3c9>
  802bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bd7:	8b 52 08             	mov    0x8(%edx),%edx
  802bda:	89 50 08             	mov    %edx,0x8(%eax)
  802bdd:	eb 0b                	jmp    802bea <free_block+0x3d4>
  802bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	a3 40 83 90 00       	mov    %eax,0x908340
  802bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802bfe:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802c03:	48                   	dec    %eax
  802c04:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  802c09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802c10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802c17:	e9 ff 01 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802c1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c20:	0f 84 db 00 00 00    	je     802d01 <free_block+0x4eb>
  802c26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c2a:	0f 84 d1 00 00 00    	je     802d01 <free_block+0x4eb>
  802c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c33:	8a 40 04             	mov    0x4(%eax),%al
  802c36:	84 c0                	test   %al,%al
  802c38:	0f 85 c3 00 00 00    	jne    802d01 <free_block+0x4eb>
  802c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c41:	8a 40 04             	mov    0x4(%eax),%al
  802c44:	3c 01                	cmp    $0x1,%al
  802c46:	0f 85 b5 00 00 00    	jne    802d01 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4f:	8b 10                	mov    (%eax),%edx
  802c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	01 c2                	add    %eax,%edx
  802c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5b:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802c6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c71:	75 17                	jne    802c8a <free_block+0x474>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 1e 3e 80 00       	push   $0x803e1e
  802c7b:	68 64 01 00 00       	push   $0x164
  802c80:	68 83 3d 80 00       	push   $0x803d83
  802c85:	e8 f8 d8 ff ff       	call   800582 <_panic>
  802c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8d:	8b 40 08             	mov    0x8(%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 11                	je     802ca5 <free_block+0x48f>
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c9d:	8b 52 0c             	mov    0xc(%edx),%edx
  802ca0:	89 50 0c             	mov    %edx,0xc(%eax)
  802ca3:	eb 0b                	jmp    802cb0 <free_block+0x49a>
  802ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cab:	a3 44 83 90 00       	mov    %eax,0x908344
  802cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 11                	je     802ccb <free_block+0x4b5>
  802cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc3:	8b 52 08             	mov    0x8(%edx),%edx
  802cc6:	89 50 08             	mov    %edx,0x8(%eax)
  802cc9:	eb 0b                	jmp    802cd6 <free_block+0x4c0>
  802ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cce:	8b 40 08             	mov    0x8(%eax),%eax
  802cd1:	a3 40 83 90 00       	mov    %eax,0x908340
  802cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cea:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802cef:	48                   	dec    %eax
  802cf0:	a3 4c 83 90 00       	mov    %eax,0x90834c
		block_pointer = 0;
  802cf5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802cfc:	e9 1a 01 00 00       	jmp    802e1b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802d01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d05:	0f 84 df 00 00 00    	je     802dea <free_block+0x5d4>
  802d0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d0f:	0f 84 d5 00 00 00    	je     802dea <free_block+0x5d4>
  802d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d18:	8a 40 04             	mov    0x4(%eax),%al
  802d1b:	3c 01                	cmp    $0x1,%al
  802d1d:	0f 85 c7 00 00 00    	jne    802dea <free_block+0x5d4>
  802d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d26:	8a 40 04             	mov    0x4(%eax),%al
  802d29:	84 c0                	test   %al,%al
  802d2b:	0f 85 b9 00 00 00    	jne    802dea <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	8b 10                	mov    (%eax),%edx
  802d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	01 c2                	add    %eax,%edx
  802d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d47:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802d52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d55:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802d59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d5d:	75 17                	jne    802d76 <free_block+0x560>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 1e 3e 80 00       	push   $0x803e1e
  802d67:	68 6e 01 00 00       	push   $0x16e
  802d6c:	68 83 3d 80 00       	push   $0x803d83
  802d71:	e8 0c d8 ff ff       	call   800582 <_panic>
  802d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d79:	8b 40 08             	mov    0x8(%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 11                	je     802d91 <free_block+0x57b>
  802d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d89:	8b 52 0c             	mov    0xc(%edx),%edx
  802d8c:	89 50 0c             	mov    %edx,0xc(%eax)
  802d8f:	eb 0b                	jmp    802d9c <free_block+0x586>
  802d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	a3 44 83 90 00       	mov    %eax,0x908344
  802d9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 11                	je     802db7 <free_block+0x5a1>
  802da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802daf:	8b 52 08             	mov    0x8(%edx),%edx
  802db2:	89 50 08             	mov    %edx,0x8(%eax)
  802db5:	eb 0b                	jmp    802dc2 <free_block+0x5ac>
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	8b 40 08             	mov    0x8(%eax),%eax
  802dbd:	a3 40 83 90 00       	mov    %eax,0x908340
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802dd6:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802ddb:	48                   	dec    %eax
  802ddc:	a3 4c 83 90 00       	mov    %eax,0x90834c
		next_block = 0;
  802de1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802de8:	eb 31                	jmp    802e1b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802dea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dee:	74 2b                	je     802e1b <free_block+0x605>
  802df0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802df4:	74 25                	je     802e1b <free_block+0x605>
  802df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df9:	8a 40 04             	mov    0x4(%eax),%al
  802dfc:	84 c0                	test   %al,%al
  802dfe:	75 1b                	jne    802e1b <free_block+0x605>
  802e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e03:	8a 40 04             	mov    0x4(%eax),%al
  802e06:	84 c0                	test   %al,%al
  802e08:	75 11                	jne    802e1b <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e11:	90                   	nop
  802e12:	eb 07                	jmp    802e1b <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802e14:	90                   	nop
  802e15:	eb 04                	jmp    802e1b <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802e17:	90                   	nop
  802e18:	eb 01                	jmp    802e1b <free_block+0x605>
	if (va == NULL)
		return;
  802e1a:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    

00802e1d <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802e1d:	55                   	push   %ebp
  802e1e:	89 e5                	mov    %esp,%ebp
  802e20:	57                   	push   %edi
  802e21:	56                   	push   %esi
  802e22:	53                   	push   %ebx
  802e23:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2a:	75 19                	jne    802e45 <realloc_block_FF+0x28>
  802e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e30:	74 13                	je     802e45 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	ff 75 0c             	pushl  0xc(%ebp)
  802e38:	e8 0c f4 ff ff       	call   802249 <alloc_block_FF>
  802e3d:	83 c4 10             	add    $0x10,%esp
  802e40:	e9 84 03 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  802e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e49:	75 3b                	jne    802e86 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802e4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4f:	75 17                	jne    802e68 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  802e51:	83 ec 0c             	sub    $0xc,%esp
  802e54:	6a 00                	push   $0x0
  802e56:	e8 ee f3 ff ff       	call   802249 <alloc_block_FF>
  802e5b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e63:	e9 61 03 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  802e68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6c:	74 18                	je     802e86 <realloc_block_FF+0x69>
		{
			free_block(va);
  802e6e:	83 ec 0c             	sub    $0xc,%esp
  802e71:	ff 75 08             	pushl  0x8(%ebp)
  802e74:	e8 9d f9 ff ff       	call   802816 <free_block>
  802e79:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e81:	e9 43 03 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  802e86:	a1 40 83 90 00       	mov    0x908340,%eax
  802e8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802e8e:	e9 02 03 00 00       	jmp    803195 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	83 e8 10             	sub    $0x10,%eax
  802e99:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e9c:	0f 85 eb 02 00 00    	jne    80318d <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaa:	83 c2 10             	add    $0x10,%edx
  802ead:	39 d0                	cmp    %edx,%eax
  802eaf:	75 08                	jne    802eb9 <realloc_block_FF+0x9c>
			{
				return va;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	e9 10 03 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  802eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ec1:	0f 83 e0 01 00 00    	jae    8030a7 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  802ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  802ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed3:	8a 40 04             	mov    0x4(%eax),%al
  802ed6:	3c 01                	cmp    $0x1,%al
  802ed8:	0f 85 06 01 00 00    	jne    802fe4 <realloc_block_FF+0x1c7>
  802ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee1:	8b 10                	mov    (%eax),%edx
  802ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802eeb:	29 c1                	sub    %eax,%ecx
  802eed:	89 c8                	mov    %ecx,%eax
  802eef:	39 c2                	cmp    %eax,%edx
  802ef1:	0f 86 ed 00 00 00    	jbe    802fe4 <realloc_block_FF+0x1c7>
  802ef7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802efb:	0f 84 e3 00 00 00    	je     802fe4 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  802f01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f04:	8b 10                	mov    (%eax),%edx
  802f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f0e:	01 d0                	add    %edx,%eax
  802f10:	83 f8 0f             	cmp    $0xf,%eax
  802f13:	0f 86 b5 00 00 00    	jbe    802fce <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  802f19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1f:	01 d0                	add    %edx,%eax
  802f21:	83 c0 10             	add    $0x10,%eax
  802f24:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  802f27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  802f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f33:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802f37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f3b:	74 06                	je     802f43 <realloc_block_FF+0x126>
  802f3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f41:	75 17                	jne    802f5a <realloc_block_FF+0x13d>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 9c 3d 80 00       	push   $0x803d9c
  802f4b:	68 ad 01 00 00       	push   $0x1ad
  802f50:	68 83 3d 80 00       	push   $0x803d83
  802f55:	e8 28 d6 ff ff       	call   800582 <_panic>
  802f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5d:	8b 50 08             	mov    0x8(%eax),%edx
  802f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f63:	89 50 08             	mov    %edx,0x8(%eax)
  802f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0c                	je     802f7c <realloc_block_FF+0x15f>
  802f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f73:	8b 40 08             	mov    0x8(%eax),%eax
  802f76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f79:	89 50 0c             	mov    %edx,0xc(%eax)
  802f7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f82:	89 50 08             	mov    %edx,0x8(%eax)
  802f85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f8b:	89 50 0c             	mov    %edx,0xc(%eax)
  802f8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f91:	8b 40 08             	mov    0x8(%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	75 08                	jne    802fa0 <realloc_block_FF+0x183>
  802f98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9b:	a3 44 83 90 00       	mov    %eax,0x908344
  802fa0:	a1 4c 83 90 00       	mov    0x90834c,%eax
  802fa5:	40                   	inc    %eax
  802fa6:	a3 4c 83 90 00       	mov    %eax,0x90834c
						next->size = 0;
  802fab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  802fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  802fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbe:	8d 50 10             	lea    0x10(%eax),%edx
  802fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc4:	89 10                	mov    %edx,(%eax)
						return va;
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	e9 fb 01 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	8d 50 10             	lea    0x10(%eax),%edx
  802fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd7:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  802fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdc:	83 c0 10             	add    $0x10,%eax
  802fdf:	e9 e5 01 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  802fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe7:	8a 40 04             	mov    0x4(%eax),%al
  802fea:	3c 01                	cmp    $0x1,%al
  802fec:	75 59                	jne    803047 <realloc_block_FF+0x22a>
  802fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff1:	8b 10                	mov    (%eax),%edx
  802ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ffb:	29 c1                	sub    %eax,%ecx
  802ffd:	89 c8                	mov    %ecx,%eax
  802fff:	39 c2                	cmp    %eax,%edx
  803001:	75 44                	jne    803047 <realloc_block_FF+0x22a>
  803003:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803007:	74 3e                	je     803047 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803009:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300c:	8b 40 08             	mov    0x8(%eax),%eax
  80300f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803015:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803018:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  80301b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80301e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803021:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803027:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  80302d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803030:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803034:	8b 45 0c             	mov    0xc(%ebp),%eax
  803037:	8d 50 10             	lea    0x10(%eax),%edx
  80303a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303d:	89 10                	mov    %edx,(%eax)
					return va;
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	e9 82 01 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803047:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304a:	8a 40 04             	mov    0x4(%eax),%al
  80304d:	84 c0                	test   %al,%al
  80304f:	74 0a                	je     80305b <realloc_block_FF+0x23e>
  803051:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803055:	0f 85 32 01 00 00    	jne    80318d <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80305b:	83 ec 0c             	sub    $0xc,%esp
  80305e:	ff 75 0c             	pushl  0xc(%ebp)
  803061:	e8 e3 f1 ff ff       	call   802249 <alloc_block_FF>
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  80306c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803070:	74 2b                	je     80309d <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803072:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	89 c3                	mov    %eax,%ebx
  80307a:	b8 04 00 00 00       	mov    $0x4,%eax
  80307f:	89 d7                	mov    %edx,%edi
  803081:	89 de                	mov    %ebx,%esi
  803083:	89 c1                	mov    %eax,%ecx
  803085:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  803087:	83 ec 0c             	sub    $0xc,%esp
  80308a:	ff 75 08             	pushl  0x8(%ebp)
  80308d:	e8 84 f7 ff ff       	call   802816 <free_block>
  803092:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803095:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803098:	e9 2c 01 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  80309d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8030a2:	e9 22 01 00 00       	jmp    8031c9 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8030a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030af:	0f 86 d8 00 00 00    	jbe    80318d <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8030b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030bd:	83 f8 0f             	cmp    $0xf,%eax
  8030c0:	0f 86 b4 00 00 00    	jbe    80317a <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  8030c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030cc:	01 d0                	add    %edx,%eax
  8030ce:	83 c0 10             	add    $0x10,%eax
  8030d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030dc:	8d 50 f0             	lea    -0x10(%eax),%edx
  8030df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030e2:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8030e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030e8:	74 06                	je     8030f0 <realloc_block_FF+0x2d3>
  8030ea:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8030ee:	75 17                	jne    803107 <realloc_block_FF+0x2ea>
  8030f0:	83 ec 04             	sub    $0x4,%esp
  8030f3:	68 9c 3d 80 00       	push   $0x803d9c
  8030f8:	68 dd 01 00 00       	push   $0x1dd
  8030fd:	68 83 3d 80 00       	push   $0x803d83
  803102:	e8 7b d4 ff ff       	call   800582 <_panic>
  803107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310a:	8b 50 08             	mov    0x8(%eax),%edx
  80310d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803110:	89 50 08             	mov    %edx,0x8(%eax)
  803113:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0c                	je     803129 <realloc_block_FF+0x30c>
  80311d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803120:	8b 40 08             	mov    0x8(%eax),%eax
  803123:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803126:	89 50 0c             	mov    %edx,0xc(%eax)
  803129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80312f:	89 50 08             	mov    %edx,0x8(%eax)
  803132:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803135:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803138:	89 50 0c             	mov    %edx,0xc(%eax)
  80313b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80313e:	8b 40 08             	mov    0x8(%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	75 08                	jne    80314d <realloc_block_FF+0x330>
  803145:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803148:	a3 44 83 90 00       	mov    %eax,0x908344
  80314d:	a1 4c 83 90 00       	mov    0x90834c,%eax
  803152:	40                   	inc    %eax
  803153:	a3 4c 83 90 00       	mov    %eax,0x90834c
					free_block((void*) (newBlockAfterSplit + 1));
  803158:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80315b:	83 c0 10             	add    $0x10,%eax
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	50                   	push   %eax
  803162:	e8 af f6 ff ff       	call   802816 <free_block>
  803167:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  80316a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316d:	8d 50 10             	lea    0x10(%eax),%edx
  803170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803173:	89 10                	mov    %edx,(%eax)
					return va;
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	eb 4f                	jmp    8031c9 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80317a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317d:	8d 50 10             	lea    0x10(%eax),%edx
  803180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803183:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	83 c0 10             	add    $0x10,%eax
  80318b:	eb 3c                	jmp    8031c9 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  80318d:	a1 48 83 90 00       	mov    0x908348,%eax
  803192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803195:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803199:	74 08                	je     8031a3 <realloc_block_FF+0x386>
  80319b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319e:	8b 40 08             	mov    0x8(%eax),%eax
  8031a1:	eb 05                	jmp    8031a8 <realloc_block_FF+0x38b>
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a8:	a3 48 83 90 00       	mov    %eax,0x908348
  8031ad:	a1 48 83 90 00       	mov    0x908348,%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	0f 85 d9 fc ff ff    	jne    802e93 <realloc_block_FF+0x76>
  8031ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031be:	0f 85 cf fc ff ff    	jne    802e93 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8031c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	66 90                	xchg   %ax,%ax
  8031d3:	90                   	nop

008031d4 <__udivdi3>:
  8031d4:	55                   	push   %ebp
  8031d5:	57                   	push   %edi
  8031d6:	56                   	push   %esi
  8031d7:	53                   	push   %ebx
  8031d8:	83 ec 1c             	sub    $0x1c,%esp
  8031db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031eb:	89 ca                	mov    %ecx,%edx
  8031ed:	89 f8                	mov    %edi,%eax
  8031ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031f3:	85 f6                	test   %esi,%esi
  8031f5:	75 2d                	jne    803224 <__udivdi3+0x50>
  8031f7:	39 cf                	cmp    %ecx,%edi
  8031f9:	77 65                	ja     803260 <__udivdi3+0x8c>
  8031fb:	89 fd                	mov    %edi,%ebp
  8031fd:	85 ff                	test   %edi,%edi
  8031ff:	75 0b                	jne    80320c <__udivdi3+0x38>
  803201:	b8 01 00 00 00       	mov    $0x1,%eax
  803206:	31 d2                	xor    %edx,%edx
  803208:	f7 f7                	div    %edi
  80320a:	89 c5                	mov    %eax,%ebp
  80320c:	31 d2                	xor    %edx,%edx
  80320e:	89 c8                	mov    %ecx,%eax
  803210:	f7 f5                	div    %ebp
  803212:	89 c1                	mov    %eax,%ecx
  803214:	89 d8                	mov    %ebx,%eax
  803216:	f7 f5                	div    %ebp
  803218:	89 cf                	mov    %ecx,%edi
  80321a:	89 fa                	mov    %edi,%edx
  80321c:	83 c4 1c             	add    $0x1c,%esp
  80321f:	5b                   	pop    %ebx
  803220:	5e                   	pop    %esi
  803221:	5f                   	pop    %edi
  803222:	5d                   	pop    %ebp
  803223:	c3                   	ret    
  803224:	39 ce                	cmp    %ecx,%esi
  803226:	77 28                	ja     803250 <__udivdi3+0x7c>
  803228:	0f bd fe             	bsr    %esi,%edi
  80322b:	83 f7 1f             	xor    $0x1f,%edi
  80322e:	75 40                	jne    803270 <__udivdi3+0x9c>
  803230:	39 ce                	cmp    %ecx,%esi
  803232:	72 0a                	jb     80323e <__udivdi3+0x6a>
  803234:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803238:	0f 87 9e 00 00 00    	ja     8032dc <__udivdi3+0x108>
  80323e:	b8 01 00 00 00       	mov    $0x1,%eax
  803243:	89 fa                	mov    %edi,%edx
  803245:	83 c4 1c             	add    $0x1c,%esp
  803248:	5b                   	pop    %ebx
  803249:	5e                   	pop    %esi
  80324a:	5f                   	pop    %edi
  80324b:	5d                   	pop    %ebp
  80324c:	c3                   	ret    
  80324d:	8d 76 00             	lea    0x0(%esi),%esi
  803250:	31 ff                	xor    %edi,%edi
  803252:	31 c0                	xor    %eax,%eax
  803254:	89 fa                	mov    %edi,%edx
  803256:	83 c4 1c             	add    $0x1c,%esp
  803259:	5b                   	pop    %ebx
  80325a:	5e                   	pop    %esi
  80325b:	5f                   	pop    %edi
  80325c:	5d                   	pop    %ebp
  80325d:	c3                   	ret    
  80325e:	66 90                	xchg   %ax,%ax
  803260:	89 d8                	mov    %ebx,%eax
  803262:	f7 f7                	div    %edi
  803264:	31 ff                	xor    %edi,%edi
  803266:	89 fa                	mov    %edi,%edx
  803268:	83 c4 1c             	add    $0x1c,%esp
  80326b:	5b                   	pop    %ebx
  80326c:	5e                   	pop    %esi
  80326d:	5f                   	pop    %edi
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    
  803270:	bd 20 00 00 00       	mov    $0x20,%ebp
  803275:	89 eb                	mov    %ebp,%ebx
  803277:	29 fb                	sub    %edi,%ebx
  803279:	89 f9                	mov    %edi,%ecx
  80327b:	d3 e6                	shl    %cl,%esi
  80327d:	89 c5                	mov    %eax,%ebp
  80327f:	88 d9                	mov    %bl,%cl
  803281:	d3 ed                	shr    %cl,%ebp
  803283:	89 e9                	mov    %ebp,%ecx
  803285:	09 f1                	or     %esi,%ecx
  803287:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80328b:	89 f9                	mov    %edi,%ecx
  80328d:	d3 e0                	shl    %cl,%eax
  80328f:	89 c5                	mov    %eax,%ebp
  803291:	89 d6                	mov    %edx,%esi
  803293:	88 d9                	mov    %bl,%cl
  803295:	d3 ee                	shr    %cl,%esi
  803297:	89 f9                	mov    %edi,%ecx
  803299:	d3 e2                	shl    %cl,%edx
  80329b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329f:	88 d9                	mov    %bl,%cl
  8032a1:	d3 e8                	shr    %cl,%eax
  8032a3:	09 c2                	or     %eax,%edx
  8032a5:	89 d0                	mov    %edx,%eax
  8032a7:	89 f2                	mov    %esi,%edx
  8032a9:	f7 74 24 0c          	divl   0xc(%esp)
  8032ad:	89 d6                	mov    %edx,%esi
  8032af:	89 c3                	mov    %eax,%ebx
  8032b1:	f7 e5                	mul    %ebp
  8032b3:	39 d6                	cmp    %edx,%esi
  8032b5:	72 19                	jb     8032d0 <__udivdi3+0xfc>
  8032b7:	74 0b                	je     8032c4 <__udivdi3+0xf0>
  8032b9:	89 d8                	mov    %ebx,%eax
  8032bb:	31 ff                	xor    %edi,%edi
  8032bd:	e9 58 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032c2:	66 90                	xchg   %ax,%ax
  8032c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032c8:	89 f9                	mov    %edi,%ecx
  8032ca:	d3 e2                	shl    %cl,%edx
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	73 e9                	jae    8032b9 <__udivdi3+0xe5>
  8032d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032d3:	31 ff                	xor    %edi,%edi
  8032d5:	e9 40 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	31 c0                	xor    %eax,%eax
  8032de:	e9 37 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032e3:	90                   	nop

008032e4 <__umoddi3>:
  8032e4:	55                   	push   %ebp
  8032e5:	57                   	push   %edi
  8032e6:	56                   	push   %esi
  8032e7:	53                   	push   %ebx
  8032e8:	83 ec 1c             	sub    $0x1c,%esp
  8032eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803303:	89 f3                	mov    %esi,%ebx
  803305:	89 fa                	mov    %edi,%edx
  803307:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80330b:	89 34 24             	mov    %esi,(%esp)
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 1a                	jne    80332c <__umoddi3+0x48>
  803312:	39 f7                	cmp    %esi,%edi
  803314:	0f 86 a2 00 00 00    	jbe    8033bc <__umoddi3+0xd8>
  80331a:	89 c8                	mov    %ecx,%eax
  80331c:	89 f2                	mov    %esi,%edx
  80331e:	f7 f7                	div    %edi
  803320:	89 d0                	mov    %edx,%eax
  803322:	31 d2                	xor    %edx,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	39 f0                	cmp    %esi,%eax
  80332e:	0f 87 ac 00 00 00    	ja     8033e0 <__umoddi3+0xfc>
  803334:	0f bd e8             	bsr    %eax,%ebp
  803337:	83 f5 1f             	xor    $0x1f,%ebp
  80333a:	0f 84 ac 00 00 00    	je     8033ec <__umoddi3+0x108>
  803340:	bf 20 00 00 00       	mov    $0x20,%edi
  803345:	29 ef                	sub    %ebp,%edi
  803347:	89 fe                	mov    %edi,%esi
  803349:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80334d:	89 e9                	mov    %ebp,%ecx
  80334f:	d3 e0                	shl    %cl,%eax
  803351:	89 d7                	mov    %edx,%edi
  803353:	89 f1                	mov    %esi,%ecx
  803355:	d3 ef                	shr    %cl,%edi
  803357:	09 c7                	or     %eax,%edi
  803359:	89 e9                	mov    %ebp,%ecx
  80335b:	d3 e2                	shl    %cl,%edx
  80335d:	89 14 24             	mov    %edx,(%esp)
  803360:	89 d8                	mov    %ebx,%eax
  803362:	d3 e0                	shl    %cl,%eax
  803364:	89 c2                	mov    %eax,%edx
  803366:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336a:	d3 e0                	shl    %cl,%eax
  80336c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803370:	8b 44 24 08          	mov    0x8(%esp),%eax
  803374:	89 f1                	mov    %esi,%ecx
  803376:	d3 e8                	shr    %cl,%eax
  803378:	09 d0                	or     %edx,%eax
  80337a:	d3 eb                	shr    %cl,%ebx
  80337c:	89 da                	mov    %ebx,%edx
  80337e:	f7 f7                	div    %edi
  803380:	89 d3                	mov    %edx,%ebx
  803382:	f7 24 24             	mull   (%esp)
  803385:	89 c6                	mov    %eax,%esi
  803387:	89 d1                	mov    %edx,%ecx
  803389:	39 d3                	cmp    %edx,%ebx
  80338b:	0f 82 87 00 00 00    	jb     803418 <__umoddi3+0x134>
  803391:	0f 84 91 00 00 00    	je     803428 <__umoddi3+0x144>
  803397:	8b 54 24 04          	mov    0x4(%esp),%edx
  80339b:	29 f2                	sub    %esi,%edx
  80339d:	19 cb                	sbb    %ecx,%ebx
  80339f:	89 d8                	mov    %ebx,%eax
  8033a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033a5:	d3 e0                	shl    %cl,%eax
  8033a7:	89 e9                	mov    %ebp,%ecx
  8033a9:	d3 ea                	shr    %cl,%edx
  8033ab:	09 d0                	or     %edx,%eax
  8033ad:	89 e9                	mov    %ebp,%ecx
  8033af:	d3 eb                	shr    %cl,%ebx
  8033b1:	89 da                	mov    %ebx,%edx
  8033b3:	83 c4 1c             	add    $0x1c,%esp
  8033b6:	5b                   	pop    %ebx
  8033b7:	5e                   	pop    %esi
  8033b8:	5f                   	pop    %edi
  8033b9:	5d                   	pop    %ebp
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop
  8033bc:	89 fd                	mov    %edi,%ebp
  8033be:	85 ff                	test   %edi,%edi
  8033c0:	75 0b                	jne    8033cd <__umoddi3+0xe9>
  8033c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c7:	31 d2                	xor    %edx,%edx
  8033c9:	f7 f7                	div    %edi
  8033cb:	89 c5                	mov    %eax,%ebp
  8033cd:	89 f0                	mov    %esi,%eax
  8033cf:	31 d2                	xor    %edx,%edx
  8033d1:	f7 f5                	div    %ebp
  8033d3:	89 c8                	mov    %ecx,%eax
  8033d5:	f7 f5                	div    %ebp
  8033d7:	89 d0                	mov    %edx,%eax
  8033d9:	e9 44 ff ff ff       	jmp    803322 <__umoddi3+0x3e>
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	89 c8                	mov    %ecx,%eax
  8033e2:	89 f2                	mov    %esi,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	3b 04 24             	cmp    (%esp),%eax
  8033ef:	72 06                	jb     8033f7 <__umoddi3+0x113>
  8033f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033f5:	77 0f                	ja     803406 <__umoddi3+0x122>
  8033f7:	89 f2                	mov    %esi,%edx
  8033f9:	29 f9                	sub    %edi,%ecx
  8033fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033ff:	89 14 24             	mov    %edx,(%esp)
  803402:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803406:	8b 44 24 04          	mov    0x4(%esp),%eax
  80340a:	8b 14 24             	mov    (%esp),%edx
  80340d:	83 c4 1c             	add    $0x1c,%esp
  803410:	5b                   	pop    %ebx
  803411:	5e                   	pop    %esi
  803412:	5f                   	pop    %edi
  803413:	5d                   	pop    %ebp
  803414:	c3                   	ret    
  803415:	8d 76 00             	lea    0x0(%esi),%esi
  803418:	2b 04 24             	sub    (%esp),%eax
  80341b:	19 fa                	sbb    %edi,%edx
  80341d:	89 d1                	mov    %edx,%ecx
  80341f:	89 c6                	mov    %eax,%esi
  803421:	e9 71 ff ff ff       	jmp    803397 <__umoddi3+0xb3>
  803426:	66 90                	xchg   %ax,%ax
  803428:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80342c:	72 ea                	jb     803418 <__umoddi3+0x134>
  80342e:	89 d9                	mov    %ebx,%ecx
  803430:	e9 62 ff ff ff       	jmp    803397 <__umoddi3+0xb3>
