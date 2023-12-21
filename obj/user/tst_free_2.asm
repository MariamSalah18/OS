
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
  800047:	e8 07 28 00 00       	call   802853 <sys_set_uheap_strategy>
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
  80006c:	68 40 3d 80 00       	push   $0x803d40
  800071:	6a 22                	push   $0x22
  800073:	68 5c 3d 80 00       	push   $0x803d5c
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
  800099:	e8 40 23 00 00       	call   8023de <sys_pf_calculate_allocated_pages>
  80009e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000a1:	e8 ed 22 00 00       	call   802393 <sys_calculate_free_frames>
  8000a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 actualSize, block_size, expectedSize, blockIndex;
	int8 block_status;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 70 3d 80 00       	push   $0x803d70
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
  8000fe:	e8 71 1e 00 00       	call   801f74 <malloc>
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
  800142:	68 c8 3d 80 00       	push   $0x803dc8
  800147:	6a 47                	push   $0x47
  800149:	68 5c 3d 80 00       	push   $0x803d5c
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
  8001c4:	e8 ca 21 00 00       	call   802393 <sys_calculate_free_frames>
  8001c9:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 24 3e 80 00       	push   $0x803e24
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
  80020d:	e8 be 1e 00 00       	call   8020d0 <free>
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
  800227:	e8 a4 1e 00 00       	call   8020d0 <free>
  80022c:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[numOfAllocs*allocCntPerSize - 2]) ;
  80022f:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	50                   	push   %eax
  800238:	e8 1c 27 00 00       	call   802959 <get_block_size>
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
  800260:	68 6c 3e 80 00       	push   $0x803e6c
  800265:	e8 df 0e 00 00       	call   801149 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[numOfAllocs*allocCntPerSize-2]) ;
  80026d:	a1 f8 76 80 00       	mov    0x8076f8,%eax
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	50                   	push   %eax
  800276:	e8 f4 26 00 00       	call   80296f <is_free_block>
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
  800291:	68 c8 3e 80 00       	push   $0x803ec8
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
  8002af:	e8 c0 1c 00 00       	call   801f74 <malloc>
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
  8002d3:	68 1c 3f 80 00       	push   $0x803f1c
  8002d8:	e8 6c 0e 00 00       	call   801149 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
		}

		//Free 2nd block
		free(startVAs[1]);
  8002e0:	a1 24 61 80 00       	mov    0x806124,%eax
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	e8 e2 1d 00 00       	call   8020d0 <free>
  8002ee:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[1]) ;
  8002f1:	a1 24 61 80 00       	mov    0x806124,%eax
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	50                   	push   %eax
  8002fa:	e8 5a 26 00 00       	call   802959 <get_block_size>
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
  800322:	68 64 3f 80 00       	push   $0x803f64
  800327:	e8 1d 0e 00 00       	call   801149 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[1]) ;
  80032f:	a1 24 61 80 00       	mov    0x806124,%eax
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	e8 32 26 00 00       	call   80296f <is_free_block>
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
  800353:	68 c0 3f 80 00       	push   $0x803fc0
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
  80036d:	68 14 40 80 00       	push   $0x804014
  800372:	e8 d2 0d 00 00       	call   801149 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	68 4f 40 80 00       	push   $0x80404f
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
  8003a6:	e8 25 1d 00 00       	call   8020d0 <free>
  8003ab:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8003ae:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003b1:	48                   	dec    %eax
  8003b2:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	50                   	push   %eax
  8003bd:	e8 97 25 00 00       	call   802959 <get_block_size>
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
  8003ea:	68 64 40 80 00       	push   $0x804064
  8003ef:	e8 55 0d 00 00       	call   801149 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8003f7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003fa:	48                   	dec    %eax
  8003fb:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	50                   	push   %eax
  800406:	e8 64 25 00 00       	call   80296f <is_free_block>
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
  800421:	68 c4 40 80 00       	push   $0x8040c4
  800426:	e8 1e 0d 00 00       	call   801149 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80042e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800431:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	50                   	push   %eax
  80043c:	e8 18 25 00 00       	call   802959 <get_block_size>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	85 c0                	test   %eax,%eax
  800446:	75 1a                	jne    800462 <_main+0x42a>
  800448:	8b 45 98             	mov    -0x68(%ebp),%eax
  80044b:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800452:	83 ec 0c             	sub    $0xc,%esp
  800455:	50                   	push   %eax
  800456:	e8 14 25 00 00       	call   80296f <is_free_block>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	84 c0                	test   %al,%al
  800460:	74 17                	je     800479 <_main+0x441>
		{
			is_correct = 0;
  800462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	68 18 41 80 00       	push   $0x804118
  800471:	e8 d3 0c 00 00       	call   801149 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	68 80 41 80 00       	push   $0x804180
  800481:	e8 c3 0c 00 00       	call   801149 <cprintf>
  800486:	83 c4 10             	add    $0x10,%esp
		blockIndex = 2*allocCntPerSize+1 ;
  800489:	c7 45 98 91 01 00 00 	movl   $0x191,-0x68(%ebp)
		free(startVAs[blockIndex]);
  800490:	8b 45 98             	mov    -0x68(%ebp),%eax
  800493:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	50                   	push   %eax
  80049e:	e8 2d 1c 00 00       	call   8020d0 <free>
  8004a3:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8004a6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004a9:	48                   	dec    %eax
  8004aa:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	50                   	push   %eax
  8004b5:	e8 9f 24 00 00       	call   802959 <get_block_size>
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
  8004e8:	68 9c 41 80 00       	push   $0x80419c
  8004ed:	e8 57 0c 00 00       	call   801149 <cprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8004f5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004f8:	48                   	dec    %eax
  8004f9:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	50                   	push   %eax
  800504:	e8 66 24 00 00       	call   80296f <is_free_block>
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
  80051f:	68 fc 41 80 00       	push   $0x8041fc
  800524:	e8 20 0c 00 00       	call   801149 <cprintf>
  800529:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80052c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80052f:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	50                   	push   %eax
  80053a:	e8 1a 24 00 00       	call   802959 <get_block_size>
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 c0                	test   %eax,%eax
  800544:	75 1a                	jne    800560 <_main+0x528>
  800546:	8b 45 98             	mov    -0x68(%ebp),%eax
  800549:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 16 24 00 00       	call   80296f <is_free_block>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	84 c0                	test   %al,%al
  80055e:	74 17                	je     800577 <_main+0x53f>
		{
			is_correct = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	68 50 42 80 00       	push   $0x804250
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
  800584:	68 b8 42 80 00       	push   $0x8042b8
  800589:	e8 bb 0b 00 00       	call   801149 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	68 ef 42 80 00       	push   $0x8042ef
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
  8005bd:	e8 0e 1b 00 00       	call   8020d0 <free>
  8005c2:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8005c5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005c8:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	50                   	push   %eax
  8005d3:	e8 81 23 00 00       	call   802959 <get_block_size>
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
  800606:	68 04 43 80 00       	push   $0x804304
  80060b:	e8 39 0b 00 00       	call   801149 <cprintf>
  800610:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800613:	8b 45 98             	mov    -0x68(%ebp),%eax
  800616:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80061d:	83 ec 0c             	sub    $0xc,%esp
  800620:	50                   	push   %eax
  800621:	e8 49 23 00 00       	call   80296f <is_free_block>
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
  80063c:	68 64 43 80 00       	push   $0x804364
  800641:	e8 03 0b 00 00       	call   801149 <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800649:	8b 45 98             	mov    -0x68(%ebp),%eax
  80064c:	40                   	inc    %eax
  80064d:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	50                   	push   %eax
  800658:	e8 fc 22 00 00       	call   802959 <get_block_size>
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	85 c0                	test   %eax,%eax
  800662:	75 1b                	jne    80067f <_main+0x647>
  800664:	8b 45 98             	mov    -0x68(%ebp),%eax
  800667:	40                   	inc    %eax
  800668:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	e8 f7 22 00 00       	call   80296f <is_free_block>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	84 c0                	test   %al,%al
  80067d:	74 17                	je     800696 <_main+0x65e>
		{
			is_correct = 0;
  80067f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800686:	83 ec 0c             	sub    $0xc,%esp
  800689:	68 b8 43 80 00       	push   $0x8043b8
  80068e:	e8 b6 0a 00 00       	call   801149 <cprintf>
  800693:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	68 20 44 80 00       	push   $0x804420
  80069e:	e8 a6 0a 00 00       	call   801149 <cprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
		blockIndex = 1*allocCntPerSize - 1 ;
  8006a6:	c7 45 98 c7 00 00 00 	movl   $0xc7,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8006ad:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006b0:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	50                   	push   %eax
  8006bb:	e8 10 1a 00 00       	call   8020d0 <free>
  8006c0:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8006c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006c6:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	50                   	push   %eax
  8006d1:	e8 83 22 00 00       	call   802959 <get_block_size>
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
  800704:	68 3c 44 80 00       	push   $0x80443c
  800709:	e8 3b 0a 00 00       	call   801149 <cprintf>
  80070e:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800711:	8b 45 98             	mov    -0x68(%ebp),%eax
  800714:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	50                   	push   %eax
  80071f:	e8 4b 22 00 00       	call   80296f <is_free_block>
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
  80073a:	68 9c 44 80 00       	push   $0x80449c
  80073f:	e8 05 0a 00 00       	call   801149 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800747:	8b 45 98             	mov    -0x68(%ebp),%eax
  80074a:	40                   	inc    %eax
  80074b:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 fe 21 00 00       	call   802959 <get_block_size>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	75 1b                	jne    80077d <_main+0x745>
  800762:	8b 45 98             	mov    -0x68(%ebp),%eax
  800765:	40                   	inc    %eax
  800766:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	50                   	push   %eax
  800771:	e8 f9 21 00 00       	call   80296f <is_free_block>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	84 c0                	test   %al,%al
  80077b:	74 17                	je     800794 <_main+0x75c>
		{
			is_correct = 0;
  80077d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	68 f0 44 80 00       	push   $0x8044f0
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
  8007a1:	68 58 45 80 00       	push   $0x804558
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
  8007ca:	e8 01 19 00 00       	call   8020d0 <free>
  8007cf:	83 c4 10             	add    $0x10,%esp

		blockIndex = 4*allocCntPerSize - 1 ;
  8007d2:	c7 45 98 1f 03 00 00 	movl   $0x31f,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8007d9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007dc:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	50                   	push   %eax
  8007e7:	e8 e4 18 00 00       	call   8020d0 <free>
  8007ec:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8007ef:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007f2:	48                   	dec    %eax
  8007f3:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 56 21 00 00       	call   802959 <get_block_size>
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
  800838:	68 98 45 80 00       	push   $0x804598
  80083d:	e8 07 09 00 00       	call   801149 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  800845:	8b 45 98             	mov    -0x68(%ebp),%eax
  800848:	48                   	dec    %eax
  800849:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800850:	83 ec 0c             	sub    $0xc,%esp
  800853:	50                   	push   %eax
  800854:	e8 16 21 00 00       	call   80296f <is_free_block>
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
  80086f:	68 f4 45 80 00       	push   $0x8045f4
  800874:	e8 d0 08 00 00       	call   801149 <cprintf>
  800879:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0 ||
  80087c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80087f:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	50                   	push   %eax
  80088a:	e8 ca 20 00 00       	call   802959 <get_block_size>
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	85 c0                	test   %eax,%eax
  800894:	75 50                	jne    8008e6 <_main+0x8ae>
  800896:	8b 45 98             	mov    -0x68(%ebp),%eax
  800899:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	50                   	push   %eax
  8008a4:	e8 c6 20 00 00       	call   80296f <is_free_block>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	84 c0                	test   %al,%al
  8008ae:	75 36                	jne    8008e6 <_main+0x8ae>
				get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  8008b0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008b3:	40                   	inc    %eax
  8008b4:	8b 04 85 20 61 80 00 	mov    0x806120(,%eax,4),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 95 20 00 00       	call   802959 <get_block_size>
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
  8008da:	e8 90 20 00 00       	call   80296f <is_free_block>
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	84 c0                	test   %al,%al
  8008e4:	74 17                	je     8008fd <_main+0x8c5>
		{
			is_correct = 0;
  8008e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #4.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  8008ed:	83 ec 0c             	sub    $0xc,%esp
  8008f0:	68 48 46 80 00       	push   $0x804648
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
  80090a:	68 b0 46 80 00       	push   $0x8046b0
  80090f:	e8 35 08 00 00       	call   801149 <cprintf>
  800914:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  800917:	83 ec 0c             	sub    $0xc,%esp
  80091a:	68 f0 46 80 00       	push   $0x8046f0
  80091f:	e8 25 08 00 00       	call   801149 <cprintf>
  800924:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800927:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 4*sizeof(int);
  80092e:	c7 45 9c 10 00 00 00 	movl   $0x10,-0x64(%ebp)
		va = malloc(actualSize);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	ff 75 9c             	pushl  -0x64(%ebp)
  80093b:	e8 34 16 00 00       	call   801f74 <malloc>
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
  80096b:	68 18 47 80 00       	push   $0x804718
  800970:	e8 d4 07 00 00       	call   801149 <cprintf>
  800975:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 2*sizeof(int) ;
  800978:	c7 45 9c 08 00 00 00 	movl   $0x8,-0x64(%ebp)
		va = malloc(actualSize);
  80097f:	83 ec 0c             	sub    $0xc,%esp
  800982:	ff 75 9c             	pushl  -0x64(%ebp)
  800985:	e8 ea 15 00 00       	call   801f74 <malloc>
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
  8009b5:	68 78 47 80 00       	push   $0x804778
  8009ba:	e8 8a 07 00 00       	call   801149 <cprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 5*sizeof(int);
  8009c2:	c7 45 9c 14 00 00 00 	movl   $0x14,-0x64(%ebp)
		va = malloc(actualSize);
  8009c9:	83 ec 0c             	sub    $0xc,%esp
  8009cc:	ff 75 9c             	pushl  -0x64(%ebp)
  8009cf:	e8 a0 15 00 00       	call   801f74 <malloc>
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
  800a00:	68 d8 47 80 00       	push   $0x8047d8
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
  800a1a:	68 38 48 80 00       	push   $0x804838
  800a1f:	e8 25 07 00 00       	call   801149 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a27:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 3*kilo/2;
  800a2e:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800a35:	83 ec 0c             	sub    $0xc,%esp
  800a38:	ff 75 9c             	pushl  -0x64(%ebp)
  800a3b:	e8 34 15 00 00       	call   801f74 <malloc>
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
  800a6c:	68 64 48 80 00       	push   $0x804864
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
  800a86:	68 c4 48 80 00       	push   $0x8048c4
  800a8b:	e8 b9 06 00 00       	call   801149 <cprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 30*sizeof(char) ;
  800a9a:	c7 45 9c 1e 00 00 00 	movl   $0x1e,-0x64(%ebp)
		va = malloc(actualSize);
  800aa1:	83 ec 0c             	sub    $0xc,%esp
  800aa4:	ff 75 9c             	pushl  -0x64(%ebp)
  800aa7:	e8 c8 14 00 00       	call   801f74 <malloc>
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
  800ad8:	68 ec 48 80 00       	push   $0x8048ec
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
  800af2:	e8 7d 14 00 00       	call   801f74 <malloc>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		//dummy allocation to consume the 1st 2 KB free block
		{
			va = malloc(actualSize);
  800afd:	83 ec 0c             	sub    $0xc,%esp
  800b00:	ff 75 9c             	pushl  -0x64(%ebp)
  800b03:	e8 6c 14 00 00       	call   801f74 <malloc>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		va = malloc(actualSize);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 9c             	pushl  -0x64(%ebp)
  800b14:	e8 5b 14 00 00       	call   801f74 <malloc>
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
  800b45:	68 4c 49 80 00       	push   $0x80494c
  800b4a:	e8 fa 05 00 00       	call   801149 <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
		}

		actualSize = 3*kilo/2 ;
  800b52:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	ff 75 9c             	pushl  -0x64(%ebp)
  800b5f:	e8 10 14 00 00       	call   801f74 <malloc>
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
  800b95:	68 ac 49 80 00       	push   $0x8049ac
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
  800baf:	68 0c 4a 80 00       	push   $0x804a0c
  800bb4:	e8 90 05 00 00       	call   801149 <cprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800bbc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800bc3:	e8 cb 17 00 00       	call   802393 <sys_calculate_free_frames>
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcd:	39 c2                	cmp    %eax,%edx
  800bcf:	74 17                	je     800be8 <_main+0xbb0>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	68 50 4a 80 00       	push   $0x804a50
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
  800c92:	68 bc 4a 80 00       	push   $0x804abc
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
  800cb0:	e8 bf 12 00 00       	call   801f74 <malloc>
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
  800d0d:	e8 9e 1b 00 00       	call   8028b0 <sys_check_WS_list>
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (chk != 1)
  800d1b:	83 bd 70 ff ff ff 01 	cmpl   $0x1,-0x90(%ebp)
  800d22:	74 17                	je     800d3b <_main+0xd03>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	68 f8 4a 80 00       	push   $0x804af8
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
  800d4b:	68 3c 4b 80 00       	push   $0x804b3c
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
  800d64:	e8 b5 18 00 00       	call   80261e <sys_getenvindex>
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
  800dc1:	e8 65 16 00 00       	call   80242b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	68 a0 4b 80 00       	push   $0x804ba0
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
  800df1:	68 c8 4b 80 00       	push   $0x804bc8
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
  800e22:	68 f0 4b 80 00       	push   $0x804bf0
  800e27:	e8 1d 03 00 00       	call   801149 <cprintf>
  800e2c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e2f:	a1 40 60 80 00       	mov    0x806040,%eax
  800e34:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	50                   	push   %eax
  800e3e:	68 48 4c 80 00       	push   $0x804c48
  800e43:	e8 01 03 00 00       	call   801149 <cprintf>
  800e48:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	68 a0 4b 80 00       	push   $0x804ba0
  800e53:	e8 f1 02 00 00       	call   801149 <cprintf>
  800e58:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e5b:	e8 e5 15 00 00       	call   802445 <sys_enable_interrupt>

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
  800e73:	e8 72 17 00 00       	call   8025ea <sys_destroy_env>
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
  800e84:	e8 c7 17 00 00       	call   802650 <sys_exit_env>
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
  800ead:	68 5c 4c 80 00       	push   $0x804c5c
  800eb2:	e8 92 02 00 00       	call   801149 <cprintf>
  800eb7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800eba:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	50                   	push   %eax
  800ec6:	68 61 4c 80 00       	push   $0x804c61
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
  800eea:	68 7d 4c 80 00       	push   $0x804c7d
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
  800f19:	68 80 4c 80 00       	push   $0x804c80
  800f1e:	6a 26                	push   $0x26
  800f20:	68 cc 4c 80 00       	push   $0x804ccc
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
  800fee:	68 d8 4c 80 00       	push   $0x804cd8
  800ff3:	6a 3a                	push   $0x3a
  800ff5:	68 cc 4c 80 00       	push   $0x804ccc
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
  801061:	68 2c 4d 80 00       	push   $0x804d2c
  801066:	6a 44                	push   $0x44
  801068:	68 cc 4c 80 00       	push   $0x804ccc
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
  8010bb:	e8 12 12 00 00       	call   8022d2 <sys_cputs>
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
  801132:	e8 9b 11 00 00       	call   8022d2 <sys_cputs>
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
  80117c:	e8 aa 12 00 00       	call   80242b <sys_disable_interrupt>
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
  80119c:	e8 a4 12 00 00       	call   802445 <sys_enable_interrupt>
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
  8011e6:	e8 f1 28 00 00       	call   803adc <__udivdi3>
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
  801236:	e8 b1 29 00 00       	call   803bec <__umoddi3>
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	05 94 4f 80 00       	add    $0x804f94,%eax
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
  801391:	8b 04 85 b8 4f 80 00 	mov    0x804fb8(,%eax,4),%eax
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
  801472:	8b 34 9d 00 4e 80 00 	mov    0x804e00(,%ebx,4),%esi
  801479:	85 f6                	test   %esi,%esi
  80147b:	75 19                	jne    801496 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80147d:	53                   	push   %ebx
  80147e:	68 a5 4f 80 00       	push   $0x804fa5
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
  801497:	68 ae 4f 80 00       	push   $0x804fae
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
  8014c4:	be b1 4f 80 00       	mov    $0x804fb1,%esi
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
	return NULL;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801f48:	a1 20 60 80 00       	mov    0x806020,%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	74 0a                	je     801f5b <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f51:	c7 05 20 60 80 00 00 	movl   $0x0,0x806020
  801f58:	00 00 00 
	}
}
  801f5b:	90                   	nop
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    

00801f5e <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	ff 75 08             	pushl  0x8(%ebp)
  801f6a:	e8 7e 09 00 00       	call   8028ed <sys_sbrk>
  801f6f:	83 c4 10             	add    $0x10,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f7a:	e8 c6 ff ff ff       	call   801f45 <InitializeUHeap>
	if (size == 0)
  801f7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f83:	75 0a                	jne    801f8f <malloc+0x1b>
		return NULL;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	e9 3f 01 00 00       	jmp    8020ce <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801f8f:	e8 ac 09 00 00       	call   802940 <sys_get_hard_limit>
  801f94:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801f97:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801fa6:	c1 e8 0c             	shr    $0xc,%eax
  801fa9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801fac:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	48                   	dec    %eax
  801fbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc7:	f7 75 d8             	divl   -0x28(%ebp)
  801fca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcd:	29 d0                	sub    %edx,%eax
  801fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd5:	c1 e8 0c             	shr    $0xc,%eax
  801fd8:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801fdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fdf:	75 0a                	jne    801feb <malloc+0x77>
		return NULL;
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe6:	e9 e3 00 00 00       	jmp    8020ce <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801feb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fee:	05 00 00 00 80       	add    $0x80000000,%eax
  801ff3:	c1 e8 0c             	shr    $0xc,%eax
  801ff6:	a3 20 a3 80 00       	mov    %eax,0x80a320

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801ffb:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802002:	77 19                	ja     80201d <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	e8 44 0b 00 00       	call   802b53 <alloc_block_FF>
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  802015:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802018:	e9 b1 00 00 00       	jmp    8020ce <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80201d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802020:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802023:	eb 4d                	jmp    802072 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  802025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802028:	8a 04 c5 40 a3 80 00 	mov    0x80a340(,%eax,8),%al
  80202f:	84 c0                	test   %al,%al
  802031:	75 27                	jne    80205a <malloc+0xe6>
			{
				counter++;
  802033:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  802036:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80203a:	75 14                	jne    802050 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80203c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203f:	05 00 00 08 00       	add    $0x80000,%eax
  802044:	c1 e0 0c             	shl    $0xc,%eax
  802047:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  80204a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  802050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802053:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802056:	75 17                	jne    80206f <malloc+0xfb>
				{
					break;
  802058:	eb 21                	jmp    80207b <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  80205a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205d:	8a 04 c5 40 a3 80 00 	mov    0x80a340(,%eax,8),%al
  802064:	3c 01                	cmp    $0x1,%al
  802066:	75 07                	jne    80206f <malloc+0xfb>
			{
				counter = 0;
  802068:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80206f:	ff 45 e8             	incl   -0x18(%ebp)
  802072:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  802079:	76 aa                	jbe    802025 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802081:	75 46                	jne    8020c9 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 d0             	pushl  -0x30(%ebp)
  802089:	ff 75 f4             	pushl  -0xc(%ebp)
  80208c:	e8 93 08 00 00       	call   802924 <sys_allocate_user_mem>
  802091:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80209a:	89 14 c5 44 a3 80 00 	mov    %edx,0x80a344(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020a7:	eb 0e                	jmp    8020b7 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8020a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ac:	c6 04 c5 40 a3 80 00 	movb   $0x1,0x80a340(,%eax,8)
  8020b3:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8020b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8020b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020c2:	77 e5                	ja     8020a9 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	eb 05                	jmp    8020ce <malloc+0x15a>
		}
	}

	return NULL;
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8020d6:	e8 65 08 00 00       	call   802940 <sys_get_hard_limit>
  8020db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8020e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e8:	0f 84 c1 00 00 00    	je     8021af <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	79 1b                	jns    802110 <free+0x40>
  8020f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020fb:	73 13                	jae    802110 <free+0x40>
    {
        free_block(virtual_address);
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	e8 18 10 00 00       	call   803120 <free_block>
  802108:	83 c4 10             	add    $0x10,%esp
    	return;
  80210b:	e9 a6 00 00 00       	jmp    8021b6 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  802110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802113:	05 00 10 00 00       	add    $0x1000,%eax
  802118:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80211b:	0f 87 91 00 00 00    	ja     8021b2 <free+0xe2>
  802121:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802128:	0f 87 84 00 00 00    	ja     8021b2 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802131:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802137:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80213c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	05 00 00 00 80       	add    $0x80000000,%eax
  802147:	c1 e8 0c             	shr    $0xc,%eax
  80214a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80214d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802150:	8b 04 c5 44 a3 80 00 	mov    0x80a344(,%eax,8),%eax
  802157:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  80215a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80215e:	74 55                	je     8021b5 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  802160:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802163:	c1 e8 0c             	shr    $0xc,%eax
  802166:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  802169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216c:	c7 04 c5 44 a3 80 00 	movl   $0x0,0x80a344(,%eax,8)
  802173:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  802177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217d:	eb 0e                	jmp    80218d <free+0xbd>
	{
		userArr[i].is_allocated=0;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	c6 04 c5 40 a3 80 00 	movb   $0x0,0x80a340(,%eax,8)
  802189:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  80218a:	ff 45 f4             	incl   -0xc(%ebp)
  80218d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802193:	01 c2                	add    %eax,%edx
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	39 c2                	cmp    %eax,%edx
  80219a:	77 e3                	ja     80217f <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  80219c:	83 ec 08             	sub    $0x8,%esp
  80219f:	ff 75 e0             	pushl  -0x20(%ebp)
  8021a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8021a5:	e8 5e 07 00 00       	call   802908 <sys_free_user_mem>
  8021aa:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8021ad:	eb 07                	jmp    8021b6 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8021af:	90                   	nop
  8021b0:	eb 04                	jmp    8021b6 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8021b2:	90                   	nop
  8021b3:	eb 01                	jmp    8021b6 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8021b5:	90                   	nop
    else
     {
    	return;
      }

}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 18             	sub    $0x18,%esp
  8021be:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021c4:	e8 7c fd ff ff       	call   801f45 <InitializeUHeap>
	if (size == 0)
  8021c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021cd:	75 07                	jne    8021d6 <smalloc+0x1e>
		return NULL;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	eb 17                	jmp    8021ed <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 10 51 80 00       	push   $0x805110
  8021de:	68 ad 00 00 00       	push   $0xad
  8021e3:	68 36 51 80 00       	push   $0x805136
  8021e8:	e8 9f ec ff ff       	call   800e8c <_panic>
	return NULL;
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021f5:	e8 4b fd ff ff       	call   801f45 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 44 51 80 00       	push   $0x805144
  802202:	68 ba 00 00 00       	push   $0xba
  802207:	68 36 51 80 00       	push   $0x805136
  80220c:	e8 7b ec ff ff       	call   800e8c <_panic>

00802211 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802217:	e8 29 fd ff ff       	call   801f45 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	68 68 51 80 00       	push   $0x805168
  802224:	68 d8 00 00 00       	push   $0xd8
  802229:	68 36 51 80 00       	push   $0x805136
  80222e:	e8 59 ec ff ff       	call   800e8c <_panic>

00802233 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	68 90 51 80 00       	push   $0x805190
  802241:	68 ea 00 00 00       	push   $0xea
  802246:	68 36 51 80 00       	push   $0x805136
  80224b:	e8 3c ec ff ff       	call   800e8c <_panic>

00802250 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 b4 51 80 00       	push   $0x8051b4
  80225e:	68 f2 00 00 00       	push   $0xf2
  802263:	68 36 51 80 00       	push   $0x805136
  802268:	e8 1f ec ff ff       	call   800e8c <_panic>

0080226d <shrink>:

}
void shrink(uint32 newSize) {
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 b4 51 80 00       	push   $0x8051b4
  80227b:	68 f6 00 00 00       	push   $0xf6
  802280:	68 36 51 80 00       	push   $0x805136
  802285:	e8 02 ec ff ff       	call   800e8c <_panic>

0080228a <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 b4 51 80 00       	push   $0x8051b4
  802298:	68 fa 00 00 00       	push   $0xfa
  80229d:	68 36 51 80 00       	push   $0x805136
  8022a2:	e8 e5 eb ff ff       	call   800e8c <_panic>

008022a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	57                   	push   %edi
  8022ab:	56                   	push   %esi
  8022ac:	53                   	push   %ebx
  8022ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022c2:	cd 30                	int    $0x30
  8022c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5e                   	pop    %esi
  8022cf:	5f                   	pop    %edi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    

008022d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	52                   	push   %edx
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	50                   	push   %eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	e8 b2 ff ff ff       	call   8022a7 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	90                   	nop
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 01                	push   $0x1
  80230a:	e8 98 ff ff ff       	call   8022a7 <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	52                   	push   %edx
  802324:	50                   	push   %eax
  802325:	6a 05                	push   $0x5
  802327:	e8 7b ff ff ff       	call   8022a7 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	56                   	push   %esi
  802335:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802336:	8b 75 18             	mov    0x18(%ebp),%esi
  802339:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	56                   	push   %esi
  802346:	53                   	push   %ebx
  802347:	51                   	push   %ecx
  802348:	52                   	push   %edx
  802349:	50                   	push   %eax
  80234a:	6a 06                	push   $0x6
  80234c:	e8 56 ff ff ff       	call   8022a7 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    

0080235b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80235e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	52                   	push   %edx
  80236b:	50                   	push   %eax
  80236c:	6a 07                	push   $0x7
  80236e:	e8 34 ff ff ff       	call   8022a7 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	ff 75 0c             	pushl  0xc(%ebp)
  802384:	ff 75 08             	pushl  0x8(%ebp)
  802387:	6a 08                	push   $0x8
  802389:	e8 19 ff ff ff       	call   8022a7 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 09                	push   $0x9
  8023a2:	e8 00 ff ff ff       	call   8022a7 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 0a                	push   $0xa
  8023bb:	e8 e7 fe ff ff       	call   8022a7 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 0b                	push   $0xb
  8023d4:	e8 ce fe ff ff       	call   8022a7 <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 0c                	push   $0xc
  8023ed:	e8 b5 fe ff ff       	call   8022a7 <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	ff 75 08             	pushl  0x8(%ebp)
  802405:	6a 0d                	push   $0xd
  802407:	e8 9b fe ff ff       	call   8022a7 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 0e                	push   $0xe
  802420:	e8 82 fe ff ff       	call   8022a7 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	90                   	nop
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 11                	push   $0x11
  80243a:	e8 68 fe ff ff       	call   8022a7 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	90                   	nop
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 12                	push   $0x12
  802454:	e8 4e fe ff ff       	call   8022a7 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	90                   	nop
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_cputc>:


void
sys_cputc(const char c)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80246b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	50                   	push   %eax
  802478:	6a 13                	push   $0x13
  80247a:	e8 28 fe ff ff       	call   8022a7 <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
}
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 14                	push   $0x14
  802494:	e8 0e fe ff ff       	call   8022a7 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	90                   	nop
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	ff 75 0c             	pushl  0xc(%ebp)
  8024ae:	50                   	push   %eax
  8024af:	6a 15                	push   $0x15
  8024b1:	e8 f1 fd ff ff       	call   8022a7 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	52                   	push   %edx
  8024cb:	50                   	push   %eax
  8024cc:	6a 18                	push   $0x18
  8024ce:	e8 d4 fd ff ff       	call   8022a7 <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	52                   	push   %edx
  8024e8:	50                   	push   %eax
  8024e9:	6a 16                	push   $0x16
  8024eb:	e8 b7 fd ff ff       	call   8022a7 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	90                   	nop
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 17                	push   $0x17
  802509:	e8 99 fd ff ff       	call   8022a7 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	90                   	nop
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	8b 45 10             	mov    0x10(%ebp),%eax
  80251d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802520:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802523:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	6a 00                	push   $0x0
  80252c:	51                   	push   %ecx
  80252d:	52                   	push   %edx
  80252e:	ff 75 0c             	pushl  0xc(%ebp)
  802531:	50                   	push   %eax
  802532:	6a 19                	push   $0x19
  802534:	e8 6e fd ff ff       	call   8022a7 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802541:	8b 55 0c             	mov    0xc(%ebp),%edx
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	52                   	push   %edx
  80254e:	50                   	push   %eax
  80254f:	6a 1a                	push   $0x1a
  802551:	e8 51 fd ff ff       	call   8022a7 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80255e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802561:	8b 55 0c             	mov    0xc(%ebp),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	51                   	push   %ecx
  80256c:	52                   	push   %edx
  80256d:	50                   	push   %eax
  80256e:	6a 1b                	push   $0x1b
  802570:	e8 32 fd ff ff       	call   8022a7 <syscall>
  802575:	83 c4 18             	add    $0x18,%esp
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80257d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	52                   	push   %edx
  80258a:	50                   	push   %eax
  80258b:	6a 1c                	push   $0x1c
  80258d:	e8 15 fd ff ff       	call   8022a7 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 1d                	push   $0x1d
  8025a6:	e8 fc fc ff ff       	call   8022a7 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	6a 00                	push   $0x0
  8025b8:	ff 75 14             	pushl  0x14(%ebp)
  8025bb:	ff 75 10             	pushl  0x10(%ebp)
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	50                   	push   %eax
  8025c2:	6a 1e                	push   $0x1e
  8025c4:	e8 de fc ff ff       	call   8022a7 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	50                   	push   %eax
  8025dd:	6a 1f                	push   $0x1f
  8025df:	e8 c3 fc ff ff       	call   8022a7 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	90                   	nop
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	50                   	push   %eax
  8025f9:	6a 20                	push   $0x20
  8025fb:	e8 a7 fc ff ff       	call   8022a7 <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 02                	push   $0x2
  802614:	e8 8e fc ff ff       	call   8022a7 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 03                	push   $0x3
  80262d:	e8 75 fc ff ff       	call   8022a7 <syscall>
  802632:	83 c4 18             	add    $0x18,%esp
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 04                	push   $0x4
  802646:	e8 5c fc ff ff       	call   8022a7 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <sys_exit_env>:


void sys_exit_env(void)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 21                	push   $0x21
  80265f:	e8 43 fc ff ff       	call   8022a7 <syscall>
  802664:	83 c4 18             	add    $0x18,%esp
}
  802667:	90                   	nop
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802670:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802673:	8d 50 04             	lea    0x4(%eax),%edx
  802676:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	52                   	push   %edx
  802680:	50                   	push   %eax
  802681:	6a 22                	push   $0x22
  802683:	e8 1f fc ff ff       	call   8022a7 <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
	return result;
  80268b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802691:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802694:	89 01                	mov    %eax,(%ecx)
  802696:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	c9                   	leave  
  80269d:	c2 04 00             	ret    $0x4

008026a0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	ff 75 10             	pushl  0x10(%ebp)
  8026aa:	ff 75 0c             	pushl  0xc(%ebp)
  8026ad:	ff 75 08             	pushl  0x8(%ebp)
  8026b0:	6a 10                	push   $0x10
  8026b2:	e8 f0 fb ff ff       	call   8022a7 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ba:	90                   	nop
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_rcr2>:
uint32 sys_rcr2()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 23                	push   $0x23
  8026cc:	e8 d6 fb ff ff       	call   8022a7 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 04             	sub    $0x4,%esp
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026e2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	50                   	push   %eax
  8026ef:	6a 24                	push   $0x24
  8026f1:	e8 b1 fb ff ff       	call   8022a7 <syscall>
  8026f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f9:	90                   	nop
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <rsttst>:
void rsttst()
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 26                	push   $0x26
  80270b:	e8 97 fb ff ff       	call   8022a7 <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
	return ;
  802713:	90                   	nop
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	8b 45 14             	mov    0x14(%ebp),%eax
  80271f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802722:	8b 55 18             	mov    0x18(%ebp),%edx
  802725:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802729:	52                   	push   %edx
  80272a:	50                   	push   %eax
  80272b:	ff 75 10             	pushl  0x10(%ebp)
  80272e:	ff 75 0c             	pushl  0xc(%ebp)
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	6a 25                	push   $0x25
  802736:	e8 6c fb ff ff       	call   8022a7 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
	return ;
  80273e:	90                   	nop
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <chktst>:
void chktst(uint32 n)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	ff 75 08             	pushl  0x8(%ebp)
  80274f:	6a 27                	push   $0x27
  802751:	e8 51 fb ff ff       	call   8022a7 <syscall>
  802756:	83 c4 18             	add    $0x18,%esp
	return ;
  802759:	90                   	nop
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <inctst>:

void inctst()
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 28                	push   $0x28
  80276b:	e8 37 fb ff ff       	call   8022a7 <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
	return ;
  802773:	90                   	nop
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <gettst>:
uint32 gettst()
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 29                	push   $0x29
  802785:	e8 1d fb ff ff       	call   8022a7 <syscall>
  80278a:	83 c4 18             	add    $0x18,%esp
}
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 2a                	push   $0x2a
  8027a1:	e8 01 fb ff ff       	call   8022a7 <syscall>
  8027a6:	83 c4 18             	add    $0x18,%esp
  8027a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027ac:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027b0:	75 07                	jne    8027b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b7:	eb 05                	jmp    8027be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 2a                	push   $0x2a
  8027d2:	e8 d0 fa ff ff       	call   8022a7 <syscall>
  8027d7:	83 c4 18             	add    $0x18,%esp
  8027da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027dd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027e1:	75 07                	jne    8027ea <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e8:	eb 05                	jmp    8027ef <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 2a                	push   $0x2a
  802803:	e8 9f fa ff ff       	call   8022a7 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
  80280b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80280e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802812:	75 07                	jne    80281b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802814:	b8 01 00 00 00       	mov    $0x1,%eax
  802819:	eb 05                	jmp    802820 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 2a                	push   $0x2a
  802834:	e8 6e fa ff ff       	call   8022a7 <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
  80283c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80283f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802843:	75 07                	jne    80284c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802845:	b8 01 00 00 00       	mov    $0x1,%eax
  80284a:	eb 05                	jmp    802851 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	ff 75 08             	pushl  0x8(%ebp)
  802861:	6a 2b                	push   $0x2b
  802863:	e8 3f fa ff ff       	call   8022a7 <syscall>
  802868:	83 c4 18             	add    $0x18,%esp
	return ;
  80286b:	90                   	nop
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802872:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802875:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	6a 00                	push   $0x0
  802880:	53                   	push   %ebx
  802881:	51                   	push   %ecx
  802882:	52                   	push   %edx
  802883:	50                   	push   %eax
  802884:	6a 2c                	push   $0x2c
  802886:	e8 1c fa ff ff       	call   8022a7 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
}
  80288e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802896:	8b 55 0c             	mov    0xc(%ebp),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	52                   	push   %edx
  8028a3:	50                   	push   %eax
  8028a4:	6a 2d                	push   $0x2d
  8028a6:	e8 fc f9 ff ff       	call   8022a7 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8028b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	6a 00                	push   $0x0
  8028be:	51                   	push   %ecx
  8028bf:	ff 75 10             	pushl  0x10(%ebp)
  8028c2:	52                   	push   %edx
  8028c3:	50                   	push   %eax
  8028c4:	6a 2e                	push   $0x2e
  8028c6:	e8 dc f9 ff ff       	call   8022a7 <syscall>
  8028cb:	83 c4 18             	add    $0x18,%esp
}
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	ff 75 10             	pushl  0x10(%ebp)
  8028da:	ff 75 0c             	pushl  0xc(%ebp)
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	6a 0f                	push   $0xf
  8028e2:	e8 c0 f9 ff ff       	call   8022a7 <syscall>
  8028e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ea:	90                   	nop
}
  8028eb:	c9                   	leave  
  8028ec:	c3                   	ret    

008028ed <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	50                   	push   %eax
  8028fc:	6a 2f                	push   $0x2f
  8028fe:	e8 a4 f9 ff ff       	call   8022a7 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp

}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	ff 75 0c             	pushl  0xc(%ebp)
  802914:	ff 75 08             	pushl  0x8(%ebp)
  802917:	6a 30                	push   $0x30
  802919:	e8 89 f9 ff ff       	call   8022a7 <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
	return;
  802921:	90                   	nop
}
  802922:	c9                   	leave  
  802923:	c3                   	ret    

00802924 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	ff 75 0c             	pushl  0xc(%ebp)
  802930:	ff 75 08             	pushl  0x8(%ebp)
  802933:	6a 31                	push   $0x31
  802935:	e8 6d f9 ff ff       	call   8022a7 <syscall>
  80293a:	83 c4 18             	add    $0x18,%esp
	return;
  80293d:	90                   	nop
}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 32                	push   $0x32
  80294f:	e8 53 f9 ff ff       	call   8022a7 <syscall>
  802954:	83 c4 18             	add    $0x18,%esp
}
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
  80295c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	83 e8 10             	sub    $0x10,%eax
  802965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
}
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	83 e8 10             	sub    $0x10,%eax
  80297b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  80297e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802981:	8a 40 04             	mov    0x4(%eax),%al
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80298c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802993:	8b 45 0c             	mov    0xc(%ebp),%eax
  802996:	83 f8 02             	cmp    $0x2,%eax
  802999:	74 2b                	je     8029c6 <alloc_block+0x40>
  80299b:	83 f8 02             	cmp    $0x2,%eax
  80299e:	7f 07                	jg     8029a7 <alloc_block+0x21>
  8029a0:	83 f8 01             	cmp    $0x1,%eax
  8029a3:	74 0e                	je     8029b3 <alloc_block+0x2d>
  8029a5:	eb 58                	jmp    8029ff <alloc_block+0x79>
  8029a7:	83 f8 03             	cmp    $0x3,%eax
  8029aa:	74 2d                	je     8029d9 <alloc_block+0x53>
  8029ac:	83 f8 04             	cmp    $0x4,%eax
  8029af:	74 3b                	je     8029ec <alloc_block+0x66>
  8029b1:	eb 4c                	jmp    8029ff <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8029b3:	83 ec 0c             	sub    $0xc,%esp
  8029b6:	ff 75 08             	pushl  0x8(%ebp)
  8029b9:	e8 95 01 00 00       	call   802b53 <alloc_block_FF>
  8029be:	83 c4 10             	add    $0x10,%esp
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029c4:	eb 4a                	jmp    802a10 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	ff 75 08             	pushl  0x8(%ebp)
  8029cc:	e8 32 07 00 00       	call   803103 <alloc_block_NF>
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029d7:	eb 37                	jmp    802a10 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	ff 75 08             	pushl  0x8(%ebp)
  8029df:	e8 a3 04 00 00       	call   802e87 <alloc_block_BF>
  8029e4:	83 c4 10             	add    $0x10,%esp
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029ea:	eb 24                	jmp    802a10 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8029ec:	83 ec 0c             	sub    $0xc,%esp
  8029ef:	ff 75 08             	pushl  0x8(%ebp)
  8029f2:	e8 ef 06 00 00       	call   8030e6 <alloc_block_WF>
  8029f7:	83 c4 10             	add    $0x10,%esp
  8029fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029fd:	eb 11                	jmp    802a10 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	68 c4 51 80 00       	push   $0x8051c4
  802a07:	e8 3d e7 ff ff       	call   801149 <cprintf>
  802a0c:	83 c4 10             	add    $0x10,%esp
		break;
  802a0f:	90                   	nop
	}
	return va;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	68 e4 51 80 00       	push   $0x8051e4
  802a23:	e8 21 e7 ff ff       	call   801149 <cprintf>
  802a28:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802a2b:	83 ec 0c             	sub    $0xc,%esp
  802a2e:	68 0f 52 80 00       	push   $0x80520f
  802a33:	e8 11 e7 ff ff       	call   801149 <cprintf>
  802a38:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a41:	eb 26                	jmp    802a69 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8a 40 04             	mov    0x4(%eax),%al
  802a49:	0f b6 d0             	movzbl %al,%edx
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	52                   	push   %edx
  802a55:	50                   	push   %eax
  802a56:	68 27 52 80 00       	push   $0x805227
  802a5b:	e8 e9 e6 ff ff       	call   801149 <cprintf>
  802a60:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802a63:	8b 45 10             	mov    0x10(%ebp),%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6d:	74 08                	je     802a77 <print_blocks_list+0x62>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 08             	mov    0x8(%eax),%eax
  802a75:	eb 05                	jmp    802a7c <print_blocks_list+0x67>
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7c:	89 45 10             	mov    %eax,0x10(%ebp)
  802a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 bd                	jne    802a43 <print_blocks_list+0x2e>
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	75 b7                	jne    802a43 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802a8c:	83 ec 0c             	sub    $0xc,%esp
  802a8f:	68 e4 51 80 00       	push   $0x8051e4
  802a94:	e8 b0 e6 ff ff       	call   801149 <cprintf>
  802a99:	83 c4 10             	add    $0x10,%esp

}
  802a9c:	90                   	nop
  802a9d:	c9                   	leave  
  802a9e:	c3                   	ret    

00802a9f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802aa5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aa9:	0f 84 a1 00 00 00    	je     802b50 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802aaf:	c7 05 4c 60 80 00 01 	movl   $0x1,0x80604c
  802ab6:	00 00 00 
	LIST_INIT(&list);
  802ab9:	c7 05 40 a3 90 00 00 	movl   $0x0,0x90a340
  802ac0:	00 00 00 
  802ac3:	c7 05 44 a3 90 00 00 	movl   $0x0,0x90a344
  802aca:	00 00 00 
  802acd:	c7 05 4c a3 90 00 00 	movl   $0x0,0x90a34c
  802ad4:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aea:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af0:	75 14                	jne    802b06 <initialize_dynamic_allocator+0x67>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 40 52 80 00       	push   $0x805240
  802afa:	6a 64                	push   $0x64
  802afc:	68 63 52 80 00       	push   $0x805263
  802b01:	e8 86 e3 ff ff       	call   800e8c <_panic>
  802b06:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 0c             	mov    0xc(%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 0d                	je     802b29 <initialize_dynamic_allocator+0x8a>
  802b1c:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b24:	89 50 08             	mov    %edx,0x8(%eax)
  802b27:	eb 08                	jmp    802b31 <initialize_dynamic_allocator+0x92>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b43:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802b48:	40                   	inc    %eax
  802b49:	a3 4c a3 90 00       	mov    %eax,0x90a34c
  802b4e:	eb 01                	jmp    802b51 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802b50:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
  802b56:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802b59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5d:	75 0a                	jne    802b69 <alloc_block_FF+0x16>
	{
		return NULL;
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b64:	e9 1c 03 00 00       	jmp    802e85 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802b69:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	75 40                	jne    802bb2 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	83 c0 10             	add    $0x10,%eax
  802b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	83 ec 0c             	sub    $0xc,%esp
  802b81:	50                   	push   %eax
  802b82:	e8 d7 f3 ff ff       	call   801f5e <sbrk>
  802b87:	83 c4 10             	add    $0x10,%esp
  802b8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802b8d:	83 ec 0c             	sub    $0xc,%esp
  802b90:	6a 00                	push   $0x0
  802b92:	e8 c7 f3 ff ff       	call   801f5e <sbrk>
  802b97:	83 c4 10             	add    $0x10,%esp
  802b9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802ba3:	83 ec 08             	sub    $0x8,%esp
  802ba6:	50                   	push   %eax
  802ba7:	ff 75 ec             	pushl  -0x14(%ebp)
  802baa:	e8 f0 fe ff ff       	call   802a9f <initialize_dynamic_allocator>
  802baf:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802bb2:	a1 40 a3 90 00       	mov    0x90a340,%eax
  802bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bba:	e9 1e 01 00 00       	jmp    802cdd <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8d 50 10             	lea    0x10(%eax),%edx
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	75 1c                	jne    802bea <alloc_block_FF+0x97>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8a 40 04             	mov    0x4(%eax),%al
  802bd4:	3c 01                	cmp    $0x1,%al
  802bd6:	75 12                	jne    802bea <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	83 c0 10             	add    $0x10,%eax
  802be5:	e9 9b 02 00 00       	jmp    802e85 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	8d 50 10             	lea    0x10(%eax),%edx
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	39 c2                	cmp    %eax,%edx
  802bf7:	0f 83 d8 00 00 00    	jae    802cd5 <alloc_block_FF+0x182>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8a 40 04             	mov    0x4(%eax),%al
  802c03:	3c 01                	cmp    $0x1,%al
  802c05:	0f 85 ca 00 00 00    	jne    802cd5 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	2b 45 08             	sub    0x8(%ebp),%eax
  802c13:	83 e8 10             	sub    $0x10,%eax
  802c16:	83 f8 0f             	cmp    $0xf,%eax
  802c19:	0f 86 a4 00 00 00    	jbe    802cc3 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	01 d0                	add    %edx,%eax
  802c27:	83 c0 10             	add    $0x10,%eax
  802c2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	2b 45 08             	sub    0x8(%ebp),%eax
  802c35:	8d 50 f0             	lea    -0x10(%eax),%edx
  802c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c3b:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802c3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c40:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c48:	74 06                	je     802c50 <alloc_block_FF+0xfd>
  802c4a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802c4e:	75 17                	jne    802c67 <alloc_block_FF+0x114>
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 7c 52 80 00       	push   $0x80527c
  802c58:	68 8f 00 00 00       	push   $0x8f
  802c5d:	68 63 52 80 00       	push   $0x805263
  802c62:	e8 25 e2 ff ff       	call   800e8c <_panic>
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 50 08             	mov    0x8(%eax),%edx
  802c6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c70:	89 50 08             	mov    %edx,0x8(%eax)
  802c73:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0c                	je     802c89 <alloc_block_FF+0x136>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c86:	89 50 0c             	mov    %edx,0xc(%eax)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c8f:	89 50 08             	mov    %edx,0x8(%eax)
  802c92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c98:	89 50 0c             	mov    %edx,0xc(%eax)
  802c9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	75 08                	jne    802cad <alloc_block_FF+0x15a>
  802ca5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ca8:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802cad:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		    iterator->size = size + sizeOfMetaData();
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8d 50 10             	lea    0x10(%eax),%edx
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	83 c0 10             	add    $0x10,%eax
  802cd0:	e9 b0 01 00 00       	jmp    802e85 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802cd5:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce1:	74 08                	je     802ceb <alloc_block_FF+0x198>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 08             	mov    0x8(%eax),%eax
  802ce9:	eb 05                	jmp    802cf0 <alloc_block_FF+0x19d>
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	a3 48 a3 90 00       	mov    %eax,0x90a348
  802cf5:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	0f 85 bd fe ff ff    	jne    802bbf <alloc_block_FF+0x6c>
  802d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d06:	0f 85 b3 fe ff ff    	jne    802bbf <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	83 c0 10             	add    $0x10,%eax
  802d12:	83 ec 0c             	sub    $0xc,%esp
  802d15:	50                   	push   %eax
  802d16:	e8 43 f2 ff ff       	call   801f5e <sbrk>
  802d1b:	83 c4 10             	add    $0x10,%esp
  802d1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	6a 00                	push   $0x0
  802d26:	e8 33 f2 ff ff       	call   801f5e <sbrk>
  802d2b:	83 c4 10             	add    $0x10,%esp
  802d2e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802d31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	29 c2                	sub    %eax,%edx
  802d39:	89 d0                	mov    %edx,%eax
  802d3b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802d3e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802d42:	0f 84 38 01 00 00    	je     802e80 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802d4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d52:	75 17                	jne    802d6b <alloc_block_FF+0x218>
  802d54:	83 ec 04             	sub    $0x4,%esp
  802d57:	68 40 52 80 00       	push   $0x805240
  802d5c:	68 9f 00 00 00       	push   $0x9f
  802d61:	68 63 52 80 00       	push   $0x805263
  802d66:	e8 21 e1 ff ff       	call   800e8c <_panic>
  802d6b:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802d71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d74:	89 50 0c             	mov    %edx,0xc(%eax)
  802d77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0d                	je     802d8e <alloc_block_FF+0x23b>
  802d81:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802d86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d89:	89 50 08             	mov    %edx,0x8(%eax)
  802d8c:	eb 08                	jmp    802d96 <alloc_block_FF+0x243>
  802d8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d91:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802d96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d99:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802d9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802da1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802da8:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 4c a3 90 00       	mov    %eax,0x90a34c
			newBlock->size = size + sizeOfMetaData();
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8d 50 10             	lea    0x10(%eax),%edx
  802db9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dbc:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802dbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dc1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dcb:	83 f8 10             	cmp    $0x10,%eax
  802dce:	0f 84 a4 00 00 00    	je     802e78 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd7:	2b 45 08             	sub    0x8(%ebp),%eax
  802dda:	83 e8 10             	sub    $0x10,%eax
  802ddd:	83 f8 0f             	cmp    $0xf,%eax
  802de0:	0f 86 8a 00 00 00    	jbe    802e70 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802de6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	01 d0                	add    %edx,%eax
  802dee:	83 c0 10             	add    $0x10,%eax
  802df1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802df4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802df8:	75 17                	jne    802e11 <alloc_block_FF+0x2be>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 40 52 80 00       	push   $0x805240
  802e02:	68 a7 00 00 00       	push   $0xa7
  802e07:	68 63 52 80 00       	push   $0x805263
  802e0c:	e8 7b e0 ff ff       	call   800e8c <_panic>
  802e11:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  802e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e1a:	89 50 0c             	mov    %edx,0xc(%eax)
  802e1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0d                	je     802e34 <alloc_block_FF+0x2e1>
  802e27:	a1 44 a3 90 00       	mov    0x90a344,%eax
  802e2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e2f:	89 50 08             	mov    %edx,0x8(%eax)
  802e32:	eb 08                	jmp    802e3c <alloc_block_FF+0x2e9>
  802e34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e37:	a3 40 a3 90 00       	mov    %eax,0x90a340
  802e3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e3f:	a3 44 a3 90 00       	mov    %eax,0x90a344
  802e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e4e:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  802e53:	40                   	inc    %eax
  802e54:	a3 4c a3 90 00       	mov    %eax,0x90a34c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5f:	8d 50 f0             	lea    -0x10(%eax),%edx
  802e62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e65:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802e67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802e6e:	eb 08                	jmp    802e78 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802e70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e73:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e76:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802e78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e7b:	83 c0 10             	add    $0x10,%eax
  802e7e:	eb 05                	jmp    802e85 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802e80:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802e85:	c9                   	leave  
  802e86:	c3                   	ret    

00802e87 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e87:	55                   	push   %ebp
  802e88:	89 e5                	mov    %esp,%ebp
  802e8a:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802e8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e98:	75 0a                	jne    802ea4 <alloc_block_BF+0x1d>
	{
		return NULL;
  802e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9f:	e9 40 02 00 00       	jmp    8030e4 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802ea4:	a1 40 a3 90 00       	mov    0x90a340,%eax
  802ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eac:	eb 66                	jmp    802f14 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8a 40 04             	mov    0x4(%eax),%al
  802eb4:	3c 01                	cmp    $0x1,%al
  802eb6:	75 21                	jne    802ed9 <alloc_block_BF+0x52>
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8d 50 10             	lea    0x10(%eax),%edx
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	75 12                	jne    802ed9 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	83 c0 10             	add    $0x10,%eax
  802ed4:	e9 0b 02 00 00       	jmp    8030e4 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8a 40 04             	mov    0x4(%eax),%al
  802edf:	3c 01                	cmp    $0x1,%al
  802ee1:	75 29                	jne    802f0c <alloc_block_BF+0x85>
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8d 50 10             	lea    0x10(%eax),%edx
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	39 c2                	cmp    %eax,%edx
  802ef0:	77 1a                	ja     802f0c <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802ef2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef6:	74 0e                	je     802f06 <alloc_block_BF+0x7f>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 10                	mov    (%eax),%edx
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	39 c2                	cmp    %eax,%edx
  802f04:	73 06                	jae    802f0c <alloc_block_BF+0x85>
			{
				BF = iterator;
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802f0c:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f18:	74 08                	je     802f22 <alloc_block_BF+0x9b>
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	eb 05                	jmp    802f27 <alloc_block_BF+0xa0>
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	a3 48 a3 90 00       	mov    %eax,0x90a348
  802f2c:	a1 48 a3 90 00       	mov    0x90a348,%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	0f 85 75 ff ff ff    	jne    802eae <alloc_block_BF+0x27>
  802f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3d:	0f 85 6b ff ff ff    	jne    802eae <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802f43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f47:	0f 84 f8 00 00 00    	je     803045 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8d 50 10             	lea    0x10(%eax),%edx
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	39 c2                	cmp    %eax,%edx
  802f5a:	0f 87 e5 00 00 00    	ja     803045 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	2b 45 08             	sub    0x8(%ebp),%eax
  802f68:	83 e8 10             	sub    $0x10,%eax
  802f6b:	83 f8 0f             	cmp    $0xf,%eax
  802f6e:	0f 86 bf 00 00 00    	jbe    803033 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	01 d0                	add    %edx,%eax
  802f7c:	83 c0 10             	add    $0x10,%eax
  802f7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	2b 45 08             	sub    0x8(%ebp),%eax
  802f93:	8d 50 f0             	lea    -0x10(%eax),%edx
  802f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f99:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802fa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa6:	74 06                	je     802fae <alloc_block_BF+0x127>
  802fa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fac:	75 17                	jne    802fc5 <alloc_block_BF+0x13e>
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	68 7c 52 80 00       	push   $0x80527c
  802fb6:	68 e3 00 00 00       	push   $0xe3
  802fbb:	68 63 52 80 00       	push   $0x805263
  802fc0:	e8 c7 de ff ff       	call   800e8c <_panic>
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc8:	8b 50 08             	mov    0x8(%eax),%edx
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	89 50 08             	mov    %edx,0x8(%eax)
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0c                	je     802fe7 <alloc_block_BF+0x160>
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	8b 40 08             	mov    0x8(%eax),%eax
  802fe1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe4:	89 50 0c             	mov    %edx,0xc(%eax)
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fed:	89 50 08             	mov    %edx,0x8(%eax)
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff6:	89 50 0c             	mov    %edx,0xc(%eax)
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	75 08                	jne    80300b <alloc_block_BF+0x184>
  803003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803006:	a3 44 a3 90 00       	mov    %eax,0x90a344
  80300b:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803010:	40                   	inc    %eax
  803011:	a3 4c a3 90 00       	mov    %eax,0x90a34c

				BF->size = size + sizeOfMetaData();
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8d 50 10             	lea    0x10(%eax),%edx
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  803028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302b:	83 c0 10             	add    $0x10,%eax
  80302e:	e9 b1 00 00 00       	jmp    8030e4 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	83 c0 10             	add    $0x10,%eax
  803040:	e9 9f 00 00 00       	jmp    8030e4 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	83 c0 10             	add    $0x10,%eax
  80304b:	83 ec 0c             	sub    $0xc,%esp
  80304e:	50                   	push   %eax
  80304f:	e8 0a ef ff ff       	call   801f5e <sbrk>
  803054:	83 c4 10             	add    $0x10,%esp
  803057:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  80305a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80305e:	74 7f                	je     8030df <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  803060:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803064:	75 17                	jne    80307d <alloc_block_BF+0x1f6>
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	68 40 52 80 00       	push   $0x805240
  80306e:	68 f6 00 00 00       	push   $0xf6
  803073:	68 63 52 80 00       	push   $0x805263
  803078:	e8 0f de ff ff       	call   800e8c <_panic>
  80307d:	8b 15 44 a3 90 00    	mov    0x90a344,%edx
  803083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803086:	89 50 0c             	mov    %edx,0xc(%eax)
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	8b 40 0c             	mov    0xc(%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 0d                	je     8030a0 <alloc_block_BF+0x219>
  803093:	a1 44 a3 90 00       	mov    0x90a344,%eax
  803098:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309b:	89 50 08             	mov    %edx,0x8(%eax)
  80309e:	eb 08                	jmp    8030a8 <alloc_block_BF+0x221>
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030ba:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8030bf:	40                   	inc    %eax
  8030c0:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		newBlock->size = size + sizeOfMetaData();
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8d 50 10             	lea    0x10(%eax),%edx
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	83 c0 10             	add    $0x10,%eax
  8030dd:	eb 05                	jmp    8030e4 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
  8030e9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 b0 52 80 00       	push   $0x8052b0
  8030f4:	68 07 01 00 00       	push   $0x107
  8030f9:	68 63 52 80 00       	push   $0x805263
  8030fe:	e8 89 dd ff ff       	call   800e8c <_panic>

00803103 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803109:	83 ec 04             	sub    $0x4,%esp
  80310c:	68 d8 52 80 00       	push   $0x8052d8
  803111:	68 0f 01 00 00       	push   $0x10f
  803116:	68 63 52 80 00       	push   $0x805263
  80311b:	e8 6c dd ff ff       	call   800e8c <_panic>

00803120 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
  803123:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  803126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312a:	0f 84 ee 05 00 00    	je     80371e <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	83 e8 10             	sub    $0x10,%eax
  803136:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  803139:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80313d:	a1 40 a3 90 00       	mov    0x90a340,%eax
  803142:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803145:	eb 16                	jmp    80315d <free_block+0x3d>
	{
		if (block_pointer == it)
  803147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80314d:	75 06                	jne    803155 <free_block+0x35>
		{
			flagx = 1;
  80314f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  803153:	eb 2f                	jmp    803184 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803155:	a1 48 a3 90 00       	mov    0x90a348,%eax
  80315a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80315d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803161:	74 08                	je     80316b <free_block+0x4b>
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	8b 40 08             	mov    0x8(%eax),%eax
  803169:	eb 05                	jmp    803170 <free_block+0x50>
  80316b:	b8 00 00 00 00       	mov    $0x0,%eax
  803170:	a3 48 a3 90 00       	mov    %eax,0x90a348
  803175:	a1 48 a3 90 00       	mov    0x90a348,%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	75 c9                	jne    803147 <free_block+0x27>
  80317e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803182:	75 c3                	jne    803147 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  803184:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  803188:	0f 84 93 05 00 00    	je     803721 <free_block+0x601>
		return;
	if (va == NULL)
  80318e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803192:	0f 84 8c 05 00 00    	je     803724 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  803198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319b:	8b 40 0c             	mov    0xc(%eax),%eax
  80319e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8031a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8031aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ae:	75 12                	jne    8031c2 <free_block+0xa2>
  8031b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031b4:	75 0c                	jne    8031c2 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8031bd:	e9 63 05 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8031c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c6:	0f 85 ca 00 00 00    	jne    803296 <free_block+0x176>
  8031cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cf:	8a 40 04             	mov    0x4(%eax),%al
  8031d2:	3c 01                	cmp    $0x1,%al
  8031d4:	0f 85 bc 00 00 00    	jne    803296 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  8031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031dd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8031e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e4:	8b 10                	mov    (%eax),%edx
  8031e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	01 c2                	add    %eax,%edx
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8031f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8031fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fe:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803202:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803206:	75 17                	jne    80321f <free_block+0xff>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 fe 52 80 00       	push   $0x8052fe
  803210:	68 3c 01 00 00       	push   $0x13c
  803215:	68 63 52 80 00       	push   $0x805263
  80321a:	e8 6d dc ff ff       	call   800e8c <_panic>
  80321f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803222:	8b 40 08             	mov    0x8(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 11                	je     80323a <free_block+0x11a>
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	8b 40 08             	mov    0x8(%eax),%eax
  80322f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803232:	8b 52 0c             	mov    0xc(%edx),%edx
  803235:	89 50 0c             	mov    %edx,0xc(%eax)
  803238:	eb 0b                	jmp    803245 <free_block+0x125>
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	8b 40 0c             	mov    0xc(%eax),%eax
  803240:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803248:	8b 40 0c             	mov    0xc(%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 11                	je     803260 <free_block+0x140>
  80324f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803252:	8b 40 0c             	mov    0xc(%eax),%eax
  803255:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803258:	8b 52 08             	mov    0x8(%edx),%edx
  80325b:	89 50 08             	mov    %edx,0x8(%eax)
  80325e:	eb 0b                	jmp    80326b <free_block+0x14b>
  803260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803263:	8b 40 08             	mov    0x8(%eax),%eax
  803266:	a3 40 a3 90 00       	mov    %eax,0x90a340
  80326b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803278:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80327f:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803284:	48                   	dec    %eax
  803285:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  80328a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803291:	e9 8f 04 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  803296:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329a:	75 16                	jne    8032b2 <free_block+0x192>
  80329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329f:	8a 40 04             	mov    0x4(%eax),%al
  8032a2:	84 c0                	test   %al,%al
  8032a4:	75 0c                	jne    8032b2 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8032a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8032ad:	e9 73 04 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8032b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032b6:	0f 85 c3 00 00 00    	jne    80337f <free_block+0x25f>
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	8a 40 04             	mov    0x4(%eax),%al
  8032c2:	3c 01                	cmp    $0x1,%al
  8032c4:	0f 85 b5 00 00 00    	jne    80337f <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 10                	mov    (%eax),%edx
  8032cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	01 c2                	add    %eax,%edx
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8032e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8032eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ef:	75 17                	jne    803308 <free_block+0x1e8>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 fe 52 80 00       	push   $0x8052fe
  8032f9:	68 49 01 00 00       	push   $0x149
  8032fe:	68 63 52 80 00       	push   $0x805263
  803303:	e8 84 db ff ff       	call   800e8c <_panic>
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	8b 40 08             	mov    0x8(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 11                	je     803323 <free_block+0x203>
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80331b:	8b 52 0c             	mov    0xc(%edx),%edx
  80331e:	89 50 0c             	mov    %edx,0xc(%eax)
  803321:	eb 0b                	jmp    80332e <free_block+0x20e>
  803323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803326:	8b 40 0c             	mov    0xc(%eax),%eax
  803329:	a3 44 a3 90 00       	mov    %eax,0x90a344
  80332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803331:	8b 40 0c             	mov    0xc(%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 11                	je     803349 <free_block+0x229>
  803338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333b:	8b 40 0c             	mov    0xc(%eax),%eax
  80333e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803341:	8b 52 08             	mov    0x8(%edx),%edx
  803344:	89 50 08             	mov    %edx,0x8(%eax)
  803347:	eb 0b                	jmp    803354 <free_block+0x234>
  803349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334c:	8b 40 08             	mov    0x8(%eax),%eax
  80334f:	a3 40 a3 90 00       	mov    %eax,0x90a340
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80335e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803361:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803368:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  80336d:	48                   	dec    %eax
  80336e:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		block_pointer = 0;
  803373:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80337a:	e9 a6 03 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  80337f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803383:	75 16                	jne    80339b <free_block+0x27b>
  803385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803388:	8a 40 04             	mov    0x4(%eax),%al
  80338b:	84 c0                	test   %al,%al
  80338d:	75 0c                	jne    80339b <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  80338f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803392:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803396:	e9 8a 03 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  80339b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80339f:	0f 84 81 01 00 00    	je     803526 <free_block+0x406>
  8033a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a9:	0f 84 77 01 00 00    	je     803526 <free_block+0x406>
  8033af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b2:	8a 40 04             	mov    0x4(%eax),%al
  8033b5:	3c 01                	cmp    $0x1,%al
  8033b7:	0f 85 69 01 00 00    	jne    803526 <free_block+0x406>
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	8a 40 04             	mov    0x4(%eax),%al
  8033c3:	3c 01                	cmp    $0x1,%al
  8033c5:	0f 85 5b 01 00 00    	jne    803526 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	8b 10                	mov    (%eax),%edx
  8033d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d3:	8b 08                	mov    (%eax),%ecx
  8033d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	01 c8                	add    %ecx,%eax
  8033dc:	01 c2                	add    %eax,%edx
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8033e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ef:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  8033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ff:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803407:	75 17                	jne    803420 <free_block+0x300>
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 fe 52 80 00       	push   $0x8052fe
  803411:	68 59 01 00 00       	push   $0x159
  803416:	68 63 52 80 00       	push   $0x805263
  80341b:	e8 6c da ff ff       	call   800e8c <_panic>
  803420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803423:	8b 40 08             	mov    0x8(%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 11                	je     80343b <free_block+0x31b>
  80342a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342d:	8b 40 08             	mov    0x8(%eax),%eax
  803430:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803433:	8b 52 0c             	mov    0xc(%edx),%edx
  803436:	89 50 0c             	mov    %edx,0xc(%eax)
  803439:	eb 0b                	jmp    803446 <free_block+0x326>
  80343b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343e:	8b 40 0c             	mov    0xc(%eax),%eax
  803441:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	85 c0                	test   %eax,%eax
  80344e:	74 11                	je     803461 <free_block+0x341>
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	8b 40 0c             	mov    0xc(%eax),%eax
  803456:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803459:	8b 52 08             	mov    0x8(%edx),%edx
  80345c:	89 50 08             	mov    %edx,0x8(%eax)
  80345f:	eb 0b                	jmp    80346c <free_block+0x34c>
  803461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803464:	8b 40 08             	mov    0x8(%eax),%eax
  803467:	a3 40 a3 90 00       	mov    %eax,0x90a340
  80346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803479:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803480:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803485:	48                   	dec    %eax
  803486:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		LIST_REMOVE(&list, next_block);
  80348b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80348f:	75 17                	jne    8034a8 <free_block+0x388>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 fe 52 80 00       	push   $0x8052fe
  803499:	68 5a 01 00 00       	push   $0x15a
  80349e:	68 63 52 80 00       	push   $0x805263
  8034a3:	e8 e4 d9 ff ff       	call   800e8c <_panic>
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	8b 40 08             	mov    0x8(%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 11                	je     8034c3 <free_block+0x3a3>
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	8b 40 08             	mov    0x8(%eax),%eax
  8034b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8034be:	89 50 0c             	mov    %edx,0xc(%eax)
  8034c1:	eb 0b                	jmp    8034ce <free_block+0x3ae>
  8034c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c9:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8034ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 11                	je     8034e9 <free_block+0x3c9>
  8034d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034db:	8b 40 0c             	mov    0xc(%eax),%eax
  8034de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e1:	8b 52 08             	mov    0x8(%edx),%edx
  8034e4:	89 50 08             	mov    %edx,0x8(%eax)
  8034e7:	eb 0b                	jmp    8034f4 <free_block+0x3d4>
  8034e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ec:	8b 40 08             	mov    0x8(%eax),%eax
  8034ef:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8034f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803501:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803508:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  80350d:	48                   	dec    %eax
  80350e:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  803513:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  80351a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803521:	e9 ff 01 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803526:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80352a:	0f 84 db 00 00 00    	je     80360b <free_block+0x4eb>
  803530:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803534:	0f 84 d1 00 00 00    	je     80360b <free_block+0x4eb>
  80353a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353d:	8a 40 04             	mov    0x4(%eax),%al
  803540:	84 c0                	test   %al,%al
  803542:	0f 85 c3 00 00 00    	jne    80360b <free_block+0x4eb>
  803548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354b:	8a 40 04             	mov    0x4(%eax),%al
  80354e:	3c 01                	cmp    $0x1,%al
  803550:	0f 85 b5 00 00 00    	jne    80360b <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803556:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803559:	8b 10                	mov    (%eax),%edx
  80355b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	01 c2                	add    %eax,%edx
  803562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803565:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803573:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80357b:	75 17                	jne    803594 <free_block+0x474>
  80357d:	83 ec 04             	sub    $0x4,%esp
  803580:	68 fe 52 80 00       	push   $0x8052fe
  803585:	68 64 01 00 00       	push   $0x164
  80358a:	68 63 52 80 00       	push   $0x805263
  80358f:	e8 f8 d8 ff ff       	call   800e8c <_panic>
  803594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803597:	8b 40 08             	mov    0x8(%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 11                	je     8035af <free_block+0x48f>
  80359e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a1:	8b 40 08             	mov    0x8(%eax),%eax
  8035a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035a7:	8b 52 0c             	mov    0xc(%edx),%edx
  8035aa:	89 50 0c             	mov    %edx,0xc(%eax)
  8035ad:	eb 0b                	jmp    8035ba <free_block+0x49a>
  8035af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b5:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8035ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 11                	je     8035d5 <free_block+0x4b5>
  8035c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035cd:	8b 52 08             	mov    0x8(%edx),%edx
  8035d0:	89 50 08             	mov    %edx,0x8(%eax)
  8035d3:	eb 0b                	jmp    8035e0 <free_block+0x4c0>
  8035d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d8:	8b 40 08             	mov    0x8(%eax),%eax
  8035db:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8035e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8035f4:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8035f9:	48                   	dec    %eax
  8035fa:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		block_pointer = 0;
  8035ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803606:	e9 1a 01 00 00       	jmp    803725 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  80360b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80360f:	0f 84 df 00 00 00    	je     8036f4 <free_block+0x5d4>
  803615:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803619:	0f 84 d5 00 00 00    	je     8036f4 <free_block+0x5d4>
  80361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803622:	8a 40 04             	mov    0x4(%eax),%al
  803625:	3c 01                	cmp    $0x1,%al
  803627:	0f 85 c7 00 00 00    	jne    8036f4 <free_block+0x5d4>
  80362d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803630:	8a 40 04             	mov    0x4(%eax),%al
  803633:	84 c0                	test   %al,%al
  803635:	0f 85 b9 00 00 00    	jne    8036f4 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  80363b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803645:	8b 10                	mov    (%eax),%edx
  803647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	01 c2                	add    %eax,%edx
  80364e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803651:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80365c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803663:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803667:	75 17                	jne    803680 <free_block+0x560>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 fe 52 80 00       	push   $0x8052fe
  803671:	68 6e 01 00 00       	push   $0x16e
  803676:	68 63 52 80 00       	push   $0x805263
  80367b:	e8 0c d8 ff ff       	call   800e8c <_panic>
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	8b 40 08             	mov    0x8(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 11                	je     80369b <free_block+0x57b>
  80368a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368d:	8b 40 08             	mov    0x8(%eax),%eax
  803690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803693:	8b 52 0c             	mov    0xc(%edx),%edx
  803696:	89 50 0c             	mov    %edx,0xc(%eax)
  803699:	eb 0b                	jmp    8036a6 <free_block+0x586>
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a1:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8036a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 11                	je     8036c1 <free_block+0x5a1>
  8036b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b9:	8b 52 08             	mov    0x8(%edx),%edx
  8036bc:	89 50 08             	mov    %edx,0x8(%eax)
  8036bf:	eb 0b                	jmp    8036cc <free_block+0x5ac>
  8036c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c4:	8b 40 08             	mov    0x8(%eax),%eax
  8036c7:	a3 40 a3 90 00       	mov    %eax,0x90a340
  8036cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8036e0:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8036e5:	48                   	dec    %eax
  8036e6:	a3 4c a3 90 00       	mov    %eax,0x90a34c
		next_block = 0;
  8036eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8036f2:	eb 31                	jmp    803725 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  8036f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036f8:	74 2b                	je     803725 <free_block+0x605>
  8036fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036fe:	74 25                	je     803725 <free_block+0x605>
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	8a 40 04             	mov    0x4(%eax),%al
  803706:	84 c0                	test   %al,%al
  803708:	75 1b                	jne    803725 <free_block+0x605>
  80370a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370d:	8a 40 04             	mov    0x4(%eax),%al
  803710:	84 c0                	test   %al,%al
  803712:	75 11                	jne    803725 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803717:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80371b:	90                   	nop
  80371c:	eb 07                	jmp    803725 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  80371e:	90                   	nop
  80371f:	eb 04                	jmp    803725 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803721:	90                   	nop
  803722:	eb 01                	jmp    803725 <free_block+0x605>
	if (va == NULL)
		return;
  803724:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803725:	c9                   	leave  
  803726:	c3                   	ret    

00803727 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
  80372a:	57                   	push   %edi
  80372b:	56                   	push   %esi
  80372c:	53                   	push   %ebx
  80372d:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803730:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803734:	75 19                	jne    80374f <realloc_block_FF+0x28>
  803736:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80373a:	74 13                	je     80374f <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  80373c:	83 ec 0c             	sub    $0xc,%esp
  80373f:	ff 75 0c             	pushl  0xc(%ebp)
  803742:	e8 0c f4 ff ff       	call   802b53 <alloc_block_FF>
  803747:	83 c4 10             	add    $0x10,%esp
  80374a:	e9 84 03 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  80374f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803753:	75 3b                	jne    803790 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  803755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803759:	75 17                	jne    803772 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  80375b:	83 ec 0c             	sub    $0xc,%esp
  80375e:	6a 00                	push   $0x0
  803760:	e8 ee f3 ff ff       	call   802b53 <alloc_block_FF>
  803765:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803768:	b8 00 00 00 00       	mov    $0x0,%eax
  80376d:	e9 61 03 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  803772:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803776:	74 18                	je     803790 <realloc_block_FF+0x69>
		{
			free_block(va);
  803778:	83 ec 0c             	sub    $0xc,%esp
  80377b:	ff 75 08             	pushl  0x8(%ebp)
  80377e:	e8 9d f9 ff ff       	call   803120 <free_block>
  803783:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803786:	b8 00 00 00 00       	mov    $0x0,%eax
  80378b:	e9 43 03 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803790:	a1 40 a3 90 00       	mov    0x90a340,%eax
  803795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803798:	e9 02 03 00 00       	jmp    803a9f <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	83 e8 10             	sub    $0x10,%eax
  8037a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037a6:	0f 85 eb 02 00 00    	jne    803a97 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8037ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b4:	83 c2 10             	add    $0x10,%edx
  8037b7:	39 d0                	cmp    %edx,%eax
  8037b9:	75 08                	jne    8037c3 <realloc_block_FF+0x9c>
			{
				return va;
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	e9 10 03 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  8037c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037cb:	0f 83 e0 01 00 00    	jae    8039b1 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8037d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d4:	8b 40 08             	mov    0x8(%eax),%eax
  8037d7:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  8037da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037dd:	8a 40 04             	mov    0x4(%eax),%al
  8037e0:	3c 01                	cmp    $0x1,%al
  8037e2:	0f 85 06 01 00 00    	jne    8038ee <realloc_block_FF+0x1c7>
  8037e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037eb:	8b 10                	mov    (%eax),%edx
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8037f5:	29 c1                	sub    %eax,%ecx
  8037f7:	89 c8                	mov    %ecx,%eax
  8037f9:	39 c2                	cmp    %eax,%edx
  8037fb:	0f 86 ed 00 00 00    	jbe    8038ee <realloc_block_FF+0x1c7>
  803801:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803805:	0f 84 e3 00 00 00    	je     8038ee <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  80380b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80380e:	8b 10                	mov    (%eax),%edx
  803810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	2b 45 0c             	sub    0xc(%ebp),%eax
  803818:	01 d0                	add    %edx,%eax
  80381a:	83 f8 0f             	cmp    $0xf,%eax
  80381d:	0f 86 b5 00 00 00    	jbe    8038d8 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803823:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803826:	8b 45 0c             	mov    0xc(%ebp),%eax
  803829:	01 d0                	add    %edx,%eax
  80382b:	83 c0 10             	add    $0x10,%eax
  80382e:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803831:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  80383a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803845:	74 06                	je     80384d <realloc_block_FF+0x126>
  803847:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80384b:	75 17                	jne    803864 <realloc_block_FF+0x13d>
  80384d:	83 ec 04             	sub    $0x4,%esp
  803850:	68 7c 52 80 00       	push   $0x80527c
  803855:	68 ad 01 00 00       	push   $0x1ad
  80385a:	68 63 52 80 00       	push   $0x805263
  80385f:	e8 28 d6 ff ff       	call   800e8c <_panic>
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	8b 50 08             	mov    0x8(%eax),%edx
  80386a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386d:	89 50 08             	mov    %edx,0x8(%eax)
  803870:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803873:	8b 40 08             	mov    0x8(%eax),%eax
  803876:	85 c0                	test   %eax,%eax
  803878:	74 0c                	je     803886 <realloc_block_FF+0x15f>
  80387a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387d:	8b 40 08             	mov    0x8(%eax),%eax
  803880:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803883:	89 50 0c             	mov    %edx,0xc(%eax)
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388c:	89 50 08             	mov    %edx,0x8(%eax)
  80388f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803895:	89 50 0c             	mov    %edx,0xc(%eax)
  803898:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389b:	8b 40 08             	mov    0x8(%eax),%eax
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	75 08                	jne    8038aa <realloc_block_FF+0x183>
  8038a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a5:	a3 44 a3 90 00       	mov    %eax,0x90a344
  8038aa:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  8038af:	40                   	inc    %eax
  8038b0:	a3 4c a3 90 00       	mov    %eax,0x90a34c
						next->size = 0;
  8038b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  8038be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038c1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  8038c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c8:	8d 50 10             	lea    0x10(%eax),%edx
  8038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ce:	89 10                	mov    %edx,(%eax)
						return va;
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	e9 fb 01 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  8038d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038db:	8d 50 10             	lea    0x10(%eax),%edx
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  8038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e6:	83 c0 10             	add    $0x10,%eax
  8038e9:	e9 e5 01 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  8038ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f1:	8a 40 04             	mov    0x4(%eax),%al
  8038f4:	3c 01                	cmp    $0x1,%al
  8038f6:	75 59                	jne    803951 <realloc_block_FF+0x22a>
  8038f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038fb:	8b 10                	mov    (%eax),%edx
  8038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803905:	29 c1                	sub    %eax,%ecx
  803907:	89 c8                	mov    %ecx,%eax
  803909:	39 c2                	cmp    %eax,%edx
  80390b:	75 44                	jne    803951 <realloc_block_FF+0x22a>
  80390d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803911:	74 3e                	je     803951 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803916:	8b 40 08             	mov    0x8(%eax),%eax
  803919:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  80391c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803922:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803925:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803928:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392b:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  80392e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  80393e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803941:	8d 50 10             	lea    0x10(%eax),%edx
  803944:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803947:	89 10                	mov    %edx,(%eax)
					return va;
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	e9 82 01 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803954:	8a 40 04             	mov    0x4(%eax),%al
  803957:	84 c0                	test   %al,%al
  803959:	74 0a                	je     803965 <realloc_block_FF+0x23e>
  80395b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80395f:	0f 85 32 01 00 00    	jne    803a97 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803965:	83 ec 0c             	sub    $0xc,%esp
  803968:	ff 75 0c             	pushl  0xc(%ebp)
  80396b:	e8 e3 f1 ff ff       	call   802b53 <alloc_block_FF>
  803970:	83 c4 10             	add    $0x10,%esp
  803973:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  803976:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80397a:	74 2b                	je     8039a7 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  80397c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80397f:	8b 45 08             	mov    0x8(%ebp),%eax
  803982:	89 c3                	mov    %eax,%ebx
  803984:	b8 04 00 00 00       	mov    $0x4,%eax
  803989:	89 d7                	mov    %edx,%edi
  80398b:	89 de                	mov    %ebx,%esi
  80398d:	89 c1                	mov    %eax,%ecx
  80398f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  803991:	83 ec 0c             	sub    $0xc,%esp
  803994:	ff 75 08             	pushl  0x8(%ebp)
  803997:	e8 84 f7 ff ff       	call   803120 <free_block>
  80399c:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  80399f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a2:	e9 2c 01 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8039a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8039ac:	e9 22 01 00 00       	jmp    803ad3 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039b9:	0f 86 d8 00 00 00    	jbe    803a97 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039c7:	83 f8 0f             	cmp    $0xf,%eax
  8039ca:	0f 86 b4 00 00 00    	jbe    803a84 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  8039d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d6:	01 d0                	add    %edx,%eax
  8039d8:	83 c0 10             	add    $0x10,%eax
  8039db:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  8039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039e6:	8d 50 f0             	lea    -0x10(%eax),%edx
  8039e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ec:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8039ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039f2:	74 06                	je     8039fa <realloc_block_FF+0x2d3>
  8039f4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039f8:	75 17                	jne    803a11 <realloc_block_FF+0x2ea>
  8039fa:	83 ec 04             	sub    $0x4,%esp
  8039fd:	68 7c 52 80 00       	push   $0x80527c
  803a02:	68 dd 01 00 00       	push   $0x1dd
  803a07:	68 63 52 80 00       	push   $0x805263
  803a0c:	e8 7b d4 ff ff       	call   800e8c <_panic>
  803a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a14:	8b 50 08             	mov    0x8(%eax),%edx
  803a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1a:	89 50 08             	mov    %edx,0x8(%eax)
  803a1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a20:	8b 40 08             	mov    0x8(%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 0c                	je     803a33 <realloc_block_FF+0x30c>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 40 08             	mov    0x8(%eax),%eax
  803a2d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a30:	89 50 0c             	mov    %edx,0xc(%eax)
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a39:	89 50 08             	mov    %edx,0x8(%eax)
  803a3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a42:	89 50 0c             	mov    %edx,0xc(%eax)
  803a45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a48:	8b 40 08             	mov    0x8(%eax),%eax
  803a4b:	85 c0                	test   %eax,%eax
  803a4d:	75 08                	jne    803a57 <realloc_block_FF+0x330>
  803a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a52:	a3 44 a3 90 00       	mov    %eax,0x90a344
  803a57:	a1 4c a3 90 00       	mov    0x90a34c,%eax
  803a5c:	40                   	inc    %eax
  803a5d:	a3 4c a3 90 00       	mov    %eax,0x90a34c
					free_block((void*) (newBlockAfterSplit + 1));
  803a62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a65:	83 c0 10             	add    $0x10,%eax
  803a68:	83 ec 0c             	sub    $0xc,%esp
  803a6b:	50                   	push   %eax
  803a6c:	e8 af f6 ff ff       	call   803120 <free_block>
  803a71:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a77:	8d 50 10             	lea    0x10(%eax),%edx
  803a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7d:	89 10                	mov    %edx,(%eax)
					return va;
  803a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a82:	eb 4f                	jmp    803ad3 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a87:	8d 50 10             	lea    0x10(%eax),%edx
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a92:	83 c0 10             	add    $0x10,%eax
  803a95:	eb 3c                	jmp    803ad3 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803a97:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803a9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803a9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aa3:	74 08                	je     803aad <realloc_block_FF+0x386>
  803aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa8:	8b 40 08             	mov    0x8(%eax),%eax
  803aab:	eb 05                	jmp    803ab2 <realloc_block_FF+0x38b>
  803aad:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab2:	a3 48 a3 90 00       	mov    %eax,0x90a348
  803ab7:	a1 48 a3 90 00       	mov    0x90a348,%eax
  803abc:	85 c0                	test   %eax,%eax
  803abe:	0f 85 d9 fc ff ff    	jne    80379d <realloc_block_FF+0x76>
  803ac4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac8:	0f 85 cf fc ff ff    	jne    80379d <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803ad6:	5b                   	pop    %ebx
  803ad7:	5e                   	pop    %esi
  803ad8:	5f                   	pop    %edi
  803ad9:	5d                   	pop    %ebp
  803ada:	c3                   	ret    
  803adb:	90                   	nop

00803adc <__udivdi3>:
  803adc:	55                   	push   %ebp
  803add:	57                   	push   %edi
  803ade:	56                   	push   %esi
  803adf:	53                   	push   %ebx
  803ae0:	83 ec 1c             	sub    $0x1c,%esp
  803ae3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af3:	89 ca                	mov    %ecx,%edx
  803af5:	89 f8                	mov    %edi,%eax
  803af7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803afb:	85 f6                	test   %esi,%esi
  803afd:	75 2d                	jne    803b2c <__udivdi3+0x50>
  803aff:	39 cf                	cmp    %ecx,%edi
  803b01:	77 65                	ja     803b68 <__udivdi3+0x8c>
  803b03:	89 fd                	mov    %edi,%ebp
  803b05:	85 ff                	test   %edi,%edi
  803b07:	75 0b                	jne    803b14 <__udivdi3+0x38>
  803b09:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0e:	31 d2                	xor    %edx,%edx
  803b10:	f7 f7                	div    %edi
  803b12:	89 c5                	mov    %eax,%ebp
  803b14:	31 d2                	xor    %edx,%edx
  803b16:	89 c8                	mov    %ecx,%eax
  803b18:	f7 f5                	div    %ebp
  803b1a:	89 c1                	mov    %eax,%ecx
  803b1c:	89 d8                	mov    %ebx,%eax
  803b1e:	f7 f5                	div    %ebp
  803b20:	89 cf                	mov    %ecx,%edi
  803b22:	89 fa                	mov    %edi,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 ce                	cmp    %ecx,%esi
  803b2e:	77 28                	ja     803b58 <__udivdi3+0x7c>
  803b30:	0f bd fe             	bsr    %esi,%edi
  803b33:	83 f7 1f             	xor    $0x1f,%edi
  803b36:	75 40                	jne    803b78 <__udivdi3+0x9c>
  803b38:	39 ce                	cmp    %ecx,%esi
  803b3a:	72 0a                	jb     803b46 <__udivdi3+0x6a>
  803b3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b40:	0f 87 9e 00 00 00    	ja     803be4 <__udivdi3+0x108>
  803b46:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4b:	89 fa                	mov    %edi,%edx
  803b4d:	83 c4 1c             	add    $0x1c,%esp
  803b50:	5b                   	pop    %ebx
  803b51:	5e                   	pop    %esi
  803b52:	5f                   	pop    %edi
  803b53:	5d                   	pop    %ebp
  803b54:	c3                   	ret    
  803b55:	8d 76 00             	lea    0x0(%esi),%esi
  803b58:	31 ff                	xor    %edi,%edi
  803b5a:	31 c0                	xor    %eax,%eax
  803b5c:	89 fa                	mov    %edi,%edx
  803b5e:	83 c4 1c             	add    $0x1c,%esp
  803b61:	5b                   	pop    %ebx
  803b62:	5e                   	pop    %esi
  803b63:	5f                   	pop    %edi
  803b64:	5d                   	pop    %ebp
  803b65:	c3                   	ret    
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	89 d8                	mov    %ebx,%eax
  803b6a:	f7 f7                	div    %edi
  803b6c:	31 ff                	xor    %edi,%edi
  803b6e:	89 fa                	mov    %edi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b7d:	89 eb                	mov    %ebp,%ebx
  803b7f:	29 fb                	sub    %edi,%ebx
  803b81:	89 f9                	mov    %edi,%ecx
  803b83:	d3 e6                	shl    %cl,%esi
  803b85:	89 c5                	mov    %eax,%ebp
  803b87:	88 d9                	mov    %bl,%cl
  803b89:	d3 ed                	shr    %cl,%ebp
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	09 f1                	or     %esi,%ecx
  803b8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b93:	89 f9                	mov    %edi,%ecx
  803b95:	d3 e0                	shl    %cl,%eax
  803b97:	89 c5                	mov    %eax,%ebp
  803b99:	89 d6                	mov    %edx,%esi
  803b9b:	88 d9                	mov    %bl,%cl
  803b9d:	d3 ee                	shr    %cl,%esi
  803b9f:	89 f9                	mov    %edi,%ecx
  803ba1:	d3 e2                	shl    %cl,%edx
  803ba3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 e8                	shr    %cl,%eax
  803bab:	09 c2                	or     %eax,%edx
  803bad:	89 d0                	mov    %edx,%eax
  803baf:	89 f2                	mov    %esi,%edx
  803bb1:	f7 74 24 0c          	divl   0xc(%esp)
  803bb5:	89 d6                	mov    %edx,%esi
  803bb7:	89 c3                	mov    %eax,%ebx
  803bb9:	f7 e5                	mul    %ebp
  803bbb:	39 d6                	cmp    %edx,%esi
  803bbd:	72 19                	jb     803bd8 <__udivdi3+0xfc>
  803bbf:	74 0b                	je     803bcc <__udivdi3+0xf0>
  803bc1:	89 d8                	mov    %ebx,%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 58 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd0:	89 f9                	mov    %edi,%ecx
  803bd2:	d3 e2                	shl    %cl,%edx
  803bd4:	39 c2                	cmp    %eax,%edx
  803bd6:	73 e9                	jae    803bc1 <__udivdi3+0xe5>
  803bd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 40 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	31 c0                	xor    %eax,%eax
  803be6:	e9 37 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803beb:	90                   	nop

00803bec <__umoddi3>:
  803bec:	55                   	push   %ebp
  803bed:	57                   	push   %edi
  803bee:	56                   	push   %esi
  803bef:	53                   	push   %ebx
  803bf0:	83 ec 1c             	sub    $0x1c,%esp
  803bf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c0b:	89 f3                	mov    %esi,%ebx
  803c0d:	89 fa                	mov    %edi,%edx
  803c0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c13:	89 34 24             	mov    %esi,(%esp)
  803c16:	85 c0                	test   %eax,%eax
  803c18:	75 1a                	jne    803c34 <__umoddi3+0x48>
  803c1a:	39 f7                	cmp    %esi,%edi
  803c1c:	0f 86 a2 00 00 00    	jbe    803cc4 <__umoddi3+0xd8>
  803c22:	89 c8                	mov    %ecx,%eax
  803c24:	89 f2                	mov    %esi,%edx
  803c26:	f7 f7                	div    %edi
  803c28:	89 d0                	mov    %edx,%eax
  803c2a:	31 d2                	xor    %edx,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	39 f0                	cmp    %esi,%eax
  803c36:	0f 87 ac 00 00 00    	ja     803ce8 <__umoddi3+0xfc>
  803c3c:	0f bd e8             	bsr    %eax,%ebp
  803c3f:	83 f5 1f             	xor    $0x1f,%ebp
  803c42:	0f 84 ac 00 00 00    	je     803cf4 <__umoddi3+0x108>
  803c48:	bf 20 00 00 00       	mov    $0x20,%edi
  803c4d:	29 ef                	sub    %ebp,%edi
  803c4f:	89 fe                	mov    %edi,%esi
  803c51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c55:	89 e9                	mov    %ebp,%ecx
  803c57:	d3 e0                	shl    %cl,%eax
  803c59:	89 d7                	mov    %edx,%edi
  803c5b:	89 f1                	mov    %esi,%ecx
  803c5d:	d3 ef                	shr    %cl,%edi
  803c5f:	09 c7                	or     %eax,%edi
  803c61:	89 e9                	mov    %ebp,%ecx
  803c63:	d3 e2                	shl    %cl,%edx
  803c65:	89 14 24             	mov    %edx,(%esp)
  803c68:	89 d8                	mov    %ebx,%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 c2                	mov    %eax,%edx
  803c6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c72:	d3 e0                	shl    %cl,%eax
  803c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7c:	89 f1                	mov    %esi,%ecx
  803c7e:	d3 e8                	shr    %cl,%eax
  803c80:	09 d0                	or     %edx,%eax
  803c82:	d3 eb                	shr    %cl,%ebx
  803c84:	89 da                	mov    %ebx,%edx
  803c86:	f7 f7                	div    %edi
  803c88:	89 d3                	mov    %edx,%ebx
  803c8a:	f7 24 24             	mull   (%esp)
  803c8d:	89 c6                	mov    %eax,%esi
  803c8f:	89 d1                	mov    %edx,%ecx
  803c91:	39 d3                	cmp    %edx,%ebx
  803c93:	0f 82 87 00 00 00    	jb     803d20 <__umoddi3+0x134>
  803c99:	0f 84 91 00 00 00    	je     803d30 <__umoddi3+0x144>
  803c9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ca3:	29 f2                	sub    %esi,%edx
  803ca5:	19 cb                	sbb    %ecx,%ebx
  803ca7:	89 d8                	mov    %ebx,%eax
  803ca9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cad:	d3 e0                	shl    %cl,%eax
  803caf:	89 e9                	mov    %ebp,%ecx
  803cb1:	d3 ea                	shr    %cl,%edx
  803cb3:	09 d0                	or     %edx,%eax
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 eb                	shr    %cl,%ebx
  803cb9:	89 da                	mov    %ebx,%edx
  803cbb:	83 c4 1c             	add    $0x1c,%esp
  803cbe:	5b                   	pop    %ebx
  803cbf:	5e                   	pop    %esi
  803cc0:	5f                   	pop    %edi
  803cc1:	5d                   	pop    %ebp
  803cc2:	c3                   	ret    
  803cc3:	90                   	nop
  803cc4:	89 fd                	mov    %edi,%ebp
  803cc6:	85 ff                	test   %edi,%edi
  803cc8:	75 0b                	jne    803cd5 <__umoddi3+0xe9>
  803cca:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f7                	div    %edi
  803cd3:	89 c5                	mov    %eax,%ebp
  803cd5:	89 f0                	mov    %esi,%eax
  803cd7:	31 d2                	xor    %edx,%edx
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 c8                	mov    %ecx,%eax
  803cdd:	f7 f5                	div    %ebp
  803cdf:	89 d0                	mov    %edx,%eax
  803ce1:	e9 44 ff ff ff       	jmp    803c2a <__umoddi3+0x3e>
  803ce6:	66 90                	xchg   %ax,%ax
  803ce8:	89 c8                	mov    %ecx,%eax
  803cea:	89 f2                	mov    %esi,%edx
  803cec:	83 c4 1c             	add    $0x1c,%esp
  803cef:	5b                   	pop    %ebx
  803cf0:	5e                   	pop    %esi
  803cf1:	5f                   	pop    %edi
  803cf2:	5d                   	pop    %ebp
  803cf3:	c3                   	ret    
  803cf4:	3b 04 24             	cmp    (%esp),%eax
  803cf7:	72 06                	jb     803cff <__umoddi3+0x113>
  803cf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cfd:	77 0f                	ja     803d0e <__umoddi3+0x122>
  803cff:	89 f2                	mov    %esi,%edx
  803d01:	29 f9                	sub    %edi,%ecx
  803d03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d07:	89 14 24             	mov    %edx,(%esp)
  803d0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d12:	8b 14 24             	mov    (%esp),%edx
  803d15:	83 c4 1c             	add    $0x1c,%esp
  803d18:	5b                   	pop    %ebx
  803d19:	5e                   	pop    %esi
  803d1a:	5f                   	pop    %edi
  803d1b:	5d                   	pop    %ebp
  803d1c:	c3                   	ret    
  803d1d:	8d 76 00             	lea    0x0(%esi),%esi
  803d20:	2b 04 24             	sub    (%esp),%eax
  803d23:	19 fa                	sbb    %edi,%edx
  803d25:	89 d1                	mov    %edx,%ecx
  803d27:	89 c6                	mov    %eax,%esi
  803d29:	e9 71 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
  803d2e:	66 90                	xchg   %ax,%ax
  803d30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d34:	72 ea                	jb     803d20 <__umoddi3+0x134>
  803d36:	89 d9                	mov    %ebx,%ecx
  803d38:	e9 62 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
