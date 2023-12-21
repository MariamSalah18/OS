
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 21 06 00 00       	call   800657 <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800044:	83 ec 0c             	sub    $0xc,%esp
  800047:	6a 01                	push   $0x1
  800049:	e8 fe 20 00 00       	call   80214c <sys_set_uheap_strategy>
  80004e:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800051:	a1 40 50 80 00       	mov    0x805040,%eax
  800056:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80005c:	a1 40 50 80 00       	mov    0x805040,%eax
  800061:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800067:	39 c2                	cmp    %eax,%edx
  800069:	72 14                	jb     80007f <_main+0x47>
			panic("Please increase the WS size");
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 40 36 80 00       	push   $0x803640
  800073:	6a 22                	push   $0x22
  800075:	68 5c 36 80 00       	push   $0x80365c
  80007a:	e8 06 07 00 00       	call   800785 <_panic>
	}
	/*=================================================*/

	int eval = 0;
  80007f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  800086:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80008d:	c7 45 bc 00 00 30 00 	movl   $0x300000,-0x44(%ebp)

	void * va ;
	int idx = 0;
  800094:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80009b:	e8 37 1c 00 00       	call   801cd7 <sys_pf_calculate_allocated_pages>
  8000a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000a3:	e8 e4 1b 00 00       	call   801c8c <sys_calculate_free_frames>
  8000a8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	uint32 actualSize;

	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 74 36 80 00       	push   $0x803674
  8000b3:	e8 8a 09 00 00       	call   800a42 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000bb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000c2:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8000d0:	e9 e7 00 00 00       	jmp    8001bc <_main+0x184>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000d5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8000dc:	e9 cb 00 00 00       	jmp    8001ac <_main+0x174>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000e4:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8000eb:	83 e8 10             	sub    $0x10,%eax
  8000ee:	89 45 b0             	mov    %eax,-0x50(%ebp)
				va = startVAs[idx++] = malloc(actualSize);
  8000f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000f4:	8d 43 01             	lea    0x1(%ebx),%eax
  8000f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	ff 75 b0             	pushl  -0x50(%ebp)
  800100:	e8 68 17 00 00       	call   80186d <malloc>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	89 04 9d 20 51 80 00 	mov    %eax,0x805120(,%ebx,4)
  80010f:	8b 04 9d 20 51 80 00 	mov    0x805120(,%ebx,4),%eax
  800116:	89 45 ac             	mov    %eax,-0x54(%ebp)
				//Check returned va
				if(va == NULL || (va < curVA))
  800119:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80011d:	74 08                	je     800127 <_main+0xef>
  80011f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800122:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800125:	73 2e                	jae    800155 <_main+0x11d>
				{
					if (is_correct)
  800127:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80012b:	74 28                	je     800155 <_main+0x11d>
					{
						is_correct = 0;
  80012d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
						panic("malloc() #1.%d: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  800134:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800137:	83 c0 10             	add    $0x10,%eax
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	ff 75 ac             	pushl  -0x54(%ebp)
  800140:	50                   	push   %eax
  800141:	ff 75 dc             	pushl  -0x24(%ebp)
  800144:	68 cc 36 80 00       	push   $0x8036cc
  800149:	6a 44                	push   $0x44
  80014b:	68 5c 36 80 00       	push   $0x80365c
  800150:	e8 30 06 00 00       	call   800785 <_panic>
					}
				}
				curVA += allocSizes[i] ;
  800155:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800158:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80015f:	01 45 d8             	add    %eax,-0x28(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800162:	c7 45 a8 00 10 00 00 	movl   $0x1000,-0x58(%ebp)
  800169:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80016c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	48                   	dec    %eax
  800172:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800175:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800178:	ba 00 00 00 00       	mov    $0x0,%edx
  80017d:	f7 75 a8             	divl   -0x58(%ebp)
  800180:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800183:	29 d0                	sub    %edx,%eax
  800185:	89 45 a0             	mov    %eax,-0x60(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800188:	8b 55 a0             	mov    -0x60(%ebp),%edx
  80018b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018e:	29 c2                	sub    %eax,%edx
  800190:	89 d0                	mov    %edx,%eax
  800192:	89 45 9c             	mov    %eax,-0x64(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  800195:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800199:	7e 0e                	jle    8001a9 <_main+0x171>
  80019b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80019e:	83 f8 0f             	cmp    $0xf,%eax
  8001a1:	77 06                	ja     8001a9 <_main+0x171>
				{
					curVA = rounded_curVA;
  8001a3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8001a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001a9:	ff 45 d0             	incl   -0x30(%ebp)
  8001ac:	81 7d d0 c7 00 00 00 	cmpl   $0xc7,-0x30(%ebp)
  8001b3:	0f 8e 28 ff ff ff    	jle    8000e1 <_main+0xa9>
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001b9:	ff 45 d4             	incl   -0x2c(%ebp)
  8001bc:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  8001c0:	0f 8e 0f ff ff ff    	jle    8000d5 <_main+0x9d>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 28 37 80 00       	push   $0x803728
  8001ce:	e8 6f 08 00 00       	call   800a42 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < numOfAllocs; ++i)
  8001d6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8001dd:	eb 2c                	jmp    80020b <_main+0x1d3>
		{
			free(startVAs[i*allocCntPerSize]);
  8001df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001e2:	89 d0                	mov    %edx,%eax
  8001e4:	c1 e0 02             	shl    $0x2,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	e8 c4 17 00 00       	call   8019c9 <free>
  800205:	83 c4 10             	add    $0x10,%esp

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		for (int i = 0; i < numOfAllocs; ++i)
  800208:	ff 45 cc             	incl   -0x34(%ebp)
  80020b:	83 7d cc 06          	cmpl   $0x6,-0x34(%ebp)
  80020f:	7e ce                	jle    8001df <_main+0x1a7>
	short* tstMidVAs[numOfFFTests+1] ;
	short* tstEndVAs[numOfFFTests+1] ;

	//====================================================================//
	/*FF ALLOC Scenario 2: Try to allocate blocks with sizes smaller than existing free blocks*/
	cprintf("2: Try to allocate set of blocks with different sizes smaller than existing free blocks\n\n") ;
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 70 37 80 00       	push   $0x803770
  800219:	e8 24 08 00 00       	call   800a42 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  800221:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800227:	bb 90 3b 80 00       	mov    $0x803b90,%ebx
  80022c:	ba 03 00 00 00       	mov    $0x3,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData(), 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;

	uint32 startOf1stFreeBlock = (uint32)startVAs[0*allocCntPerSize];
  800239:	a1 20 51 80 00       	mov    0x805120,%eax
  80023e:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];
  800241:	a1 80 5a 80 00       	mov    0x805a80,%eax
  800246:	89 45 94             	mov    %eax,-0x6c(%ebp)

	{
		is_correct = 1;
  800249:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		uint32 expectedVAs[numOfFFTests] =
  800250:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800253:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800259:	8b 45 98             	mov    -0x68(%ebp),%eax
  80025c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
  800262:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800268:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80026b:	01 d0                	add    %edx,%eax
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];

	{
		is_correct = 1;

		uint32 expectedVAs[numOfFFTests] =
  80026d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  800273:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80027a:	e9 f7 00 00 00       	jmp    800376 <_main+0x33e>
		{
			actualSize = testSizes[i] - sizeOfMetaData();
  80027f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800282:	8b 84 85 4c ff ff ff 	mov    -0xb4(%ebp,%eax,4),%eax
  800289:	83 e8 10             	sub    $0x10,%eax
  80028c:	89 45 90             	mov    %eax,-0x70(%ebp)
			va = tstStartVAs[i] = malloc(actualSize);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	ff 75 90             	pushl  -0x70(%ebp)
  800295:	e8 d3 15 00 00       	call   80186d <malloc>
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	89 94 85 78 ff ff ff 	mov    %edx,-0x88(%ebp,%eax,4)
  8002a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002ac:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8002b3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			tstMidVAs[i] = va + actualSize/2 ;
  8002b6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002b9:	d1 e8                	shr    %eax
  8002bb:	89 c2                	mov    %eax,%edx
  8002bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002c0:	01 c2                	add    %eax,%edx
  8002c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002c5:	89 94 85 68 ff ff ff 	mov    %edx,-0x98(%ebp,%eax,4)
			tstEndVAs[i] = va + actualSize - sizeof(short);
  8002cc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002cf:	8d 50 fe             	lea    -0x2(%eax),%edx
  8002d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002d5:	01 c2                	add    %eax,%edx
  8002d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002da:	89 94 85 58 ff ff ff 	mov    %edx,-0xa8(%ebp,%eax,4)
			//Check returned va
			if(tstStartVAs[i] == NULL || (tstStartVAs[i] != (short*)expectedVAs[i]))
  8002e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002e4:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	74 18                	je     800307 <_main+0x2cf>
  8002ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002f2:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  8002f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002fc:	8b 84 85 40 ff ff ff 	mov    -0xc0(%ebp,%eax,4),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	74 2d                	je     800334 <_main+0x2fc>
			{
				is_correct = 0;
  800307:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #2.%d: WRONG FF ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", i, expectedVAs[i] ,tstStartVAs[i]);
  80030e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800311:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  800318:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80031b:	8b 84 85 40 ff ff ff 	mov    -0xc0(%ebp,%eax,4),%eax
  800322:	52                   	push   %edx
  800323:	50                   	push   %eax
  800324:	ff 75 c8             	pushl  -0x38(%ebp)
  800327:	68 cc 37 80 00       	push   $0x8037cc
  80032c:	e8 11 07 00 00       	call   800a42 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
				//break;
			}
			*(tstStartVAs[i]) = 353 + i;
  800334:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800337:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  80033e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800341:	05 61 01 00 00       	add    $0x161,%eax
  800346:	66 89 02             	mov    %ax,(%edx)
			*(tstMidVAs[i]) = 353 + i;
  800349:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80034c:	8b 94 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%edx
  800353:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800356:	05 61 01 00 00       	add    $0x161,%eax
  80035b:	66 89 02             	mov    %ax,(%edx)
			*(tstEndVAs[i]) = 353 + i;
  80035e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800361:	8b 94 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%edx
  800368:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80036b:	05 61 01 00 00       	add    $0x161,%eax
  800370:	66 89 02             	mov    %ax,(%edx)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  800373:	ff 45 c8             	incl   -0x38(%ebp)
  800376:	83 7d c8 02          	cmpl   $0x2,-0x38(%ebp)
  80037a:	0f 8e ff fe ff ff    	jle    80027f <_main+0x247>
			*(tstStartVAs[i]) = 353 + i;
			*(tstMidVAs[i]) = 353 + i;
			*(tstEndVAs[i]) = 353 + i;
		}
		//Check stored sizes
		if(get_block_size(tstStartVAs[1]) != allocSizes[0])
  800380:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	50                   	push   %eax
  80038a:	e8 c3 1e 00 00       	call   802252 <get_block_size>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 c2                	mov    %eax,%edx
  800394:	a1 00 50 80 00       	mov    0x805000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	74 17                	je     8003b4 <_main+0x37c>
		{
			is_correct = 0;
  80039d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #3: WRONG FF ALLOC - make sure if the remaining free space doesn’t fit a dynamic allocator block, then this area should be added to the allocated area and counted as internal fragmentation\n");
  8003a4:	83 ec 0c             	sub    $0xc,%esp
  8003a7:	68 2c 38 80 00       	push   $0x80382c
  8003ac:	e8 91 06 00 00       	call   800a42 <cprintf>
  8003b1:	83 c4 10             	add    $0x10,%esp
			//break;
		}
		if (is_correct)
  8003b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b8:	74 04                	je     8003be <_main+0x386>
		{
			eval += 30;
  8003ba:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 3: Try to allocate a block with a size equal to the size of the first existing free block*/
	cprintf("3: Try to allocate a block with equal to the first existing free block\n\n") ;
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	68 f4 38 80 00       	push   $0x8038f4
  8003c6:	e8 77 06 00 00       	call   800a42 <cprintf>
  8003cb:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003ce:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		actualSize = kilo/8 - sizeOfMetaData(); 	//expected to be allocated in remaining of 4th free block
  8003d5:	c7 45 90 70 00 00 00 	movl   $0x70,-0x70(%ebp)
		va = tstStartVAs[numOfFFTests] = malloc(actualSize);
  8003dc:	83 ec 0c             	sub    $0xc,%esp
  8003df:	ff 75 90             	pushl  -0x70(%ebp)
  8003e2:	e8 86 14 00 00       	call   80186d <malloc>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8003ed:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003f0:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tstMidVAs[numOfFFTests] = va + actualSize/2 ;
  8003f3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003f6:	d1 e8                	shr    %eax
  8003f8:	89 c2                	mov    %eax,%edx
  8003fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		tstEndVAs[numOfFFTests] = va + actualSize - sizeof(short);
  800405:	8b 45 90             	mov    -0x70(%ebp),%eax
  800408:	8d 50 fe             	lea    -0x2(%eax),%edx
  80040b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80040e:	01 d0                	add    %edx,%eax
  800410:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		//Check returned va
		void* expected = (void*)(startOf4thFreeBlock + testSizes[0] + testSizes[2]) ;
  800416:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80041c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80041f:	01 c2                	add    %eax,%edx
  800421:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if(va == NULL || (va != expected))
  80042c:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  800430:	74 08                	je     80043a <_main+0x402>
  800432:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800435:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800438:	74 1d                	je     800457 <_main+0x41f>
		{
			is_correct = 0;
  80043a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #4: WRONG FF ALLOC - alloc_block_FF return wrong address.expected %x, actual %x\n", expected, va);
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	ff 75 ac             	pushl  -0x54(%ebp)
  800447:	ff 75 8c             	pushl  -0x74(%ebp)
  80044a:	68 40 39 80 00       	push   $0x803940
  80044f:	e8 ee 05 00 00       	call   800a42 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		}
		*(tstStartVAs[numOfFFTests]) = 353 + numOfFFTests;
  800457:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80045a:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstMidVAs[numOfFFTests]) = 353 + numOfFFTests;
  80045f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800465:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstEndVAs[numOfFFTests]) = 353 + numOfFFTests;
  80046a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800470:	66 c7 00 64 01       	movw   $0x164,(%eax)

		if (is_correct)
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	74 04                	je     80047f <_main+0x447>
		{
			eval += 30;
  80047b:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	68 9c 39 80 00       	push   $0x80399c
  800487:	e8 b6 05 00 00       	call   800a42 <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80048f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		for (int i = 0; i <= numOfFFTests; ++i)
  800496:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  80049d:	e9 ab 00 00 00       	jmp    80054d <_main+0x515>
		{
			//cprintf("startVA = %x, mid = %x, last = %x\n", tstStartVAs[i], tstMidVAs[i], tstEndVAs[i]);
			if (*(tstStartVAs[i]) != (353+i) || *(tstMidVAs[i]) != (353+i) || *(tstEndVAs[i]) != (353+i) )
  8004a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004a5:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8004ac:	66 8b 00             	mov    (%eax),%ax
  8004af:	98                   	cwtl   
  8004b0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b3:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004b9:	39 d0                	cmp    %edx,%eax
  8004bb:	75 36                	jne    8004f3 <_main+0x4bb>
  8004bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004c0:	8b 84 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%eax
  8004c7:	66 8b 00             	mov    (%eax),%ax
  8004ca:	98                   	cwtl   
  8004cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ce:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004d4:	39 d0                	cmp    %edx,%eax
  8004d6:	75 1b                	jne    8004f3 <_main+0x4bb>
  8004d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004db:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  8004e2:	66 8b 00             	mov    (%eax),%ax
  8004e5:	98                   	cwtl   
  8004e6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e9:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004ef:	39 d0                	cmp    %edx,%eax
  8004f1:	74 57                	je     80054a <_main+0x512>
			{
				is_correct = 0;
  8004f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc #5.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
  8004fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004fd:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800504:	66 8b 00             	mov    (%eax),%ax
  800507:	0f bf c8             	movswl %ax,%ecx
  80050a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050d:	8b 84 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%eax
  800514:	66 8b 00             	mov    (%eax),%ax
  800517:	0f bf d0             	movswl %ax,%edx
  80051a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80051d:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  800524:	66 8b 00             	mov    (%eax),%ax
  800527:	98                   	cwtl   
  800528:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80052b:	81 c3 61 01 00 00    	add    $0x161,%ebx
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	51                   	push   %ecx
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	53                   	push   %ebx
  800538:	ff 75 c4             	pushl  -0x3c(%ebp)
  80053b:	68 d0 39 80 00       	push   $0x8039d0
  800540:	e8 fd 04 00 00       	call   800a42 <cprintf>
  800545:	83 c4 20             	add    $0x20,%esp
				break;
  800548:	eb 0d                	jmp    800557 <_main+0x51f>
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i <= numOfFFTests; ++i)
  80054a:	ff 45 c4             	incl   -0x3c(%ebp)
  80054d:	83 7d c4 03          	cmpl   $0x3,-0x3c(%ebp)
  800551:	0f 8e 4b ff ff ff    	jle    8004a2 <_main+0x46a>
				cprintf("malloc #5.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
				break;
			}
		}

		if (is_correct)
  800557:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80055b:	74 04                	je     800561 <_main+0x529>
		{
			eval += 20;
  80055d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 5: Test a Non-Granted Request */
	cprintf("5: Test a Non-Granted Request\n\n") ;
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 34 3a 80 00       	push   $0x803a34
  800569:	e8 d4 04 00 00       	call   800a42 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800571:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 2*kilo - sizeOfMetaData();
  800578:	c7 45 90 f0 07 00 00 	movl   $0x7f0,-0x70(%ebp)

		//Fill the 7th free block
		va = malloc(actualSize);
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	ff 75 90             	pushl  -0x70(%ebp)
  800585:	e8 e3 12 00 00       	call   80186d <malloc>
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 45 ac             	mov    %eax,-0x54(%ebp)

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	6a 00                	push   $0x0
  800595:	e8 bd 12 00 00       	call   801857 <sbrk>
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	ba 00 00 00 82       	mov    $0x82000000,%edx
  8005a2:	29 c2                	sub    %eax,%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e8 0c             	shr    $0xc,%eax
  8005a9:	01 c0                	add    %eax,%eax
  8005ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8005ae:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8005b5:	eb 33                	jmp    8005ea <_main+0x5b2>
		{
			va = malloc(actualSize);
  8005b7:	83 ec 0c             	sub    $0xc,%esp
  8005ba:	ff 75 90             	pushl  -0x70(%ebp)
  8005bd:	e8 ab 12 00 00       	call   80186d <malloc>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if(va == NULL)
  8005c8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8005cc:	75 19                	jne    8005e7 <_main+0x5af>
			{
				is_correct = 0;
  8005ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #6.%d: WRONG FF ALLOC - alloc_block_FF return NULL address while it's expected to return correct one.\n");
  8005d5:	83 ec 0c             	sub    $0xc,%esp
  8005d8:	68 54 3a 80 00       	push   $0x803a54
  8005dd:	e8 60 04 00 00       	call   800a42 <cprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
				break;
  8005e5:	eb 0b                	jmp    8005f2 <_main+0x5ba>
		//Fill the 7th free block
		va = malloc(actualSize);

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8005e7:	ff 45 c0             	incl   -0x40(%ebp)
  8005ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005ed:	3b 45 88             	cmp    -0x78(%ebp),%eax
  8005f0:	72 c5                	jb     8005b7 <_main+0x57f>
				break;
			}
		}

		//Test two more allocs
		va = malloc(actualSize);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff 75 90             	pushl  -0x70(%ebp)
  8005f8:	e8 70 12 00 00       	call   80186d <malloc>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	89 45 ac             	mov    %eax,-0x54(%ebp)
		va = malloc(actualSize);
  800603:	83 ec 0c             	sub    $0xc,%esp
  800606:	ff 75 90             	pushl  -0x70(%ebp)
  800609:	e8 5f 12 00 00       	call   80186d <malloc>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	89 45 ac             	mov    %eax,-0x54(%ebp)

		if(va != NULL)
  800614:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  800618:	74 17                	je     800631 <_main+0x5f9>
		{
			is_correct = 0;
  80061a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #7: WRONG FF ALLOC - alloc_block_FF return an address while it's expected to return NULL since it reaches the hard limit.\n");
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	68 c4 3a 80 00       	push   $0x803ac4
  800629:	e8 14 04 00 00       	call   800a42 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800631:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800635:	74 04                	je     80063b <_main+0x603>
		{
			eval += 20;
  800637:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}
	cprintf("test FIRST FIT (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800641:	68 48 3b 80 00       	push   $0x803b48
  800646:	e8 f7 03 00 00       	call   800a42 <cprintf>
  80064b:	83 c4 10             	add    $0x10,%esp

	return;
  80064e:	90                   	nop
}
  80064f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800652:	5b                   	pop    %ebx
  800653:	5e                   	pop    %esi
  800654:	5f                   	pop    %edi
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065d:	e8 b5 18 00 00       	call   801f17 <sys_getenvindex>
  800662:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800668:	89 d0                	mov    %edx,%eax
  80066a:	01 c0                	add    %eax,%eax
  80066c:	01 d0                	add    %edx,%eax
  80066e:	c1 e0 06             	shl    $0x6,%eax
  800671:	29 d0                	sub    %edx,%eax
  800673:	c1 e0 03             	shl    $0x3,%eax
  800676:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80067b:	a3 40 50 80 00       	mov    %eax,0x805040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800680:	a1 40 50 80 00       	mov    0x805040,%eax
  800685:	8a 40 68             	mov    0x68(%eax),%al
  800688:	84 c0                	test   %al,%al
  80068a:	74 0d                	je     800699 <libmain+0x42>
		binaryname = myEnv->prog_name;
  80068c:	a1 40 50 80 00       	mov    0x805040,%eax
  800691:	83 c0 68             	add    $0x68,%eax
  800694:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80069d:	7e 0a                	jle    8006a9 <libmain+0x52>
		binaryname = argv[0];
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	_main(argc, argv);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 81 f9 ff ff       	call   800038 <_main>
  8006b7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006ba:	e8 65 16 00 00       	call   801d24 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 b4 3b 80 00       	push   $0x803bb4
  8006c7:	e8 76 03 00 00       	call   800a42 <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8006d4:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8006da:	a1 40 50 80 00       	mov    0x805040,%eax
  8006df:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8006e5:	83 ec 04             	sub    $0x4,%esp
  8006e8:	52                   	push   %edx
  8006e9:	50                   	push   %eax
  8006ea:	68 dc 3b 80 00       	push   $0x803bdc
  8006ef:	e8 4e 03 00 00       	call   800a42 <cprintf>
  8006f4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8006fc:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800702:	a1 40 50 80 00       	mov    0x805040,%eax
  800707:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80070d:	a1 40 50 80 00       	mov    0x805040,%eax
  800712:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800718:	51                   	push   %ecx
  800719:	52                   	push   %edx
  80071a:	50                   	push   %eax
  80071b:	68 04 3c 80 00       	push   $0x803c04
  800720:	e8 1d 03 00 00       	call   800a42 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800728:	a1 40 50 80 00       	mov    0x805040,%eax
  80072d:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	50                   	push   %eax
  800737:	68 5c 3c 80 00       	push   $0x803c5c
  80073c:	e8 01 03 00 00       	call   800a42 <cprintf>
  800741:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	68 b4 3b 80 00       	push   $0x803bb4
  80074c:	e8 f1 02 00 00       	call   800a42 <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800754:	e8 e5 15 00 00       	call   801d3e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800759:	e8 19 00 00 00       	call   800777 <exit>
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	6a 00                	push   $0x0
  80076c:	e8 72 17 00 00       	call   801ee3 <sys_destroy_env>
  800771:	83 c4 10             	add    $0x10,%esp
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <exit>:

void
exit(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80077d:	e8 c7 17 00 00       	call   801f49 <sys_exit_env>
}
  800782:	90                   	nop
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80078b:	8d 45 10             	lea    0x10(%ebp),%eax
  80078e:	83 c0 04             	add    $0x4,%eax
  800791:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800794:	a1 1c 93 80 00       	mov    0x80931c,%eax
  800799:	85 c0                	test   %eax,%eax
  80079b:	74 16                	je     8007b3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80079d:	a1 1c 93 80 00       	mov    0x80931c,%eax
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	50                   	push   %eax
  8007a6:	68 70 3c 80 00       	push   $0x803c70
  8007ab:	e8 92 02 00 00       	call   800a42 <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007b3:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	ff 75 08             	pushl  0x8(%ebp)
  8007be:	50                   	push   %eax
  8007bf:	68 75 3c 80 00       	push   $0x803c75
  8007c4:	e8 79 02 00 00       	call   800a42 <cprintf>
  8007c9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d5:	50                   	push   %eax
  8007d6:	e8 fc 01 00 00       	call   8009d7 <vcprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	6a 00                	push   $0x0
  8007e3:	68 91 3c 80 00       	push   $0x803c91
  8007e8:	e8 ea 01 00 00       	call   8009d7 <vcprintf>
  8007ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007f0:	e8 82 ff ff ff       	call   800777 <exit>

	// should not return here
	while (1) ;
  8007f5:	eb fe                	jmp    8007f5 <_panic+0x70>

008007f7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007fd:	a1 40 50 80 00       	mov    0x805040,%eax
  800802:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080b:	39 c2                	cmp    %eax,%edx
  80080d:	74 14                	je     800823 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80080f:	83 ec 04             	sub    $0x4,%esp
  800812:	68 94 3c 80 00       	push   $0x803c94
  800817:	6a 26                	push   $0x26
  800819:	68 e0 3c 80 00       	push   $0x803ce0
  80081e:	e8 62 ff ff ff       	call   800785 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800823:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80082a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800831:	e9 c5 00 00 00       	jmp    8008fb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800839:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	01 d0                	add    %edx,%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	85 c0                	test   %eax,%eax
  800849:	75 08                	jne    800853 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80084b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80084e:	e9 a5 00 00 00       	jmp    8008f8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800853:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800861:	eb 69                	jmp    8008cc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800863:	a1 40 50 80 00       	mov    0x805040,%eax
  800868:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80086e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800871:	89 d0                	mov    %edx,%eax
  800873:	01 c0                	add    %eax,%eax
  800875:	01 d0                	add    %edx,%eax
  800877:	c1 e0 03             	shl    $0x3,%eax
  80087a:	01 c8                	add    %ecx,%eax
  80087c:	8a 40 04             	mov    0x4(%eax),%al
  80087f:	84 c0                	test   %al,%al
  800881:	75 46                	jne    8008c9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800883:	a1 40 50 80 00       	mov    0x805040,%eax
  800888:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80088e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800891:	89 d0                	mov    %edx,%eax
  800893:	01 c0                	add    %eax,%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	c1 e0 03             	shl    $0x3,%eax
  80089a:	01 c8                	add    %ecx,%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	01 c8                	add    %ecx,%eax
  8008ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	75 09                	jne    8008c9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008c7:	eb 15                	jmp    8008de <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
  8008cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8008d1:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8008d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008da:	39 c2                	cmp    %eax,%edx
  8008dc:	77 85                	ja     800863 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e2:	75 14                	jne    8008f8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	68 ec 3c 80 00       	push   $0x803cec
  8008ec:	6a 3a                	push   $0x3a
  8008ee:	68 e0 3c 80 00       	push   $0x803ce0
  8008f3:	e8 8d fe ff ff       	call   800785 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008f8:	ff 45 f0             	incl   -0x10(%ebp)
  8008fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800901:	0f 8c 2f ff ff ff    	jl     800836 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800907:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800915:	eb 26                	jmp    80093d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800917:	a1 40 50 80 00       	mov    0x805040,%eax
  80091c:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800922:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800925:	89 d0                	mov    %edx,%eax
  800927:	01 c0                	add    %eax,%eax
  800929:	01 d0                	add    %edx,%eax
  80092b:	c1 e0 03             	shl    $0x3,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	8a 40 04             	mov    0x4(%eax),%al
  800933:	3c 01                	cmp    $0x1,%al
  800935:	75 03                	jne    80093a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800937:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093a:	ff 45 e0             	incl   -0x20(%ebp)
  80093d:	a1 40 50 80 00       	mov    0x805040,%eax
  800942:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800948:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094b:	39 c2                	cmp    %eax,%edx
  80094d:	77 c8                	ja     800917 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80094f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800952:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800955:	74 14                	je     80096b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 40 3d 80 00       	push   $0x803d40
  80095f:	6a 44                	push   $0x44
  800961:	68 e0 3c 80 00       	push   $0x803ce0
  800966:	e8 1a fe ff ff       	call   800785 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096b:	90                   	nop
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	8d 48 01             	lea    0x1(%eax),%ecx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	89 0a                	mov    %ecx,(%edx)
  800981:	8b 55 08             	mov    0x8(%ebp),%edx
  800984:	88 d1                	mov    %dl,%cl
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	3d ff 00 00 00       	cmp    $0xff,%eax
  800997:	75 2c                	jne    8009c5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800999:	a0 44 50 80 00       	mov    0x805044,%al
  80099e:	0f b6 c0             	movzbl %al,%eax
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a4:	8b 12                	mov    (%edx),%edx
  8009a6:	89 d1                	mov    %edx,%ecx
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	83 c2 08             	add    $0x8,%edx
  8009ae:	83 ec 04             	sub    $0x4,%esp
  8009b1:	50                   	push   %eax
  8009b2:	51                   	push   %ecx
  8009b3:	52                   	push   %edx
  8009b4:	e8 12 12 00 00       	call   801bcb <sys_cputs>
  8009b9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 40 04             	mov    0x4(%eax),%eax
  8009cb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d4:	90                   	nop
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e7:	00 00 00 
	b.cnt = 0;
  8009ea:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a00:	50                   	push   %eax
  800a01:	68 6e 09 80 00       	push   $0x80096e
  800a06:	e8 11 02 00 00       	call   800c1c <vprintfmt>
  800a0b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a0e:	a0 44 50 80 00       	mov    0x805044,%al
  800a13:	0f b6 c0             	movzbl %al,%eax
  800a16:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	50                   	push   %eax
  800a20:	52                   	push   %edx
  800a21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a27:	83 c0 08             	add    $0x8,%eax
  800a2a:	50                   	push   %eax
  800a2b:	e8 9b 11 00 00       	call   801bcb <sys_cputs>
  800a30:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a33:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800a3a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a48:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800a4f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	e8 73 ff ff ff       	call   8009d7 <vcprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a75:	e8 aa 12 00 00       	call   801d24 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	e8 48 ff ff ff       	call   8009d7 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a95:	e8 a4 12 00 00       	call   801d3e <sys_enable_interrupt>
	return cnt;
  800a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	53                   	push   %ebx
  800aa3:	83 ec 14             	sub    $0x14,%esp
  800aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800abd:	77 55                	ja     800b14 <printnum+0x75>
  800abf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac2:	72 05                	jb     800ac9 <printnum+0x2a>
  800ac4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ac7:	77 4b                	ja     800b14 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ac9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800acf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad7:	52                   	push   %edx
  800ad8:	50                   	push   %eax
  800ad9:	ff 75 f4             	pushl  -0xc(%ebp)
  800adc:	ff 75 f0             	pushl  -0x10(%ebp)
  800adf:	e8 f0 28 00 00       	call   8033d4 <__udivdi3>
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	ff 75 20             	pushl  0x20(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	ff 75 18             	pushl  0x18(%ebp)
  800af1:	52                   	push   %edx
  800af2:	50                   	push   %eax
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 a1 ff ff ff       	call   800a9f <printnum>
  800afe:	83 c4 20             	add    $0x20,%esp
  800b01:	eb 1a                	jmp    800b1d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	ff 75 20             	pushl  0x20(%ebp)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b14:	ff 4d 1c             	decl   0x1c(%ebp)
  800b17:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1b:	7f e6                	jg     800b03 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b1d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2b:	53                   	push   %ebx
  800b2c:	51                   	push   %ecx
  800b2d:	52                   	push   %edx
  800b2e:	50                   	push   %eax
  800b2f:	e8 b0 29 00 00       	call   8034e4 <__umoddi3>
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	0f be c0             	movsbl %al,%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
}
  800b50:	90                   	nop
  800b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5d:	7e 1c                	jle    800b7b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	8d 50 08             	lea    0x8(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	89 10                	mov    %edx,(%eax)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	83 e8 08             	sub    $0x8,%eax
  800b74:	8b 50 04             	mov    0x4(%eax),%edx
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	eb 40                	jmp    800bbb <getuint+0x65>
	else if (lflag)
  800b7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7f:	74 1e                	je     800b9f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	8d 50 04             	lea    0x4(%eax),%edx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	89 10                	mov    %edx,(%eax)
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	83 e8 04             	sub    $0x4,%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9d:	eb 1c                	jmp    800bbb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	8d 50 04             	lea    0x4(%eax),%edx
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 10                	mov    %edx,(%eax)
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	83 e8 04             	sub    $0x4,%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc4:	7e 1c                	jle    800be2 <getint+0x25>
		return va_arg(*ap, long long);
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	8d 50 08             	lea    0x8(%eax),%edx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	89 10                	mov    %edx,(%eax)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	83 e8 08             	sub    $0x8,%eax
  800bdb:	8b 50 04             	mov    0x4(%eax),%edx
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	eb 38                	jmp    800c1a <getint+0x5d>
	else if (lflag)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 1a                	je     800c02 <getint+0x45>
		return va_arg(*ap, long);
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	8d 50 04             	lea    0x4(%eax),%edx
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	89 10                	mov    %edx,(%eax)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	83 e8 04             	sub    $0x4,%eax
  800bfd:	8b 00                	mov    (%eax),%eax
  800bff:	99                   	cltd   
  800c00:	eb 18                	jmp    800c1a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	8d 50 04             	lea    0x4(%eax),%edx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 10                	mov    %edx,(%eax)
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	83 e8 04             	sub    $0x4,%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	99                   	cltd   
}
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c24:	eb 17                	jmp    800c3d <vprintfmt+0x21>
			if (ch == '\0')
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	0f 84 af 03 00 00    	je     800fdd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	53                   	push   %ebx
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	ff d0                	call   *%eax
  800c3a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	8d 50 01             	lea    0x1(%eax),%edx
  800c43:	89 55 10             	mov    %edx,0x10(%ebp)
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	0f b6 d8             	movzbl %al,%ebx
  800c4b:	83 fb 25             	cmp    $0x25,%ebx
  800c4e:	75 d6                	jne    800c26 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c50:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c54:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c69:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	8d 50 01             	lea    0x1(%eax),%edx
  800c76:	89 55 10             	mov    %edx,0x10(%ebp)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f b6 d8             	movzbl %al,%ebx
  800c7e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c81:	83 f8 55             	cmp    $0x55,%eax
  800c84:	0f 87 2b 03 00 00    	ja     800fb5 <vprintfmt+0x399>
  800c8a:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  800c91:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c93:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c97:	eb d7                	jmp    800c70 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c99:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c9d:	eb d1                	jmp    800c70 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c9f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ca9:	89 d0                	mov    %edx,%eax
  800cab:	c1 e0 02             	shl    $0x2,%eax
  800cae:	01 d0                	add    %edx,%eax
  800cb0:	01 c0                	add    %eax,%eax
  800cb2:	01 d8                	add    %ebx,%eax
  800cb4:	83 e8 30             	sub    $0x30,%eax
  800cb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc2:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc5:	7e 3e                	jle    800d05 <vprintfmt+0xe9>
  800cc7:	83 fb 39             	cmp    $0x39,%ebx
  800cca:	7f 39                	jg     800d05 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ccf:	eb d5                	jmp    800ca6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd4:	83 c0 04             	add    $0x4,%eax
  800cd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 e8 04             	sub    $0x4,%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce5:	eb 1f                	jmp    800d06 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	79 83                	jns    800c70 <vprintfmt+0x54>
				width = 0;
  800ced:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf4:	e9 77 ff ff ff       	jmp    800c70 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cf9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d00:	e9 6b ff ff ff       	jmp    800c70 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d05:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0a:	0f 89 60 ff ff ff    	jns    800c70 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d16:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d1d:	e9 4e ff ff ff       	jmp    800c70 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d22:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d25:	e9 46 ff ff ff       	jmp    800c70 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2d:	83 c0 04             	add    $0x4,%eax
  800d30:	89 45 14             	mov    %eax,0x14(%ebp)
  800d33:	8b 45 14             	mov    0x14(%ebp),%eax
  800d36:	83 e8 04             	sub    $0x4,%eax
  800d39:	8b 00                	mov    (%eax),%eax
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	50                   	push   %eax
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
			break;
  800d4a:	e9 89 02 00 00       	jmp    800fd8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 14             	mov    %eax,0x14(%ebp)
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 e8 04             	sub    $0x4,%eax
  800d5e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d60:	85 db                	test   %ebx,%ebx
  800d62:	79 02                	jns    800d66 <vprintfmt+0x14a>
				err = -err;
  800d64:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d66:	83 fb 64             	cmp    $0x64,%ebx
  800d69:	7f 0b                	jg     800d76 <vprintfmt+0x15a>
  800d6b:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800d72:	85 f6                	test   %esi,%esi
  800d74:	75 19                	jne    800d8f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d76:	53                   	push   %ebx
  800d77:	68 c5 3f 80 00       	push   $0x803fc5
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	ff 75 08             	pushl  0x8(%ebp)
  800d82:	e8 5e 02 00 00       	call   800fe5 <printfmt>
  800d87:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8a:	e9 49 02 00 00       	jmp    800fd8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d8f:	56                   	push   %esi
  800d90:	68 ce 3f 80 00       	push   $0x803fce
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	ff 75 08             	pushl  0x8(%ebp)
  800d9b:	e8 45 02 00 00       	call   800fe5 <printfmt>
  800da0:	83 c4 10             	add    $0x10,%esp
			break;
  800da3:	e9 30 02 00 00       	jmp    800fd8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	83 c0 04             	add    $0x4,%eax
  800dae:	89 45 14             	mov    %eax,0x14(%ebp)
  800db1:	8b 45 14             	mov    0x14(%ebp),%eax
  800db4:	83 e8 04             	sub    $0x4,%eax
  800db7:	8b 30                	mov    (%eax),%esi
  800db9:	85 f6                	test   %esi,%esi
  800dbb:	75 05                	jne    800dc2 <vprintfmt+0x1a6>
				p = "(null)";
  800dbd:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  800dc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc6:	7e 6d                	jle    800e35 <vprintfmt+0x219>
  800dc8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcc:	74 67                	je     800e35 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	50                   	push   %eax
  800dd5:	56                   	push   %esi
  800dd6:	e8 0c 03 00 00       	call   8010e7 <strnlen>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de1:	eb 16                	jmp    800df9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	50                   	push   %eax
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	ff d0                	call   *%eax
  800df3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df6:	ff 4d e4             	decl   -0x1c(%ebp)
  800df9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfd:	7f e4                	jg     800de3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dff:	eb 34                	jmp    800e35 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e05:	74 1c                	je     800e23 <vprintfmt+0x207>
  800e07:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0a:	7e 05                	jle    800e11 <vprintfmt+0x1f5>
  800e0c:	83 fb 7e             	cmp    $0x7e,%ebx
  800e0f:	7e 12                	jle    800e23 <vprintfmt+0x207>
					putch('?', putdat);
  800e11:	83 ec 08             	sub    $0x8,%esp
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	6a 3f                	push   $0x3f
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	ff d0                	call   *%eax
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	eb 0f                	jmp    800e32 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e23:	83 ec 08             	sub    $0x8,%esp
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	53                   	push   %ebx
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	ff d0                	call   *%eax
  800e2f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e32:	ff 4d e4             	decl   -0x1c(%ebp)
  800e35:	89 f0                	mov    %esi,%eax
  800e37:	8d 70 01             	lea    0x1(%eax),%esi
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	0f be d8             	movsbl %al,%ebx
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	74 24                	je     800e67 <vprintfmt+0x24b>
  800e43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e47:	78 b8                	js     800e01 <vprintfmt+0x1e5>
  800e49:	ff 4d e0             	decl   -0x20(%ebp)
  800e4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e50:	79 af                	jns    800e01 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e52:	eb 13                	jmp    800e67 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e54:	83 ec 08             	sub    $0x8,%esp
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	6a 20                	push   $0x20
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	ff d0                	call   *%eax
  800e61:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e64:	ff 4d e4             	decl   -0x1c(%ebp)
  800e67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6b:	7f e7                	jg     800e54 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e6d:	e9 66 01 00 00       	jmp    800fd8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e72:	83 ec 08             	sub    $0x8,%esp
  800e75:	ff 75 e8             	pushl  -0x18(%ebp)
  800e78:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7b:	50                   	push   %eax
  800e7c:	e8 3c fd ff ff       	call   800bbd <getint>
  800e81:	83 c4 10             	add    $0x10,%esp
  800e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e90:	85 d2                	test   %edx,%edx
  800e92:	79 23                	jns    800eb7 <vprintfmt+0x29b>
				putch('-', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	6a 2d                	push   $0x2d
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	ff d0                	call   *%eax
  800ea1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaa:	f7 d8                	neg    %eax
  800eac:	83 d2 00             	adc    $0x0,%edx
  800eaf:	f7 da                	neg    %edx
  800eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eb7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ebe:	e9 bc 00 00 00       	jmp    800f7f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec3:	83 ec 08             	sub    $0x8,%esp
  800ec6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecc:	50                   	push   %eax
  800ecd:	e8 84 fc ff ff       	call   800b56 <getuint>
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800edb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee2:	e9 98 00 00 00       	jmp    800f7f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 58                	push   $0x58
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 58                	push   $0x58
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	ff 75 0c             	pushl  0xc(%ebp)
  800f0d:	6a 58                	push   $0x58
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	ff d0                	call   *%eax
  800f14:	83 c4 10             	add    $0x10,%esp
			break;
  800f17:	e9 bc 00 00 00       	jmp    800fd8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	ff 75 0c             	pushl  0xc(%ebp)
  800f22:	6a 30                	push   $0x30
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	ff d0                	call   *%eax
  800f29:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	6a 78                	push   $0x78
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 14             	mov    %eax,0x14(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 e8 04             	sub    $0x4,%eax
  800f4b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f57:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f5e:	eb 1f                	jmp    800f7f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	ff 75 e8             	pushl  -0x18(%ebp)
  800f66:	8d 45 14             	lea    0x14(%ebp),%eax
  800f69:	50                   	push   %eax
  800f6a:	e8 e7 fb ff ff       	call   800b56 <getuint>
  800f6f:	83 c4 10             	add    $0x10,%esp
  800f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f7f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	52                   	push   %edx
  800f8a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f8d:	50                   	push   %eax
  800f8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f91:	ff 75 f0             	pushl  -0x10(%ebp)
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 00 fb ff ff       	call   800a9f <printnum>
  800f9f:	83 c4 20             	add    $0x20,%esp
			break;
  800fa2:	eb 34                	jmp    800fd8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa4:	83 ec 08             	sub    $0x8,%esp
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	53                   	push   %ebx
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
			break;
  800fb3:	eb 23                	jmp    800fd8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	6a 25                	push   $0x25
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	ff d0                	call   *%eax
  800fc2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc5:	ff 4d 10             	decl   0x10(%ebp)
  800fc8:	eb 03                	jmp    800fcd <vprintfmt+0x3b1>
  800fca:	ff 4d 10             	decl   0x10(%ebp)
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	48                   	dec    %eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 25                	cmp    $0x25,%al
  800fd5:	75 f3                	jne    800fca <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fd7:	90                   	nop
		}
	}
  800fd8:	e9 47 fc ff ff       	jmp    800c24 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fdd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800feb:	8d 45 10             	lea    0x10(%ebp),%eax
  800fee:	83 c0 04             	add    $0x4,%eax
  800ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffa:	50                   	push   %eax
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	ff 75 08             	pushl  0x8(%ebp)
  801001:	e8 16 fc ff ff       	call   800c1c <vprintfmt>
  801006:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801009:	90                   	nop
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	8b 40 08             	mov    0x8(%eax),%eax
  801015:	8d 50 01             	lea    0x1(%eax),%edx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	8b 10                	mov    (%eax),%edx
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8b 40 04             	mov    0x4(%eax),%eax
  801029:	39 c2                	cmp    %eax,%edx
  80102b:	73 12                	jae    80103f <sprintputch+0x33>
		*b->buf++ = ch;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	8b 00                	mov    (%eax),%eax
  801032:	8d 48 01             	lea    0x1(%eax),%ecx
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	89 0a                	mov    %ecx,(%edx)
  80103a:	8b 55 08             	mov    0x8(%ebp),%edx
  80103d:	88 10                	mov    %dl,(%eax)
}
  80103f:	90                   	nop
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	8d 50 ff             	lea    -0x1(%eax),%edx
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801067:	74 06                	je     80106f <vsnprintf+0x2d>
  801069:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80106d:	7f 07                	jg     801076 <vsnprintf+0x34>
		return -E_INVAL;
  80106f:	b8 03 00 00 00       	mov    $0x3,%eax
  801074:	eb 20                	jmp    801096 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801076:	ff 75 14             	pushl  0x14(%ebp)
  801079:	ff 75 10             	pushl  0x10(%ebp)
  80107c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	68 0c 10 80 00       	push   $0x80100c
  801085:	e8 92 fb ff ff       	call   800c1c <vprintfmt>
  80108a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80108d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801090:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801093:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80109e:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a1:	83 c0 04             	add    $0x4,%eax
  8010a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ad:	50                   	push   %eax
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	ff 75 08             	pushl  0x8(%ebp)
  8010b4:	e8 89 ff ff ff       	call   801042 <vsnprintf>
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d1:	eb 06                	jmp    8010d9 <strlen+0x15>
		n++;
  8010d3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d6:	ff 45 08             	incl   0x8(%ebp)
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	84 c0                	test   %al,%al
  8010e0:	75 f1                	jne    8010d3 <strlen+0xf>
		n++;
	return n;
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f4:	eb 09                	jmp    8010ff <strnlen+0x18>
		n++;
  8010f6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	ff 4d 0c             	decl   0xc(%ebp)
  8010ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801103:	74 09                	je     80110e <strnlen+0x27>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	84 c0                	test   %al,%al
  80110c:	75 e8                	jne    8010f6 <strnlen+0xf>
		n++;
	return n;
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80111f:	90                   	nop
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8d 50 01             	lea    0x1(%eax),%edx
  801126:	89 55 08             	mov    %edx,0x8(%ebp)
  801129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801132:	8a 12                	mov    (%edx),%dl
  801134:	88 10                	mov    %dl,(%eax)
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e4                	jne    801120 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801154:	eb 1f                	jmp    801175 <strncpy+0x34>
		*dst++ = *src;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8d 50 01             	lea    0x1(%eax),%edx
  80115c:	89 55 08             	mov    %edx,0x8(%ebp)
  80115f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801162:	8a 12                	mov    (%edx),%dl
  801164:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	84 c0                	test   %al,%al
  80116d:	74 03                	je     801172 <strncpy+0x31>
			src++;
  80116f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801172:	ff 45 fc             	incl   -0x4(%ebp)
  801175:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801178:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117b:	72 d9                	jb     801156 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80118e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801192:	74 30                	je     8011c4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801194:	eb 16                	jmp    8011ac <strlcpy+0x2a>
			*dst++ = *src++;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8d 50 01             	lea    0x1(%eax),%edx
  80119c:	89 55 08             	mov    %edx,0x8(%ebp)
  80119f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011a8:	8a 12                	mov    (%edx),%dl
  8011aa:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ac:	ff 4d 10             	decl   0x10(%ebp)
  8011af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b3:	74 09                	je     8011be <strlcpy+0x3c>
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	84 c0                	test   %al,%al
  8011bc:	75 d8                	jne    801196 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ca:	29 c2                	sub    %eax,%edx
  8011cc:	89 d0                	mov    %edx,%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011d3:	eb 06                	jmp    8011db <strcmp+0xb>
		p++, q++;
  8011d5:	ff 45 08             	incl   0x8(%ebp)
  8011d8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 0e                	je     8011f2 <strcmp+0x22>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 10                	mov    (%eax),%dl
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	38 c2                	cmp    %al,%dl
  8011f0:	74 e3                	je     8011d5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f b6 d0             	movzbl %al,%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	0f b6 c0             	movzbl %al,%eax
  801202:	29 c2                	sub    %eax,%edx
  801204:	89 d0                	mov    %edx,%eax
}
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80120b:	eb 09                	jmp    801216 <strncmp+0xe>
		n--, p++, q++;
  80120d:	ff 4d 10             	decl   0x10(%ebp)
  801210:	ff 45 08             	incl   0x8(%ebp)
  801213:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121a:	74 17                	je     801233 <strncmp+0x2b>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	84 c0                	test   %al,%al
  801223:	74 0e                	je     801233 <strncmp+0x2b>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 10                	mov    (%eax),%dl
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	38 c2                	cmp    %al,%dl
  801231:	74 da                	je     80120d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801233:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801237:	75 07                	jne    801240 <strncmp+0x38>
		return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
  80123e:	eb 14                	jmp    801254 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f b6 d0             	movzbl %al,%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f b6 c0             	movzbl %al,%eax
  801250:	29 c2                	sub    %eax,%edx
  801252:	89 d0                	mov    %edx,%eax
}
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801262:	eb 12                	jmp    801276 <strchr+0x20>
		if (*s == c)
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80126c:	75 05                	jne    801273 <strchr+0x1d>
			return (char *) s;
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	eb 11                	jmp    801284 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	84 c0                	test   %al,%al
  80127d:	75 e5                	jne    801264 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 04             	sub    $0x4,%esp
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801292:	eb 0d                	jmp    8012a1 <strfind+0x1b>
		if (*s == c)
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129c:	74 0e                	je     8012ac <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	84 c0                	test   %al,%al
  8012a8:	75 ea                	jne    801294 <strfind+0xe>
  8012aa:	eb 01                	jmp    8012ad <strfind+0x27>
		if (*s == c)
			break;
  8012ac:	90                   	nop
	return (char *) s;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012c4:	eb 0e                	jmp    8012d4 <memset+0x22>
		*p++ = c;
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8d 50 01             	lea    0x1(%eax),%edx
  8012cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012d4:	ff 4d f8             	decl   -0x8(%ebp)
  8012d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012db:	79 e9                	jns    8012c6 <memset+0x14>
		*p++ = c;

	return v;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012f4:	eb 16                	jmp    80130c <memcpy+0x2a>
		*d++ = *s++;
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	8d 50 01             	lea    0x1(%eax),%edx
  8012fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801302:	8d 4a 01             	lea    0x1(%edx),%ecx
  801305:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801308:	8a 12                	mov    (%edx),%dl
  80130a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801312:	89 55 10             	mov    %edx,0x10(%ebp)
  801315:	85 c0                	test   %eax,%eax
  801317:	75 dd                	jne    8012f6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801336:	73 50                	jae    801388 <memmove+0x6a>
  801338:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80133b:	8b 45 10             	mov    0x10(%ebp),%eax
  80133e:	01 d0                	add    %edx,%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	76 43                	jbe    801388 <memmove+0x6a>
		s += n;
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801351:	eb 10                	jmp    801363 <memmove+0x45>
			*--d = *--s;
  801353:	ff 4d f8             	decl   -0x8(%ebp)
  801356:	ff 4d fc             	decl   -0x4(%ebp)
  801359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135c:	8a 10                	mov    (%eax),%dl
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	8d 50 ff             	lea    -0x1(%eax),%edx
  801369:	89 55 10             	mov    %edx,0x10(%ebp)
  80136c:	85 c0                	test   %eax,%eax
  80136e:	75 e3                	jne    801353 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801370:	eb 23                	jmp    801395 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801375:	8d 50 01             	lea    0x1(%eax),%edx
  801378:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801381:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801384:	8a 12                	mov    (%edx),%dl
  801386:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801388:	8b 45 10             	mov    0x10(%ebp),%eax
  80138b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80138e:	89 55 10             	mov    %edx,0x10(%ebp)
  801391:	85 c0                	test   %eax,%eax
  801393:	75 dd                	jne    801372 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013ac:	eb 2a                	jmp    8013d8 <memcmp+0x3e>
		if (*s1 != *s2)
  8013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b1:	8a 10                	mov    (%eax),%dl
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	38 c2                	cmp    %al,%dl
  8013ba:	74 16                	je     8013d2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	0f b6 d0             	movzbl %al,%edx
  8013c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	0f b6 c0             	movzbl %al,%eax
  8013cc:	29 c2                	sub    %eax,%edx
  8013ce:	89 d0                	mov    %edx,%eax
  8013d0:	eb 18                	jmp    8013ea <memcmp+0x50>
		s1++, s2++;
  8013d2:	ff 45 fc             	incl   -0x4(%ebp)
  8013d5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013de:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	75 c9                	jne    8013ae <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013fd:	eb 15                	jmp    801414 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	0f b6 d0             	movzbl %al,%edx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	0f b6 c0             	movzbl %al,%eax
  80140d:	39 c2                	cmp    %eax,%edx
  80140f:	74 0d                	je     80141e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80141a:	72 e3                	jb     8013ff <memfind+0x13>
  80141c:	eb 01                	jmp    80141f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80141e:	90                   	nop
	return (void *) s;
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80142a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801431:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801438:	eb 03                	jmp    80143d <strtol+0x19>
		s++;
  80143a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 20                	cmp    $0x20,%al
  801444:	74 f4                	je     80143a <strtol+0x16>
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	3c 09                	cmp    $0x9,%al
  80144d:	74 eb                	je     80143a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 2b                	cmp    $0x2b,%al
  801456:	75 05                	jne    80145d <strtol+0x39>
		s++;
  801458:	ff 45 08             	incl   0x8(%ebp)
  80145b:	eb 13                	jmp    801470 <strtol+0x4c>
	else if (*s == '-')
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 2d                	cmp    $0x2d,%al
  801464:	75 0a                	jne    801470 <strtol+0x4c>
		s++, neg = 1;
  801466:	ff 45 08             	incl   0x8(%ebp)
  801469:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801470:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801474:	74 06                	je     80147c <strtol+0x58>
  801476:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80147a:	75 20                	jne    80149c <strtol+0x78>
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	3c 30                	cmp    $0x30,%al
  801483:	75 17                	jne    80149c <strtol+0x78>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	40                   	inc    %eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	3c 78                	cmp    $0x78,%al
  80148d:	75 0d                	jne    80149c <strtol+0x78>
		s += 2, base = 16;
  80148f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801493:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80149a:	eb 28                	jmp    8014c4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80149c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a0:	75 15                	jne    8014b7 <strtol+0x93>
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	3c 30                	cmp    $0x30,%al
  8014a9:	75 0c                	jne    8014b7 <strtol+0x93>
		s++, base = 8;
  8014ab:	ff 45 08             	incl   0x8(%ebp)
  8014ae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014b5:	eb 0d                	jmp    8014c4 <strtol+0xa0>
	else if (base == 0)
  8014b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bb:	75 07                	jne    8014c4 <strtol+0xa0>
		base = 10;
  8014bd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3c 2f                	cmp    $0x2f,%al
  8014cb:	7e 19                	jle    8014e6 <strtol+0xc2>
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	3c 39                	cmp    $0x39,%al
  8014d4:	7f 10                	jg     8014e6 <strtol+0xc2>
			dig = *s - '0';
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	0f be c0             	movsbl %al,%eax
  8014de:	83 e8 30             	sub    $0x30,%eax
  8014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e4:	eb 42                	jmp    801528 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	3c 60                	cmp    $0x60,%al
  8014ed:	7e 19                	jle    801508 <strtol+0xe4>
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	3c 7a                	cmp    $0x7a,%al
  8014f6:	7f 10                	jg     801508 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	0f be c0             	movsbl %al,%eax
  801500:	83 e8 57             	sub    $0x57,%eax
  801503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801506:	eb 20                	jmp    801528 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	3c 40                	cmp    $0x40,%al
  80150f:	7e 39                	jle    80154a <strtol+0x126>
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	3c 5a                	cmp    $0x5a,%al
  801518:	7f 30                	jg     80154a <strtol+0x126>
			dig = *s - 'A' + 10;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f be c0             	movsbl %al,%eax
  801522:	83 e8 37             	sub    $0x37,%eax
  801525:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80152e:	7d 19                	jge    801549 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801530:	ff 45 08             	incl   0x8(%ebp)
  801533:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801536:	0f af 45 10          	imul   0x10(%ebp),%eax
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153f:	01 d0                	add    %edx,%eax
  801541:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801544:	e9 7b ff ff ff       	jmp    8014c4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801549:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80154a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154e:	74 08                	je     801558 <strtol+0x134>
		*endptr = (char *) s;
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	8b 55 08             	mov    0x8(%ebp),%edx
  801556:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801558:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80155c:	74 07                	je     801565 <strtol+0x141>
  80155e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801561:	f7 d8                	neg    %eax
  801563:	eb 03                	jmp    801568 <strtol+0x144>
  801565:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <ltostr>:

void
ltostr(long value, char *str)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801570:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801577:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80157e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801582:	79 13                	jns    801597 <ltostr+0x2d>
	{
		neg = 1;
  801584:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801591:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801594:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80159f:	99                   	cltd   
  8015a0:	f7 f9                	idiv   %ecx
  8015a2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a8:	8d 50 01             	lea    0x1(%eax),%edx
  8015ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	01 d0                	add    %edx,%eax
  8015b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b8:	83 c2 30             	add    $0x30,%edx
  8015bb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015c5:	f7 e9                	imul   %ecx
  8015c7:	c1 fa 02             	sar    $0x2,%edx
  8015ca:	89 c8                	mov    %ecx,%eax
  8015cc:	c1 f8 1f             	sar    $0x1f,%eax
  8015cf:	29 c2                	sub    %eax,%edx
  8015d1:	89 d0                	mov    %edx,%eax
  8015d3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015de:	f7 e9                	imul   %ecx
  8015e0:	c1 fa 02             	sar    $0x2,%edx
  8015e3:	89 c8                	mov    %ecx,%eax
  8015e5:	c1 f8 1f             	sar    $0x1f,%eax
  8015e8:	29 c2                	sub    %eax,%edx
  8015ea:	89 d0                	mov    %edx,%eax
  8015ec:	c1 e0 02             	shl    $0x2,%eax
  8015ef:	01 d0                	add    %edx,%eax
  8015f1:	01 c0                	add    %eax,%eax
  8015f3:	29 c1                	sub    %eax,%ecx
  8015f5:	89 ca                	mov    %ecx,%edx
  8015f7:	85 d2                	test   %edx,%edx
  8015f9:	75 9c                	jne    801597 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801602:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801605:	48                   	dec    %eax
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801609:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80160d:	74 3d                	je     80164c <ltostr+0xe2>
		start = 1 ;
  80160f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801616:	eb 34                	jmp    80164c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	8a 00                	mov    (%eax),%al
  801622:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 c2                	add    %eax,%edx
  80162d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	01 c8                	add    %ecx,%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801639:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	01 c2                	add    %eax,%edx
  801641:	8a 45 eb             	mov    -0x15(%ebp),%al
  801644:	88 02                	mov    %al,(%edx)
		start++ ;
  801646:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801649:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801652:	7c c4                	jl     801618 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801654:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	01 d0                	add    %edx,%eax
  80165c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	e8 54 fa ff ff       	call   8010c4 <strlen>
  801670:	83 c4 04             	add    $0x4,%esp
  801673:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	e8 46 fa ff ff       	call   8010c4 <strlen>
  80167e:	83 c4 04             	add    $0x4,%esp
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80168b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801692:	eb 17                	jmp    8016ab <strcconcat+0x49>
		final[s] = str1[s] ;
  801694:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801697:	8b 45 10             	mov    0x10(%ebp),%eax
  80169a:	01 c2                	add    %eax,%edx
  80169c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	01 c8                	add    %ecx,%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016a8:	ff 45 fc             	incl   -0x4(%ebp)
  8016ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016b1:	7c e1                	jl     801694 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016c1:	eb 1f                	jmp    8016e2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8d 50 01             	lea    0x1(%eax),%edx
  8016c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016cc:	89 c2                	mov    %eax,%edx
  8016ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d1:	01 c2                	add    %eax,%edx
  8016d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	01 c8                	add    %ecx,%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016df:	ff 45 f8             	incl   -0x8(%ebp)
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016e8:	7c d9                	jl     8016c3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	c6 00 00             	movb   $0x0,(%eax)
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801710:	8b 45 10             	mov    0x10(%ebp),%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80171b:	eb 0c                	jmp    801729 <strsplit+0x31>
			*string++ = 0;
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8d 50 01             	lea    0x1(%eax),%edx
  801723:	89 55 08             	mov    %edx,0x8(%ebp)
  801726:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8a 00                	mov    (%eax),%al
  80172e:	84 c0                	test   %al,%al
  801730:	74 18                	je     80174a <strsplit+0x52>
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	0f be c0             	movsbl %al,%eax
  80173a:	50                   	push   %eax
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	e8 13 fb ff ff       	call   801256 <strchr>
  801743:	83 c4 08             	add    $0x8,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	75 d3                	jne    80171d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	84 c0                	test   %al,%al
  801751:	74 5a                	je     8017ad <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	83 f8 0f             	cmp    $0xf,%eax
  80175b:	75 07                	jne    801764 <strsplit+0x6c>
		{
			return 0;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	eb 66                	jmp    8017ca <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801764:	8b 45 14             	mov    0x14(%ebp),%eax
  801767:	8b 00                	mov    (%eax),%eax
  801769:	8d 48 01             	lea    0x1(%eax),%ecx
  80176c:	8b 55 14             	mov    0x14(%ebp),%edx
  80176f:	89 0a                	mov    %ecx,(%edx)
  801771:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801778:	8b 45 10             	mov    0x10(%ebp),%eax
  80177b:	01 c2                	add    %eax,%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801782:	eb 03                	jmp    801787 <strsplit+0x8f>
			string++;
  801784:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8a 00                	mov    (%eax),%al
  80178c:	84 c0                	test   %al,%al
  80178e:	74 8b                	je     80171b <strsplit+0x23>
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	0f be c0             	movsbl %al,%eax
  801798:	50                   	push   %eax
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	e8 b5 fa ff ff       	call   801256 <strchr>
  8017a1:	83 c4 08             	add    $0x8,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	74 dc                	je     801784 <strsplit+0x8c>
			string++;
	}
  8017a8:	e9 6e ff ff ff       	jmp    80171b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ad:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b1:	8b 00                	mov    (%eax),%eax
  8017b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bd:	01 d0                	add    %edx,%eax
  8017bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8017d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017d9:	eb 4c                	jmp    801827 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8017db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	01 d0                	add    %edx,%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	3c 40                	cmp    $0x40,%al
  8017e7:	7e 27                	jle    801810 <str2lower+0x44>
  8017e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	3c 5a                	cmp    $0x5a,%al
  8017f5:	7f 19                	jg     801810 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8017f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	01 d0                	add    %edx,%eax
  8017ff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	01 ca                	add    %ecx,%edx
  801807:	8a 12                	mov    (%edx),%dl
  801809:	83 c2 20             	add    $0x20,%edx
  80180c:	88 10                	mov    %dl,(%eax)
  80180e:	eb 14                	jmp    801824 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801810:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	01 c2                	add    %eax,%edx
  801818:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	01 c8                	add    %ecx,%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801824:	ff 45 fc             	incl   -0x4(%ebp)
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	e8 95 f8 ff ff       	call   8010c4 <strlen>
  80182f:	83 c4 04             	add    $0x4,%esp
  801832:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801835:	7f a4                	jg     8017db <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801841:	a1 20 50 80 00       	mov    0x805020,%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	74 0a                	je     801854 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80184a:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  801851:	00 00 00 
	}
}
  801854:	90                   	nop
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80185d:	83 ec 0c             	sub    $0xc,%esp
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 7e 09 00 00       	call   8021e6 <sys_sbrk>
  801868:	83 c4 10             	add    $0x10,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801873:	e8 c6 ff ff ff       	call   80183e <InitializeUHeap>
	if (size == 0)
  801878:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187c:	75 0a                	jne    801888 <malloc+0x1b>
		return NULL;
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	e9 3f 01 00 00       	jmp    8019c7 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801888:	e8 ac 09 00 00       	call   802239 <sys_get_hard_limit>
  80188d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801890:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80189f:	c1 e8 0c             	shr    $0xc,%eax
  8018a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8018a5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8018ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8018af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018b2:	01 d0                	add    %edx,%eax
  8018b4:	48                   	dec    %eax
  8018b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c0:	f7 75 d8             	divl   -0x28(%ebp)
  8018c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018c6:	29 d0                	sub    %edx,%eax
  8018c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8018cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018ce:	c1 e8 0c             	shr    $0xc,%eax
  8018d1:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8018d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d8:	75 0a                	jne    8018e4 <malloc+0x77>
		return NULL;
  8018da:	b8 00 00 00 00       	mov    $0x0,%eax
  8018df:	e9 e3 00 00 00       	jmp    8019c7 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8018e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e7:	05 00 00 00 80       	add    $0x80000000,%eax
  8018ec:	c1 e8 0c             	shr    $0xc,%eax
  8018ef:	a3 20 93 80 00       	mov    %eax,0x809320

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018f4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018fb:	77 19                	ja     801916 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	e8 44 0b 00 00       	call   80244c <alloc_block_FF>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  80190e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801911:	e9 b1 00 00 00       	jmp    8019c7 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801916:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801919:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80191c:	eb 4d                	jmp    80196b <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  80191e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801921:	8a 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%al
  801928:	84 c0                	test   %al,%al
  80192a:	75 27                	jne    801953 <malloc+0xe6>
			{
				counter++;
  80192c:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  80192f:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801933:	75 14                	jne    801949 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801938:	05 00 00 08 00       	add    $0x80000,%eax
  80193d:	c1 e0 0c             	shl    $0xc,%eax
  801940:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801946:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80194f:	75 17                	jne    801968 <malloc+0xfb>
				{
					break;
  801951:	eb 21                	jmp    801974 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801956:	8a 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%al
  80195d:	3c 01                	cmp    $0x1,%al
  80195f:	75 07                	jne    801968 <malloc+0xfb>
			{
				counter = 0;
  801961:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801968:	ff 45 e8             	incl   -0x18(%ebp)
  80196b:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801972:	76 aa                	jbe    80191e <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801977:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80197a:	75 46                	jne    8019c2 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	ff 75 d0             	pushl  -0x30(%ebp)
  801982:	ff 75 f4             	pushl  -0xc(%ebp)
  801985:	e8 93 08 00 00       	call   80221d <sys_allocate_user_mem>
  80198a:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801990:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801993:	89 14 c5 44 93 80 00 	mov    %edx,0x809344(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019a0:	eb 0e                	jmp    8019b0 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8019a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a5:	c6 04 c5 40 93 80 00 	movb   $0x1,0x809340(,%eax,8)
  8019ac:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8019ad:	ff 45 e4             	incl   -0x1c(%ebp)
  8019b0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b6:	01 d0                	add    %edx,%eax
  8019b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019bb:	77 e5                	ja     8019a2 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	eb 05                	jmp    8019c7 <malloc+0x15a>
		}
	}

	return NULL;
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8019cf:	e8 65 08 00 00       	call   802239 <sys_get_hard_limit>
  8019d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8019dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019e1:	0f 84 c1 00 00 00    	je     801aa8 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8019e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	79 1b                	jns    801a09 <free+0x40>
  8019ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f4:	73 13                	jae    801a09 <free+0x40>
    {
        free_block(virtual_address);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 18 10 00 00       	call   802a19 <free_block>
  801a01:	83 c4 10             	add    $0x10,%esp
    	return;
  801a04:	e9 a6 00 00 00       	jmp    801aaf <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0c:	05 00 10 00 00       	add    $0x1000,%eax
  801a11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a14:	0f 87 91 00 00 00    	ja     801aab <free+0xe2>
  801a1a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801a21:	0f 87 84 00 00 00    	ja     801aab <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a35:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3b:	05 00 00 00 80       	add    $0x80000000,%eax
  801a40:	c1 e8 0c             	shr    $0xc,%eax
  801a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a49:	8b 04 c5 44 93 80 00 	mov    0x809344(,%eax,8),%eax
  801a50:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801a53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a57:	74 55                	je     801aae <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5c:	c1 e8 0c             	shr    $0xc,%eax
  801a5f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	c7 04 c5 44 93 80 00 	movl   $0x0,0x809344(,%eax,8)
  801a6c:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a76:	eb 0e                	jmp    801a86 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	c6 04 c5 40 93 80 00 	movb   $0x0,0x809340(,%eax,8)
  801a82:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801a83:	ff 45 f4             	incl   -0xc(%ebp)
  801a86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8c:	01 c2                	add    %eax,%edx
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	39 c2                	cmp    %eax,%edx
  801a93:	77 e3                	ja     801a78 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	ff 75 e0             	pushl  -0x20(%ebp)
  801a9b:	ff 75 ec             	pushl  -0x14(%ebp)
  801a9e:	e8 5e 07 00 00       	call   802201 <sys_free_user_mem>
  801aa3:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801aa6:	eb 07                	jmp    801aaf <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801aa8:	90                   	nop
  801aa9:	eb 04                	jmp    801aaf <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801aab:	90                   	nop
  801aac:	eb 01                	jmp    801aaf <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801aae:	90                   	nop
    else
     {
    	return;
      }

}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
  801ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aba:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801abd:	e8 7c fd ff ff       	call   80183e <InitializeUHeap>
	if (size == 0)
  801ac2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac6:	75 07                	jne    801acf <smalloc+0x1e>
		return NULL;
  801ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  801acd:	eb 17                	jmp    801ae6 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	68 30 41 80 00       	push   $0x804130
  801ad7:	68 ad 00 00 00       	push   $0xad
  801adc:	68 56 41 80 00       	push   $0x804156
  801ae1:	e8 9f ec ff ff       	call   800785 <_panic>
	return NULL;
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aee:	e8 4b fd ff ff       	call   80183e <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 64 41 80 00       	push   $0x804164
  801afb:	68 ba 00 00 00       	push   $0xba
  801b00:	68 56 41 80 00       	push   $0x804156
  801b05:	e8 7b ec ff ff       	call   800785 <_panic>

00801b0a <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b10:	e8 29 fd ff ff       	call   80183e <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	68 88 41 80 00       	push   $0x804188
  801b1d:	68 d8 00 00 00       	push   $0xd8
  801b22:	68 56 41 80 00       	push   $0x804156
  801b27:	e8 59 ec ff ff       	call   800785 <_panic>

00801b2c <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	68 b0 41 80 00       	push   $0x8041b0
  801b3a:	68 ea 00 00 00       	push   $0xea
  801b3f:	68 56 41 80 00       	push   $0x804156
  801b44:	e8 3c ec ff ff       	call   800785 <_panic>

00801b49 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	68 d4 41 80 00       	push   $0x8041d4
  801b57:	68 f2 00 00 00       	push   $0xf2
  801b5c:	68 56 41 80 00       	push   $0x804156
  801b61:	e8 1f ec ff ff       	call   800785 <_panic>

00801b66 <shrink>:

}
void shrink(uint32 newSize) {
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 d4 41 80 00       	push   $0x8041d4
  801b74:	68 f6 00 00 00       	push   $0xf6
  801b79:	68 56 41 80 00       	push   $0x804156
  801b7e:	e8 02 ec ff ff       	call   800785 <_panic>

00801b83 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	68 d4 41 80 00       	push   $0x8041d4
  801b91:	68 fa 00 00 00       	push   $0xfa
  801b96:	68 56 41 80 00       	push   $0x804156
  801b9b:	e8 e5 eb ff ff       	call   800785 <_panic>

00801ba0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	57                   	push   %edi
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bb8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bbb:	cd 30                	int    $0x30
  801bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5f                   	pop    %edi
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bd7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	52                   	push   %edx
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	50                   	push   %eax
  801be7:	6a 00                	push   $0x0
  801be9:	e8 b2 ff ff ff       	call   801ba0 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 01                	push   $0x1
  801c03:	e8 98 ff ff ff       	call   801ba0 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 05                	push   $0x5
  801c20:	e8 7b ff ff ff       	call   801ba0 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	56                   	push   %esi
  801c2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c2f:	8b 75 18             	mov    0x18(%ebp),%esi
  801c32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	51                   	push   %ecx
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 06                	push   $0x6
  801c45:	e8 56 ff ff ff       	call   801ba0 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	52                   	push   %edx
  801c64:	50                   	push   %eax
  801c65:	6a 07                	push   $0x7
  801c67:	e8 34 ff ff ff       	call   801ba0 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	ff 75 08             	pushl  0x8(%ebp)
  801c80:	6a 08                	push   $0x8
  801c82:	e8 19 ff ff ff       	call   801ba0 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 09                	push   $0x9
  801c9b:	e8 00 ff ff ff       	call   801ba0 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 0a                	push   $0xa
  801cb4:	e8 e7 fe ff ff       	call   801ba0 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 0b                	push   $0xb
  801ccd:	e8 ce fe ff ff       	call   801ba0 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 0c                	push   $0xc
  801ce6:	e8 b5 fe ff ff       	call   801ba0 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	6a 0d                	push   $0xd
  801d00:	e8 9b fe ff ff       	call   801ba0 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 0e                	push   $0xe
  801d19:	e8 82 fe ff ff       	call   801ba0 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	90                   	nop
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 11                	push   $0x11
  801d33:	e8 68 fe ff ff       	call   801ba0 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 12                	push   $0x12
  801d4d:	e8 4e fe ff ff       	call   801ba0 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	50                   	push   %eax
  801d71:	6a 13                	push   $0x13
  801d73:	e8 28 fe ff ff       	call   801ba0 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 14                	push   $0x14
  801d8d:	e8 0e fe ff ff       	call   801ba0 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	90                   	nop
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	50                   	push   %eax
  801da8:	6a 15                	push   $0x15
  801daa:	e8 f1 fd ff ff       	call   801ba0 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 18                	push   $0x18
  801dc7:	e8 d4 fd ff ff       	call   801ba0 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	6a 16                	push   $0x16
  801de4:	e8 b7 fd ff ff       	call   801ba0 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	90                   	nop
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	52                   	push   %edx
  801dff:	50                   	push   %eax
  801e00:	6a 17                	push   $0x17
  801e02:	e8 99 fd ff ff       	call   801ba0 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 04             	sub    $0x4,%esp
  801e13:	8b 45 10             	mov    0x10(%ebp),%eax
  801e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	6a 00                	push   $0x0
  801e25:	51                   	push   %ecx
  801e26:	52                   	push   %edx
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	50                   	push   %eax
  801e2b:	6a 19                	push   $0x19
  801e2d:	e8 6e fd ff ff       	call   801ba0 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 1a                	push   $0x1a
  801e4a:	e8 51 fd ff ff       	call   801ba0 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	51                   	push   %ecx
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 1b                	push   $0x1b
  801e69:	e8 32 fd ff ff       	call   801ba0 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	52                   	push   %edx
  801e83:	50                   	push   %eax
  801e84:	6a 1c                	push   $0x1c
  801e86:	e8 15 fd ff ff       	call   801ba0 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 1d                	push   $0x1d
  801e9f:	e8 fc fc ff ff       	call   801ba0 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	ff 75 14             	pushl  0x14(%ebp)
  801eb4:	ff 75 10             	pushl  0x10(%ebp)
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	50                   	push   %eax
  801ebb:	6a 1e                	push   $0x1e
  801ebd:	e8 de fc ff ff       	call   801ba0 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	50                   	push   %eax
  801ed6:	6a 1f                	push   $0x1f
  801ed8:	e8 c3 fc ff ff       	call   801ba0 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	90                   	nop
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	50                   	push   %eax
  801ef2:	6a 20                	push   $0x20
  801ef4:	e8 a7 fc ff ff       	call   801ba0 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 02                	push   $0x2
  801f0d:	e8 8e fc ff ff       	call   801ba0 <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 03                	push   $0x3
  801f26:	e8 75 fc ff ff       	call   801ba0 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 04                	push   $0x4
  801f3f:	e8 5c fc ff ff       	call   801ba0 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_exit_env>:


void sys_exit_env(void)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 21                	push   $0x21
  801f58:	e8 43 fc ff ff       	call   801ba0 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
}
  801f60:	90                   	nop
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f6c:	8d 50 04             	lea    0x4(%eax),%edx
  801f6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	52                   	push   %edx
  801f79:	50                   	push   %eax
  801f7a:	6a 22                	push   $0x22
  801f7c:	e8 1f fc ff ff       	call   801ba0 <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
	return result;
  801f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f8d:	89 01                	mov    %eax,(%ecx)
  801f8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	c9                   	leave  
  801f96:	c2 04 00             	ret    $0x4

00801f99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	ff 75 10             	pushl  0x10(%ebp)
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	6a 10                	push   $0x10
  801fab:	e8 f0 fb ff ff       	call   801ba0 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb3:	90                   	nop
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 23                	push   $0x23
  801fc5:	e8 d6 fb ff ff       	call   801ba0 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fdb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	50                   	push   %eax
  801fe8:	6a 24                	push   $0x24
  801fea:	e8 b1 fb ff ff       	call   801ba0 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff2:	90                   	nop
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <rsttst>:
void rsttst()
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 26                	push   $0x26
  802004:	e8 97 fb ff ff       	call   801ba0 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
	return ;
  80200c:	90                   	nop
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	8b 45 14             	mov    0x14(%ebp),%eax
  802018:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80201b:	8b 55 18             	mov    0x18(%ebp),%edx
  80201e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	ff 75 10             	pushl  0x10(%ebp)
  802027:	ff 75 0c             	pushl  0xc(%ebp)
  80202a:	ff 75 08             	pushl  0x8(%ebp)
  80202d:	6a 25                	push   $0x25
  80202f:	e8 6c fb ff ff       	call   801ba0 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
	return ;
  802037:	90                   	nop
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <chktst>:
void chktst(uint32 n)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	6a 27                	push   $0x27
  80204a:	e8 51 fb ff ff       	call   801ba0 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return ;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <inctst>:

void inctst()
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 28                	push   $0x28
  802064:	e8 37 fb ff ff       	call   801ba0 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
	return ;
  80206c:	90                   	nop
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <gettst>:
uint32 gettst()
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 29                	push   $0x29
  80207e:	e8 1d fb ff ff       	call   801ba0 <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 2a                	push   $0x2a
  80209a:	e8 01 fb ff ff       	call   801ba0 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
  8020a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020a5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020a9:	75 07                	jne    8020b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b0:	eb 05                	jmp    8020b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 2a                	push   $0x2a
  8020cb:	e8 d0 fa ff ff       	call   801ba0 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
  8020d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020d6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020da:	75 07                	jne    8020e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e1:	eb 05                	jmp    8020e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 2a                	push   $0x2a
  8020fc:	e8 9f fa ff ff       	call   801ba0 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
  802104:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802107:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80210b:	75 07                	jne    802114 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80210d:	b8 01 00 00 00       	mov    $0x1,%eax
  802112:	eb 05                	jmp    802119 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 2a                	push   $0x2a
  80212d:	e8 6e fa ff ff       	call   801ba0 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
  802135:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802138:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80213c:	75 07                	jne    802145 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80213e:	b8 01 00 00 00       	mov    $0x1,%eax
  802143:	eb 05                	jmp    80214a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	ff 75 08             	pushl  0x8(%ebp)
  80215a:	6a 2b                	push   $0x2b
  80215c:	e8 3f fa ff ff       	call   801ba0 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
	return ;
  802164:	90                   	nop
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80216b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80216e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802171:	8b 55 0c             	mov    0xc(%ebp),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	6a 00                	push   $0x0
  802179:	53                   	push   %ebx
  80217a:	51                   	push   %ecx
  80217b:	52                   	push   %edx
  80217c:	50                   	push   %eax
  80217d:	6a 2c                	push   $0x2c
  80217f:	e8 1c fa ff ff       	call   801ba0 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80218f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	52                   	push   %edx
  80219c:	50                   	push   %eax
  80219d:	6a 2d                	push   $0x2d
  80219f:	e8 fc f9 ff ff       	call   801ba0 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	6a 00                	push   $0x0
  8021b7:	51                   	push   %ecx
  8021b8:	ff 75 10             	pushl  0x10(%ebp)
  8021bb:	52                   	push   %edx
  8021bc:	50                   	push   %eax
  8021bd:	6a 2e                	push   $0x2e
  8021bf:	e8 dc f9 ff ff       	call   801ba0 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	ff 75 10             	pushl  0x10(%ebp)
  8021d3:	ff 75 0c             	pushl  0xc(%ebp)
  8021d6:	ff 75 08             	pushl  0x8(%ebp)
  8021d9:	6a 0f                	push   $0xf
  8021db:	e8 c0 f9 ff ff       	call   801ba0 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e3:	90                   	nop
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	50                   	push   %eax
  8021f5:	6a 2f                	push   $0x2f
  8021f7:	e8 a4 f9 ff ff       	call   801ba0 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp

}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	6a 30                	push   $0x30
  802212:	e8 89 f9 ff ff       	call   801ba0 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
	return;
  80221a:	90                   	nop
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	ff 75 08             	pushl  0x8(%ebp)
  80222c:	6a 31                	push   $0x31
  80222e:	e8 6d f9 ff ff       	call   801ba0 <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
	return;
  802236:	90                   	nop
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 32                	push   $0x32
  802248:	e8 53 f9 ff ff       	call   801ba0 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	83 e8 10             	sub    $0x10,%eax
  80225e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802261:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	83 e8 10             	sub    $0x10,%eax
  802274:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802277:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227a:	8a 40 04             	mov    0x4(%eax),%al
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	83 f8 02             	cmp    $0x2,%eax
  802292:	74 2b                	je     8022bf <alloc_block+0x40>
  802294:	83 f8 02             	cmp    $0x2,%eax
  802297:	7f 07                	jg     8022a0 <alloc_block+0x21>
  802299:	83 f8 01             	cmp    $0x1,%eax
  80229c:	74 0e                	je     8022ac <alloc_block+0x2d>
  80229e:	eb 58                	jmp    8022f8 <alloc_block+0x79>
  8022a0:	83 f8 03             	cmp    $0x3,%eax
  8022a3:	74 2d                	je     8022d2 <alloc_block+0x53>
  8022a5:	83 f8 04             	cmp    $0x4,%eax
  8022a8:	74 3b                	je     8022e5 <alloc_block+0x66>
  8022aa:	eb 4c                	jmp    8022f8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	ff 75 08             	pushl  0x8(%ebp)
  8022b2:	e8 95 01 00 00       	call   80244c <alloc_block_FF>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022bd:	eb 4a                	jmp    802309 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8022bf:	83 ec 0c             	sub    $0xc,%esp
  8022c2:	ff 75 08             	pushl  0x8(%ebp)
  8022c5:	e8 32 07 00 00       	call   8029fc <alloc_block_NF>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022d0:	eb 37                	jmp    802309 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	e8 a3 04 00 00       	call   802780 <alloc_block_BF>
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022e3:	eb 24                	jmp    802309 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 08             	pushl  0x8(%ebp)
  8022eb:	e8 ef 06 00 00       	call   8029df <alloc_block_WF>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022f6:	eb 11                	jmp    802309 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022f8:	83 ec 0c             	sub    $0xc,%esp
  8022fb:	68 e4 41 80 00       	push   $0x8041e4
  802300:	e8 3d e7 ff ff       	call   800a42 <cprintf>
  802305:	83 c4 10             	add    $0x10,%esp
		break;
  802308:	90                   	nop
	}
	return va;
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802314:	83 ec 0c             	sub    $0xc,%esp
  802317:	68 04 42 80 00       	push   $0x804204
  80231c:	e8 21 e7 ff ff       	call   800a42 <cprintf>
  802321:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802324:	83 ec 0c             	sub    $0xc,%esp
  802327:	68 2f 42 80 00       	push   $0x80422f
  80232c:	e8 11 e7 ff ff       	call   800a42 <cprintf>
  802331:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233a:	eb 26                	jmp    802362 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8a 40 04             	mov    0x4(%eax),%al
  802342:	0f b6 d0             	movzbl %al,%edx
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	83 ec 04             	sub    $0x4,%esp
  80234d:	52                   	push   %edx
  80234e:	50                   	push   %eax
  80234f:	68 47 42 80 00       	push   $0x804247
  802354:	e8 e9 e6 ff ff       	call   800a42 <cprintf>
  802359:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80235c:	8b 45 10             	mov    0x10(%ebp),%eax
  80235f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	74 08                	je     802370 <print_blocks_list+0x62>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 08             	mov    0x8(%eax),%eax
  80236e:	eb 05                	jmp    802375 <print_blocks_list+0x67>
  802370:	b8 00 00 00 00       	mov    $0x0,%eax
  802375:	89 45 10             	mov    %eax,0x10(%ebp)
  802378:	8b 45 10             	mov    0x10(%ebp),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 bd                	jne    80233c <print_blocks_list+0x2e>
  80237f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802383:	75 b7                	jne    80233c <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802385:	83 ec 0c             	sub    $0xc,%esp
  802388:	68 04 42 80 00       	push   $0x804204
  80238d:	e8 b0 e6 ff ff       	call   800a42 <cprintf>
  802392:	83 c4 10             	add    $0x10,%esp

}
  802395:	90                   	nop
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80239e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023a2:	0f 84 a1 00 00 00    	je     802449 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8023a8:	c7 05 4c 50 80 00 01 	movl   $0x1,0x80504c
  8023af:	00 00 00 
	LIST_INIT(&list);
  8023b2:	c7 05 40 93 90 00 00 	movl   $0x0,0x909340
  8023b9:	00 00 00 
  8023bc:	c7 05 44 93 90 00 00 	movl   $0x0,0x909344
  8023c3:	00 00 00 
  8023c6:	c7 05 4c 93 90 00 00 	movl   $0x0,0x90934c
  8023cd:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e3:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	75 14                	jne    8023ff <initialize_dynamic_allocator+0x67>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 60 42 80 00       	push   $0x804260
  8023f3:	6a 64                	push   $0x64
  8023f5:	68 83 42 80 00       	push   $0x804283
  8023fa:	e8 86 e3 ff ff       	call   800785 <_panic>
  8023ff:	8b 15 44 93 90 00    	mov    0x909344,%edx
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	89 50 0c             	mov    %edx,0xc(%eax)
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 0c             	mov    0xc(%eax),%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	74 0d                	je     802422 <initialize_dynamic_allocator+0x8a>
  802415:	a1 44 93 90 00       	mov    0x909344,%eax
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	89 50 08             	mov    %edx,0x8(%eax)
  802420:	eb 08                	jmp    80242a <initialize_dynamic_allocator+0x92>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	a3 40 93 90 00       	mov    %eax,0x909340
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	a3 44 93 90 00       	mov    %eax,0x909344
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80243c:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802441:	40                   	inc    %eax
  802442:	a3 4c 93 90 00       	mov    %eax,0x90934c
  802447:	eb 01                	jmp    80244a <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802449:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802452:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802456:	75 0a                	jne    802462 <alloc_block_FF+0x16>
	{
		return NULL;
  802458:	b8 00 00 00 00       	mov    $0x0,%eax
  80245d:	e9 1c 03 00 00       	jmp    80277e <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  802462:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	75 40                	jne    8024ab <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	83 c0 10             	add    $0x10,%eax
  802471:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	83 ec 0c             	sub    $0xc,%esp
  80247a:	50                   	push   %eax
  80247b:	e8 d7 f3 ff ff       	call   801857 <sbrk>
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802486:	83 ec 0c             	sub    $0xc,%esp
  802489:	6a 00                	push   $0x0
  80248b:	e8 c7 f3 ff ff       	call   801857 <sbrk>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802499:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80249c:	83 ec 08             	sub    $0x8,%esp
  80249f:	50                   	push   %eax
  8024a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8024a3:	e8 f0 fe ff ff       	call   802398 <initialize_dynamic_allocator>
  8024a8:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8024ab:	a1 40 93 90 00       	mov    0x909340,%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b3:	e9 1e 01 00 00       	jmp    8025d6 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8d 50 10             	lea    0x10(%eax),%edx
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	39 c2                	cmp    %eax,%edx
  8024c5:	75 1c                	jne    8024e3 <alloc_block_FF+0x97>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8a 40 04             	mov    0x4(%eax),%al
  8024cd:	3c 01                	cmp    $0x1,%al
  8024cf:	75 12                	jne    8024e3 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	83 c0 10             	add    $0x10,%eax
  8024de:	e9 9b 02 00 00       	jmp    80277e <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	8d 50 10             	lea    0x10(%eax),%edx
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	39 c2                	cmp    %eax,%edx
  8024f0:	0f 83 d8 00 00 00    	jae    8025ce <alloc_block_FF+0x182>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8a 40 04             	mov    0x4(%eax),%al
  8024fc:	3c 01                	cmp    $0x1,%al
  8024fe:	0f 85 ca 00 00 00    	jne    8025ce <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	2b 45 08             	sub    0x8(%ebp),%eax
  80250c:	83 e8 10             	sub    $0x10,%eax
  80250f:	83 f8 0f             	cmp    $0xf,%eax
  802512:	0f 86 a4 00 00 00    	jbe    8025bc <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	83 c0 10             	add    $0x10,%eax
  802523:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	2b 45 08             	sub    0x8(%ebp),%eax
  80252e:	8d 50 f0             	lea    -0x10(%eax),%edx
  802531:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802534:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802536:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802539:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	74 06                	je     802549 <alloc_block_FF+0xfd>
  802543:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802547:	75 17                	jne    802560 <alloc_block_FF+0x114>
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 9c 42 80 00       	push   $0x80429c
  802551:	68 8f 00 00 00       	push   $0x8f
  802556:	68 83 42 80 00       	push   $0x804283
  80255b:	e8 25 e2 ff ff       	call   800785 <_panic>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 50 08             	mov    0x8(%eax),%edx
  802566:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802569:	89 50 08             	mov    %edx,0x8(%eax)
  80256c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80256f:	8b 40 08             	mov    0x8(%eax),%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	74 0c                	je     802582 <alloc_block_FF+0x136>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 08             	mov    0x8(%eax),%eax
  80257c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80257f:	89 50 0c             	mov    %edx,0xc(%eax)
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802588:	89 50 08             	mov    %edx,0x8(%eax)
  80258b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	89 50 0c             	mov    %edx,0xc(%eax)
  802594:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802597:	8b 40 08             	mov    0x8(%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	75 08                	jne    8025a6 <alloc_block_FF+0x15a>
  80259e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025a1:	a3 44 93 90 00       	mov    %eax,0x909344
  8025a6:	a1 4c 93 90 00       	mov    0x90934c,%eax
  8025ab:	40                   	inc    %eax
  8025ac:	a3 4c 93 90 00       	mov    %eax,0x90934c
		    iterator->size = size + sizeOfMetaData();
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8d 50 10             	lea    0x10(%eax),%edx
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	83 c0 10             	add    $0x10,%eax
  8025c9:	e9 b0 01 00 00       	jmp    80277e <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  8025ce:	a1 48 93 90 00       	mov    0x909348,%eax
  8025d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025da:	74 08                	je     8025e4 <alloc_block_FF+0x198>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 08             	mov    0x8(%eax),%eax
  8025e2:	eb 05                	jmp    8025e9 <alloc_block_FF+0x19d>
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	a3 48 93 90 00       	mov    %eax,0x909348
  8025ee:	a1 48 93 90 00       	mov    0x909348,%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 85 bd fe ff ff    	jne    8024b8 <alloc_block_FF+0x6c>
  8025fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ff:	0f 85 b3 fe ff ff    	jne    8024b8 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	83 c0 10             	add    $0x10,%eax
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	50                   	push   %eax
  80260f:	e8 43 f2 ff ff       	call   801857 <sbrk>
  802614:	83 c4 10             	add    $0x10,%esp
  802617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	6a 00                	push   $0x0
  80261f:	e8 33 f2 ff ff       	call   801857 <sbrk>
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  80262a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	29 c2                	sub    %eax,%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802637:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80263b:	0f 84 38 01 00 00    	je     802779 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802644:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802647:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80264b:	75 17                	jne    802664 <alloc_block_FF+0x218>
  80264d:	83 ec 04             	sub    $0x4,%esp
  802650:	68 60 42 80 00       	push   $0x804260
  802655:	68 9f 00 00 00       	push   $0x9f
  80265a:	68 83 42 80 00       	push   $0x804283
  80265f:	e8 21 e1 ff ff       	call   800785 <_panic>
  802664:	8b 15 44 93 90 00    	mov    0x909344,%edx
  80266a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80266d:	89 50 0c             	mov    %edx,0xc(%eax)
  802670:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 0d                	je     802687 <alloc_block_FF+0x23b>
  80267a:	a1 44 93 90 00       	mov    0x909344,%eax
  80267f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802682:	89 50 08             	mov    %edx,0x8(%eax)
  802685:	eb 08                	jmp    80268f <alloc_block_FF+0x243>
  802687:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80268a:	a3 40 93 90 00       	mov    %eax,0x909340
  80268f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802692:	a3 44 93 90 00       	mov    %eax,0x909344
  802697:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80269a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026a1:	a1 4c 93 90 00       	mov    0x90934c,%eax
  8026a6:	40                   	inc    %eax
  8026a7:	a3 4c 93 90 00       	mov    %eax,0x90934c
			newBlock->size = size + sizeOfMetaData();
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	8d 50 10             	lea    0x10(%eax),%edx
  8026b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026b5:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8026b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026ba:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  8026be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c4:	83 f8 10             	cmp    $0x10,%eax
  8026c7:	0f 84 a4 00 00 00    	je     802771 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  8026cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026d3:	83 e8 10             	sub    $0x10,%eax
  8026d6:	83 f8 0f             	cmp    $0xf,%eax
  8026d9:	0f 86 8a 00 00 00    	jbe    802769 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  8026df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	83 c0 10             	add    $0x10,%eax
  8026ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  8026ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026f1:	75 17                	jne    80270a <alloc_block_FF+0x2be>
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 60 42 80 00       	push   $0x804260
  8026fb:	68 a7 00 00 00       	push   $0xa7
  802700:	68 83 42 80 00       	push   $0x804283
  802705:	e8 7b e0 ff ff       	call   800785 <_panic>
  80270a:	8b 15 44 93 90 00    	mov    0x909344,%edx
  802710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802713:	89 50 0c             	mov    %edx,0xc(%eax)
  802716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	74 0d                	je     80272d <alloc_block_FF+0x2e1>
  802720:	a1 44 93 90 00       	mov    0x909344,%eax
  802725:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802728:	89 50 08             	mov    %edx,0x8(%eax)
  80272b:	eb 08                	jmp    802735 <alloc_block_FF+0x2e9>
  80272d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802730:	a3 40 93 90 00       	mov    %eax,0x909340
  802735:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802738:	a3 44 93 90 00       	mov    %eax,0x909344
  80273d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802740:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802747:	a1 4c 93 90 00       	mov    0x90934c,%eax
  80274c:	40                   	inc    %eax
  80274d:	a3 4c 93 90 00       	mov    %eax,0x90934c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802752:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802755:	2b 45 08             	sub    0x8(%ebp),%eax
  802758:	8d 50 f0             	lea    -0x10(%eax),%edx
  80275b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80275e:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802763:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802767:	eb 08                	jmp    802771 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802769:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80276c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80276f:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802771:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802774:	83 c0 10             	add    $0x10,%eax
  802777:	eb 05                	jmp    80277e <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  80278d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802791:	75 0a                	jne    80279d <alloc_block_BF+0x1d>
	{
		return NULL;
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	e9 40 02 00 00       	jmp    8029dd <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  80279d:	a1 40 93 90 00       	mov    0x909340,%eax
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a5:	eb 66                	jmp    80280d <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8a 40 04             	mov    0x4(%eax),%al
  8027ad:	3c 01                	cmp    $0x1,%al
  8027af:	75 21                	jne    8027d2 <alloc_block_BF+0x52>
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	8d 50 10             	lea    0x10(%eax),%edx
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	39 c2                	cmp    %eax,%edx
  8027be:	75 12                	jne    8027d2 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	83 c0 10             	add    $0x10,%eax
  8027cd:	e9 0b 02 00 00       	jmp    8029dd <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8a 40 04             	mov    0x4(%eax),%al
  8027d8:	3c 01                	cmp    $0x1,%al
  8027da:	75 29                	jne    802805 <alloc_block_BF+0x85>
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8d 50 10             	lea    0x10(%eax),%edx
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	39 c2                	cmp    %eax,%edx
  8027e9:	77 1a                	ja     802805 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8027eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ef:	74 0e                	je     8027ff <alloc_block_BF+0x7f>
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 10                	mov    (%eax),%edx
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	39 c2                	cmp    %eax,%edx
  8027fd:	73 06                	jae    802805 <alloc_block_BF+0x85>
			{
				BF = iterator;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802805:	a1 48 93 90 00       	mov    0x909348,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	74 08                	je     80281b <alloc_block_BF+0x9b>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 40 08             	mov    0x8(%eax),%eax
  802819:	eb 05                	jmp    802820 <alloc_block_BF+0xa0>
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	a3 48 93 90 00       	mov    %eax,0x909348
  802825:	a1 48 93 90 00       	mov    0x909348,%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	0f 85 75 ff ff ff    	jne    8027a7 <alloc_block_BF+0x27>
  802832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802836:	0f 85 6b ff ff ff    	jne    8027a7 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  80283c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802840:	0f 84 f8 00 00 00    	je     80293e <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	8d 50 10             	lea    0x10(%eax),%edx
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	39 c2                	cmp    %eax,%edx
  802853:	0f 87 e5 00 00 00    	ja     80293e <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	2b 45 08             	sub    0x8(%ebp),%eax
  802861:	83 e8 10             	sub    $0x10,%eax
  802864:	83 f8 0f             	cmp    $0xf,%eax
  802867:	0f 86 bf 00 00 00    	jbe    80292c <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  80286d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	01 d0                	add    %edx,%eax
  802875:	83 c0 10             	add    $0x10,%eax
  802878:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	2b 45 08             	sub    0x8(%ebp),%eax
  80288c:	8d 50 f0             	lea    -0x10(%eax),%edx
  80288f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802892:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  80289b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289f:	74 06                	je     8028a7 <alloc_block_BF+0x127>
  8028a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a5:	75 17                	jne    8028be <alloc_block_BF+0x13e>
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	68 9c 42 80 00       	push   $0x80429c
  8028af:	68 e3 00 00 00       	push   $0xe3
  8028b4:	68 83 42 80 00       	push   $0x804283
  8028b9:	e8 c7 de ff ff       	call   800785 <_panic>
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 50 08             	mov    0x8(%eax),%edx
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	89 50 08             	mov    %edx,0x8(%eax)
  8028ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cd:	8b 40 08             	mov    0x8(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0c                	je     8028e0 <alloc_block_BF+0x160>
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 40 08             	mov    0x8(%eax),%eax
  8028da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028dd:	89 50 0c             	mov    %edx,0xc(%eax)
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e6:	89 50 08             	mov    %edx,0x8(%eax)
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ef:	89 50 0c             	mov    %edx,0xc(%eax)
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	8b 40 08             	mov    0x8(%eax),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	75 08                	jne    802904 <alloc_block_BF+0x184>
  8028fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ff:	a3 44 93 90 00       	mov    %eax,0x909344
  802904:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802909:	40                   	inc    %eax
  80290a:	a3 4c 93 90 00       	mov    %eax,0x90934c

				BF->size = size + sizeOfMetaData();
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	8d 50 10             	lea    0x10(%eax),%edx
  802915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802918:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	83 c0 10             	add    $0x10,%eax
  802927:	e9 b1 00 00 00       	jmp    8029dd <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	83 c0 10             	add    $0x10,%eax
  802939:	e9 9f 00 00 00       	jmp    8029dd <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	83 c0 10             	add    $0x10,%eax
  802944:	83 ec 0c             	sub    $0xc,%esp
  802947:	50                   	push   %eax
  802948:	e8 0a ef ff ff       	call   801857 <sbrk>
  80294d:	83 c4 10             	add    $0x10,%esp
  802950:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802953:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802957:	74 7f                	je     8029d8 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802959:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80295d:	75 17                	jne    802976 <alloc_block_BF+0x1f6>
  80295f:	83 ec 04             	sub    $0x4,%esp
  802962:	68 60 42 80 00       	push   $0x804260
  802967:	68 f6 00 00 00       	push   $0xf6
  80296c:	68 83 42 80 00       	push   $0x804283
  802971:	e8 0f de ff ff       	call   800785 <_panic>
  802976:	8b 15 44 93 90 00    	mov    0x909344,%edx
  80297c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297f:	89 50 0c             	mov    %edx,0xc(%eax)
  802982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0d                	je     802999 <alloc_block_BF+0x219>
  80298c:	a1 44 93 90 00       	mov    0x909344,%eax
  802991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802994:	89 50 08             	mov    %edx,0x8(%eax)
  802997:	eb 08                	jmp    8029a1 <alloc_block_BF+0x221>
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	a3 40 93 90 00       	mov    %eax,0x909340
  8029a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a4:	a3 44 93 90 00       	mov    %eax,0x909344
  8029a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029b3:	a1 4c 93 90 00       	mov    0x90934c,%eax
  8029b8:	40                   	inc    %eax
  8029b9:	a3 4c 93 90 00       	mov    %eax,0x90934c
		newBlock->size = size + sizeOfMetaData();
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8d 50 10             	lea    0x10(%eax),%edx
  8029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c7:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8029c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	83 c0 10             	add    $0x10,%eax
  8029d6:	eb 05                	jmp    8029dd <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  8029d8:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8029e5:	83 ec 04             	sub    $0x4,%esp
  8029e8:	68 d0 42 80 00       	push   $0x8042d0
  8029ed:	68 07 01 00 00       	push   $0x107
  8029f2:	68 83 42 80 00       	push   $0x804283
  8029f7:	e8 89 dd ff ff       	call   800785 <_panic>

008029fc <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 f8 42 80 00       	push   $0x8042f8
  802a0a:	68 0f 01 00 00       	push   $0x10f
  802a0f:	68 83 42 80 00       	push   $0x804283
  802a14:	e8 6c dd ff ff       	call   800785 <_panic>

00802a19 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a23:	0f 84 ee 05 00 00    	je     803017 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	83 e8 10             	sub    $0x10,%eax
  802a2f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802a32:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802a36:	a1 40 93 90 00       	mov    0x909340,%eax
  802a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a3e:	eb 16                	jmp    802a56 <free_block+0x3d>
	{
		if (block_pointer == it)
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a46:	75 06                	jne    802a4e <free_block+0x35>
		{
			flagx = 1;
  802a48:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802a4c:	eb 2f                	jmp    802a7d <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802a4e:	a1 48 93 90 00       	mov    0x909348,%eax
  802a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5a:	74 08                	je     802a64 <free_block+0x4b>
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 08             	mov    0x8(%eax),%eax
  802a62:	eb 05                	jmp    802a69 <free_block+0x50>
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
  802a69:	a3 48 93 90 00       	mov    %eax,0x909348
  802a6e:	a1 48 93 90 00       	mov    0x909348,%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	75 c9                	jne    802a40 <free_block+0x27>
  802a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a7b:	75 c3                	jne    802a40 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802a7d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802a81:	0f 84 93 05 00 00    	je     80301a <free_block+0x601>
		return;
	if (va == NULL)
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	0f 84 8c 05 00 00    	je     80301d <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a94:	8b 40 0c             	mov    0xc(%eax),%eax
  802a97:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802aa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa7:	75 12                	jne    802abb <free_block+0xa2>
  802aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aad:	75 0c                	jne    802abb <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802ab6:	e9 63 05 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802abb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802abf:	0f 85 ca 00 00 00    	jne    802b8f <free_block+0x176>
  802ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac8:	8a 40 04             	mov    0x4(%eax),%al
  802acb:	3c 01                	cmp    $0x1,%al
  802acd:	0f 85 bc 00 00 00    	jne    802b8f <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 10                	mov    (%eax),%edx
  802adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aff:	75 17                	jne    802b18 <free_block+0xff>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 1e 43 80 00       	push   $0x80431e
  802b09:	68 3c 01 00 00       	push   $0x13c
  802b0e:	68 83 42 80 00       	push   $0x804283
  802b13:	e8 6d dc ff ff       	call   800785 <_panic>
  802b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1b:	8b 40 08             	mov    0x8(%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	74 11                	je     802b33 <free_block+0x11a>
  802b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b25:	8b 40 08             	mov    0x8(%eax),%eax
  802b28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b2b:	8b 52 0c             	mov    0xc(%edx),%edx
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b31:	eb 0b                	jmp    802b3e <free_block+0x125>
  802b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	a3 44 93 90 00       	mov    %eax,0x909344
  802b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b41:	8b 40 0c             	mov    0xc(%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 11                	je     802b59 <free_block+0x140>
  802b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b51:	8b 52 08             	mov    0x8(%edx),%edx
  802b54:	89 50 08             	mov    %edx,0x8(%eax)
  802b57:	eb 0b                	jmp    802b64 <free_block+0x14b>
  802b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5c:	8b 40 08             	mov    0x8(%eax),%eax
  802b5f:	a3 40 93 90 00       	mov    %eax,0x909340
  802b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b78:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802b7d:	48                   	dec    %eax
  802b7e:	a3 4c 93 90 00       	mov    %eax,0x90934c
		next_block = 0;
  802b83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802b8a:	e9 8f 04 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802b8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b93:	75 16                	jne    802bab <free_block+0x192>
  802b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b98:	8a 40 04             	mov    0x4(%eax),%al
  802b9b:	84 c0                	test   %al,%al
  802b9d:	75 0c                	jne    802bab <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802ba6:	e9 73 04 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802bab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802baf:	0f 85 c3 00 00 00    	jne    802c78 <free_block+0x25f>
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8a 40 04             	mov    0x4(%eax),%al
  802bbb:	3c 01                	cmp    $0x1,%al
  802bbd:	0f 85 b5 00 00 00    	jne    802c78 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	8b 10                	mov    (%eax),%edx
  802bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	01 c2                	add    %eax,%edx
  802bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd2:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802be4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be8:	75 17                	jne    802c01 <free_block+0x1e8>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 1e 43 80 00       	push   $0x80431e
  802bf2:	68 49 01 00 00       	push   $0x149
  802bf7:	68 83 42 80 00       	push   $0x804283
  802bfc:	e8 84 db ff ff       	call   800785 <_panic>
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	8b 40 08             	mov    0x8(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 11                	je     802c1c <free_block+0x203>
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	8b 40 08             	mov    0x8(%eax),%eax
  802c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c14:	8b 52 0c             	mov    0xc(%edx),%edx
  802c17:	89 50 0c             	mov    %edx,0xc(%eax)
  802c1a:	eb 0b                	jmp    802c27 <free_block+0x20e>
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c22:	a3 44 93 90 00       	mov    %eax,0x909344
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 11                	je     802c42 <free_block+0x229>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3a:	8b 52 08             	mov    0x8(%edx),%edx
  802c3d:	89 50 08             	mov    %edx,0x8(%eax)
  802c40:	eb 0b                	jmp    802c4d <free_block+0x234>
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	a3 40 93 90 00       	mov    %eax,0x909340
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c61:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802c66:	48                   	dec    %eax
  802c67:	a3 4c 93 90 00       	mov    %eax,0x90934c
		block_pointer = 0;
  802c6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802c73:	e9 a6 03 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802c78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c7c:	75 16                	jne    802c94 <free_block+0x27b>
  802c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c81:	8a 40 04             	mov    0x4(%eax),%al
  802c84:	84 c0                	test   %al,%al
  802c86:	75 0c                	jne    802c94 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802c8f:	e9 8a 03 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802c94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c98:	0f 84 81 01 00 00    	je     802e1f <free_block+0x406>
  802c9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ca2:	0f 84 77 01 00 00    	je     802e1f <free_block+0x406>
  802ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cab:	8a 40 04             	mov    0x4(%eax),%al
  802cae:	3c 01                	cmp    $0x1,%al
  802cb0:	0f 85 69 01 00 00    	jne    802e1f <free_block+0x406>
  802cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb9:	8a 40 04             	mov    0x4(%eax),%al
  802cbc:	3c 01                	cmp    $0x1,%al
  802cbe:	0f 85 5b 01 00 00    	jne    802e1f <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc7:	8b 10                	mov    (%eax),%edx
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 08                	mov    (%eax),%ecx
  802cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	01 c8                	add    %ecx,%eax
  802cd5:	01 c2                	add    %eax,%edx
  802cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cda:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802cfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d00:	75 17                	jne    802d19 <free_block+0x300>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 1e 43 80 00       	push   $0x80431e
  802d0a:	68 59 01 00 00       	push   $0x159
  802d0f:	68 83 42 80 00       	push   $0x804283
  802d14:	e8 6c da ff ff       	call   800785 <_panic>
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	8b 40 08             	mov    0x8(%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 11                	je     802d34 <free_block+0x31b>
  802d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d26:	8b 40 08             	mov    0x8(%eax),%eax
  802d29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d2c:	8b 52 0c             	mov    0xc(%edx),%edx
  802d2f:	89 50 0c             	mov    %edx,0xc(%eax)
  802d32:	eb 0b                	jmp    802d3f <free_block+0x326>
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	a3 44 93 90 00       	mov    %eax,0x909344
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	8b 40 0c             	mov    0xc(%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	74 11                	je     802d5a <free_block+0x341>
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d52:	8b 52 08             	mov    0x8(%edx),%edx
  802d55:	89 50 08             	mov    %edx,0x8(%eax)
  802d58:	eb 0b                	jmp    802d65 <free_block+0x34c>
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	8b 40 08             	mov    0x8(%eax),%eax
  802d60:	a3 40 93 90 00       	mov    %eax,0x909340
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d79:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802d7e:	48                   	dec    %eax
  802d7f:	a3 4c 93 90 00       	mov    %eax,0x90934c
		LIST_REMOVE(&list, next_block);
  802d84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d88:	75 17                	jne    802da1 <free_block+0x388>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 1e 43 80 00       	push   $0x80431e
  802d92:	68 5a 01 00 00       	push   $0x15a
  802d97:	68 83 42 80 00       	push   $0x804283
  802d9c:	e8 e4 d9 ff ff       	call   800785 <_panic>
  802da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 11                	je     802dbc <free_block+0x3a3>
  802dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db4:	8b 52 0c             	mov    0xc(%edx),%edx
  802db7:	89 50 0c             	mov    %edx,0xc(%eax)
  802dba:	eb 0b                	jmp    802dc7 <free_block+0x3ae>
  802dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	a3 44 93 90 00       	mov    %eax,0x909344
  802dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	74 11                	je     802de2 <free_block+0x3c9>
  802dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dda:	8b 52 08             	mov    0x8(%edx),%edx
  802ddd:	89 50 08             	mov    %edx,0x8(%eax)
  802de0:	eb 0b                	jmp    802ded <free_block+0x3d4>
  802de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	a3 40 93 90 00       	mov    %eax,0x909340
  802ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e01:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802e06:	48                   	dec    %eax
  802e07:	a3 4c 93 90 00       	mov    %eax,0x90934c
		next_block = 0;
  802e0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802e13:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802e1a:	e9 ff 01 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802e1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e23:	0f 84 db 00 00 00    	je     802f04 <free_block+0x4eb>
  802e29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e2d:	0f 84 d1 00 00 00    	je     802f04 <free_block+0x4eb>
  802e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e36:	8a 40 04             	mov    0x4(%eax),%al
  802e39:	84 c0                	test   %al,%al
  802e3b:	0f 85 c3 00 00 00    	jne    802f04 <free_block+0x4eb>
  802e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e44:	8a 40 04             	mov    0x4(%eax),%al
  802e47:	3c 01                	cmp    $0x1,%al
  802e49:	0f 85 b5 00 00 00    	jne    802f04 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e52:	8b 10                	mov    (%eax),%edx
  802e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	01 c2                	add    %eax,%edx
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802e70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e74:	75 17                	jne    802e8d <free_block+0x474>
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	68 1e 43 80 00       	push   $0x80431e
  802e7e:	68 64 01 00 00       	push   $0x164
  802e83:	68 83 42 80 00       	push   $0x804283
  802e88:	e8 f8 d8 ff ff       	call   800785 <_panic>
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 11                	je     802ea8 <free_block+0x48f>
  802e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9a:	8b 40 08             	mov    0x8(%eax),%eax
  802e9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ea0:	8b 52 0c             	mov    0xc(%edx),%edx
  802ea3:	89 50 0c             	mov    %edx,0xc(%eax)
  802ea6:	eb 0b                	jmp    802eb3 <free_block+0x49a>
  802ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	a3 44 93 90 00       	mov    %eax,0x909344
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	74 11                	je     802ece <free_block+0x4b5>
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ec6:	8b 52 08             	mov    0x8(%edx),%edx
  802ec9:	89 50 08             	mov    %edx,0x8(%eax)
  802ecc:	eb 0b                	jmp    802ed9 <free_block+0x4c0>
  802ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	a3 40 93 90 00       	mov    %eax,0x909340
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802eed:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802ef2:	48                   	dec    %eax
  802ef3:	a3 4c 93 90 00       	mov    %eax,0x90934c
		block_pointer = 0;
  802ef8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802eff:	e9 1a 01 00 00       	jmp    80301e <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802f04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f08:	0f 84 df 00 00 00    	je     802fed <free_block+0x5d4>
  802f0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f12:	0f 84 d5 00 00 00    	je     802fed <free_block+0x5d4>
  802f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1b:	8a 40 04             	mov    0x4(%eax),%al
  802f1e:	3c 01                	cmp    $0x1,%al
  802f20:	0f 85 c7 00 00 00    	jne    802fed <free_block+0x5d4>
  802f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f29:	8a 40 04             	mov    0x4(%eax),%al
  802f2c:	84 c0                	test   %al,%al
  802f2e:	0f 85 b9 00 00 00    	jne    802fed <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3e:	8b 10                	mov    (%eax),%edx
  802f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	01 c2                	add    %eax,%edx
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802f5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f60:	75 17                	jne    802f79 <free_block+0x560>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 1e 43 80 00       	push   $0x80431e
  802f6a:	68 6e 01 00 00       	push   $0x16e
  802f6f:	68 83 42 80 00       	push   $0x804283
  802f74:	e8 0c d8 ff ff       	call   800785 <_panic>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 11                	je     802f94 <free_block+0x57b>
  802f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f86:	8b 40 08             	mov    0x8(%eax),%eax
  802f89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f8c:	8b 52 0c             	mov    0xc(%edx),%edx
  802f8f:	89 50 0c             	mov    %edx,0xc(%eax)
  802f92:	eb 0b                	jmp    802f9f <free_block+0x586>
  802f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	a3 44 93 90 00       	mov    %eax,0x909344
  802f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 11                	je     802fba <free_block+0x5a1>
  802fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fac:	8b 40 0c             	mov    0xc(%eax),%eax
  802faf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb2:	8b 52 08             	mov    0x8(%edx),%edx
  802fb5:	89 50 08             	mov    %edx,0x8(%eax)
  802fb8:	eb 0b                	jmp    802fc5 <free_block+0x5ac>
  802fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	a3 40 93 90 00       	mov    %eax,0x909340
  802fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fd9:	a1 4c 93 90 00       	mov    0x90934c,%eax
  802fde:	48                   	dec    %eax
  802fdf:	a3 4c 93 90 00       	mov    %eax,0x90934c
		next_block = 0;
  802fe4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802feb:	eb 31                	jmp    80301e <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802fed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff1:	74 2b                	je     80301e <free_block+0x605>
  802ff3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff7:	74 25                	je     80301e <free_block+0x605>
  802ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffc:	8a 40 04             	mov    0x4(%eax),%al
  802fff:	84 c0                	test   %al,%al
  803001:	75 1b                	jne    80301e <free_block+0x605>
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	8a 40 04             	mov    0x4(%eax),%al
  803009:	84 c0                	test   %al,%al
  80300b:	75 11                	jne    80301e <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80300d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803010:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803014:	90                   	nop
  803015:	eb 07                	jmp    80301e <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803017:	90                   	nop
  803018:	eb 04                	jmp    80301e <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  80301a:	90                   	nop
  80301b:	eb 01                	jmp    80301e <free_block+0x605>
	if (va == NULL)
		return;
  80301d:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
  803023:	57                   	push   %edi
  803024:	56                   	push   %esi
  803025:	53                   	push   %ebx
  803026:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803029:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302d:	75 19                	jne    803048 <realloc_block_FF+0x28>
  80302f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803033:	74 13                	je     803048 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  803035:	83 ec 0c             	sub    $0xc,%esp
  803038:	ff 75 0c             	pushl  0xc(%ebp)
  80303b:	e8 0c f4 ff ff       	call   80244c <alloc_block_FF>
  803040:	83 c4 10             	add    $0x10,%esp
  803043:	e9 84 03 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  803048:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80304c:	75 3b                	jne    803089 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  80304e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803052:	75 17                	jne    80306b <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  803054:	83 ec 0c             	sub    $0xc,%esp
  803057:	6a 00                	push   $0x0
  803059:	e8 ee f3 ff ff       	call   80244c <alloc_block_FF>
  80305e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803061:	b8 00 00 00 00       	mov    $0x0,%eax
  803066:	e9 61 03 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  80306b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306f:	74 18                	je     803089 <realloc_block_FF+0x69>
		{
			free_block(va);
  803071:	83 ec 0c             	sub    $0xc,%esp
  803074:	ff 75 08             	pushl  0x8(%ebp)
  803077:	e8 9d f9 ff ff       	call   802a19 <free_block>
  80307c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80307f:	b8 00 00 00 00       	mov    $0x0,%eax
  803084:	e9 43 03 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803089:	a1 40 93 90 00       	mov    0x909340,%eax
  80308e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803091:	e9 02 03 00 00       	jmp    803398 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	83 e8 10             	sub    $0x10,%eax
  80309c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80309f:	0f 85 eb 02 00 00    	jne    803390 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8030a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ad:	83 c2 10             	add    $0x10,%edx
  8030b0:	39 d0                	cmp    %edx,%eax
  8030b2:	75 08                	jne    8030bc <realloc_block_FF+0x9c>
			{
				return va;
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	e9 10 03 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  8030bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030c4:	0f 83 e0 01 00 00    	jae    8032aa <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8030ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cd:	8b 40 08             	mov    0x8(%eax),%eax
  8030d0:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  8030d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d6:	8a 40 04             	mov    0x4(%eax),%al
  8030d9:	3c 01                	cmp    $0x1,%al
  8030db:	0f 85 06 01 00 00    	jne    8031e7 <realloc_block_FF+0x1c7>
  8030e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e4:	8b 10                	mov    (%eax),%edx
  8030e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030ee:	29 c1                	sub    %eax,%ecx
  8030f0:	89 c8                	mov    %ecx,%eax
  8030f2:	39 c2                	cmp    %eax,%edx
  8030f4:	0f 86 ed 00 00 00    	jbe    8031e7 <realloc_block_FF+0x1c7>
  8030fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030fe:	0f 84 e3 00 00 00    	je     8031e7 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  803104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803107:	8b 10                	mov    (%eax),%edx
  803109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803111:	01 d0                	add    %edx,%eax
  803113:	83 f8 0f             	cmp    $0xf,%eax
  803116:	0f 86 b5 00 00 00    	jbe    8031d1 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  80311c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80311f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803122:	01 d0                	add    %edx,%eax
  803124:	83 c0 10             	add    $0x10,%eax
  803127:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  80312a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  803133:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803136:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80313a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80313e:	74 06                	je     803146 <realloc_block_FF+0x126>
  803140:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803144:	75 17                	jne    80315d <realloc_block_FF+0x13d>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 9c 42 80 00       	push   $0x80429c
  80314e:	68 ad 01 00 00       	push   $0x1ad
  803153:	68 83 42 80 00       	push   $0x804283
  803158:	e8 28 d6 ff ff       	call   800785 <_panic>
  80315d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803160:	8b 50 08             	mov    0x8(%eax),%edx
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	89 50 08             	mov    %edx,0x8(%eax)
  803169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316c:	8b 40 08             	mov    0x8(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 0c                	je     80317f <realloc_block_FF+0x15f>
  803173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803176:	8b 40 08             	mov    0x8(%eax),%eax
  803179:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80317c:	89 50 0c             	mov    %edx,0xc(%eax)
  80317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803182:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803185:	89 50 08             	mov    %edx,0x8(%eax)
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80318e:	89 50 0c             	mov    %edx,0xc(%eax)
  803191:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803194:	8b 40 08             	mov    0x8(%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	75 08                	jne    8031a3 <realloc_block_FF+0x183>
  80319b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319e:	a3 44 93 90 00       	mov    %eax,0x909344
  8031a3:	a1 4c 93 90 00       	mov    0x90934c,%eax
  8031a8:	40                   	inc    %eax
  8031a9:	a3 4c 93 90 00       	mov    %eax,0x90934c
						next->size = 0;
  8031ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  8031b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ba:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  8031be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c1:	8d 50 10             	lea    0x10(%eax),%edx
  8031c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c7:	89 10                	mov    %edx,(%eax)
						return va;
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	e9 fb 01 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  8031d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d4:	8d 50 10             	lea    0x10(%eax),%edx
  8031d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031da:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  8031dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031df:	83 c0 10             	add    $0x10,%eax
  8031e2:	e9 e5 01 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  8031e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ea:	8a 40 04             	mov    0x4(%eax),%al
  8031ed:	3c 01                	cmp    $0x1,%al
  8031ef:	75 59                	jne    80324a <realloc_block_FF+0x22a>
  8031f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f4:	8b 10                	mov    (%eax),%edx
  8031f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8031fe:	29 c1                	sub    %eax,%ecx
  803200:	89 c8                	mov    %ecx,%eax
  803202:	39 c2                	cmp    %eax,%edx
  803204:	75 44                	jne    80324a <realloc_block_FF+0x22a>
  803206:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80320a:	74 3e                	je     80324a <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  80320c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320f:	8b 40 08             	mov    0x8(%eax),%eax
  803212:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803218:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80321b:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  80321e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803224:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803233:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323a:	8d 50 10             	lea    0x10(%eax),%edx
  80323d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803240:	89 10                	mov    %edx,(%eax)
					return va;
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	e9 82 01 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  80324a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324d:	8a 40 04             	mov    0x4(%eax),%al
  803250:	84 c0                	test   %al,%al
  803252:	74 0a                	je     80325e <realloc_block_FF+0x23e>
  803254:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803258:	0f 85 32 01 00 00    	jne    803390 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80325e:	83 ec 0c             	sub    $0xc,%esp
  803261:	ff 75 0c             	pushl  0xc(%ebp)
  803264:	e8 e3 f1 ff ff       	call   80244c <alloc_block_FF>
  803269:	83 c4 10             	add    $0x10,%esp
  80326c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  80326f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803273:	74 2b                	je     8032a0 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803275:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	89 c3                	mov    %eax,%ebx
  80327d:	b8 04 00 00 00       	mov    $0x4,%eax
  803282:	89 d7                	mov    %edx,%edi
  803284:	89 de                	mov    %ebx,%esi
  803286:	89 c1                	mov    %eax,%ecx
  803288:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  80328a:	83 ec 0c             	sub    $0xc,%esp
  80328d:	ff 75 08             	pushl  0x8(%ebp)
  803290:	e8 84 f7 ff ff       	call   802a19 <free_block>
  803295:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803298:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329b:	e9 2c 01 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8032a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8032a5:	e9 22 01 00 00       	jmp    8033cc <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8032aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b2:	0f 86 d8 00 00 00    	jbe    803390 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8032b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032c0:	83 f8 0f             	cmp    $0xf,%eax
  8032c3:	0f 86 b4 00 00 00    	jbe    80337d <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  8032c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032cf:	01 d0                	add    %edx,%eax
  8032d1:	83 c0 10             	add    $0x10,%eax
  8032d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  8032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032df:	8d 50 f0             	lea    -0x10(%eax),%edx
  8032e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032e5:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8032e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032eb:	74 06                	je     8032f3 <realloc_block_FF+0x2d3>
  8032ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032f1:	75 17                	jne    80330a <realloc_block_FF+0x2ea>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 9c 42 80 00       	push   $0x80429c
  8032fb:	68 dd 01 00 00       	push   $0x1dd
  803300:	68 83 42 80 00       	push   $0x804283
  803305:	e8 7b d4 ff ff       	call   800785 <_panic>
  80330a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330d:	8b 50 08             	mov    0x8(%eax),%edx
  803310:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803313:	89 50 08             	mov    %edx,0x8(%eax)
  803316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803319:	8b 40 08             	mov    0x8(%eax),%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	74 0c                	je     80332c <realloc_block_FF+0x30c>
  803320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803323:	8b 40 08             	mov    0x8(%eax),%eax
  803326:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803329:	89 50 0c             	mov    %edx,0xc(%eax)
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803332:	89 50 08             	mov    %edx,0x8(%eax)
  803335:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803338:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333b:	89 50 0c             	mov    %edx,0xc(%eax)
  80333e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803341:	8b 40 08             	mov    0x8(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	75 08                	jne    803350 <realloc_block_FF+0x330>
  803348:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80334b:	a3 44 93 90 00       	mov    %eax,0x909344
  803350:	a1 4c 93 90 00       	mov    0x90934c,%eax
  803355:	40                   	inc    %eax
  803356:	a3 4c 93 90 00       	mov    %eax,0x90934c
					free_block((void*) (newBlockAfterSplit + 1));
  80335b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80335e:	83 c0 10             	add    $0x10,%eax
  803361:	83 ec 0c             	sub    $0xc,%esp
  803364:	50                   	push   %eax
  803365:	e8 af f6 ff ff       	call   802a19 <free_block>
  80336a:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  80336d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803370:	8d 50 10             	lea    0x10(%eax),%edx
  803373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803376:	89 10                	mov    %edx,(%eax)
					return va;
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	eb 4f                	jmp    8033cc <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	8d 50 10             	lea    0x10(%eax),%edx
  803383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803386:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338b:	83 c0 10             	add    $0x10,%eax
  80338e:	eb 3c                	jmp    8033cc <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803390:	a1 48 93 90 00       	mov    0x909348,%eax
  803395:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803398:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80339c:	74 08                	je     8033a6 <realloc_block_FF+0x386>
  80339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a1:	8b 40 08             	mov    0x8(%eax),%eax
  8033a4:	eb 05                	jmp    8033ab <realloc_block_FF+0x38b>
  8033a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ab:	a3 48 93 90 00       	mov    %eax,0x909348
  8033b0:	a1 48 93 90 00       	mov    0x909348,%eax
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	0f 85 d9 fc ff ff    	jne    803096 <realloc_block_FF+0x76>
  8033bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033c1:	0f 85 cf fc ff ff    	jne    803096 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8033c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8033cf:	5b                   	pop    %ebx
  8033d0:	5e                   	pop    %esi
  8033d1:	5f                   	pop    %edi
  8033d2:	5d                   	pop    %ebp
  8033d3:	c3                   	ret    

008033d4 <__udivdi3>:
  8033d4:	55                   	push   %ebp
  8033d5:	57                   	push   %edi
  8033d6:	56                   	push   %esi
  8033d7:	53                   	push   %ebx
  8033d8:	83 ec 1c             	sub    $0x1c,%esp
  8033db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033eb:	89 ca                	mov    %ecx,%edx
  8033ed:	89 f8                	mov    %edi,%eax
  8033ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f3:	85 f6                	test   %esi,%esi
  8033f5:	75 2d                	jne    803424 <__udivdi3+0x50>
  8033f7:	39 cf                	cmp    %ecx,%edi
  8033f9:	77 65                	ja     803460 <__udivdi3+0x8c>
  8033fb:	89 fd                	mov    %edi,%ebp
  8033fd:	85 ff                	test   %edi,%edi
  8033ff:	75 0b                	jne    80340c <__udivdi3+0x38>
  803401:	b8 01 00 00 00       	mov    $0x1,%eax
  803406:	31 d2                	xor    %edx,%edx
  803408:	f7 f7                	div    %edi
  80340a:	89 c5                	mov    %eax,%ebp
  80340c:	31 d2                	xor    %edx,%edx
  80340e:	89 c8                	mov    %ecx,%eax
  803410:	f7 f5                	div    %ebp
  803412:	89 c1                	mov    %eax,%ecx
  803414:	89 d8                	mov    %ebx,%eax
  803416:	f7 f5                	div    %ebp
  803418:	89 cf                	mov    %ecx,%edi
  80341a:	89 fa                	mov    %edi,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	39 ce                	cmp    %ecx,%esi
  803426:	77 28                	ja     803450 <__udivdi3+0x7c>
  803428:	0f bd fe             	bsr    %esi,%edi
  80342b:	83 f7 1f             	xor    $0x1f,%edi
  80342e:	75 40                	jne    803470 <__udivdi3+0x9c>
  803430:	39 ce                	cmp    %ecx,%esi
  803432:	72 0a                	jb     80343e <__udivdi3+0x6a>
  803434:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803438:	0f 87 9e 00 00 00    	ja     8034dc <__udivdi3+0x108>
  80343e:	b8 01 00 00 00       	mov    $0x1,%eax
  803443:	89 fa                	mov    %edi,%edx
  803445:	83 c4 1c             	add    $0x1c,%esp
  803448:	5b                   	pop    %ebx
  803449:	5e                   	pop    %esi
  80344a:	5f                   	pop    %edi
  80344b:	5d                   	pop    %ebp
  80344c:	c3                   	ret    
  80344d:	8d 76 00             	lea    0x0(%esi),%esi
  803450:	31 ff                	xor    %edi,%edi
  803452:	31 c0                	xor    %eax,%eax
  803454:	89 fa                	mov    %edi,%edx
  803456:	83 c4 1c             	add    $0x1c,%esp
  803459:	5b                   	pop    %ebx
  80345a:	5e                   	pop    %esi
  80345b:	5f                   	pop    %edi
  80345c:	5d                   	pop    %ebp
  80345d:	c3                   	ret    
  80345e:	66 90                	xchg   %ax,%ax
  803460:	89 d8                	mov    %ebx,%eax
  803462:	f7 f7                	div    %edi
  803464:	31 ff                	xor    %edi,%edi
  803466:	89 fa                	mov    %edi,%edx
  803468:	83 c4 1c             	add    $0x1c,%esp
  80346b:	5b                   	pop    %ebx
  80346c:	5e                   	pop    %esi
  80346d:	5f                   	pop    %edi
  80346e:	5d                   	pop    %ebp
  80346f:	c3                   	ret    
  803470:	bd 20 00 00 00       	mov    $0x20,%ebp
  803475:	89 eb                	mov    %ebp,%ebx
  803477:	29 fb                	sub    %edi,%ebx
  803479:	89 f9                	mov    %edi,%ecx
  80347b:	d3 e6                	shl    %cl,%esi
  80347d:	89 c5                	mov    %eax,%ebp
  80347f:	88 d9                	mov    %bl,%cl
  803481:	d3 ed                	shr    %cl,%ebp
  803483:	89 e9                	mov    %ebp,%ecx
  803485:	09 f1                	or     %esi,%ecx
  803487:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348b:	89 f9                	mov    %edi,%ecx
  80348d:	d3 e0                	shl    %cl,%eax
  80348f:	89 c5                	mov    %eax,%ebp
  803491:	89 d6                	mov    %edx,%esi
  803493:	88 d9                	mov    %bl,%cl
  803495:	d3 ee                	shr    %cl,%esi
  803497:	89 f9                	mov    %edi,%ecx
  803499:	d3 e2                	shl    %cl,%edx
  80349b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349f:	88 d9                	mov    %bl,%cl
  8034a1:	d3 e8                	shr    %cl,%eax
  8034a3:	09 c2                	or     %eax,%edx
  8034a5:	89 d0                	mov    %edx,%eax
  8034a7:	89 f2                	mov    %esi,%edx
  8034a9:	f7 74 24 0c          	divl   0xc(%esp)
  8034ad:	89 d6                	mov    %edx,%esi
  8034af:	89 c3                	mov    %eax,%ebx
  8034b1:	f7 e5                	mul    %ebp
  8034b3:	39 d6                	cmp    %edx,%esi
  8034b5:	72 19                	jb     8034d0 <__udivdi3+0xfc>
  8034b7:	74 0b                	je     8034c4 <__udivdi3+0xf0>
  8034b9:	89 d8                	mov    %ebx,%eax
  8034bb:	31 ff                	xor    %edi,%edi
  8034bd:	e9 58 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034c8:	89 f9                	mov    %edi,%ecx
  8034ca:	d3 e2                	shl    %cl,%edx
  8034cc:	39 c2                	cmp    %eax,%edx
  8034ce:	73 e9                	jae    8034b9 <__udivdi3+0xe5>
  8034d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d3:	31 ff                	xor    %edi,%edi
  8034d5:	e9 40 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034da:	66 90                	xchg   %ax,%ax
  8034dc:	31 c0                	xor    %eax,%eax
  8034de:	e9 37 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034e3:	90                   	nop

008034e4 <__umoddi3>:
  8034e4:	55                   	push   %ebp
  8034e5:	57                   	push   %edi
  8034e6:	56                   	push   %esi
  8034e7:	53                   	push   %ebx
  8034e8:	83 ec 1c             	sub    $0x1c,%esp
  8034eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803503:	89 f3                	mov    %esi,%ebx
  803505:	89 fa                	mov    %edi,%edx
  803507:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350b:	89 34 24             	mov    %esi,(%esp)
  80350e:	85 c0                	test   %eax,%eax
  803510:	75 1a                	jne    80352c <__umoddi3+0x48>
  803512:	39 f7                	cmp    %esi,%edi
  803514:	0f 86 a2 00 00 00    	jbe    8035bc <__umoddi3+0xd8>
  80351a:	89 c8                	mov    %ecx,%eax
  80351c:	89 f2                	mov    %esi,%edx
  80351e:	f7 f7                	div    %edi
  803520:	89 d0                	mov    %edx,%eax
  803522:	31 d2                	xor    %edx,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	39 f0                	cmp    %esi,%eax
  80352e:	0f 87 ac 00 00 00    	ja     8035e0 <__umoddi3+0xfc>
  803534:	0f bd e8             	bsr    %eax,%ebp
  803537:	83 f5 1f             	xor    $0x1f,%ebp
  80353a:	0f 84 ac 00 00 00    	je     8035ec <__umoddi3+0x108>
  803540:	bf 20 00 00 00       	mov    $0x20,%edi
  803545:	29 ef                	sub    %ebp,%edi
  803547:	89 fe                	mov    %edi,%esi
  803549:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80354d:	89 e9                	mov    %ebp,%ecx
  80354f:	d3 e0                	shl    %cl,%eax
  803551:	89 d7                	mov    %edx,%edi
  803553:	89 f1                	mov    %esi,%ecx
  803555:	d3 ef                	shr    %cl,%edi
  803557:	09 c7                	or     %eax,%edi
  803559:	89 e9                	mov    %ebp,%ecx
  80355b:	d3 e2                	shl    %cl,%edx
  80355d:	89 14 24             	mov    %edx,(%esp)
  803560:	89 d8                	mov    %ebx,%eax
  803562:	d3 e0                	shl    %cl,%eax
  803564:	89 c2                	mov    %eax,%edx
  803566:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356a:	d3 e0                	shl    %cl,%eax
  80356c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803570:	8b 44 24 08          	mov    0x8(%esp),%eax
  803574:	89 f1                	mov    %esi,%ecx
  803576:	d3 e8                	shr    %cl,%eax
  803578:	09 d0                	or     %edx,%eax
  80357a:	d3 eb                	shr    %cl,%ebx
  80357c:	89 da                	mov    %ebx,%edx
  80357e:	f7 f7                	div    %edi
  803580:	89 d3                	mov    %edx,%ebx
  803582:	f7 24 24             	mull   (%esp)
  803585:	89 c6                	mov    %eax,%esi
  803587:	89 d1                	mov    %edx,%ecx
  803589:	39 d3                	cmp    %edx,%ebx
  80358b:	0f 82 87 00 00 00    	jb     803618 <__umoddi3+0x134>
  803591:	0f 84 91 00 00 00    	je     803628 <__umoddi3+0x144>
  803597:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359b:	29 f2                	sub    %esi,%edx
  80359d:	19 cb                	sbb    %ecx,%ebx
  80359f:	89 d8                	mov    %ebx,%eax
  8035a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a5:	d3 e0                	shl    %cl,%eax
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	d3 ea                	shr    %cl,%edx
  8035ab:	09 d0                	or     %edx,%eax
  8035ad:	89 e9                	mov    %ebp,%ecx
  8035af:	d3 eb                	shr    %cl,%ebx
  8035b1:	89 da                	mov    %ebx,%edx
  8035b3:	83 c4 1c             	add    $0x1c,%esp
  8035b6:	5b                   	pop    %ebx
  8035b7:	5e                   	pop    %esi
  8035b8:	5f                   	pop    %edi
  8035b9:	5d                   	pop    %ebp
  8035ba:	c3                   	ret    
  8035bb:	90                   	nop
  8035bc:	89 fd                	mov    %edi,%ebp
  8035be:	85 ff                	test   %edi,%edi
  8035c0:	75 0b                	jne    8035cd <__umoddi3+0xe9>
  8035c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c7:	31 d2                	xor    %edx,%edx
  8035c9:	f7 f7                	div    %edi
  8035cb:	89 c5                	mov    %eax,%ebp
  8035cd:	89 f0                	mov    %esi,%eax
  8035cf:	31 d2                	xor    %edx,%edx
  8035d1:	f7 f5                	div    %ebp
  8035d3:	89 c8                	mov    %ecx,%eax
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 d0                	mov    %edx,%eax
  8035d9:	e9 44 ff ff ff       	jmp    803522 <__umoddi3+0x3e>
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	89 c8                	mov    %ecx,%eax
  8035e2:	89 f2                	mov    %esi,%edx
  8035e4:	83 c4 1c             	add    $0x1c,%esp
  8035e7:	5b                   	pop    %ebx
  8035e8:	5e                   	pop    %esi
  8035e9:	5f                   	pop    %edi
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    
  8035ec:	3b 04 24             	cmp    (%esp),%eax
  8035ef:	72 06                	jb     8035f7 <__umoddi3+0x113>
  8035f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f5:	77 0f                	ja     803606 <__umoddi3+0x122>
  8035f7:	89 f2                	mov    %esi,%edx
  8035f9:	29 f9                	sub    %edi,%ecx
  8035fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035ff:	89 14 24             	mov    %edx,(%esp)
  803602:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803606:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360a:	8b 14 24             	mov    (%esp),%edx
  80360d:	83 c4 1c             	add    $0x1c,%esp
  803610:	5b                   	pop    %ebx
  803611:	5e                   	pop    %esi
  803612:	5f                   	pop    %edi
  803613:	5d                   	pop    %ebp
  803614:	c3                   	ret    
  803615:	8d 76 00             	lea    0x0(%esi),%esi
  803618:	2b 04 24             	sub    (%esp),%eax
  80361b:	19 fa                	sbb    %edi,%edx
  80361d:	89 d1                	mov    %edx,%ecx
  80361f:	89 c6                	mov    %eax,%esi
  803621:	e9 71 ff ff ff       	jmp    803597 <__umoddi3+0xb3>
  803626:	66 90                	xchg   %ax,%ax
  803628:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80362c:	72 ea                	jb     803618 <__umoddi3+0x134>
  80362e:	89 d9                	mov    %ebx,%ecx
  803630:	e9 62 ff ff ff       	jmp    803597 <__umoddi3+0xb3>
