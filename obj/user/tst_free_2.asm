
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 28 0d 00 00       	call   800d5e <libmain>
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
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800042:	83 ec 0c             	sub    $0xc,%esp
  800045:	6a 01                	push   $0x1
  800047:	e8 05 28 00 00       	call   802851 <sys_set_uheap_strategy>
  80004c:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004f:	a1 40 60 80 00       	mov    0x806040,%eax
  800054:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80005a:	a1 40 60 80 00       	mov    0x806040,%eax
  80005f:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800065:	39 c2                	cmp    %eax,%edx
  800067:	72 14                	jb     80007d <_main+0x45>
			panic("Please increase the WS size");
  800069:	83 ec 04             	sub    $0x4,%esp
  80006c:	68 c0 3d 80 00       	push   $0x803dc0
  800071:	6a 22                	push   $0x22
  800073:	68 dc 3d 80 00       	push   $0x803ddc
  800078:	e8 0f 0e 00 00       	call   800e8c <_panic>
	}
	/*=================================================*/

	int eval = 0;
  80007d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800084:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80008b:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  800092:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800099:	e8 3e 23 00 00       	call   8023dc <sys_pf_calculate_allocated_pages>
  80009e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000a1:	e8 eb 22 00 00       	call   802391 <sys_calculate_free_frames>
  8000a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 actualSize, block_size, expectedSize, blockIndex;
	int8 block_status;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 f0 3d 80 00       	push   $0x803df0
  8000b1:	e8 93 10 00 00       	call   801149 <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000c0:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ce:	e9 e7 00 00 00       	jmp    8001ba <_main+0x182>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000da:	e9 cb 00 00 00       	jmp    8001aa <_main+0x172>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8000e9:	83 e8 10             	sub    $0x10,%eax
  8000ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx++] = malloc(actualSize);
  8000ef:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000f2:	8d 43 01             	lea    0x1(%ebx),%eax
  8000f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	ff 75 bc             	pushl  -0x44(%ebp)
  8000fe:	e8 6f 1e 00 00       	call   801f72 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 04 9d 20 61 80 00 	mov    %eax,0x806120(,%ebx,4)
  80010d:	8b 04 9d 20 61 80 00 	mov    0x806120(,%ebx,4),%eax
  800114:	89 45 b8             	mov    %eax,-0x48(%ebp)
				//				if (j == 0)
				//					cprintf("first va of size %x = %x\n",allocSizes[i], va);

				//Check returned va
				if(va == NULL || (va < curVA))
  800117:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80011b:	74 08                	je     800125 <_main+0xed>
  80011d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800120:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800123:	73 2e                	jae    800153 <_main+0x11b>
				{
					if (is_correct)
  800125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800129:	74 28                	je     800153 <_main+0x11b>
					{
						is_correct = 0;
  80012b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
						panic("malloc() #0.%d: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	83 c0 10             	add    $0x10,%eax
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	ff 75 b8             	pushl  -0x48(%ebp)
  80013e:	50                   	push   %eax
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	68 48 3e 80 00       	push   $0x803e48
  800147:	6a 47                	push   $0x47
  800149:	68 dc 3d 80 00       	push   $0x803ddc
  80014e:	e8 39 0d 00 00       	call   800e8c <_panic>
					}
				}
				curVA += allocSizes[i] ;
  800153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800156:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  80015d:	01 45 e8             	add    %eax,-0x18(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800160:	c7 45 b4 00 10 00 00 	movl   $0x1000,-0x4c(%ebp)
  800167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80016a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80016d:	01 d0                	add    %edx,%eax
  80016f:	48                   	dec    %eax
  800170:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800173:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800176:	ba 00 00 00 00       	mov    $0x0,%edx
  80017b:	f7 75 b4             	divl   -0x4c(%ebp)
  80017e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800181:	29 d0                	sub    %edx,%eax
  800183:	89 45 ac             	mov    %eax,-0x54(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800186:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018c:	29 c2                	sub    %eax,%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  800193:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  800197:	7e 0e                	jle    8001a7 <_main+0x16f>
  800199:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80019c:	83 f8 0f             	cmp    $0xf,%eax
  80019f:	77 06                	ja     8001a7 <_main+0x16f>
				{
					curVA = rounded_curVA;
  8001a1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001a7:	ff 45 e0             	incl   -0x20(%ebp)
  8001aa:	81 7d e0 c7 00 00 00 	cmpl   $0xc7,-0x20(%ebp)
  8001b1:	0f 8e 28 ff ff ff    	jle    8000df <_main+0xa7>
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001b7:	ff 45 e4             	incl   -0x1c(%ebp)
  8001ba:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001be:	0f 8e 0f ff ff ff    	jle    8000d3 <_main+0x9b>
			//if (is_correct == 0)
			//break;
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  8001c4:	e8 c8 21 00 00       	call   802391 <sys_calculate_free_frames>
  8001c9:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 a4 3e 80 00       	push   $0x803ea4
  8001d4:	e8 70 0f 00 00       	call   801149 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8001dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8001e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ea:	eb 2c                	jmp    800218 <_main+0x1e0>
		{
			free(startVAs[i*allocCntPerSize]);
  8001ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001ef:	89 d0                	mov    %edx,%eax
  8001f1:	c1 e0 02             	shl    $0x2,%eax
  8001f4:	01 d0                	add    %edx,%eax
  8001f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fd:	01 d0                	add    %edx,%eax
  8001ff:	c1 e0 03             	shl    $0x3,%eax
  800202:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	50                   	push   %eax
  80020d:	e8 bc 1e 00 00       	call   8020ce <free>
  800212:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  800215:	ff 45 dc             	incl   -0x24(%ebp)
  800218:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  80021c:	7e ce                	jle    8001ec <_main+0x1b4>
		{
			free(startVAs[i*allocCntPerSize]);
		}

		//Free block before last
		free(startVAs[numOfAllocs*allocCntPerSize - 2]);
  80021e:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	50                   	push   %eax
  800227:	e8 a2 1e 00 00       	call   8020ce <free>
  80022c:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[numOfAllocs*allocCntPerSize - 2]) ;
  80022f:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	50                   	push   %eax
  800238:	e8 36 27 00 00       	call   802973 <get_block_size>
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (block_size != allocSizes[numOfAllocs-1])
  800243:	a1 18 60 80 00       	mov    0x806018,%eax
  800248:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80024b:	74 20                	je     80026d <_main+0x235>
		{
			is_correct = 0;
  80024d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",allocSizes[numOfAllocs-1],block_size);
  800254:	a1 18 60 80 00       	mov    0x806018,%eax
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80025f:	50                   	push   %eax
  800260:	68 ec 3e 80 00       	push   $0x803eec
  800265:	e8 df 0e 00 00       	call   801149 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[numOfAllocs*allocCntPerSize-2]) ;
  80026d:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	50                   	push   %eax
  800276:	e8 0e 27 00 00       	call   802989 <is_free_block>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800281:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800285:	74 17                	je     80029e <_main+0x266>
		{
			is_correct = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	68 48 3f 80 00       	push   $0x803f48
  800296:	e8 ae 0e 00 00       	call   801149 <cprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
		}

		//Reallocate first block
		actualSize = allocSizes[0] - sizeOfMetaData();
  80029e:	a1 00 60 80 00       	mov    0x806000,%eax
  8002a3:	83 e8 10             	sub    $0x10,%eax
  8002a6:	89 45 9c             	mov    %eax,-0x64(%ebp)
		va = malloc(actualSize);
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	ff 75 9c             	pushl  -0x64(%ebp)
  8002af:	e8 be 1c 00 00       	call   801f72 <malloc>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		if(va == NULL || (va != (void*)(USER_HEAP_START + sizeOfMetaData())))
  8002ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8002be:	74 09                	je     8002c9 <_main+0x291>
  8002c0:	81 7d b8 10 00 00 80 	cmpl   $0x80000010,-0x48(%ebp)
  8002c7:	74 17                	je     8002e0 <_main+0x2a8>
		{
			is_correct = 0;
  8002c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.3: WRONG ALLOC - alloc_block_FF return wrong address.\n");
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 9c 3f 80 00       	push   $0x803f9c
  8002d8:	e8 6c 0e 00 00       	call   801149 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
		}

		//Free 2nd block
		free(startVAs[1]);
  8002e0:	a1 24 61 80 00       	mov    0x806124,%eax
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	e8 e0 1d 00 00       	call   8020ce <free>
  8002ee:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[1]) ;
  8002f1:	a1 24 61 80 00       	mov    0x806124,%eax
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	50                   	push   %eax
  8002fa:	e8 74 26 00 00       	call   802973 <get_block_size>
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (block_size != allocSizes[0])
  800305:	a1 00 60 80 00       	mov    0x806000,%eax
  80030a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80030d:	74 20                	je     80032f <_main+0x2f7>
		{
			is_correct = 0;
  80030f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.4: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",allocSizes[0],block_size);
  800316:	a1 00 60 80 00       	mov    0x806000,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	ff 75 a4             	pushl  -0x5c(%ebp)
  800321:	50                   	push   %eax
  800322:	68 e4 3f 80 00       	push   $0x803fe4
  800327:	e8 1d 0e 00 00       	call   801149 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[1]) ;
  80032f:	a1 24 61 80 00       	mov    0x806124,%eax
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	e8 4c 26 00 00       	call   802989 <is_free_block>
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800343:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800347:	74 17                	je     800360 <_main+0x328>
		{
			is_correct = 0;
  800349:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.5: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 40 40 80 00       	push   $0x804040
  800358:	e8 ec 0d 00 00       	call   801149 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800364:	74 04                	je     80036a <_main+0x332>
		{
			eval += 10;
  800366:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*free Scenario 2: Merge with previous ONLY (AT the tail)*/
	cprintf("2: Free some allocated blocks [Merge with previous ONLY]\n\n") ;
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 94 40 80 00       	push   $0x804094
  800372:	e8 d2 0d 00 00       	call   801149 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	68 cf 40 80 00       	push   $0x8040cf
  800382:	e8 c2 0d 00 00       	call   801149 <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  80038a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last block (coalesce with previous)
		blockIndex = numOfAllocs*allocCntPerSize-1;
  800391:	c7 45 98 77 05 00 00 	movl   $0x577,-0x68(%ebp)
		free(startVAs[blockIndex]);
  800398:	8b 45 98             	mov    -0x68(%ebp),%eax
  80039b:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	50                   	push   %eax
  8003a6:	e8 23 1d 00 00       	call   8020ce <free>
  8003ab:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8003ae:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003b1:	48                   	dec    %eax
  8003b2:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	50                   	push   %eax
  8003bd:	e8 b1 25 00 00       	call   802973 <get_block_size>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = 2*allocSizes[numOfAllocs-1];
  8003c8:	a1 18 60 80 00       	mov    0x806018,%eax
  8003cd:	01 c0                	add    %eax,%eax
  8003cf:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8003d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d5:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8003d8:	74 1d                	je     8003f7 <_main+0x3bf>
		{
			is_correct = 0;
  8003da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n", expectedSize,block_size);
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003e7:	ff 75 94             	pushl  -0x6c(%ebp)
  8003ea:	68 e4 40 80 00       	push   $0x8040e4
  8003ef:	e8 55 0d 00 00       	call   801149 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8003f7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003fa:	48                   	dec    %eax
  8003fb:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	50                   	push   %eax
  800406:	e8 7e 25 00 00       	call   802989 <is_free_block>
  80040b:	83 c4 10             	add    $0x10,%esp
  80040e:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800411:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800415:	74 17                	je     80042e <_main+0x3f6>
		{
			is_correct = 0;
  800417:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80041e:	83 ec 0c             	sub    $0xc,%esp
  800421:	68 44 41 80 00       	push   $0x804144
  800426:	e8 1e 0d 00 00       	call   801149 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80042e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800431:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	50                   	push   %eax
  80043c:	e8 32 25 00 00       	call   802973 <get_block_size>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	85 c0                	test   %eax,%eax
  800446:	75 1a                	jne    800462 <_main+0x42a>
  800448:	8b 45 98             	mov    -0x68(%ebp),%eax
  80044b:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800452:	83 ec 0c             	sub    $0xc,%esp
  800455:	50                   	push   %eax
  800456:	e8 2e 25 00 00       	call   802989 <is_free_block>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	84 c0                	test   %al,%al
  800460:	74 17                	je     800479 <_main+0x441>
		{
			is_correct = 0;
  800462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	68 98 41 80 00       	push   $0x804198
  800471:	e8 d3 0c 00 00       	call   801149 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	68 00 42 80 00       	push   $0x804200
  800481:	e8 c3 0c 00 00       	call   801149 <cprintf>
  800486:	83 c4 10             	add    $0x10,%esp
		blockIndex = 2*allocCntPerSize+1 ;
  800489:	c7 45 98 91 01 00 00 	movl   $0x191,-0x68(%ebp)
		free(startVAs[blockIndex]);
  800490:	8b 45 98             	mov    -0x68(%ebp),%eax
  800493:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	50                   	push   %eax
  80049e:	e8 2b 1c 00 00       	call   8020ce <free>
  8004a3:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8004a6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004a9:	48                   	dec    %eax
  8004aa:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	50                   	push   %eax
  8004b5:	e8 b9 24 00 00       	call   802973 <get_block_size>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[2]+allocSizes[2];
  8004c0:	8b 15 08 60 80 00    	mov    0x806008,%edx
  8004c6:	a1 08 60 80 00       	mov    0x806008,%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8004d0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004d3:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8004d6:	74 1d                	je     8004f5 <_main+0x4bd>
		{
			is_correct = 0;
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #2.2.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8004e5:	ff 75 94             	pushl  -0x6c(%ebp)
  8004e8:	68 1c 42 80 00       	push   $0x80421c
  8004ed:	e8 57 0c 00 00       	call   801149 <cprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8004f5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004f8:	48                   	dec    %eax
  8004f9:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	50                   	push   %eax
  800504:	e8 80 24 00 00       	call   802989 <is_free_block>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80050f:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800513:	74 17                	je     80052c <_main+0x4f4>
		{
			is_correct = 0;
  800515:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.2.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80051c:	83 ec 0c             	sub    $0xc,%esp
  80051f:	68 7c 42 80 00       	push   $0x80427c
  800524:	e8 20 0c 00 00       	call   801149 <cprintf>
  800529:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80052c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80052f:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	50                   	push   %eax
  80053a:	e8 34 24 00 00       	call   802973 <get_block_size>
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 c0                	test   %eax,%eax
  800544:	75 1a                	jne    800560 <_main+0x528>
  800546:	8b 45 98             	mov    -0x68(%ebp),%eax
  800549:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 30 24 00 00       	call   802989 <is_free_block>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	84 c0                	test   %al,%al
  80055e:	74 17                	je     800577 <_main+0x53f>
		{
			is_correct = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	68 d0 42 80 00       	push   $0x8042d0
  80056f:	e8 d5 0b 00 00       	call   801149 <cprintf>
  800574:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80057b:	74 04                	je     800581 <_main+0x549>
		{
			eval += 10;
  80057d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}


	//====================================================================//
	/*free Scenario 4: Merge with next ONLY (AT the head)*/
	cprintf("3: Free some allocated blocks [Merge with next ONLY]\n\n") ;
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	68 38 43 80 00       	push   $0x804338
  800589:	e8 bb 0b 00 00       	call   801149 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	68 6f 43 80 00       	push   $0x80436f
  800599:	e8 ab 0b 00 00       	call   801149 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8005a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		blockIndex = 0 ;
  8005a8:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8005af:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b2:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8005b9:	83 ec 0c             	sub    $0xc,%esp
  8005bc:	50                   	push   %eax
  8005bd:	e8 0c 1b 00 00       	call   8020ce <free>
  8005c2:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8005c5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005c8:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	50                   	push   %eax
  8005d3:	e8 9b 23 00 00       	call   802973 <get_block_size>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[0]+allocSizes[0];
  8005de:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8005e4:	a1 00 60 80 00       	mov    0x806000,%eax
  8005e9:	01 d0                	add    %edx,%eax
  8005eb:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8005ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8005f1:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8005f4:	74 1d                	je     800613 <_main+0x5db>
		{
			is_correct = 0;
  8005f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #3.1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8005fd:	83 ec 04             	sub    $0x4,%esp
  800600:	ff 75 a4             	pushl  -0x5c(%ebp)
  800603:	ff 75 94             	pushl  -0x6c(%ebp)
  800606:	68 84 43 80 00       	push   $0x804384
  80060b:	e8 39 0b 00 00       	call   801149 <cprintf>
  800610:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800613:	8b 45 98             	mov    -0x68(%ebp),%eax
  800616:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80061d:	83 ec 0c             	sub    $0xc,%esp
  800620:	50                   	push   %eax
  800621:	e8 63 23 00 00       	call   802989 <is_free_block>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80062c:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800630:	74 17                	je     800649 <_main+0x611>
		{
			is_correct = 0;
  800632:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	68 e4 43 80 00       	push   $0x8043e4
  800641:	e8 03 0b 00 00       	call   801149 <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800649:	8b 45 98             	mov    -0x68(%ebp),%eax
  80064c:	40                   	inc    %eax
  80064d:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	50                   	push   %eax
  800658:	e8 16 23 00 00       	call   802973 <get_block_size>
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	85 c0                	test   %eax,%eax
  800662:	75 1b                	jne    80067f <_main+0x647>
  800664:	8b 45 98             	mov    -0x68(%ebp),%eax
  800667:	40                   	inc    %eax
  800668:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	e8 11 23 00 00       	call   802989 <is_free_block>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	84 c0                	test   %al,%al
  80067d:	74 17                	je     800696 <_main+0x65e>
		{
			is_correct = 0;
  80067f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800686:	83 ec 0c             	sub    $0xc,%esp
  800689:	68 38 44 80 00       	push   $0x804438
  80068e:	e8 b6 0a 00 00       	call   801149 <cprintf>
  800693:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	68 a0 44 80 00       	push   $0x8044a0
  80069e:	e8 a6 0a 00 00       	call   801149 <cprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
		blockIndex = 1*allocCntPerSize - 1 ;
  8006a6:	c7 45 98 c7 00 00 00 	movl   $0xc7,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8006ad:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006b0:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	50                   	push   %eax
  8006bb:	e8 0e 1a 00 00       	call   8020ce <free>
  8006c0:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8006c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006c6:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	50                   	push   %eax
  8006d1:	e8 9d 22 00 00       	call   802973 <get_block_size>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[0]+allocSizes[1];
  8006dc:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8006e2:	a1 04 60 80 00       	mov    0x806004,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8006ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006ef:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8006f2:	74 1d                	je     800711 <_main+0x6d9>
		{
			is_correct = 0;
  8006f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #3.2.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	ff 75 a4             	pushl  -0x5c(%ebp)
  800701:	ff 75 94             	pushl  -0x6c(%ebp)
  800704:	68 bc 44 80 00       	push   $0x8044bc
  800709:	e8 3b 0a 00 00       	call   801149 <cprintf>
  80070e:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800711:	8b 45 98             	mov    -0x68(%ebp),%eax
  800714:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	50                   	push   %eax
  80071f:	e8 65 22 00 00       	call   802989 <is_free_block>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80072a:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  80072e:	74 17                	je     800747 <_main+0x70f>
		{
			is_correct = 0;
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.2.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	68 1c 45 80 00       	push   $0x80451c
  80073f:	e8 05 0a 00 00       	call   801149 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800747:	8b 45 98             	mov    -0x68(%ebp),%eax
  80074a:	40                   	inc    %eax
  80074b:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 18 22 00 00       	call   802973 <get_block_size>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	75 1b                	jne    80077d <_main+0x745>
  800762:	8b 45 98             	mov    -0x68(%ebp),%eax
  800765:	40                   	inc    %eax
  800766:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	50                   	push   %eax
  800771:	e8 13 22 00 00       	call   802989 <is_free_block>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	84 c0                	test   %al,%al
  80077b:	74 17                	je     800794 <_main+0x75c>
		{
			is_correct = 0;
  80077d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	68 70 45 80 00       	push   $0x804570
  80078c:	e8 b8 09 00 00       	call   801149 <cprintf>
  800791:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800798:	74 04                	je     80079e <_main+0x766>
		{
			eval += 10;
  80079a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}
	//====================================================================//
	/*free Scenario 6: Merge with prev & next */
	cprintf("4: Free some allocated blocks [Merge with previous & next]\n\n") ;
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	68 d8 45 80 00       	push   $0x8045d8
  8007a6:	e8 9e 09 00 00       	call   801149 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8007ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		blockIndex = 4*allocCntPerSize - 2 ;
  8007b5:	c7 45 98 1e 03 00 00 	movl   $0x31e,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8007bc:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007bf:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8007c6:	83 ec 0c             	sub    $0xc,%esp
  8007c9:	50                   	push   %eax
  8007ca:	e8 ff 18 00 00       	call   8020ce <free>
  8007cf:	83 c4 10             	add    $0x10,%esp

		blockIndex = 4*allocCntPerSize - 1 ;
  8007d2:	c7 45 98 1f 03 00 00 	movl   $0x31f,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8007d9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007dc:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	50                   	push   %eax
  8007e7:	e8 e2 18 00 00       	call   8020ce <free>
  8007ec:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8007ef:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007f2:	48                   	dec    %eax
  8007f3:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 70 21 00 00       	call   802973 <get_block_size>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[3]+allocSizes[3]+allocSizes[4];
  800809:	8b 15 0c 60 80 00    	mov    0x80600c,%edx
  80080f:	a1 0c 60 80 00       	mov    0x80600c,%eax
  800814:	01 c2                	add    %eax,%edx
  800816:	a1 10 60 80 00       	mov    0x806010,%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  800820:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800823:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  800826:	74 1d                	je     800845 <_main+0x80d>
		{
			is_correct = 0;
  800828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #4.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 a4             	pushl  -0x5c(%ebp)
  800835:	ff 75 94             	pushl  -0x6c(%ebp)
  800838:	68 18 46 80 00       	push   $0x804618
  80083d:	e8 07 09 00 00       	call   801149 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  800845:	8b 45 98             	mov    -0x68(%ebp),%eax
  800848:	48                   	dec    %eax
  800849:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800850:	83 ec 0c             	sub    $0xc,%esp
  800853:	50                   	push   %eax
  800854:	e8 30 21 00 00       	call   802989 <is_free_block>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80085f:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800863:	74 17                	je     80087c <_main+0x844>
		{
			is_correct = 0;
  800865:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #4.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80086c:	83 ec 0c             	sub    $0xc,%esp
  80086f:	68 74 46 80 00       	push   $0x804674
  800874:	e8 d0 08 00 00       	call   801149 <cprintf>
  800879:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0 ||
  80087c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80087f:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	50                   	push   %eax
  80088a:	e8 e4 20 00 00       	call   802973 <get_block_size>
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	85 c0                	test   %eax,%eax
  800894:	75 50                	jne    8008e6 <_main+0x8ae>
  800896:	8b 45 98             	mov    -0x68(%ebp),%eax
  800899:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	50                   	push   %eax
  8008a4:	e8 e0 20 00 00       	call   802989 <is_free_block>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	84 c0                	test   %al,%al
  8008ae:	75 36                	jne    8008e6 <_main+0x8ae>
				get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  8008b0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008b3:	40                   	inc    %eax
  8008b4:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 af 20 00 00       	call   802973 <get_block_size>
  8008c4:	83 c4 10             	add    $0x10,%esp
		if (block_status != 1)
		{
			is_correct = 0;
			cprintf("test_free_2 #4.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
		}
		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0 ||
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	75 1b                	jne    8008e6 <_main+0x8ae>
				get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  8008cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008ce:	40                   	inc    %eax
  8008cf:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	50                   	push   %eax
  8008da:	e8 aa 20 00 00       	call   802989 <is_free_block>
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	84 c0                	test   %al,%al
  8008e4:	74 17                	je     8008fd <_main+0x8c5>
		{
			is_correct = 0;
  8008e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #4.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  8008ed:	83 ec 0c             	sub    $0xc,%esp
  8008f0:	68 c8 46 80 00       	push   $0x8046c8
  8008f5:	e8 4f 08 00 00       	call   801149 <cprintf>
  8008fa:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800901:	74 04                	je     800907 <_main+0x8cf>
		{
			eval += 20;
  800903:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}


	//====================================================================//
	/*Allocate After Free Scenarios */
	cprintf("5: Allocate After Free [should be placed in coalesced blocks]\n\n") ;
  800907:	83 ec 0c             	sub    $0xc,%esp
  80090a:	68 30 47 80 00       	push   $0x804730
  80090f:	e8 35 08 00 00       	call   801149 <cprintf>
  800914:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  800917:	83 ec 0c             	sub    $0xc,%esp
  80091a:	68 70 47 80 00       	push   $0x804770
  80091f:	e8 25 08 00 00       	call   801149 <cprintf>
  800924:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800927:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 4*sizeof(int);
  80092e:	c7 45 9c 10 00 00 00 	movl   $0x10,-0x64(%ebp)
		va = malloc(actualSize);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	ff 75 9c             	pushl  -0x64(%ebp)
  80093b:	e8 32 16 00 00       	call   801f72 <malloc>
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		void* expected = (void*)(USER_HEAP_START + sizeOfMetaData());
  800946:	c7 45 90 10 00 00 80 	movl   $0x80000010,-0x70(%ebp)
		if(va == NULL || (va != expected))
  80094d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800951:	74 08                	je     80095b <_main+0x923>
  800953:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800956:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800959:	74 1d                	je     800978 <_main+0x940>
		{
			is_correct = 0;
  80095b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.1: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	ff 75 b8             	pushl  -0x48(%ebp)
  800968:	ff 75 90             	pushl  -0x70(%ebp)
  80096b:	68 98 47 80 00       	push   $0x804798
  800970:	e8 d4 07 00 00       	call   801149 <cprintf>
  800975:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 2*sizeof(int) ;
  800978:	c7 45 9c 08 00 00 00 	movl   $0x8,-0x64(%ebp)
		va = malloc(actualSize);
  80097f:	83 ec 0c             	sub    $0xc,%esp
  800982:	ff 75 9c             	pushl  -0x64(%ebp)
  800985:	e8 e8 15 00 00       	call   801f72 <malloc>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = (void*)(USER_HEAP_START + sizeOfMetaData() + 4*sizeof(int) + sizeOfMetaData());
  800990:	c7 45 90 30 00 00 80 	movl   $0x80000030,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800997:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80099b:	74 08                	je     8009a5 <_main+0x96d>
  80099d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009a0:	3b 45 90             	cmp    -0x70(%ebp),%eax
  8009a3:	74 1d                	je     8009c2 <_main+0x98a>
		{
			is_correct = 0;
  8009a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	ff 75 b8             	pushl  -0x48(%ebp)
  8009b2:	ff 75 90             	pushl  -0x70(%ebp)
  8009b5:	68 f8 47 80 00       	push   $0x8047f8
  8009ba:	e8 8a 07 00 00       	call   801149 <cprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 5*sizeof(int);
  8009c2:	c7 45 9c 14 00 00 00 	movl   $0x14,-0x64(%ebp)
		va = malloc(actualSize);
  8009c9:	83 ec 0c             	sub    $0xc,%esp
  8009cc:	ff 75 9c             	pushl  -0x64(%ebp)
  8009cf:	e8 9e 15 00 00       	call   801f72 <malloc>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[1*allocCntPerSize - 1];
  8009da:	a1 3c 64 80 00       	mov    0x80643c,%eax
  8009df:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  8009e2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8009e6:	74 08                	je     8009f0 <_main+0x9b8>
  8009e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009eb:	3b 45 90             	cmp    -0x70(%ebp),%eax
  8009ee:	74 1d                	je     800a0d <_main+0x9d5>
		{
			is_correct = 0;
  8009f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.3: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  8009f7:	83 ec 04             	sub    $0x4,%esp
  8009fa:	ff 75 b8             	pushl  -0x48(%ebp)
  8009fd:	ff 75 90             	pushl  -0x70(%ebp)
  800a00:	68 58 48 80 00       	push   $0x804858
  800a05:	e8 3f 07 00 00       	call   801149 <cprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a11:	74 04                	je     800a17 <_main+0x9df>
		{
			eval += 10;
  800a13:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		cprintf("	5.2: in block coalesces with PREV & NEXT\n\n") ;
  800a17:	83 ec 0c             	sub    $0xc,%esp
  800a1a:	68 b8 48 80 00       	push   $0x8048b8
  800a1f:	e8 25 07 00 00       	call   801149 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a27:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 3*kilo/2;
  800a2e:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800a35:	83 ec 0c             	sub    $0xc,%esp
  800a38:	ff 75 9c             	pushl  -0x64(%ebp)
  800a3b:	e8 32 15 00 00       	call   801f72 <malloc>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[4*allocCntPerSize - 2];
  800a46:	a1 98 6d 80 00       	mov    0x806d98,%eax
  800a4b:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800a4e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800a52:	74 08                	je     800a5c <_main+0xa24>
  800a54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a57:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800a5a:	74 1d                	je     800a79 <_main+0xa41>
		{
			is_correct = 0;
  800a5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800a63:	83 ec 04             	sub    $0x4,%esp
  800a66:	ff 75 b8             	pushl  -0x48(%ebp)
  800a69:	ff 75 90             	pushl  -0x70(%ebp)
  800a6c:	68 e4 48 80 00       	push   $0x8048e4
  800a71:	e8 d3 06 00 00       	call   801149 <cprintf>
  800a76:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800a79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a7d:	74 04                	je     800a83 <_main+0xa4b>
		{
			eval += 10;
  800a7f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		cprintf("	5.3: in block coalesces with PREV\n\n") ;
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	68 44 49 80 00       	push   $0x804944
  800a8b:	e8 b9 06 00 00       	call   801149 <cprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 30*sizeof(char) ;
  800a9a:	c7 45 9c 1e 00 00 00 	movl   $0x1e,-0x64(%ebp)
		va = malloc(actualSize);
  800aa1:	83 ec 0c             	sub    $0xc,%esp
  800aa4:	ff 75 9c             	pushl  -0x64(%ebp)
  800aa7:	e8 c6 14 00 00       	call   801f72 <malloc>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[2*allocCntPerSize];
  800ab2:	a1 60 67 80 00       	mov    0x806760,%eax
  800ab7:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800aba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800abe:	74 08                	je     800ac8 <_main+0xa90>
  800ac0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ac3:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800ac6:	74 1d                	je     800ae5 <_main+0xaad>
		{
			is_correct = 0;
  800ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.1: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800acf:	83 ec 04             	sub    $0x4,%esp
  800ad2:	ff 75 b8             	pushl  -0x48(%ebp)
  800ad5:	ff 75 90             	pushl  -0x70(%ebp)
  800ad8:	68 6c 49 80 00       	push   $0x80496c
  800add:	e8 67 06 00 00       	call   801149 <cprintf>
  800ae2:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 3*kilo/2 ;
  800ae5:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)

		//dummy allocation to consume the 1st 1.5 KB free block
		{
			va = malloc(actualSize);
  800aec:	83 ec 0c             	sub    $0xc,%esp
  800aef:	ff 75 9c             	pushl  -0x64(%ebp)
  800af2:	e8 7b 14 00 00       	call   801f72 <malloc>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		//dummy allocation to consume the 1st 2 KB free block
		{
			va = malloc(actualSize);
  800afd:	83 ec 0c             	sub    $0xc,%esp
  800b00:	ff 75 9c             	pushl  -0x64(%ebp)
  800b03:	e8 6a 14 00 00       	call   801f72 <malloc>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		va = malloc(actualSize);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 9c             	pushl  -0x64(%ebp)
  800b14:	e8 59 14 00 00       	call   801f72 <malloc>
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[numOfAllocs*allocCntPerSize-2];
  800b1f:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800b24:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800b27:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800b2b:	74 08                	je     800b35 <_main+0xafd>
  800b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b30:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800b33:	74 1d                	je     800b52 <_main+0xb1a>
		{
			is_correct = 0;
  800b35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	ff 75 b8             	pushl  -0x48(%ebp)
  800b42:	ff 75 90             	pushl  -0x70(%ebp)
  800b45:	68 cc 49 80 00       	push   $0x8049cc
  800b4a:	e8 fa 05 00 00       	call   801149 <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
		}

		actualSize = 3*kilo/2 ;
  800b52:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	ff 75 9c             	pushl  -0x64(%ebp)
  800b5f:	e8 0e 14 00 00       	call   801f72 <malloc>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	89 45 b8             	mov    %eax,-0x48(%ebp)

		//Check returned va
		expected = (void*)startVAs[numOfAllocs*allocCntPerSize-2] + 3*kilo/2 + sizeOfMetaData();
  800b6a:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800b6f:	05 10 06 00 00       	add    $0x610,%eax
  800b74:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800b77:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800b7b:	74 08                	je     800b85 <_main+0xb4d>
  800b7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b80:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800b83:	74 1d                	je     800ba2 <_main+0xb6a>
		{
			is_correct = 0;
  800b85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.3: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800b8c:	83 ec 04             	sub    $0x4,%esp
  800b8f:	ff 75 b8             	pushl  -0x48(%ebp)
  800b92:	ff 75 90             	pushl  -0x70(%ebp)
  800b95:	68 2c 4a 80 00       	push   $0x804a2c
  800b9a:	e8 aa 05 00 00       	call   801149 <cprintf>
  800b9f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800ba2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ba6:	74 04                	je     800bac <_main+0xb74>
		{
			eval += 10;
  800ba8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}


	//====================================================================//
	/*Check memory allocation*/
	cprintf("6: Check memory allocation [should not be changed due to free]\n\n") ;
  800bac:	83 ec 0c             	sub    $0xc,%esp
  800baf:	68 8c 4a 80 00       	push   $0x804a8c
  800bb4:	e8 90 05 00 00       	call   801149 <cprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800bbc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800bc3:	e8 c9 17 00 00       	call   802391 <sys_calculate_free_frames>
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcd:	39 c2                	cmp    %eax,%edx
  800bcf:	74 17                	je     800be8 <_main+0xbb0>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	68 d0 4a 80 00       	push   $0x804ad0
  800bd9:	e8 6b 05 00 00       	call   801149 <cprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800be1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bec:	74 04                	je     800bf2 <_main+0xbba>
		{
			eval += 10;
  800bee:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  800bf2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (int i = 0; i < numOfAllocs; ++i)
  800bf9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800c00:	eb 23                	jmp    800c25 <_main+0xbed>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
  800c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c05:	8b 14 85 00 60 80 00 	mov    0x806000(,%eax,4),%edx
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	c1 e0 02             	shl    $0x2,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c1a:	01 d0                	add    %edx,%eax
  800c1c:	c1 e0 03             	shl    $0x3,%eax
  800c1f:	01 45 d8             	add    %eax,-0x28(%ebp)
			eval += 10;
		}
	}

	uint32 expectedAllocatedSize = 0;
	for (int i = 0; i < numOfAllocs; ++i)
  800c22:	ff 45 d4             	incl   -0x2c(%ebp)
  800c25:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  800c29:	7e d7                	jle    800c02 <_main+0xbca>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  800c2b:	c7 45 8c 00 10 00 00 	movl   $0x1000,-0x74(%ebp)
  800c32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c35:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c38:	01 d0                	add    %edx,%eax
  800c3a:	48                   	dec    %eax
  800c3b:	89 45 88             	mov    %eax,-0x78(%ebp)
  800c3e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800c41:	ba 00 00 00 00       	mov    $0x0,%edx
  800c46:	f7 75 8c             	divl   -0x74(%ebp)
  800c49:	8b 45 88             	mov    -0x78(%ebp),%eax
  800c4c:	29 d0                	sub    %edx,%eax
  800c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800c51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c54:	c1 e8 0c             	shr    $0xc,%eax
  800c57:	89 45 84             	mov    %eax,-0x7c(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800c5a:	c7 45 80 00 00 40 00 	movl   $0x400000,-0x80(%ebp)
  800c61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c64:	8b 45 80             	mov    -0x80(%ebp),%eax
  800c67:	01 d0                	add    %edx,%eax
  800c69:	48                   	dec    %eax
  800c6a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800c70:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	f7 75 80             	divl   -0x80(%ebp)
  800c7e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800c84:	29 d0                	sub    %edx,%eax
  800c86:	c1 e8 16             	shr    $0x16,%eax
  800c89:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

	//====================================================================//
	/*Check WS elements*/
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	68 3c 4b 80 00       	push   $0x804b3c
  800c97:	e8 ad 04 00 00       	call   801149 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800c9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800ca6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800ca9:	c1 e0 02             	shl    $0x2,%eax
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	e8 bd 12 00 00       	call   801f72 <malloc>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		int i = 0;
  800cbe:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800cc5:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  800ccc:	eb 24                	jmp    800cf2 <_main+0xcba>
		{
			expectedVAs[i++] = va;
  800cce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800cd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cde:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ce4:	01 c2                	add    %eax,%edx
  800ce6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ce9:	89 02                	mov    %eax,(%edx)
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800ceb:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  800cf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf5:	05 00 00 00 80       	add    $0x80000000,%eax
  800cfa:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800cfd:	77 cf                	ja     800cce <_main+0xc96>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800cff:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800d02:	6a 02                	push   $0x2
  800d04:	6a 00                	push   $0x0
  800d06:	50                   	push   %eax
  800d07:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  800d0d:	e8 9c 1b 00 00       	call   8028ae <sys_check_WS_list>
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (chk != 1)
  800d1b:	83 bd 70 ff ff ff 01 	cmpl   $0x1,-0x90(%ebp)
  800d22:	74 17                	je     800d3b <_main+0xd03>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	68 78 4b 80 00       	push   $0x804b78
  800d2c:	e8 18 04 00 00       	call   801149 <cprintf>
  800d31:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800d34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3f:	74 04                	je     800d45 <_main+0xd0d>
		{
			eval += 10;
  800d41:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	cprintf("test free() with FIRST FIT completed [DYNAMIC ALLOCATOR]. Evaluation = %d%\n", eval);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	68 bc 4b 80 00       	push   $0x804bbc
  800d50:	e8 f4 03 00 00       	call   801149 <cprintf>
  800d55:	83 c4 10             	add    $0x10,%esp

	return;
  800d58:	90                   	nop
}
  800d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d64:	e8 b3 18 00 00       	call   80261c <sys_getenvindex>
  800d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d6f:	89 d0                	mov    %edx,%eax
  800d71:	01 c0                	add    %eax,%eax
  800d73:	01 d0                	add    %edx,%eax
  800d75:	c1 e0 06             	shl    $0x6,%eax
  800d78:	29 d0                	sub    %edx,%eax
  800d7a:	c1 e0 03             	shl    $0x3,%eax
  800d7d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800d82:	a3 40 60 80 00       	mov    %eax,0x806040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800d87:	a1 40 60 80 00       	mov    0x806040,%eax
  800d8c:	8a 40 68             	mov    0x68(%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 0d                	je     800da0 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800d93:	a1 40 60 80 00       	mov    0x806040,%eax
  800d98:	83 c0 68             	add    $0x68,%eax
  800d9b:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800da0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da4:	7e 0a                	jle    800db0 <libmain+0x52>
		binaryname = argv[0];
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// call user main routine
	_main(argc, argv);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	ff 75 08             	pushl  0x8(%ebp)
  800db9:	e8 7a f2 ff ff       	call   800038 <_main>
  800dbe:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800dc1:	e8 63 16 00 00       	call   802429 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	68 20 4c 80 00       	push   $0x804c20
  800dce:	e8 76 03 00 00       	call   801149 <cprintf>
  800dd3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800dd6:	a1 40 60 80 00       	mov    0x806040,%eax
  800ddb:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800de1:	a1 40 60 80 00       	mov    0x806040,%eax
  800de6:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800dec:	83 ec 04             	sub    $0x4,%esp
  800def:	52                   	push   %edx
  800df0:	50                   	push   %eax
  800df1:	68 48 4c 80 00       	push   $0x804c48
  800df6:	e8 4e 03 00 00       	call   801149 <cprintf>
  800dfb:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800dfe:	a1 40 60 80 00       	mov    0x806040,%eax
  800e03:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800e09:	a1 40 60 80 00       	mov    0x806040,%eax
  800e0e:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800e14:	a1 40 60 80 00       	mov    0x806040,%eax
  800e19:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800e1f:	51                   	push   %ecx
  800e20:	52                   	push   %edx
  800e21:	50                   	push   %eax
  800e22:	68 70 4c 80 00       	push   $0x804c70
  800e27:	e8 1d 03 00 00       	call   801149 <cprintf>
  800e2c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e2f:	a1 40 60 80 00       	mov    0x806040,%eax
  800e34:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	50                   	push   %eax
  800e3e:	68 c8 4c 80 00       	push   $0x804cc8
  800e43:	e8 01 03 00 00       	call   801149 <cprintf>
  800e48:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	68 20 4c 80 00       	push   $0x804c20
  800e53:	e8 f1 02 00 00       	call   801149 <cprintf>
  800e58:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e5b:	e8 e3 15 00 00       	call   802443 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e60:	e8 19 00 00 00       	call   800e7e <exit>
}
  800e65:	90                   	nop
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	6a 00                	push   $0x0
  800e73:	e8 70 17 00 00       	call   8025e8 <sys_destroy_env>
  800e78:	83 c4 10             	add    $0x10,%esp
}
  800e7b:	90                   	nop
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <exit>:

void
exit(void)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800e84:	e8 c5 17 00 00       	call   80264e <sys_exit_env>
}
  800e89:	90                   	nop
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800e92:	8d 45 10             	lea    0x10(%ebp),%eax
  800e95:	83 c0 04             	add    $0x4,%eax
  800e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e9b:	a1 1c a3 80 00       	mov    0x80a31c,%eax
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	74 16                	je     800eba <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ea4:	a1 1c a3 80 00       	mov    0x80a31c,%eax
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	50                   	push   %eax
  800ead:	68 dc 4c 80 00       	push   $0x804cdc
  800eb2:	e8 92 02 00 00       	call   801149 <cprintf>
  800eb7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800eba:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	50                   	push   %eax
  800ec6:	68 e1 4c 80 00       	push   $0x804ce1
  800ecb:	e8 79 02 00 00       	call   801149 <cprintf>
  800ed0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  800edc:	50                   	push   %eax
  800edd:	e8 fc 01 00 00       	call   8010de <vcprintf>
  800ee2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	6a 00                	push   $0x0
  800eea:	68 fd 4c 80 00       	push   $0x804cfd
  800eef:	e8 ea 01 00 00       	call   8010de <vcprintf>
  800ef4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ef7:	e8 82 ff ff ff       	call   800e7e <exit>

	// should not return here
	while (1) ;
  800efc:	eb fe                	jmp    800efc <_panic+0x70>

00800efe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f04:	a1 40 60 80 00       	mov    0x806040,%eax
  800f09:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	39 c2                	cmp    %eax,%edx
  800f14:	74 14                	je     800f2a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	68 00 4d 80 00       	push   $0x804d00
  800f1e:	6a 26                	push   $0x26
  800f20:	68 4c 4d 80 00       	push   $0x804d4c
  800f25:	e8 62 ff ff ff       	call   800e8c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f38:	e9 c5 00 00 00       	jmp    801002 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	01 d0                	add    %edx,%eax
  800f4c:	8b 00                	mov    (%eax),%eax
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	75 08                	jne    800f5a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800f52:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f55:	e9 a5 00 00 00       	jmp    800fff <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800f5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f68:	eb 69                	jmp    800fd3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f6a:	a1 40 60 80 00       	mov    0x806040,%eax
  800f6f:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800f75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f78:	89 d0                	mov    %edx,%eax
  800f7a:	01 c0                	add    %eax,%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	c1 e0 03             	shl    $0x3,%eax
  800f81:	01 c8                	add    %ecx,%eax
  800f83:	8a 40 04             	mov    0x4(%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 46                	jne    800fd0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f8a:	a1 40 60 80 00       	mov    0x806040,%eax
  800f8f:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800f95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f98:	89 d0                	mov    %edx,%eax
  800f9a:	01 c0                	add    %eax,%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	c1 e0 03             	shl    $0x3,%eax
  800fa1:	01 c8                	add    %ecx,%eax
  800fa3:	8b 00                	mov    (%eax),%eax
  800fa5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	01 c8                	add    %ecx,%eax
  800fc1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fc3:	39 c2                	cmp    %eax,%edx
  800fc5:	75 09                	jne    800fd0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800fc7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800fce:	eb 15                	jmp    800fe5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fd0:	ff 45 e8             	incl   -0x18(%ebp)
  800fd3:	a1 40 60 80 00       	mov    0x806040,%eax
  800fd8:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800fde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fe1:	39 c2                	cmp    %eax,%edx
  800fe3:	77 85                	ja     800f6a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800fe5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800fe9:	75 14                	jne    800fff <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	68 58 4d 80 00       	push   $0x804d58
  800ff3:	6a 3a                	push   $0x3a
  800ff5:	68 4c 4d 80 00       	push   $0x804d4c
  800ffa:	e8 8d fe ff ff       	call   800e8c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800fff:	ff 45 f0             	incl   -0x10(%ebp)
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801008:	0f 8c 2f ff ff ff    	jl     800f3d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80100e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801015:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80101c:	eb 26                	jmp    801044 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80101e:	a1 40 60 80 00       	mov    0x806040,%eax
  801023:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801029:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80102c:	89 d0                	mov    %edx,%eax
  80102e:	01 c0                	add    %eax,%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	c1 e0 03             	shl    $0x3,%eax
  801035:	01 c8                	add    %ecx,%eax
  801037:	8a 40 04             	mov    0x4(%eax),%al
  80103a:	3c 01                	cmp    $0x1,%al
  80103c:	75 03                	jne    801041 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80103e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801041:	ff 45 e0             	incl   -0x20(%ebp)
  801044:	a1 40 60 80 00       	mov    0x806040,%eax
  801049:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80104f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801052:	39 c2                	cmp    %eax,%edx
  801054:	77 c8                	ja     80101e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801059:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80105c:	74 14                	je     801072 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	68 ac 4d 80 00       	push   $0x804dac
  801066:	6a 44                	push   $0x44
  801068:	68 4c 4d 80 00       	push   $0x804d4c
  80106d:	e8 1a fe ff ff       	call   800e8c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801072:	90                   	nop
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 48 01             	lea    0x1(%eax),%ecx
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	89 0a                	mov    %ecx,(%edx)
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	88 d1                	mov    %dl,%cl
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	8b 00                	mov    (%eax),%eax
  801099:	3d ff 00 00 00       	cmp    $0xff,%eax
  80109e:	75 2c                	jne    8010cc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010a0:	a0 44 60 80 00       	mov    0x806044,%al
  8010a5:	0f b6 c0             	movzbl %al,%eax
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	8b 12                	mov    (%edx),%edx
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b2:	83 c2 08             	add    $0x8,%edx
  8010b5:	83 ec 04             	sub    $0x4,%esp
  8010b8:	50                   	push   %eax
  8010b9:	51                   	push   %ecx
  8010ba:	52                   	push   %edx
  8010bb:	e8 10 12 00 00       	call   8022d0 <sys_cputs>
  8010c0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	8b 40 04             	mov    0x4(%eax),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8010db:	90                   	nop
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8010e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8010ee:	00 00 00 
	b.cnt = 0;
  8010f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010f8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8010fb:	ff 75 0c             	pushl  0xc(%ebp)
  8010fe:	ff 75 08             	pushl  0x8(%ebp)
  801101:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801107:	50                   	push   %eax
  801108:	68 75 10 80 00       	push   $0x801075
  80110d:	e8 11 02 00 00       	call   801323 <vprintfmt>
  801112:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801115:	a0 44 60 80 00       	mov    0x806044,%al
  80111a:	0f b6 c0             	movzbl %al,%eax
  80111d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	50                   	push   %eax
  801127:	52                   	push   %edx
  801128:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80112e:	83 c0 08             	add    $0x8,%eax
  801131:	50                   	push   %eax
  801132:	e8 99 11 00 00       	call   8022d0 <sys_cputs>
  801137:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80113a:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  801141:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <cprintf>:

int cprintf(const char *fmt, ...) {
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80114f:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  801156:	8d 45 0c             	lea    0xc(%ebp),%eax
  801159:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	83 ec 08             	sub    $0x8,%esp
  801162:	ff 75 f4             	pushl  -0xc(%ebp)
  801165:	50                   	push   %eax
  801166:	e8 73 ff ff ff       	call   8010de <vcprintf>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80117c:	e8 a8 12 00 00       	call   802429 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801181:	8d 45 0c             	lea    0xc(%ebp),%eax
  801184:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	ff 75 f4             	pushl  -0xc(%ebp)
  801190:	50                   	push   %eax
  801191:	e8 48 ff ff ff       	call   8010de <vcprintf>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80119c:	e8 a2 12 00 00       	call   802443 <sys_enable_interrupt>
	return cnt;
  8011a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 14             	sub    $0x14,%esp
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8011bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011c4:	77 55                	ja     80121b <printnum+0x75>
  8011c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011c9:	72 05                	jb     8011d0 <printnum+0x2a>
  8011cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ce:	77 4b                	ja     80121b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011d0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8011d3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8011d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011de:	52                   	push   %edx
  8011df:	50                   	push   %eax
  8011e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011e6:	e8 69 29 00 00       	call   803b54 <__udivdi3>
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	ff 75 20             	pushl  0x20(%ebp)
  8011f4:	53                   	push   %ebx
  8011f5:	ff 75 18             	pushl  0x18(%ebp)
  8011f8:	52                   	push   %edx
  8011f9:	50                   	push   %eax
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 a1 ff ff ff       	call   8011a6 <printnum>
  801205:	83 c4 20             	add    $0x20,%esp
  801208:	eb 1a                	jmp    801224 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80120a:	83 ec 08             	sub    $0x8,%esp
  80120d:	ff 75 0c             	pushl  0xc(%ebp)
  801210:	ff 75 20             	pushl  0x20(%ebp)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	ff d0                	call   *%eax
  801218:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80121b:	ff 4d 1c             	decl   0x1c(%ebp)
  80121e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801222:	7f e6                	jg     80120a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801224:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801227:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801232:	53                   	push   %ebx
  801233:	51                   	push   %ecx
  801234:	52                   	push   %edx
  801235:	50                   	push   %eax
  801236:	e8 29 2a 00 00       	call   803c64 <__umoddi3>
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	05 14 50 80 00       	add    $0x805014,%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	50                   	push   %eax
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	ff d0                	call   *%eax
  801254:	83 c4 10             	add    $0x10,%esp
}
  801257:	90                   	nop
  801258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801260:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801264:	7e 1c                	jle    801282 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 50 08             	lea    0x8(%eax),%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 10                	mov    %edx,(%eax)
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8b 00                	mov    (%eax),%eax
  801278:	83 e8 08             	sub    $0x8,%eax
  80127b:	8b 50 04             	mov    0x4(%eax),%edx
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	eb 40                	jmp    8012c2 <getuint+0x65>
	else if (lflag)
  801282:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801286:	74 1e                	je     8012a6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 50 04             	lea    0x4(%eax),%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 10                	mov    %edx,(%eax)
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8b 00                	mov    (%eax),%eax
  80129a:	83 e8 04             	sub    $0x4,%eax
  80129d:	8b 00                	mov    (%eax),%eax
  80129f:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a4:	eb 1c                	jmp    8012c2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8b 00                	mov    (%eax),%eax
  8012ab:	8d 50 04             	lea    0x4(%eax),%edx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	89 10                	mov    %edx,(%eax)
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8b 00                	mov    (%eax),%eax
  8012b8:	83 e8 04             	sub    $0x4,%eax
  8012bb:	8b 00                	mov    (%eax),%eax
  8012bd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012cb:	7e 1c                	jle    8012e9 <getint+0x25>
		return va_arg(*ap, long long);
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	8d 50 08             	lea    0x8(%eax),%edx
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	89 10                	mov    %edx,(%eax)
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 e8 08             	sub    $0x8,%eax
  8012e2:	8b 50 04             	mov    0x4(%eax),%edx
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	eb 38                	jmp    801321 <getint+0x5d>
	else if (lflag)
  8012e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ed:	74 1a                	je     801309 <getint+0x45>
		return va_arg(*ap, long);
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8b 00                	mov    (%eax),%eax
  8012f4:	8d 50 04             	lea    0x4(%eax),%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	89 10                	mov    %edx,(%eax)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	83 e8 04             	sub    $0x4,%eax
  801304:	8b 00                	mov    (%eax),%eax
  801306:	99                   	cltd   
  801307:	eb 18                	jmp    801321 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 50 04             	lea    0x4(%eax),%edx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 10                	mov    %edx,(%eax)
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8b 00                	mov    (%eax),%eax
  80131b:	83 e8 04             	sub    $0x4,%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	99                   	cltd   
}
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	56                   	push   %esi
  801327:	53                   	push   %ebx
  801328:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80132b:	eb 17                	jmp    801344 <vprintfmt+0x21>
			if (ch == '\0')
  80132d:	85 db                	test   %ebx,%ebx
  80132f:	0f 84 af 03 00 00    	je     8016e4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	53                   	push   %ebx
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	ff d0                	call   *%eax
  801341:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 10             	mov    %edx,0x10(%ebp)
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	0f b6 d8             	movzbl %al,%ebx
  801352:	83 fb 25             	cmp    $0x25,%ebx
  801355:	75 d6                	jne    80132d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801357:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80135b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801362:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801369:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801370:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	8d 50 01             	lea    0x1(%eax),%edx
  80137d:	89 55 10             	mov    %edx,0x10(%ebp)
  801380:	8a 00                	mov    (%eax),%al
  801382:	0f b6 d8             	movzbl %al,%ebx
  801385:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801388:	83 f8 55             	cmp    $0x55,%eax
  80138b:	0f 87 2b 03 00 00    	ja     8016bc <vprintfmt+0x399>
  801391:	8b 04 85 38 50 80 00 	mov    0x805038(,%eax,4),%eax
  801398:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80139a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80139e:	eb d7                	jmp    801377 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013a4:	eb d1                	jmp    801377 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013b0:	89 d0                	mov    %edx,%eax
  8013b2:	c1 e0 02             	shl    $0x2,%eax
  8013b5:	01 d0                	add    %edx,%eax
  8013b7:	01 c0                	add    %eax,%eax
  8013b9:	01 d8                	add    %ebx,%eax
  8013bb:	83 e8 30             	sub    $0x30,%eax
  8013be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013c9:	83 fb 2f             	cmp    $0x2f,%ebx
  8013cc:	7e 3e                	jle    80140c <vprintfmt+0xe9>
  8013ce:	83 fb 39             	cmp    $0x39,%ebx
  8013d1:	7f 39                	jg     80140c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8013d6:	eb d5                	jmp    8013ad <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8013d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013db:	83 c0 04             	add    $0x4,%eax
  8013de:	89 45 14             	mov    %eax,0x14(%ebp)
  8013e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e4:	83 e8 04             	sub    $0x4,%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8013ec:	eb 1f                	jmp    80140d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8013ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f2:	79 83                	jns    801377 <vprintfmt+0x54>
				width = 0;
  8013f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8013fb:	e9 77 ff ff ff       	jmp    801377 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801400:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801407:	e9 6b ff ff ff       	jmp    801377 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80140c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80140d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801411:	0f 89 60 ff ff ff    	jns    801377 <vprintfmt+0x54>
				width = precision, precision = -1;
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80141d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801424:	e9 4e ff ff ff       	jmp    801377 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801429:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80142c:	e9 46 ff ff ff       	jmp    801377 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	83 c0 04             	add    $0x4,%eax
  801437:	89 45 14             	mov    %eax,0x14(%ebp)
  80143a:	8b 45 14             	mov    0x14(%ebp),%eax
  80143d:	83 e8 04             	sub    $0x4,%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	83 ec 08             	sub    $0x8,%esp
  801445:	ff 75 0c             	pushl  0xc(%ebp)
  801448:	50                   	push   %eax
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	ff d0                	call   *%eax
  80144e:	83 c4 10             	add    $0x10,%esp
			break;
  801451:	e9 89 02 00 00       	jmp    8016df <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	83 c0 04             	add    $0x4,%eax
  80145c:	89 45 14             	mov    %eax,0x14(%ebp)
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	83 e8 04             	sub    $0x4,%eax
  801465:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801467:	85 db                	test   %ebx,%ebx
  801469:	79 02                	jns    80146d <vprintfmt+0x14a>
				err = -err;
  80146b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80146d:	83 fb 64             	cmp    $0x64,%ebx
  801470:	7f 0b                	jg     80147d <vprintfmt+0x15a>
  801472:	8b 34 9d 80 4e 80 00 	mov    0x804e80(,%ebx,4),%esi
  801479:	85 f6                	test   %esi,%esi
  80147b:	75 19                	jne    801496 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80147d:	53                   	push   %ebx
  80147e:	68 25 50 80 00       	push   $0x805025
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	ff 75 08             	pushl  0x8(%ebp)
  801489:	e8 5e 02 00 00       	call   8016ec <printfmt>
  80148e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801491:	e9 49 02 00 00       	jmp    8016df <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801496:	56                   	push   %esi
  801497:	68 2e 50 80 00       	push   $0x80502e
  80149c:	ff 75 0c             	pushl  0xc(%ebp)
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	e8 45 02 00 00       	call   8016ec <printfmt>
  8014a7:	83 c4 10             	add    $0x10,%esp
			break;
  8014aa:	e9 30 02 00 00       	jmp    8016df <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014af:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b2:	83 c0 04             	add    $0x4,%eax
  8014b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bb:	83 e8 04             	sub    $0x4,%eax
  8014be:	8b 30                	mov    (%eax),%esi
  8014c0:	85 f6                	test   %esi,%esi
  8014c2:	75 05                	jne    8014c9 <vprintfmt+0x1a6>
				p = "(null)";
  8014c4:	be 31 50 80 00       	mov    $0x805031,%esi
			if (width > 0 && padc != '-')
  8014c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014cd:	7e 6d                	jle    80153c <vprintfmt+0x219>
  8014cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8014d3:	74 67                	je     80153c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8014d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	50                   	push   %eax
  8014dc:	56                   	push   %esi
  8014dd:	e8 0c 03 00 00       	call   8017ee <strnlen>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8014e8:	eb 16                	jmp    801500 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8014ea:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	ff d0                	call   *%eax
  8014fa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8014fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801500:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801504:	7f e4                	jg     8014ea <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801506:	eb 34                	jmp    80153c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801508:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80150c:	74 1c                	je     80152a <vprintfmt+0x207>
  80150e:	83 fb 1f             	cmp    $0x1f,%ebx
  801511:	7e 05                	jle    801518 <vprintfmt+0x1f5>
  801513:	83 fb 7e             	cmp    $0x7e,%ebx
  801516:	7e 12                	jle    80152a <vprintfmt+0x207>
					putch('?', putdat);
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	6a 3f                	push   $0x3f
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	ff d0                	call   *%eax
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	eb 0f                	jmp    801539 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	53                   	push   %ebx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	ff d0                	call   *%eax
  801536:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801539:	ff 4d e4             	decl   -0x1c(%ebp)
  80153c:	89 f0                	mov    %esi,%eax
  80153e:	8d 70 01             	lea    0x1(%eax),%esi
  801541:	8a 00                	mov    (%eax),%al
  801543:	0f be d8             	movsbl %al,%ebx
  801546:	85 db                	test   %ebx,%ebx
  801548:	74 24                	je     80156e <vprintfmt+0x24b>
  80154a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80154e:	78 b8                	js     801508 <vprintfmt+0x1e5>
  801550:	ff 4d e0             	decl   -0x20(%ebp)
  801553:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801557:	79 af                	jns    801508 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801559:	eb 13                	jmp    80156e <vprintfmt+0x24b>
				putch(' ', putdat);
  80155b:	83 ec 08             	sub    $0x8,%esp
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	6a 20                	push   $0x20
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	ff d0                	call   *%eax
  801568:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80156b:	ff 4d e4             	decl   -0x1c(%ebp)
  80156e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801572:	7f e7                	jg     80155b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801574:	e9 66 01 00 00       	jmp    8016df <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801579:	83 ec 08             	sub    $0x8,%esp
  80157c:	ff 75 e8             	pushl  -0x18(%ebp)
  80157f:	8d 45 14             	lea    0x14(%ebp),%eax
  801582:	50                   	push   %eax
  801583:	e8 3c fd ff ff       	call   8012c4 <getint>
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80158e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801597:	85 d2                	test   %edx,%edx
  801599:	79 23                	jns    8015be <vprintfmt+0x29b>
				putch('-', putdat);
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	6a 2d                	push   $0x2d
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	ff d0                	call   *%eax
  8015a8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b1:	f7 d8                	neg    %eax
  8015b3:	83 d2 00             	adc    $0x0,%edx
  8015b6:	f7 da                	neg    %edx
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015c5:	e9 bc 00 00 00       	jmp    801686 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	e8 84 fc ff ff       	call   80125d <getuint>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8015e2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015e9:	e9 98 00 00 00       	jmp    801686 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8015ee:	83 ec 08             	sub    $0x8,%esp
  8015f1:	ff 75 0c             	pushl  0xc(%ebp)
  8015f4:	6a 58                	push   $0x58
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	ff d0                	call   *%eax
  8015fb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	6a 58                	push   $0x58
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	ff d0                	call   *%eax
  80160b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	ff 75 0c             	pushl  0xc(%ebp)
  801614:	6a 58                	push   $0x58
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	ff d0                	call   *%eax
  80161b:	83 c4 10             	add    $0x10,%esp
			break;
  80161e:	e9 bc 00 00 00       	jmp    8016df <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	6a 30                	push   $0x30
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	ff d0                	call   *%eax
  801630:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	ff 75 0c             	pushl  0xc(%ebp)
  801639:	6a 78                	push   $0x78
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	ff d0                	call   *%eax
  801640:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801643:	8b 45 14             	mov    0x14(%ebp),%eax
  801646:	83 c0 04             	add    $0x4,%eax
  801649:	89 45 14             	mov    %eax,0x14(%ebp)
  80164c:	8b 45 14             	mov    0x14(%ebp),%eax
  80164f:	83 e8 04             	sub    $0x4,%eax
  801652:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801654:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80165e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801665:	eb 1f                	jmp    801686 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	ff 75 e8             	pushl  -0x18(%ebp)
  80166d:	8d 45 14             	lea    0x14(%ebp),%eax
  801670:	50                   	push   %eax
  801671:	e8 e7 fb ff ff       	call   80125d <getuint>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80167f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801686:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80168a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	52                   	push   %edx
  801691:	ff 75 e4             	pushl  -0x1c(%ebp)
  801694:	50                   	push   %eax
  801695:	ff 75 f4             	pushl  -0xc(%ebp)
  801698:	ff 75 f0             	pushl  -0x10(%ebp)
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	ff 75 08             	pushl  0x8(%ebp)
  8016a1:	e8 00 fb ff ff       	call   8011a6 <printnum>
  8016a6:	83 c4 20             	add    $0x20,%esp
			break;
  8016a9:	eb 34                	jmp    8016df <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	53                   	push   %ebx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	ff d0                	call   *%eax
  8016b7:	83 c4 10             	add    $0x10,%esp
			break;
  8016ba:	eb 23                	jmp    8016df <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016bc:	83 ec 08             	sub    $0x8,%esp
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	6a 25                	push   $0x25
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	ff d0                	call   *%eax
  8016c9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016cc:	ff 4d 10             	decl   0x10(%ebp)
  8016cf:	eb 03                	jmp    8016d4 <vprintfmt+0x3b1>
  8016d1:	ff 4d 10             	decl   0x10(%ebp)
  8016d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d7:	48                   	dec    %eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	3c 25                	cmp    $0x25,%al
  8016dc:	75 f3                	jne    8016d1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8016de:	90                   	nop
		}
	}
  8016df:	e9 47 fc ff ff       	jmp    80132b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8016e4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8016e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e8:	5b                   	pop    %ebx
  8016e9:	5e                   	pop    %esi
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8016f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8016f5:	83 c0 04             	add    $0x4,%eax
  8016f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801701:	50                   	push   %eax
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 16 fc ff ff       	call   801323 <vprintfmt>
  80170d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8b 40 08             	mov    0x8(%eax),%eax
  80171c:	8d 50 01             	lea    0x1(%eax),%edx
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
  801728:	8b 10                	mov    (%eax),%edx
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	8b 40 04             	mov    0x4(%eax),%eax
  801730:	39 c2                	cmp    %eax,%edx
  801732:	73 12                	jae    801746 <sprintputch+0x33>
		*b->buf++ = ch;
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	8b 00                	mov    (%eax),%eax
  801739:	8d 48 01             	lea    0x1(%eax),%ecx
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	89 0a                	mov    %ecx,(%edx)
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	88 10                	mov    %dl,(%eax)
}
  801746:	90                   	nop
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	01 d0                	add    %edx,%eax
  801760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80176a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80176e:	74 06                	je     801776 <vsnprintf+0x2d>
  801770:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801774:	7f 07                	jg     80177d <vsnprintf+0x34>
		return -E_INVAL;
  801776:	b8 03 00 00 00       	mov    $0x3,%eax
  80177b:	eb 20                	jmp    80179d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80177d:	ff 75 14             	pushl  0x14(%ebp)
  801780:	ff 75 10             	pushl  0x10(%ebp)
  801783:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801786:	50                   	push   %eax
  801787:	68 13 17 80 00       	push   $0x801713
  80178c:	e8 92 fb ff ff       	call   801323 <vprintfmt>
  801791:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801797:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017a5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017a8:	83 c0 04             	add    $0x4,%eax
  8017ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b4:	50                   	push   %eax
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	e8 89 ff ff ff       	call   801749 <vsnprintf>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017d8:	eb 06                	jmp    8017e0 <strlen+0x15>
		n++;
  8017da:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8017dd:	ff 45 08             	incl   0x8(%ebp)
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	84 c0                	test   %al,%al
  8017e7:	75 f1                	jne    8017da <strlen+0xf>
		n++;
	return n;
  8017e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017fb:	eb 09                	jmp    801806 <strnlen+0x18>
		n++;
  8017fd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801800:	ff 45 08             	incl   0x8(%ebp)
  801803:	ff 4d 0c             	decl   0xc(%ebp)
  801806:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80180a:	74 09                	je     801815 <strnlen+0x27>
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	84 c0                	test   %al,%al
  801813:	75 e8                	jne    8017fd <strnlen+0xf>
		n++;
	return n;
  801815:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801826:	90                   	nop
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8d 50 01             	lea    0x1(%eax),%edx
  80182d:	89 55 08             	mov    %edx,0x8(%ebp)
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8d 4a 01             	lea    0x1(%edx),%ecx
  801836:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801839:	8a 12                	mov    (%edx),%dl
  80183b:	88 10                	mov    %dl,(%eax)
  80183d:	8a 00                	mov    (%eax),%al
  80183f:	84 c0                	test   %al,%al
  801841:	75 e4                	jne    801827 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801843:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801854:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80185b:	eb 1f                	jmp    80187c <strncpy+0x34>
		*dst++ = *src;
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8d 50 01             	lea    0x1(%eax),%edx
  801863:	89 55 08             	mov    %edx,0x8(%ebp)
  801866:	8b 55 0c             	mov    0xc(%ebp),%edx
  801869:	8a 12                	mov    (%edx),%dl
  80186b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80186d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	84 c0                	test   %al,%al
  801874:	74 03                	je     801879 <strncpy+0x31>
			src++;
  801876:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801879:	ff 45 fc             	incl   -0x4(%ebp)
  80187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801882:	72 d9                	jb     80185d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801884:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801895:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801899:	74 30                	je     8018cb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80189b:	eb 16                	jmp    8018b3 <strlcpy+0x2a>
			*dst++ = *src++;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8d 50 01             	lea    0x1(%eax),%edx
  8018a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018af:	8a 12                	mov    (%edx),%dl
  8018b1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018b3:	ff 4d 10             	decl   0x10(%ebp)
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	74 09                	je     8018c5 <strlcpy+0x3c>
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	84 c0                	test   %al,%al
  8018c3:	75 d8                	jne    80189d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d1:	29 c2                	sub    %eax,%edx
  8018d3:	89 d0                	mov    %edx,%eax
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8018da:	eb 06                	jmp    8018e2 <strcmp+0xb>
		p++, q++;
  8018dc:	ff 45 08             	incl   0x8(%ebp)
  8018df:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	84 c0                	test   %al,%al
  8018e9:	74 0e                	je     8018f9 <strcmp+0x22>
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 10                	mov    (%eax),%dl
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	38 c2                	cmp    %al,%dl
  8018f7:	74 e3                	je     8018dc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	0f b6 d0             	movzbl %al,%edx
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	0f b6 c0             	movzbl %al,%eax
  801909:	29 c2                	sub    %eax,%edx
  80190b:	89 d0                	mov    %edx,%eax
}
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    

0080190f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801912:	eb 09                	jmp    80191d <strncmp+0xe>
		n--, p++, q++;
  801914:	ff 4d 10             	decl   0x10(%ebp)
  801917:	ff 45 08             	incl   0x8(%ebp)
  80191a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80191d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801921:	74 17                	je     80193a <strncmp+0x2b>
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	84 c0                	test   %al,%al
  80192a:	74 0e                	je     80193a <strncmp+0x2b>
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8a 10                	mov    (%eax),%dl
  801931:	8b 45 0c             	mov    0xc(%ebp),%eax
  801934:	8a 00                	mov    (%eax),%al
  801936:	38 c2                	cmp    %al,%dl
  801938:	74 da                	je     801914 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80193a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193e:	75 07                	jne    801947 <strncmp+0x38>
		return 0;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax
  801945:	eb 14                	jmp    80195b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	0f b6 d0             	movzbl %al,%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	0f b6 c0             	movzbl %al,%eax
  801957:	29 c2                	sub    %eax,%edx
  801959:	89 d0                	mov    %edx,%eax
}
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801969:	eb 12                	jmp    80197d <strchr+0x20>
		if (*s == c)
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801973:	75 05                	jne    80197a <strchr+0x1d>
			return (char *) s;
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	eb 11                	jmp    80198b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80197a:	ff 45 08             	incl   0x8(%ebp)
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8a 00                	mov    (%eax),%al
  801982:	84 c0                	test   %al,%al
  801984:	75 e5                	jne    80196b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801999:	eb 0d                	jmp    8019a8 <strfind+0x1b>
		if (*s == c)
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a3:	74 0e                	je     8019b3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019a5:	ff 45 08             	incl   0x8(%ebp)
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8a 00                	mov    (%eax),%al
  8019ad:	84 c0                	test   %al,%al
  8019af:	75 ea                	jne    80199b <strfind+0xe>
  8019b1:	eb 01                	jmp    8019b4 <strfind+0x27>
		if (*s == c)
			break;
  8019b3:	90                   	nop
	return (char *) s;
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019cb:	eb 0e                	jmp    8019db <memset+0x22>
		*p++ = c;
  8019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d0:	8d 50 01             	lea    0x1(%eax),%edx
  8019d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8019db:	ff 4d f8             	decl   -0x8(%ebp)
  8019de:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8019e2:	79 e9                	jns    8019cd <memset+0x14>
		*p++ = c;

	return v;
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8019ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8019fb:	eb 16                	jmp    801a13 <memcpy+0x2a>
		*d++ = *s++;
  8019fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a00:	8d 50 01             	lea    0x1(%eax),%edx
  801a03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a09:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a0f:	8a 12                	mov    (%edx),%dl
  801a11:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a13:	8b 45 10             	mov    0x10(%ebp),%eax
  801a16:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a19:	89 55 10             	mov    %edx,0x10(%ebp)
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	75 dd                	jne    8019fd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a3d:	73 50                	jae    801a8f <memmove+0x6a>
  801a3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a42:	8b 45 10             	mov    0x10(%ebp),%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a4a:	76 43                	jbe    801a8f <memmove+0x6a>
		s += n;
  801a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a52:	8b 45 10             	mov    0x10(%ebp),%eax
  801a55:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a58:	eb 10                	jmp    801a6a <memmove+0x45>
			*--d = *--s;
  801a5a:	ff 4d f8             	decl   -0x8(%ebp)
  801a5d:	ff 4d fc             	decl   -0x4(%ebp)
  801a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a63:	8a 10                	mov    (%eax),%dl
  801a65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a68:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a70:	89 55 10             	mov    %edx,0x10(%ebp)
  801a73:	85 c0                	test   %eax,%eax
  801a75:	75 e3                	jne    801a5a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801a77:	eb 23                	jmp    801a9c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7c:	8d 50 01             	lea    0x1(%eax),%edx
  801a7f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a85:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a88:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a8b:	8a 12                	mov    (%edx),%dl
  801a8d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a92:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a95:	89 55 10             	mov    %edx,0x10(%ebp)
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	75 dd                	jne    801a79 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ab3:	eb 2a                	jmp    801adf <memcmp+0x3e>
		if (*s1 != *s2)
  801ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab8:	8a 10                	mov    (%eax),%dl
  801aba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abd:	8a 00                	mov    (%eax),%al
  801abf:	38 c2                	cmp    %al,%dl
  801ac1:	74 16                	je     801ad9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	0f b6 d0             	movzbl %al,%edx
  801acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ace:	8a 00                	mov    (%eax),%al
  801ad0:	0f b6 c0             	movzbl %al,%eax
  801ad3:	29 c2                	sub    %eax,%edx
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	eb 18                	jmp    801af1 <memcmp+0x50>
		s1++, s2++;
  801ad9:	ff 45 fc             	incl   -0x4(%ebp)
  801adc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801adf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae2:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ae5:	89 55 10             	mov    %edx,0x10(%ebp)
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	75 c9                	jne    801ab5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801af9:	8b 55 08             	mov    0x8(%ebp),%edx
  801afc:	8b 45 10             	mov    0x10(%ebp),%eax
  801aff:	01 d0                	add    %edx,%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b04:	eb 15                	jmp    801b1b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	8a 00                	mov    (%eax),%al
  801b0b:	0f b6 d0             	movzbl %al,%edx
  801b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b11:	0f b6 c0             	movzbl %al,%eax
  801b14:	39 c2                	cmp    %eax,%edx
  801b16:	74 0d                	je     801b25 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b18:	ff 45 08             	incl   0x8(%ebp)
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b21:	72 e3                	jb     801b06 <memfind+0x13>
  801b23:	eb 01                	jmp    801b26 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b25:	90                   	nop
	return (void *) s;
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b3f:	eb 03                	jmp    801b44 <strtol+0x19>
		s++;
  801b41:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	8a 00                	mov    (%eax),%al
  801b49:	3c 20                	cmp    $0x20,%al
  801b4b:	74 f4                	je     801b41 <strtol+0x16>
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	8a 00                	mov    (%eax),%al
  801b52:	3c 09                	cmp    $0x9,%al
  801b54:	74 eb                	je     801b41 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	8a 00                	mov    (%eax),%al
  801b5b:	3c 2b                	cmp    $0x2b,%al
  801b5d:	75 05                	jne    801b64 <strtol+0x39>
		s++;
  801b5f:	ff 45 08             	incl   0x8(%ebp)
  801b62:	eb 13                	jmp    801b77 <strtol+0x4c>
	else if (*s == '-')
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	3c 2d                	cmp    $0x2d,%al
  801b6b:	75 0a                	jne    801b77 <strtol+0x4c>
		s++, neg = 1;
  801b6d:	ff 45 08             	incl   0x8(%ebp)
  801b70:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b7b:	74 06                	je     801b83 <strtol+0x58>
  801b7d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801b81:	75 20                	jne    801ba3 <strtol+0x78>
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 30                	cmp    $0x30,%al
  801b8a:	75 17                	jne    801ba3 <strtol+0x78>
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	40                   	inc    %eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	3c 78                	cmp    $0x78,%al
  801b94:	75 0d                	jne    801ba3 <strtol+0x78>
		s += 2, base = 16;
  801b96:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801b9a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ba1:	eb 28                	jmp    801bcb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ba3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba7:	75 15                	jne    801bbe <strtol+0x93>
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	8a 00                	mov    (%eax),%al
  801bae:	3c 30                	cmp    $0x30,%al
  801bb0:	75 0c                	jne    801bbe <strtol+0x93>
		s++, base = 8;
  801bb2:	ff 45 08             	incl   0x8(%ebp)
  801bb5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801bbc:	eb 0d                	jmp    801bcb <strtol+0xa0>
	else if (base == 0)
  801bbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bc2:	75 07                	jne    801bcb <strtol+0xa0>
		base = 10;
  801bc4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	8a 00                	mov    (%eax),%al
  801bd0:	3c 2f                	cmp    $0x2f,%al
  801bd2:	7e 19                	jle    801bed <strtol+0xc2>
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	8a 00                	mov    (%eax),%al
  801bd9:	3c 39                	cmp    $0x39,%al
  801bdb:	7f 10                	jg     801bed <strtol+0xc2>
			dig = *s - '0';
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	8a 00                	mov    (%eax),%al
  801be2:	0f be c0             	movsbl %al,%eax
  801be5:	83 e8 30             	sub    $0x30,%eax
  801be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801beb:	eb 42                	jmp    801c2f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	8a 00                	mov    (%eax),%al
  801bf2:	3c 60                	cmp    $0x60,%al
  801bf4:	7e 19                	jle    801c0f <strtol+0xe4>
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	8a 00                	mov    (%eax),%al
  801bfb:	3c 7a                	cmp    $0x7a,%al
  801bfd:	7f 10                	jg     801c0f <strtol+0xe4>
			dig = *s - 'a' + 10;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8a 00                	mov    (%eax),%al
  801c04:	0f be c0             	movsbl %al,%eax
  801c07:	83 e8 57             	sub    $0x57,%eax
  801c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c0d:	eb 20                	jmp    801c2f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8a 00                	mov    (%eax),%al
  801c14:	3c 40                	cmp    $0x40,%al
  801c16:	7e 39                	jle    801c51 <strtol+0x126>
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	8a 00                	mov    (%eax),%al
  801c1d:	3c 5a                	cmp    $0x5a,%al
  801c1f:	7f 30                	jg     801c51 <strtol+0x126>
			dig = *s - 'A' + 10;
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	0f be c0             	movsbl %al,%eax
  801c29:	83 e8 37             	sub    $0x37,%eax
  801c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c32:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c35:	7d 19                	jge    801c50 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c37:	ff 45 08             	incl   0x8(%ebp)
  801c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c41:	89 c2                	mov    %eax,%edx
  801c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c46:	01 d0                	add    %edx,%eax
  801c48:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c4b:	e9 7b ff ff ff       	jmp    801bcb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c50:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c55:	74 08                	je     801c5f <strtol+0x134>
		*endptr = (char *) s;
  801c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c63:	74 07                	je     801c6c <strtol+0x141>
  801c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c68:	f7 d8                	neg    %eax
  801c6a:	eb 03                	jmp    801c6f <strtol+0x144>
  801c6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <ltostr>:

void
ltostr(long value, char *str)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801c77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801c7e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801c85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c89:	79 13                	jns    801c9e <ltostr+0x2d>
	{
		neg = 1;
  801c8b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c95:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801c98:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801c9b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801ca6:	99                   	cltd   
  801ca7:	f7 f9                	idiv   %ecx
  801ca9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801caf:	8d 50 01             	lea    0x1(%eax),%edx
  801cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801cb5:	89 c2                	mov    %eax,%edx
  801cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cbf:	83 c2 30             	add    $0x30,%edx
  801cc2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ccc:	f7 e9                	imul   %ecx
  801cce:	c1 fa 02             	sar    $0x2,%edx
  801cd1:	89 c8                	mov    %ecx,%eax
  801cd3:	c1 f8 1f             	sar    $0x1f,%eax
  801cd6:	29 c2                	sub    %eax,%edx
  801cd8:	89 d0                	mov    %edx,%eax
  801cda:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ce5:	f7 e9                	imul   %ecx
  801ce7:	c1 fa 02             	sar    $0x2,%edx
  801cea:	89 c8                	mov    %ecx,%eax
  801cec:	c1 f8 1f             	sar    $0x1f,%eax
  801cef:	29 c2                	sub    %eax,%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	c1 e0 02             	shl    $0x2,%eax
  801cf6:	01 d0                	add    %edx,%eax
  801cf8:	01 c0                	add    %eax,%eax
  801cfa:	29 c1                	sub    %eax,%ecx
  801cfc:	89 ca                	mov    %ecx,%edx
  801cfe:	85 d2                	test   %edx,%edx
  801d00:	75 9c                	jne    801c9e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0c:	48                   	dec    %eax
  801d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d10:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d14:	74 3d                	je     801d53 <ltostr+0xe2>
		start = 1 ;
  801d16:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d1d:	eb 34                	jmp    801d53 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d25:	01 d0                	add    %edx,%eax
  801d27:	8a 00                	mov    (%eax),%al
  801d29:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d32:	01 c2                	add    %eax,%edx
  801d34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	01 c8                	add    %ecx,%eax
  801d3c:	8a 00                	mov    (%eax),%al
  801d3e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d46:	01 c2                	add    %eax,%edx
  801d48:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d4b:	88 02                	mov    %al,(%edx)
		start++ ;
  801d4d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d50:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d56:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d59:	7c c4                	jl     801d1f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d5b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d66:	90                   	nop
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	e8 54 fa ff ff       	call   8017cb <strlen>
  801d77:	83 c4 04             	add    $0x4,%esp
  801d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	e8 46 fa ff ff       	call   8017cb <strlen>
  801d85:	83 c4 04             	add    $0x4,%esp
  801d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801d8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d99:	eb 17                	jmp    801db2 <strcconcat+0x49>
		final[s] = str1[s] ;
  801d9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801da1:	01 c2                	add    %eax,%edx
  801da3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	01 c8                	add    %ecx,%eax
  801dab:	8a 00                	mov    (%eax),%al
  801dad:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801daf:	ff 45 fc             	incl   -0x4(%ebp)
  801db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801db8:	7c e1                	jl     801d9b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801dba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dc1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801dc8:	eb 1f                	jmp    801de9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dcd:	8d 50 01             	lea    0x1(%eax),%edx
  801dd0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801dd3:	89 c2                	mov    %eax,%edx
  801dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd8:	01 c2                	add    %eax,%edx
  801dda:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de0:	01 c8                	add    %ecx,%eax
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801de6:	ff 45 f8             	incl   -0x8(%ebp)
  801de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801def:	7c d9                	jl     801dca <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801df1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	01 d0                	add    %edx,%eax
  801df9:	c6 00 00             	movb   $0x0,(%eax)
}
  801dfc:	90                   	nop
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e02:	8b 45 14             	mov    0x14(%ebp),%eax
  801e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0e:	8b 00                	mov    (%eax),%eax
  801e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e17:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e22:	eb 0c                	jmp    801e30 <strsplit+0x31>
			*string++ = 0;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	8d 50 01             	lea    0x1(%eax),%edx
  801e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  801e2d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	8a 00                	mov    (%eax),%al
  801e35:	84 c0                	test   %al,%al
  801e37:	74 18                	je     801e51 <strsplit+0x52>
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	8a 00                	mov    (%eax),%al
  801e3e:	0f be c0             	movsbl %al,%eax
  801e41:	50                   	push   %eax
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	e8 13 fb ff ff       	call   80195d <strchr>
  801e4a:	83 c4 08             	add    $0x8,%esp
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	75 d3                	jne    801e24 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8a 00                	mov    (%eax),%al
  801e56:	84 c0                	test   %al,%al
  801e58:	74 5a                	je     801eb4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5d:	8b 00                	mov    (%eax),%eax
  801e5f:	83 f8 0f             	cmp    $0xf,%eax
  801e62:	75 07                	jne    801e6b <strsplit+0x6c>
		{
			return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	eb 66                	jmp    801ed1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6e:	8b 00                	mov    (%eax),%eax
  801e70:	8d 48 01             	lea    0x1(%eax),%ecx
  801e73:	8b 55 14             	mov    0x14(%ebp),%edx
  801e76:	89 0a                	mov    %ecx,(%edx)
  801e78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	01 c2                	add    %eax,%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801e89:	eb 03                	jmp    801e8e <strsplit+0x8f>
			string++;
  801e8b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	8a 00                	mov    (%eax),%al
  801e93:	84 c0                	test   %al,%al
  801e95:	74 8b                	je     801e22 <strsplit+0x23>
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	8a 00                	mov    (%eax),%al
  801e9c:	0f be c0             	movsbl %al,%eax
  801e9f:	50                   	push   %eax
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	e8 b5 fa ff ff       	call   80195d <strchr>
  801ea8:	83 c4 08             	add    $0x8,%esp
  801eab:	85 c0                	test   %eax,%eax
  801ead:	74 dc                	je     801e8b <strsplit+0x8c>
			string++;
	}
  801eaf:	e9 6e ff ff ff       	jmp    801e22 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801eb4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801eb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb8:	8b 00                	mov    (%eax),%eax
  801eba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec4:	01 d0                	add    %edx,%eax
  801ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ecc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ee0:	eb 4c                	jmp    801f2e <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801ee2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	01 d0                	add    %edx,%eax
  801eea:	8a 00                	mov    (%eax),%al
  801eec:	3c 40                	cmp    $0x40,%al
  801eee:	7e 27                	jle    801f17 <str2lower+0x44>
  801ef0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	8a 00                	mov    (%eax),%al
  801efa:	3c 5a                	cmp    $0x5a,%al
  801efc:	7f 19                	jg     801f17 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801efe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	01 ca                	add    %ecx,%edx
  801f0e:	8a 12                	mov    (%edx),%dl
  801f10:	83 c2 20             	add    $0x20,%edx
  801f13:	88 10                	mov    %dl,(%eax)
  801f15:	eb 14                	jmp    801f2b <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801f17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	01 c2                	add    %eax,%edx
  801f1f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	01 c8                	add    %ecx,%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801f2b:	ff 45 fc             	incl   -0x4(%ebp)
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	e8 95 f8 ff ff       	call   8017cb <strlen>
  801f36:	83 c4 04             	add    $0x4,%esp
  801f39:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f3c:	7f a4                	jg     801ee2 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801f46:	a1 20 60 80 00       	mov    0x806020,%eax
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	74 0a                	je     801f59 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f4f:	c7 05 20 60 80 00 00 	movl   $0x0,0x806020
  801f56:	00 00 00 
	}
}
  801f59:	90                   	nop
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	e8 7e 09 00 00       	call   8028eb <sys_sbrk>
  801f6d:	83 c4 10             	add    $0x10,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f78:	e8 c6 ff ff ff       	call   801f43 <InitializeUHeap>
	if (size == 0)
  801f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f81:	75 0a                	jne    801f8d <malloc+0x1b>
		return NULL;
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	e9 3f 01 00 00       	jmp    8020cc <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801f8d:	e8 ac 09 00 00       	call   80293e <sys_get_hard_limit>
  801f92:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801f95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f9f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801fa4:	c1 e8 0c             	shr    $0xc,%eax
  801fa7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801faa:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	48                   	dec    %eax
  801fba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc5:	f7 75 d8             	divl   -0x28(%ebp)
  801fc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcb:	29 d0                	sub    %edx,%eax
  801fcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801fd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd3:	c1 e8 0c             	shr    $0xc,%eax
  801fd6:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fdd:	75 0a                	jne    801fe9 <malloc+0x77>
		return NULL;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	e9 e3 00 00 00       	jmp    8020cc <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fec:	05 00 00 00 80       	add    $0x80000000,%eax
  801ff1:	c1 e8 0c             	shr    $0xc,%eax
  801ff4:	a3 20 a3 80 00       	mov    %eax,0x80a320

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801ff9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802000:	77 19                	ja     80201b <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	e8 60 0b 00 00       	call   802b6d <alloc_block_FF>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  802013:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802016:	e9 b1 00 00 00       	jmp    8020cc <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80201b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80201e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802021:	eb 4d                	jmp    802070 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  802023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802026:	8a 04 c5 40 a3 80 00 	mov    0x80a340(,%eax,8),%al
  80202d:	84 c0                	test   %al,%al
  80202f:	75 27                	jne    802058 <malloc+0xe6>
			{
				counter++;
  802031:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  802034:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  802038:	75 14                	jne    80204e <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80203a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203d:	05 00 00 08 00       	add    $0x80000,%eax
  802042:	c1 e0 0c             	shl    $0xc,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  802048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  80204e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802051:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802054:	75 17                	jne    80206d <malloc+0xfb>
				{
					break;
  802056:	eb 21                	jmp    802079 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  802058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205b:	8a 04 c5 40 a3 80 00 	mov    0x80a340(,%eax,8),%al
  802062:	3c 01                	cmp    $0x1,%al
  802064:	75 07                	jne    80206d <malloc+0xfb>
			{
				counter = 0;
  802066:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80206d:	ff 45 e8             	incl   -0x18(%ebp)
  802070:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  802077:	76 aa                	jbe    802023 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  802079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80207f:	75 46                	jne    8020c7 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	ff 75 d0             	pushl  -0x30(%ebp)
  802087:	ff 75 f4             	pushl  -0xc(%ebp)
  80208a:	e8 93 08 00 00       	call   802922 <sys_allocate_user_mem>
  80208f:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  802092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802095:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802098:	89 14 c5 44 a3 80 00 	mov    %edx,0x80a344(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  80209f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020a5:	eb 0e                	jmp    8020b5 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8020a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020aa:	c6 04 c5 40 a3 80 00 	movb   $0x1,0x80a340(,%eax,8)
  8020b1:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8020b2:	ff 45 e4             	incl   -0x1c(%ebp)
  8020b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	01 d0                	add    %edx,%eax
  8020bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020c0:	77 e5                	ja     8020a7 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	eb 05                	jmp    8020cc <malloc+0x15a>
		}
	}

	return NULL;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8020d4:	e8 65 08 00 00       	call   80293e <sys_get_hard_limit>
  8020d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8020e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e6:	0f 84 c1 00 00 00    	je     8021ad <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8020ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	79 1b                	jns    80210e <free+0x40>
  8020f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020f9:	73 13                	jae    80210e <free+0x40>
    {
        free_block(virtual_address);
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	ff 75 08             	pushl  0x8(%ebp)
  802101:	e8 34 10 00 00       	call   80313a <free_block>
  802106:	83 c4 10             	add    $0x10,%esp
    	return;
  802109:	e9 a6 00 00 00       	jmp    8021b4 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  80210e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802111:	05 00 10 00 00       	add    $0x1000,%eax
  802116:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802119:	0f 87 91 00 00 00    	ja     8021b0 <free+0xe2>
  80211f:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802126:	0f 87 84 00 00 00    	ja     8021b0 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802135:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80213a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80213d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802140:	05 00 00 00 80       	add    $0x80000000,%eax
  802145:	c1 e8 0c             	shr    $0xc,%eax
  802148:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80214b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80214e:	8b 04 c5 44 a3 80 00 	mov    0x80a344(,%eax,8),%eax
  802155:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  802158:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80215c:	74 55                	je     8021b3 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  80215e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802161:	c1 e8 0c             	shr    $0xc,%eax
  802164:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  802167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216a:	c7 04 c5 44 a3 80 00 	movl   $0x0,0x80a344(,%eax,8)
  802171:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  802175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217b:	eb 0e                	jmp    80218b <free+0xbd>
	{
		userArr[i].is_allocated=0;
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	c6 04 c5 40 a3 80 00 	movb   $0x0,0x80a340(,%eax,8)
  802187:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  802188:	ff 45 f4             	incl   -0xc(%ebp)
  80218b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80218e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802191:	01 c2                	add    %eax,%edx
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	39 c2                	cmp    %eax,%edx
  802198:	77 e3                	ja     80217d <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80219a:	83 ec 08             	sub    $0x8,%esp
  80219d:	ff 75 e0             	pushl  -0x20(%ebp)
  8021a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8021a3:	e8 5e 07 00 00       	call   802906 <sys_free_user_mem>
  8021a8:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8021ab:	eb 07                	jmp    8021b4 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8021ad:	90                   	nop
  8021ae:	eb 04                	jmp    8021b4 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8021b0:	90                   	nop
  8021b1:	eb 01                	jmp    8021b4 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8021b3:	90                   	nop
    else
     {
    	return;
      }

}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 18             	sub    $0x18,%esp
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021c2:	e8 7c fd ff ff       	call   801f43 <InitializeUHeap>
	if (size == 0)
  8021c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021cb:	75 07                	jne    8021d4 <smalloc+0x1e>
		return NULL;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	eb 17                	jmp    8021eb <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 90 51 80 00       	push   $0x805190
  8021dc:	68 ad 00 00 00       	push   $0xad
  8021e1:	68 b6 51 80 00       	push   $0x8051b6
  8021e6:	e8 a1 ec ff ff       	call   800e8c <_panic>
	return NULL;
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021f3:	e8 4b fd ff ff       	call   801f43 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	68 c4 51 80 00       	push   $0x8051c4
  802200:	68 ba 00 00 00       	push   $0xba
  802205:	68 b6 51 80 00       	push   $0x8051b6
  80220a:	e8 7d ec ff ff       	call   800e8c <_panic>

0080220f <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802215:	e8 29 fd ff ff       	call   801f43 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 e8 51 80 00       	push   $0x8051e8
  802222:	68 d8 00 00 00       	push   $0xd8
  802227:	68 b6 51 80 00       	push   $0x8051b6
  80222c:	e8 5b ec ff ff       	call   800e8c <_panic>

00802231 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 10 52 80 00       	push   $0x805210
  80223f:	68 ea 00 00 00       	push   $0xea
  802244:	68 b6 51 80 00       	push   $0x8051b6
  802249:	e8 3e ec ff ff       	call   800e8c <_panic>

0080224e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 34 52 80 00       	push   $0x805234
  80225c:	68 f2 00 00 00       	push   $0xf2
  802261:	68 b6 51 80 00       	push   $0x8051b6
  802266:	e8 21 ec ff ff       	call   800e8c <_panic>

0080226b <shrink>:

}
void shrink(uint32 newSize) {
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 34 52 80 00       	push   $0x805234
  802279:	68 f6 00 00 00       	push   $0xf6
  80227e:	68 b6 51 80 00       	push   $0x8051b6
  802283:	e8 04 ec ff ff       	call   800e8c <_panic>

00802288 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 34 52 80 00       	push   $0x805234
  802296:	68 fa 00 00 00       	push   $0xfa
  80229b:	68 b6 51 80 00       	push   $0x8051b6
  8022a0:	e8 e7 eb ff ff       	call   800e8c <_panic>

008022a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	57                   	push   %edi
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022c0:	cd 30                	int    $0x30
  8022c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5e                   	pop    %esi
  8022cd:	5f                   	pop    %edi
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    

008022d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	52                   	push   %edx
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	50                   	push   %eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	e8 b2 ff ff ff       	call   8022a5 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 01                	push   $0x1
  802308:	e8 98 ff ff ff       	call   8022a5 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802315:	8b 55 0c             	mov    0xc(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	6a 05                	push   $0x5
  802325:	e8 7b ff ff ff       	call   8022a5 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802334:	8b 75 18             	mov    0x18(%ebp),%esi
  802337:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	51                   	push   %ecx
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 06                	push   $0x6
  80234a:	e8 56 ff ff ff       	call   8022a5 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 07                	push   $0x7
  80236c:	e8 34 ff ff ff       	call   8022a5 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	6a 08                	push   $0x8
  802387:	e8 19 ff ff ff       	call   8022a5 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 09                	push   $0x9
  8023a0:	e8 00 ff ff ff       	call   8022a5 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 0a                	push   $0xa
  8023b9:	e8 e7 fe ff ff       	call   8022a5 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 0b                	push   $0xb
  8023d2:	e8 ce fe ff ff       	call   8022a5 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 0c                	push   $0xc
  8023eb:	e8 b5 fe ff ff       	call   8022a5 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 08             	pushl  0x8(%ebp)
  802403:	6a 0d                	push   $0xd
  802405:	e8 9b fe ff ff       	call   8022a5 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 0e                	push   $0xe
  80241e:	e8 82 fe ff ff       	call   8022a5 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	90                   	nop
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 11                	push   $0x11
  802438:	e8 68 fe ff ff       	call   8022a5 <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	90                   	nop
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 12                	push   $0x12
  802452:	e8 4e fe ff ff       	call   8022a5 <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
}
  80245a:	90                   	nop
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_cputc>:


void
sys_cputc(const char c)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802469:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	50                   	push   %eax
  802476:	6a 13                	push   $0x13
  802478:	e8 28 fe ff ff       	call   8022a5 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 14                	push   $0x14
  802492:	e8 0e fe ff ff       	call   8022a5 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	90                   	nop
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	ff 75 0c             	pushl  0xc(%ebp)
  8024ac:	50                   	push   %eax
  8024ad:	6a 15                	push   $0x15
  8024af:	e8 f1 fd ff ff       	call   8022a5 <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	52                   	push   %edx
  8024c9:	50                   	push   %eax
  8024ca:	6a 18                	push   $0x18
  8024cc:	e8 d4 fd ff ff       	call   8022a5 <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 16                	push   $0x16
  8024e9:	e8 b7 fd ff ff       	call   8022a5 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	90                   	nop
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	6a 17                	push   $0x17
  802507:	e8 99 fd ff ff       	call   8022a5 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	90                   	nop
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	8b 45 10             	mov    0x10(%ebp),%eax
  80251b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80251e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802521:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	6a 00                	push   $0x0
  80252a:	51                   	push   %ecx
  80252b:	52                   	push   %edx
  80252c:	ff 75 0c             	pushl  0xc(%ebp)
  80252f:	50                   	push   %eax
  802530:	6a 19                	push   $0x19
  802532:	e8 6e fd ff ff       	call   8022a5 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80253f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	6a 1a                	push   $0x1a
  80254f:	e8 51 fd ff ff       	call   8022a5 <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80255c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80255f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	51                   	push   %ecx
  80256a:	52                   	push   %edx
  80256b:	50                   	push   %eax
  80256c:	6a 1b                	push   $0x1b
  80256e:	e8 32 fd ff ff       	call   8022a5 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 1c                	push   $0x1c
  80258b:	e8 15 fd ff ff       	call   8022a5 <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 1d                	push   $0x1d
  8025a4:	e8 fc fc ff ff       	call   8022a5 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	ff 75 14             	pushl  0x14(%ebp)
  8025b9:	ff 75 10             	pushl  0x10(%ebp)
  8025bc:	ff 75 0c             	pushl  0xc(%ebp)
  8025bf:	50                   	push   %eax
  8025c0:	6a 1e                	push   $0x1e
  8025c2:	e8 de fc ff ff       	call   8022a5 <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	50                   	push   %eax
  8025db:	6a 1f                	push   $0x1f
  8025dd:	e8 c3 fc ff ff       	call   8022a5 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
}
  8025e5:	90                   	nop
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	50                   	push   %eax
  8025f7:	6a 20                	push   $0x20
  8025f9:	e8 a7 fc ff ff       	call   8022a5 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 02                	push   $0x2
  802612:	e8 8e fc ff ff       	call   8022a5 <syscall>
  802617:	83 c4 18             	add    $0x18,%esp
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 03                	push   $0x3
  80262b:	e8 75 fc ff ff       	call   8022a5 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 04                	push   $0x4
  802644:	e8 5c fc ff ff       	call   8022a5 <syscall>
  802649:	83 c4 18             	add    $0x18,%esp
}
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <sys_exit_env>:


void sys_exit_env(void)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 21                	push   $0x21
  80265d:	e8 43 fc ff ff       	call   8022a5 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	90                   	nop
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80266e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802671:	8d 50 04             	lea    0x4(%eax),%edx
  802674:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	52                   	push   %edx
  80267e:	50                   	push   %eax
  80267f:	6a 22                	push   $0x22
  802681:	e8 1f fc ff ff       	call   8022a5 <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
	return result;
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80268f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802692:	89 01                	mov    %eax,(%ecx)
  802694:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	c9                   	leave  
  80269b:	c2 04 00             	ret    $0x4

0080269e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	ff 75 10             	pushl  0x10(%ebp)
  8026a8:	ff 75 0c             	pushl  0xc(%ebp)
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	6a 10                	push   $0x10
  8026b0:	e8 f0 fb ff ff       	call   8022a5 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_rcr2>:
uint32 sys_rcr2()
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 23                	push   $0x23
  8026ca:	e8 d6 fb ff ff       	call   8022a5 <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026e0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	50                   	push   %eax
  8026ed:	6a 24                	push   $0x24
  8026ef:	e8 b1 fb ff ff       	call   8022a5 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f7:	90                   	nop
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <rsttst>:
void rsttst()
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 26                	push   $0x26
  802709:	e8 97 fb ff ff       	call   8022a5 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
	return ;
  802711:	90                   	nop
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	8b 45 14             	mov    0x14(%ebp),%eax
  80271d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802720:	8b 55 18             	mov    0x18(%ebp),%edx
  802723:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802727:	52                   	push   %edx
  802728:	50                   	push   %eax
  802729:	ff 75 10             	pushl  0x10(%ebp)
  80272c:	ff 75 0c             	pushl  0xc(%ebp)
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	6a 25                	push   $0x25
  802734:	e8 6c fb ff ff       	call   8022a5 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
	return ;
  80273c:	90                   	nop
}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <chktst>:
void chktst(uint32 n)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	ff 75 08             	pushl  0x8(%ebp)
  80274d:	6a 27                	push   $0x27
  80274f:	e8 51 fb ff ff       	call   8022a5 <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
	return ;
  802757:	90                   	nop
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <inctst>:

void inctst()
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 28                	push   $0x28
  802769:	e8 37 fb ff ff       	call   8022a5 <syscall>
  80276e:	83 c4 18             	add    $0x18,%esp
	return ;
  802771:	90                   	nop
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <gettst>:
uint32 gettst()
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 29                	push   $0x29
  802783:	e8 1d fb ff ff       	call   8022a5 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 2a                	push   $0x2a
  80279f:	e8 01 fb ff ff       	call   8022a5 <syscall>
  8027a4:	83 c4 18             	add    $0x18,%esp
  8027a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027aa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027ae:	75 07                	jne    8027b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b5:	eb 05                	jmp    8027bc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 2a                	push   $0x2a
  8027d0:	e8 d0 fa ff ff       	call   8022a5 <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
  8027d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027db:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027df:	75 07                	jne    8027e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e6:	eb 05                	jmp    8027ed <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 2a                	push   $0x2a
  802801:	e8 9f fa ff ff       	call   8022a5 <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
  802809:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80280c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802810:	75 07                	jne    802819 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802812:	b8 01 00 00 00       	mov    $0x1,%eax
  802817:	eb 05                	jmp    80281e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 2a                	push   $0x2a
  802832:	e8 6e fa ff ff       	call   8022a5 <syscall>
  802837:	83 c4 18             	add    $0x18,%esp
  80283a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80283d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802841:	75 07                	jne    80284a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802843:	b8 01 00 00 00       	mov    $0x1,%eax
  802848:	eb 05                	jmp    80284f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	ff 75 08             	pushl  0x8(%ebp)
  80285f:	6a 2b                	push   $0x2b
  802861:	e8 3f fa ff ff       	call   8022a5 <syscall>
  802866:	83 c4 18             	add    $0x18,%esp
	return ;
  802869:	90                   	nop
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802870:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802873:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802876:	8b 55 0c             	mov    0xc(%ebp),%edx
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	6a 00                	push   $0x0
  80287e:	53                   	push   %ebx
  80287f:	51                   	push   %ecx
  802880:	52                   	push   %edx
  802881:	50                   	push   %eax
  802882:	6a 2c                	push   $0x2c
  802884:	e8 1c fa ff ff       	call   8022a5 <syscall>
  802889:	83 c4 18             	add    $0x18,%esp
}
  80288c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802894:	8b 55 0c             	mov    0xc(%ebp),%edx
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	52                   	push   %edx
  8028a1:	50                   	push   %eax
  8028a2:	6a 2d                	push   $0x2d
  8028a4:	e8 fc f9 ff ff       	call   8022a5 <syscall>
  8028a9:	83 c4 18             	add    $0x18,%esp
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8028b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	51                   	push   %ecx
  8028bd:	ff 75 10             	pushl  0x10(%ebp)
  8028c0:	52                   	push   %edx
  8028c1:	50                   	push   %eax
  8028c2:	6a 2e                	push   $0x2e
  8028c4:	e8 dc f9 ff ff       	call   8022a5 <syscall>
  8028c9:	83 c4 18             	add    $0x18,%esp
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	ff 75 10             	pushl  0x10(%ebp)
  8028d8:	ff 75 0c             	pushl  0xc(%ebp)
  8028db:	ff 75 08             	pushl  0x8(%ebp)
  8028de:	6a 0f                	push   $0xf
  8028e0:	e8 c0 f9 ff ff       	call   8022a5 <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e8:	90                   	nop
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	50                   	push   %eax
  8028fa:	6a 2f                	push   $0x2f
  8028fc:	e8 a4 f9 ff ff       	call   8022a5 <syscall>
  802901:	83 c4 18             	add    $0x18,%esp

}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	ff 75 0c             	pushl  0xc(%ebp)
  802912:	ff 75 08             	pushl  0x8(%ebp)
  802915:	6a 30                	push   $0x30
  802917:	e8 89 f9 ff ff       	call   8022a5 <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
	return;
  80291f:	90                   	nop
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	ff 75 0c             	pushl  0xc(%ebp)
  80292e:	ff 75 08             	pushl  0x8(%ebp)
  802931:	6a 31                	push   $0x31
  802933:	e8 6d f9 ff ff       	call   8022a5 <syscall>
  802938:	83 c4 18             	add    $0x18,%esp
	return;
  80293b:	90                   	nop
}
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 32                	push   $0x32
  80294d:	e8 53 f9 ff ff       	call   8022a5 <syscall>
  802952:	83 c4 18             	add    $0x18,%esp
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	50                   	push   %eax
  802966:	6a 33                	push   $0x33
  802968:	e8 38 f9 ff ff       	call   8022a5 <syscall>
  80296d:	83 c4 18             	add    $0x18,%esp
}
  802970:	90                   	nop
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	83 e8 10             	sub    $0x10,%eax
  80297f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	83 e8 10             	sub    $0x10,%eax
  802995:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80299b:	8a 40 04             	mov    0x4(%eax),%al
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8029a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8029ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b0:	83 f8 02             	cmp    $0x2,%eax
  8029b3:	74 2b                	je     8029e0 <alloc_block+0x40>
  8029b5:	83 f8 02             	cmp    $0x2,%eax
  8029b8:	7f 07                	jg     8029c1 <alloc_block+0x21>
  8029ba:	83 f8 01             	cmp    $0x1,%eax
  8029bd:	74 0e                	je     8029cd <alloc_block+0x2d>
  8029bf:	eb 58                	jmp    802a19 <alloc_block+0x79>
  8029c1:	83 f8 03             	cmp    $0x3,%eax
  8029c4:	74 2d                	je     8029f3 <alloc_block+0x53>
  8029c6:	83 f8 04             	cmp    $0x4,%eax
  8029c9:	74 3b                	je     802a06 <alloc_block+0x66>
  8029cb:	eb 4c                	jmp    802a19 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	ff 75 08             	pushl  0x8(%ebp)
  8029d3:	e8 95 01 00 00       	call   802b6d <alloc_block_FF>
  8029d8:	83 c4 10             	add    $0x10,%esp
  8029db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029de:	eb 4a                	jmp    802a2a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	ff 75 08             	pushl  0x8(%ebp)
  8029e6:	e8 32 07 00 00       	call   80311d <alloc_block_NF>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029f1:	eb 37                	jmp    802a2a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8029f3:	83 ec 0c             	sub    $0xc,%esp
  8029f6:	ff 75 08             	pushl  0x8(%ebp)
  8029f9:	e8 a3 04 00 00       	call   802ea1 <alloc_block_BF>
  8029fe:	83 c4 10             	add    $0x10,%esp
  802a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a04:	eb 24                	jmp    802a2a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802a06:	83 ec 0c             	sub    $0xc,%esp
  802a09:	ff 75 08             	pushl  0x8(%ebp)
  802a0c:	e8 ef 06 00 00       	call   803100 <alloc_block_WF>
  802a11:	83 c4 10             	add    $0x10,%esp
  802a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a17:	eb 11                	jmp    802a2a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802a19:	83 ec 0c             	sub    $0xc,%esp
  802a1c:	68 44 52 80 00       	push   $0x805244
  802a21:	e8 23 e7 ff ff       	call   801149 <cprintf>
  802a26:	83 c4 10             	add    $0x10,%esp
		break;
  802a29:	90                   	nop
	}
	return va;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802a2d:	c9                   	leave  
  802a2e:	c3                   	ret    

00802a2f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802a2f:	55                   	push   %ebp
  802a30:	89 e5                	mov    %esp,%ebp
  802a32:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	68 64 52 80 00       	push   $0x805264
  802a3d:	e8 07 e7 ff ff       	call   801149 <cprintf>
  802a42:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802a45:	83 ec 0c             	sub    $0xc,%esp
  802a48:	68 8f 52 80 00       	push   $0x80528f
  802a4d:	e8 f7 e6 ff ff       	call   801149 <cprintf>
  802a52:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5b:	eb 26                	jmp    802a83 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8a 40 04             	mov    0x4(%eax),%al
  802a63:	0f b6 d0             	movzbl %al,%edx
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	52                   	push   %edx
  802a6f:	50                   	push   %eax
  802a70:	68 a7 52 80 00       	push   $0x8052a7
  802a75:	e8 cf e6 ff ff       	call   801149 <cprintf>
  802a7a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a87:	74 08                	je     802a91 <print_blocks_list+0x62>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	eb 05                	jmp    802a96 <print_blocks_list+0x67>
  802a91:	b8 00 00 00 00       	mov    $0x0,%eax
  802a96:	89 45 10             	mov    %eax,0x10(%ebp)
  802a99:	8b 45 10             	mov    0x10(%ebp),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	75 bd                	jne    802a5d <print_blocks_list+0x2e>
  802aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa4:	75 b7                	jne    802a5d <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802aa6:	83 ec 0c             	sub    $0xc,%esp
  802aa9:	68 64 52 80 00       	push   $0x805264
  802aae:	e8 96 e6 ff ff       	call   801149 <cprintf>
  802ab3:	83 c4 10             	add    $0x10,%esp

}
  802ab6:	90                   	nop
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ac3:	0f 84 a1 00 00 00    	je     802b6a <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802ac9:	c7 05 4c 60 80 00 01 	movl   $0x1,0x80604c
  802ad0:	00 00 00 
	LIST_INIT(&list);
  802ad3:	c7 05 40 a3 90 00 00 	movl   $0x0,0x90a340
  802ada:	00 00 00 
  802add:	c7 05 44 a3 90 00 00 	movl   $0x0,0x90a344
  802ae4:	00 00 00 
  802ae7:	c7 05 4c a3 90 00 00 	movl   $0x0,0x90a34c
  802aee:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b04:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	75 14                	jne    802b20 <initialize_dynamic_allocator+0x67>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 c0 52 80 00       	push   $0x8052c0
  802b14:	6a 64                	push   $0x64
  802b16:	68 e3 52 80 00       	push   $0x8052e3
  802b1b:	e8 6c e3 ff ff       	call   800e8c <_panic>
  802b20:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	89 50 0c             	mov    %edx,0xc(%eax)
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0d                	je     802b43 <initialize_dynamic_allocator+0x8a>
  802b36:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3e:	89 50 08             	mov    %edx,0x8(%eax)
  802b41:	eb 08                	jmp    802b4b <initialize_dynamic_allocator+0x92>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b5d:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802b62:	40                   	inc    %eax
  802b63:	a3 4c a3 90 00       	mov    %eax,0x90a34c
  802b68:	eb 01                	jmp    802b6b <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802b6a:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802b6d:	55                   	push   %ebp
  802b6e:	89 e5                	mov    %esp,%ebp
  802b70:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b77:	75 0a                	jne    802b83 <alloc_block_FF+0x16>
	{
		return NULL;
  802b79:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7e:	e9 1c 03 00 00       	jmp    802e9f <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802b83:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	75 40                	jne    802bcc <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	83 c0 10             	add    $0x10,%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	83 ec 0c             	sub    $0xc,%esp
  802b9b:	50                   	push   %eax
  802b9c:	e8 bb f3 ff ff       	call   801f5c <sbrk>
  802ba1:	83 c4 10             	add    $0x10,%esp
  802ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802ba7:	83 ec 0c             	sub    $0xc,%esp
  802baa:	6a 00                	push   $0x0
  802bac:	e8 ab f3 ff ff       	call   801f5c <sbrk>
  802bb1:	83 c4 10             	add    $0x10,%esp
  802bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bba:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802bbd:	83 ec 08             	sub    $0x8,%esp
  802bc0:	50                   	push   %eax
  802bc1:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc4:	e8 f0 fe ff ff       	call   802ab9 <initialize_dynamic_allocator>
  802bc9:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802bcc:	a1 40 a3 90 00       	mov    0x90a340,%eax
  802bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd4:	e9 1e 01 00 00       	jmp    802cf7 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8d 50 10             	lea    0x10(%eax),%edx
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	39 c2                	cmp    %eax,%edx
  802be6:	75 1c                	jne    802c04 <alloc_block_FF+0x97>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8a 40 04             	mov    0x4(%eax),%al
  802bee:	3c 01                	cmp    $0x1,%al
  802bf0:	75 12                	jne    802c04 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	83 c0 10             	add    $0x10,%eax
  802bff:	e9 9b 02 00 00       	jmp    802e9f <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8d 50 10             	lea    0x10(%eax),%edx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	39 c2                	cmp    %eax,%edx
  802c11:	0f 83 d8 00 00 00    	jae    802cef <alloc_block_FF+0x182>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8a 40 04             	mov    0x4(%eax),%al
  802c1d:	3c 01                	cmp    $0x1,%al
  802c1f:	0f 85 ca 00 00 00    	jne    802cef <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c2d:	83 e8 10             	sub    $0x10,%eax
  802c30:	83 f8 0f             	cmp    $0xf,%eax
  802c33:	0f 86 a4 00 00 00    	jbe    802cdd <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	83 c0 10             	add    $0x10,%eax
  802c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4f:	8d 50 f0             	lea    -0x10(%eax),%edx
  802c52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c55:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802c57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c5a:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	74 06                	je     802c6a <alloc_block_FF+0xfd>
  802c64:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802c68:	75 17                	jne    802c81 <alloc_block_FF+0x114>
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	68 fc 52 80 00       	push   $0x8052fc
  802c72:	68 8f 00 00 00       	push   $0x8f
  802c77:	68 e3 52 80 00       	push   $0x8052e3
  802c7c:	e8 0b e2 ff ff       	call   800e8c <_panic>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c8a:	89 50 08             	mov    %edx,0x8(%eax)
  802c8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c90:	8b 40 08             	mov    0x8(%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0c                	je     802ca3 <alloc_block_FF+0x136>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 08             	mov    0x8(%eax),%eax
  802c9d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ca0:	89 50 0c             	mov    %edx,0xc(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ca9:	89 50 08             	mov    %edx,0x8(%eax)
  802cac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	89 50 0c             	mov    %edx,0xc(%eax)
  802cb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	75 08                	jne    802cc7 <alloc_block_FF+0x15a>
  802cbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cc2:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802cc7:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802ccc:	40                   	inc    %eax
  802ccd:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		    iterator->size = size + sizeOfMetaData();
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8d 50 10             	lea    0x10(%eax),%edx
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	83 c0 10             	add    $0x10,%eax
  802cea:	e9 b0 01 00 00       	jmp    802e9f <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802cef:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfb:	74 08                	je     802d05 <alloc_block_FF+0x198>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 08             	mov    0x8(%eax),%eax
  802d03:	eb 05                	jmp    802d0a <alloc_block_FF+0x19d>
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	a3 48 a3 90 00       	mov    %eax,0x90a348
  802d0f:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802d14:	85 c0                	test   %eax,%eax
  802d16:	0f 85 bd fe ff ff    	jne    802bd9 <alloc_block_FF+0x6c>
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	0f 85 b3 fe ff ff    	jne    802bd9 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	83 c0 10             	add    $0x10,%eax
  802d2c:	83 ec 0c             	sub    $0xc,%esp
  802d2f:	50                   	push   %eax
  802d30:	e8 27 f2 ff ff       	call   801f5c <sbrk>
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802d3b:	83 ec 0c             	sub    $0xc,%esp
  802d3e:	6a 00                	push   $0x0
  802d40:	e8 17 f2 ff ff       	call   801f5c <sbrk>
  802d45:	83 c4 10             	add    $0x10,%esp
  802d48:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d51:	29 c2                	sub    %eax,%edx
  802d53:	89 d0                	mov    %edx,%eax
  802d55:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802d58:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802d5c:	0f 84 38 01 00 00    	je     802e9a <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d65:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802d68:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d6c:	75 17                	jne    802d85 <alloc_block_FF+0x218>
  802d6e:	83 ec 04             	sub    $0x4,%esp
  802d71:	68 c0 52 80 00       	push   $0x8052c0
  802d76:	68 9f 00 00 00       	push   $0x9f
  802d7b:	68 e3 52 80 00       	push   $0x8052e3
  802d80:	e8 07 e1 ff ff       	call   800e8c <_panic>
  802d85:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802d8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802d91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	74 0d                	je     802da8 <alloc_block_FF+0x23b>
  802d9b:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802da0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802da3:	89 50 08             	mov    %edx,0x8(%eax)
  802da6:	eb 08                	jmp    802db0 <alloc_block_FF+0x243>
  802da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dab:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802db0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802db3:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802db8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dbb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dc2:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802dc7:	40                   	inc    %eax
  802dc8:	a3 4c a3 90 00       	mov    %eax,0x90a34c
			newBlock->size = size + sizeOfMetaData();
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8d 50 10             	lea    0x10(%eax),%edx
  802dd3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dd6:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802dd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ddb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802ddf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de2:	2b 45 08             	sub    0x8(%ebp),%eax
  802de5:	83 f8 10             	cmp    $0x10,%eax
  802de8:	0f 84 a4 00 00 00    	je     802e92 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802dee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df1:	2b 45 08             	sub    0x8(%ebp),%eax
  802df4:	83 e8 10             	sub    $0x10,%eax
  802df7:	83 f8 0f             	cmp    $0xf,%eax
  802dfa:	0f 86 8a 00 00 00    	jbe    802e8a <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802e00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	01 d0                	add    %edx,%eax
  802e08:	83 c0 10             	add    $0x10,%eax
  802e0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802e0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e12:	75 17                	jne    802e2b <alloc_block_FF+0x2be>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 c0 52 80 00       	push   $0x8052c0
  802e1c:	68 a7 00 00 00       	push   $0xa7
  802e21:	68 e3 52 80 00       	push   $0x8052e3
  802e26:	e8 61 e0 ff ff       	call   800e8c <_panic>
  802e2b:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802e31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e34:	89 50 0c             	mov    %edx,0xc(%eax)
  802e37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 0d                	je     802e4e <alloc_block_FF+0x2e1>
  802e41:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802e46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e49:	89 50 08             	mov    %edx,0x8(%eax)
  802e4c:	eb 08                	jmp    802e56 <alloc_block_FF+0x2e9>
  802e4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e51:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802e56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e59:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802e5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e68:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802e6d:	40                   	inc    %eax
  802e6e:	a3 4c a3 90 00       	mov    %eax,0x90a34c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802e73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e76:	2b 45 08             	sub    0x8(%ebp),%eax
  802e79:	8d 50 f0             	lea    -0x10(%eax),%edx
  802e7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7f:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e84:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802e88:	eb 08                	jmp    802e92 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802e8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e90:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802e92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e95:	83 c0 10             	add    $0x10,%eax
  802e98:	eb 05                	jmp    802e9f <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802e9a:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802e9f:	c9                   	leave  
  802ea0:	c3                   	ret    

00802ea1 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802ea7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802eae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb2:	75 0a                	jne    802ebe <alloc_block_BF+0x1d>
	{
		return NULL;
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	e9 40 02 00 00       	jmp    8030fe <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802ebe:	a1 40 a3 90 00       	mov    0x90a340,%eax
  802ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec6:	eb 66                	jmp    802f2e <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8a 40 04             	mov    0x4(%eax),%al
  802ece:	3c 01                	cmp    $0x1,%al
  802ed0:	75 21                	jne    802ef3 <alloc_block_BF+0x52>
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8d 50 10             	lea    0x10(%eax),%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	75 12                	jne    802ef3 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	83 c0 10             	add    $0x10,%eax
  802eee:	e9 0b 02 00 00       	jmp    8030fe <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8a 40 04             	mov    0x4(%eax),%al
  802ef9:	3c 01                	cmp    $0x1,%al
  802efb:	75 29                	jne    802f26 <alloc_block_BF+0x85>
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8d 50 10             	lea    0x10(%eax),%edx
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	39 c2                	cmp    %eax,%edx
  802f0a:	77 1a                	ja     802f26 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802f0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f10:	74 0e                	je     802f20 <alloc_block_BF+0x7f>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 10                	mov    (%eax),%edx
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	39 c2                	cmp    %eax,%edx
  802f1e:	73 06                	jae    802f26 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802f26:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	74 08                	je     802f3c <alloc_block_BF+0x9b>
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 08             	mov    0x8(%eax),%eax
  802f3a:	eb 05                	jmp    802f41 <alloc_block_BF+0xa0>
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	a3 48 a3 90 00       	mov    %eax,0x90a348
  802f46:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	0f 85 75 ff ff ff    	jne    802ec8 <alloc_block_BF+0x27>
  802f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f57:	0f 85 6b ff ff ff    	jne    802ec8 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802f5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f61:	0f 84 f8 00 00 00    	je     80305f <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8d 50 10             	lea    0x10(%eax),%edx
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	39 c2                	cmp    %eax,%edx
  802f74:	0f 87 e5 00 00 00    	ja     80305f <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	2b 45 08             	sub    0x8(%ebp),%eax
  802f82:	83 e8 10             	sub    $0x10,%eax
  802f85:	83 f8 0f             	cmp    $0xf,%eax
  802f88:	0f 86 bf 00 00 00    	jbe    80304d <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802f8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	01 d0                	add    %edx,%eax
  802f96:	83 c0 10             	add    $0x10,%eax
  802f99:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	2b 45 08             	sub    0x8(%ebp),%eax
  802fad:	8d 50 f0             	lea    -0x10(%eax),%edx
  802fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb3:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802fbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc0:	74 06                	je     802fc8 <alloc_block_BF+0x127>
  802fc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc6:	75 17                	jne    802fdf <alloc_block_BF+0x13e>
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	68 fc 52 80 00       	push   $0x8052fc
  802fd0:	68 e3 00 00 00       	push   $0xe3
  802fd5:	68 e3 52 80 00       	push   $0x8052e3
  802fda:	e8 ad de ff ff       	call   800e8c <_panic>
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	8b 50 08             	mov    0x8(%eax),%edx
  802fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe8:	89 50 08             	mov    %edx,0x8(%eax)
  802feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fee:	8b 40 08             	mov    0x8(%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 0c                	je     803001 <alloc_block_BF+0x160>
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ffe:	89 50 0c             	mov    %edx,0xc(%eax)
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803007:	89 50 08             	mov    %edx,0x8(%eax)
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803010:	89 50 0c             	mov    %edx,0xc(%eax)
  803013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	75 08                	jne    803025 <alloc_block_BF+0x184>
  80301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803020:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803025:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  80302a:	40                   	inc    %eax
  80302b:	a3 4c a3 90 00       	mov    %eax,0x90a34c

				BF->size = size + sizeOfMetaData();
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8d 50 10             	lea    0x10(%eax),%edx
  803036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	83 c0 10             	add    $0x10,%eax
  803048:	e9 b1 00 00 00       	jmp    8030fe <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	83 c0 10             	add    $0x10,%eax
  80305a:	e9 9f 00 00 00       	jmp    8030fe <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	83 c0 10             	add    $0x10,%eax
  803065:	83 ec 0c             	sub    $0xc,%esp
  803068:	50                   	push   %eax
  803069:	e8 ee ee ff ff       	call   801f5c <sbrk>
  80306e:	83 c4 10             	add    $0x10,%esp
  803071:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  803074:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  803078:	74 7f                	je     8030f9 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  80307a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307e:	75 17                	jne    803097 <alloc_block_BF+0x1f6>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 c0 52 80 00       	push   $0x8052c0
  803088:	68 f6 00 00 00       	push   $0xf6
  80308d:	68 e3 52 80 00       	push   $0x8052e3
  803092:	e8 f5 dd ff ff       	call   800e8c <_panic>
  803097:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 0d                	je     8030ba <alloc_block_BF+0x219>
  8030ad:	a1 44 a3 90 00       	mov    0x90a344,%eax
  8030b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b5:	89 50 08             	mov    %edx,0x8(%eax)
  8030b8:	eb 08                	jmp    8030c2 <alloc_block_BF+0x221>
  8030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bd:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030d4:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		newBlock->size = size + sizeOfMetaData();
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8d 50 10             	lea    0x10(%eax),%edx
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	83 c0 10             	add    $0x10,%eax
  8030f7:	eb 05                	jmp    8030fe <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 30 53 80 00       	push   $0x805330
  80310e:	68 07 01 00 00       	push   $0x107
  803113:	68 e3 52 80 00       	push   $0x8052e3
  803118:	e8 6f dd ff ff       	call   800e8c <_panic>

0080311d <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80311d:	55                   	push   %ebp
  80311e:	89 e5                	mov    %esp,%ebp
  803120:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803123:	83 ec 04             	sub    $0x4,%esp
  803126:	68 58 53 80 00       	push   $0x805358
  80312b:	68 0f 01 00 00       	push   $0x10f
  803130:	68 e3 52 80 00       	push   $0x8052e3
  803135:	e8 52 dd ff ff       	call   800e8c <_panic>

0080313a <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
  80313d:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  803140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803144:	0f 84 ee 05 00 00    	je     803738 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	83 e8 10             	sub    $0x10,%eax
  803150:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  803153:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803157:	a1 40 a3 90 00       	mov    0x90a340,%eax
  80315c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80315f:	eb 16                	jmp    803177 <free_block+0x3d>
	{
		if (block_pointer == it)
  803161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803164:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803167:	75 06                	jne    80316f <free_block+0x35>
		{
			flagx = 1;
  803169:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  80316d:	eb 2f                	jmp    80319e <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80316f:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803174:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80317b:	74 08                	je     803185 <free_block+0x4b>
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	8b 40 08             	mov    0x8(%eax),%eax
  803183:	eb 05                	jmp    80318a <free_block+0x50>
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
  80318a:	a3 48 a3 90 00       	mov    %eax,0x90a348
  80318f:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	75 c9                	jne    803161 <free_block+0x27>
  803198:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80319c:	75 c3                	jne    803161 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  80319e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8031a2:	0f 84 93 05 00 00    	je     80373b <free_block+0x601>
		return;
	if (va == NULL)
  8031a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ac:	0f 84 8c 05 00 00    	je     80373e <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8031b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	8b 40 08             	mov    0x8(%eax),%eax
  8031c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8031c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c8:	75 12                	jne    8031dc <free_block+0xa2>
  8031ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031ce:	75 0c                	jne    8031dc <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8031d7:	e9 63 05 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8031dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e0:	0f 85 ca 00 00 00    	jne    8032b0 <free_block+0x176>
  8031e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e9:	8a 40 04             	mov    0x4(%eax),%al
  8031ec:	3c 01                	cmp    $0x1,%al
  8031ee:	0f 85 bc 00 00 00    	jne    8032b0 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8031fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fe:	8b 10                	mov    (%eax),%edx
  803200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	01 c2                	add    %eax,%edx
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803218:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80321c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803220:	75 17                	jne    803239 <free_block+0xff>
  803222:	83 ec 04             	sub    $0x4,%esp
  803225:	68 7e 53 80 00       	push   $0x80537e
  80322a:	68 3c 01 00 00       	push   $0x13c
  80322f:	68 e3 52 80 00       	push   $0x8052e3
  803234:	e8 53 dc ff ff       	call   800e8c <_panic>
  803239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323c:	8b 40 08             	mov    0x8(%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 11                	je     803254 <free_block+0x11a>
  803243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803246:	8b 40 08             	mov    0x8(%eax),%eax
  803249:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80324c:	8b 52 0c             	mov    0xc(%edx),%edx
  80324f:	89 50 0c             	mov    %edx,0xc(%eax)
  803252:	eb 0b                	jmp    80325f <free_block+0x125>
  803254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803257:	8b 40 0c             	mov    0xc(%eax),%eax
  80325a:	a3 44 a3 90 00       	mov    %eax,0x90a344
  80325f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 11                	je     80327a <free_block+0x140>
  803269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803272:	8b 52 08             	mov    0x8(%edx),%edx
  803275:	89 50 08             	mov    %edx,0x8(%eax)
  803278:	eb 0b                	jmp    803285 <free_block+0x14b>
  80327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327d:	8b 40 08             	mov    0x8(%eax),%eax
  803280:	a3 40 a3 90 00       	mov    %eax,0x90a340
  803285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803288:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803292:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803299:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  80329e:	48                   	dec    %eax
  80329f:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  8032a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8032ab:	e9 8f 04 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8032b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b4:	75 16                	jne    8032cc <free_block+0x192>
  8032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b9:	8a 40 04             	mov    0x4(%eax),%al
  8032bc:	84 c0                	test   %al,%al
  8032be:	75 0c                	jne    8032cc <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8032c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8032c7:	e9 73 04 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8032cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032d0:	0f 85 c3 00 00 00    	jne    803399 <free_block+0x25f>
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	8a 40 04             	mov    0x4(%eax),%al
  8032dc:	3c 01                	cmp    $0x1,%al
  8032de:	0f 85 b5 00 00 00    	jne    803399 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e7:	8b 10                	mov    (%eax),%edx
  8032e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	01 c2                	add    %eax,%edx
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8032f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803305:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803309:	75 17                	jne    803322 <free_block+0x1e8>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 7e 53 80 00       	push   $0x80537e
  803313:	68 49 01 00 00       	push   $0x149
  803318:	68 e3 52 80 00       	push   $0x8052e3
  80331d:	e8 6a db ff ff       	call   800e8c <_panic>
  803322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803325:	8b 40 08             	mov    0x8(%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 11                	je     80333d <free_block+0x203>
  80332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332f:	8b 40 08             	mov    0x8(%eax),%eax
  803332:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803335:	8b 52 0c             	mov    0xc(%edx),%edx
  803338:	89 50 0c             	mov    %edx,0xc(%eax)
  80333b:	eb 0b                	jmp    803348 <free_block+0x20e>
  80333d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803340:	8b 40 0c             	mov    0xc(%eax),%eax
  803343:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334b:	8b 40 0c             	mov    0xc(%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 11                	je     803363 <free_block+0x229>
  803352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803355:	8b 40 0c             	mov    0xc(%eax),%eax
  803358:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80335b:	8b 52 08             	mov    0x8(%edx),%edx
  80335e:	89 50 08             	mov    %edx,0x8(%eax)
  803361:	eb 0b                	jmp    80336e <free_block+0x234>
  803363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803366:	8b 40 08             	mov    0x8(%eax),%eax
  803369:	a3 40 a3 90 00       	mov    %eax,0x90a340
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803382:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803387:	48                   	dec    %eax
  803388:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		block_pointer = 0;
  80338d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803394:	e9 a6 03 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  803399:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80339d:	75 16                	jne    8033b5 <free_block+0x27b>
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	8a 40 04             	mov    0x4(%eax),%al
  8033a5:	84 c0                	test   %al,%al
  8033a7:	75 0c                	jne    8033b5 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  8033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ac:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8033b0:	e9 8a 03 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8033b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b9:	0f 84 81 01 00 00    	je     803540 <free_block+0x406>
  8033bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c3:	0f 84 77 01 00 00    	je     803540 <free_block+0x406>
  8033c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cc:	8a 40 04             	mov    0x4(%eax),%al
  8033cf:	3c 01                	cmp    $0x1,%al
  8033d1:	0f 85 69 01 00 00    	jne    803540 <free_block+0x406>
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	8a 40 04             	mov    0x4(%eax),%al
  8033dd:	3c 01                	cmp    $0x1,%al
  8033df:	0f 85 5b 01 00 00    	jne    803540 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 10                	mov    (%eax),%edx
  8033ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ed:	8b 08                	mov    (%eax),%ecx
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	01 c8                	add    %ecx,%eax
  8033f6:	01 c2                	add    %eax,%edx
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8033fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80341d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803421:	75 17                	jne    80343a <free_block+0x300>
  803423:	83 ec 04             	sub    $0x4,%esp
  803426:	68 7e 53 80 00       	push   $0x80537e
  80342b:	68 59 01 00 00       	push   $0x159
  803430:	68 e3 52 80 00       	push   $0x8052e3
  803435:	e8 52 da ff ff       	call   800e8c <_panic>
  80343a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343d:	8b 40 08             	mov    0x8(%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	74 11                	je     803455 <free_block+0x31b>
  803444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803447:	8b 40 08             	mov    0x8(%eax),%eax
  80344a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80344d:	8b 52 0c             	mov    0xc(%edx),%edx
  803450:	89 50 0c             	mov    %edx,0xc(%eax)
  803453:	eb 0b                	jmp    803460 <free_block+0x326>
  803455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803458:	8b 40 0c             	mov    0xc(%eax),%eax
  80345b:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803463:	8b 40 0c             	mov    0xc(%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 11                	je     80347b <free_block+0x341>
  80346a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346d:	8b 40 0c             	mov    0xc(%eax),%eax
  803470:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803473:	8b 52 08             	mov    0x8(%edx),%edx
  803476:	89 50 08             	mov    %edx,0x8(%eax)
  803479:	eb 0b                	jmp    803486 <free_block+0x34c>
  80347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347e:	8b 40 08             	mov    0x8(%eax),%eax
  803481:	a3 40 a3 90 00       	mov    %eax,0x90a340
  803486:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803489:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803493:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80349a:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  80349f:	48                   	dec    %eax
  8034a0:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		LIST_REMOVE(&list, next_block);
  8034a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a9:	75 17                	jne    8034c2 <free_block+0x388>
  8034ab:	83 ec 04             	sub    $0x4,%esp
  8034ae:	68 7e 53 80 00       	push   $0x80537e
  8034b3:	68 5a 01 00 00       	push   $0x15a
  8034b8:	68 e3 52 80 00       	push   $0x8052e3
  8034bd:	e8 ca d9 ff ff       	call   800e8c <_panic>
  8034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c5:	8b 40 08             	mov    0x8(%eax),%eax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	74 11                	je     8034dd <free_block+0x3a3>
  8034cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cf:	8b 40 08             	mov    0x8(%eax),%eax
  8034d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8034d8:	89 50 0c             	mov    %edx,0xc(%eax)
  8034db:	eb 0b                	jmp    8034e8 <free_block+0x3ae>
  8034dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e3:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 11                	je     803503 <free_block+0x3c9>
  8034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034fb:	8b 52 08             	mov    0x8(%edx),%edx
  8034fe:	89 50 08             	mov    %edx,0x8(%eax)
  803501:	eb 0b                	jmp    80350e <free_block+0x3d4>
  803503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803506:	8b 40 08             	mov    0x8(%eax),%eax
  803509:	a3 40 a3 90 00       	mov    %eax,0x90a340
  80350e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803511:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803522:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803527:	48                   	dec    %eax
  803528:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  80352d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  803534:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80353b:	e9 ff 01 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803544:	0f 84 db 00 00 00    	je     803625 <free_block+0x4eb>
  80354a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80354e:	0f 84 d1 00 00 00    	je     803625 <free_block+0x4eb>
  803554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803557:	8a 40 04             	mov    0x4(%eax),%al
  80355a:	84 c0                	test   %al,%al
  80355c:	0f 85 c3 00 00 00    	jne    803625 <free_block+0x4eb>
  803562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803565:	8a 40 04             	mov    0x4(%eax),%al
  803568:	3c 01                	cmp    $0x1,%al
  80356a:	0f 85 b5 00 00 00    	jne    803625 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803573:	8b 10                	mov    (%eax),%edx
  803575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	01 c2                	add    %eax,%edx
  80357c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357f:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803584:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80358a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803591:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803595:	75 17                	jne    8035ae <free_block+0x474>
  803597:	83 ec 04             	sub    $0x4,%esp
  80359a:	68 7e 53 80 00       	push   $0x80537e
  80359f:	68 64 01 00 00       	push   $0x164
  8035a4:	68 e3 52 80 00       	push   $0x8052e3
  8035a9:	e8 de d8 ff ff       	call   800e8c <_panic>
  8035ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b1:	8b 40 08             	mov    0x8(%eax),%eax
  8035b4:	85 c0                	test   %eax,%eax
  8035b6:	74 11                	je     8035c9 <free_block+0x48f>
  8035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bb:	8b 40 08             	mov    0x8(%eax),%eax
  8035be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8035c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8035c7:	eb 0b                	jmp    8035d4 <free_block+0x49a>
  8035c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cf:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8035d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035da:	85 c0                	test   %eax,%eax
  8035dc:	74 11                	je     8035ef <free_block+0x4b5>
  8035de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035e7:	8b 52 08             	mov    0x8(%edx),%edx
  8035ea:	89 50 08             	mov    %edx,0x8(%eax)
  8035ed:	eb 0b                	jmp    8035fa <free_block+0x4c0>
  8035ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f2:	8b 40 08             	mov    0x8(%eax),%eax
  8035f5:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803607:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80360e:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803613:	48                   	dec    %eax
  803614:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		block_pointer = 0;
  803619:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803620:	e9 1a 01 00 00       	jmp    80373f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803625:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803629:	0f 84 df 00 00 00    	je     80370e <free_block+0x5d4>
  80362f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803633:	0f 84 d5 00 00 00    	je     80370e <free_block+0x5d4>
  803639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363c:	8a 40 04             	mov    0x4(%eax),%al
  80363f:	3c 01                	cmp    $0x1,%al
  803641:	0f 85 c7 00 00 00    	jne    80370e <free_block+0x5d4>
  803647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364a:	8a 40 04             	mov    0x4(%eax),%al
  80364d:	84 c0                	test   %al,%al
  80364f:	0f 85 b9 00 00 00    	jne    80370e <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  803655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803658:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80365c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365f:	8b 10                	mov    (%eax),%edx
  803661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	01 c2                	add    %eax,%edx
  803668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366b:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80366d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803679:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80367d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803681:	75 17                	jne    80369a <free_block+0x560>
  803683:	83 ec 04             	sub    $0x4,%esp
  803686:	68 7e 53 80 00       	push   $0x80537e
  80368b:	68 6e 01 00 00       	push   $0x16e
  803690:	68 e3 52 80 00       	push   $0x8052e3
  803695:	e8 f2 d7 ff ff       	call   800e8c <_panic>
  80369a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369d:	8b 40 08             	mov    0x8(%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	74 11                	je     8036b5 <free_block+0x57b>
  8036a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a7:	8b 40 08             	mov    0x8(%eax),%eax
  8036aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8036b0:	89 50 0c             	mov    %edx,0xc(%eax)
  8036b3:	eb 0b                	jmp    8036c0 <free_block+0x586>
  8036b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bb:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8036c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 11                	je     8036db <free_block+0x5a1>
  8036ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d3:	8b 52 08             	mov    0x8(%edx),%edx
  8036d6:	89 50 08             	mov    %edx,0x8(%eax)
  8036d9:	eb 0b                	jmp    8036e6 <free_block+0x5ac>
  8036db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036de:	8b 40 08             	mov    0x8(%eax),%eax
  8036e1:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8036e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8036fa:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8036ff:	48                   	dec    %eax
  803700:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  803705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80370c:	eb 31                	jmp    80373f <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  80370e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803712:	74 2b                	je     80373f <free_block+0x605>
  803714:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803718:	74 25                	je     80373f <free_block+0x605>
  80371a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371d:	8a 40 04             	mov    0x4(%eax),%al
  803720:	84 c0                	test   %al,%al
  803722:	75 1b                	jne    80373f <free_block+0x605>
  803724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803727:	8a 40 04             	mov    0x4(%eax),%al
  80372a:	84 c0                	test   %al,%al
  80372c:	75 11                	jne    80373f <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80372e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803731:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803735:	90                   	nop
  803736:	eb 07                	jmp    80373f <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803738:	90                   	nop
  803739:	eb 04                	jmp    80373f <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  80373b:	90                   	nop
  80373c:	eb 01                	jmp    80373f <free_block+0x605>
	if (va == NULL)
		return;
  80373e:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  80373f:	c9                   	leave  
  803740:	c3                   	ret    

00803741 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803741:	55                   	push   %ebp
  803742:	89 e5                	mov    %esp,%ebp
  803744:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803747:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374b:	75 19                	jne    803766 <realloc_block_FF+0x25>
  80374d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803751:	74 13                	je     803766 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  803753:	83 ec 0c             	sub    $0xc,%esp
  803756:	ff 75 0c             	pushl  0xc(%ebp)
  803759:	e8 0f f4 ff ff       	call   802b6d <alloc_block_FF>
  80375e:	83 c4 10             	add    $0x10,%esp
  803761:	e9 ea 03 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  803766:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80376a:	75 3b                	jne    8037a7 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  80376c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803770:	75 17                	jne    803789 <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  803772:	83 ec 0c             	sub    $0xc,%esp
  803775:	6a 00                	push   $0x0
  803777:	e8 f1 f3 ff ff       	call   802b6d <alloc_block_FF>
  80377c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80377f:	b8 00 00 00 00       	mov    $0x0,%eax
  803784:	e9 c7 03 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  803789:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378d:	74 18                	je     8037a7 <realloc_block_FF+0x66>
		{
			free_block(va);
  80378f:	83 ec 0c             	sub    $0xc,%esp
  803792:	ff 75 08             	pushl  0x8(%ebp)
  803795:	e8 a0 f9 ff ff       	call   80313a <free_block>
  80379a:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80379d:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a2:	e9 a9 03 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  8037a7:	a1 40 a3 90 00       	mov    0x90a340,%eax
  8037ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037af:	e9 68 03 00 00       	jmp    803b1c <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	83 e8 10             	sub    $0x10,%eax
  8037ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037bd:	0f 85 51 03 00 00    	jne    803b14 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037cb:	83 c2 10             	add    $0x10,%edx
  8037ce:	39 d0                	cmp    %edx,%eax
  8037d0:	75 08                	jne    8037da <realloc_block_FF+0x99>
			{
				return va;
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	e9 76 03 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  8037da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037e2:	0f 83 45 02 00 00    	jae    803a2d <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 40 08             	mov    0x8(%eax),%eax
  8037ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  8037f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f4:	8a 40 04             	mov    0x4(%eax),%al
  8037f7:	3c 01                	cmp    $0x1,%al
  8037f9:	0f 85 6b 01 00 00    	jne    80396a <realloc_block_FF+0x229>
  8037ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803803:	0f 84 61 01 00 00    	je     80396a <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  803809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380c:	8b 10                	mov    (%eax),%edx
  80380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803816:	29 c1                	sub    %eax,%ecx
  803818:	89 c8                	mov    %ecx,%eax
  80381a:	39 c2                	cmp    %eax,%edx
  80381c:	0f 86 e3 00 00 00    	jbe    803905 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  803822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803825:	8b 10                	mov    (%eax),%edx
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80382f:	01 d0                	add    %edx,%eax
  803831:	83 f8 0f             	cmp    $0xf,%eax
  803834:	0f 86 b5 00 00 00    	jbe    8038ef <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  80383a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80383d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803840:	01 d0                	add    %edx,%eax
  803842:	83 c0 10             	add    $0x10,%eax
  803845:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  803848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  803851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803854:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  803858:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385c:	74 06                	je     803864 <realloc_block_FF+0x123>
  80385e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803862:	75 17                	jne    80387b <realloc_block_FF+0x13a>
  803864:	83 ec 04             	sub    $0x4,%esp
  803867:	68 fc 52 80 00       	push   $0x8052fc
  80386c:	68 ae 01 00 00       	push   $0x1ae
  803871:	68 e3 52 80 00       	push   $0x8052e3
  803876:	e8 11 d6 ff ff       	call   800e8c <_panic>
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	8b 50 08             	mov    0x8(%eax),%edx
  803881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803884:	89 50 08             	mov    %edx,0x8(%eax)
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 40 08             	mov    0x8(%eax),%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	74 0c                	je     80389d <realloc_block_FF+0x15c>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 40 08             	mov    0x8(%eax),%eax
  803897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80389a:	89 50 0c             	mov    %edx,0xc(%eax)
  80389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a3:	89 50 08             	mov    %edx,0x8(%eax)
  8038a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038ac:	89 50 0c             	mov    %edx,0xc(%eax)
  8038af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b2:	8b 40 08             	mov    0x8(%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	75 08                	jne    8038c1 <realloc_block_FF+0x180>
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8038c1:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8038c6:	40                   	inc    %eax
  8038c7:	a3 4c a3 90 00       	mov    %eax,0x90a34c
							next->size = 0;
  8038cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  8038d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	8d 50 10             	lea    0x10(%eax),%edx
  8038e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e5:	89 10                	mov    %edx,(%eax)
							return va;
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	e9 61 02 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  8038ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f2:	8d 50 10             	lea    0x10(%eax),%edx
  8038f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f8:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  8038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fd:	83 c0 10             	add    $0x10,%eax
  803900:	e9 4b 02 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  803905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803908:	8b 10                	mov    (%eax),%edx
  80390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803912:	29 c1                	sub    %eax,%ecx
  803914:	89 c8                	mov    %ecx,%eax
  803916:	39 c2                	cmp    %eax,%edx
  803918:	0f 83 f5 01 00 00    	jae    803b13 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80391e:	83 ec 0c             	sub    $0xc,%esp
  803921:	ff 75 0c             	pushl  0xc(%ebp)
  803924:	e8 44 f2 ff ff       	call   802b6d <alloc_block_FF>
  803929:	83 c4 10             	add    $0x10,%esp
  80392c:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  80392f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803933:	74 2d                	je     803962 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	83 ec 04             	sub    $0x4,%esp
  80393d:	50                   	push   %eax
  80393e:	ff 75 08             	pushl  0x8(%ebp)
  803941:	ff 75 ec             	pushl  -0x14(%ebp)
  803944:	e8 a0 e0 ff ff       	call   8019e9 <memcpy>
  803949:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  80394c:	83 ec 0c             	sub    $0xc,%esp
  80394f:	ff 75 08             	pushl  0x8(%ebp)
  803952:	e8 e3 f7 ff ff       	call   80313a <free_block>
  803957:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  80395a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395d:	e9 ee 01 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  803962:	8b 45 08             	mov    0x8(%ebp),%eax
  803965:	e9 e6 01 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  80396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396d:	8a 40 04             	mov    0x4(%eax),%al
  803970:	3c 01                	cmp    $0x1,%al
  803972:	75 59                	jne    8039cd <realloc_block_FF+0x28c>
  803974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803977:	8b 10                	mov    (%eax),%edx
  803979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397c:	8b 00                	mov    (%eax),%eax
  80397e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803981:	29 c1                	sub    %eax,%ecx
  803983:	89 c8                	mov    %ecx,%eax
  803985:	39 c2                	cmp    %eax,%edx
  803987:	75 44                	jne    8039cd <realloc_block_FF+0x28c>
  803989:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80398d:	74 3e                	je     8039cd <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  80398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803992:	8b 40 08             	mov    0x8(%eax),%eax
  803995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399e:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  8039a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039a7:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  8039aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  8039ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039bd:	8d 50 10             	lea    0x10(%eax),%edx
  8039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c3:	89 10                	mov    %edx,(%eax)
					return va;
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	e9 83 01 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  8039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d0:	8a 40 04             	mov    0x4(%eax),%al
  8039d3:	84 c0                	test   %al,%al
  8039d5:	74 0a                	je     8039e1 <realloc_block_FF+0x2a0>
  8039d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039db:	0f 85 33 01 00 00    	jne    803b14 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8039e1:	83 ec 0c             	sub    $0xc,%esp
  8039e4:	ff 75 0c             	pushl  0xc(%ebp)
  8039e7:	e8 81 f1 ff ff       	call   802b6d <alloc_block_FF>
  8039ec:	83 c4 10             	add    $0x10,%esp
  8039ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  8039f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8039f6:	74 2d                	je     803a25 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  8039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fb:	8b 00                	mov    (%eax),%eax
  8039fd:	83 ec 04             	sub    $0x4,%esp
  803a00:	50                   	push   %eax
  803a01:	ff 75 08             	pushl  0x8(%ebp)
  803a04:	ff 75 e0             	pushl  -0x20(%ebp)
  803a07:	e8 dd df ff ff       	call   8019e9 <memcpy>
  803a0c:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  803a0f:	83 ec 0c             	sub    $0xc,%esp
  803a12:	ff 75 08             	pushl  0x8(%ebp)
  803a15:	e8 20 f7 ff ff       	call   80313a <free_block>
  803a1a:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a20:	e9 2b 01 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  803a25:	8b 45 08             	mov    0x8(%ebp),%eax
  803a28:	e9 23 01 00 00       	jmp    803b50 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	8b 00                	mov    (%eax),%eax
  803a32:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a35:	0f 86 d9 00 00 00    	jbe    803b14 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3e:	8b 00                	mov    (%eax),%eax
  803a40:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a43:	83 f8 0f             	cmp    $0xf,%eax
  803a46:	0f 86 b4 00 00 00    	jbe    803b00 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a52:	01 d0                	add    %edx,%eax
  803a54:	83 c0 10             	add    $0x10,%eax
  803a57:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	8b 00                	mov    (%eax),%eax
  803a5f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a62:	8d 50 f0             	lea    -0x10(%eax),%edx
  803a65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a68:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6e:	74 06                	je     803a76 <realloc_block_FF+0x335>
  803a70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a74:	75 17                	jne    803a8d <realloc_block_FF+0x34c>
  803a76:	83 ec 04             	sub    $0x4,%esp
  803a79:	68 fc 52 80 00       	push   $0x8052fc
  803a7e:	68 ed 01 00 00       	push   $0x1ed
  803a83:	68 e3 52 80 00       	push   $0x8052e3
  803a88:	e8 ff d3 ff ff       	call   800e8c <_panic>
  803a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a90:	8b 50 08             	mov    0x8(%eax),%edx
  803a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a96:	89 50 08             	mov    %edx,0x8(%eax)
  803a99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a9c:	8b 40 08             	mov    0x8(%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 0c                	je     803aaf <realloc_block_FF+0x36e>
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	8b 40 08             	mov    0x8(%eax),%eax
  803aa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803aac:	89 50 0c             	mov    %edx,0xc(%eax)
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ab5:	89 50 08             	mov    %edx,0x8(%eax)
  803ab8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803abe:	89 50 0c             	mov    %edx,0xc(%eax)
  803ac1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac4:	8b 40 08             	mov    0x8(%eax),%eax
  803ac7:	85 c0                	test   %eax,%eax
  803ac9:	75 08                	jne    803ad3 <realloc_block_FF+0x392>
  803acb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ace:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803ad3:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803ad8:	40                   	inc    %eax
  803ad9:	a3 4c a3 90 00       	mov    %eax,0x90a34c
					free_block((void*) (newBlockAfterSplit + 1));
  803ade:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae1:	83 c0 10             	add    $0x10,%eax
  803ae4:	83 ec 0c             	sub    $0xc,%esp
  803ae7:	50                   	push   %eax
  803ae8:	e8 4d f6 ff ff       	call   80313a <free_block>
  803aed:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af3:	8d 50 10             	lea    0x10(%eax),%edx
  803af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af9:	89 10                	mov    %edx,(%eax)
					return va;
  803afb:	8b 45 08             	mov    0x8(%ebp),%eax
  803afe:	eb 50                	jmp    803b50 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b03:	8d 50 10             	lea    0x10(%eax),%edx
  803b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b09:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	83 c0 10             	add    $0x10,%eax
  803b11:	eb 3d                	jmp    803b50 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803b13:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803b14:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b20:	74 08                	je     803b2a <realloc_block_FF+0x3e9>
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	8b 40 08             	mov    0x8(%eax),%eax
  803b28:	eb 05                	jmp    803b2f <realloc_block_FF+0x3ee>
  803b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2f:	a3 48 a3 90 00       	mov    %eax,0x90a348
  803b34:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803b39:	85 c0                	test   %eax,%eax
  803b3b:	0f 85 73 fc ff ff    	jne    8037b4 <realloc_block_FF+0x73>
  803b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b45:	0f 85 69 fc ff ff    	jne    8037b4 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b50:	c9                   	leave  
  803b51:	c3                   	ret    
  803b52:	66 90                	xchg   %ax,%ax

00803b54 <__udivdi3>:
  803b54:	55                   	push   %ebp
  803b55:	57                   	push   %edi
  803b56:	56                   	push   %esi
  803b57:	53                   	push   %ebx
  803b58:	83 ec 1c             	sub    $0x1c,%esp
  803b5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b6b:	89 ca                	mov    %ecx,%edx
  803b6d:	89 f8                	mov    %edi,%eax
  803b6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b73:	85 f6                	test   %esi,%esi
  803b75:	75 2d                	jne    803ba4 <__udivdi3+0x50>
  803b77:	39 cf                	cmp    %ecx,%edi
  803b79:	77 65                	ja     803be0 <__udivdi3+0x8c>
  803b7b:	89 fd                	mov    %edi,%ebp
  803b7d:	85 ff                	test   %edi,%edi
  803b7f:	75 0b                	jne    803b8c <__udivdi3+0x38>
  803b81:	b8 01 00 00 00       	mov    $0x1,%eax
  803b86:	31 d2                	xor    %edx,%edx
  803b88:	f7 f7                	div    %edi
  803b8a:	89 c5                	mov    %eax,%ebp
  803b8c:	31 d2                	xor    %edx,%edx
  803b8e:	89 c8                	mov    %ecx,%eax
  803b90:	f7 f5                	div    %ebp
  803b92:	89 c1                	mov    %eax,%ecx
  803b94:	89 d8                	mov    %ebx,%eax
  803b96:	f7 f5                	div    %ebp
  803b98:	89 cf                	mov    %ecx,%edi
  803b9a:	89 fa                	mov    %edi,%edx
  803b9c:	83 c4 1c             	add    $0x1c,%esp
  803b9f:	5b                   	pop    %ebx
  803ba0:	5e                   	pop    %esi
  803ba1:	5f                   	pop    %edi
  803ba2:	5d                   	pop    %ebp
  803ba3:	c3                   	ret    
  803ba4:	39 ce                	cmp    %ecx,%esi
  803ba6:	77 28                	ja     803bd0 <__udivdi3+0x7c>
  803ba8:	0f bd fe             	bsr    %esi,%edi
  803bab:	83 f7 1f             	xor    $0x1f,%edi
  803bae:	75 40                	jne    803bf0 <__udivdi3+0x9c>
  803bb0:	39 ce                	cmp    %ecx,%esi
  803bb2:	72 0a                	jb     803bbe <__udivdi3+0x6a>
  803bb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bb8:	0f 87 9e 00 00 00    	ja     803c5c <__udivdi3+0x108>
  803bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc3:	89 fa                	mov    %edi,%edx
  803bc5:	83 c4 1c             	add    $0x1c,%esp
  803bc8:	5b                   	pop    %ebx
  803bc9:	5e                   	pop    %esi
  803bca:	5f                   	pop    %edi
  803bcb:	5d                   	pop    %ebp
  803bcc:	c3                   	ret    
  803bcd:	8d 76 00             	lea    0x0(%esi),%esi
  803bd0:	31 ff                	xor    %edi,%edi
  803bd2:	31 c0                	xor    %eax,%eax
  803bd4:	89 fa                	mov    %edi,%edx
  803bd6:	83 c4 1c             	add    $0x1c,%esp
  803bd9:	5b                   	pop    %ebx
  803bda:	5e                   	pop    %esi
  803bdb:	5f                   	pop    %edi
  803bdc:	5d                   	pop    %ebp
  803bdd:	c3                   	ret    
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	89 d8                	mov    %ebx,%eax
  803be2:	f7 f7                	div    %edi
  803be4:	31 ff                	xor    %edi,%edi
  803be6:	89 fa                	mov    %edi,%edx
  803be8:	83 c4 1c             	add    $0x1c,%esp
  803beb:	5b                   	pop    %ebx
  803bec:	5e                   	pop    %esi
  803bed:	5f                   	pop    %edi
  803bee:	5d                   	pop    %ebp
  803bef:	c3                   	ret    
  803bf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bf5:	89 eb                	mov    %ebp,%ebx
  803bf7:	29 fb                	sub    %edi,%ebx
  803bf9:	89 f9                	mov    %edi,%ecx
  803bfb:	d3 e6                	shl    %cl,%esi
  803bfd:	89 c5                	mov    %eax,%ebp
  803bff:	88 d9                	mov    %bl,%cl
  803c01:	d3 ed                	shr    %cl,%ebp
  803c03:	89 e9                	mov    %ebp,%ecx
  803c05:	09 f1                	or     %esi,%ecx
  803c07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c0b:	89 f9                	mov    %edi,%ecx
  803c0d:	d3 e0                	shl    %cl,%eax
  803c0f:	89 c5                	mov    %eax,%ebp
  803c11:	89 d6                	mov    %edx,%esi
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 ee                	shr    %cl,%esi
  803c17:	89 f9                	mov    %edi,%ecx
  803c19:	d3 e2                	shl    %cl,%edx
  803c1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 e8                	shr    %cl,%eax
  803c23:	09 c2                	or     %eax,%edx
  803c25:	89 d0                	mov    %edx,%eax
  803c27:	89 f2                	mov    %esi,%edx
  803c29:	f7 74 24 0c          	divl   0xc(%esp)
  803c2d:	89 d6                	mov    %edx,%esi
  803c2f:	89 c3                	mov    %eax,%ebx
  803c31:	f7 e5                	mul    %ebp
  803c33:	39 d6                	cmp    %edx,%esi
  803c35:	72 19                	jb     803c50 <__udivdi3+0xfc>
  803c37:	74 0b                	je     803c44 <__udivdi3+0xf0>
  803c39:	89 d8                	mov    %ebx,%eax
  803c3b:	31 ff                	xor    %edi,%edi
  803c3d:	e9 58 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c42:	66 90                	xchg   %ax,%ax
  803c44:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c48:	89 f9                	mov    %edi,%ecx
  803c4a:	d3 e2                	shl    %cl,%edx
  803c4c:	39 c2                	cmp    %eax,%edx
  803c4e:	73 e9                	jae    803c39 <__udivdi3+0xe5>
  803c50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c53:	31 ff                	xor    %edi,%edi
  803c55:	e9 40 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	31 c0                	xor    %eax,%eax
  803c5e:	e9 37 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c63:	90                   	nop

00803c64 <__umoddi3>:
  803c64:	55                   	push   %ebp
  803c65:	57                   	push   %edi
  803c66:	56                   	push   %esi
  803c67:	53                   	push   %ebx
  803c68:	83 ec 1c             	sub    $0x1c,%esp
  803c6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c83:	89 f3                	mov    %esi,%ebx
  803c85:	89 fa                	mov    %edi,%edx
  803c87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c8b:	89 34 24             	mov    %esi,(%esp)
  803c8e:	85 c0                	test   %eax,%eax
  803c90:	75 1a                	jne    803cac <__umoddi3+0x48>
  803c92:	39 f7                	cmp    %esi,%edi
  803c94:	0f 86 a2 00 00 00    	jbe    803d3c <__umoddi3+0xd8>
  803c9a:	89 c8                	mov    %ecx,%eax
  803c9c:	89 f2                	mov    %esi,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d0                	mov    %edx,%eax
  803ca2:	31 d2                	xor    %edx,%edx
  803ca4:	83 c4 1c             	add    $0x1c,%esp
  803ca7:	5b                   	pop    %ebx
  803ca8:	5e                   	pop    %esi
  803ca9:	5f                   	pop    %edi
  803caa:	5d                   	pop    %ebp
  803cab:	c3                   	ret    
  803cac:	39 f0                	cmp    %esi,%eax
  803cae:	0f 87 ac 00 00 00    	ja     803d60 <__umoddi3+0xfc>
  803cb4:	0f bd e8             	bsr    %eax,%ebp
  803cb7:	83 f5 1f             	xor    $0x1f,%ebp
  803cba:	0f 84 ac 00 00 00    	je     803d6c <__umoddi3+0x108>
  803cc0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cc5:	29 ef                	sub    %ebp,%edi
  803cc7:	89 fe                	mov    %edi,%esi
  803cc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 e0                	shl    %cl,%eax
  803cd1:	89 d7                	mov    %edx,%edi
  803cd3:	89 f1                	mov    %esi,%ecx
  803cd5:	d3 ef                	shr    %cl,%edi
  803cd7:	09 c7                	or     %eax,%edi
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 e2                	shl    %cl,%edx
  803cdd:	89 14 24             	mov    %edx,(%esp)
  803ce0:	89 d8                	mov    %ebx,%eax
  803ce2:	d3 e0                	shl    %cl,%eax
  803ce4:	89 c2                	mov    %eax,%edx
  803ce6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cea:	d3 e0                	shl    %cl,%eax
  803cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf4:	89 f1                	mov    %esi,%ecx
  803cf6:	d3 e8                	shr    %cl,%eax
  803cf8:	09 d0                	or     %edx,%eax
  803cfa:	d3 eb                	shr    %cl,%ebx
  803cfc:	89 da                	mov    %ebx,%edx
  803cfe:	f7 f7                	div    %edi
  803d00:	89 d3                	mov    %edx,%ebx
  803d02:	f7 24 24             	mull   (%esp)
  803d05:	89 c6                	mov    %eax,%esi
  803d07:	89 d1                	mov    %edx,%ecx
  803d09:	39 d3                	cmp    %edx,%ebx
  803d0b:	0f 82 87 00 00 00    	jb     803d98 <__umoddi3+0x134>
  803d11:	0f 84 91 00 00 00    	je     803da8 <__umoddi3+0x144>
  803d17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d1b:	29 f2                	sub    %esi,%edx
  803d1d:	19 cb                	sbb    %ecx,%ebx
  803d1f:	89 d8                	mov    %ebx,%eax
  803d21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d25:	d3 e0                	shl    %cl,%eax
  803d27:	89 e9                	mov    %ebp,%ecx
  803d29:	d3 ea                	shr    %cl,%edx
  803d2b:	09 d0                	or     %edx,%eax
  803d2d:	89 e9                	mov    %ebp,%ecx
  803d2f:	d3 eb                	shr    %cl,%ebx
  803d31:	89 da                	mov    %ebx,%edx
  803d33:	83 c4 1c             	add    $0x1c,%esp
  803d36:	5b                   	pop    %ebx
  803d37:	5e                   	pop    %esi
  803d38:	5f                   	pop    %edi
  803d39:	5d                   	pop    %ebp
  803d3a:	c3                   	ret    
  803d3b:	90                   	nop
  803d3c:	89 fd                	mov    %edi,%ebp
  803d3e:	85 ff                	test   %edi,%edi
  803d40:	75 0b                	jne    803d4d <__umoddi3+0xe9>
  803d42:	b8 01 00 00 00       	mov    $0x1,%eax
  803d47:	31 d2                	xor    %edx,%edx
  803d49:	f7 f7                	div    %edi
  803d4b:	89 c5                	mov    %eax,%ebp
  803d4d:	89 f0                	mov    %esi,%eax
  803d4f:	31 d2                	xor    %edx,%edx
  803d51:	f7 f5                	div    %ebp
  803d53:	89 c8                	mov    %ecx,%eax
  803d55:	f7 f5                	div    %ebp
  803d57:	89 d0                	mov    %edx,%eax
  803d59:	e9 44 ff ff ff       	jmp    803ca2 <__umoddi3+0x3e>
  803d5e:	66 90                	xchg   %ax,%ax
  803d60:	89 c8                	mov    %ecx,%eax
  803d62:	89 f2                	mov    %esi,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	3b 04 24             	cmp    (%esp),%eax
  803d6f:	72 06                	jb     803d77 <__umoddi3+0x113>
  803d71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d75:	77 0f                	ja     803d86 <__umoddi3+0x122>
  803d77:	89 f2                	mov    %esi,%edx
  803d79:	29 f9                	sub    %edi,%ecx
  803d7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d7f:	89 14 24             	mov    %edx,(%esp)
  803d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d8a:	8b 14 24             	mov    (%esp),%edx
  803d8d:	83 c4 1c             	add    $0x1c,%esp
  803d90:	5b                   	pop    %ebx
  803d91:	5e                   	pop    %esi
  803d92:	5f                   	pop    %edi
  803d93:	5d                   	pop    %ebp
  803d94:	c3                   	ret    
  803d95:	8d 76 00             	lea    0x0(%esi),%esi
  803d98:	2b 04 24             	sub    (%esp),%eax
  803d9b:	19 fa                	sbb    %edi,%edx
  803d9d:	89 d1                	mov    %edx,%ecx
  803d9f:	89 c6                	mov    %eax,%esi
  803da1:	e9 71 ff ff ff       	jmp    803d17 <__umoddi3+0xb3>
  803da6:	66 90                	xchg   %ax,%ax
  803da8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dac:	72 ea                	jb     803d98 <__umoddi3+0x134>
  803dae:	89 d9                	mov    %ebx,%ecx
  803db0:	e9 62 ff ff ff       	jmp    803d17 <__umoddi3+0xb3>
